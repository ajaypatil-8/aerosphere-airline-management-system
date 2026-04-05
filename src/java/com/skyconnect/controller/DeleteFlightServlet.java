package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteFlight")
public class DeleteFlightServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/adminFlights");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection con = DBConnection.getConnection()) {
            // Check if flight has active bookings
            PreparedStatement check = con.prepareStatement(
                "SELECT COUNT(*) FROM bookings WHERE flight_id=? AND status != 'CANCELLED'");
            check.setInt(1, id);
            ResultSet rs = check.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                session.setAttribute("deleteError",
                    "Cannot delete flight — it has active bookings.");
                resp.sendRedirect(req.getContextPath() + "/adminFlights");
                return;
            }

            PreparedStatement ps = con.prepareStatement("DELETE FROM flights WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            session.setAttribute("deleteSuccess", "Flight deleted successfully.");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("deleteError", "Error deleting flight: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/adminFlights");
    }
}
