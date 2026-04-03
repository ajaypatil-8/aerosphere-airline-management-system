package com.skyconnect.dao;

import com.skyconnect.model.Booking;
import com.skyconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /** Create booking with status=PENDING. Returns generated booking id. */
    public int createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (user_id, flight_id, num_seats, total_amount, status, payment_status, razorpay_order_id) VALUES (?,?,?,?,'PENDING','PENDING',?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getFlightId());
            ps.setInt(3, booking.getNumSeats());
            ps.setDouble(4, booking.getTotalAmount());
            ps.setString(5, booking.getRazorpayOrderId());
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

    /** Update booking to BOOKED + payment SUCCESS after Razorpay verification */
    public boolean confirmBooking(int bookingId) {
        String sql = "UPDATE bookings SET status='BOOKED', payment_status='SUCCESS' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Mark booking as CANCELLED */
    public boolean cancelBooking(int bookingId, int userId) {
        String sql = "UPDATE bookings SET status='CANCELLED', cancelled_at=NOW() WHERE id=? AND user_id=? AND status='BOOKED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Update razorpay_order_id on booking */
    public boolean updateOrderId(int bookingId, String orderId) {
        String sql = "UPDATE bookings SET razorpay_order_id=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get booking by id */
    public Booking getBookingById(int id) {
        String sql = "SELECT b.*, f.flight_no, f.source, f.destination, DATE_FORMAT(f.depart_date,'%d %b %Y') AS depart_date, TIME_FORMAT(f.depart_time,'%H:%i') AS depart_time, u.name AS user_name " +
                     "FROM bookings b JOIN flights f ON b.flight_id=f.id JOIN users u ON b.user_id=u.id WHERE b.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Get all bookings for a user */
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, f.flight_no, f.source, f.destination, DATE_FORMAT(f.depart_date,'%d %b %Y') AS depart_date, TIME_FORMAT(f.depart_time,'%H:%i') AS depart_time " +
                     "FROM bookings b JOIN flights f ON b.flight_id=f.id WHERE b.user_id=? ORDER BY b.booking_date DESC";
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

    /** Admin: get all bookings with optional search */
    public List<Booking> getAllBookings(String search) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, f.flight_no, f.source, f.destination, DATE_FORMAT(f.depart_date,'%d %b %Y') AS depart_date, TIME_FORMAT(f.depart_time,'%H:%i') AS depart_time, u.name AS user_name " +
                     "FROM bookings b JOIN flights f ON b.flight_id=f.id JOIN users u ON b.user_id=u.id " +
                     (search != null && !search.isEmpty() ? "WHERE f.flight_no LIKE ? OR u.name LIKE ? OR b.status LIKE ? " : "") +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (search != null && !search.isEmpty()) {
                String like = "%" + search + "%";
                ps.setString(1, like); ps.setString(2, like); ps.setString(3, like);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Count all confirmed bookings */
    public int countBookings() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM bookings WHERE status='BOOKED'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Total revenue from confirmed bookings */
    public double totalRevenue() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status='BOOKED'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ---- helper ----
    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setFlightId(rs.getInt("flight_id"));
        b.setBookingDate(rs.getTimestamp("booking_date"));
        b.setNumSeats(rs.getInt("num_seats"));
        b.setTotalAmount(rs.getDouble("total_amount"));
        b.setStatus(rs.getString("status"));
        b.setPaymentStatus(rs.getString("payment_status"));
        b.setCancelledAt(rs.getTimestamp("cancelled_at"));
        try { b.setRazorpayOrderId(rs.getString("razorpay_order_id")); } catch (SQLException ignored) {}
        try { b.setFlightNo(rs.getString("flight_no")); }     catch (SQLException ignored) {}
        try { b.setSource(rs.getString("source")); }          catch (SQLException ignored) {}
        try { b.setDestination(rs.getString("destination")); } catch (SQLException ignored) {}
        try { b.setDepartDate(rs.getString("depart_date")); }  catch (SQLException ignored) {}
        try { b.setDepartTime(rs.getString("depart_time")); }  catch (SQLException ignored) {}
        try { b.setUserName(rs.getString("user_name")); }      catch (SQLException ignored) {}
        return b;
    }
}