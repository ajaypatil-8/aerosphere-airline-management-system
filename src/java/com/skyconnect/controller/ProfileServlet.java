package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection()) {
            // FIX: Fetch ALL user fields including phone, dob, gender, address
            String sql = "SELECT id, name, email, phone, dob, gender, address, role, created_at FROM users WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("id",        rs.getInt("id"));
                req.setAttribute("name",      rs.getString("name"));
                req.setAttribute("email",     rs.getString("email"));
                req.setAttribute("phone",     rs.getString("phone")   != null ? rs.getString("phone")   : "");
                req.setAttribute("dob",       rs.getDate("dob")       != null ? rs.getDate("dob").toString() : "");
                req.setAttribute("gender",    rs.getString("gender")  != null ? rs.getString("gender")  : "");
                req.setAttribute("address",   rs.getString("address") != null ? rs.getString("address") : "");
                req.setAttribute("role",      rs.getString("role"));
                req.setAttribute("createdAt", rs.getTimestamp("created_at"));
            } else {
                req.setAttribute("error", "Profile not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading profile: " + e.getMessage());
        }

        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }
}