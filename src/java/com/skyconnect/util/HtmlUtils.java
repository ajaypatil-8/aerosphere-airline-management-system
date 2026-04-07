package com.skyconnect.util;

/**
 * AeroSphere — HTML Escape Utility (XSS Prevention)
 *
 * Use this to safely output user-supplied data in JSP pages.
 *
 * ─── USAGE IN JSP ────────────────────────────────────────────────
 *
 * Add import at top of JSP:
 *   <%@ page import="com.skyconnect.util.HtmlUtils" %>
 *
 * Then replace UNSAFE output:
 *   UNSAFE:  <%= userName %>
 *   SAFE:    <%= HtmlUtils.e(userName) %>
 *
 * For numbers/IDs you know are safe (never user-inputted strings):
 *   <%= bookingId %>  ← fine, it's an int from DB
 *
 * ─────────────────────────────────────────────────────────────────
 */
public class HtmlUtils {

    private HtmlUtils() {}

    /**
     * Escape HTML special characters to prevent XSS.
     * Shorthand alias: use e() in JSP for brevity.
     *
     * Escapes: & < > " ' /
     * Returns empty string for null input (never throws NullPointerException).
     */
    public static String e(String value) {
        return escape(value);
    }

    /**
     * Full name version of e() — same behavior.
     */
    public static String escape(String value) {
        if (value == null) return "";
        StringBuilder sb = new StringBuilder(value.length() + 8);
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            switch (c) {
                case '&':  sb.append("&amp;");   break;
                case '<':  sb.append("&lt;");    break;
                case '>':  sb.append("&gt;");    break;
                case '"':  sb.append("&quot;");  break;
                case '\'': sb.append("&#x27;");  break;
                case '/':  sb.append("&#x2F;");  break;
                default:   sb.append(c);
            }
        }
        return sb.toString();
    }

    /**
     * Escape a value for use inside a JavaScript string literal.
     * Use when you're outputting a Java variable into JS code in a JSP.
     *
     * Example (in JSP):
     *   var name = '<%= HtmlUtils.escapeJs(userName) %>';
     */
    public static String escapeJs(String value) {
        if (value == null) return "";
        return value
            .replace("\\",  "\\\\")
            .replace("'",   "\\'")
            .replace("\"",  "\\\"")
            .replace("\n",  "\\n")
            .replace("\r",  "\\r")
            .replace("\t",  "\\t")
            .replace("<",   "\\u003C")   // prevents </script> injection
            .replace(">",   "\\u003E")
            .replace("&",   "\\u0026");
    }

    /**
     * Safe toString — returns empty string if value is null.
     * Useful for objects (Integer, Double, etc.) where null would print "null".
     *
     * Example:
     *   <%= HtmlUtils.safe(bookingId) %>   instead of  <%= bookingId == null ? "" : bookingId %>
     */
    public static String safe(Object value) {
        return (value == null) ? "" : escape(String.valueOf(value));
    }
}
