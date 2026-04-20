/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

@WebServlet("/savePassengers")
public class SavePassengersServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdStr = req.getParameter("bookingId");
        if (bookingIdStr == null) {
            resp.sendRedirect(request.getContextPath() + "/userDashboard");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);

        // 🔹 Get passenger arrays
        String[] names   = req.getParameterValues("full_name[]");
        String[] ages    = req.getParameterValues("age[]");
        String[] genders = req.getParameterValues("gender[]");
        String[] phones  = req.getParameterValues("phone[]");
        String[] emails  = req.getParameterValues("email[]");
        String[] dobs    = req.getParameterValues("dob[]");

        // Safety check
        if (names == null || names.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/addPassengers?bookingId=" + bookingId);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "INSERT INTO passengers " +
                "(booking_id, full_name, age, gender, phone, email, dob) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < names.length; i++) {

                ps.setInt(1, bookingId);
                ps.setString(2, names[i]);
                ps.setInt(3, Integer.parseInt(ages[i]));
                ps.setString(4, genders[i]);
                ps.setString(5, phones[i]);
                ps.setString(6, emails[i]);

                if (dobs[i] != null && !dobs[i].isEmpty()) {
                    ps.setDate(7, Date.valueOf(dobs[i]));
                } else {
                    ps.setNull(7, java.sql.Types.DATE);
                }

                ps.addBatch();
            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/addPassengers?bookingId=" + bookingId);
            return;
        }

        // ✅ Clear seat count (optional but clean)
        session.removeAttribute("numSeats");

        // ➡ Redirect to payment page
        resp.sendRedirect(req.getContextPath() + "/payment?bookingId=" + bookingId);
    }
}*/

package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/savePassengers")
public class SavePassengersServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
           resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId;
        int bookingId;
        try {
            userId    = (Integer) session.getAttribute("userId");
            bookingId = Integer.parseInt(req.getParameter("bookingId"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/userDashboard");
            return;
        }

        String[] names   = req.getParameterValues("full_name[]");
        String[] genders = req.getParameterValues("gender[]");
        String[] phones  = req.getParameterValues("phone[]");
        String[] emails  = req.getParameterValues("email[]");
        String[] dobs    = req.getParameterValues("dob[]");
        String[] seats   = req.getParameterValues("seat_no[]"); // 🔹 may be empty

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            /* ================= 1️⃣ GET FLIGHT ID + OWNERSHIP CHECK ================= */
            int flightId = 0;
            PreparedStatement ps = con.prepareStatement(
                "SELECT flight_id FROM bookings WHERE id=? AND user_id=?"
            );
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                flightId = rs.getInt("flight_id");
            } else {
                resp.sendRedirect(req.getContextPath() + "/userDashboard");
                return;
            }

            /* ================= 2️⃣ GET ALREADY BOOKED SEATS ================= */
            Set<String> bookedSeats = new HashSet<>();

            ps = con.prepareStatement(
                "SELECT seat_no FROM passengers " +
                "WHERE booking_id IN (SELECT id FROM bookings WHERE flight_id=?)"
            );
            ps.setInt(1, flightId);
            rs = ps.executeQuery();
            while (rs.next()) {
                if (rs.getString("seat_no") != null)
                    bookedSeats.add(rs.getString("seat_no"));
            }

            /* ================= 3️⃣ GENERATE SEAT MAP ================= */
            List<String> allSeats = new ArrayList<>();
            char[] rows = {'A','B','C','D','E','F'};
            for (char r : rows) {
                for (int i = 1; i <= 30; i++) {
                    allSeats.add(r + String.valueOf(i));
                }
            }

            Iterator<String> seatIterator = allSeats.iterator();

            /* ================= 4️⃣ INSERT PASSENGERS ================= */
            String insertSql =
                "INSERT INTO passengers " +
                "(booking_id, full_name, age, gender, phone, email, dob, seat_no) " +
                "VALUES (?,?,?,?,?,?,?,?)";

            ps = con.prepareStatement(insertSql);

            for (int i = 0; i < names.length; i++) {

                String seat = (seats != null && seats[i] != null && !seats[i].isEmpty())
                              ? seats[i] : null;

                // 🔁 AUTO ASSIGN SEAT IF EMPTY
                if (seat == null) {
                    while (seatIterator.hasNext()) {
                        String nextSeat = seatIterator.next();
                        if (!bookedSeats.contains(nextSeat)) {
                            seat = nextSeat;
                            bookedSeats.add(seat);
                            break;
                        }
                    }
                }

                ps.setInt(1, bookingId);
                ps.setString(2, names[i]);

                // Calculate age automatically from DOB
                int age = 0;
                if (dobs != null && dobs[i] != null && !dobs[i].isEmpty()) {
                    java.time.LocalDate birth = java.sql.Date.valueOf(dobs[i]).toLocalDate();
                    age = (int) java.time.temporal.ChronoUnit.YEARS.between(birth, java.time.LocalDate.now());
                }
                ps.setInt(3, age);

                ps.setString(4, genders[i]);
                ps.setString(5, phones[i]);
                ps.setString(6, emails[i]);

                if (dobs != null && dobs[i] != null && !dobs[i].isEmpty())
                   ps.setDate(7, java.sql.Date.valueOf(dobs[i]));

                else
                    ps.setNull(7, Types.DATE);

                ps.setString(8, seat); // 🔥 seat saved

                ps.addBatch();
            }

            ps.executeBatch();
            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/addPassengers?bookingId=" + bookingId);
            return;
        }

        session.removeAttribute("numSeats");

        // ➡ Go to payment
        resp.sendRedirect(req.getContextPath() + "/payment?bookingId=" + bookingId);
    }
}

