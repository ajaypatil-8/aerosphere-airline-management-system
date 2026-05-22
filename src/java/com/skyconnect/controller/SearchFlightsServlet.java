package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/searchFlights")
public class SearchFlightsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String source      = req.getParameter("source");
        String destination = req.getParameter("destination");
        String departDate  = req.getParameter("departDate");
        String numSeatsStr = req.getParameter("numSeats");

        int numSeats = 1;
        try {
            if (numSeatsStr != null && !numSeatsStr.isEmpty())
                numSeats = Integer.parseInt(numSeatsStr);
        } catch (NumberFormatException e) { numSeats = 1; }

        if (source == null || destination == null || departDate == null ||
            source.isEmpty() || destination.isEmpty() || departDate.isEmpty()) {
            req.setAttribute("error", "All fields are required");
            req.getRequestDispatcher("/Views/user/search_flights.jsp").forward(req, resp);
            return;
        }

        java.sql.Date sqlDate;
        try {
            sqlDate = java.sql.Date.valueOf(departDate);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Invalid date format. Please select a valid date.");
            req.getRequestDispatcher("/Views/user/search_flights.jsp").forward(req, resp);
            return;
        }

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<Map<String, Object>> flights = new ArrayList<>();
        int totalCount = 0;

        try (Connection con = DBConnection.getConnection()) {

            // Count query
            String countSql =
                "SELECT COUNT(*) FROM flights " +
                "WHERE source=? AND destination=? AND depart_date=? AND seats_available >= ?";
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                ps.setString(1, source);
                ps.setString(2, destination);
                ps.setDate(3, sqlDate);
                ps.setInt(4, numSeats);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Data query with LIMIT / OFFSET
            String sql =
                "SELECT * FROM flights " +
                "WHERE source=? AND destination=? AND depart_date=? AND seats_available >= ? " +
                "ORDER BY depart_time ASC " +
                "LIMIT ? OFFSET ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, source);
                ps.setString(2, destination);
                ps.setDate(3, sqlDate);
                ps.setInt(4, numSeats);
                ps.setInt(5, PAGE_SIZE);
                ps.setInt(6, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> flight = new HashMap<>();
                        flight.put("id",               rs.getInt("id"));
                        flight.put("flight_no",        rs.getString("flight_no"));
                        flight.put("source",           rs.getString("source"));
                        flight.put("destination",      rs.getString("destination"));
                        flight.put("depart_date",      rs.getDate("depart_date"));
                        flight.put("depart_time",      rs.getTime("depart_time"));
                        flight.put("arrival_time",     rs.getTime("arrival_time"));
                        flight.put("price",            rs.getDouble("price"));
                        flight.put("seats_available",  rs.getInt("seats_available"));
                        flights.add(flight);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to search flights");
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("flights",     flights);
        req.setAttribute("searched",    true);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("source",      source);
        req.setAttribute("destination", destination);
        req.setAttribute("departDate",  departDate);
        req.setAttribute("numSeats",    numSeats);

        req.getRequestDispatcher("/Views/user/search_flights.jsp").forward(req, resp);
    }
}
