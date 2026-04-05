<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    Integer seats     = (Integer) request.getAttribute("seats");
    if (seats == null) seats = 1;
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Passenger Details – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
<style>
.passenger-card{background:rgba(0,87,255,.05);border:1px solid rgba(0,87,255,.18);border-radius:14px;padding:24px;margin-bottom:20px;position:relative;}
.passenger-num{position:absolute;top:-12px;left:20px;background:var(--sky);color:#fff;font-family:'Syne',sans-serif;font-weight:800;font-size:.82rem;padding:3px 14px;border-radius:99px;}
.pax-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;}
@media(max-width:700px){.pax-grid{grid-template-columns:1fr 1fr;}}
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
    <div class="step active"><div class="step-circle">3</div><div class="step-label">Passengers</div></div>
    <div class="step-line"></div>
    <div class="step"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
    <div class="step-line"></div>
    <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
  </div>

  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">👥 Passenger Details</h1>
      <p class="page-subtitle">Fill details for all <%= seats %> passenger(s) — Booking #<%= bookingId %></p>
    </div>
  </div>

  <form action="${pageContext.request.contextPath}/savePassengers" method="post">
    <input type="hidden" name="bookingId" value="<%= bookingId %>">

    <% for (int i = 1; i <= seats; i++) { %>
    <div class="passenger-card animate-fadeup">
      <div class="passenger-num">Passenger <%= i %></div>
      <div class="pax-grid" style="margin-top:8px;">
        <div class="form-group" style="grid-column:1/-1;">
          <label>Full Name *</label>
          <div class="field-wrap"><span class="fi">👤</span><input type="text" name="full_name[]" placeholder="As on ID/Passport" required></div>
        </div>
        <div class="form-group">
          <label>Age *</label>
          <div class="field-wrap"><span class="fi">🔢</span><input type="number" name="age[]" placeholder="e.g. 25" min="1" max="120" required></div>
        </div>
        <div class="form-group">
          <label>Gender *</label>
          <div class="field-wrap no-icon"><select name="gender[]" required>
            <option value="">Select</option>
            <option value="MALE">Male</option>
            <option value="FEMALE">Female</option>
            <option value="OTHER">Other</option>
          </select></div>
        </div>
        <div class="form-group">
          <label>Date of Birth</label>
          <div class="field-wrap"><span class="fi">📅</span><input type="date" name="dob[]"></div>
        </div>
        <div class="form-group">
          <label>Phone</label>
          <div class="field-wrap"><span class="fi">📱</span><input type="tel" name="phone[]" placeholder="+91 XXXXXXXXXX"></div>
        </div>
        <div class="form-group">
          <label>Email</label>
          <div class="field-wrap"><span class="fi">✉️</span><input type="email" name="email[]" placeholder="passenger@email.com"></div>
        </div>
      </div>
    </div>
    <% } %>

    <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:8px;">
      <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-secondary">← Cancel</a>
      <button type="submit" class="btn btn-primary btn-lg">Continue to Payment →</button>
    </div>
  </form>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
