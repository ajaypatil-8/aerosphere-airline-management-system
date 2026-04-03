
package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
@WebServlet("/approveRefund")
public class ApproveRefundServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int refundId = Integer.parseInt(req.getParameter("refundId"));
        String action = req.getParameter("action"); // APPROVE / REJECT

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // Lock refund
            String fetch =
                "SELECT booking_id FROM refunds WHERE id=? FOR UPDATE";
            PreparedStatement ps = con.prepareStatement(fetch);
            ps.setInt(1, refundId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                con.rollback();
                resp.sendRedirect("adminRefunds");
                return;
            }

            int bookingId = rs.getInt("booking_id");

            if ("APPROVE".equals(action)) {

                // Update refund
                ps = con.prepareStatement(
                    "UPDATE refunds SET refund_status='APPROVED', approved_at=NOW() WHERE id=?");
                ps.setInt(1, refundId);
                ps.executeUpdate();

                // Update booking payment status
                ps = con.prepareStatement(
                    "UPDATE bookings SET payment_status='REFUNDED' WHERE id=?");
                ps.setInt(1, bookingId);
                ps.executeUpdate();

            } else {

                ps = con.prepareStatement(
                    "UPDATE refunds SET refund_status='REJECTED', approved_at=NOW() WHERE id=?");
                ps.setInt(1, refundId);
                ps.executeUpdate();
            }

            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("adminRefunds");
    }
}