package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String dob = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");
        String role = "USER";

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO users(name,email,password,phone,dob,gender,address,role)"
                    + " VALUES(?,?,?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setDate(5, Date.valueOf(dob));
            ps.setString(6, gender);
            ps.setString(7, address);
            ps.setString(8, role);

            ps.executeUpdate();

            req.setAttribute("success", "Account created successfully! Please login.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Registration failed: email already exists!");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}
