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

        List<UserRow> users = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT id, name, email, role, phone, created_at " +
                "FROM users ORDER BY created_at DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserRow u = new UserRow();
                u.id = rs.getInt("id");
                u.name = rs.getString("name");
                u.email = rs.getString("email");
                u.role = rs.getString("role");
                u.phone = rs.getString("phone");
                u.createdAt = rs.getDate("created_at");
                users.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("users", users);
        req.getRequestDispatcher("/Views/admin/users_repor.jsp").forward(req, resp);
    }
}