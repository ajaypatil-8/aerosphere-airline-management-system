package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportPayments")
public class ReportPaymentsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 50;

    public static class PaymentRow {
        public int paymentId;
        public int bookingId;
        public String userName;
        public String flightNo;
        public String route;
        public Timestamp paymentDate;
        public String paymentMethod;
        public double amount;
        public String paymentStatus;
        public String bookingStatus;
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
        String method   = req.getParameter("method");

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<PaymentRow> payments = new ArrayList<>();
        int totalCount = 0;

        StringBuilder where = new StringBuilder(" WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.isEmpty()) {
            where.append(" AND DATE(p.payment_date) >= ?");
            params.add(Date.valueOf(dateFrom));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            where.append(" AND DATE(p.payment_date) <= ?");
            params.add(Date.valueOf(dateTo));
        }
        if (method != null && !method.isEmpty()) {
            where.append(" AND p.payment_method = ?");
            params.add(method);
        }

        String baseFrom =
            "FROM payments p " +
            "JOIN bookings b ON p.booking_id = b.id " +
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
                "SELECT p.id AS payment_id, b.id AS booking_id, u.name AS user_name, " +
                "f.flight_no, CONCAT(f.source,' → ',f.destination) AS route, " +
                "p.payment_date, p.payment_method, p.amount, " +
                "p.payment_status, b.status AS booking_status " +
                baseFrom + where +
                " ORDER BY p.payment_date DESC LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                for (Object param : params) ps.setObject(idx++, param);
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        PaymentRow p = new PaymentRow();
                        p.paymentId     = rs.getInt("payment_id");
                        p.bookingId     = rs.getInt("booking_id");
                        p.userName      = rs.getString("user_name");
                        p.flightNo      = rs.getString("flight_no");
                        p.route         = rs.getString("route");
                        p.paymentDate   = rs.getTimestamp("payment_date");
                        p.paymentMethod = rs.getString("payment_method");
                        p.amount        = rs.getDouble("amount");
                        p.paymentStatus = rs.getString("payment_status");
                        p.bookingStatus = rs.getString("booking_status");
                        payments.add(p);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("payments",    payments);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("dateFrom",    dateFrom);
        req.setAttribute("dateTo",      dateTo);
        req.setAttribute("method",      method);
        req.getRequestDispatcher("/Views/admin/payments_report.jsp").forward(req, resp);
    }
}
