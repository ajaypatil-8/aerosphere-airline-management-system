<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String bookingId = request.getParameter("bookingId");
    if (bookingId == null) { response.sendRedirect("userDashboard"); return; }
    Object amountObj = request.getAttribute("amount");
    double amount = amountObj != null ? (Double) amountObj : 0;
    String flightNo = (String) request.getAttribute("flightNo");
    String source   = (String) request.getAttribute("source");
    String dest     = (String) request.getAttribute("destination");
    String error    = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .method-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 12px; margin: 16px 0; }
        .method-card {
            border: 2px solid var(--border); border-radius: 12px;
            padding: 16px 12px; text-align: center; cursor: pointer;
            transition: all .2s; background: rgba(255,255,255,.03);
        }
        .method-card:hover { border-color: var(--sky-glow); background: rgba(0,87,255,.07); }
        .method-card.selected { border-color: var(--sky); background: rgba(0,87,255,.12); }
        .method-card input[type=radio] { display: none; }
        .method-icon { font-size: 1.8rem; margin-bottom: 8px; }
        .method-label { font-size: .8rem; font-weight: 600; color: rgba(255,255,255,.7); }
        .amount-box {
            background: linear-gradient(135deg, rgba(0,57,200,.2), rgba(0,87,255,.08));
            border: 1px solid rgba(0,87,255,.3); border-radius: 14px;
            padding: 24px; text-align: center; margin-bottom: 24px;
        }
        .amount-label { font-size: .8rem; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; }
        .amount-value { font-family: 'Syne',sans-serif; font-size: 2.8rem; font-weight: 800; color: var(--gold); }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper narrow">

    <div class="steps">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
        <div class="step-line done"></div>
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Book</div></div>
        <div class="step-line done"></div>
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Passengers</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
    </div>

    <div class="page-header">
        <div>
            <h1 class="page-title">💳 Payment</h1>
            <p class="page-subtitle">Secure payment for booking #<%= bookingId %></p>
        </div>
    </div>

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

    <!-- Amount Display -->
    <div class="amount-box">
        <div class="amount-label">Total Amount Due</div>
        <div class="amount-value">₹<%= String.format("%,.2f", amount) %></div>
        <% if (flightNo != null) { %>
        <div style="margin-top:10px;font-size:.875rem;color:var(--muted);">
            ✈ <%= flightNo %>
            <% if (source != null && dest != null) { %>
            &nbsp;·&nbsp; <%= source %> → <%= dest %>
            <% } %>
        </div>
        <% } %>
    </div>

    <form action="processPayment" method="post" onsubmit="return validateMethod()">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <div class="card-glow" style="padding:28px;">
            <div class="section-label">Select Payment Method</div>
            <div class="method-cards" id="methodCards">
                <label class="method-card" onclick="selectMethod(this, 'UPI')">
                    <input type="radio" name="paymentMethod" value="UPI">
                    <div class="method-icon">📱</div>
                    <div class="method-label">UPI</div>
                </label>
                <label class="method-card" onclick="selectMethod(this, 'CREDIT_CARD')">
                    <input type="radio" name="paymentMethod" value="CREDIT_CARD">
                    <div class="method-icon">💳</div>
                    <div class="method-label">Credit Card</div>
                </label>
                <label class="method-card" onclick="selectMethod(this, 'DEBIT_CARD')">
                    <input type="radio" name="paymentMethod" value="DEBIT_CARD">
                    <div class="method-icon">💳</div>
                    <div class="method-label">Debit Card</div>
                </label>
                <label class="method-card" onclick="selectMethod(this, 'NET_BANKING')">
                    <input type="radio" name="paymentMethod" value="NET_BANKING">
                    <div class="method-icon">🏦</div>
                    <div class="method-label">Net Banking</div>
                </label>
                <label class="method-card" onclick="selectMethod(this, 'WALLET')">
                    <input type="radio" name="paymentMethod" value="WALLET">
                    <div class="method-icon">👜</div>
                    <div class="method-label">Wallet</div>
                </label>
                <label class="method-card" onclick="selectMethod(this, 'CASH')">
                    <input type="radio" name="paymentMethod" value="CASH">
                    <div class="method-icon">💵</div>
                    <div class="method-label">Cash</div>
                </label>
            </div>
            <div id="methodError" style="display:none;" class="alert alert-error" style="margin-top:8px;">Please select a payment method.</div>

            <div style="margin-top:6px;font-size:.78rem;color:var(--muted);">🔒 Payments are securely processed</div>
        </div>

        <div style="display:flex;gap:12px;margin-top:16px;">
            <a href="userDashboard" class="btn btn-ghost" style="flex:1;justify-content:center;">← Cancel</a>
            <button type="submit" class="btn btn-blue" style="flex:2;font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;">
                💳 Pay ₹<%= String.format("%,.2f", amount) %>
            </button>
        </div>
    </form>

</div>

<script>
function selectMethod(el, val) {
    document.querySelectorAll('.method-card').forEach(c => c.classList.remove('selected'));
    el.classList.add('selected');
    el.querySelector('input').checked = true;
    document.getElementById('methodError').style.display = 'none';
}
function validateMethod() {
    const checked = document.querySelector('input[name="paymentMethod"]:checked');
    if (!checked) {
        document.getElementById('methodError').style.display = 'flex';
        return false;
    }
    return true;
}
const s = document.getElementById('stars');
for (let i = 0; i < 60; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
