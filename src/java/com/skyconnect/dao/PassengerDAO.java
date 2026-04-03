package com.skyconnect.dao;

import com.skyconnect.model.Passenger;
import com.skyconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PassengerDAO {

    /**
     * Insert a list of passengers for a booking.
     * Seat numbers are auto-generated: ROW+LETTER (e.g. 1A, 1B...)
     */
    public boolean insertPassengers(List<Passenger> passengers) {
        String sql = "INSERT INTO passengers (booking_id, full_name, age, gender, phone, email, dob, seat_no) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < passengers.size(); i++) {
                Passenger p = passengers.get(i);
                ps.setInt(1, p.getBookingId());
                ps.setString(2, p.getFullName());
                ps.setInt(3, p.getAge());
                ps.setString(4, p.getGender());
                ps.setString(5, p.getPhone());
                ps.setString(6, p.getEmail());
                ps.setDate(7, p.getDob());
                ps.setString(8, p.getSeatNo());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int r : results) if (r <= 0) return false;
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get all passengers for a booking */
    public List<Passenger> getPassengersByBooking(int bookingId) {
        List<Passenger> list = new ArrayList<>();
        String sql = "SELECT * FROM passengers WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Passenger p = new Passenger();
                p.setId(rs.getInt("id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setFullName(rs.getString("full_name"));
                p.setAge(rs.getInt("age"));
                p.setGender(rs.getString("gender"));
                p.setPhone(rs.getString("phone"));
                p.setEmail(rs.getString("email"));
                p.setDob(rs.getDate("dob"));
                p.setSeatNo(rs.getString("seat_no"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Generate seat numbers based on flight's existing bookings.
     * Returns e.g. ["12A","12B","12C"]
     */
    public List<String> generateSeatNumbers(int flightId, int count) {
        List<String> seats = new ArrayList<>();
        // Find max seat row already booked for this flight
        String sql = "SELECT p.seat_no FROM passengers p JOIN bookings b ON p.booking_id=b.id WHERE b.flight_id=? AND b.status!='CANCELLED'";
        int maxRow = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, flightId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String sn = rs.getString("seat_no");
                if (sn != null && sn.length() >= 2) {
                    try { maxRow = Math.max(maxRow, Integer.parseInt(sn.replaceAll("[^0-9]",""))); }
                    catch (NumberFormatException ignored) {}
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        String[] cols = {"A","B","C","D","E","F"};
        int row = maxRow + 1;
        int colIdx = 0;
        for (int i = 0; i < count; i++) {
            seats.add(row + cols[colIdx]);
            colIdx++;
            if (colIdx >= 6) { colIdx = 0; row++; }
        }
        return seats;
    }
}