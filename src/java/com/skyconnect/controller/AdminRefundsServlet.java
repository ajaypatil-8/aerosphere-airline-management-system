package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/adminRefunds")
public class AdminRefundsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        // FIX: was checking session.getAttribute("role") — should be "userRole"
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "//Views/auth/login.jsp");
            return;
        }

        List<Map<String, Object>> refunds = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            // FIX: was referencing r.requested_at which does not exist — use r.approved_at
            String sql =
                "SELECT r.id, r.booking_id, r.refund_amount, r.refund_status, " +
                "r.refund_reason, r.approved_at, " +
                "u.name AS user_name, f.flight_no " +
                "FROM refunds r " +
                "JOIN bookings b ON r.booking_id = b.id " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN flights f ON b.flight_id = f.id " +
                "ORDER BY r.id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id",         rs.getInt("id"));
                row.put("bookingId",  rs.getInt("booking_id"));
                row.put("amount",     rs.getDouble("refund_amount"));
                row.put("status",     rs.getString("refund_status"));
                row.put("reason",     rs.getString("refund_reason"));
                row.put("user",       rs.getString("user_name"));
                row.put("flight",     rs.getString("flight_no"));
                row.put("approvedAt", rs.getTimestamp("approved_at"));
                refunds.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading refunds: " + e.getMessage());
        }

        req.setAttribute("refunds", refunds);
        req.getRequestDispatcher("admin_refunds.jsp").forward(req, resp);
    }
}