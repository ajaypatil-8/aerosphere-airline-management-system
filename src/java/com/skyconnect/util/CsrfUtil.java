package com.skyconnect.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * AeroSphere — CSRF Protection Utility
 *
 * Protects all POST forms from Cross-Site Request Forgery attacks.
 *
 * ─── HOW TO USE ───────────────────────────────────────────────────
 *
 * STEP 1 — In every Servlet GET handler (before forwarding to JSP):
 *   CsrfUtil.ensureToken(request);
 *   // then forward to JSP as normal
 *
 * STEP 2 — In every JSP form (add hidden field inside <form>):
 *   <%@ page import="com.skyconnect.util.CsrfUtil" %>
 *   <input type="hidden" name="_csrf" value="<%= CsrfUtil.getToken(request) %>">
 *
 * STEP 3 — In every Servlet POST handler (FIRST thing before anything else):
 *   if (!CsrfUtil.isValid(request)) {
 *       response.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF validation failed.");
 *       return;
 *   }
 *
 * ──────────────────────────────────────────────────────────────────
 */
public class CsrfUtil {

    /** The form field name — must match what you put in JSP hidden input. */
    public static final String FORM_FIELD   = "_csrf";

    private static final String SESSION_KEY = "__aerosphere_csrf_token__";
    private static final SecureRandom RNG   = new SecureRandom();

    // No instantiation
    private CsrfUtil() {}

    /**
     * Generate a new 32-byte random token, store in session, return it.
     * Call this if you need to rotate the token (e.g. after login).
     */
    public static String generateToken(HttpServletRequest req) {
        byte[] bytes = new byte[32];
        RNG.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        req.getSession(true).setAttribute(SESSION_KEY, token);
        return token;
    }

    /**
     * Get the current CSRF token from session.
     * Generates one if none exists yet.
     * Use this in JSP: <%= CsrfUtil.getToken(request) %>
     */
    public static String getToken(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            String token = (String) session.getAttribute(SESSION_KEY);
            if (token != null && !token.isEmpty()) return token;
        }
        return generateToken(req);
    }

    /**
     * Ensure a token exists in the session (call from GET handlers).
     * Does nothing if a token already exists.
     */
    public static void ensureToken(HttpServletRequest req) {
        getToken(req); // creates one if missing
    }

    /**
     * Validate the CSRF token submitted in a POST form.
     *
     * @return true  if token is present and matches session
     * @return false if token missing, invalid, or session gone
     */
    public static boolean isValid(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(SESSION_KEY);
        String formToken    = req.getParameter(FORM_FIELD);

        if (sessionToken == null || sessionToken.isEmpty()) return false;
        if (formToken    == null || formToken.isEmpty())    return false;

        // Constant-time comparison — prevents timing-based attacks
        return constantTimeEquals(sessionToken, formToken);
    }

    // ── Private helpers ────────────────────────────────────────────

    /**
     * Compare two strings in constant time.
     * Unlike String.equals(), this doesn't short-circuit on first mismatch,
     * so an attacker cannot measure response time to guess the token.
     */
    private static boolean constantTimeEquals(String a, String b) {
        // Different lengths → definitely not equal
        // (returning false early here doesn't leak which char is wrong)
        if (a.length() != b.length()) return false;

        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= (a.charAt(i) ^ b.charAt(i));
        }
        return result == 0;
    }
}
