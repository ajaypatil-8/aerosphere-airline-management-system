package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@WebServlet("/cancelBooking")
public class CancelBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            int flightId, seats;
            double totalAmount;
            String status, paymentStatus;
            Date departDate;
            Time departTime;

            // 🔒 Lock booking + ownership validation
            String bookingSql =
                "SELECT b.flight_id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                "f.depart_date, f.depart_time " +
                "FROM bookings b " +
                "JOIN flights f ON b.flight_id = f.id " +
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

            flightId = rs.getInt("flight_id");
            seats = rs.getInt("num_seats");
            totalAmount = rs.getDouble("total_amount");
            status = rs.getString("status");
            paymentStatus = rs.getString("payment_status");
            departDate = rs.getDate("depart_date");
            departTime = rs.getTime("depart_time");

            if ("CANCELLED".equals(status)) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            // ⏱️ Time check
            LocalDateTime flightDateTime =
                LocalDateTime.of(departDate.toLocalDate(), departTime.toLocalTime());

            long hoursLeft =
                ChronoUnit.HOURS.between(LocalDateTime.now(), flightDateTime);

            if (hoursLeft <= 0) {
                con.rollback();
                session.setAttribute("cancelError", "Flight already departed");
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            // ♻ Restore seats
            ps = con.prepareStatement(
                "UPDATE flights SET seats_available = seats_available + ? WHERE id=?");
            ps.setInt(1, seats);
            ps.setInt(2, flightId);
            ps.executeUpdate();

            // 💸 Insert refund request (FIXED)
            if ("PAID".equals(paymentStatus) && hoursLeft >= 24) {

                String checkRefund =
                    "SELECT id FROM refunds WHERE booking_id=?";
                ps = con.prepareStatement(checkRefund);
                ps.setInt(1, bookingId);
                ResultSet rrs = ps.executeQuery();

                if (!rrs.next()) {

                    // ✅ FIX: user_id added
                    ps = con.prepareStatement(
                        "INSERT INTO refunds (booking_id, user_id, refund_amount, refund_reason) " +
                        "VALUES (?, ?, ?, ?)");
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId); // ⭐ REQUIRED
                    ps.setDouble(3, totalAmount);
                    ps.setString(4, "Cancelled before 24 hours of departure");
                    ps.executeUpdate();
                }
            }

            // 🧾 Cancel booking
            ps = con.prepareStatement(
                "UPDATE bookings SET status='CANCELLED', cancelled_at=NOW() WHERE id=?");
            ps.setInt(1, bookingId);
            ps.executeUpdate();

            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/userBookings");
    }
}