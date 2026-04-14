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
import java.util.*;
import java.util.logging.Logger;

/**
 * AeroSphere — AdminMessagesServlet
 *
 * GET  /adminMessages          → list all contact messages
 * POST /adminMessages (reply)  → send email reply to user, mark message as REPLIED
 * POST /adminMessages (delete) → delete a message
 */
@WebServlet("/adminMessages")
public class AdminMessagesServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(AdminMessagesServlet.class.getName());

    // ── GET: list messages ────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Map<String, Object>> messages = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT id, sender_name, sender_email, subject, booking_id, " +
                         "message, status, admin_reply, created_at, replied_at " +
                         "FROM contact_messages " +
                         "WHERE status != 'DELETED' " +
                         "ORDER BY FIELD(status,'NEW','REPLIED'), created_at DESC";

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("id",           rs.getInt("id"));
                    row.put("sender_name",  rs.getString("sender_name"));
                    row.put("sender_email", rs.getString("sender_email"));
                    row.put("subject",      rs.getString("subject"));
                    row.put("booking_id",   rs.getString("booking_id"));
                    row.put("message",      rs.getString("message"));
                    row.put("status",       rs.getString("status"));
                    row.put("admin_reply",  rs.getString("admin_reply"));
                    row.put("created_at",   rs.getString("created_at"));
                    row.put("replied_at",   rs.getString("replied_at"));
                    messages.add(row);
                }
            }

            // Badge count for sidebar: count unread messages
            int pendingMessages = 0;
            for (Map<String, Object> m : messages) {
                if ("NEW".equals(m.get("status"))) pendingMessages++;
            }
            req.setAttribute("pendingMessages", pendingMessages);

        } catch (SQLException e) {
            LOG.severe("[AdminMessages] DB error: " + e.getMessage());
            req.setAttribute("error", "Failed to load messages: " + e.getMessage());
        }

        req.setAttribute("messages", messages);
        CsrfUtil.ensureToken(req);
        req.getRequestDispatcher("/Views/admin/admin_messages.jsp").forward(req, resp);
    }

    // ── POST: reply or delete ─────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!CsrfUtil.isValid(req)) {
            resp.sendRedirect(req.getContextPath() + "/adminMessages");
            return;
        }

        String action    = req.getParameter("action");
        String msgIdStr  = req.getParameter("messageId");

        if (msgIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/adminMessages");
            return;
        }

        int messageId;
        try { messageId = Integer.parseInt(msgIdStr); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/adminMessages");
            return;
        }

        if ("reply".equals(action)) {
            handleReply(req, resp, messageId);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp, messageId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/adminMessages");
        }
    }

    // ── Reply to user via email ───────────────────────────────────────
    private void handleReply(HttpServletRequest req, HttpServletResponse resp, int messageId)
            throws ServletException, IOException {

        String replyTo        = req.getParameter("replyTo");
        String senderName     = req.getParameter("senderName");
        String originalSubject= req.getParameter("originalSubject");
        String replyText      = HtmlUtils.escape(req.getParameter("replyText"));

        if (isEmpty(replyText)) {
            req.setAttribute("error", "Reply message cannot be empty.");
            doGet(req, resp);
            return;
        }
        if (isEmpty(replyTo) || !replyTo.contains("@")) {
            req.setAttribute("error", "Invalid recipient email.");
            doGet(req, resp);
            return;
        }

        // Build email HTML
        String emailSubject = "Re: " + originalSubject + " — AeroSphere Support";
        AppConfig cfg = AppConfig.get();

        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body style='"
            + "margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;'>"
            + "<div style='max-width:620px;margin:32px auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,.08);'>"
            + "<div style='background:#10B981;padding:24px 32px;'>"
            + "<div style='font-size:22px;color:#fff;font-weight:900;'>✈ AeroSphere Support</div>"
            + "</div>"
            + "<div style='padding:32px;'>"
            + "<h2 style='margin:0 0 10px;color:#1c1917;font-size:1.2rem;'>Reply to your message</h2>"
            + "<p style='color:#6b7280;margin:0 0 20px;font-size:.9rem;'>Hi " + senderName + ",</p>"
            + "<p style='color:#6b7280;margin:0 0 16px;font-size:.88rem;'>Regarding your query: <em>\"" + originalSubject + "\"</em></p>"
            + "<div style='background:#f0fdf4;border:1px solid #86efac;border-left:4px solid #10B981;border-radius:8px;padding:20px;margin-bottom:24px;font-size:.9rem;line-height:1.75;color:#1c1917;white-space:pre-wrap;word-break:break-word;'>"
            + replyText.replace("<","&lt;").replace(">","&gt;")
            + "</div>"
            + "<p style='color:#6b7280;font-size:.85rem;margin:0;'>If you have any further questions, please reply to this email or visit our "
            + "<a href='" + cfg.getAppBaseUrl() + "/contact' style='color:#10B981;'>Contact Us</a> page.</p>"
            + "<p style='color:#6b7280;font-size:.85rem;margin-top:8px;'>Safe travels,<br><strong>AeroSphere Support Team</strong></p>"
            + "</div>"
            + "<div style='background:#f9fafb;padding:14px 32px;border-top:1px solid #e5e7eb;text-align:center;'>"
            + "<p style='color:#9ca3af;font-size:.76rem;margin:0;'>&copy; 2026 AeroSphere. All rights reserved.</p>"
            + "</div></div></body></html>";

        // Send email
        boolean sent = EmailService.sendRawSync(replyTo, emailSubject, html);

        if (!sent) {
            req.setAttribute("error", "Failed to send reply email. Please check SMTP configuration.");
            doGet(req, resp);
            return;
        }

        // Update DB: mark as REPLIED, store reply text
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE contact_messages SET status='REPLIED', admin_reply=?, replied_at=NOW() WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, replyText);
                ps.setInt(2, messageId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            LOG.severe("[AdminMessages] DB error marking replied: " + e.getMessage());
        }

        req.setAttribute("success", "Reply sent to " + replyTo + " successfully.");
        doGet(req, resp);
    }

    // ── Delete a message (soft delete) ────────────────────────────────
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, int messageId)
            throws ServletException, IOException {

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE contact_messages SET status='DELETED' WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, messageId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            LOG.severe("[AdminMessages] DB error deleting message: " + e.getMessage());
            req.setAttribute("error", "Failed to delete message.");
            doGet(req, resp);
            return;
        }

        req.setAttribute("success", "Message deleted.");
        doGet(req, resp);
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
