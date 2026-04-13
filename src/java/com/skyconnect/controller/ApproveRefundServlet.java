package com.skyconnect.controller;

import com.skyconnect.service.EmailService;
import com.skyconnect.util.CsrfUtil;
import com.skyconnect.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;

/**
 * AeroSphere — ApproveRefundServlet (UPDATED)
 *
 * Changes vs original:
 *  1. Sends refund approved/rejected email notification (async)
 *  2. Loads user email/name to send the notification
 *  3. All original DB logic is preserved exactly
 *
 * URL: /approveRefund (POST — unchanged)
 */
@WebServlet("/approveRefund")
public class ApproveRefundServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(ApproveRefundServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        if (!CsrfUtil.isValid(req)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF validation failed.");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int refundId;
        try { refundId = Integer.parseInt(req.getParameter("refundId")); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/adminRefunds");
            return;
        }

        String action = req.getParameter("action"); // "APPROVE" or "REJECT"
        boolean approving = "APPROVE".equals(action);

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // Lock refund row + load data needed for email
            String fetch =
                "SELECT r.booking_id, r.refund_amount, r.refund_status, " +
                "u.email AS user_email, u.name AS user_name " +
                "FROM refunds r " +
                "JOIN users u ON r.user_id = u.id " +
                "WHERE r.id = ? FOR UPDATE";

            PreparedStatement ps = con.prepareStatement(fetch);
            ps.setInt(1, refundId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/adminRefunds");
                return;
            }

            int    bookingId   = rs.getInt("booking_id");
            double refundAmt   = rs.getDouble("refund_amount");
            String userEmail   = rs.getString("user_email");
            String userName    = rs.getString("user_name");
            String currentStatus = rs.getString("refund_status");

            // Prevent double-processing
            if (!"PENDING".equals(currentStatus)) {
                con.rollback();
                resp.sendRedirect(req.getContextPath() + "/adminRefunds");
                return;
            }

            if (approving) {
                // Approve refund
                ps = con.prepareStatement(
                    "UPDATE refunds SET refund_status='APPROVED', approved_at=NOW() WHERE id=?");
                ps.setInt(1, refundId);
                ps.executeUpdate();

                // Update booking payment status to REFUNDED
                ps = con.prepareStatement(
                    "UPDATE bookings SET payment_status='REFUNDED' WHERE id=?");
                ps.setInt(1, bookingId);
                ps.executeUpdate();

            } else {
                // Reject refund
                ps = con.prepareStatement(
                    "UPDATE refunds SET refund_status='REJECTED', approved_at=NOW() WHERE id=?");
                ps.setInt(1, refundId);
                ps.executeUpdate();
            }

            con.commit();

            LOG.info("Refund #" + refundId + " " + (approving ? "APPROVED" : "REJECTED") +
                     " for booking #" + bookingId);

            // Send notification email (async)
            if (userEmail != null && !userEmail.isEmpty()) {
                EmailService.sendRefundUpdate(
                    userEmail, userName,
                    String.valueOf(bookingId),
                    refundAmt, approving
                );
            }

        } catch (Exception e) {
            LOG.severe("ApproveRefundServlet error: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/adminRefunds");
    }
}
