<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Cookie Policy – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:opsz,wght@9..40,400;9..40,500;9..40,600;9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Syne',sans-serif;font-size:2.2rem;font-weight:800;margin-bottom:10px}
.page-hero p{opacity:.85;font-size:1rem}.page-hero .meta{margin-top:16px;font-size:.82rem;opacity:.7}
.legal-wrap{max-width:820px;margin:0 auto;padding:56px 32px}
.legal-section{margin-bottom:36px}
.legal-section h2{font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:800;margin-bottom:12px;padding-bottom:10px;border-bottom:2px solid var(--border)}
.legal-section p{color:var(--text-muted);line-height:1.8;font-size:.9rem;margin-bottom:10px}
.cookie-table{width:100%;border-collapse:collapse;font-size:.87rem;margin:16px 0}
.cookie-table th{background:var(--surface-2);padding:10px 14px;text-align:left;font-weight:700;font-size:.78rem;text-transform:uppercase;letter-spacing:.04em;color:var(--text-muted);border-bottom:2px solid var(--border)}
.cookie-table td{padding:11px 14px;border-bottom:1px solid var(--border);color:var(--text);line-height:1.5}
.cookie-table tr:last-child td{border:none}
.cookie-table tr:hover td{background:var(--surface-2)}
.tag{display:inline-block;padding:2px 8px;border-radius:4px;font-size:.72rem;font-weight:700}
.tag.essential{background:rgba(16,185,129,.12);color:#059669}
.tag.preference{background:rgba(14,165,233,.12);color:#0284C7}
@media(max-width:600px){.legal-wrap{padding:32px 16px}.cookie-table{font-size:.78rem}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>
<div class="page-hero fade-up">
  <h1>🍪 Cookie Policy</h1>
  <p>We keep cookies to a minimum. Here's exactly what we use and why.</p>
  <div class="meta">Last updated: January 1, 2026</div>
</div>
<div class="legal-wrap">

  <div class="legal-section fade-up">
    <h2>What Are Cookies?</h2>
    <p>Cookies are small text files stored on your device when you visit a website. They help the site remember information about your visit, such as your login status and preferences. We use cookies sparingly and only for what is strictly necessary to make the platform work.</p>
  </div>

  <div class="legal-section fade-up">
    <h2>Cookies We Use</h2>
    <div style="background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden">
      <table class="cookie-table">
        <thead>
          <tr><th>Cookie Name</th><th>Type</th><th>Purpose</th><th>Duration</th></tr>
        </thead>
        <tbody>
          <tr>
            <td><code>JSESSIONID</code></td>
            <td><span class="tag essential">Essential</span></td>
            <td>Maintains your login session. Required for the booking system to work correctly. Without this cookie you cannot log in.</td>
            <td>Session (expires on browser close)</td>
          </tr>
          <tr>
            <td><code>asTheme</code> (localStorage)</td>
            <td><span class="tag preference">Preference</span></td>
            <td>Remembers your dark/light mode preference. Stored in browser localStorage — not sent to our servers.</td>
            <td>Persistent (until cleared)</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-top:12px">That's it. We do not use advertising cookies, tracking pixels, or third-party analytics scripts. Your browsing on AeroSphere is not tracked for marketing purposes.</p>
  </div>

  <div class="legal-section fade-up">
    <h2>Cookies We Do NOT Use</h2>
    <p>To be clear about what AeroSphere does <strong>not</strong> do:</p>
    <ul style="padding-left:20px;color:var(--text-muted);font-size:.9rem;line-height:2;display:flex;flex-direction:column;gap:4px">
      <li>❌ No Google Analytics or similar tracking</li>
      <li>❌ No Facebook Pixel or social media tracking</li>
      <li>❌ No advertising or retargeting cookies</li>
      <li>❌ No cross-site tracking</li>
      <li>❌ No fingerprinting or device tracking</li>
    </ul>
  </div>

  <div class="legal-section fade-up">
    <h2>Managing Cookies</h2>
    <p>You can control and delete cookies through your browser settings. Here's how for major browsers:</p>
    <ul style="padding-left:20px;color:var(--text-muted);font-size:.9rem;line-height:1.9;display:flex;flex-direction:column;gap:5px">
      <li><strong>Chrome:</strong> Settings → Privacy and Security → Cookies and other site data</li>
      <li><strong>Firefox:</strong> Settings → Privacy &amp; Security → Cookies and Site Data</li>
      <li><strong>Safari:</strong> Preferences → Privacy → Manage Website Data</li>
      <li><strong>Edge:</strong> Settings → Cookies and site permissions → Manage and delete cookies</li>
    </ul>
    <p style="margin-top:12px">Please note: deleting the <code>JSESSIONID</code> cookie will log you out. Deleting <code>asTheme</code> will reset your theme to the system default. Other site functionality will not be affected.</p>
  </div>

  <div class="legal-section fade-up">
    <h2>Changes to This Policy</h2>
    <p>We may update this Cookie Policy if we add new features that require additional cookies. We will always update the "Last updated" date and notify users if any new tracking cookies are introduced. We are committed to keeping our cookie use minimal and transparent.</p>
    <p>Questions? <a href="${pageContext.request.contextPath}/contact" style="color:var(--primary)">Contact us</a> and we'll respond within 48 hours.</p>
  </div>
</div>
<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
</body>
</html>
