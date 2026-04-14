package com.skyconnect.service;

import com.skyconnect.util.AppConfig;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AeroSphere — EmailService
 *
 * Sends transactional emails (booking confirmation, cancellation, refund, OTP).
 *
 * OTP is sent SYNCHRONOUSLY so errors can be detected and reported to the user.
 * All other sends are ASYNC — fire-and-forget on a background thread.
 *
 * Configuration (via context.xml / AppConfig):
 *   smtp.host     = smtp.gmail.com
 *   smtp.port     = 587
 *   smtp.user     = YOUR_GMAIL@gmail.com
 *   smtp.password = YOUR_APP_PASSWORD_16_CHARS   (no spaces)
 *   smtp.from     = AeroSphere
 */
public class EmailService {

    private static final Logger LOG = Logger.getLogger(EmailService.class.getName());

    // Single background thread for all non-critical async email sending
    private static final ExecutorService EXEC = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "aerosphere-mailer");
        t.setDaemon(true);
        return t;
    });

    private EmailService() {}

    // ─────────────────────────────────────────────────────────────────
    // Public API
    // ─────────────────────────────────────────────────────────────────

    /**
     * OTP verification email for registration.
     *
     * SYNCHRONOUS — blocks until the email is sent (or fails).
     * Returns true on success, false on any failure.
     * Callers should report the failure to the user instead of silently ignoring it.
     */
    public static boolean sendOtp(String toEmail, String otp) {
        String subject = "Your AeroSphere Verification Code: " + otp;
        String body = buildHtml(
            "Email Verification 🔐",
            "Hi there,",
            "You requested a one-time password (OTP) to verify your email address for AeroSphere registration.",
            "<div style='text-align:center;margin:28px 0;'>"
            + "<div style='display:inline-block;background:#f0fdf4;border:2px dashed #10B981;"
            + "border-radius:14px;padding:20px 40px;'>"
            + "<div style='font-size:2.2rem;font-weight:900;letter-spacing:8px;color:#059669;"
            + "font-family:monospace;'>" + otp + "</div>"
            + "<div style='font-size:0.78rem;color:#6b7280;margin-top:6px;'>Valid for 10 minutes</div>"
            + "</div></div>",
            "If you did not request this OTP, please ignore this email. Do not share this code with anyone.",
            "#10B981"
        );

        // OTP is on the critical path — send synchronously so we can report failure
        try {
            doSend(toEmail, subject, body);
            return true;
        } catch (Exception e) {
            LOG.log(Level.SEVERE, "[EmailService] Failed to send OTP to " + toEmail + ": " + e.getMessage(), e);
            return false;
        }
    }

    /** Booking confirmation email */
    public static void sendBookingConfirmation(
            String toEmail, String toName,
            String bookingId, String flightNo,
            String source, String destination,
            String departDate, String departTime,
            int numSeats, double totalAmount) {

        String subject = "✈ Booking Confirmed — " + flightNo + " | AeroSphere #" + bookingId;

        String body = buildHtml(
            "Booking Confirmed! 🎉",
            "Hi " + toName + ",",
            "Your flight has been booked successfully. Here are your booking details:",
            "<table style='width:100%;border-collapse:collapse;margin:16px 0;'>"
            + tableRow("Booking ID",    "#" + bookingId)
            + tableRow("Flight",        flightNo)
            + tableRow("Route",         source + " → " + destination)
            + tableRow("Date",          departDate)
            + tableRow("Time",          departTime)
            + tableRow("Seats",         String.valueOf(numSeats))
            + tableRow("Amount Paid",   "₹" + String.format("%,.2f", totalAmount))
            + "</table>",
            "Thank you for choosing AeroSphere. Have a great flight!",
            "#10B981"
        );

        sendAsync(toEmail, subject, body);
    }

    /** Cancellation notification email */
    public static void sendCancellationNotice(
            String toEmail, String toName,
            String bookingId, String flightNo,
            String source, String destination,
            String departDate, double refundAmount, String refundPolicy) {

        String subject = "Booking Cancelled — #" + bookingId + " | AeroSphere";

        String body = buildHtml(
            "Booking Cancelled",
            "Hi " + toName + ",",
            "Your booking has been cancelled. Here's a summary:",
            "<table style='width:100%;border-collapse:collapse;margin:16px 0;'>"
            + tableRow("Booking ID",    "#" + bookingId)
            + tableRow("Flight",        flightNo)
            + tableRow("Route",         source + " → " + destination)
            + tableRow("Date",          departDate)
            + tableRow("Refund Amount", "₹" + String.format("%,.2f", refundAmount))
            + tableRow("Refund Policy", refundPolicy)
            + "</table>",
            "Your refund request has been submitted and will be processed by our admin team within 3-5 business days.",
            "#EF4444"
        );

        sendAsync(toEmail, subject, body);
    }

    /** Refund approved/rejected notification */
    public static void sendRefundUpdate(
            String toEmail, String toName,
            String bookingId, double refundAmount, boolean approved) {

        String subject = approved
            ? "✅ Refund Approved — ₹" + String.format("%,.2f", refundAmount) + " | AeroSphere"
            : "Refund Update — Booking #" + bookingId + " | AeroSphere";

        String headline = approved ? "Refund Approved ✅" : "Refund Update";
        String message  = approved
            ? "Great news! Your refund of <strong>₹" + String.format("%,.2f", refundAmount) +
              "</strong> for booking <strong>#" + bookingId + "</strong> has been approved. " +
              "The amount will be credited to your original payment method within 5-7 business days."
            : "We're unable to process the refund for booking <strong>#" + bookingId +
              "</strong> at this time. Please contact our support team if you have any questions.";

        String color = approved ? "#10B981" : "#F59E0B";

        String body = buildHtml(
            headline,
            "Hi " + toName + ",",
            message,
            "",
            "Thank you for flying with AeroSphere.",
            color
        );

        sendAsync(toEmail, subject, body);
    }

    /** Registration welcome email */
    public static void sendWelcome(String toEmail, String toName) {
        String subject = "Welcome to AeroSphere ✈";
        String body = buildHtml(
            "Welcome aboard, " + toName + "! ✈",
            "Hi " + toName + ",",
            "Your AeroSphere account has been created successfully. You can now search and book flights across India with ease.",
            "<div style='text-align:center;margin:24px 0;'>"
            + "<a href='http://localhost:8080/airline/searchFlights' "
            + "style='background:#10B981;color:#fff;padding:12px 28px;border-radius:8px;"
            + "text-decoration:none;font-weight:700;font-size:1rem;'>Search Flights</a></div>",
            "Safe travels!",
            "#10B981"
        );
        sendAsync(toEmail, subject, body);
    }

    /**
     * Send a raw HTML email asynchronously.
     * Used by ContactServlet to notify the admin of a new contact message.
     */
    public static void sendRaw(String toEmail, String subject, String htmlBody) {
        sendAsync(toEmail, subject, htmlBody);
    }

    /**
     * Send a raw HTML email SYNCHRONOUSLY.
     * Used by AdminMessagesServlet to reply to users — returns true on success.
     */
    public static boolean sendRawSync(String toEmail, String subject, String htmlBody) {
        try {
            doSend(toEmail, subject, htmlBody);
            return true;
        } catch (Exception e) {
            LOG.log(Level.WARNING, "[EmailService] sendRawSync failed to " + toEmail + ": " + e.getMessage(), e);
            return false;
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // Internal helpers
    // ─────────────────────────────────────────────────────────────────

    private static void sendAsync(String to, String subject, String htmlBody) {
        EXEC.submit(() -> {
            try {
                doSend(to, subject, htmlBody);
            } catch (Exception e) {
                LOG.log(Level.WARNING, "[EmailService] Failed to send email to " + to + ": " + e.getMessage(), e);
            }
        });
    }

    private static void doSend(String to, String subject, String htmlBody)
            throws MessagingException, java.io.UnsupportedEncodingException {
        AppConfig cfg = AppConfig.get();

        if (!cfg.isSmtpConfigured()) {
            LOG.info("[EmailService] SMTP not configured — skipping email to " + to);
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth",                "true");
        props.put("mail.smtp.starttls.enable",     "true");
        props.put("mail.smtp.starttls.required",   "true");   // FIX: enforce STARTTLS, don't allow plaintext fallback
        props.put("mail.smtp.ssl.trust",           cfg.getSmtpHost()); // FIX: trust Gmail's SSL cert to prevent handshake failure
        props.put("mail.smtp.host",                cfg.getSmtpHost());
        props.put("mail.smtp.port",                String.valueOf(cfg.getSmtpPort()));
        props.put("mail.smtp.connectiontimeout",   "15000");  // FIX: was 5000 — too short for Gmail
        props.put("mail.smtp.timeout",             "15000");  // FIX: was 5000
        props.put("mail.smtp.writetimeout",        "15000");  // FIX: was missing entirely

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(cfg.getSmtpUser(), cfg.getSmtpPassword());
            }
        });

        // Uncomment the line below to see detailed SMTP handshake logs in Tomcat console (useful for debugging)
        // session.setDebug(true);

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(cfg.getSmtpUser(), cfg.getSmtpFrom()));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setContent(htmlBody, "text/html; charset=UTF-8");

        Transport.send(msg);
        LOG.info("[EmailService] Sent '" + subject + "' to " + to);
    }

    private static String tableRow(String label, String value) {
        return "<tr>"
            + "<td style='padding:8px 12px;border:1px solid #e5e7eb;font-weight:600;"
            + "background:#f9fafb;color:#374151;width:40%;'>" + label + "</td>"
            + "<td style='padding:8px 12px;border:1px solid #e5e7eb;color:#1c1917;'>" + value + "</td>"
            + "</tr>";
    }

    private static String buildHtml(
            String headline, String greeting, String message,
            String contentBlock, String footer, String accentColor) {

        return "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body style='"
            + "margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;'>"
            + "<div style='max-width:600px;margin:32px auto;background:#ffffff;"
            + "border-radius:12px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,.08);'>"

            // Header
            + "<div style='background:" + accentColor + ";padding:28px 32px;text-align:center;'>"
            + "<div style='font-size:28px;color:#fff;font-weight:900;letter-spacing:-1px;'>"
            + "✈ AeroSphere</div></div>"

            // Body
            + "<div style='padding:32px;'>"
            + "<h2 style='margin:0 0 8px;color:#1c1917;font-size:1.4rem;'>" + headline + "</h2>"
            + "<p style='color:#6b7280;margin:0 0 20px;'>" + greeting + "</p>"
            + "<p style='color:#374151;line-height:1.6;margin:0 0 16px;'>" + message + "</p>"
            + contentBlock
            + "<p style='color:#6b7280;font-size:.9rem;margin:24px 0 0;'>" + footer + "</p>"
            + "</div>"

            // Footer
            + "<div style='background:#f9fafb;padding:16px 32px;border-top:1px solid #e5e7eb;"
            + "text-align:center;'>"
            + "<p style='color:#9ca3af;font-size:.78rem;margin:0;'>"
            + "&copy; 2026 AeroSphere. All rights reserved.</p></div>"

            + "</div></body></html>";
    }
}