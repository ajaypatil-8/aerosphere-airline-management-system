<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.flightapp.model.*, com.flightapp.dao.*, java.util.*" %>
<%
    // ── Preserve all existing session/attribute reads ──
    HttpSession sess = request.getSession(false);
    String userEmail = (sess != null) ? (String) sess.getAttribute("userEmail") : null;
    if (userEmail == null) { response.sendRedirect("login.jsp"); return; }

    String bookingId    = (String) request.getAttribute("bookingId");
    String flightNo     = (String) request.getAttribute("flightNo");
    String from         = (String) request.getAttribute("from");
    String to           = (String) request.getAttribute("to");
    String depTime      = (String) request.getAttribute("depTime");
    String arrTime      = (String) request.getAttribute("arrTime");
    String travelClass  = (String) request.getAttribute("travelClass");
    String passengers   = (String) request.getAttribute("passengers");
    String totalFare    = (String) request.getAttribute("totalFare");
    String razorpayKey  = (String) request.getAttribute("razorpayKey");
    String razorpayOrderId = (String) request.getAttribute("razorpayOrderId");
    String amountPaise  = (String) request.getAttribute("amountPaise");
    String userName     = (String) request.getAttribute("userName");
    String userPhone    = (String) request.getAttribute("userPhone");
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Payment — SkyBook</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <!-- Project CSS -->
    <link rel="stylesheet" href="assests/css/style.css"/>
    <link rel="stylesheet" href="assests/css/animations.css"/>
    <!-- Razorpay SDK — UNCHANGED -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

    <style>
        /* ── Page layout ── */
        .pay-page {
            min-height: 100vh;
            background: var(--bg-0);
            background-image:
                radial-gradient(ellipse 60% 50% at 70% 10%, rgba(14,165,233,.12) 0%, transparent 70%),
                radial-gradient(ellipse 50% 40% at 10% 80%, rgba(16,185,129,.08) 0%, transparent 60%);
            display: flex;
            flex-direction: column;
        }

        .pay-wrapper {
            flex: 1;
            display: grid;
            grid-template-columns: 1fr 420px;
            gap: 2rem;
            max-width: 1100px;
            margin: 0 auto;
            padding: 2rem 1.5rem 4rem;
            width: 100%;
        }

        /* ── Section header ── */
        .pay-section-title {
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: .08em;
            text-transform: uppercase;
            color: var(--accent-blue);
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: .5rem;
        }
        .pay-section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, var(--accent-blue), transparent);
            opacity: .3;
        }

        /* ── Card base ── */
        .pay-card {
            background: var(--surface-1);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            animation: fadeUp .5s ease both;
        }
        .pay-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: var(--grad-brand);
        }

        /* ── Step indicators (left col) ── */
        .pay-steps {
            display: flex;
            gap: 0;
            margin-bottom: 2rem;
        }
        .pay-step {
            display: flex;
            align-items: center;
            gap: .5rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .8rem;
            color: var(--text-muted);
            font-weight: 500;
        }
        .pay-step.done .step-num {
            background: var(--grad-brand);
            color: #fff;
        }
        .pay-step.active .step-num {
            background: var(--grad-brand);
            color: #fff;
            box-shadow: 0 0 0 3px rgba(14,165,233,.3);
        }
        .pay-step.active { color: var(--text-primary); font-weight: 600; }
        .step-num {
            width: 28px; height: 28px;
            border-radius: 50%;
            background: var(--surface-2);
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            font-family: 'Syne', sans-serif;
            font-size: .75rem;
            font-weight: 700;
            flex-shrink: 0;
            transition: all .3s;
        }
        .step-line {
            flex: 1;
            height: 1px;
            background: var(--border);
            margin: 0 .4rem;
            min-width: 30px;
        }
        .step-line.done { background: var(--grad-brand); }

        /* ── Payment method tabs ── */
        .pay-methods {
            display: flex;
            gap: .75rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        .pay-method-btn {
            display: flex;
            align-items: center;
            gap: .5rem;
            padding: .65rem 1.2rem;
            border-radius: 12px;
            border: 1.5px solid var(--border);
            background: var(--surface-2);
            color: var(--text-secondary);
            font-family: 'DM Sans', sans-serif;
            font-size: .85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all .25s;
        }
        .pay-method-btn:hover {
            border-color: var(--accent-blue);
            color: var(--accent-blue);
        }
        .pay-method-btn.active {
            border-color: var(--accent-blue);
            background: rgba(14,165,233,.12);
            color: var(--accent-blue);
        }
        .pay-method-btn i { font-size: 1rem; }

        /* ── Razorpay highlight box ── */
        .razorpay-box {
            border: 1.5px dashed var(--border);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            margin-top: 1rem;
            background: var(--surface-2);
            transition: border-color .3s;
            animation: fadeUp .5s .2s ease both;
        }
        .razorpay-box:hover { border-color: var(--accent-blue); }
        .rzp-logo { font-size: 2.8rem; margin-bottom: .75rem; }
        .rzp-title {
            font-family: 'Syne', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: .4rem;
        }
        .rzp-desc {
            font-size: .85rem;
            color: var(--text-muted);
            font-family: 'DM Sans', sans-serif;
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }
        .rzp-badges {
            display: flex;
            justify-content: center;
            gap: .5rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }
        .rzp-badge {
            display: flex;
            align-items: center;
            gap: .3rem;
            padding: .3rem .75rem;
            border-radius: 20px;
            background: rgba(16,185,129,.1);
            color: var(--accent-green);
            font-size: .75rem;
            font-family: 'DM Sans', sans-serif;
            font-weight: 500;
        }

        /* ── Pay Now button ── */
        .btn-pay-now {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: .6rem;
            padding: 1rem 2.5rem;
            background: var(--grad-brand);
            color: #fff;
            border: none;
            border-radius: 14px;
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all .3s;
            position: relative;
            overflow: hidden;
            width: 100%;
            letter-spacing: .03em;
        }
        .btn-pay-now::after {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,0);
            transition: background .2s;
        }
        .btn-pay-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(14,165,233,.4);
        }
        .btn-pay-now:active { transform: translateY(0); }
        .btn-pay-now .spinner {
            display: none;
            width: 18px; height: 18px;
            border: 2px solid rgba(255,255,255,.3);
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin .7s linear infinite;
        }
        .btn-pay-now.loading .spinner { display: block; }
        .btn-pay-now.loading .btn-label { display: none; }

        /* ── Right col: Summary ── */
        .summary-col { display: flex; flex-direction: column; gap: 1.5rem; }

        .flight-summary-card {
            background: var(--surface-1);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            animation: fadeUp .5s .1s ease both;
            position: relative;
        }
        .flight-summary-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: var(--grad-brand);
        }
        .fsc-header {
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .fsc-title {
            font-family: 'Syne', sans-serif;
            font-size: .9rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        .fsc-badge {
            padding: .25rem .7rem;
            border-radius: 20px;
            background: rgba(14,165,233,.1);
            color: var(--accent-blue);
            font-size: .75rem;
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
        }

        .route-display {
            padding: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            position: relative;
        }
        .route-city {
            text-align: center;
            flex: 1;
        }
        .route-city .code {
            font-family: 'Syne', sans-serif;
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-primary);
        }
        .route-city .name {
            font-size: .75rem;
            color: var(--text-muted);
            font-family: 'DM Sans', sans-serif;
            margin-top: .1rem;
        }
        .route-city .time {
            font-size: .85rem;
            color: var(--accent-blue);
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
            margin-top: .3rem;
        }
        .route-arrow {
            flex: 0 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: .2rem;
        }
        .route-arrow i {
            color: var(--accent-blue);
            font-size: 1.1rem;
            animation: flyRight 2s ease-in-out infinite;
        }
        .route-line {
            width: 60px;
            height: 1px;
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-green));
        }

        /* Fare rows */
        .fare-rows {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            gap: .6rem;
        }
        .fare-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-family: 'DM Sans', sans-serif;
            font-size: .85rem;
            color: var(--text-secondary);
            padding: .3rem 0;
        }
        .fare-row.total {
            border-top: 1px solid var(--border);
            margin-top: .3rem;
            padding-top: .8rem;
            font-weight: 700;
            font-size: 1rem;
            color: var(--text-primary);
        }
        .fare-row.total .val {
            background: var(--grad-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-family: 'Syne', sans-serif;
            font-size: 1.1rem;
        }

        /* Trust badges */
        .trust-strip {
            display: flex;
            gap: .5rem;
            flex-direction: column;
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
        }
        .trust-item {
            display: flex;
            align-items: center;
            gap: .6rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .8rem;
            color: var(--text-muted);
        }
        .trust-item i { color: var(--accent-green); width: 14px; }

        /* Timer */
        .session-timer {
            display: flex;
            align-items: center;
            gap: .6rem;
            padding: .8rem 1.2rem;
            background: rgba(245,158,11,.08);
            border: 1px solid rgba(245,158,11,.2);
            border-radius: 12px;
            font-family: 'DM Sans', sans-serif;
            font-size: .85rem;
            color: #F59E0B;
            font-weight: 500;
            animation: fadeUp .5s .3s ease both;
        }
        #countdown { font-family: 'Syne', sans-serif; font-weight: 700; }

        /* ── Responsive ── */
        @media (max-width: 900px) {
            .pay-wrapper {
                grid-template-columns: 1fr;
            }
            .summary-col { order: -1; }
        }
        @media (max-width: 480px) {
            .pay-card { padding: 1.4rem; }
            .pay-methods { gap: .5rem; }
            .pay-method-btn { padding: .5rem .9rem; font-size: .78rem; }
        }

        @keyframes spin { to { transform: rotate(360deg); } }
        @keyframes flyRight {
            0%,100% { transform: translateX(0); }
            50% { transform: translateX(5px); }
        }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(18px); }
            to   { opacity:1; transform:translateY(0); }
        }
    </style>
