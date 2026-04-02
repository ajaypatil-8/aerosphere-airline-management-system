/*package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT id, name, role FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = req.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userRole", rs.getString("role"));

                // ---- ROLE BASED REDIRECT ----
                String role = rs.getString("role");
                if ("ADMIN".equalsIgnoreCase(role)) {
                    resp.sendRedirect("adminDashboard");   // Go to admin dashboard servlet
                } else {
                    resp.sendRedirect("userDashboard");    // Go to user dashboard servlet
                }

            } else {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Login failed: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}*/


package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String loginType = req.getParameter("loginType"); // USER / ADMIN

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT id, name, role FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String role = rs.getString("role");

                // ❌ Prevent user logging in from admin page
                if ("ADMIN".equals(loginType) && !"ADMIN".equals(role)) {
                    req.setAttribute("error", "Access denied. Admins only.");
                    req.getRequestDispatcher("admin_login.jsp").forward(req, resp);
                    return;
                }

                // ✅ Create session
                HttpSession session = req.getSession(true);
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                //session.setAttribute("userRole", role);
                session.setAttribute("userRole", role);
session.setAttribute("role", role);   // ✅ ADD THIS

                // ✅ Redirect
                if ("ADMIN".equalsIgnoreCase(role)) {
                    resp.sendRedirect("adminDashboard");
                } else {
                    resp.sendRedirect("userDashboard");
                }

            } else {
                req.setAttribute("error", "Invalid email or password");

                if ("ADMIN".equals(loginType)) {
                    req.getRequestDispatcher("admin_login.jsp").forward(req, resp);
                } else {
                    req.getRequestDispatcher("login.jsp").forward(req, resp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Login failed. Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
