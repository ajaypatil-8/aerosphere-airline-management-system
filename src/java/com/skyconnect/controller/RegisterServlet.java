package com.skyconnect.controller;

import com.skyconnect.dao.UserDAO;
import com.skyconnect.model.User;
import com.skyconnect.service.EmailService;
import com.skyconnect.util.CsrfUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.logging.Logger;

/**
 * AeroSphere — RegisterServlet (UPDATED)
 *
 * Changes vs Section 1 version:
 *  1. Sends welcome email after successful registration (async, non-blocking)
 *
 * All CSRF, BCrypt, validation logic from Section 1 is preserved exactly.
 * URL: /register (GET + POST — unchanged)
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RegisterServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── CSRF check (from Section 1) ────────────────────────────
        if (!CsrfUtil.validate(req)) {
            req.setAttribute("error", "Invalid request. Please try again.");
            req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
            return;
        }

        String name     = trim(req.getParameter("name"));
        String email    = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String phone    = trim(req.getParameter("phone"));
        String dobStr   = trim(req.getParameter("dob"));
        String gender   = trim(req.getParameter("gender"));
        String address  = trim(req.getParameter("address"));

        // ── Validation ────────────────────────────────────────────
        if (name.isEmpty() || email.isEmpty() || password == null || password.isEmpty()) {
            forward(req, resp, "Name, email, and password are required.");
            return;
        }
        if (name.length() < 2 || name.length() > 100) {
            forward(req, resp, "Name must be 2–100 characters.");
            return;
        }
        if (!email.matches("^[\\w.+-]+@[\\w-]+\\.[\\w.]{2,}$")) {
            forward(req, resp, "Please enter a valid email address.");
            return;
        }
        if (password.length() < 8) {
            forward(req, resp, "Password must be at least 8 characters.");
            return;
        }
        if (!phone.isEmpty() && !phone.matches("^[+]?[0-9\\s\\-]{7,15}$")) {
            forward(req, resp, "Please enter a valid phone number.");
            return;
        }

        // ── Parse DOB safely ─────────────────────────────────────
        java.sql.Date dob = null;
        if (!dobStr.isEmpty()) {
            try {
                LocalDate parsed = LocalDate.parse(dobStr);
                if (parsed.isAfter(LocalDate.now())) {
                    forward(req, resp, "Date of birth cannot be in the future.");
                    return;
                }
                dob = java.sql.Date.valueOf(parsed);
            } catch (Exception e) {
                forward(req, resp, "Invalid date of birth.");
                return;
            }
        }

        // ── Create User ───────────────────────────────────────────
        User user = new User();
        user.setName(name);
        user.setEmail(email.toLowerCase());
        user.setPhone(phone.isEmpty() ? null : phone);
        user.setDob(dob);
        user.setGender(gender.isEmpty() ? null : gender);
        user.setAddress(address.isEmpty() ? null : address);
        user.setRole("USER");

        UserDAO dao = new UserDAO();

        if (dao.emailExists(user.getEmail())) {
            forward(req, resp, "An account with this email already exists.");
            return;
        }

        int newId = dao.createUser(user, password);

        if (newId > 0) {
            LOG.info("New user registered: " + email + " (id=" + newId + ")");

            // ── Send welcome email (async) ─────────────────────────
            // Fires in background thread — registration redirect is instant
            EmailService.sendWelcome(user.getEmail(), user.getName());

            // ── Redirect to login with success message ─────────────
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } else {
            forward(req, resp, "Registration failed. Please try again.");
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String error)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
