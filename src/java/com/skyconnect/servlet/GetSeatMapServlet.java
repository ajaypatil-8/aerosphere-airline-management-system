package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/getSeatMap")
public class GetSeatMapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json");

        String flightId = req.getParameter("flightId");
        Set<String> bookedSeats = new HashSet<>();

        String sql =
            "SELECT p.seat_no FROM passengers p " +
            "JOIN bookings b ON p.booking_id = b.id " +
            "WHERE b.flight_id=? AND b.status!='CANCELLED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(flightId));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                bookedSeats.add(rs.getString("seat_no"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // JSON response
        resp.getWriter().print(bookedSeats.toString());
    }
}