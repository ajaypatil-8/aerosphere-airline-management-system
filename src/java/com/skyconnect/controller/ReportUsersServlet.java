package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportUsers")
public class ReportUsersServlet extends HttpServlet {

    private static final int PAGE_SIZE = 50;

    public static class UserRow {
        public int id;
        public String name;
        public String email;
        public String role;
        public String phone;
        public Date createdAt;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role   = req.getParameter("role");
        String search = req.getParameter("search");
        if (search != null) search = search.trim();

        // Pagination
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * PAGE_SIZE;

        List<UserRow> users = new ArrayList<>();
        int totalCount = 0;

        StringBuilder where = new StringBuilder(" WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (role != null && !role.isEmpty()) {
            where.append(" AND role = ?");
            params.add(role);
        }
        if (search != null && !search.isEmpty()) {
            where.append(" AND (name LIKE ? OR email LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        try (Connection con = DBConnection.getConnection()) {

            // Count
            String countSql = "SELECT COUNT(*) FROM users" + where;
            try (PreparedStatement ps = con.prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Paginated data
            String sql =
                "SELECT id, name, email, role, phone, created_at FROM users" +
                where + " ORDER BY created_at DESC LIMIT ? OFFSET ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int idx = 1;
                for (Object param : params) ps.setObject(idx++, param);
                ps.setInt(idx++, PAGE_SIZE);
                ps.setInt(idx, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        UserRow u = new UserRow();
                        u.id        = rs.getInt("id");
                        u.name      = rs.getString("name");
                        u.email     = rs.getString("email");
                        u.role      = rs.getString("role");
                        u.phone     = rs.getString("phone");
                        u.createdAt = rs.getDate("created_at");
                        users.add(u);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        req.setAttribute("users",       users);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("role",        role);
        req.setAttribute("search",      search);
        req.getRequestDispatcher("/Views/admin/users_report.jsp").forward(req, resp);
    }
}
