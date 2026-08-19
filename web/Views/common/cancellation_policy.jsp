<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Cancellation Policy – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Fraunces',sans-serif;font-size:2.2rem;font-weight:800;margin-bottom:10px}
.page-hero p{opacity:.85;font-size:1rem;max-width:520px;margin:0 auto}
.policy-wrap{max-width:860px;margin:0 auto;padding:56px 32px}
.policy-card{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden;margin-bottom:28px}
.policy-card-header{padding:20px 28px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:12px}
.policy-card-header h2{font-family:'Fraunces',sans-serif;font-size:1.1rem;font-weight:800}
.policy-card-body{padding:24px 28px}
.refund-tiers{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin:24px 0}
.tier{border-radius:var(--radius);padding:20px;text-align:center;border:2px solid}
.tier.green{border-color:var(--success);background:var(--success-bg)}
.tier.yellow{border-color:var(--warning);background:var(--warning-bg)}
.tier.red{border-color:var(--danger);background:var(--danger-bg)}
.tier-pct{font-family:'Fraunces',sans-serif;font-size:2rem;font-weight:800;margin-bottom:4px}
.tier.green .tier-pct{color:var(--secondary-dark)}
.tier.yellow .tier-pct{color:var(--warning-dark)}
.tier.red .tier-pct{color:var(--danger-dark)}
.tier-label{font-size:.78rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted)}
.tier-time{font-size:.85rem;color:var(--text-muted);margin-top:6px}
.policy-list{list-style:none;display:flex;flex-direction:column;gap:10px}
.policy-list li{display:flex;gap:10px;padding:12px 16px;background:var(--bg);border-radius:var(--radius-sm);font-size:.9rem;line-height:1.6;color:var(--text)}
.policy-list li .ic{font-size:1.1rem;flex-shrink:0;margin-top:1px}
.step-list{counter-reset:step;display:flex;flex-direction:column;gap:12px}
.step-list li{display:flex;gap:14px;align-items:flex-start;font-size:.9rem;line-height:1.65;color:var(--text)}
.step-num{width:28px;height:28px;border-radius:50%;background:var(--grad-brand);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:.78rem;flex-shrink:0;margin-top:1px}
.notice{background:var(--warning-bg);border:1px solid var(--warning-border);border-radius:var(--radius);padding:16px 20px;color:var(--text);font-size:.88rem;line-height:1.65;display:flex;gap:10px;align-items:flex-start;margin-top:20px}
@media(max-width:640px){.refund-tiers{grid-template-columns:1fr}.policy-wrap{padding:32px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>

<div class="page-hero fade-up">
  <h1><i class="ph-bold ph-airplane-tilt"></i> Cancellation Policy</h1>
  <p>We understand plans change. Here's everything you need to know about cancellations and refunds.</p>
</div>

<div class="policy-wrap">

  <div class="policy-card fade-up">
    <div class="policy-card-header">
      <span style="font-size:1.4rem"><i class="ph-bold ph-hand-coins"></i></span>
      <h2>Refund Schedule</h2>
    </div>
    <div class="policy-card-body">
      <p style="color:var(--text-muted);font-size:.9rem;margin-bottom:20px">The refund amount depends on how far in advance you cancel before the scheduled departure time.</p>
      <div class="refund-tiers">
        <div class="tier green">
          <div class="tier-pct">100%</div>
          <div class="tier-label">Full Refund</div>
          <div class="tier-time">More than 24 hours<br>before departure</div>
        </div>
        <div class="tier yellow">
          <div class="tier-pct">50%</div>
          <div class="tier-label">Partial Refund</div>
          <div class="tier-time">2 – 24 hours<br>before departure</div>
        </div>
        <div class="tier red">
          <div class="tier-pct">0%</div>
          <div class="tier-label">No Refund</div>
          <div class="tier-time">Less than 2 hours<br>before departure</div>
        </div>
      </div>
      <div class="notice">
        <span><i class="ph-bold ph-warning"></i></span>
        <span>Refund percentages apply to the base ticket price. Convenience fees and payment gateway charges are non-refundable. Refunds are credited to the original payment method only.</span>
      </div>
    </div>
  </div>

  <div class="policy-card fade-up">
    <div class="policy-card-header">
      <span style="font-size:1.4rem"><i class="ph-bold ph-clipboard-text"></i></span>
      <h2>How to Cancel a Booking</h2>
    </div>
    <div class="policy-card-body">
      <ol class="step-list">
        <li><div class="step-num">1</div><span>Log in to your AeroSphere account and navigate to <strong>My Bookings</strong> from the navigation menu.</span></li>
        <li><div class="step-num">2</div><span>Find the booking you wish to cancel. Only bookings with <strong>PAID</strong> status can be cancelled for a refund.</span></li>
        <li><div class="step-num">3</div><span>Click the <strong>Cancel Booking</strong> button. A confirmation dialog will appear — confirm the cancellation.</span></li>
        <li><div class="step-num">4</div><span>A <strong>refund request</strong> is automatically created and sent to the admin team for review.</span></li>
        <li><div class="step-num">5</div><span>Once approved, the refund amount will be credited to your original payment method within <strong>3–5 business days</strong>. You'll receive an email notification.</span></li>
      </ol>
    </div>
  </div>

  <div class="policy-card fade-up">
    <div class="policy-card-header">
      <span style="font-size:1.4rem"><i class="ph-bold ph-push-pin"></i></span>
      <h2>Important Conditions</h2>
    </div>
    <div class="policy-card-body">
      <ul class="policy-list">
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span>Cancellations can only be made through your online account under "My Bookings". Phone or email cancellations are not accepted.</span></li>
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span>Only bookings with <strong>PAID</strong> status are eligible for cancellation and refund. Bookings that are already cancelled or expired cannot be cancelled again.</span></li>
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span>The refund is always credited to the <strong>same payment method</strong> used for the original booking. No cash refunds are provided.</span></li>
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span>Flight cancellations by the airline (force majeure, technical issues, weather) will result in a <strong>100% refund</strong> regardless of timing.</span></li>
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span>Group bookings (5+ passengers) may have different cancellation terms. Please contact support for group booking queries.</span></li>
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span>AeroSphere reserves the right to modify this policy. Changes will be notified via email and posted on this page.</span></li>
      </ul>
    </div>
  </div>

  <div class="policy-card fade-up">
    <div class="policy-card-header">
      <span style="font-size:1.4rem">⏱</span>
      <h2>Refund Processing Timeline</h2>
    </div>
    <div class="policy-card-body">
      <ul class="policy-list">
        <li><span class="ic"><i class="ph-bold ph-tray"></i></span><span><strong>Cancellation submitted:</strong> Immediate. Your booking status changes to CANCELLED and a refund request is created instantly.</span></li>
        <li><span class="ic"><i class="ph-bold ph-magnifying-glass"></i></span><span><strong>Admin review:</strong> 1–2 business days. Our team reviews the refund request against the cancellation policy.</span></li>
        <li><span class="ic"><i class="ph-bold ph-check-circle"></i></span><span><strong>Approval notification:</strong> You receive an email when the refund is approved or if there is any issue.</span></li>
        <li><span class="ic"><i class="ph-bold ph-credit-card"></i></span><span><strong>Credit to account:</strong> 3–5 business days after approval for cards. UPI refunds may reflect within 1–2 business days.</span></li>
      </ul>
    </div>
  </div>

  <div style="text-align:center;margin-top:40px" class="fade-up">
    <p style="color:var(--text-muted);margin-bottom:16px;font-size:.9rem">Have a question about your cancellation? We're here to help.</p>
    <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary"><i class="ph-bold ph-envelope-simple"></i> Contact Support</a>
  </div>

</div>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
</body>
</html>
