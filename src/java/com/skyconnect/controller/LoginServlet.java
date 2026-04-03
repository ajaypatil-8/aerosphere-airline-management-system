package com.skyconnect.controller;

import com.skyconnect.dao.UserDAO;
import com.skyconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");

            if ("ADMIN".equals(u.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/adminDashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/userDashboard");
            }
            return;
        }

        // ✅ FIXED PATH
        req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email") == null ? "" : req.getParameter("email").trim();
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");

        if (email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(email, password);

        if (user == null) {
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userRole", user.getRole());

        if ("ADMIN".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/adminDashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/userDashboard");
        }
    }
}