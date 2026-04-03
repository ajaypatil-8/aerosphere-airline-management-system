package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportCancelled")
public class ReportCancelledServlet extends HttpServlet {

    public static class CancelledRow {
        public int bookingId;
        public String userName;
        public String flightNo;
        public String route;
        public Timestamp bookingDate;
        public int seats;
        public double amount;
        public String paymentStatus;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<CancelledRow> cancelled = new ArrayList<>();

        String sql =
            "SELECT b.id AS booking_id, u.name AS user_name, f.flight_no, " +
            "CONCAT(f.source,' → ',f.destination) AS route, " +
            "b.booking_date, b.num_seats, b.total_amount, b.payment_status " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN flights f ON b.flight_id = f.id " +
            "WHERE b.status = 'CANCELLED' " +
            "ORDER BY b.booking_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CancelledRow c = new CancelledRow();
                c.bookingId = rs.getInt("booking_id");
                c.userName = rs.getString("user_name");
                c.flightNo = rs.getString("flight_no");
                c.route = rs.getString("route");
                c.bookingDate = rs.getTimestamp("booking_date");
                c.seats = rs.getInt("num_seats");
                c.amount = rs.getDouble("total_amount");
                c.paymentStatus = rs.getString("payment_status");
                cancelled.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("cancelled", cancelled);
        req.getRequestDispatcher("/Views/admin/cancelled_report.jsp").forward(req, resp);
    }
}