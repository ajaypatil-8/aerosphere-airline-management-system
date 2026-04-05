package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    public static class RecentBooking {
        public int bookingId;
        public String flightNo;
        public String userName;
        public String source;
        public String destination;
        public double totalAmount;
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

        try (Connection con = DBConnection.getConnection()) {

            // ── Total counts ──────────────────────────────────────────────
            req.setAttribute("totalFlights",  getCount(con, "SELECT COUNT(*) FROM flights"));
            req.setAttribute("totalBookings", getCount(con, "SELECT COUNT(*) FROM bookings"));
            req.setAttribute("totalUsers",    getCount(con, "SELECT COUNT(*) FROM users WHERE role='USER'"));

            // ── Total Revenue: sum of all PAID payments ───────────────────
            // FIX: was querying bookings WHERE status='BOOKED' — paid bookings
            // have status='PAID', so that query always returned 0.
            // Correct source of truth is the payments table.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE payment_status = 'SUCCESS'");
                 ResultSet rs = ps.executeQuery()) {
                req.setAttribute("totalRevenue", rs.next() ? rs.getDouble(1) : 0.0);
            }

            // ── Pending Refunds: from the refunds table, not bookings ─────
            // FIX: was querying bookings WHERE status='CANCELLED' — that counts
            // cancellations, not pending refund requests in the refunds table.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM refunds WHERE refund_status = 'PENDING'");
                 ResultSet rs = ps.executeQuery()) {
                req.setAttribute("pendingRefunds", rs.next() ? rs.getInt(1) : 0);
            }

            // ── Recent 10 bookings ────────────────────────────────────────
            List<RecentBooking> recent = new ArrayList<>();
            String sql =
                "SELECT b.id, b.total_amount, b.status, b.booking_date, " +
                "f.flight_no, f.source, f.destination, u.name " +
                "FROM bookings b " +
                "JOIN flights f ON b.flight_id = f.id " +
                "JOIN users   u ON b.user_id   = u.id " +
                "ORDER BY b.booking_date DESC LIMIT 10";

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecentBooking r = new RecentBooking();
                    r.bookingId     = rs.getInt("id");
                    r.flightNo      = rs.getString("flight_no");
                    r.userName      = rs.getString("name");
                    r.source        = rs.getString("source");
                    r.destination   = rs.getString("destination");
                    r.totalAmount   = rs.getDouble("total_amount");
                    r.paymentStatus = rs.getString("status");
                    r.bookingDate   = rs.getTimestamp("booking_date");
                    recent.add(r);
                }
            }

            req.setAttribute("recentBookings", recent);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/Views/admin/admin_dashboard.jsp").forward(req, resp);
    }

    private int getCount(Connection con, String query) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
