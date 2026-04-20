package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import com.skyconnect.util.CsrfUtil;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/allFlights")
public class AllFlightsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Fetch only upcoming/current flights (filter out past departures)
        List<Map<String, Object>> flights = new ArrayList<>();
        String sql = "SELECT id, flight_no, source, destination, depart_date, " +
                     "depart_time, arrival_time, price, seats_total, seats_available " +
                     "FROM flights " +
                     "WHERE TIMESTAMP(depart_date, depart_time) >= NOW() " +
                     "ORDER BY depart_date ASC, depart_time ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> f = new LinkedHashMap<>();
                f.put("id",               rs.getInt("id"));
                f.put("flight_no",        rs.getString("flight_no"));
                f.put("source",           rs.getString("source"));
                f.put("destination",      rs.getString("destination"));
                f.put("depart_date",      rs.getDate("depart_date"));
                f.put("depart_time",      rs.getTime("depart_time"));
                f.put("arrival_time",     rs.getTime("arrival_time"));
                f.put("price",            rs.getDouble("price"));
                f.put("seats_total",      rs.getInt("seats_total"));
                f.put("seats_available",  rs.getInt("seats_available"));
                flights.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load flights: " + e.getMessage());
        }

        req.setAttribute("flights", flights);
        CsrfUtil.ensureToken(req);
        req.getRequestDispatcher("/Views/user/all_flights.jsp").forward(req, resp);
    }
}