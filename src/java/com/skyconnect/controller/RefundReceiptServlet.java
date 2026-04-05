package com.skyconnect.controller;

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
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");
        if (userId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/userRefundHistory"); return; }

        int refundId = Integer.parseInt(idStr);

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
            ps.setInt(1, refundId); ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("refundId",    rs.getInt("id"));
                req.setAttribute("amount",      rs.getDouble("refund_amount"));
                req.setAttribute("status",      rs.getString("refund_status"));
                req.setAttribute("approvedAt",  rs.getTimestamp("approved_at"));
                req.setAttribute("flightNo",    rs.getString("flight_no"));
                req.setAttribute("passengerName", rs.getString("name"));
                req.getRequestDispatcher("/Views/user/refund_receipt.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) { e.printStackTrace(); }

        resp.sendRedirect(req.getContextPath() + "/userRefundHistory");
    }
}
