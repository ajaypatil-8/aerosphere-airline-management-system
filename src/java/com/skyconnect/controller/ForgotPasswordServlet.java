package com.skyconnect.controller;

import com.skyconnect.dao.UserDAO;
import com.skyconnect.model.User;
import com.skyconnect.service.EmailService;
import com.skyconnect.util.CsrfUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Random;
import java.util.logging.Logger;

/**
 * Handles /forgotPassword
 *
 * GET  → show choose-method page (step=choose)
 * POST action=sendOtp      → send OTP email, redirect to step=otp
 * POST action=verifyOtp    → verify OTP, redirect to step=newpass
 * POST action=resetPassword→ reset password via OTP flow, redirect to step=success
 * POST action=useOldPass   → show old-password form (step=oldpass)
 * POST action=changeWithOld→ change password using old password
 * GET  resend=1            → resend OTP
 */
@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private static final long OTP_VALIDITY_MS = 10 * 60 * 1000L; // 10 min

    private static final String VIEW = "/Views/auth/forgot_password.jsp";

    // ── GET ───────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Resend OTP shortcut: /forgotPassword?resend=1&email=xxx
        String resend = req.getParameter("resend");
        if ("1".equals(resend)) {
            String email = req.getParameter("email");
            if (email != null && !email.trim().isEmpty()) {
                sendOtp(req, resp, email.trim().toLowerCase());
                return;
            }
        }

        // Default: show the choose-method page
        req.setAttribute("step", "choose");
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── POST ──────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // CSRF check
        if (!CsrfUtil.isValid(req)) {
            req.setAttribute("step", "choose");
            req.setAttribute("error", "Invalid request. Please try again.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "sendOtp":
                handleSendOtp(req, resp);
                break;
            case "verifyOtp":
                handleVerifyOtp(req, resp);
                break;
            case "resetPassword":
                handleResetPassword(req, resp);
                break;
            case "useOldPass":
                handleUseOldPass(req, resp);
                break;
            case "changeWithOld":
                handleChangeWithOld(req, resp);
                break;
            default:
                req.setAttribute("step", "choose");
                req.getRequestDispatcher(VIEW).forward(req, resp);
        }
    }

    // ── action=sendOtp ────────────────────────────────────────────────
    private void handleSendOtp(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("step", "choose");
            req.setAttribute("error", "Please enter your email address.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }
        sendOtp(req, resp, email.trim().toLowerCase());
    }

    /** Shared logic: generate OTP, send email, forward to otp step */
    private void sendOtp(HttpServletRequest req, HttpServletResponse resp, String email)
            throws ServletException, IOException {

        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);
        if (user == null) {
            // Don't reveal whether the account exists — just say "if registered, OTP was sent"
            req.setAttribute("step", "otp");
            req.setAttribute("email", email);
            req.setAttribute("success", "If that email is registered, an OTP has been sent.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        long expiry = System.currentTimeMillis() + OTP_VALIDITY_MS;

        HttpSession session = req.getSession(true);
        session.setAttribute("fp_otp",    otp);
        session.setAttribute("fp_email",  email);
        session.setAttribute("fp_expiry", expiry);

        LOG.info("[ForgotPasswordServlet] Sending OTP to " + email);

        boolean sent = EmailService.sendRawSync(
            email,
            "Your AeroSphere Password Reset Code: " + otp,
            buildOtpEmail(user.getName(), otp)
        );

        if (!sent) {
            session.removeAttribute("fp_otp");
            session.removeAttribute("fp_email");
            session.removeAttribute("fp_expiry");
            req.setAttribute("step", "choose");
            req.setAttribute("error", "Failed to send OTP email. Please try again.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        req.setAttribute("step", "otp");
        req.setAttribute("email", email);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── action=verifyOtp ──────────────────────────────────────────────
    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String otp   = req.getParameter("otp");

        HttpSession session = req.getSession(false);
        String storedOtp    = session != null ? (String) session.getAttribute("fp_otp")    : null;
        String storedEmail  = session != null ? (String) session.getAttribute("fp_email")  : null;
        Long   expiry       = session != null ? (Long)   session.getAttribute("fp_expiry") : null;

        if (storedOtp == null || storedEmail == null || expiry == null) {
            req.setAttribute("step", "choose");
            req.setAttribute("error", "Session expired. Please start over.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (System.currentTimeMillis() > expiry) {
            session.removeAttribute("fp_otp");
            req.setAttribute("step", "otp");
            req.setAttribute("email", email != null ? email : storedEmail);
            req.setAttribute("error", "OTP has expired. Please request a new one.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (!storedOtp.equals(otp) || !storedEmail.equalsIgnoreCase(email)) {
            req.setAttribute("step", "otp");
            req.setAttribute("email", storedEmail);
            req.setAttribute("error", "Invalid OTP. Please try again.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        // Mark OTP as verified (remove it so it can't be reused)
        session.removeAttribute("fp_otp");
        session.setAttribute("fp_verified", true);

        req.setAttribute("step", "newpass");
        req.setAttribute("email", storedEmail);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── action=resetPassword ──────────────────────────────────────────
    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String newPw    = req.getParameter("newPassword");
        String confirmPw= req.getParameter("confirmPassword");

        HttpSession session = req.getSession(false);
        Boolean verified = session != null ? (Boolean) session.getAttribute("fp_verified") : null;
        String storedEmail = session != null ? (String) session.getAttribute("fp_email") : null;

        if (verified == null || !verified || storedEmail == null) {
            req.setAttribute("step", "choose");
            req.setAttribute("error", "Session expired or OTP not verified. Please start over.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (!storedEmail.equalsIgnoreCase(email)) {
            req.setAttribute("step", "choose");
            req.setAttribute("error", "Email mismatch. Please start over.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (newPw == null || newPw.length() < 8) {
            req.setAttribute("step", "newpass");
            req.setAttribute("email", storedEmail);
            req.setAttribute("error", "Password must be at least 8 characters.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (!newPw.equals(confirmPw)) {
            req.setAttribute("step", "newpass");
            req.setAttribute("email", storedEmail);
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        UserDAO dao = new UserDAO();
        boolean ok = dao.resetPasswordByEmail(storedEmail, newPw);

        if (!ok) {
            req.setAttribute("step", "newpass");
            req.setAttribute("email", storedEmail);
            req.setAttribute("error", "Failed to update password. Please try again.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        // Clean session
        session.removeAttribute("fp_verified");
        session.removeAttribute("fp_email");
        session.removeAttribute("fp_expiry");

        req.setAttribute("step", "success");
        req.setAttribute("success", "Password reset successfully! You can now sign in with your new password.");
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── action=useOldPass ────────────────────────────────────────────
    private void handleUseOldPass(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("step", "oldpass");
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── action=changeWithOld ──────────────────────────────────────────
    private void handleChangeWithOld(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email     = req.getParameter("email");
        String oldPw     = req.getParameter("oldPassword");
        String newPw     = req.getParameter("newPassword");
        String confirmPw = req.getParameter("confirmPassword");

        if (email == null || oldPw == null || newPw == null) {
            req.setAttribute("step", "oldpass");
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (newPw.length() < 8) {
            req.setAttribute("step", "oldpass");
            req.setAttribute("error", "New password must be at least 8 characters.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        if (!newPw.equals(confirmPw)) {
            req.setAttribute("step", "oldpass");
            req.setAttribute("error", "New passwords do not match.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        UserDAO dao = new UserDAO();
        boolean ok = dao.changePasswordByEmail(email.trim().toLowerCase(), oldPw, newPw);

        if (!ok) {
            req.setAttribute("step", "oldpass");
            req.setAttribute("error", "Incorrect email or password. Please try again.");
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        req.setAttribute("step", "success");
        req.setAttribute("success", "Password changed successfully! You can now sign in with your new password.");
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── Email template ────────────────────────────────────────────────
    private String buildOtpEmail(String name, String otp) {
        return "<!DOCTYPE html><html><body style='font-family:DM Sans,sans-serif;background:#F0F9FF;padding:40px 20px'>"
            + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 8px 32px rgba(0,0,0,.08)'>"
            + "<div style='height:4px;background:linear-gradient(135deg,#0EA5E9,#10B981)'></div>"
            + "<div style='padding:36px 32px'>"
            + "<div style='font-size:2rem;margin-bottom:16px'>🔑</div>"
            + "<h2 style='font-family:Syne,sans-serif;font-size:1.4rem;font-weight:800;margin:0 0 8px'>Password Reset Request</h2>"
            + "<p style='color:#64748B;font-size:.9rem;margin:0 0 28px'>Hi " + name + ", use the code below to reset your password. Valid for 10 minutes.</p>"
            + "<div style='text-align:center;margin:0 0 28px'>"
            + "<div style='display:inline-block;background:#f0fdf4;border:2px dashed #10B981;border-radius:14px;padding:20px 40px'>"
            + "<div style='font-size:2.2rem;font-weight:900;letter-spacing:10px;color:#0F172A'>" + otp + "</div>"
            + "</div></div>"
            + "<p style='color:#94A3B8;font-size:.8rem;margin:0'>If you didn't request this, ignore this email. Your password remains unchanged.</p>"
            + "</div></div></body></html>";
    }
}
