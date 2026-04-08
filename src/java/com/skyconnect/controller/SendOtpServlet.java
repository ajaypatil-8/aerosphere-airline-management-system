package com.skyconnect.controller;

import com.skyconnect.dao.UserDAO;
import com.skyconnect.service.EmailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import java.util.logging.Logger;


@WebServlet("/sendOtp")
public class SendOtpServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(SendOtpServlet.class.getName());

    // OTP is valid for 10 minutes
    private static final long OTP_VALIDITY_MS = 10 * 60 * 1000L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            out.print("{\"success\":false,\"error\":\"Email is required.\"}");
            return;
        }

        email = email.trim().toLowerCase();

        // Basic email format check
        if (!email.matches("^[\\w.+-]+@[\\w-]+\\.[\\w.]{2,}$")) {
            out.print("{\"success\":false,\"error\":\"Please enter a valid email address.\"}");
            return;
        }

        // Check if email already registered
        UserDAO dao = new UserDAO();
        if (dao.emailExists(email)) {
            out.print("{\"success\":false,\"error\":\"An account with this email already exists.\"}");
            return;
        }

        // Generate 6-digit OTP
        String otp    = String.format("%06d", new Random().nextInt(1000000));
        long   expiry = System.currentTimeMillis() + OTP_VALIDITY_MS;

        // Store in session BEFORE sending so it's available even if send is retried
        HttpSession session = req.getSession(true);
        session.setAttribute("otp_code",   otp);
        session.setAttribute("otp_email",  email);
        session.setAttribute("otp_expiry", expiry);

        LOG.info("[SendOtpServlet] Attempting to send OTP to " + email);

        boolean sent = EmailService.sendOtp(email, otp);

        if (!sent) {
            session.removeAttribute("otp_code");
            session.removeAttribute("otp_email");
            session.removeAttribute("otp_expiry");

            LOG.warning("[SendOtpServlet] Failed to send OTP email to " + email);
            out.print("{\"success\":false,\"error\":\"Failed to send OTP email. Please check your email address or try again in a moment.\"}");
            return;
        }

        LOG.info("[SendOtpServlet] OTP sent successfully to " + email);
        out.print("{\"success\":true,\"message\":\"OTP sent to your email. Valid for 10 minutes.\"}");
    }
}