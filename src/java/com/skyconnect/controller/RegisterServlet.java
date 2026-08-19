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
 * AeroSphere — RegisterServlet (with OTP verification)
 *
 * GET  /register → show register.jsp
 * POST /register → validate OTP from session, then create user account
 *
 * OTP flow:
 *   1. User fills form, enters email, clicks "Send OTP" → SendOtpServlet (AJAX)
 *   2. OTP stored in session (otp_code, otp_email, otp_expiry)
 *   3. User enters OTP in modal and submits the full form
 *   4. This servlet verifies OTP matches session before creating account
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RegisterServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        CsrfUtil.ensureToken(req);
        req.getRequestDispatcher("/Views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── CSRF check ────────────────────────────────────────────
        if (!CsrfUtil.isValid(req)) {
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
        String otpInput = trim(req.getParameter("otp"));

        // ── Field validation ──────────────────────────────────────
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

        // ── OTP verification ──────────────────────────────────────
        HttpSession session = req.getSession(false);
        if (session == null) {
            forward(req, resp, "Session expired. Please send the OTP again.");
            return;
        }

        String sessionOtp    = (String) session.getAttribute("otp_code");
        String sessionEmail  = (String) session.getAttribute("otp_email");
        Long   sessionExpiry = (Long)   session.getAttribute("otp_expiry");

        if (otpInput.isEmpty()) {
            forward(req, resp, "Please enter the OTP sent to your email.");
            return;
        }
        if (sessionOtp == null || sessionEmail == null || sessionExpiry == null) {
            forward(req, resp, "OTP not found. Please click 'Send OTP' first.");
            return;
        }
        if (System.currentTimeMillis() > sessionExpiry) {
            // Clear expired OTP
            session.removeAttribute("otp_code");
            session.removeAttribute("otp_email");
            session.removeAttribute("otp_expiry");
            forward(req, resp, "OTP has expired. Please request a new one.");
            return;
        }
        if (!sessionEmail.equalsIgnoreCase(email.trim())) {
            forward(req, resp, "OTP was sent to a different email. Please send OTP to: " + email);
            return;
        }
        if (!sessionOtp.equals(otpInput)) {
            forward(req, resp, "Invalid OTP. Please check the code sent to your email.");
            return;
        }

        // OTP verified — clear from session so it can't be reused
        session.removeAttribute("otp_code");
        session.removeAttribute("otp_email");
        session.removeAttribute("otp_expiry");

        // ── Parse DOB safely ──────────────────────────────────────
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

        // ── Build User object ─────────────────────────────────────
        User user = new User();
        user.setName(name);
        user.setEmail(email.toLowerCase().trim());
        user.setPhone(phone.isEmpty() ? null : phone);
        user.setDob(dob);
        user.setGender(gender.isEmpty() ? null : gender);
        user.setAddress(address.isEmpty() ? null : address);
        user.setRole("USER");
        user.setPassword(password);

        UserDAO dao = new UserDAO();

        if (dao.emailExists(user.getEmail())) {
            forward(req, resp, "An account with this email already exists.");
            return;
        }

        int newId = dao.register(user);

        if (newId > 0) {
            LOG.info("New user registered: " + email + " (id=" + newId + ")");
            EmailService.sendWelcome(user.getEmail(), user.getName());
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } else if (newId == -2) {
            // Duplicate email caught at the DB level (race with emailExists check,
            // or a leftover row from an earlier attempt).
            forward(req, resp, "An account with this email already exists.");
        } else {
            // Genuine DB/SQL failure — details are in the server logs (UserDAO.register).
            forward(req, resp, "Registration failed due to a server error. Please try again shortly, or contact support if it persists.");
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