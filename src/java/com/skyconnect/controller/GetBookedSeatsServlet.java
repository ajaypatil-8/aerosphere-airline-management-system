package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/getBookedSeats")
public class GetBookedSeatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingIdStr = req.getParameter("bookingId");
        if (bookingIdStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);

        List<String> seats = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT seat_no FROM passengers " +
                "WHERE booking_id IN (" +
                "SELECT id FROM bookings WHERE flight_id = " +
                "(SELECT flight_id FROM bookings WHERE id = ?)" +
                ") AND seat_no IS NOT NULL";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                seats.add(rs.getString("seat_no"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // -------- JSON RESPONSE --------
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < seats.size(); i++) {
            json.append("\"").append(seats.get(i)).append("\"");
            if (i < seats.size() - 1) json.append(",");
        }
        json.append("]");

        resp.getWriter().write(json.toString());
    }
}
