package com.skyconnect.servlet;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // show edit form
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT name, email FROM users WHERE id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("curName", rs.getString("name"));
                req.setAttribute("curEmail", rs.getString("email"));
            } else {
                req.setAttribute("error", "User not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
        }

        req.getRequestDispatcher("edit_profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // handle update
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password"); // optional

        String message = null;

        if (name == null || email == null || name.trim().isEmpty() || email.trim().isEmpty()) {
            message = "Name and email cannot be empty.";
            req.setAttribute("error", message);
            // reload current values below and forward
        } else {
            try (Connection con = DBConnection.getConnection()) {
                if (password != null && password.trim().length() > 0) {
                    String sql = "UPDATE users SET name = ?, email = ?, password = ? WHERE id = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, name.trim());
                    ps.setString(2, email.trim());
                    ps.setString(3, password);
                    ps.setInt(4, userId);
                    ps.executeUpdate();
                } else {
                    String sql = "UPDATE users SET name = ?, email = ? WHERE id = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, name.trim());
                    ps.setString(2, email.trim());
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
                // update session
                session.setAttribute("userName", name.trim());
                req.setAttribute("success", "Profile updated successfully.");
                // after successful update, forward to profile page
                resp.sendRedirect("profile"); // will use ProfileServlet to load fresh data
                return;
            } catch (SQLIntegrityConstraintViolationException cve) {
                message = "Email already in use by another account.";
                req.setAttribute("error", message);
            } catch (Exception e) {
                e.printStackTrace();
                message = "Update error: " + e.getMessage();
                req.setAttribute("error", message);
            }
        }

        // if we reach here, show form again with current DB values (so user doesn't lose data)
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT name,email FROM users WHERE id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("curName", rs.getString("name"));
                req.setAttribute("curEmail", rs.getString("email"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        req.getRequestDispatcher("edit_profile.jsp").forward(req, resp);
    }
}
