package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportBookings")
public class ReportBookingsServlet extends HttpServlet {

    public static class BookingRow {
        public int id;
        public String userName;
        public String flightNo;
        public String source;
        public String destination;
        public int seats;
        public double amount;
        public String status;
        public String paymentStatus;
        public Timestamp bookingDate;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<BookingRow> list = new ArrayList<>();

        String status = req.getParameter("status");
        String payment = req.getParameter("payment");
        String date = req.getParameter("date");

        StringBuilder sql = new StringBuilder(
            "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, b.booking_date, " +
            "u.name AS user_name, f.flight_no, f.source, f.destination " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id=u.id " +
            "JOIN flights f ON b.flight_id=f.id WHERE 1=1 "
        );

        if (status != null && !status.isEmpty()) {
            sql.append(" AND b.status=? ");
        }
        if (payment != null && !payment.isEmpty()) {
            sql.append(" AND b.payment_status=? ");
        }
        if (date != null && !date.isEmpty()) {
            sql.append(" AND DATE(b.booking_date)=? ");
        }

        sql.append(" ORDER BY b.booking_date DESC");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql.toString());

            int index = 1;
            if (status != null && !status.isEmpty())
                ps.setString(index++, status);
            if (payment != null && !payment.isEmpty())
                ps.setString(index++, payment);
            if (date != null && !date.isEmpty())
                ps.setDate(index++, Date.valueOf(date));

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingRow b = new BookingRow();
                b.id = rs.getInt("id");
                b.userName = rs.getString("user_name");
                b.flightNo = rs.getString("flight_no");
                b.source = rs.getString("source");
                b.destination = rs.getString("destination");
                b.seats = rs.getInt("num_seats");
                b.amount = rs.getDouble("total_amount");
                b.status = rs.getString("status");
                b.paymentStatus = rs.getString("payment_status");
                b.bookingDate = rs.getTimestamp("booking_date");
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("bookings", list);
        req.getRequestDispatcher("/Views/admin/bookings_report.jsp").forward(req, resp);
    }
}