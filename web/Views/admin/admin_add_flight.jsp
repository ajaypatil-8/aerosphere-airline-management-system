<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String flightError   = (String) session.getAttribute("flightError");
    String flightSuccess = (String) session.getAttribute("flightSuccess");
    session.removeAttribute("flightError");
    session.removeAttribute("flightSuccess");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Add Flight – SkyConnect Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span> <small style="font-size:.6rem;color:var(--gold);font-weight:700;">ADMIN</small></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper medium">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">✈ Schedule a Flight</h1>
      <p class="page-subtitle">Add a new flight to the SkyConnect network</p>
    </div>
    <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-secondary">← All Flights</a>
  </div>

  <% if (flightError != null) { %><div class="alert alert-error">⚠ <%= flightError %></div><% } %>
  <% if (flightSuccess != null) { %><div class="alert alert-success">✅ <%= flightSuccess %></div><% } %>

  <div class="card animate-fadeup">
    <form action="${pageContext.request.contextPath}/addFlight" method="post">

      <div class="form-grid" style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
        <div class="form-group">
          <label>Flight Number *</label>
          <div class="field-wrap"><span class="fi">🛩</span>
            <input type="text" name="flight_no" placeholder="e.g. SK101" required maxlength="20"></div>
        </div>
        <div class="form-group">
          <label>Departure Date *</label>
          <div class="field-wrap"><span class="fi">📅</span>
            <input type="date" name="depart_date" required></div>
        </div>
        <div class="form-group">
          <label>From (Source) *</label>
          <div class="field-wrap"><span class="fi">🛫</span>
            <input type="text" name="source" placeholder="e.g. Mumbai" required maxlength="100"></div>
        </div>
        <div class="form-group">
          <label>To (Destination) *</label>
          <div class="field-wrap"><span class="fi">🛬</span>
            <input type="text" name="destination" placeholder="e.g. Delhi" required maxlength="100"></div>
        </div>
        <div class="form-group">
          <label>Departure Time *</label>
          <div class="field-wrap"><span class="fi">🕐</span>
            <input type="time" name="depart_time" required></div>
        </div>
        <div class="form-group">
          <label>Arrival Time</label>
          <div class="field-wrap"><span class="fi">🕑</span>
            <input type="time" name="arrival_time"></div>
        </div>
        <div class="form-group">
          <label>Price per Seat (₹) *</label>
          <div class="field-wrap"><span class="fi">💰</span>
            <input type="number" name="price" placeholder="e.g. 4500" min="1" step="0.01" required></div>
        </div>
        <div class="form-group">
          <label>Total Seats *</label>
          <div class="field-wrap"><span class="fi">💺</span>
            <input type="number" name="seats_total" placeholder="e.g. 180" min="1" max="999" required></div>
        </div>
      </div>

      <hr class="divider">
      <div style="display:flex;gap:12px;justify-content:flex-end;">
        <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-secondary">Cancel</a>
        <button type="reset"  class="btn btn-secondary">Reset</button>
        <button type="submit" class="btn btn-primary btn-lg">✈ Schedule Flight</button>
      </div>
    </form>
  </div>
</div>
<script>
document.querySelector('input[name="depart_date"]').min = new Date().toISOString().split('T')[0];
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
