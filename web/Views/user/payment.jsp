<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer bookingId   = (Integer) request.getAttribute("bookingId");
    Double  baseAmount  = (Double)  request.getAttribute("baseAmount");
    Double  gst         = (Double)  request.getAttribute("gst");
    Double  finalAmount = (Double)  request.getAttribute("finalAmount");
    if (baseAmount  == null) baseAmount  = 0.0;
    if (gst         == null) gst         = 0.0;
    if (finalAmount == null) finalAmount = 0.0;
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Payment – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
<style>
.pay-option{display:flex;align-items:center;gap:14px;padding:16px 20px;border:2px solid var(--border);border-radius:12px;margin-bottom:12px;cursor:pointer;transition:all .2s;}
.pay-option:hover,.pay-option.selected{border-color:var(--sky);background:rgba(0,87,255,.07);}
.pay-option input[type=radio]{accent-color:var(--sky);width:18px;height:18px;flex-shrink:0;}
.pay-icon{width:40px;height:40px;border-radius:10px;background:rgba(0,87,255,.12);display:flex;align-items:center;justify-content:center;font-size:1.3rem;}
.pay-label{font-family:'Syne',sans-serif;font-weight:700;font-size:.95rem;}
.pay-sub{font-size:.78rem;color:var(--muted);}
.fare-row{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid rgba(255,255,255,.06);font-size:.9rem;}
.fare-row:last-child{border-bottom:none;}
.fare-total{display:flex;justify-content:space-between;padding:14px 0;border-top:2px solid var(--sky-glow);}
.secure-badge{display:inline-flex;align-items:center;gap:6px;background:rgba(16,185,129,.08);border:1px solid rgba(16,185,129,.2);color:#34D399;border-radius:8px;padding:6px 14px;font-size:.78rem;font-weight:600;margin-top:12px;}
</style>
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">My Bookings</a>
    <a href="${pageContext.request.contextPath}/logout"        class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper medium">
  <!-- Steps -->
  <div class="steps animate-fadeup" style="margin-bottom:28px;">
    <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
    <div class="step-line done"></div>
    <div class="step done"><div class="step-circle">✓</div><div class="step-label">Confirm</div></div>
    <div class="step-line done"></div>
    <div class="step done"><div class="step-circle">✓</div><div class="step-label">Passengers</div></div>
    <div class="step-line done"></div>
    <div class="step active"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
    <div class="step-line"></div>
    <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
  </div>

  <div class="page-header animate-fadeup">
    <div><h1 class="page-title">💳 Complete Payment</h1><p class="page-subtitle">Booking #<%= bookingId %> · Secure checkout</p></div>
  </div>

  <div style="display:grid;grid-template-columns:1fr 380px;gap:24px;align-items:start;">
    <!-- Payment methods -->
    <div class="card animate-fadeup">
      <div class="section-label">Choose Payment Method</div>
      <form action="${pageContext.request.contextPath}/processPayment" method="post" id="payForm">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <label class="pay-option" onclick="selectPay(this)">
          <input type="radio" name="paymentMethod" value="UPI" required>
          <div class="pay-icon">📱</div>
          <div><div class="pay-label">UPI</div><div class="pay-sub">Google Pay, PhonePe, Paytm</div></div>
        </label>
        <label class="pay-option" onclick="selectPay(this)">
          <input type="radio" name="paymentMethod" value="CREDIT_CARD">
          <div class="pay-icon">💳</div>
          <div><div class="pay-label">Credit Card</div><div class="pay-sub">Visa, Mastercard, Amex</div></div>
        </label>
        <label class="pay-option" onclick="selectPay(this)">
          <input type="radio" name="paymentMethod" value="DEBIT_CARD">
          <div class="pay-icon">🏦</div>
          <div><div class="pay-label">Debit Card</div><div class="pay-sub">All major bank cards</div></div>
        </label>
        <label class="pay-option" onclick="selectPay(this)">
          <input type="radio" name="paymentMethod" value="NET_BANKING">
          <div class="pay-icon">🌐</div>
          <div><div class="pay-label">Net Banking</div><div class="pay-sub">50+ banks supported</div></div>
        </label>

        <hr class="divider">
        <button type="submit" class="btn btn-primary btn-lg btn-full" id="payBtn" disabled
          onclick="this.textContent='⏳ Processing...';this.disabled=true;payForm.submit();">
          🔒 Pay ₹<%= String.format("%,.0f", finalAmount) %> Securely
        </button>
        <div class="secure-badge">🔒 256-bit SSL encrypted · 100% secure</div>
      </form>
    </div>

    <!-- Fare summary -->
    <div class="card animate-fadeup delay-2">
      <div class="section-label">Fare Summary</div>
      <div class="fare-row"><span class="text-muted">Base Fare</span><span>₹<%= String.format("%,.2f", baseAmount) %></span></div>
      <div class="fare-row"><span class="text-muted">GST (5%)</span><span>₹<%= String.format("%,.2f", gst) %></span></div>
      <div class="fare-row"><span class="text-muted">Booking ID</span><span style="color:var(--sky-glow)">#<%= bookingId %></span></div>
      <div class="fare-total">
        <span style="font-family:'Syne',sans-serif;font-weight:700;">Total Payable</span>
        <span style="font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;color:var(--gold);">₹<%= String.format("%,.0f", finalAmount) %></span>
      </div>
      <p style="font-size:.75rem;color:var(--muted);margin-top:8px;line-height:1.5;">By completing payment you agree to SkyConnect's terms. Cancellations 24h+ before departure are eligible for a refund.</p>
    </div>
  </div>
</div>
<script>
function selectPay(el){
  document.querySelectorAll('.pay-option').forEach(o=>o.classList.remove('selected'));
  el.classList.add('selected');
  el.querySelector('input').checked=true;
  document.getElementById('payBtn').disabled=false;
  document.getElementById('payBtn').textContent='🔒 Pay ₹<%= String.format("%,.0f", finalAmount) %> Securely';
}
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
