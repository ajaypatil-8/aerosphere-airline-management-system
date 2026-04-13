package com.skyconnect.dao;

import com.skyconnect.model.Refund;
import com.skyconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RefundDAO {

    /** Request a refund. Returns -2 if already exists for this booking. */
    public int requestRefund(Refund refund) {
        // Prevent duplicate
        if (getRefundByBooking(refund.getBookingId()) != null) return -2;
        String sql = "INSERT INTO refunds (booking_id, user_id, refund_amount, refund_reason) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, refund.getBookingId());
            ps.setInt(2, refund.getUserId());
            ps.setDouble(3, refund.getRefundAmount());
            ps.setString(4, refund.getRefundReason());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Admin: get all refunds with join data */
    public List<Refund> getAllRefunds() {
        List<Refund> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS user_name, f.flight_no, f.source, f.destination " +
                     "FROM refunds r JOIN users u ON r.user_id=u.id JOIN bookings b ON r.booking_id=b.id JOIN flights f ON b.flight_id=f.id " +
                     "ORDER BY r.requested_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Admin: count pending refunds */
    public int countPendingRefunds() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM refunds WHERE refund_status='PENDING'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Approve or reject a refund */
    public boolean updateRefundStatus(int refundId, String status) {
        String sql = status.equals("APPROVED")
                ? "UPDATE refunds SET refund_status='APPROVED', approved_at=NOW() WHERE id=? AND refund_status='PENDING'"
                : "UPDATE refunds SET refund_status='REJECTED', approved_at=NOW() WHERE id=? AND refund_status='PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, refundId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get refund history for a user */
    public List<Refund> getRefundsByUser(int userId) {
        List<Refund> list = new ArrayList<>();
        String sql = "SELECT r.*, f.flight_no, f.source, f.destination " +
                     "FROM refunds r JOIN bookings b ON r.booking_id=b.id JOIN flights f ON b.flight_id=f.id " +
                     "WHERE r.user_id=? ORDER BY r.requested_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get refund by booking id */
    public Refund getRefundByBooking(int bookingId) {
        String sql = "SELECT r.* FROM refunds r WHERE r.booking_id=? LIMIT 1";
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

    private Refund mapRow(ResultSet rs) throws SQLException {
        Refund r = new Refund();
        r.setId(rs.getInt("id"));
        r.setBookingId(rs.getInt("booking_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setRefundAmount(rs.getDouble("refund_amount"));
        r.setRefundReason(rs.getString("refund_reason"));
        r.setRefundStatus(rs.getString("refund_status"));
        r.setApprovedAt(rs.getTimestamp("approved_at"));
        r.setRequestedAt(rs.getTimestamp("requested_at"));
        try { r.setUserName(rs.getString("user_name")); }     catch (SQLException ignored) {}
        try { r.setFlightNo(rs.getString("flight_no")); }     catch (SQLException ignored) {}
        try { r.setSource(rs.getString("source")); }          catch (SQLException ignored) {}
        try { r.setDestination(rs.getString("destination")); } catch (SQLException ignored) {}
        return r;
    }
}