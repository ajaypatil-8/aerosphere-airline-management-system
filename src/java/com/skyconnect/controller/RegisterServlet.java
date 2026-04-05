package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, bounce to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("userRole");
            resp.sendRedirect(req.getContextPath() +
                ("ADMIN".equals(role) ? "/adminDashboard" : "/userDashboard"));
            return;
        }
        req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String phone    = req.getParameter("phone");
        String dob      = req.getParameter("dob");
        String gender   = req.getParameter("gender");
        String address  = req.getParameter("address");

        // ── basic validation ──
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty()) {
            req.setAttribute("error", "Name, email and password are required.");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        // ── HASH the password with BCrypt before storing ──
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO users(name, email, password, phone, dob, gender, address, role) "
                       + "VALUES(?, ?, ?, ?, ?, ?, ?, 'USER')";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name.trim());
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, hashedPassword);        // ← BCrypt hash, not plain text
            ps.setString(4, phone != null && !phone.trim().isEmpty() ? phone.trim() : null);

            if (dob != null && !dob.trim().isEmpty()) {
                ps.setDate(5, Date.valueOf(dob.trim()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, gender != null && !gender.trim().isEmpty() ? gender.trim() : null);
            ps.setString(7, address != null && !address.trim().isEmpty() ? address.trim() : null);

            ps.executeUpdate();

            req.setAttribute("success", "Account created successfully! Please sign in.");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);

        } catch (SQLIntegrityConstraintViolationException e) {
            req.setAttribute("error", "An account with this email already exists.");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
        }
    }
}
