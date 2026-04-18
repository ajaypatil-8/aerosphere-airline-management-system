package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

/**
 * AeroSphere — Health Check Endpoint
 *
 * GET /health
 *   → 200 OK  {"status":"UP","db":"UP"}   if DB reachable
 *   → 503     {"status":"UP","db":"DOWN"} if DB unreachable
 *
 * Used by Docker HEALTHCHECK, load balancers, and uptime monitors.
 */
@WebServlet("/health")
public class HealthCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        boolean dbUp = false;
        try (Connection conn = DBConnection.getConnection()) {
            dbUp = conn != null && conn.isValid(2);
        } catch (Exception ignored) {}

        int statusCode = dbUp ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE;
        resp.setStatus(statusCode);

        try (PrintWriter out = resp.getWriter()) {
            out.printf("{\"status\":\"UP\",\"db\":\"%s\",\"app\":\"AeroSphere\"}",
                       dbUp ? "UP" : "DOWN");
        }
    }
}
