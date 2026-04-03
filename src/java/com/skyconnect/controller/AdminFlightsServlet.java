package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminFlights")
public class AdminFlightsServlet extends HttpServlet {

    public static class Flight {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date date;
        public Time departTime;
        public Time arrivalTime;
        public double price;
        public int totalSeats;
        public int availableSeats;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Flight> flights = new ArrayList<>();

        String sql =
            "SELECT * FROM flights ORDER BY depart_date DESC, depart_time ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Flight f = new Flight();
                f.id = rs.getInt("id");
                f.flightNo = rs.getString("flight_no");
                f.source = rs.getString("source");
                f.destination = rs.getString("destination");
                f.date = rs.getDate("depart_date");
                f.departTime = rs.getTime("depart_time");
                f.arrivalTime = rs.getTime("arrival_time");
                f.price = rs.getDouble("price");
                f.totalSeats = rs.getInt("seats_total");
                f.availableSeats = rs.getInt("seats_available");
                flights.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("flights", flights);
        req.getRequestDispatcher("adminflights.jsp").forward(req, resp);
    }
}