package com.skyconnect.util;

import javax.servlet.ServletContext;
import java.util.logging.Logger;

/**
 * AeroSphere — Centralized Application Configuration
 *
 * Resolution order (first non-empty value wins):
 *   1. Environment variable  → ideal for Docker / Kubernetes
 *   2. context.xml <Parameter> → fallback for local Tomcat dev
 *   3. Hard-coded default   → safe fallback
 */
public class AppConfig {

    private static final Logger LOG = Logger.getLogger(AppConfig.class.getName());
    private static volatile AppConfig instance;

    private String dbUrl;
    private String dbUser;
    private String dbPassword;
    private String razorpayKeyId;
    private String razorpayKeySecret;
    private String smtpHost;
    private int    smtpPort;
    private String smtpUser;
    private String smtpPassword;
    private String smtpFrom;
    private String smsApiKey;
    private String appName;
    private String appBaseUrl;

    private AppConfig() {}

    public static synchronized void init(ServletContext ctx) {
        if (instance != null) return;
        AppConfig cfg = new AppConfig();

        cfg.dbUrl      = resolve(ctx, "DB_URL",      "db.url",
                "jdbc:mysql://mysql:3306/airlinedb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        cfg.dbUser     = resolve(ctx, "DB_USER",     "db.user",     "root");
        cfg.dbPassword = resolve(ctx, "DB_PASSWORD", "db.password", "");
        cfg.razorpayKeyId     = resolve(ctx, "RAZORPAY_KEY_ID",     "razorpay.key_id",     "");
        cfg.razorpayKeySecret = resolve(ctx, "RAZORPAY_KEY_SECRET", "razorpay.key_secret", "");
        cfg.smtpHost     = resolve(ctx, "SMTP_HOST",     "smtp.host",     "smtp.gmail.com");
        cfg.smtpPort     = Integer.parseInt(resolve(ctx, "SMTP_PORT", "smtp.port", "587"));
        cfg.smtpUser     = resolve(ctx, "SMTP_USER",     "smtp.user",     "");
        cfg.smtpPassword = resolve(ctx, "SMTP_PASSWORD", "smtp.password", "");
        cfg.smtpFrom     = resolve(ctx, "SMTP_FROM",     "smtp.from",     "AeroSphere");
        cfg.smsApiKey    = resolve(ctx, "SMS_API_KEY",   "sms.api.key",   "");
        cfg.appName      = resolve(ctx, "APP_NAME",      "app.name",      "AeroSphere");
        cfg.appBaseUrl   = resolve(ctx, "APP_BASE_URL",  "app.baseUrl",   "http://localhost");

        instance = cfg;

        LOG.info("══════════════════════════════════════════");
        LOG.info("  AeroSphere — Configuration Loaded");
        LOG.info("  DB URL    : " + cfg.dbUrl);
        LOG.info("  Razorpay  : " + (cfg.isRazorpayConfigured() ? "CONFIGURED" : "NOT SET"));
        LOG.info("  SMTP      : " + (cfg.isSmtpConfigured() ? cfg.smtpUser : "NOT SET"));
        LOG.info("  App URL   : " + cfg.appBaseUrl);
        LOG.info("══════════════════════════════════════════");
    }

    public static AppConfig get() {
        if (instance == null) throw new IllegalStateException("AppConfig not initialized.");
        return instance;
    }

    private static String resolve(ServletContext ctx, String envKey, String paramName, String fallback) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) return envVal.trim();
        if (ctx != null) {
            String paramVal = ctx.getInitParameter(paramName);
            if (paramVal != null && !paramVal.trim().isEmpty()) return paramVal.trim();
        }
        return fallback;
    }

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

    public boolean isRazorpayConfigured() {
        return !razorpayKeyId.isEmpty() && !razorpayKeyId.startsWith("rzp_test_XXX");
    }
    public boolean isSmtpConfigured() {
        return !smtpUser.isEmpty() && !smtpUser.contains("your_gmail");
    }
}
