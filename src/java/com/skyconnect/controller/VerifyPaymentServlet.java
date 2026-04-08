package com.skyconnect.controller;

import com.skyconnect.service.EmailService;
import com.skyconnect.util.AppConfig;
import com.skyconnect.util.DBConnection;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Logger;

@WebServlet("/verifyPayment")
public class VerifyPaymentServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(VerifyPaymentServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // ── Auth check ────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");
        if (userId == null) {
            resp.setStatus(401);
            out.print("{\"success\":false,\"error\":\"Not logged in\"}");
            return;
        }

        // ── Read params ───────────────────────────────────────────
        String razorpayOrderId   = req.getParameter("razorpay_order_id");
        String razorpayPaymentId = req.getParameter("razorpay_payment_id");
        String razorpaySignature = req.getParameter("razorpay_signature");
        String bookingIdParam    = req.getParameter("bookingId");

        if (razorpayOrderId == null || razorpayPaymentId == null
                || razorpaySignature == null || bookingIdParam == null) {
            resp.setStatus(400);
            out.print("{\"success\":false,\"error\":\"Missing payment parameters\"}");
            return;
        }

        int bookingId;
        try { bookingId = Integer.parseInt(bookingIdParam); }
        catch (NumberFormatException e) {
            resp.setStatus(400);
            out.print("{\"success\":false,\"error\":\"Invalid bookingId\"}");
            return;
        }

        try {
            // ── Verify HMAC-SHA256 signature ───────────────────────
            AppConfig cfg = AppConfig.get();
            String secret  = cfg.getRazorpayKeySecret();
            String payload = razorpayOrderId + "|" + razorpayPaymentId;

            String expectedSignature = hmacSha256(payload, secret);

            if (!expectedSignature.equals(razorpaySignature)) {
                LOG.warning("Signature mismatch for booking #" + bookingId
                        + " | expected=" + expectedSignature
                        + " | got=" + razorpaySignature);
                resp.setStatus(400);
                out.print("{\"success\":false,\"error\":\"Payment verification failed — signature mismatch\"}");
                return;
            }

            // ── Signature valid — update DB ────────────────────────
            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                // Fetch booking details for email + validation
                String fetch =
                    "SELECT b.total_amount, b.payment_status, b.num_seats, " +
                    "u.email AS user_email, u.name AS user_name, " +
                    "f.flight_no, f.source, f.destination, " +
                    "DATE_FORMAT(f.depart_date,'%d %b %Y') AS depart_date, " +
                    "TIME_FORMAT(f.depart_time,'%H:%i') AS depart_time " +
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
                    resp.setStatus(404);
                    out.print("{\"success\":false,\"error\":\"Booking not found\"}");
                    return;
                }

                // Idempotent — if already paid, just redirect to invoice
                if ("PAID".equals(rs.getString("payment_status"))) {
                    con.rollback();
                    out.print("{\"success\":true,\"redirect\":\""
                        + req.getContextPath() + "/invoice?bookingId=" + bookingId + "\"}");
                    return;
                }

                double baseAmount  = rs.getDouble("total_amount");
                double gst         = baseAmount * 0.05;
                double finalAmount = baseAmount + gst;
                String userEmail   = rs.getString("user_email");
                String userName    = rs.getString("user_name");
                String flightNo    = rs.getString("flight_no");
                String source      = rs.getString("source");
                String destination = rs.getString("destination");
                String departDate  = rs.getString("depart_date");
                String departTime  = rs.getString("depart_time");
                int    numSeats    = rs.getInt("num_seats");

                // Insert payment record with Razorpay IDs
                PreparedStatement ins = con.prepareStatement(
                    "INSERT INTO payments (booking_id, amount, payment_method, " +
                    "razorpay_order_id, razorpay_payment_id, razorpay_signature, payment_status) " +
                    "VALUES (?, ?, 'RAZORPAY', ?, ?, ?, 'SUCCESS')");
                ins.setInt(1, bookingId);
                ins.setDouble(2, finalAmount);
                ins.setString(3, razorpayOrderId);
                ins.setString(4, razorpayPaymentId);
                ins.setString(5, razorpaySignature);
                ins.executeUpdate();

                // Update booking status
                PreparedStatement upd = con.prepareStatement(
                    "UPDATE bookings SET payment_status='PAID', status='BOOKED', " +
                    "total_amount=? WHERE id=?");
                upd.setDouble(1, finalAmount);
                upd.setInt(2, bookingId);
                upd.executeUpdate();

                con.commit();
                LOG.info("Payment VERIFIED for booking #" + bookingId
                        + " | razorpay_payment_id=" + razorpayPaymentId);

                // Send booking confirmation email (async)
                if (userEmail != null && !userEmail.isEmpty()) {
                    EmailService.sendBookingConfirmation(
                        userEmail, userName,
                        String.valueOf(bookingId), flightNo,
                        source, destination,
                        departDate, departTime,
                        numSeats, finalAmount
                    );
                }

                out.print("{\"success\":true,\"redirect\":\""
                    + req.getContextPath() + "/invoice?bookingId=" + bookingId + "\"}");
            }

        } catch (Exception e) {
            LOG.severe("VerifyPaymentServlet error: " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(500);
            out.print("{\"success\":false,\"error\":\"Server error during verification\"}");
        }
    }

    /**
     * Computes HMAC-SHA256 of the given data using the secret key,
     * and returns the result as a lowercase hex string.
     */
    private static String hmacSha256(String data, String secret) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec keySpec = new SecretKeySpec(secret.getBytes("UTF-8"), "HmacSHA256");
        mac.init(keySpec);
        byte[] bytes = mac.doFinal(data.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
