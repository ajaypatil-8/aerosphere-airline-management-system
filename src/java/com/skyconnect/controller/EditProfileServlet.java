package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection()) {
            // FIX: Fetch ALL fields so the edit form is pre-filled
            PreparedStatement ps = con.prepareStatement(
                "SELECT name, email, phone, dob, gender, address FROM users WHERE id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("curName",    rs.getString("name"));
                req.setAttribute("curEmail",   rs.getString("email"));
                req.setAttribute("curPhone",   rs.getString("phone")   != null ? rs.getString("phone")   : "");
                req.setAttribute("curDob",     rs.getDate("dob")       != null ? rs.getDate("dob").toString() : "");
                req.setAttribute("curGender",  rs.getString("gender")  != null ? rs.getString("gender")  : "");
                req.setAttribute("curAddress", rs.getString("address") != null ? rs.getString("address") : "");
            } else {
                req.setAttribute("error", "User not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
        }

        req.getRequestDispatcher("/Views/user/edit_profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");
        String dobStr   = req.getParameter("dob");
        String gender   = req.getParameter("gender");
        String address  = req.getParameter("address");
        String password = req.getParameter("password");

        if (name == null || email == null || name.trim().isEmpty() || email.trim().isEmpty()) {
            req.setAttribute("error", "Name and email cannot be empty.");
            reloadForm(req, userId);
            req.getRequestDispatcher("/Views/user/edit_profile.jsp").forward(req, resp);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            // Build query depending on whether password is being changed
            String sql;
            PreparedStatement ps;

            if (password != null && !password.trim().isEmpty()) {
                sql = "UPDATE users SET name=?, email=?, phone=?, dob=?, gender=?, address=?, password=? WHERE id=?";
                ps  = con.prepareStatement(sql);
                ps.setString(1, name.trim());
                ps.setString(2, email.trim());
                ps.setString(3, phone   != null ? phone.trim()   : null);
                if (dobStr != null && !dobStr.isEmpty()) { ps.setDate(4, Date.valueOf(dobStr)); } else { ps.setNull(4, Types.DATE); }
                ps.setString(5, gender  != null ? gender.trim()  : null);
                ps.setString(6, address != null ? address.trim() : null);
                ps.setString(7, password.trim());
                ps.setInt(8, userId);
            } else {
                sql = "UPDATE users SET name=?, email=?, phone=?, dob=?, gender=?, address=? WHERE id=?";
                ps  = con.prepareStatement(sql);
                ps.setString(1, name.trim());
                ps.setString(2, email.trim());
                ps.setString(3, phone   != null ? phone.trim()   : null);
                if (dobStr != null && !dobStr.isEmpty()) { ps.setDate(4, Date.valueOf(dobStr)); } else { ps.setNull(4, Types.DATE); }
                ps.setString(5, gender  != null ? gender.trim()  : null);
                ps.setString(6, address != null ? address.trim() : null);
                ps.setInt(7, userId);
            }

            ps.executeUpdate();
            session.setAttribute("userName", name.trim());
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;

        } catch (SQLIntegrityConstraintViolationException cve) {
            req.setAttribute("error", "Email already in use by another account.");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Update error: " + e.getMessage());
        }

        reloadForm(req, userId);
        req.getRequestDispatcher("/Views/user/edit_profile.jsp").forward(req, resp);
    }

    /** Reload current DB values into request for re-displaying the form */
    private void reloadForm(HttpServletRequest req, int userId) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT name, email, phone, dob, gender, address FROM users WHERE id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("curName",    rs.getString("name"));
                req.setAttribute("curEmail",   rs.getString("email"));
                req.setAttribute("curPhone",   rs.getString("phone")   != null ? rs.getString("phone")   : "");
                req.setAttribute("curDob",     rs.getDate("dob")       != null ? rs.getDate("dob").toString() : "");
                req.setAttribute("curGender",  rs.getString("gender")  != null ? rs.getString("gender")  : "");
                req.setAttribute("curAddress", rs.getString("address") != null ? rs.getString("address") : "");
            }
        } catch (Exception ex) { ex.printStackTrace(); }
    }
}