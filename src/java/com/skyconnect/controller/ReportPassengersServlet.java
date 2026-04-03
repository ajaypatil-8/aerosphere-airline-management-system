package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportPassengers")
public class ReportPassengersServlet extends HttpServlet {

    public static class PassengerRow {
        public int bookingId;
        public String flightNo;
        public String source;
        public String destination;
        public String passengerName;
        public String seatNo;
        public int age;
        public String gender;
        public String bookingStatus;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<PassengerRow> list = new ArrayList<>();

        String flightId = req.getParameter("flightId");

        String sql =
            "SELECT b.id AS booking_id, b.status, " +
            "f.flight_no, f.source, f.destination, " +
            "p.full_name, p.age, p.gender, p.seat_no " +
            "FROM passengers p " +
            "JOIN bookings b ON p.booking_id = b.id " +
            "JOIN flights f ON b.flight_id = f.id ";

        if (flightId != null && !flightId.isEmpty()) {
            sql += "WHERE f.id = ? ";
        }

        sql += "ORDER BY f.flight_no, p.seat_no";

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);

            if (flightId != null && !flightId.isEmpty()) {
                ps.setInt(1, Integer.parseInt(flightId));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PassengerRow p = new PassengerRow();
                p.bookingId = rs.getInt("booking_id");
                p.flightNo = rs.getString("flight_no");
                p.source = rs.getString("source");
                p.destination = rs.getString("destination");
                p.passengerName = rs.getString("full_name");
                p.age = rs.getInt("age");
                p.gender = rs.getString("gender");
                p.seatNo = rs.getString("seat_no");
                p.bookingStatus = rs.getString("status");
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("passengers", list);
        req.getRequestDispatcher("/Views/admin/passenger_report.jsp").forward(req, resp);
    }
}