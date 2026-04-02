package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/userRefundHistory")
public class UserRefundHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // User must be logged in
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        List<Map<String, Object>> refunds = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT r.id, r.refund_amount, r.refund_status, r.refund_reason, " +
                "r.requested_at, r.approved_at, " +
                "f.flight_no " +
                "FROM refunds r " +
                "JOIN bookings b ON r.booking_id = b.id " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE r.user_id = ? " +
                "ORDER BY r.requested_at DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("flight", rs.getString("flight_no"));
                row.put("amount", rs.getDouble("refund_amount"));
                row.put("status", rs.getString("refund_status"));
                row.put("reason", rs.getString("refund_reason"));
                row.put("requestedAt", rs.getTimestamp("requested_at"));
                row.put("approvedAt", rs.getTimestamp("approved_at"));
                refunds.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("refunds", refunds);
        req.getRequestDispatcher("refund_history.jsp").forward(req, resp);
    }
}