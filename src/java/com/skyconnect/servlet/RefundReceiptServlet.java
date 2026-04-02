package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/refundReceipt")
public class RefundReceiptServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int refundId = Integer.parseInt(req.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT r.id, r.refund_amount, r.refund_status, r.approved_at, " +
                "f.flight_no, u.name " +
                "FROM refunds r " +
                "JOIN bookings b ON r.booking_id=b.id " +
                "JOIN flights f ON b.flight_id=f.id " +
                "JOIN users u ON r.user_id=u.id " +
                "WHERE r.id=? AND r.user_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, refundId);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("refund", rs);
                req.getRequestDispatcher("refund_receipt.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("userRefundHistory");
    }
}