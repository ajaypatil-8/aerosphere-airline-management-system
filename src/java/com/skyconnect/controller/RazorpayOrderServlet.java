package com.skyconnect.controller;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.skyconnect.util.AppConfig;
import com.skyconnect.util.DBConnection;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Logger;

@WebServlet("/createRazorpayOrder")
public class RazorpayOrderServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RazorpayOrderServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // ── Auth check ────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");
        if (userId == null) {
            resp.setStatus(401);
            out.print("{\"error\":\"Not logged in\"}");
            return;
        }

        // ── Parse bookingId ───────────────────────────────────────
        String bookingIdParam = req.getParameter("bookingId");
        if (bookingIdParam == null) {
            resp.setStatus(400);
            out.print("{\"error\":\"Missing bookingId\"}");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            resp.setStatus(400);
            out.print("{\"error\":\"Invalid bookingId\"}");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            // Fetch booking
            String sql = "SELECT total_amount, payment_status FROM bookings WHERE id=? AND user_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.setStatus(404);
                out.print("{\"error\":\"Booking not found\"}");
                return;
            }

            if ("PAID".equals(rs.getString("payment_status"))) {
                resp.setStatus(400);
                out.print("{\"error\":\"Already paid\"}");
                return;
            }

            double baseAmount = rs.getDouble("total_amount");
            double gst = baseAmount * 0.05;
            double finalAmount = baseAmount + gst;

            long amountPaise = Math.round(finalAmount * 100);

            // ── Config ─────────────────────────────────────────────
            AppConfig cfg = AppConfig.get();

            // Safety check
            if (!cfg.isRazorpayConfigured()) {
                resp.setStatus(500);
                out.print("{\"error\":\"Razorpay not configured\"}");
                return;
            }

            // ── Razorpay Client ────────────────────────────────────
            RazorpayClient razorpay = new RazorpayClient(
                    cfg.getRazorpayKeyId(),
                    cfg.getRazorpayKeySecret()
            );

            // ── Create Order (FIXED) ───────────────────────────────
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountPaise);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "booking_" + bookingId);

            // ❌ REMOVED: payment_capture (causing failure)

            Order order = razorpay.orders.create(orderRequest);
            String razorpayOrderId = order.get("id");

            // ── Save order ID ──────────────────────────────────────
            PreparedStatement upd = con.prepareStatement(
                    "UPDATE bookings SET razorpay_order_id=? WHERE id=?");
            upd.setString(1, razorpayOrderId);
            upd.setInt(2, bookingId);
            upd.executeUpdate();

            // ── Response ───────────────────────────────────────────
            JSONObject response = new JSONObject();
            response.put("orderId", razorpayOrderId);
            response.put("amount", amountPaise);
            response.put("currency", "INR");
            response.put("keyId", cfg.getRazorpayKeyId());

            out.print(response.toString());

            LOG.info("Razorpay order created: " + razorpayOrderId + " for booking #" + bookingId);

        } catch (Exception e) {
            e.printStackTrace(); // 🔥 full debug

            resp.setStatus(500);
            out.print("{\"error\":\"" + e.getClass().getName() + ": "
                    + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}