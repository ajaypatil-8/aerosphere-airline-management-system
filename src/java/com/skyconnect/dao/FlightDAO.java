package com.skyconnect.dao;

import com.skyconnect.model.Flight;
import com.skyconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FlightDAO {

    /** Search available flights by source, destination, date */
    public List<Flight> searchFlights(String source, String destination, String date) {
        List<Flight> list = new ArrayList<>();
        String sql = "SELECT * FROM flights WHERE LOWER(source) LIKE LOWER(?) AND LOWER(destination) LIKE LOWER(?) " +
                     "AND depart_date = ? AND seats_available > 0 ORDER BY depart_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + source.trim() + "%");
            ps.setString(2, "%" + destination.trim() + "%");
            ps.setString(3, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get flight by id */
    public Flight getFlightById(int id) {
        String sql = "SELECT * FROM flights WHERE id = ?";
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

    /** Get all flights (admin) */
    public List<Flight> getAllFlights() {
        List<Flight> list = new ArrayList<>();
        String sql = "SELECT * FROM flights ORDER BY depart_date, depart_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Add new flight. Returns generated id or -1. -2 if flight_no duplicate. */
    public int addFlight(Flight flight) {
        String sql = "INSERT INTO flights (flight_no, source, destination, depart_date, depart_time, arrival_time, price, seats_total, seats_available) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, flight.getFlightNo().toUpperCase());
            ps.setString(2, flight.getSource());
            ps.setString(3, flight.getDestination());
            ps.setDate(4, flight.getDepartDate());
            ps.setTime(5, flight.getDepartTime());
            ps.setTime(6, flight.getArrivalTime());
            ps.setDouble(7, flight.getPrice());
            ps.setInt(8, flight.getSeatsTotal());
            ps.setInt(9, flight.getSeatsTotal()); // initially all available
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            return -2; // duplicate flight_no
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Update flight details */
    public boolean updateFlight(Flight flight) {
        String sql = "UPDATE flights SET flight_no=?, source=?, destination=?, depart_date=?, depart_time=?, arrival_time=?, price=?, seats_total=?, seats_available=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, flight.getFlightNo().toUpperCase());
            ps.setString(2, flight.getSource());
            ps.setString(3, flight.getDestination());
            ps.setDate(4, flight.getDepartDate());
            ps.setTime(5, flight.getDepartTime());
            ps.setTime(6, flight.getArrivalTime());
            ps.setDouble(7, flight.getPrice());
            ps.setInt(8, flight.getSeatsTotal());
            ps.setInt(9, flight.getSeatsAvailable());
            ps.setInt(10, flight.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Delete flight by id */
    public boolean deleteFlight(int id) {
        String sql = "DELETE FROM flights WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Decrement seats_available (with overbooking check). Thread-safe via DB constraint. */
    public boolean decrementSeats(int flightId, int numSeats) {
        String sql = "UPDATE flights SET seats_available = seats_available - ? WHERE id = ? AND seats_available >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, numSeats);
            ps.setInt(2, flightId);
            ps.setInt(3, numSeats);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Restore seats on cancellation */
    public boolean restoreSeats(int flightId, int numSeats) {
        String sql = "UPDATE flights SET seats_available = LEAST(seats_available + ?, seats_total) WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, numSeats);
            ps.setInt(2, flightId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Total flights count */
    public int countFlights() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM flights");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ---- helper ----
    private Flight mapRow(ResultSet rs) throws SQLException {
        Flight f = new Flight();
        f.setId(rs.getInt("id"));
        f.setFlightNo(rs.getString("flight_no"));
        f.setSource(rs.getString("source"));
        f.setDestination(rs.getString("destination"));
        f.setDepartDate(rs.getDate("depart_date"));
        f.setDepartTime(rs.getTime("depart_time"));
        f.setArrivalTime(rs.getTime("arrival_time"));
        f.setPrice(rs.getDouble("price"));
        f.setSeatsTotal(rs.getInt("seats_total"));
        f.setSeatsAvailable(rs.getInt("seats_available"));
        return f;
    }
}