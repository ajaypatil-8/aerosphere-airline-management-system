
package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/addPassengers")
public class AddPassengerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingIdStr = req.getParameter("bookingId");
        if (bookingIdStr == null) {
            resp.sendRedirect("userBookings");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT num_seats FROM bookings WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int seats = rs.getInt("num_seats");

                req.setAttribute("bookingId", bookingId);
                req.setAttribute("seats", seats);

                req.getRequestDispatcher("addPassengers.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("userBookings");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("userBookings");
        }
    }
}
