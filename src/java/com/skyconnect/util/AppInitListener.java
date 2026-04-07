package com.skyconnect.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * AeroSphere — Application Startup Listener
 *
 * Runs BEFORE any servlet is initialised.
 * Reads all configuration from META-INF/context.xml and stores
 * it in AppConfig so every servlet/DAO can access it without
 * holding hardcoded credentials.
 *
 * Registered automatically via @WebListener (Servlet 3.0+).
 */
@WebListener
public class AppInitListener implements ServletContextListener {

    private static final Logger log = Logger.getLogger(AppInitListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            AppConfig.init(sce.getServletContext());

            AppConfig cfg = AppConfig.get();

            log.info("══════════════════════════════════════════");
            log.info("  AeroSphere — Application Started");
            log.info("══════════════════════════════════════════");
            log.info("  DB URL    : " + cfg.getDbUrl());
            log.info("  Razorpay  : " + (cfg.isRazorpayConfigured()
                                          ? "CONFIGURED (" + cfg.getRazorpayKeyId().substring(0, 12) + "...)"
                                          : "⚠ NOT SET — payment will use simulation mode"));
            log.info("  SMTP      : " + (cfg.isSmtpConfigured()
                                          ? "CONFIGURED (" + cfg.getSmtpUser() + ")"
                                          : "⚠ NOT SET — emails disabled"));
            log.info("  App Base  : " + cfg.getAppBaseUrl());
            log.info("══════════════════════════════════════════");

        } catch (Exception e) {
            log.severe("❌ AppConfig initialisation FAILED: " + e.getMessage());
            // Don't throw — let the app start anyway so other pages still work
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info("AeroSphere — Application Stopped.");
    }
}