</head>
<body>
<div class="pay-page">

    <%@ include file="common/navbar.jsp" %>

    <div class="pay-wrapper">
        <!-- ═══════════════ LEFT COL ═══════════════ -->
        <div class="pay-left-col">

            <!-- Step progress -->
            <div class="pay-steps" style="margin-bottom:1.8rem;">
                <div class="pay-step done">
                    <div class="step-num"><i class="fa fa-check" style="font-size:.65rem;"></i></div>
                    <span>Search</span>
                </div>
                <div class="step-line done"></div>
                <div class="pay-step done">
                    <div class="step-num"><i class="fa fa-check" style="font-size:.65rem;"></i></div>
                    <span>Details</span>
                </div>
                <div class="step-line done"></div>
                <div class="pay-step active">
                    <div class="step-num">3</div>
                    <span>Payment</span>
                </div>
                <div class="step-line"></div>
                <div class="pay-step">
                    <div class="step-num">4</div>
                    <span>Confirm</span>
                </div>
            </div>

            <!-- Payment card -->
            <div class="pay-card">
                <p class="pay-section-title"><i class="fa fa-credit-card"></i> Choose Payment Method</p>

                <!-- Method tabs -->
                <div class="pay-methods">
                    <button class="pay-method-btn active" onclick="selectMethod(this, 'razorpay')">
                        <i class="fa fa-bolt"></i> Razorpay
                    </button>
                    <button class="pay-method-btn" onclick="selectMethod(this, 'card')">
                        <i class="fa fa-credit-card"></i> Card
                    </button>
                    <button class="pay-method-btn" onclick="selectMethod(this, 'upi')">
                        <i class="fa fa-mobile-screen"></i> UPI
                    </button>
                    <button class="pay-method-btn" onclick="selectMethod(this, 'netbanking')">
                        <i class="fa fa-building-columns"></i> Net Banking
                    </button>
                </div>

                <!-- Razorpay panel (default) -->
                <div id="panel-razorpay" class="method-panel">
                    <div class="razorpay-box">
                        <div class="rzp-logo">⚡</div>
                        <div class="rzp-title">Pay Securely with Razorpay</div>
                        <div class="rzp-desc">
                            Complete your booking instantly using UPI, Cards, Net Banking, or Wallets —
                            all through Razorpay's secure gateway.
                        </div>
                        <div class="rzp-badges">
                            <span class="rzp-badge"><i class="fa fa-shield-halved"></i> SSL Secured</span>
                            <span class="rzp-badge"><i class="fa fa-lock"></i> PCI DSS</span>
                            <span class="rzp-badge"><i class="fa fa-rotate"></i> Instant Refunds</span>
                        </div>
                        <!-- ── RAZORPAY PAYMENT TRIGGER — BUSINESS LOGIC UNCHANGED ── -->
                        <button class="btn-pay-now" id="payNowBtn" onclick="initiateRazorpay()">
                            <span class="btn-label">
                                <i class="fa fa-lock"></i>
                                Pay ₹<%= totalFare != null ? totalFare : "0" %> Securely
                            </span>
                            <span class="spinner"></span>
                        </button>
                    </div>
                </div>

                <!-- Card panel (UI only placeholder) -->
                <div id="panel-card" class="method-panel" style="display:none;">
                    <div style="padding:1rem 0; color:var(--text-muted); font-family:'DM Sans',sans-serif; font-size:.9rem; text-align:center;">
                        <i class="fa fa-info-circle" style="color:var(--accent-blue); margin-right:.4rem;"></i>
                        Direct card payments are processed via Razorpay. Click the button above to proceed.
                    </div>
                    <button class="btn-pay-now" onclick="initiateRazorpay()">
                        <span class="btn-label"><i class="fa fa-lock"></i> Pay ₹<%= totalFare != null ? totalFare : "0" %> via Card</span>
                        <span class="spinner"></span>
                    </button>
                </div>

                <!-- UPI panel -->
                <div id="panel-upi" class="method-panel" style="display:none;">
                    <div style="padding:1rem 0; color:var(--text-muted); font-family:'DM Sans',sans-serif; font-size:.9rem; text-align:center;">
                        <i class="fa fa-mobile-screen" style="color:var(--accent-blue); margin-right:.4rem;"></i>
                        UPI options (GPay, PhonePe, Paytm) are available inside Razorpay's payment flow.
                    </div>
                    <button class="btn-pay-now" onclick="initiateRazorpay()">
                        <span class="btn-label"><i class="fa fa-lock"></i> Pay ₹<%= totalFare != null ? totalFare : "0" %> via UPI</span>
                        <span class="spinner"></span>
                    </button>
                </div>

                <!-- Net banking panel -->
                <div id="panel-netbanking" class="method-panel" style="display:none;">
                    <div style="padding:1rem 0; color:var(--text-muted); font-family:'DM Sans',sans-serif; font-size:.9rem; text-align:center;">
                        <i class="fa fa-building-columns" style="color:var(--accent-blue); margin-right:.4rem;"></i>
                        All major banks are supported inside Razorpay's payment flow.
                    </div>
                    <button class="btn-pay-now" onclick="initiateRazorpay()">
                        <span class="btn-label"><i class="fa fa-lock"></i> Pay ₹<%= totalFare != null ? totalFare : "0" %> via Net Banking</span>
                        <span class="spinner"></span>
                    </button>
                </div>
            </div><!-- /pay-card -->
        </div><!-- /pay-left-col -->

        <!-- ═══════════════ RIGHT COL ═══════════════ -->
        <div class="summary-col">

            <!-- Session timer -->
            <div class="session-timer">
                <i class="fa fa-clock"></i>
                Session expires in <span id="countdown">09:59</span> — complete payment soon
            </div>

            <!-- Flight summary -->
            <div class="flight-summary-card">
                <div class="fsc-header">
                    <span class="fsc-title">✈ Booking Summary</span>
                    <span class="fsc-badge"><%= travelClass != null ? travelClass : "Economy" %></span>
                </div>

                <div class="route-display">
                    <div class="route-city">
                        <div class="code"><%= from != null ? from.substring(0, Math.min(3, from.length())).toUpperCase() : "DEP" %></div>
                        <div class="name"><%= from != null ? from : "Departure" %></div>
                        <div class="time"><%= depTime != null ? depTime : "--:--" %></div>
                    </div>
                    <div class="route-arrow">
                        <div class="route-line"></div>
                        <i class="fa fa-plane"></i>
                        <div class="route-line"></div>
                    </div>
                    <div class="route-city">
                        <div class="code"><%= to != null ? to.substring(0, Math.min(3, to.length())).toUpperCase() : "ARR" %></div>
                        <div class="name"><%= to != null ? to : "Arrival" %></div>
                        <div class="time"><%= arrTime != null ? arrTime : "--:--" %></div>
                    </div>
                </div>

                <div class="fare-rows">
                    <div class="fare-row">
                        <span>Flight No.</span>
                        <span style="font-family:'Syne',sans-serif; font-weight:600; color:var(--text-primary);">
                            <%= flightNo != null ? flightNo : "—" %>
                        </span>
                    </div>
                    <div class="fare-row">
                        <span>Passengers</span>
                        <span><%= passengers != null ? passengers : "1" %></span>
                    </div>
                    <div class="fare-row">
                        <span>Class</span>
                        <span><%= travelClass != null ? travelClass : "Economy" %></span>
                    </div>
                    <div class="fare-row">
                        <span>Base Fare</span>
                        <span>₹<%= totalFare != null ? totalFare : "0" %></span>
                    </div>
                    <div class="fare-row">
                        <span>Taxes & Fees</span>
                        <span style="color:var(--text-muted);">Included</span>
                    </div>
                    <div class="fare-row total">
                        <span>Total Amount</span>
                        <span class="val">₹<%= totalFare != null ? totalFare : "0" %></span>
                    </div>
                </div>

                <div class="trust-strip">
                    <div class="trust-item"><i class="fa fa-check-circle"></i> Free cancellation within 24 hours</div>
                    <div class="trust-item"><i class="fa fa-check-circle"></i> Instant e-ticket on confirmation</div>
                    <div class="trust-item"><i class="fa fa-check-circle"></i> 256-bit SSL encrypted payment</div>
                </div>
            </div><!-- /flight-summary-card -->

        </div><!-- /summary-col -->
    </div><!-- /pay-wrapper -->

    <%@ include file="common/footer.jsp" %>
