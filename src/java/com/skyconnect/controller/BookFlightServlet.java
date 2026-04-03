/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/bookFlight")
public class BookFlightServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String flightIdStr = req.getParameter("flightId");
        String numSeatsStr = req.getParameter("numSeats");

        if (flightIdStr == null || numSeatsStr == null) {
            resp.sendRedirect("index.jsp");
            return;
        }

        int flightId = Integer.parseInt(flightIdStr);
        int numSeats = Integer.parseInt(numSeatsStr);

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // 1) lock flight row and check seats
            int available = 0;
            double price = 0;

            String checkSql = "SELECT seats_available, price FROM flights WHERE id = ? FOR UPDATE";
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, flightId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        available = rs.getInt("seats_available");
                        price = rs.getDouble("price");
                    } else {
                        con.rollback();
                        session.setAttribute("bookingError", "Flight not found.");
                        resp.sendRedirect("userDashboard");
                        return;
                    }
                }
            }

            if (available < numSeats) {
                con.rollback();
                session.setAttribute("bookingError", "Not enough seats available.");
                resp.sendRedirect("userDashboard");
                return;
            }

            double totalAmount = price * numSeats;

            // 2) insert booking
            int bookingId = 0;
            String insertSql = "INSERT INTO bookings(user_id, flight_id, num_seats, total_amount, status) " +
                               "VALUES (?,?,?,?, 'BOOKED')";
            try (PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, flightId);
                ps.setInt(3, numSeats);
                ps.setDouble(4, totalAmount);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        bookingId = keys.getInt(1);
                    }
                }
            }

            // 3) update seats
            String updateSql = "UPDATE flights SET seats_available = seats_available - ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setInt(1, numSeats);
                ps.setInt(2, flightId);
                ps.executeUpdate();
            }

            con.commit();

            // 👉 go to payment, not invoice
            //resp.sendRedirect("payment?bookingId=" + bookingId);
            resp.sendRedirect("addPassengers?bookingId=" + bookingId);

            return;

        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("bookingError", "Booking failed: " + e.getMessage());
            }
            resp.sendRedirect("userDashboard");
        }
    }
}

/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/bookFlight")
public class BookFlightServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 🔐 Check login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int flightId = Integer.parseInt(req.getParameter("flightId"));

        try (Connection con = DBConnection.getConnection()) {

            // 1️⃣ Get flight details
            String flightSql = "SELECT * FROM flights WHERE id=?";
            PreparedStatement ps = con.prepareStatement(flightSql);
            ps.setInt(1, flightId);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect("search_flights.jsp");
                return;
            }

            double price = rs.getDouble("price");
            int seatsAvailable = rs.getInt("seats_available");

            if (seatsAvailable <= 0) {
                req.setAttribute("error", "No seats available");
                req.getRequestDispatcher("search_flights.jsp").forward(req, resp);
                return;
            }

            // 2️⃣ Insert booking
            String bookingSql =
                "INSERT INTO bookings (user_id, flight_id, seats, total_amount, status) " +
                "VALUES (?, ?, ?, ?, 'BOOKED')";

            PreparedStatement bp = con.prepareStatement(bookingSql);
            bp.setInt(1, userId);
            bp.setInt(2, flightId);
            bp.setInt(3, 1); // default 1 seat
            bp.setDouble(4, price);

            bp.executeUpdate();

            // 3️⃣ Update available seats
            String updateSeats =
                "UPDATE flights SET seats_available = seats_available - 1 WHERE id=?";
            PreparedStatement us = con.prepareStatement(updateSeats);
            us.setInt(1, flightId);
            us.executeUpdate();

            // 4️⃣ Redirect to dashboard
            resp.sendRedirect("userDashboard");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}*/




package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/bookFlight")
public class BookFlightServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
           resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        int flightId = Integer.parseInt(req.getParameter("flightId"));
        int numSeats = Integer.parseInt(req.getParameter("numSeats"));

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            int availableSeats;
            double price;

            // 🔒 Lock flight row
            String checkSql =
                "SELECT seats_available, price FROM flights WHERE id=? FOR UPDATE";

            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, flightId);
                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    con.rollback();
                    resp.sendRedirect("searchFlights");
                    return;
                }

                availableSeats = rs.getInt("seats_available");
                price = rs.getDouble("price");
            }

            if (availableSeats < numSeats) {
                con.rollback();
                session.setAttribute("bookingError", "Not enough seats available");
                resp.sendRedirect("searchFlights");
                return;
            }

            double totalAmount = price * numSeats;
            int bookingId;

            // 📌 Insert booking
            String insertSql =
                "INSERT INTO bookings " +
                "(user_id, flight_id, booking_date, num_seats, total_amount, status, payment_status) " +
                "VALUES (?, ?, NOW(), ?, ?, 'BOOKED', 'PENDING')";

            try (PreparedStatement ps =
                         con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, userId);
                ps.setInt(2, flightId);
                ps.setInt(3, numSeats);
                ps.setDouble(4, totalAmount);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                keys.next();
                bookingId = keys.getInt(1);
            }

            // ✈ Update seats
            String updateSql =
                "UPDATE flights SET seats_available = seats_available - ? WHERE id=?";

            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setInt(1, numSeats);
                ps.setInt(2, flightId);
                ps.executeUpdate();
            }

            con.commit();

            // ✅ MOST IMPORTANT LINE (YOU WERE MISSING THIS)
            session.setAttribute("numSeats", numSeats);

            // ➡ Go to passenger details
            resp.sendRedirect("addPassengers?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("userDashboard");
        }
    }
}
