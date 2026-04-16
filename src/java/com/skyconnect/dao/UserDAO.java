package com.skyconnect.dao;

import com.skyconnect.model.User;
import com.skyconnect.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /** Authenticate: returns User if credentials match, null otherwise */
    public User authenticate(String email, String plainPassword) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase().trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password");
                boolean valid;
                if (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$")) {
                    valid = BCrypt.checkpw(plainPassword, storedHash);
                } else {
                    // Legacy plain-text fallback — auto-upgrade on next login
                    valid = storedHash.equals(plainPassword);
                }
                if (valid) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Register a new user. Returns generated id or -1 on failure. */
    public int register(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, dob, gender, address, role) VALUES (?,?,?,?,?,?,?,'USER')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12));
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashed);
            ps.setString(4, user.getPhone());
            ps.setDate(5, user.getDob());
            ps.setString(6, user.getGender());
            ps.setString(7, user.getAddress());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            return -2; // email already exists
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Check if email already registered */
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase().trim());
            return ps.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get user by id */
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
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

    /** Update profile (name, phone, dob, gender, address) */
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET name=?, phone=?, dob=?, gender=?, address=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getPhone());
            ps.setDate(3, user.getDob());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Change password — verifies old password first */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = getUserById(userId);
        if (user == null) return false;
        String stored = user.getPassword();
        boolean match = (stored.startsWith("$2") ? BCrypt.checkpw(oldPassword, stored) : stored.equals(oldPassword));
        if (!match) return false;
        String sql = "UPDATE users SET password=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get user by email (for forgot-password flow) */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase().trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Reset password by email — no old-password check (OTP already verified) */
    public boolean resetPasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE users SET password=? WHERE email=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
            ps.setString(2, email.toLowerCase().trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Change password by email — verifies old password first */
    public boolean changePasswordByEmail(String email, String oldPassword, String newPassword) {
        User user = getUserByEmail(email);
        if (user == null) return false;
        String stored = user.getPassword();
        boolean match = (stored.startsWith("$2") ? BCrypt.checkpw(oldPassword, stored) : stored.equals(oldPassword));
        if (!match) return false;
        return resetPasswordByEmail(email, newPassword);
    }

    /** Admin: get all users */
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Count all users (role = USER) */
    public int countUsers() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role='USER'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Admin: ban / suspend an account.
     * Sets is_active = 0 so the user cannot log in.
     */
    public boolean banUser(int userId) {
        return setActiveStatus(userId, false);
    }

    /**
     * Admin: re-activate a banned account.
     */
    public boolean unbanUser(int userId) {
        return setActiveStatus(userId, true);
    }

    private boolean setActiveStatus(int userId, boolean active) {
        String sql = "UPDATE users SET is_active=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── private helper ─────────────────────────────────────────────
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setDob(rs.getDate("dob"));
        u.setGender(rs.getString("gender"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        // is_active column: default true if column doesn't exist yet (safe fallback)
        try {
            u.setActive(rs.getBoolean("is_active"));
        } catch (SQLException ignored) {
            u.setActive(true); // column not added yet — treat as active
        }
        return u;
    }
}
