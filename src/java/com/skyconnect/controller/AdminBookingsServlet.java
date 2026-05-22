package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminBookings")
public class AdminBookingsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 25;

    public static class BookingRow {
        public int id;
        public String flightNo;
        public String userName;
        public int seats;
        public double amount;
        public String status;
        public Timestamp bookedOn;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Parse page, search, status filter
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        String search = req.getParameter("search");
        if (search == null) search = "";
        search = search.trim();

        String statusFilter = req.getParameter("status");
        if (statusFilter == null) statusFilter = "";
        statusFilter = statusFilter.trim();

        int offset = (page - 1) * PAGE_SIZE;

        List<BookingRow> rows = new ArrayList<>();
        int totalBookings = 0;

        // Build dynamic WHERE
        StringBuilder where = new StringBuilder(" WHERE 1=1");
        if (!search.isEmpty())       where.append(" AND (f.flight_no LIKE ? OR u.name LIKE ?)");
        if (!statusFilter.isEmpty()) where.append(" AND b.status = ?");

        String baseFrom = " FROM bookings b " +
                          "JOIN flights f ON b.flight_id = f.id " +
                          "JOIN users u ON b.user_id = u.id";

        try (Connection con = DBConnection.getConnection()) {

            // Count
            String countSql = "SELECT COUNT(*)" + baseFrom + where;
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                int idx = 1;
                if (!search.isEmpty()) {
                    String like = "%" + search + "%";
                    ps.setString(idx++, like); ps.setString(idx++, like);
                }
                if (!statusFilter.isEmpty()) ps.setString(idx, statusFilter);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalBookings = rs.getInt(1);
                }
            }

            // Data
            String sql = "SELECT b.id, f.flight_no, u.name AS user_name, b.num_seats, " +
                         "b.total_amount, b.status, b.booking_date" +
                         baseFrom + where +
                         " ORDER BY b.booking_date DESC LIMIT ? OFFSET ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                if (!search.isEmpty()) {
                    String like = "%" + search + "%";
                    ps.setString(idx++, like); ps.setString(idx++, like);
                }
                if (!statusFilter.isEmpty()) ps.setString(idx++, statusFilter);
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        BookingRow r = new BookingRow();
                        r.id       = rs.getInt("id");
                        r.flightNo = rs.getString("flight_no");
                        r.userName = rs.getString("user_name");
                        r.seats    = rs.getInt("num_seats");
                        r.amount   = rs.getDouble("total_amount");
                        r.status   = rs.getString("status");
                        r.bookedOn = rs.getTimestamp("booking_date");
                        rows.add(r);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading bookings: " + e.getMessage());
        }

        int totalPages = (int) Math.ceil((double) totalBookings / PAGE_SIZE);

        req.setAttribute("bookings",      rows);
        req.setAttribute("currentPage",   page);
        req.setAttribute("totalPages",    totalPages);
        req.setAttribute("totalBookings", totalBookings);
        req.setAttribute("search",        search);
        req.setAttribute("statusFilter",  statusFilter);
        req.getRequestDispatcher("/Views/admin/admin_bookings.jsp").forward(req, resp);
    }
}
