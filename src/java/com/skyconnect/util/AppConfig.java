package com.skyconnect.util;

import javax.servlet.ServletContext;

/**
 * AeroSphere — Centralized Application Configuration
 *
 * Singleton populated at startup by AppInitListener.
 * All values come from META-INF/context.xml  <Parameter> entries.
 *
 * Usage anywhere in the app:
 *   AppConfig cfg = AppConfig.get();
 *   String keyId  = cfg.getRazorpayKeyId();
 */
public class AppConfig {

    private static volatile AppConfig instance;

    // ── Database ───────────────────────────────────────────────
    private String dbUrl;
    private String dbUser;
    private String dbPassword;

    // ── Razorpay ───────────────────────────────────────────────
    private String razorpayKeyId;
    private String razorpayKeySecret;

    // ── SMTP / Email ───────────────────────────────────────────
    private String smtpHost;
    private int    smtpPort;
    private String smtpUser;
    private String smtpPassword;
    private String smtpFrom;

    // ── SMS ────────────────────────────────────────────────────
    private String smsApiKey;

    // ── App ────────────────────────────────────────────────────
    private String appName;
    private String appBaseUrl;

    private AppConfig() {}

    // ─────────────────────────────────────────────────────────────
    // Initialisation — called ONCE by AppInitListener on startup
    // ─────────────────────────────────────────────────────────────

    public static synchronized void init(ServletContext ctx) {
        if (instance != null) return;   // already initialised

        AppConfig cfg = new AppConfig();

        cfg.dbUrl           = param(ctx, "db.url",      "jdbc:mysql://localhost:3306/airlinedb?useSSL=false&serverTimezone=UTC");
        cfg.dbUser          = param(ctx, "db.user",     "root");
        cfg.dbPassword      = param(ctx, "db.password", "");

        cfg.razorpayKeyId     = param(ctx, "razorpay.key_id",     "");
        cfg.razorpayKeySecret = param(ctx, "razorpay.key_secret", "");

        cfg.smtpHost        = param(ctx, "smtp.host",     "smtp.gmail.com");
        cfg.smtpPort        = Integer.parseInt(param(ctx, "smtp.port", "587"));
        cfg.smtpUser        = param(ctx, "smtp.user",     "");
        cfg.smtpPassword    = param(ctx, "smtp.password", "");
        cfg.smtpFrom        = param(ctx, "smtp.from",     "AeroSphere");

        cfg.smsApiKey       = param(ctx, "sms.api.key",  "");

        cfg.appName         = param(ctx, "app.name",     "AeroSphere");
        cfg.appBaseUrl      = param(ctx, "app.baseUrl",  "http://localhost:8080/airline");

        instance = cfg;
    }

    /**
     * Returns the singleton.
     * Throws if called before AppInitListener has run.
     */
    public static AppConfig get() {
        if (instance == null) {
            throw new IllegalStateException(
                "AppConfig not initialized. Is AppInitListener registered in web.xml?");
        }
        return instance;
    }

    // ── Private helper ─────────────────────────────────────────
    private static String param(ServletContext ctx, String name, String fallback) {
        String v = ctx.getInitParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : fallback;
    }

    // ── Getters ────────────────────────────────────────────────

    public String getDbUrl()             { return dbUrl; }
    public String getDbUser()            { return dbUser; }
    public String getDbPassword()        { return dbPassword; }

    public String getRazorpayKeyId()     { return razorpayKeyId; }
    public String getRazorpayKeySecret() { return razorpayKeySecret; }

    public String getSmtpHost()          { return smtpHost; }
    public int    getSmtpPort()          { return smtpPort; }
    public String getSmtpUser()          { return smtpUser; }
    public String getSmtpPassword()      { return smtpPassword; }
    public String getSmtpFrom()          { return smtpFrom; }

    public String getSmsApiKey()         { return smsApiKey; }

    public String getAppName()           { return appName; }
    public String getAppBaseUrl()        { return appBaseUrl; }

    /** Returns true if Razorpay keys are configured (not placeholder). */
    public boolean isRazorpayConfigured() {
        return !razorpayKeyId.isEmpty() && !razorpayKeyId.startsWith("rzp_test_XXX");
    }

    /** Returns true if SMTP is configured for sending emails. */
    public boolean isSmtpConfigured() {
        return !smtpUser.isEmpty() && !smtpUser.contains("your_gmail");
    }
}
