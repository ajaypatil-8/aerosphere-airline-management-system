package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminBookings")
public class AdminBookingsServlet extends HttpServlet {

    public static class BookingRow {
        public int id;
        public String flightNo;
        public String userName;
        public int seats;
        public double amount;
        public String status;
        public Timestamp bookedOn;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<BookingRow> rows = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT b.id, f.flight_no, u.name AS user_name, b.num_seats, b.total_amount, b.status, b.booking_date " +
                         "FROM bookings b " +
                         "JOIN flights f ON b.flight_id = f.id " +
                         "JOIN users u ON b.user_id = u.id " +
                         "ORDER BY b.booking_date DESC";
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingRow r = new BookingRow();
                    r.id = rs.getInt("id");
                    r.flightNo = rs.getString("flight_no");
                    r.userName = rs.getString("user_name");
                    r.seats = rs.getInt("num_seats");
                    r.amount = rs.getDouble("total_amount");
                    r.status = rs.getString("status");
                    r.bookedOn = rs.getTimestamp("booking_date");
                    rows.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading bookings: " + e.getMessage());
        }

        req.setAttribute("bookings", rows);
        req.getRequestDispatcher("admin_bookings.jsp").forward(req, resp);
    }
}
