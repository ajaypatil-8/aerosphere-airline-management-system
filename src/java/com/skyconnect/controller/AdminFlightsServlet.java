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

    private static final int PAGE_SIZE = 25;

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

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Parse page and search
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        String search = req.getParameter("search");
        if (search == null) search = "";
        search = search.trim();

        int offset = (page - 1) * PAGE_SIZE;

        List<Flight> flights = new ArrayList<>();
        int totalFlights = 0;

        // Build WHERE clause for optional search
        String whereClause = search.isEmpty()
            ? ""
            : " WHERE flight_no LIKE ? OR source LIKE ? OR destination LIKE ?";

        try (Connection con = DBConnection.getConnection()) {

            String countSql = "SELECT COUNT(*) FROM flights" + whereClause;
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                if (!search.isEmpty()) {
                    String like = "%" + search + "%";
                    ps.setString(1, like); ps.setString(2, like); ps.setString(3, like);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalFlights = rs.getInt(1);
                }
            }

            String sql = "SELECT * FROM flights" + whereClause +
                         " ORDER BY depart_date ASC, depart_time ASC" +
                         " LIMIT ? OFFSET ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                if (!search.isEmpty()) {
                    String like = "%" + search + "%";
                    ps.setString(idx++, like); ps.setString(idx++, like); ps.setString(idx++, like);
                }
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Flight f = new Flight();
                        f.id             = rs.getInt("id");
                        f.flightNo       = rs.getString("flight_no");
                        f.source         = rs.getString("source");
                        f.destination    = rs.getString("destination");
                        f.date           = rs.getDate("depart_date");
                        f.departTime     = rs.getTime("depart_time");
                        f.arrivalTime    = rs.getTime("arrival_time");
                        f.price          = rs.getDouble("price");
                        f.totalSeats     = rs.getInt("seats_total");
                        f.availableSeats = rs.getInt("seats_available");
                        flights.add(f);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading flights: " + e.getMessage());
        }

        int totalPages = (int) Math.ceil((double) totalFlights / PAGE_SIZE);

        req.setAttribute("flights",      flights);
        req.setAttribute("currentPage",  page);
        req.setAttribute("totalPages",   totalPages);
        req.setAttribute("totalFlights", totalFlights);
        req.setAttribute("search",       search);
        req.getRequestDispatcher("/Views/admin/admin_flights.jsp").forward(req, resp);
    }
}
