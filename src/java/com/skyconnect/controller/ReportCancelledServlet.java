package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportCancelled")
public class ReportCancelledServlet extends HttpServlet {

    private static final int PAGE_SIZE = 50;

    public static class CancelledRow {
        public int bookingId;
        public String userName;
        public String flightNo;
        public String route;
        public Timestamp bookingDate;
        public int seats;
        public double amount;
        public String paymentStatus;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String dateFrom = req.getParameter("dateFrom");
        String dateTo   = req.getParameter("dateTo");

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<CancelledRow> cancelled = new ArrayList<>();
        int totalCount = 0;

        StringBuilder where = new StringBuilder(" WHERE b.status = 'CANCELLED'");
        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.isEmpty()) {
            where.append(" AND DATE(b.booking_date) >= ?");
            params.add(Date.valueOf(dateFrom));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            where.append(" AND DATE(b.booking_date) <= ?");
            params.add(Date.valueOf(dateTo));
        }

        String baseFrom =
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN flights f ON b.flight_id = f.id";

        try (Connection con = DBConnection.getConnection()) {

            // Count
            String countSql = "SELECT COUNT(*) " + baseFrom + where;
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Paginated data
            String sql =
                "SELECT b.id AS booking_id, u.name AS user_name, f.flight_no, " +
                "CONCAT(f.source,' → ',f.destination) AS route, " +
                "b.booking_date, b.num_seats, b.total_amount, b.payment_status " +
                baseFrom + where +
                " ORDER BY b.booking_date DESC LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                for (Object param : params) ps.setObject(idx++, param);
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        CancelledRow c = new CancelledRow();
                        c.bookingId     = rs.getInt("booking_id");
                        c.userName      = rs.getString("user_name");
                        c.flightNo      = rs.getString("flight_no");
                        c.route         = rs.getString("route");
                        c.bookingDate   = rs.getTimestamp("booking_date");
                        c.seats         = rs.getInt("num_seats");
                        c.amount        = rs.getDouble("total_amount");
                        c.paymentStatus = rs.getString("payment_status");
                        cancelled.add(c);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("cancelled",   cancelled);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("dateFrom",    dateFrom);
        req.setAttribute("dateTo",      dateTo);
        req.getRequestDispatcher("/Views/admin/cancelled_report.jsp").forward(req, resp);
    }
}
