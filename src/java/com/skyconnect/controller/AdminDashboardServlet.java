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

    // ✅ Updated model (matches JSP exactly)
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

           // totals
req.setAttribute("totalFlights", getCount(con, "SELECT COUNT(*) FROM flights"));
req.setAttribute("totalBookings", getCount(con, "SELECT COUNT(*) FROM bookings"));
req.setAttribute("totalUsers", getCount(con, "SELECT COUNT(*) FROM users"));


// ✅ ADD HERE 👇

// Total Revenue
try (PreparedStatement ps = con.prepareStatement(
    "SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status='BOOKED'");
     ResultSet rs = ps.executeQuery()) {

    if (rs.next()) req.setAttribute("totalRevenue", rs.getDouble(1));
    else req.setAttribute("totalRevenue", 0.0);
}

// Pending Refunds
try (PreparedStatement ps = con.prepareStatement(
    "SELECT COUNT(*) FROM bookings WHERE status='CANCELLED'");
     ResultSet rs = ps.executeQuery()) {

    if (rs.next()) req.setAttribute("pendingRefunds", rs.getInt(1));
    else req.setAttribute("pendingRefunds", 0);
}

            // ✅ recent bookings (FIXED QUERY)
            List<RecentBooking> recent = new ArrayList<>();

            String sql = "SELECT b.id, b.total_amount, b.status, b.booking_date, " +
                         "f.flight_no, f.source, f.destination, u.name " +
                         "FROM bookings b " +
                         "JOIN flights f ON b.flight_id = f.id " +
                         "JOIN users u ON b.user_id = u.id " +
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

    // ✅ helper method
    private int getCount(Connection con, String query) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}