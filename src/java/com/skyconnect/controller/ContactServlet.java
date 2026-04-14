package com.skyconnect.controller;

import com.skyconnect.service.EmailService;
import com.skyconnect.util.AppConfig;
import com.skyconnect.util.CsrfUtil;
import com.skyconnect.util.DBConnection;
import com.skyconnect.util.HtmlUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;

/**
 * AeroSphere — ContactServlet
 *
 * GET  /contact  → show contact form (contact.jsp)
 * POST /contact  → save message to DB, email admin, show confirmation
 *
 * DB table required (run once):
 *   CREATE TABLE contact_messages (
 *     id            INT AUTO_INCREMENT PRIMARY KEY,
 *     sender_name   VARCHAR(100)  NOT NULL,
 *     sender_email  VARCHAR(150)  NOT NULL,
 *     subject       VARCHAR(200)  NOT NULL,
 *     booking_id    VARCHAR(20)   DEFAULT NULL,
 *     message       TEXT          NOT NULL,
 *     status        ENUM('NEW','REPLIED','DELETED') DEFAULT 'NEW',
 *     admin_reply   TEXT          DEFAULT NULL,
 *     created_at    DATETIME      DEFAULT CURRENT_TIMESTAMP,
 *     replied_at    DATETIME      DEFAULT NULL
 *   );
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(ContactServlet.class.getName());

    // ── GET: show the contact form ────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        CsrfUtil.ensureToken(req);
        req.getRequestDispatcher("/Views/common/contact.jsp").forward(req, resp);
    }

    // ── POST: process form submission ─────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // CSRF validation
        HttpSession session = req.getSession(false);
        if (!CsrfUtil.isValid(req)) {
            resp.sendRedirect(req.getContextPath() + "/contact");
            return;
        }

        // Collect and sanitize inputs
        String senderName  = HtmlUtils.escape(req.getParameter("senderName"));
        String senderEmail = HtmlUtils.escape(req.getParameter("senderEmail"));
        String subject     = HtmlUtils.escape(req.getParameter("subject"));
        String bookingId   = HtmlUtils.escape(req.getParameter("bookingId"));
        String message     = HtmlUtils.escape(req.getParameter("message"));

        // Basic validation
        if (isEmpty(senderName) || isEmpty(senderEmail) || isEmpty(subject) || isEmpty(message)) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/Views/common/contact.jsp").forward(req, resp);
            return;
        }
        if (message.length() > 2000) {
            req.setAttribute("error", "Message must not exceed 2000 characters.");
            req.getRequestDispatcher("/Views/common/contact.jsp").forward(req, resp);
            return;
        }
        if (!senderEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            req.setAttribute("error", "Please enter a valid email address.");
            req.getRequestDispatcher("/Views/common/contact.jsp").forward(req, resp);
            return;
        }

        // Save to DB
        int savedId = saveToDb(senderName, senderEmail, subject, bookingId, message);
        if (savedId <= 0) {
            req.setAttribute("error", "Failed to submit your message. Please try again later.");
            req.getRequestDispatcher("/Views/common/contact.jsp").forward(req, resp);
            return;
        }

        // Email admin (async, fire-and-forget)
        emailAdmin(savedId, senderName, senderEmail, subject, bookingId, message);

        // Success
        req.setAttribute("success",
            "Thank you, " + senderName + "! Your message has been received. " +
            "We'll reply to " + senderEmail + " within 24–48 hours.");
        req.getRequestDispatcher("/Views/common/contact.jsp").forward(req, resp);
    }

    // ── Save message to database ──────────────────────────────────────
    private int saveToDb(String name, String email, String subject,
                         String bookingId, String message) {
        String sql = "INSERT INTO contact_messages " +
                     "(sender_name, sender_email, subject, booking_id, message, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, 'NEW', NOW())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, (bookingId != null && !bookingId.trim().isEmpty()) ? bookingId.trim() : null);
            ps.setString(5, message);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOG.severe("[ContactServlet] DB error saving message: " + e.getMessage());
        }
        return -1;
    }

    // ── Email the admin about the new message ─────────────────────────
    private void emailAdmin(int id, String senderName, String senderEmail,
                            String subject, String bookingId, String message) {
        try {
            AppConfig cfg = AppConfig.get();
            String adminEmail = cfg.getSmtpUser(); // send to the configured SMTP account

            String emailSubject = "[AeroSphere Contact] " + subject +
                                  (bookingId != null && !bookingId.isEmpty() ? " [Booking #" + bookingId + "]" : "") +
                                  " — Message #" + id;

            String bookingRow = (bookingId != null && !bookingId.isEmpty())
                ? "<tr><td style='padding:8px 12px;border:1px solid #e5e7eb;font-weight:600;background:#f9fafb;width:35%'>Booking ID</td>"
                + "<td style='padding:8px 12px;border:1px solid #e5e7eb'>#" + bookingId + "</td></tr>"
                : "";

            String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body style='"
                + "margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;'>"
                + "<div style='max-width:620px;margin:32px auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,.08);'>"
                + "<div style='background:#0EA5E9;padding:24px 32px;'>"
                + "<div style='font-size:22px;color:#fff;font-weight:900;'>✈ AeroSphere — New Contact Message</div>"
                + "</div>"
                + "<div style='padding:28px 32px;'>"
                + "<p style='color:#374151;margin:0 0 16px;font-size:.95rem;'>A new message has been submitted via the Contact Us form.</p>"
                + "<table style='width:100%;border-collapse:collapse;margin:0 0 20px;'>"
                + "<tr><td style='padding:8px 12px;border:1px solid #e5e7eb;font-weight:600;background:#f9fafb;width:35%'>Message ID</td>"
                + "<td style='padding:8px 12px;border:1px solid #e5e7eb'>#" + id + "</td></tr>"
                + "<tr><td style='padding:8px 12px;border:1px solid #e5e7eb;font-weight:600;background:#f9fafb;'>From</td>"
                + "<td style='padding:8px 12px;border:1px solid #e5e7eb'>" + senderName + " &lt;" + senderEmail + "&gt;</td></tr>"
                + "<tr><td style='padding:8px 12px;border:1px solid #e5e7eb;font-weight:600;background:#f9fafb;'>Subject</td>"
                + "<td style='padding:8px 12px;border:1px solid #e5e7eb'>" + subject + "</td></tr>"
                + bookingRow
                + "</table>"
                + "<div style='font-weight:700;font-size:.85rem;text-transform:uppercase;letter-spacing:.04em;color:#6b7280;margin-bottom:8px;'>Message</div>"
                + "<div style='background:#f9fafb;border:1px solid #e5e7eb;border-radius:8px;padding:16px;font-size:.9rem;line-height:1.75;color:#1c1917;white-space:pre-wrap;word-break:break-word;'>"
                + message.replace("<","&lt;").replace(">","&gt;")
                + "</div>"
                + "<div style='margin-top:24px;text-align:center;'>"
                + "<a href='" + cfg.getAppBaseUrl() + "/adminMessages' "
                + "style='background:#0EA5E9;color:#fff;padding:11px 26px;border-radius:8px;text-decoration:none;font-weight:700;font-size:.9rem;'>View &amp; Reply in Admin Panel</a>"
                + "</div>"
                + "</div>"
                + "<div style='background:#f9fafb;padding:14px 32px;border-top:1px solid #e5e7eb;text-align:center;'>"
                + "<p style='color:#9ca3af;font-size:.76rem;margin:0;'>&copy; 2026 AeroSphere. Admin notification — do not reply directly to this email.</p>"
                + "</div></div></body></html>";

            EmailService.sendRaw(adminEmail, emailSubject, html);
        } catch (Exception e) {
            LOG.warning("[ContactServlet] Could not email admin: " + e.getMessage());
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
