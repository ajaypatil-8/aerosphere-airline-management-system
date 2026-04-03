package com.skyconnect.dao;

import com.skyconnect.model.Payment;
import com.skyconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    /** Insert payment record after successful Razorpay verification */
    public boolean insertPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, amount, payment_method, payment_status, razorpay_order_id, razorpay_payment_id, razorpay_signature) VALUES (?,?,'RAZORPAY','SUCCESS',?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getRazorpayOrderId());
            ps.setString(4, payment.getRazorpayPaymentId());
            ps.setString(5, payment.getRazorpaySignature());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get payment for a booking */
    public Payment getPaymentByBooking(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY payment_date DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Total revenue */
    public double getTotalRevenue() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(amount),0) FROM payments WHERE payment_status='SUCCESS'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setAmount(rs.getDouble("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        try { p.setRazorpayOrderId(rs.getString("razorpay_order_id")); }   catch (SQLException ignored) {}
        try { p.setRazorpayPaymentId(rs.getString("razorpay_payment_id")); } catch (SQLException ignored) {}
        try { p.setRazorpaySignature(rs.getString("razorpay_signature")); }  catch (SQLException ignored) {}
        return p;
    }
}