package com.skyconnect.controller;

import com.skyconnect.service.PdfInvoiceService;
import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * AeroSphere — InvoiceServlet (UPDATED)
 *
 * GET /invoice?bookingId=X          → show invoice.jsp (existing behaviour)
 * GET /invoice?bookingId=X&download=true → stream PDF download
 *
 * Backend logic is IDENTICAL to the original — only PDF download is added.
 */
@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(InvoiceServlet.class.getName());

    // ── Inner class (unchanged from original) ──────────────────────
    public static class Passenger {
        public String name;
        public int    age;
        public String gender;
        public String seatNo;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");

        // Allow admin to view any invoice; users only see their own
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;
        boolean isAdmin = "ADMIN".equals(userRole);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idParam = req.getParameter("bookingId");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/userBookings");
            return;
        }

        int bookingId;
        try { bookingId = Integer.parseInt(idParam); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/userBookings");
            return;
        }

        boolean download = "true".equals(req.getParameter("download"));

        try (Connection con = DBConnection.getConnection()) {

            // ── 1. Load booking + user + flight ───────────────────
            String sql = isAdmin
                ? "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                  "u.name, u.email, " +
                  "f.flight_no, f.source, f.destination, " +
                  "f.depart_date, f.depart_time, f.arrival_time " +
                  "FROM bookings b " +
                  "JOIN users u ON b.user_id = u.id " +
                  "JOIN flights f ON b.flight_id = f.id " +
                  "WHERE b.id = ?"
                : "SELECT b.id, b.num_seats, b.total_amount, b.status, b.payment_status, " +
                  "u.name, u.email, " +
                  "f.flight_no, f.source, f.destination, " +
                  "f.depart_date, f.depart_time, f.arrival_time " +
                  "FROM bookings b " +
                  "JOIN users u ON b.user_id = u.id " +
                  "JOIN flights f ON b.flight_id = f.id " +
                  "WHERE b.id = ? AND b.user_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            if (!isAdmin) ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect(req.getContextPath() + "/userBookings");
                return;
            }

            String userName    = rs.getString("name");
            String userEmail   = rs.getString("email");
            String flightNo    = rs.getString("flight_no");
            String source      = rs.getString("source");
            String destination = rs.getString("destination");
            String departDate  = rs.getString("depart_date");
            String departTime  = rs.getString("depart_time");
            String arrivalTime = rs.getString("arrival_time");
            int    numSeats    = rs.getInt("num_seats");
            double baseAmount  = rs.getDouble("total_amount");
            String status      = rs.getString("status");
            String paymentStatus = rs.getString("payment_status");

            double gst         = baseAmount * 0.05;
            double totalAmount = baseAmount + gst;

            // ── 2. Load payment info ─────────────────────────────
            String psql = "SELECT amount, payment_method, payment_status " +
                          "FROM payments WHERE booking_id=? ORDER BY payment_date DESC LIMIT 1";
            PreparedStatement ps2 = con.prepareStatement(psql);
            ps2.setInt(1, bookingId);
            ResultSet prs = ps2.executeQuery();

            double paidAmount   = totalAmount;
            String paymentMethod = "—";
            if (prs.next()) {
                paidAmount     = prs.getDouble("amount");
                paymentMethod  = prs.getString("payment_method");
            }

            // ── 3. Load passengers ────────────────────────────────
            String passql = "SELECT full_name, age, gender, seat_no " +
                            "FROM passengers WHERE booking_id=? ORDER BY id";
            PreparedStatement ps3 = con.prepareStatement(passql);
            ps3.setInt(1, bookingId);
            ResultSet pssr = ps3.executeQuery();

            List<Passenger> passengers = new ArrayList<>();
            List<PdfInvoiceService.PassengerRow> pdfPassengers = new ArrayList<>();
            while (pssr.next()) {
                Passenger p = new Passenger();
                p.name   = pssr.getString("full_name");
                p.age    = pssr.getInt("age");
                p.gender = pssr.getString("gender");
                p.seatNo = pssr.getString("seat_no");
                passengers.add(p);
                pdfPassengers.add(new PdfInvoiceService.PassengerRow(p.name, p.age, p.gender, p.seatNo));
            }

            // ── 4. PDF download branch ────────────────────────────
            if (download) {
                String filename = "AeroSphere_Invoice_" + String.format("%06d", bookingId) + ".pdf";
                resp.setContentType("application/pdf");
                resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                resp.setHeader("Cache-Control", "no-cache");

                PdfInvoiceService.generate(
                    resp.getOutputStream(),
                    bookingId, userName, userEmail,
                    flightNo, source, destination,
                    departDate, departTime, arrivalTime,
                    numSeats, baseAmount, gst, paidAmount,
                    paymentMethod, pdfPassengers
                );
                return; // Don't forward to JSP
            }

            // ── 5. Normal JSP render (original behaviour) ─────────
            req.setAttribute("bookingId",     bookingId);
            req.setAttribute("userName",      userName);
            req.setAttribute("userEmail",     userEmail);
            req.setAttribute("flightNo",      flightNo);
            req.setAttribute("source",        source);
            req.setAttribute("destination",   destination);
            req.setAttribute("departDate",    departDate);
            req.setAttribute("departTime",    departTime);
            req.setAttribute("arrivalTime",   arrivalTime);
            req.setAttribute("seats",         numSeats);
            req.setAttribute("amount",        baseAmount);
            req.setAttribute("gst",           gst);
            req.setAttribute("totalAmount",   totalAmount);
            req.setAttribute("paidAmount",    paidAmount);
            req.setAttribute("paymentMethod", paymentMethod);
            req.setAttribute("paymentStatus", paymentStatus);
            req.setAttribute("status",        status);
            req.setAttribute("passengers",    passengers);

            req.getRequestDispatcher("/Views/user/invoice.jsp").forward(req, resp);

        } catch (Exception e) {
            LOG.severe("InvoiceServlet error for booking " + bookingId + ": " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/userBookings");
        }
    }
}
