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
    // Show error if payment failed (?error=1 from PaymentServlet redirect)
    String payError = "1".equals(request.getParameter("error"))
        ? "Payment processing failed. Please try again." : null;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Payment – AeroSphere</title>
<%-- FIX: Apply theme before paint to prevent flash --%>
<script>
(function(){
  var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');
  document.documentElement.setAttribute('data-theme',t);
})();
</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.page-wrapper{max-width:900px;margin:0 auto;padding:32px 24px}
.steps{display:flex;align-items:center;margin-bottom:28px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.step{display:flex;flex-direction:column;align-items:center;gap:5px}
.step-circle{width:34px;height:34px;border-radius:50%;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:700;color:var(--text-muted);background:var(--card-bg);transition:all .3s}
.step.done .step-circle{background:var(--primary);border-color:var(--primary);color:#fff}
.step.active .step-circle{border-color:var(--primary);color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.step-label{font-size:.7rem;font-weight:600;color:var(--text-muted);white-space:nowrap}
.step-line{flex:1;height:2px;background:var(--border);margin:0 8px;align-self:center}
.step-line.done{background:var(--primary)}
.page-header{margin-bottom:20px}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* ERROR ALERT */
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626;border-radius:11px;padding:12px 16px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px;margin-bottom:20px}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.two-col{display:grid;grid-template-columns:1fr 360px;gap:24px;align-items:start}
.card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);animation:fadeUp .5s ease both .1s}
.card-inner{padding:24px}
.card-title{font-size:.82rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted);margin-bottom:18px;padding-bottom:12px;border-bottom:1px solid var(--border)}
.pay-option{display:flex;align-items:center;gap:14px;padding:14px 16px;border:2px solid var(--border);border-radius:11px;margin-bottom:10px;cursor:pointer;transition:all .2s}
.pay-option:hover,.pay-option.selected{border-color:var(--primary);background:var(--primary-glow)}
.pay-option input[type=radio]{accent-color:var(--primary);width:17px;height:17px;flex-shrink:0;cursor:pointer}
.pay-icon{width:38px;height:38px;border-radius:10px;background:var(--bg);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.2rem}
.pay-label{font-size:.9rem;font-weight:600}
.pay-sub{font-size:.76rem;color:var(--text-muted);margin-top:2px}
.fare-row{display:flex;justify-content:space-between;padding:9px 0;border-bottom:1px solid var(--border);font-size:.88rem}
.fare-row:last-of-type{border-bottom:none}
.fare-row .lbl{color:var(--text-muted)}
.fare-total{display:flex;justify-content:space-between;padding:14px 0;border-top:2px solid var(--primary);margin-top:4px}
.fare-total .lbl{font-weight:700;font-size:.95rem}
.fare-total .val{font-size:1.4rem;font-weight:900;color:var(--primary)}
.btn-pay{display:flex;align-items:center;justify-content:center;gap:8px;width:100%;padding:15px;background:var(--primary);border:none;border-radius:11px;color:#fff;font-family:'Inter',sans-serif;font-size:.95rem;font-weight:700;cursor:pointer;transition:all .25s;box-shadow:0 5px 18px var(--primary-glow);margin-top:16px}
.btn-pay:hover{background:var(--primary-dark);transform:translateY(-2px);box-shadow:0 8px 24px var(--primary-glow)}
.btn-pay:disabled{opacity:.45;cursor:not-allowed;transform:none}
.secure-badge{display:inline-flex;align-items:center;gap:6px;background:rgba(16,185,129,.08);border:1px solid var(--primary);color:var(--primary);border-radius:8px;padding:7px 14px;font-size:.76rem;font-weight:600;margin-top:12px;width:100%;justify-content:center}
.pay-note{font-size:.75rem;color:var(--text-muted);margin-top:10px;line-height:1.55}
hr.divider{border:none;border-top:1px solid var(--border);margin:18px 0}
@media(max-width:768px){.two-col{grid-template-columns:1fr}}
</style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">My Bookings</a>
        <a href="${pageContext.request.contextPath}/logout"        class="nav-link btn-danger">Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <!-- STEPS -->
    <div class="steps">
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

    <div class="page-header">
        <div class="page-title">💳 Complete Payment</div>
        <div class="page-subtitle">Booking #<%= bookingId %> · Secure checkout</div>
    </div>

    <%-- FIX: Show payment error if ?error=1 returned from PaymentServlet --%>
    <% if (payError != null) { %>
    <div class="alert-error">⚠️ <%= payError %></div>
    <% } %>

    <div class="two-col">
        <!-- PAYMENT METHODS -->
        <div class="card">
            <div class="card-inner">
                <div class="card-title">Choose Payment Method</div>
                <%-- FIX: form action changed from /processPayment → /payment --%>
                <form action="${pageContext.request.contextPath}/payment" method="post" id="payForm">
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
                    <button type="submit" class="btn-pay" id="payBtn" disabled>
                        🔒 Pay ₹<%= String.format("%,.0f", finalAmount) %> Securely
                    </button>
                    <div class="secure-badge">🔒 256-bit SSL encrypted · 100% secure</div>
                </form>
            </div>
        </div>

        <!-- FARE SUMMARY -->
        <div class="card" style="animation-delay:.15s">
            <div class="card-inner">
                <div class="card-title">Fare Summary</div>
                <div class="fare-row"><span class="lbl">Base Fare</span><span>₹<%= String.format("%,.2f", baseAmount) %></span></div>
                <div class="fare-row"><span class="lbl">GST (5%)</span><span>₹<%= String.format("%,.2f", gst) %></span></div>
                <div class="fare-row"><span class="lbl">Booking ID</span><span style="color:var(--primary);font-weight:600">#<%= bookingId %></span></div>
                <div class="fare-total">
                    <span class="lbl">Total Payable</span>
                    <span class="val">₹<%= String.format("%,.0f", finalAmount) %></span>
                </div>
                <p class="pay-note">By completing payment you agree to AeroSphere's terms. Cancellations more than 24h before departure: 100% refund. 2–24h before departure: 50% refund.</p>
            </div>
        </div>
    </div>
</div>

<script>
// FIX: Set correct toggle icon immediately from localStorage
(function(){
  var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');
  document.documentElement.setAttribute('data-theme',t);
  var btn=document.getElementById('themeToggle');
  if(btn) btn.textContent=t==='dark'?'☀️':'🌙';
})();
function toggleTheme(){
  var n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',n);
  localStorage.setItem('aerosphere-theme',n);
  document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';
}
function selectPay(el){
  document.querySelectorAll('.pay-option').forEach(function(o){o.classList.remove('selected');});
  el.classList.add('selected');
  el.querySelector('input').checked=true;
  var btn=document.getElementById('payBtn');
  btn.disabled=false;
  btn.textContent='🔒 Pay ₹<%= String.format("%,.0f", finalAmount) %> Securely';
}
// Prevent double-submit
document.getElementById('payForm').addEventListener('submit',function(){
  var btn=document.getElementById('payBtn');
  btn.disabled=true;
  btn.textContent='⏳ Processing payment...';
});
</script>
</body></html>
