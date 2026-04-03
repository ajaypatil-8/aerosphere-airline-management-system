package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/userDashboard")
public class UserDashboardServlet extends HttpServlet {

    public static class Booking {
        public int bookingId;
        public String flightNo;
        public String source;
        public String destination;
        public String bookingDate;
        public int numSeats;
        public double totalAmount;
        public String status;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Login required
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Prepare list for recent bookings
        List<Booking> bookings = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT b.id AS bookingId, f.flight_no, f.source, f.destination, " +
                         "b.booking_date, b.num_seats, b.total_amount, b.status " +
                         "FROM bookings b " +
                         "JOIN flights f ON b.flight_id = f.id " +
                         "WHERE b.user_id = ? " +
                         "ORDER BY b.booking_date DESC LIMIT 5";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking b = new Booking();
                b.bookingId = rs.getInt("bookingId");
                b.flightNo = rs.getString("flight_no");
                b.source = rs.getString("source");
                b.destination = rs.getString("destination");
                b.bookingDate = rs.getTimestamp("booking_date").toString();
                b.numSeats = rs.getInt("num_seats");
                b.totalAmount = rs.getDouble("total_amount");
                b.status = rs.getString("status");
                bookings.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load dashboard: " + e.getMessage());
        }

        // Set data for JSP
        req.setAttribute("recentBookings", bookings);

        // Move to dashboard page
        req.getRequestDispatcher("/Views/user/user_dashboard.jsp").forward(req, resp);
    }
}


/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/userDashboard")
public class UserDashboardServlet extends HttpServlet {

    public static class Booking {
        public int id, seats;
        public String flightNo, source, destination, status, departDate;
        public double amount;
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");

        if (userId == null) {
            resp.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        req.setAttribute("userName", userName);

        try (Connection con = DBConnection.getConnection()) {

            // ---------- COUNTS ---------- 
            PreparedStatement ps = con.prepareStatement(
                "SELECT " +
                "COUNT(id), " +
                "SUM(status='BOOKED'), " +
                "SUM(status='CANCELLED'), " +
                "COALESCE(SUM(total_amount),0) " +
                "FROM bookings WHERE user_id=?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("totalBookings", rs.getInt(1));
                req.setAttribute("bookedCount", rs.getInt(2));
                req.setAttribute("cancelledCount", rs.getInt(3));
                req.setAttribute("amountSpent", rs.getDouble(4));
            }

            // ---------- UPCOMING ---------- 
            ps = con.prepareStatement(
                "SELECT b.id, f.flight_no, f.source, f.destination, f.depart_date " +
                "FROM bookings b JOIN flights f ON b.flight_id=f.id " +
                "WHERE b.user_id=? AND b.status='BOOKED' " +
                "ORDER BY f.depart_date ASC LIMIT 1"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("upcomingFlight", rs.getString(2));
                req.setAttribute("upcomingRoute",
                        rs.getString(3) + " → " + rs.getString(4));
                req.setAttribute("upcomingDate", rs.getString(5));
                req.setAttribute("upcomingBookingId", rs.getInt(1));
            }

            // ---------- RECENT ---------- 
            List<Booking> list = new ArrayList<>();
            ps = con.prepareStatement(
                "SELECT b.id, b.num_seats, b.total_amount, b.status, " +
                "f.flight_no, f.source, f.destination, f.depart_date " +
                "FROM bookings b JOIN flights f ON b.flight_id=f.id " +
                "WHERE b.user_id=? ORDER BY b.id DESC LIMIT 5"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Booking b = new Booking();
                b.id = rs.getInt(1);
                b.seats = rs.getInt(2);
                b.amount = rs.getDouble(3);
                b.status = rs.getString(4);
                b.flightNo = rs.getString(5);
                b.source = rs.getString(6);
                b.destination = rs.getString(7);
                b.departDate = rs.getString(8);
                list.add(b);
            }

            req.setAttribute("recentBookings", list);
            req.getRequestDispatcher("/Views/user/user_dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace(); // CHECK TOMCAT CONSOLE
            resp.getWriter().println("Dashboard Error");
        }
    }
}
*/