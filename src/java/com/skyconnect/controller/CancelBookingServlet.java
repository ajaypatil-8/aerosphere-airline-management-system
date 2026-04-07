package com.skyconnect.controller;

import com.skyconnect.service.EmailService;
import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.logging.Logger;

/**
 * AeroSphere — CancelBookingServlet (UPDATED)
 *
 * Changes vs original:
 *  1. Cancellation blocked within 2 hours of departure (was: only blocked after departure)
 *  2. Tiered refund: 100% if >24h before, 50% if 2–24h before
 *  3. Sends cancellation email notification (async, non-blocking)
 *  4. Improved error messages surfaced to user via session attribute
 *
 * URL: /cancelBooking  (POST only — unchanged)
 * All existing DB operations and session checks are preserved.
 */
@WebServlet("/cancelBooking")
public class CancelBookingServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(CancelBookingServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = req.getParameter("bookingId");
        if (bookingIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/userBookings");
            return;
        }

        int bookingId;
        try { bookingId = Integer.parseInt(bookingIdParam); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/userBookings");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // ── 1. Lock booking row + validate ownership ──────────
            String bookingSql =
                "SELECT b.flight_id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                "f.depart_date, f.depart_time, f.source, f.destination, f.flight_no, " +
                "u.email AS user_email, u.name AS user_name " +
                "FROM bookings b " +
                "JOIN flights f ON b.flight_id = f.id " +
                "JOIN users u ON b.user_id = u.id " +
                "WHERE b.id = ? AND b.user_id = ? FOR UPDATE";

            PreparedStatement ps = con.prepareStatement(bookingSql);
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            int    flightId      = rs.getInt("flight_id");
            int    seats         = rs.getInt("num_seats");
            double totalAmount   = rs.getDouble("total_amount");
            String status        = rs.getString("status");
            String paymentStatus = rs.getString("payment_status");
            Date   departDate    = rs.getDate("depart_date");
            Time   departTime    = rs.getTime("depart_time");
            String source        = rs.getString("source");
            String destination   = rs.getString("destination");
            String flightNo      = rs.getString("flight_no");
            String userEmail     = rs.getString("user_email");
            String userName      = rs.getString("user_name");

            // ── 2. Already cancelled? ─────────────────────────────
            if ("CANCELLED".equals(status)) {
                con.rollback();
                session.setAttribute("cancelError", "This booking is already cancelled.");
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            // ── 3. Time check ─────────────────────────────────────
            LocalDateTime flightDateTime =
                LocalDateTime.of(departDate.toLocalDate(), departTime.toLocalTime());
            long hoursLeft = ChronoUnit.HOURS.between(LocalDateTime.now(), flightDateTime);

            // Block if already departed
            if (hoursLeft <= 0) {
                con.rollback();
                session.setAttribute("cancelError", "Cannot cancel — flight has already departed.");
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            // ── UPDATED: Block if within 2 hours of departure ─────
            if (hoursLeft <= 2) {
                con.rollback();
                session.setAttribute("cancelError",
                    "Cannot cancel — cancellation is only allowed more than 2 hours before departure.");
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            // ── 4. Restore seats ──────────────────────────────────
            ps = con.prepareStatement(
                "UPDATE flights SET seats_available = seats_available + ? WHERE id = ?");
            ps.setInt(1, seats);
            ps.setInt(2, flightId);
            ps.executeUpdate();

            // ── 5. Tiered refund calculation ──────────────────────
            // UPDATED: 100% refund if >24h, 50% refund if 2–24h before departure
            double refundAmount = 0;
            String refundPolicy = "No refund";

            if ("PAID".equals(paymentStatus)) {
                if (hoursLeft >= 24) {
                    refundAmount = totalAmount;          // 100%
                    refundPolicy = "100% refund (cancelled >24h before departure)";
                } else {
                    refundAmount = totalAmount * 0.50;   // 50%
                    refundPolicy = "50% refund (cancelled 2–24h before departure)";
                }

                // Check if refund already exists (idempotency)
                ps = con.prepareStatement("SELECT id FROM refunds WHERE booking_id = ?");
                ps.setInt(1, bookingId);
                ResultSet rrs = ps.executeQuery();

                if (!rrs.next()) {
                    ps = con.prepareStatement(
                        "INSERT INTO refunds (booking_id, user_id, refund_amount, refund_reason) " +
                        "VALUES (?, ?, ?, ?)");
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);
                    ps.setDouble(3, refundAmount);
                    ps.setString(4, refundPolicy);
                    ps.executeUpdate();
                }
            }

            // ── 6. Mark booking cancelled ─────────────────────────
            ps = con.prepareStatement(
                "UPDATE bookings SET status='CANCELLED', cancelled_at=NOW() WHERE id = ?");
            ps.setInt(1, bookingId);
            ps.executeUpdate();

            con.commit();

            LOG.info("Booking #" + bookingId + " cancelled by user #" + userId +
                     " | hoursLeft=" + hoursLeft + " | refund=₹" + refundAmount);

            // ── 7. Send cancellation email (async, won't block) ───
            if (userEmail != null && !userEmail.isEmpty()) {
                EmailService.sendCancellationNotice(
                    userEmail, userName,
                    String.valueOf(bookingId), flightNo,
                    source, destination,
                    departDate.toString(),
                    refundAmount, refundPolicy
                );
            }

            session.setAttribute("cancelSuccess",
                "Booking #" + bookingId + " cancelled successfully." +
                (refundAmount > 0 ? " Refund of ₹" + String.format("%,.2f", refundAmount) + " will be processed." : "")
            );

        } catch (Exception e) {
            LOG.severe("CancelBookingServlet error: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("cancelError", "An error occurred. Please try again.");
        }

        resp.sendRedirect(req.getContextPath() + "/userBookings");
    }
}
