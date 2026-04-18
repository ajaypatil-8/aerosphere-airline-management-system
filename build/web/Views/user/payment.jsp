<%@ page contentType="text/html;charset=UTF-8" %>
<%
    HttpSession sess = request.getSession(false);
    String userName = (sess != null) ? (String) sess.getAttribute("userName") : null;
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    // Attributes set by PaymentServlet.doGet
    Integer bookingId   = (Integer) request.getAttribute("bookingId");
    Double  baseAmount  = (Double)  request.getAttribute("baseAmount");
    Double  gst         = (Double)  request.getAttribute("gst");
    Double  finalAmount = (Double)  request.getAttribute("finalAmount");
    Integer numSeats    = (Integer) request.getAttribute("numSeats");
    String  flightNo    = (String)  request.getAttribute("flightNo");
    String  source      = (String)  request.getAttribute("source");
    String  destination = (String)  request.getAttribute("destination");
    String  departDate  = (String)  request.getAttribute("departDate");
    String  departTime  = (String)  request.getAttribute("departTime");
    String  arrivalTime = (String)  request.getAttribute("arrivalTime");

    if (bookingId == null) { response.sendRedirect(request.getContextPath() + "/userBookings"); return; }

    String userEmail = (String) sess.getAttribute("userEmail");
    if (userEmail == null) userEmail = "";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Payment – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<!-- Razorpay SDK -->
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<style>
.pay-page{min-height:100vh;background:var(--bg);display:flex;flex-direction:column}
.pay-wrapper{flex:1;display:grid;grid-template-columns:1fr 380px;gap:28px;max-width:1060px;margin:0 auto;padding:32px 24px 60px;width:100%}
@media(max-width:860px){.pay-wrapper{grid-template-columns:1fr}}

