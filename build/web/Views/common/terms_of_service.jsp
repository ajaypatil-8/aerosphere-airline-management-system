<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Terms of Service – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600;9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Syne',sans-serif;font-size:2.2rem;font-weight:800;margin-bottom:10px}
.page-hero p{opacity:.85;font-size:1rem}.page-hero .meta{margin-top:16px;font-size:.82rem;opacity:.7}
.legal-wrap{max-width:820px;margin:0 auto;padding:56px 32px}
.legal-toc{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:24px 28px;margin-bottom:40px}
.legal-toc h3{font-family:'Syne',sans-serif;font-weight:800;font-size:.9rem;margin-bottom:14px;text-transform:uppercase;letter-spacing:.05em}
.legal-toc ol{padding-left:18px;display:flex;flex-direction:column;gap:6px}
.legal-toc li a{color:var(--primary);font-size:.87rem;text-decoration:none;font-weight:500}
.legal-toc li a:hover{text-decoration:underline}
.legal-section{margin-bottom:36px}
.legal-section h2{font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:800;margin-bottom:12px;padding-bottom:10px;border-bottom:2px solid var(--border);scroll-margin-top:90px}
.legal-section p{color:var(--text-muted);line-height:1.8;font-size:.9rem;margin-bottom:10px}
.legal-section ul{padding-left:20px;color:var(--text-muted);font-size:.9rem;line-height:1.8;display:flex;flex-direction:column;gap:5px}
.highlight-box{background:rgba(14,165,233,.06);border:1px solid rgba(14,165,233,.2);border-radius:var(--radius);padding:16px 20px;color:var(--text);font-size:.88rem;line-height:1.7;margin-bottom:20px}
@media(max-width:600px){.legal-wrap{padding:32px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>
<div class="page-hero fade-up">
  <h1>📄 Terms of Service</h1>
  <p>Please read these terms carefully before using AeroSphere.</p>
  <div class="meta">Last updated: January 1, 2026 &nbsp;|&nbsp; Effective: January 1, 2026</div>
</div>
<div class="legal-wrap">
  <div class="legal-toc fade-up">
    <h3>Table of Contents</h3>
    <ol>
      <li><a href="#acceptance">Acceptance of Terms</a></li>
      <li><a href="#account">Account Registration</a></li>
      <li><a href="#booking-terms">Booking & Payment</a></li>
      <li><a href="#cancellation">Cancellations & Refunds</a></li>
      <li><a href="#conduct">User Conduct</a></li>
      <li><a href="#ip">Intellectual Property</a></li>
      <li><a href="#liability">Limitation of Liability</a></li>
      <li><a href="#termination">Termination</a></li>
      <li><a href="#governing">Governing Law</a></li>
      <li><a href="#changes">Changes to Terms</a></li>
    </ol>
  </div>

  <div class="legal-section fade-up" id="acceptance">
    <h2>1. Acceptance of Terms</h2>
    <div class="highlight-box">By accessing or using AeroSphere, you agree to be bound by these Terms of Service. If you do not agree, please do not use our platform.</div>
    <p>These Terms of Service ("Terms") govern your access to and use of the AeroSphere website and services ("Service") operated by AeroSphere ("we", "us", "our"). By creating an account or making a booking, you confirm that you are at least 18 years old and legally capable of entering into binding agreements.</p>
  </div>

  <div class="legal-section fade-up" id="account">
    <h2>2. Account Registration</h2>
    <p>To use our booking services, you must create an account. You agree to:</p>
    <ul>
      <li>Provide accurate, complete, and current information during registration</li>
      <li>Maintain the security of your password and account credentials</li>
      <li>Notify us immediately of any unauthorized use of your account</li>
      <li>Not share your account with any other person</li>
      <li>Not create multiple accounts or accounts on behalf of others without authorization</li>
    </ul>
    <p>We reserve the right to suspend or terminate accounts that violate these provisions.</p>
  </div>

  <div class="legal-section fade-up" id="booking-terms">
    <h2>3. Booking &amp; Payment</h2>
    <p>All bookings made through AeroSphere are subject to seat availability and flight schedule. By completing a booking you acknowledge:</p>
    <ul>
      <li>The total price shown (including taxes and fees) is the final amount charged</li>
      <li>Payment must be completed at the time of booking through our secure payment gateway</li>
      <li>Bookings are confirmed only after successful payment and confirmation email receipt</li>
      <li>You are responsible for ensuring all passenger details entered are correct</li>
      <li>Name corrections after booking may not be possible; contact support for assistance</li>
      <li>AeroSphere is not responsible for any losses arising from incorrect passenger details</li>
    </ul>
  </div>

  <div class="legal-section fade-up" id="cancellation">
    <h2>4. Cancellations &amp; Refunds</h2>
    <p>Cancellations and refunds are governed by our <a href="${pageContext.request.contextPath}/cancellationPolicy" style="color:var(--primary)">Cancellation Policy</a>, which is incorporated into these Terms by reference. Key points:</p>
    <ul>
      <li>&gt;24 hours before departure: 100% refund of ticket price</li>
      <li>2–24 hours before departure: 50% refund of ticket price</li>
      <li>&lt;2 hours before departure: No refund</li>
      <li>Convenience fees and gateway charges are non-refundable</li>
      <li>Refunds are processed to the original payment method only</li>
    </ul>
  </div>

  <div class="legal-section fade-up" id="conduct">
    <h2>5. User Conduct</h2>
    <p>When using AeroSphere, you agree not to:</p>
    <ul>
      <li>Use the platform for any unlawful or fraudulent purpose</li>
      <li>Attempt to gain unauthorized access to any part of the system</li>
      <li>Submit false or misleading booking information</li>
      <li>Conduct automated bookings, scraping, or crawling without permission</li>
      <li>Interfere with the proper functioning of the platform</li>
      <li>Harass, threaten, or abuse other users or staff</li>
    </ul>
    <p>Violation of these rules may result in immediate account termination and legal action.</p>
  </div>

  <div class="legal-section fade-up" id="ip">
    <h2>6. Intellectual Property</h2>
    <p>All content on the AeroSphere platform — including design, logos, text, graphics, and code — is the intellectual property of AeroSphere and is protected by applicable copyright and trademark laws. You may not reproduce, distribute, or create derivative works without explicit written permission.</p>
  </div>

  <div class="legal-section fade-up" id="liability">
    <h2>7. Limitation of Liability</h2>
    <p>To the fullest extent permitted by law, AeroSphere shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the platform, including but not limited to:</p>
    <ul>
      <li>Flight delays, cancellations, or schedule changes by airlines</li>
      <li>Loss of data, revenue, or profits</li>
      <li>Unauthorized access to your account due to your own negligence</li>
      <li>Actions of third-party payment processors or service providers</li>
    </ul>
    <p>Our total liability in any matter shall not exceed the amount paid by you for the specific booking giving rise to the claim.</p>
  </div>

  <div class="legal-section fade-up" id="termination">
    <h2>8. Termination</h2>
    <p>We reserve the right to suspend or terminate your account at any time for violation of these Terms, fraudulent activity, or any other reason at our sole discretion. Upon termination, your right to use the Service ceases immediately. Existing bookings will be processed normally.</p>
  </div>

  <div class="legal-section fade-up" id="governing">
    <h2>9. Governing Law</h2>
    <p>These Terms are governed by and construed in accordance with the laws of India. Any disputes arising from these Terms or your use of the Service shall be subject to the exclusive jurisdiction of the courts in India. By using the platform, you consent to this jurisdiction.</p>
  </div>

  <div class="legal-section fade-up" id="changes">
    <h2>10. Changes to Terms</h2>
    <p>We may update these Terms from time to time. When we do, we will update the "Last updated" date at the top of this page and notify registered users by email. Your continued use of the platform after changes constitutes acceptance of the new Terms.</p>
    <p>For questions about these Terms, please contact us via our <a href="${pageContext.request.contextPath}/contact" style="color:var(--primary)">Contact Us</a> page.</p>
  </div>
</div>
<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
</body>
</html>
