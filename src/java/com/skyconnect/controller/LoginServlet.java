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

    // ── GET: show login page ──────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("userRole");
            if ("ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/adminDashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/userDashboard");
            }
            return;
        }
        req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
    }

    // ── POST: process login ───────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email     = req.getParameter("email")     == null ? "" : req.getParameter("email").trim();
        String password  = req.getParameter("password")  == null ? "" : req.getParameter("password");
        // loginType sent by the form: "USER" or "ADMIN"
        String loginType = req.getParameter("loginType") == null ? "USER" : req.getParameter("loginType").trim().toUpperCase();

        // ── basic validation ──
        if (email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.setAttribute("activeTab", loginType);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── authenticate ──
        User user = userDAO.authenticate(email, password);

        if (user == null) {
            req.setAttribute("error", "Invalid email or password.");
            req.setAttribute("activeTab", loginType);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── ROLE ENFORCEMENT ──
        // If loginType=USER  but the account is ADMIN → block
        if ("USER".equals(loginType) && "ADMIN".equals(user.getRole())) {
            req.setAttribute("error", "Admin accounts must use the Admin login tab.");
            req.setAttribute("activeTab", "USER");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }
        // If loginType=ADMIN but the account is USER  → block
        if ("ADMIN".equals(loginType) && !"ADMIN".equals(user.getRole())) {
            req.setAttribute("error", "You don't have admin privileges.");
            req.setAttribute("activeTab", "ADMIN");
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── create session — all four required attributes ──
        HttpSession session = req.getSession(true);
        session.setAttribute("user",     user);
        session.setAttribute("userId",   user.getId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userRole", user.getRole());

        // ── redirect to correct dashboard ──
        if ("ADMIN".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/adminDashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/userDashboard");
        }
    }
}
