<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Privacy Policy – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Syne',sans-serif;font-size:2.2rem;font-weight:800;margin-bottom:10px}
.page-hero p{opacity:.85;font-size:1rem}
.page-hero .meta{margin-top:16px;font-size:.82rem;opacity:.7}
.legal-wrap{max-width:820px;margin:0 auto;padding:56px 32px}
.legal-toc{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:24px 28px;margin-bottom:40px}
.legal-toc h3{font-family:'Syne',sans-serif;font-weight:800;font-size:.9rem;margin-bottom:14px;text-transform:uppercase;letter-spacing:.05em}
.legal-toc ol{padding-left:18px;display:flex;flex-direction:column;gap:6px}
.legal-toc li a{color:var(--primary);font-size:.87rem;text-decoration:none;font-weight:500}
.legal-toc li a:hover{text-decoration:underline}
.legal-section{margin-bottom:40px}
.legal-section h2{font-family:'Syne',sans-serif;font-size:1.15rem;font-weight:800;margin-bottom:14px;padding-bottom:10px;border-bottom:2px solid var(--border);scroll-margin-top:90px}
.legal-section p{color:var(--text-muted);line-height:1.8;font-size:.9rem;margin-bottom:12px}
.legal-section ul{padding-left:20px;color:var(--text-muted);font-size:.9rem;line-height:1.8;display:flex;flex-direction:column;gap:5px}
.data-table{width:100%;border-collapse:collapse;font-size:.87rem;margin:16px 0}
.data-table th{background:var(--surface-2);padding:10px 14px;text-align:left;font-weight:700;font-size:.78rem;text-transform:uppercase;letter-spacing:.04em;color:var(--text-muted);border-bottom:2px solid var(--border)}
.data-table td{padding:10px 14px;border-bottom:1px solid var(--border);color:var(--text)}
@media(max-width:600px){.legal-wrap{padding:32px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>

<div class="page-hero fade-up">
  <h1>🔒 Privacy Policy</h1>
  <p>We're committed to protecting your personal data and being transparent about how we use it.</p>
  <div class="meta">Last updated: January 1, 2026 &nbsp;|&nbsp; Effective: January 1, 2026</div>
</div>

<div class="legal-wrap">

  <div class="legal-toc fade-up">
    <h3>Table of Contents</h3>
    <ol>
      <li><a href="#collect">Information We Collect</a></li>
      <li><a href="#use">How We Use Your Information</a></li>
      <li><a href="#share">Information Sharing</a></li>
      <li><a href="#security">Data Security</a></li>
      <li><a href="#cookies">Cookies & Tracking</a></li>
      <li><a href="#rights">Your Rights</a></li>
      <li><a href="#retention">Data Retention</a></li>
      <li><a href="#contact-us">Contact Us</a></li>
    </ol>
  </div>

  <div class="legal-section fade-up">
    <p>AeroSphere ("we", "our", or "us") is committed to protecting the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our platform. Please read it carefully.</p>
  </div>

  <div class="legal-section fade-up" id="collect">
    <h2>1. Information We Collect</h2>
    <p>We collect information you provide directly to us and information generated through your use of our services:</p>
    <table class="data-table">
      <thead><tr><th>Category</th><th>Data Collected</th><th>Source</th></tr></thead>
      <tbody>
        <tr><td>Account Information</td><td>Name, email address, phone number, password (hashed)</td><td>Registration form</td></tr>
        <tr><td>Booking Data</td><td>Passenger names, flight preferences, travel dates, seat selection</td><td>Booking process</td></tr>
        <tr><td>Payment Information</td><td>Transaction ID, payment status (card details are NOT stored)</td><td>Razorpay gateway</td></tr>
        <tr><td>Communication</td><td>Messages sent via Contact Us form, support emails</td><td>Contact form</td></tr>
        <tr><td>Usage Data</td><td>Pages visited, session duration, browser type, IP address</td><td>Server logs</td></tr>
      </tbody>
    </table>
  </div>

  <div class="legal-section fade-up" id="use">
    <h2>2. How We Use Your Information</h2>
    <ul>
      <li>To process and confirm flight bookings and payments</li>
      <li>To send booking confirmations, invoices, and flight updates via email</li>
      <li>To verify your identity during account registration (OTP)</li>
      <li>To respond to your support queries and contact form messages</li>
      <li>To improve our platform based on usage patterns and feedback</li>
      <li>To detect and prevent fraud, unauthorized access, and abuse</li>
      <li>To comply with legal obligations under applicable Indian law</li>
    </ul>
  </div>

  <div class="legal-section fade-up" id="share">
    <h2>3. Information Sharing</h2>
    <p>We do not sell, trade, or rent your personal data to third parties. We share information only in these limited circumstances:</p>
    <ul>
      <li><strong>Payment Processors:</strong> Razorpay receives transaction data to process payments. They are PCI-DSS compliant and have their own privacy policy.</li>
      <li><strong>Email Service Providers:</strong> We use SMTP (Gmail) to send transactional emails. Email addresses are transmitted but not stored by third parties beyond delivery.</li>
      <li><strong>Legal Requirements:</strong> We may disclose information when required by law, court order, or government authority.</li>
      <li><strong>Business Transfers:</strong> In the event of a merger or acquisition, your data may be transferred to the new entity under the same privacy protections.</li>
    </ul>
  </div>

  <div class="legal-section fade-up" id="security">
    <h2>4. Data Security</h2>
    <p>We implement industry-standard security measures to protect your data:</p>
    <ul>
      <li>All web traffic is encrypted using HTTPS/TLS</li>
      <li>Passwords are hashed using bcrypt — we cannot read your password</li>
      <li>CSRF tokens protect all forms from cross-site request forgery</li>
      <li>Sessions are managed with HttpOnly, Secure cookies</li>
      <li>Payment card details are never stored on our servers</li>
      <li>Database access is restricted to authorised internal services only</li>
    </ul>
    <p>While we take every precaution, no internet transmission is 100% secure. Please use a strong, unique password for your account.</p>
  </div>

  <div class="legal-section fade-up" id="cookies">
    <h2>5. Cookies &amp; Tracking</h2>
    <p>We use the following cookies:</p>
    <ul>
      <li><strong>Session Cookies:</strong> Required for login and booking flow. These expire when you close your browser.</li>
      <li><strong>Preference Cookies:</strong> Store your dark/light mode preference (saved in localStorage, not sent to server).</li>
    </ul>
    <p>We do not use advertising cookies or third-party tracking scripts. You can disable cookies in your browser settings, but this may affect site functionality.</p>
  </div>

  <div class="legal-section fade-up" id="rights">
    <h2>6. Your Rights</h2>
    <p>You have the following rights regarding your personal data:</p>
    <ul>
      <li><strong>Access:</strong> Request a copy of the personal data we hold about you</li>
      <li><strong>Correction:</strong> Update inaccurate data via your Profile settings or by contacting support</li>
      <li><strong>Deletion:</strong> Request deletion of your account and associated data (subject to legal retention requirements)</li>
      <li><strong>Portability:</strong> Request your data in a structured, machine-readable format</li>
      <li><strong>Objection:</strong> Object to processing of your data for direct marketing</li>
    </ul>
    <p>To exercise any of these rights, please contact us via the Contact Us page. We will respond within 30 days.</p>
  </div>

  <div class="legal-section fade-up" id="retention">
    <h2>7. Data Retention</h2>
    <p>We retain your personal data for as long as your account is active or as needed to provide services. Specific retention periods:</p>
    <ul>
      <li>Account information: Until account deletion, plus 6 months</li>
      <li>Booking and payment records: 7 years (legal/tax requirements)</li>
      <li>Support messages: 2 years</li>
      <li>Server access logs: 90 days</li>
    </ul>
  </div>

  <div class="legal-section fade-up" id="contact-us">
    <h2>8. Contact Us</h2>
    <p>If you have any questions about this Privacy Policy or wish to exercise your rights, please reach out:</p>
    <ul>
      <li><strong>Email:</strong> Via our <a href="${pageContext.request.contextPath}/contact" style="color:var(--primary)">Contact Us page</a></li>
      <li><strong>Response time:</strong> Within 48 business hours</li>
    </ul>
    <p>We may update this Privacy Policy from time to time. The "Last updated" date at the top will reflect the most recent revision. Continued use of the platform constitutes acceptance of the updated policy.</p>
  </div>

</div>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
</body>
</html>
