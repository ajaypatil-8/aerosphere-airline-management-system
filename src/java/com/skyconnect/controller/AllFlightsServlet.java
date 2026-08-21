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

    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Parse page param
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * PAGE_SIZE;

        List<Map<String, Object>> flights = new ArrayList<>();
        int totalFlights = 0;

        // Index-friendly rewrite: the old version wrapped both columns in
        // TIMESTAMP(depart_date, depart_time) >= NOW(), which can't use any
        // index and forces a full table scan on every request. Splitting the
        // condition lets the DB use an index on (depart_date, depart_time).
        String baseSql = "FROM flights WHERE (depart_date > CURDATE() " +
                          "OR (depart_date = CURDATE() AND depart_time >= CURTIME()))";

        try (Connection con = DBConnection.getConnection()) {

            // Total count
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) " + baseSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalFlights = rs.getInt(1);
            }

            // Paginated rows
            String sql = "SELECT id, flight_no, source, destination, depart_date, " +
                         "depart_time, arrival_time, price, seats_total, seats_available " +
                         baseSql +
                         " ORDER BY depart_date ASC, depart_time ASC" +
                         " LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, PAGE_SIZE);
                ps.setInt(2, offset);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> f = new LinkedHashMap<>();
                        f.put("id",              rs.getInt("id"));
                        f.put("flight_no",       rs.getString("flight_no"));
                        f.put("source",          rs.getString("source"));
                        f.put("destination",     rs.getString("destination"));
                        f.put("depart_date",     rs.getDate("depart_date"));
                        f.put("depart_time",     rs.getTime("depart_time"));
                        f.put("arrival_time",    rs.getTime("arrival_time"));
                        f.put("price",           rs.getDouble("price"));
                        f.put("seats_total",     rs.getInt("seats_total"));
                        f.put("seats_available", rs.getInt("seats_available"));
                        flights.add(f);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load flights: " + e.getMessage());
        }

        int totalPages = (int) Math.ceil((double) totalFlights / PAGE_SIZE);

        req.setAttribute("flights",      flights);
        req.setAttribute("currentPage",  page);
        req.setAttribute("totalPages",   totalPages);
        req.setAttribute("totalFlights", totalFlights);
        req.setAttribute("pageSize",     PAGE_SIZE);
        CsrfUtil.ensureToken(req);
        req.getRequestDispatcher("/Views/user/all_flights.jsp").forward(req, resp);
    }
}