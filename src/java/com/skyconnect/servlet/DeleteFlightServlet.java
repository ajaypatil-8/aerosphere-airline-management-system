package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/deleteFlight")
public class DeleteFlightServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {

            // 🔒 Check seats condition
            String checkSql =
                "SELECT seats_total, seats_available FROM flights WHERE id=?";
            PreparedStatement ps = con.prepareStatement(checkSql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                resp.sendRedirect("adminFlights");
                return;
            }

            int total = rs.getInt("seats_total");
            int available = rs.getInt("seats_available");

            // ❌ Do NOT delete if seats booked
            if (total != available) {
                resp.sendRedirect("adminFlights?error=booked");
                return;
            }

            // ✅ Safe to delete
            String delSql = "DELETE FROM flights WHERE id=?";
            ps = con.prepareStatement(delSql);
            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("adminFlights");
    }
}