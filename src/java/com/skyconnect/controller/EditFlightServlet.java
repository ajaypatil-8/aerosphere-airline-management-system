package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editFlight")
public class EditFlightServlet extends HttpServlet {

    // ================= LOAD FORM =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM flights WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect(req.getContextPath() + "/adminFlights");
                return;
            }

            req.setAttribute("id", id);
            req.setAttribute("flightNo", rs.getString("flight_no"));
            req.setAttribute("source", rs.getString("source"));
            req.setAttribute("destination", rs.getString("destination"));
            req.setAttribute("date", rs.getDate("depart_date"));
            req.setAttribute("departTime", rs.getTime("depart_time"));
            req.setAttribute("arrivalTime", rs.getTime("arrival_time"));
            req.setAttribute("price", rs.getDouble("price"));
            req.setAttribute("totalSeats", rs.getInt("seats_total"));
            req.setAttribute("availableSeats", rs.getInt("seats_available"));

            req.getRequestDispatcher("/Views/admin/admin_edit_flight.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/adminFlights");
        }
    }

    // ================= UPDATE FLIGHT =================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String date = req.getParameter("depart_date");
        String depart = req.getParameter("depart_time");
        String arrival = req.getParameter("arrival_time");
        double price = Double.parseDouble(req.getParameter("price"));

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "UPDATE flights SET depart_date=?, depart_time=?, arrival_time=?, price=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(date));
            ps.setTime(2, Time.valueOf(depart));
            ps.setTime(3, Time.valueOf(arrival));
            ps.setDouble(4, price);
            ps.setInt(5, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/adminFlights");
    }
}