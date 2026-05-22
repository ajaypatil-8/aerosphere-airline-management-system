package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportFlights")
public class ReportFlightsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 50;

    public static class FlightRow {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date departDate;
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

        String route      = req.getParameter("route");
        String departDate = req.getParameter("date");
        String dateFrom   = req.getParameter("dateFrom");
        String dateTo     = req.getParameter("dateTo");

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<FlightRow> flights = new ArrayList<>();
        int totalCount = 0;

        try (Connection con = DBConnection.getConnection()) {

            StringBuilder where = new StringBuilder(" WHERE 1=1");
            List<Object> params = new ArrayList<>();

            if (route != null && !route.isEmpty()) {
                where.append(" AND CONCAT(source,'-',destination) = ?");
                params.add(route);
            }
            if (departDate != null && !departDate.isEmpty()) {
                where.append(" AND depart_date = ?");
                params.add(Date.valueOf(departDate));
            } else {
                if (dateFrom != null && !dateFrom.isEmpty()) {
                    where.append(" AND depart_date >= ?");
                    params.add(Date.valueOf(dateFrom));
                }
                if (dateTo != null && !dateTo.isEmpty()) {
                    where.append(" AND depart_date <= ?");
                    params.add(Date.valueOf(dateTo));
                }
            }

            // Count
            String countSql = "SELECT COUNT(*) FROM flights" + where;
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Paginated data
            String sql =
                "SELECT id, flight_no, source, destination, depart_date, depart_time, " +
                "arrival_time, price, seats_total, seats_available FROM flights" +
                where + " ORDER BY depart_date DESC LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                for (Object param : params) ps.setObject(idx++, param);
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        FlightRow f = new FlightRow();
                        f.id             = rs.getInt("id");
                        f.flightNo       = rs.getString("flight_no");
                        f.source         = rs.getString("source");
                        f.destination    = rs.getString("destination");
                        f.departDate     = rs.getDate("depart_date");
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
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("flights",     flights);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("route",       route);
        req.setAttribute("date",        departDate);
        req.setAttribute("dateFrom",    dateFrom);
        req.setAttribute("dateTo",      dateTo);
        req.getRequestDispatcher("/Views/admin/flights_report.jsp").forward(req, resp);
    }
}
