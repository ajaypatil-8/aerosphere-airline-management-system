/*package com.skyconnect.servlet;

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

    public static class BookingRow {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date departDate;
        public Time departTime;
        public int numSeats;
        public double totalAmount;
        public String status;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        List<BookingRow> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT b.id, b.num_seats, b.total_amount, b.payment_status, " +
                         "f.flight_no, f.source, f.destination, f.depart_date, f.depart_time " +
                         "FROM bookings b JOIN flights f ON b.flight_id = f.id " +
                         "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingRow br = new BookingRow();
                br.id = rs.getInt("id");
                br.numSeats = rs.getInt("num_seats");
                br.totalAmount = rs.getDouble("total_amount");
                br.status = rs.getString("payment_status");
                br.flightNo = rs.getString("flight_no");
                br.source = rs.getString("source");
                br.destination = rs.getString("destination");
                br.departDate = rs.getDate("depart_date");
                br.departTime = rs.getTime("depart_time");
                list.add(br);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error loading bookings: " + e.getMessage());
        }

        req.setAttribute("bookings", list);
        req.getRequestDispatcher("user_bookings.jsp").forward(req, resp);
    }
}
*/




/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/userBookings")
public class UserBookingsServlet extends HttpServlet {

    // ===================== INNER DTO =====================
    public static class BookingRow {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date departDate;     // java.sql.Date
        public Time departTime;     // java.sql.Time
        public int seats;
        public double amount;
        public String status;
        public String paymentStatus;
    }

    // ===================== GET =====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        List<BookingRow> bookings = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                "f.flight_no, f.source, f.destination, f.depart_date, f.depart_time " +
                "FROM bookings b " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.booking_date DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingRow br = new BookingRow();
                br.id = rs.getInt("id");
                br.flightNo = rs.getString("flight_no");
                br.source = rs.getString("source");
                br.destination = rs.getString("destination");
                br.departDate = rs.getDate("depart_date");   // sql.Date
                br.departTime = rs.getTime("depart_time");   // sql.Time
                br.seats = rs.getInt("num_seats");
                br.amount = rs.getDouble("total_amount");
                br.status = rs.getString("status");
                br.paymentStatus = rs.getString("payment_status");

                bookings.add(br);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load bookings");
        }

        req.setAttribute("bookings", bookings);
        req.getRequestDispatcher("user_bookings.jsp").forward(req, resp);
    }
}
*/



package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/userBookings")
public class UserBookingsServlet extends HttpServlet {

    public static class BookingRow {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date departDate;        // java.sql.Date
        public Time departTime;
        public int numSeats;
        public double totalAmount;
        public String status;          // BOOKED / PAID / CANCELLED
        public String paymentStatus;   // PENDING / PAID / REFUNDED
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        List<BookingRow> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                "f.flight_no, f.source, f.destination, f.depart_date, f.depart_time " +
                "FROM bookings b " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE b.user_id = ? ORDER BY b.booking_date DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingRow br = new BookingRow();
                br.id = rs.getInt("id");
                br.numSeats = rs.getInt("num_seats");
                br.totalAmount = rs.getDouble("total_amount");
                br.status = rs.getString("status");
                br.paymentStatus = rs.getString("payment_status");

                br.flightNo = rs.getString("flight_no");
                br.source = rs.getString("source");
                br.destination = rs.getString("destination");
                br.departDate = rs.getDate("depart_date");
                br.departTime = rs.getTime("depart_time");

                list.add(br);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load bookings");
        }

        req.setAttribute("bookings", list);
        req.getRequestDispatcher("user_bookings.jsp").forward(req, resp);
    }
}
