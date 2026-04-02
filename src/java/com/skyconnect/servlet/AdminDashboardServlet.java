package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminDashboard")
//@WebServlet("/admin_dashboard")
public class AdminDashboardServlet extends HttpServlet {

    public static class RecentBooking {
        public int id;
        public String flightNo;
        public String userName;
        public int seats;
        public double amount;
        public String status;
        public Timestamp bookedOn;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            // totals
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM flights");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) req.setAttribute("totalFlights", rs.getInt(1));
                else req.setAttribute("totalFlights", 0);
            }

            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM bookings");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) req.setAttribute("totalBookings", rs.getInt(1));
                else req.setAttribute("totalBookings", 0);
            }

            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) req.setAttribute("totalUsers", rs.getInt(1));
                else req.setAttribute("totalUsers", 0);
            }

           /* try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM payments WHERE payment_status = 'PENDING'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) req.setAttribute("pendingPayments", rs.getInt(1));
                else req.setAttribute("pendingPayments", 0);
            }*/
           // Pending payments = all BOOKED bookings that are not successfully paid
String pendingSql =
    "SELECT COUNT(*) " +
    "FROM bookings b " +
    "LEFT JOIN payments p " +
    "  ON b.id = p.booking_id " +
    "  AND p.payment_status = 'SUCCESS' " +
    "WHERE b.status = 'BOOKED' " +
    "  AND (p.id IS NULL OR p.payment_status='PENDING')";

try (PreparedStatement ps = con.prepareStatement(pendingSql);
     ResultSet rs = ps.executeQuery()) {

    if (rs.next()) {
        req.setAttribute("pendingPayments", rs.getInt(1));
    } else {
        req.setAttribute("pendingPayments", 0);
    }
}


            // recent bookings
            List<RecentBooking> recent = new ArrayList<>();
            String sql = "SELECT b.id,b.num_seats,b.total_amount,b.status,b.booking_date, f.flight_no, u.name " +
                         "FROM bookings b JOIN flights f ON b.flight_id=f.id JOIN users u ON b.user_id=u.id " +
                         "ORDER BY b.booking_date DESC LIMIT 10";
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecentBooking r = new RecentBooking();
                    r.id = rs.getInt("id");
                    r.flightNo = rs.getString("flight_no");
                    r.userName = rs.getString("name");
                    r.seats = rs.getInt("num_seats");
                    r.amount = rs.getDouble("total_amount");
                    r.status = rs.getString("status");
                    r.bookedOn = rs.getTimestamp("booking_date");
                    recent.add(r);
                }
            }
            req.setAttribute("recentBookings", recent);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading admin dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("admin_dashboard.jsp").forward(req, resp);
    }
}