</div>

<!-- ── HIDDEN FORM FOR RAZORPAY CALLBACK — BUSINESS LOGIC UNCHANGED ── -->
<form id="razorpayResponseForm" action="PaymentVerificationServlet" method="POST" style="display:none;">
    <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id"/>
    <input type="hidden" name="razorpay_order_id"   id="razorpay_order_id"/>
    <input type="hidden" name="razorpay_signature"  id="razorpay_signature"/>
    <input type="hidden" name="bookingId"            value="<%= bookingId %>"/>
</form>

<script src="assests/js/main.js"></script>
<script>
    /* ── Method tab switching ── */
    function selectMethod(btn, panel) {
        document.querySelectorAll('.pay-method-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.method-panel').forEach(p => p.style.display = 'none');
        document.getElementById('panel-' + panel).style.display = 'block';
    }

    /* ── Countdown timer ── */
    (function startCountdown() {
        let secs = 599;
        const el = document.getElementById('countdown');
        const iv = setInterval(() => {
            if (secs <= 0) { clearInterval(iv); el.textContent = '00:00'; return; }
            const m = Math.floor(secs / 60).toString().padStart(2,'0');
            const s = (secs % 60).toString().padStart(2,'0');
            el.textContent = m + ':' + s;
            secs--;
        }, 1000);
    })();

    /* ── Razorpay initiation — BUSINESS LOGIC UNCHANGED ── */
    function initiateRazorpay() {
        const btn = document.getElementById('payNowBtn');
        if (btn) {
            btn.classList.add('loading');
            btn.disabled = true;
        }
        const options = {
            key:         '<%= razorpayKey %>',
            amount:      '<%= amountPaise %>',
            currency:    'INR',
            name:        'SkyBook Airlines',
            description: 'Flight Booking — <%= flightNo %>',
            order_id:    '<%= razorpayOrderId %>',
            prefill: {
                name:    '<%= userName %>',
                email:   '<%= userEmail %>',
                contact: '<%= userPhone %>'
            },
            theme: { color: '#0EA5E9' },
            handler: function(response) {
                document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                document.getElementById('razorpay_order_id').value   = response.razorpay_order_id;
                document.getElementById('razorpay_signature').value  = response.razorpay_signature;
                document.getElementById('razorpayResponseForm').submit();
            },
            modal: {
                ondismiss: function() {
                    if (btn) { btn.classList.remove('loading'); btn.disabled = false; }
                }
            }
        };
        const rzp = new Razorpay(options);
        rzp.open();
    }
</script>
</body>
</html>
