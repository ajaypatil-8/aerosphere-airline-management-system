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

    private static final int PAGE_SIZE = 50;

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
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String flightId = req.getParameter("flightId");

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<PassengerRow> list = new ArrayList<>();
        int totalCount = 0;

        String baseFrom =
            "FROM passengers p " +
            "JOIN bookings b ON p.booking_id = b.id " +
            "JOIN flights f ON b.flight_id = f.id";

        String whereClause = (flightId != null && !flightId.isEmpty())
            ? " WHERE f.id = ?"
            : "";

        try (Connection con = DBConnection.getConnection()) {

            // Count
            String countSql = "SELECT COUNT(*) " + baseFrom + whereClause;
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                if (!whereClause.isEmpty()) ps.setInt(1, Integer.parseInt(flightId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Paginated data
            String sql =
                "SELECT b.id AS booking_id, b.status, " +
                "f.flight_no, f.source, f.destination, " +
                "p.full_name, p.age, p.gender, p.seat_no " +
                baseFrom + whereClause +
                " ORDER BY f.flight_no, p.seat_no LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                if (!whereClause.isEmpty()) ps.setInt(idx++, Integer.parseInt(flightId));
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        PassengerRow p = new PassengerRow();
                        p.bookingId     = rs.getInt("booking_id");
                        p.flightNo      = rs.getString("flight_no");
                        p.source        = rs.getString("source");
                        p.destination   = rs.getString("destination");
                        p.passengerName = rs.getString("full_name");
                        p.age           = rs.getInt("age");
                        p.gender        = rs.getString("gender");
                        p.seatNo        = rs.getString("seat_no");
                        p.bookingStatus = rs.getString("status");
                        list.add(p);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("passengers",  list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("flightId",    flightId);
        req.getRequestDispatcher("/Views/admin/passenger_report.jsp").forward(req, resp);
    }
}
