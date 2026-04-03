/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdStr = req.getParameter("bookingId");
        String paymentMethod = req.getParameter("paymentMethod");

        if (bookingIdStr == null || paymentMethod == null || paymentMethod.isEmpty()) {
            resp.sendRedirect("userDashboard");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            double amount = 0;

            // 1️⃣ Get booking amount
            String fetchSql =
                "SELECT total_amount FROM bookings WHERE id=? AND status='BOOKED'";

            try (PreparedStatement ps = con.prepareStatement(fetchSql)) {
                ps.setInt(1, bookingId);
                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    con.rollback();
                    resp.sendRedirect("userDashboard");
                    return;
                }

                amount = rs.getDouble("total_amount");
            }

            // 2️⃣ Insert payment record
            String insertPaymentSql =
                "INSERT INTO payments (booking_id, payment_date, amount, payment_method, payment_status) " +
                "VALUES (?, NOW(), ?, ?, 'SUCCESS')";

            try (PreparedStatement ps = con.prepareStatement(insertPaymentSql)) {
                ps.setInt(1, bookingId);
                ps.setDouble(2, amount);
                ps.setString(3, paymentMethod);
                ps.executeUpdate();
            }

            // 3️⃣ Update booking status
            String updateBookingSql =
                "UPDATE bookings SET status='PAID', payment_status='PAID' WHERE id=?";

            try (PreparedStatement ps = con.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/payment?bookingId=" + bookingIdStr);
            return;
        }

        // ✅ Payment done → go to My Bookings
        resp.sendRedirect("userBookings");
    }
}
*/


package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {

    // =========================
    // SHOW PAYMENT PAGE
    // =========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));

        try (Connection con = DBConnection.getConnection()) {

            // 🔒 Load booking safely
            String sql =
                "SELECT total_amount, status, payment_status " +
                "FROM bookings WHERE id=? AND user_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect("userBookings");
                return;
            }

            String bookingStatus = rs.getString("status");
            String paymentStatus = rs.getString("payment_status");
            double amount = rs.getDouble("total_amount");

            // ❌ Already cancelled
            if ("CANCELLED".equals(bookingStatus)) {
                resp.sendRedirect("invoice?bookingId=" + bookingId);
                return;
            }

            // ✅ Already paid → skip payment
            if ("PAID".equals(paymentStatus)) {
                resp.sendRedirect("invoice?bookingId=" + bookingId);
                return;
            }

            // GST calculation
            double gst = amount * 0.05;
            double finalAmount = amount + gst;

            req.setAttribute("bookingId", bookingId);
            req.setAttribute("baseAmount", amount);
            req.setAttribute("gst", gst);
            req.setAttribute("finalAmount", finalAmount);

            req.getRequestDispatcher("/Views/user/payment.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("userBookings");
        }
    }

    // =========================
    // PROCESS PAYMENT
    // =========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (userId == null) {
           resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        String method = req.getParameter("paymentMethod");

        if (method == null || method.isEmpty()) {
            resp.sendRedirect("payment?bookingId=" + bookingId);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // 🔒 Lock booking
            String fetch =
                "SELECT total_amount, payment_status " +
                "FROM bookings WHERE id=? AND user_id=? FOR UPDATE";

            PreparedStatement ps = con.prepareStatement(fetch);
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                con.rollback();
                resp.sendRedirect("userBookings");
                return;
            }

            String paymentStatus = rs.getString("payment_status");

            // ❌ Already paid
            if ("PAID".equals(paymentStatus)) {
                con.rollback();
                resp.sendRedirect("invoice?bookingId=" + bookingId);
                return;
            }

            double amount = rs.getDouble("total_amount");
            double gst = amount * 0.05;
            double finalAmount = amount + gst;

            // 💳 Insert payment
            String paySql =
                "INSERT INTO payments (booking_id, amount, payment_method, payment_status) " +
                "VALUES (?, ?, ?, 'SUCCESS')";

            PreparedStatement ps2 = con.prepareStatement(paySql);
            ps2.setInt(1, bookingId);
            ps2.setDouble(2, finalAmount);
            ps2.setString(3, method);
            ps2.executeUpdate();

            // ✅ Update booking
            String updateBooking =
                "UPDATE bookings SET payment_status='PAID', status='PAID' WHERE id=?";

            PreparedStatement ps3 = con.prepareStatement(updateBooking);
            ps3.setInt(1, bookingId);
            ps3.executeUpdate();

            con.commit();

            resp.sendRedirect("invoice?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("payment?bookingId=" + bookingId);
        }
    }
}
