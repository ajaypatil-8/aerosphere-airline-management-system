package com.skyconnect.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * AeroSphere — Database Connection Utility
 *
 * Credentials are now loaded from META-INF/context.xml via AppConfig.
 * Nothing is hardcoded here anymore.
 *
 * Usage (always use try-with-resources to auto-close):
 *
 *   try (Connection conn = DBConnection.getConnection()) {
 *       // use conn
 *   }
 *
 * For production: consider upgrading to HikariCP connection pool.
 * (See Section 5 of improvements for HikariCP setup)
 */
public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    /**
     * Returns a fresh JDBC connection.
     * CALLER MUST CLOSE IT — always use try-with-resources.
     */
    public static Connection getConnection() throws SQLException {
        AppConfig cfg = AppConfig.get();
        return DriverManager.getConnection(
            cfg.getDbUrl(),
            cfg.getDbUser(),
            cfg.getDbPassword()
        );
    }

    /** Null-safe connection close (convenience helper). */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
