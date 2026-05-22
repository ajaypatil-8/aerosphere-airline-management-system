package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/userRefundHistory")
public class UserRefundHistoryServlet extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<Map<String, Object>> refunds = new ArrayList<>();
        int totalCount = 0;

        try (Connection con = DBConnection.getConnection()) {

            // Count
            String countSql =
                "SELECT COUNT(*) FROM refunds r " +
                "JOIN bookings b ON r.booking_id = b.id " +
                "WHERE r.user_id = ?";
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Paginated data
            String sql =
                "SELECT r.id, r.refund_amount, r.refund_status, r.refund_reason, " +
                "r.approved_at, f.flight_no, f.source, f.destination " +
                "FROM refunds r " +
                "JOIN bookings b ON r.booking_id = b.id " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE r.user_id = ? " +
                "ORDER BY r.id DESC " +
                "LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, PAGE_SIZE);
                ps.setInt(3, offset);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        row.put("id",          rs.getInt("id"));
                        row.put("flight",      rs.getString("flight_no"));
                        row.put("source",      rs.getString("source"));
                        row.put("destination", rs.getString("destination"));
                        row.put("amount",      rs.getDouble("refund_amount"));
                        row.put("status",      rs.getString("refund_status"));
                        row.put("reason",      rs.getString("refund_reason"));
                        row.put("approvedAt",  rs.getTimestamp("approved_at"));
                        refunds.add(row);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading refunds: " + e.getMessage());
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("refunds",     refunds);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.getRequestDispatcher("/Views/user/refund_history.jsp").forward(req, resp);
    }
}
