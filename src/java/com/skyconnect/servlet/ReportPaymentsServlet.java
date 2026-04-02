package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportPayments")
public class ReportPaymentsServlet extends HttpServlet {

    public static class PaymentRow {
        public int paymentId;
        public int bookingId;
        public String userName;
        public String flightNo;
        public String route;
        public Timestamp paymentDate;
        public String paymentMethod;
        public double amount;
        public String paymentStatus;
        public String bookingStatus;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<PaymentRow> payments = new ArrayList<>();

        String sql =
            "SELECT p.id AS payment_id, b.id AS booking_id, u.name AS user_name, " +
            "f.flight_no, CONCAT(f.source,' → ',f.destination) AS route, " +
            "p.payment_date, p.payment_method, p.amount, " +
            "p.payment_status, b.status AS booking_status " +
            "FROM payments p " +
            "JOIN bookings b ON p.booking_id = b.id " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN flights f ON b.flight_id = f.id " +
            "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PaymentRow p = new PaymentRow();
                p.paymentId = rs.getInt("payment_id");
                p.bookingId = rs.getInt("booking_id");
                p.userName = rs.getString("user_name");
                p.flightNo = rs.getString("flight_no");
                p.route = rs.getString("route");
                p.paymentDate = rs.getTimestamp("payment_date");
                p.paymentMethod = rs.getString("payment_method");
                p.amount = rs.getDouble("amount");
                p.paymentStatus = rs.getString("payment_status");
                p.bookingStatus = rs.getString("booking_status");
                payments.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("payments", payments);
        req.getRequestDispatcher("payments_report.jsp").forward(req, resp);
    }
}