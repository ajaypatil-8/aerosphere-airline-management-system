package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportBookings")
public class ReportBookingsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 50;

    public static class BookingRow {
        public int id;
        public String userName;
        public String flightNo;
        public String source;
        public String destination;
        public int seats;
        public double amount;
        public String status;
        public String paymentStatus;
        public Timestamp bookingDate;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String status  = req.getParameter("status");
        String payment = req.getParameter("payment");
        String date    = req.getParameter("date");
        String dateFrom = req.getParameter("dateFrom");
        String dateTo   = req.getParameter("dateTo");

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<BookingRow> list = new ArrayList<>();
        int totalCount = 0;

        StringBuilder where = new StringBuilder(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            where.append(" AND b.status=? ");
            params.add(status);
        }
        if (payment != null && !payment.isEmpty()) {
            where.append(" AND b.payment_status=? ");
            params.add(payment);
        }
        if (date != null && !date.isEmpty()) {
            where.append(" AND DATE(b.booking_date)=? ");
            params.add(Date.valueOf(date));
        } else {
            if (dateFrom != null && !dateFrom.isEmpty()) {
                where.append(" AND DATE(b.booking_date) >= ? ");
                params.add(Date.valueOf(dateFrom));
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                where.append(" AND DATE(b.booking_date) <= ? ");
                params.add(Date.valueOf(dateTo));
            }
        }

        String baseFrom =
            "FROM bookings b " +
            "JOIN users u ON b.user_id=u.id " +
            "JOIN flights f ON b.flight_id=f.id";

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
                "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, b.booking_date, " +
                "u.name AS user_name, f.flight_no, f.source, f.destination " +
                baseFrom + where +
                " ORDER BY b.booking_date DESC LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                for (Object param : params) ps.setObject(idx++, param);
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        BookingRow b = new BookingRow();
                        b.id            = rs.getInt("id");
                        b.userName      = rs.getString("user_name");
                        b.flightNo      = rs.getString("flight_no");
                        b.source        = rs.getString("source");
                        b.destination   = rs.getString("destination");
                        b.seats         = rs.getInt("num_seats");
                        b.amount        = rs.getDouble("total_amount");
                        b.status        = rs.getString("status");
                        b.paymentStatus = rs.getString("payment_status");
                        b.bookingDate   = rs.getTimestamp("booking_date");
                        list.add(b);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("bookings",    list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("status",      status);
        req.setAttribute("payment",     payment);
        req.setAttribute("date",        date);
        req.setAttribute("dateFrom",    dateFrom);
        req.setAttribute("dateTo",      dateTo);
        req.getRequestDispatcher("/Views/admin/bookings_report.jsp").forward(req, resp);
    }
}
