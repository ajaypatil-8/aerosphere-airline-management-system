package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/userBookings")
public class UserBookingsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    public static class BookingRow {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date departDate;
        public Time departTime;
        public int numSeats;
        public double totalAmount;
        public String status;           // BOOKED / PAID / CANCELLED
        public String paymentStatus;    // PENDING / PAID / REFUNDED
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<BookingRow> list = new ArrayList<>();
        int totalCount = 0;

        try (Connection con = DBConnection.getConnection()) {

            // Count
            String countSql =
                "SELECT COUNT(*) FROM bookings b WHERE b.user_id = ?";
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Paginated data
            String sql =
                "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                "f.flight_no, f.source, f.destination, f.depart_date, f.depart_time " +
                "FROM bookings b " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE b.user_id = ? ORDER BY b.booking_date DESC " +
                "LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, PAGE_SIZE);
                ps.setInt(3, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        BookingRow br = new BookingRow();
                        br.id            = rs.getInt("id");
                        br.numSeats      = rs.getInt("num_seats");
                        br.totalAmount   = rs.getDouble("total_amount");
                        br.status        = rs.getString("status");
                        br.paymentStatus = rs.getString("payment_status");
                        br.flightNo      = rs.getString("flight_no");
                        br.source        = rs.getString("source");
                        br.destination   = rs.getString("destination");
                        br.departDate    = rs.getDate("depart_date");
                        br.departTime    = rs.getTime("depart_time");
                        list.add(br);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load bookings");
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("bookings",    list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.getRequestDispatcher("/Views/user/user_bookings.jsp").forward(req, resp);
    }
}
