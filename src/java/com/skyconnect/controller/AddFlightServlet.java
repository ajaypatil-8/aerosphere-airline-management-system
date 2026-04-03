package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet("/addFlight")
public class AddFlightServlet extends HttpServlet {

    private static final DateTimeFormatter TF = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String flightNo = req.getParameter("flight_no");
        String source = req.getParameter("source");
        String destination = req.getParameter("destination");
        String departDate = req.getParameter("depart_date");
        String departTime = req.getParameter("depart_time");   // expected "HH:mm"
        String arrivalTime = req.getParameter("arrival_time"); // optional
        String priceStr = req.getParameter("price");
        String seatsStr = req.getParameter("seats_total");

        // basic server-side validation
        if (flightNo == null || flightNo.trim().isEmpty()
            || source == null || source.trim().isEmpty()
            || destination == null || destination.trim().isEmpty()
            || departDate == null || departDate.trim().isEmpty()
            || departTime == null || departTime.trim().isEmpty()
            || priceStr == null || priceStr.trim().isEmpty()
            || seatsStr == null || seatsStr.trim().isEmpty()) {

            session.setAttribute("flightError", "Please fill all required fields.");
            resp.sendRedirect(req.getContextPath() + "/addFlight");
            return;
        }

        // parse numbers & times safely
        try (Connection con = DBConnection.getConnection()) {
            // parse depart time (HH:mm)
            Time depSqlTime;
            try {
                LocalTime lt = LocalTime.parse(departTime, TF);
                depSqlTime = Time.valueOf(lt);
            } catch (DateTimeParseException ex) {
                session.setAttribute("flightError", "Invalid departure time. Use HH:mm.");
                resp.sendRedirect(req.getContextPath() + "/addFlight");
                return;
            }

            Time arrSqlTime = null;
            if (arrivalTime != null && !arrivalTime.trim().isEmpty()) {
                try {
                    LocalTime la = LocalTime.parse(arrivalTime, TF);
                    arrSqlTime = Time.valueOf(la);
                } catch (DateTimeParseException ex) {
                    session.setAttribute("flightError", "Invalid arrival time. Use HH:mm.");
                    resp.sendRedirect(req.getContextPath() + "/addFlight");
                    return;
                }
            }

            double price = Double.parseDouble(priceStr);
            int seats = Integer.parseInt(seatsStr);

            String sql = "INSERT INTO flights (flight_no, source, destination, depart_date, depart_time, arrival_time, price, seats_total, seats_available) VALUES (?,?,?,?,?,?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, flightNo.trim());
                ps.setString(2, source.trim());
                ps.setString(3, destination.trim());
                ps.setDate(4, Date.valueOf(departDate));              // ensure HTML date control sends YYYY-MM-DD
                ps.setTime(5, depSqlTime);
                if (arrSqlTime == null) ps.setNull(6, Types.TIME);
                else ps.setTime(6, arrSqlTime);
                ps.setDouble(7, price);
                ps.setInt(8, seats);
                ps.setInt(9, seats);
                int rows = ps.executeUpdate();
                session.setAttribute("flightSuccess", "Flight added successfully.");
            }

            resp.sendRedirect(req.getContextPath() + "/addFlight");
            return;

        } catch (Exception e) {
            e.printStackTrace(); // server log
            session.setAttribute("flightError", "Error adding flight: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/addFlight");
        }
    }
}