/* Steps */
.steps{display:flex;align-items:center;gap:0;margin-bottom:28px;flex-wrap:wrap;gap:4px}
.step{display:flex;align-items:center;gap:6px;font-size:.78rem;font-weight:500;color:var(--text-faint,#94A3B8)}
.step.active{color:var(--primary,#0EA5E9);font-weight:700}
.step.done{color:var(--success,#10B981)}
.step-circle{width:24px;height:24px;border-radius:50%;border:1.5px solid currentColor;display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:.7rem;font-weight:800;flex-shrink:0}
.step.active .step-circle,.step.done .step-circle{background:currentColor;color:#fff;border-color:transparent}
.step-line{flex:1;height:1px;background:var(--border,#E2E8F0);margin:0 6px;min-width:16px}
.step-line.done{background:var(--success,#10B981)}

/* Cards */
.pay-card{background:var(--surface-0,#fff);border:1px solid var(--border);border-radius:18px;overflow:hidden;box-shadow:var(--shadow,0 2px 12px rgba(0,0,0,.06));margin-bottom:16px;animation:fadeUp .5s var(--ease,.4s cubic-bezier(.16,1,.3,1)) both}
.pay-card-head{padding:14px 20px;background:var(--surface-1,#F8FAFC);border-bottom:1px solid var(--border);font-family:'Syne',sans-serif;font-size:.86rem;font-weight:700;display:flex;align-items:center;gap:8px}
.pay-card-body{padding:22px}

/* Test mode banner */
.test-banner{background:rgba(245,158,11,.1);border:1px solid rgba(245,158,11,.3);border-radius:10px;padding:11px 15px;font-size:.8rem;color:#D97706;font-weight:600;display:flex;align-items:flex-start;gap:8px;margin-bottom:16px;line-height:1.5}
[data-theme="dark"] .test-banner{background:rgba(245,158,11,.07);color:#FCD34D;border-color:rgba(245,158,11,.2)}

/* Razorpay box */
.rzp-box{border:2px dashed var(--border);border-radius:14px;padding:26px 20px;text-align:center;background:var(--surface-1,#F8FAFC);transition:border-color .2s}
.rzp-box:hover{border-color:var(--primary,#0EA5E9)}
.rzp-icon{font-size:2.5rem;margin-bottom:10px}
.rzp-title{font-family:'Syne',sans-serif;font-size:1.05rem;font-weight:800;color:var(--text);margin-bottom:6px}
.rzp-desc{font-size:.83rem;color:var(--text-muted);line-height:1.6;margin-bottom:16px;max-width:360px;margin-left:auto;margin-right:auto}
.rzp-badges{display:flex;justify-content:center;gap:7px;flex-wrap:wrap;margin-bottom:18px}
.rzp-badge{display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:99px;background:rgba(16,185,129,.1);color:#059669;font-size:.73rem;font-weight:600}
[data-theme="dark"] .rzp-badge{background:rgba(16,185,129,.15);color:#34D399}

/* Pay button */
.btn-pay{width:100%;padding:14px;background:var(--grad-brand,linear-gradient(135deg,#0EA5E9,#10B981));border:none;border-radius:12px;color:#fff;font-family:'Syne',sans-serif;font-size:.97rem;font-weight:800;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:9px;transition:transform .2s,box-shadow .2s;position:relative;overflow:hidden}
.btn-pay:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(14,165,233,.35)}
.btn-pay:active{transform:translateY(0)}
.btn-pay:disabled{opacity:.55;cursor:not-allowed;transform:none;box-shadow:none}
.btn-pay .spinner{display:none;width:17px;height:17px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite}
.btn-pay.loading .spinner{display:inline-block}
.btn-pay.loading .btn-label{display:none}

/* Summary card */
.summary-card{background:var(--surface-0,#fff);border:1px solid var(--border);border-radius:18px;overflow:hidden;box-shadow:var(--shadow);animation:fadeUp .5s var(--ease,.4s cubic-bezier(.16,1,.3,1)) .1s both}
.summary-head{padding:14px 20px;background:var(--surface-1);border-bottom:1px solid var(--border);font-family:'Syne',sans-serif;font-size:.86rem;font-weight:700;position:relative}
.summary-head::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad-brand,linear-gradient(135deg,#0EA5E9,#10B981))}
.route-block{padding:18px 20px;display:flex;align-items:center;justify-content:space-between;gap:10px}
.route-city .code{font-family:'Syne',sans-serif;font-size:1.45rem;font-weight:800;color:var(--text);line-height:1}
.route-city .name{font-size:.7rem;color:var(--text-muted);margin-top:3px;text-transform:uppercase;letter-spacing:.05em}
.route-city .time{font-size:.78rem;color:var(--primary,#0EA5E9);font-weight:600;margin-top:4px}
.route-arrow{font-size:1.25rem;color:var(--primary,#0EA5E9);animation:floatAnim 3s ease-in-out infinite}
.fare-row{display:flex;justify-content:space-between;align-items:center;padding:10px 20px;font-size:.865rem;border-top:1px solid var(--border)}
.fare-row-lbl{color:var(--text-muted)}
.fare-row-val{font-weight:600;color:var(--text)}
.fare-total{display:flex;justify-content:space-between;align-items:center;padding:13px 20px;background:var(--primary-glow,rgba(14,165,233,.07));border-top:2px solid var(--primary,#0EA5E9)}
.fare-total-lbl{font-family:'Syne',sans-serif;font-weight:800;color:var(--text)}
.fare-total-val{font-family:'Syne',sans-serif;font-size:1.25rem;font-weight:800;color:var(--primary,#0EA5E9)}

/* Timer */
.timer-bar{display:flex;align-items:center;gap:8px;padding:10px 14px;background:rgba(245,158,11,.08);border:1px solid rgba(245,158,11,.22);border-radius:10px;font-size:.81rem;color:#D97706;font-weight:600;margin-bottom:14px}
#countdown{font-family:'Syne',sans-serif;font-weight:800}

/* Error toast */
.err-toast{background:#FEF2F2;border:1px solid #FECACA;color:#DC2626;border-radius:10px;padding:11px 15px;font-size:.84rem;margin-bottom:14px;display:none;line-height:1.5}
[data-theme="dark"] .err-toast{background:rgba(220,38,38,.1);border-color:rgba(220,38,38,.25);color:#FCA5A5}

@keyframes spin{to{transform:rotate(360deg)}}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>
<div class="pay-page">
<div class="pay-wrapper">

  <!-- ═══ LEFT COL ═══ -->
  <div>
    <!-- Steps -->
    <div class="steps">
      <div class="step done"><div class="step-circle">✓</div><span>Search</span></div>
      <div class="step-line done"></div>
      <div class="step done"><div class="step-circle">✓</div><span>Confirm</span></div>
      <div class="step-line done"></div>
      <div class="step done"><div class="step-circle">✓</div><span>Passengers</span></div>
      <div class="step-line done"></div>
      <div class="step active"><div class="step-circle">4</div><span>Payment</span></div>
      <div class="step-line"></div>
      <div class="step"><div class="step-circle">5</div><span>Ticket</span></div>
    </div>

    <!-- Error area -->
    <div class="err-toast" id="errToast"></div>

    <!-- TEST MODE notice -->
    <div class="test-banner">
      🧪 <div>
        <strong>TEST MODE</strong> — Razorpay is in test mode.<br>
        Use card <code>4111 1111 1111 1111</code> &nbsp;|&nbsp; Expiry: any future date &nbsp;|&nbsp; CVV: any 3 digits
      </div>
    </div>

    <!-- Pay card -->
    <div class="pay-card">
      <div class="pay-card-head">⚡ Pay Securely with Razorpay</div>
      <div class="pay-card-body">
        <div class="rzp-box">
          <div class="rzp-icon">⚡</div>
          <div class="rzp-title">Razorpay Secure Checkout</div>
          <div class="rzp-desc">
            Complete your booking with UPI, Cards, Net Banking or Wallets.<br>
            All payments are 256-bit SSL encrypted.
          </div>
          <div class="rzp-badges">
            <span class="rzp-badge">🔒 SSL</span>
            <span class="rzp-badge">🛡 PCI DSS</span>
            <span class="rzp-badge">⚡ Instant Confirm</span>
            <span class="rzp-badge">🔄 Easy Refunds</span>
          </div>
          <button class="btn-pay" id="payBtn" onclick="startPayment()">
            <span class="btn-label">🔒&nbsp; Pay ₹<%= String.format("%.2f", finalAmount) %> Now</span>
            <span class="spinner"></span>
          </button>
        </div>
      </div>
    </div>

    <div style="text-align:center;font-size:.78rem;color:var(--text-faint,#94A3B8);margin-top:6px">
      Booking #<%= bookingId %> &nbsp;·&nbsp; Powered by Razorpay &nbsp;·&nbsp; 🔐 Secure &amp; Encrypted
    </div>
  </div>

  <!-- ═══ RIGHT COL ═══ -->
  <div>
    <div class="timer-bar">
      ⏱ Expires in <span id="countdown">09:59</span>
    </div>

    <div class="summary-card">
      <div class="summary-head">✈ Booking Summary</div>
      <div class="route-block">
        <div class="route-city">
          <div class="code"><%= source != null && source.length()>=3 ? source.substring(0,3).toUpperCase() : (source!=null?source.toUpperCase():"DEP") %></div>
          <div class="name"><%= source != null ? source : "—" %></div>
          <div class="time">🛫 <%= departTime != null ? departTime : "—" %></div>
        </div>
        <div class="route-arrow">✈</div>
        <div class="route-city" style="text-align:right">
          <div class="code"><%= destination != null && destination.length()>=3 ? destination.substring(0,3).toUpperCase() : (destination!=null?destination.toUpperCase():"ARR") %></div>
          <div class="name"><%= destination != null ? destination : "—" %></div>
          <div class="time">🛬 <%= arrivalTime != null ? arrivalTime : "—" %></div>
        </div>
      </div>
      <div class="fare-row"><span class="fare-row-lbl">Flight</span><span class="fare-row-val" style="color:var(--primary)"><%= flightNo != null ? flightNo : "—" %></span></div>
      <div class="fare-row"><span class="fare-row-lbl">Date</span><span class="fare-row-val"><%= departDate != null ? departDate : "—" %></span></div>
      <div class="fare-row"><span class="fare-row-lbl">Passengers</span><span class="fare-row-val"><%= numSeats != null ? numSeats : 1 %></span></div>
      <div class="fare-row"><span class="fare-row-lbl">Base Fare</span><span class="fare-row-val">₹<%= String.format("%.2f", baseAmount) %></span></div>
      <div class="fare-row"><span class="fare-row-lbl">GST (5%)</span><span class="fare-row-val">₹<%= String.format("%.2f", gst) %></span></div>
      <div class="fare-total">
        <span class="fare-total-lbl">Total Payable</span>
        <span class="fare-total-val">₹<%= String.format("%.2f", finalAmount) %></span>
      </div>
    </div>
  </div>

</div><!-- /pay-wrapper -->
</div><!-- /pay-page -->

<!-- Hidden form for signature verification -->
<form id="verifyForm" action="${pageContext.request.contextPath}/verifyPayment" method="post" style="display:none">
  <input type="hidden" name="razorpay_payment_id" id="f_payment_id">
  <input type="hidden" name="razorpay_order_id"   id="f_order_id">
  <input type="hidden" name="razorpay_signature"  id="f_signature">
  <input type="hidden" name="bookingId"            value="<%= bookingId %>">
</form>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
// Countdown timer
(function(){
  var secs = 599, el = document.getElementById('countdown');
  var iv = setInterval(function(){
    if(secs <= 0){ clearInterval(iv); el.textContent = '00:00'; return; }
    el.textContent = String(Math.floor(secs/60)).padStart(2,'0') + ':' + String(secs%60).padStart(2,'0');
    secs--;
  }, 1000);
})();

function showErr(msg){
  var t = document.getElementById('errToast');
  t.textContent = '⚠ ' + msg;
  t.style.display = 'block';
  t.scrollIntoView({behavior:'smooth', block:'nearest'});
}

async function startPayment() {
  var btn = document.getElementById('payBtn');
  btn.classList.add('loading');
  btn.disabled = true;
  document.getElementById('errToast').style.display = 'none';

  try {
    // 1. Create Razorpay order via server
    var res = await fetch('${pageContext.request.contextPath}/createRazorpayOrder', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'bookingId=<%= bookingId %>'
    });

    if (!res.ok) {
      var err = await res.json().catch(function(){ return {error: 'Server error ('+res.status+')'}; });
      showErr(err.error || 'Could not create order. Try again.');
      btn.classList.remove('loading'); btn.disabled = false;
      return;
    }

    var data = await res.json();
    if (data.error) {
      showErr(data.error);
      btn.classList.remove('loading'); btn.disabled = false;
      return;
    }

    // 2. Open Razorpay checkout (test key from server)
    var rzp = new Razorpay({
      key:         data.keyId,
      amount:      data.amount,
      currency:    data.currency || 'INR',
      name:        'AeroSphere Airlines',
      description: 'Flight Booking #<%= bookingId %>',
      order_id:    data.orderId,
      prefill: {
        name:    '<%= userName.replace("'", "\\'") %>',
        email:   '<%= userEmail.replace("'", "\\'") %>',
        contact: ''
      },
      notes: { booking_id: '<%= bookingId %>' },
      theme: { color: '#0EA5E9' },
      handler: async function(response) {
        // 3. Verify payment signature on server via fetch (servlet returns JSON)
        try {
          var params = new URLSearchParams();
          params.append('razorpay_payment_id', response.razorpay_payment_id);
          params.append('razorpay_order_id',   response.razorpay_order_id);
          params.append('razorpay_signature',  response.razorpay_signature);
          params.append('bookingId',           '<%= bookingId %>');

          var vRes = await fetch('${pageContext.request.contextPath}/verifyPayment', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: params.toString()
          });

          var vData = await vRes.json();

          if (vData.success && vData.redirect) {
            window.location.href = vData.redirect;
          } else {
            showErr(vData.error || 'Payment verification failed. Contact support.');
            btn.classList.remove('loading'); btn.disabled = false;
          }
        } catch(e) {
          showErr('Verification error. Please check My Bookings to confirm status.');
          btn.classList.remove('loading'); btn.disabled = false;
        }
      },
      modal: {
        ondismiss: function() {
          btn.classList.remove('loading'); btn.disabled = false;
        }
      }
    });

    rzp.on('payment.failed', function(resp){
      showErr('Payment failed: ' + (resp.error.description || 'Unknown error'));
      btn.classList.remove('loading'); btn.disabled = false;
    });

    rzp.open();

  } catch(e) {
    showErr('Network error. Please check connection and try again.');
    btn.classList.remove('loading'); btn.disabled = false;
  }
}
</script>
</body>
</html>
