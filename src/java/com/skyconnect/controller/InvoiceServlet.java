/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    public static class Passenger {
        public String name;
        public int age;
        public String gender;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("bookingId");
        if (idParam == null) {
            resp.getWriter().println("Missing bookingId");
            return;
        }

        int bookingId = Integer.parseInt(idParam);

        try (Connection con = DBConnection.getConnection()) {

            // ---------------- BOOKING + USER + FLIGHT ----------------
            String sql =
                "SELECT b.num_seats, b.total_amount, b.status, " +
                "u.name, u.email, " +
                "f.flight_no, f.source, f.destination, f.depart_date, f.depart_time, f.arrival_time " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE b.id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.getWriter().println("Booking not found");
                return;
            }

            req.setAttribute("bookingId", bookingId);
            req.setAttribute("userName", rs.getString("name"));
            req.setAttribute("userEmail", rs.getString("email"));
            req.setAttribute("flightNo", rs.getString("flight_no"));
            req.setAttribute("source", rs.getString("source"));
            req.setAttribute("destination", rs.getString("destination"));
            req.setAttribute("departDate", rs.getString("depart_date"));
            req.setAttribute("departTime", rs.getString("depart_time"));
            req.setAttribute("arrivalTime", rs.getString("arrival_time"));
            req.setAttribute("seats", rs.getInt("num_seats"));
            req.setAttribute("amount", rs.getDouble("total_amount"));
            req.setAttribute("status", rs.getString("status"));

            // ---------------- PAYMENT ----------------
            String psql =
                "SELECT amount, payment_method, payment_status " +
                "FROM payments WHERE booking_id=? ORDER BY payment_date DESC LIMIT 1";

            PreparedStatement ps2 = con.prepareStatement(psql);
            ps2.setInt(1, bookingId);
            ResultSet prs = ps2.executeQuery();

            if (prs.next()) {
                req.setAttribute("paidAmount", prs.getDouble("amount"));
                req.setAttribute("paymentMethod", prs.getString("payment_method"));
                req.setAttribute("paymentStatus", prs.getString("payment_status"));
            }

            // ---------------- PASSENGERS ----------------
            List<Passenger> passengers = new ArrayList<>();

            String psgSql =
                "SELECT full_name, age, gender FROM passengers WHERE booking_id = ?";

            PreparedStatement ps3 = con.prepareStatement(psgSql);
            ps3.setInt(1, bookingId);
            ResultSet rs3 = ps3.executeQuery();

            while (rs3.next()) {
                Passenger p = new Passenger();
                p.name = rs3.getString("full_name");
                p.age = rs3.getInt("age");
                p.gender = rs3.getString("gender");
                passengers.add(p);
            }

            req.setAttribute("passengers", passengers);

            req.getRequestDispatcher("/Views/user/invoice.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
*/


package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    // ================= PASSENGER MODEL =================
    public static class Passenger {
        public String name;
        public int age;
        public String gender;
        public String seatNo;   // ✅ SEAT NUMBER
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("bookingId");
        if (idParam == null) {
            resp.getWriter().println("Missing bookingId");
            return;
        }

        int bookingId = Integer.parseInt(idParam);

        try (Connection con = DBConnection.getConnection()) {

            // ================= BOOKING + USER + FLIGHT =================
            String sql =
                "SELECT b.num_seats, b.total_amount, b.status, " +
                "u.name, u.email, " +
                "f.flight_no, f.source, f.destination, " +
                "f.depart_date, f.depart_time, f.arrival_time " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN flights f ON b.flight_id = f.id " +
                "WHERE b.id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.getWriter().println("Booking not found");
                return;
            }

            req.setAttribute("bookingId", bookingId);
            req.setAttribute("userName", rs.getString("name"));
            req.setAttribute("userEmail", rs.getString("email"));
            req.setAttribute("flightNo", rs.getString("flight_no"));
            req.setAttribute("source", rs.getString("source"));
            req.setAttribute("destination", rs.getString("destination"));
            req.setAttribute("departDate", rs.getString("depart_date"));
            req.setAttribute("departTime", rs.getString("depart_time"));
            req.setAttribute("arrivalTime", rs.getString("arrival_time"));
            req.setAttribute("seats", rs.getInt("num_seats"));
            req.setAttribute("amount", rs.getDouble("total_amount"));
            req.setAttribute("status", rs.getString("status"));

            // ================= PAYMENT =================
            String psql =
                "SELECT amount, payment_method, payment_status " +
                "FROM payments WHERE booking_id=? " +
                "ORDER BY payment_date DESC LIMIT 1";

            PreparedStatement ps2 = con.prepareStatement(psql);
            ps2.setInt(1, bookingId);
            ResultSet prs = ps2.executeQuery();

            if (prs.next()) {
                req.setAttribute("paidAmount", prs.getDouble("amount"));
                req.setAttribute("paymentMethod", prs.getString("payment_method"));
                req.setAttribute("paymentStatus", prs.getString("payment_status"));
            }

            // ================= PASSENGERS (SEAT-WISE) =================
            List<Passenger> passengers = new ArrayList<>();

            String psgSql =
                "SELECT full_name, age, gender, seat_no " +
                "FROM passengers " +
                "WHERE booking_id = ? " +
                "ORDER BY seat_no";   // ✅ SEAT ORDER

            PreparedStatement ps3 = con.prepareStatement(psgSql);
            ps3.setInt(1, bookingId);
            ResultSet rs3 = ps3.executeQuery();

            while (rs3.next()) {
                Passenger p = new Passenger();
                p.name   = rs3.getString("full_name");
                p.age    = rs3.getInt("age");
                p.gender = rs3.getString("gender");
                p.seatNo = rs3.getString("seat_no"); // ✅
                passengers.add(p);
            }

            req.setAttribute("passengers", passengers);

            // ================= FORWARD =================
            req.getRequestDispatcher("/Views/user/invoice.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
