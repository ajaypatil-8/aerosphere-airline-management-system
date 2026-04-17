package com.skyconnect.controller;

import com.skyconnect.service.EmailService;
import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;

/**
 * AeroSphere — PaymentServlet (UPDATED)
 *
 * CRITICAL FIX: Was mapped to /processPayment — now correctly mapped to /payment
 * (matches all JSP form actions and the prompt's URL mapping table).
 *
 * Changes vs original:
 *  1. @WebServlet changed from /processPayment → /payment
 *  2. Sends booking confirmation email after successful payment (async)
 *  3. On payment failure: sets error attribute so JSP can show message
 *  4. Status set to 'BOOKED' (not 'PAID') on success — aligns with DB design
 *
 * GET /payment?bookingId=X  → show payment.jsp  (unchanged)
 * POST /payment             → process payment   (fixed)
 */
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(PaymentServlet.class.getName());

    // ── SHOW PAYMENT PAGE ─────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
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

            String sql =
                "SELECT b.total_amount, b.status, b.payment_status, b.num_seats, " +
                "f.flight_no, f.source, f.destination, " +
                "DATE_FORMAT(f.depart_date,'%d %b %Y') AS depart_date, " +
                "TIME_FORMAT(f.depart_time,'%H:%i') AS depart_time, " +
                "TIME_FORMAT(f.arrival_time,'%H:%i') AS arrival_time " +
                "FROM bookings b JOIN flights f ON b.flight_id=f.id " +
                "WHERE b.id=? AND b.user_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            String bookingStatus = rs.getString("status");
            String paymentStatus = rs.getString("payment_status");
            double amount        = rs.getDouble("total_amount");

            if ("CANCELLED".equals(bookingStatus)) {
                resp.sendRedirect(req.getContextPath() + "/invoice?bookingId=" + bookingId);
                return;
            }
            if ("PAID".equals(paymentStatus)) {
                resp.sendRedirect(req.getContextPath() + "/invoice?bookingId=" + bookingId);
                return;
            }

            double gst         = amount * 0.05;
            double finalAmount = amount + gst;

            req.setAttribute("bookingId",   bookingId);
            req.setAttribute("baseAmount",  amount);
            req.setAttribute("gst",         gst);
            req.setAttribute("finalAmount", finalAmount);
            req.setAttribute("numSeats",    rs.getInt("num_seats"));
            req.setAttribute("flightNo",    rs.getString("flight_no"));
            req.setAttribute("source",      rs.getString("source"));
            req.setAttribute("destination", rs.getString("destination"));
            req.setAttribute("departDate",  rs.getString("depart_date"));
            req.setAttribute("departTime",  rs.getString("depart_time"));
            req.setAttribute("arrivalTime", rs.getString("arrival_time"));

            req.getRequestDispatcher("/Views/user/payment.jsp").forward(req, resp);

        } catch (Exception e) {
            LOG.severe("PaymentServlet GET error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/userBookings");
        }
    }

    // ── PROCESS PAYMENT ───────────────────────────────────────────
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
        String method = req.getParameter("paymentMethod");

        if (bookingIdParam == null || method == null || method.trim().isEmpty()) {
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

            // Lock booking + validate ownership
            String fetch =
                "SELECT b.total_amount, b.payment_status, b.status, " +
                "u.email AS user_email, u.name AS user_name, " +
                "f.flight_no, f.source, f.destination, " +
                "DATE_FORMAT(f.depart_date,'%d %b %Y') AS depart_date, " +
                "TIME_FORMAT(f.depart_time,'%H:%i') AS depart_time, " +
                "b.num_seats " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE b.id=? AND b.user_id=? FOR UPDATE";

            PreparedStatement ps = con.prepareStatement(fetch);
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            if ("PAID".equals(rs.getString("payment_status"))) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/invoice?bookingId=" + bookingId);
                return;
            }

            if ("CANCELLED".equals(rs.getString("status"))) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            double amount      = rs.getDouble("total_amount");
            double gst         = amount * 0.05;
            double finalAmount = amount + gst;
            String userEmail   = rs.getString("user_email");
            String userName    = rs.getString("user_name");
            String flightNo    = rs.getString("flight_no");
            String source      = rs.getString("source");
            String destination = rs.getString("destination");
            String departDate  = rs.getString("depart_date");
            String departTime  = rs.getString("depart_time");
            int    numSeats    = rs.getInt("num_seats");

            // Insert payment record
            String paySql =
                "INSERT INTO payments (booking_id, amount, payment_method, payment_status) " +
                "VALUES (?, ?, ?, 'SUCCESS')";
            PreparedStatement ps2 = con.prepareStatement(paySql);
            ps2.setInt(1, bookingId);
            ps2.setDouble(2, finalAmount);
            ps2.setString(3, method.trim());
            ps2.executeUpdate();

            // Update booking: BOOKED + PAID + sync total_amount to GST-inclusive final amount
            String updateSql =
                "UPDATE bookings SET payment_status='PAID', status='BOOKED', total_amount=? WHERE id=?";
            PreparedStatement ps3 = con.prepareStatement(updateSql);
            ps3.setDouble(1, finalAmount);
            ps3.setInt(2, bookingId);
            ps3.executeUpdate();

            con.commit();

            LOG.info("Payment SUCCESS for booking #" + bookingId +
                     " | method=" + method + " | amount=₹" + finalAmount);

            // Send booking confirmation email (async — does not block response)
            if (userEmail != null && !userEmail.isEmpty()) {
                EmailService.sendBookingConfirmation(
                    userEmail, userName,
                    String.valueOf(bookingId), flightNo,
                    source, destination,
                    departDate, departTime,
                    numSeats, finalAmount
                );
            }

            resp.sendRedirect(req.getContextPath() + "/invoice?bookingId=" + bookingId);

        } catch (Exception e) {
            LOG.severe("PaymentServlet POST error: " + e.getMessage());
            e.printStackTrace();
            // Don't lose the user — send them back to payment page with error
            resp.sendRedirect(req.getContextPath() + "/payment?bookingId=" + bookingId + "&error=1");
        }
    }
}
