package com.skyconnect.controller;

import com.skyconnect.dao.UserDAO;
import com.skyconnect.model.User;
import com.skyconnect.util.CsrfUtil;

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

        // ── Security: generate CSRF token for the login forms ──
        CsrfUtil.ensureToken(req);

        req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
    }

    // ── POST: process login ───────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── CSRF Validation (prevents cross-site request forgery) ──
        if (!CsrfUtil.isValid(req)) {
            req.setAttribute("error", "Security token invalid. Please refresh the page and try again.");
            req.setAttribute("activeTab", "USER");
            CsrfUtil.ensureToken(req);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        String email     = req.getParameter("email")     == null ? "" : req.getParameter("email").trim();
        String password  = req.getParameter("password")  == null ? "" : req.getParameter("password");
        String loginType = req.getParameter("loginType") == null ? "USER" : req.getParameter("loginType").trim().toUpperCase();

        // ── Basic validation ──
        if (email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.setAttribute("activeTab", loginType);
            CsrfUtil.ensureToken(req);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── Authenticate ──
        User user = userDAO.authenticate(email, password);

        if (user == null) {
            req.setAttribute("error", "Invalid email or password.");
            req.setAttribute("activeTab", loginType);
            CsrfUtil.ensureToken(req);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── Check account is active (not banned) ──
        if (!user.isActive()) {
            req.setAttribute("error", "Your account has been suspended. Please contact support.");
            req.setAttribute("activeTab", loginType);
            CsrfUtil.ensureToken(req);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── Role enforcement ──
        if ("USER".equals(loginType) && "ADMIN".equals(user.getRole())) {
            req.setAttribute("error", "Admin accounts must use the Admin login tab.");
            req.setAttribute("activeTab", "USER");
            CsrfUtil.ensureToken(req);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }
        if ("ADMIN".equals(loginType) && !"ADMIN".equals(user.getRole())) {
            req.setAttribute("error", "You don't have admin privileges.");
            req.setAttribute("activeTab", "ADMIN");
            CsrfUtil.ensureToken(req);
            req.getRequestDispatcher("/Views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ── SESSION FIXATION FIX ─────────────────────────────────────────────
        // Invalidate the old anonymous session (which an attacker may have
        // set up and given the user a session-fixed cookie for).
        // Then create a brand-new session to guarantee a fresh session ID.
        HttpSession oldSession = req.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession session = req.getSession(true);   // ← new session, new ID

        // ── Populate session ──
        session.setAttribute("user",     user);
        session.setAttribute("userId",   user.getId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userRole", user.getRole());

        // After login the old CSRF token is now in the dead session.
        // Generate a fresh one for the new session.
        CsrfUtil.generateToken(req);

        // ── Redirect ──
        if ("ADMIN".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/adminDashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/userDashboard");
        }
    }
}
