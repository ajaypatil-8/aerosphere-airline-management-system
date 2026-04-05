<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer id        = (Integer) request.getAttribute("id");
    String  flightNo  = (String)  request.getAttribute("flightNo");
    String  source    = (String)  request.getAttribute("source");
    String  dest      = (String)  request.getAttribute("destination");
    Object  date      = request.getAttribute("date");
    Object  depTime   = request.getAttribute("departTime");
    Object  arrTime   = request.getAttribute("arrivalTime");
    Double  price     = (Double)  request.getAttribute("price");
    Integer totalSeats= (Integer) request.getAttribute("totalSeats");
    Integer availSeats= (Integer) request.getAttribute("availableSeats");
    String depTimeStr = depTime != null ? depTime.toString().substring(0,5) : "";
    String arrTimeStr = arrTime != null ? arrTime.toString().substring(0,5) : "";
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Edit Flight – SkyConnect Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span> <small style="font-size:.6rem;color:var(--gold);font-weight:700;">ADMIN</small></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link active">Flights</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper medium">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">✏️ Edit Flight</h1>
      <p class="page-subtitle">Flight <strong style="color:var(--sky-glow)"><%= flightNo %></strong> — <%= source %> → <%= dest %></p>
    </div>
    <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-secondary">← Back</a>
  </div>

  <div class="card animate-fadeup">
    <!-- Read-only info -->
    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;margin-bottom:24px;padding:18px;background:rgba(0,87,255,.06);border-radius:12px;border:1px solid rgba(0,87,255,.15);">
      <div><div style="font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;margin-bottom:4px;">Flight No</div><div style="font-weight:700;color:var(--sky-glow)"><%= flightNo %></div></div>
      <div><div style="font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;margin-bottom:4px;">From</div><div style="font-weight:600"><%= source %></div></div>
      <div><div style="font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;margin-bottom:4px;">To</div><div style="font-weight:600"><%= dest %></div></div>
      <div><div style="font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;margin-bottom:4px;">Total Seats</div><div style="font-weight:600"><%= totalSeats %></div></div>
      <div><div style="font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;margin-bottom:4px;">Available Seats</div><div style="font-weight:600;color:#34D399"><%= availSeats %></div></div>
    </div>

    <form action="${pageContext.request.contextPath}/editFlight" method="post">
      <input type="hidden" name="id" value="<%= id %>">
      <div class="form-grid" style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
        <div class="form-group">
          <label>Departure Date *</label>
          <div class="field-wrap"><span class="fi">📅</span>
            <input type="date" name="depart_date" value="<%= date %>" required></div>
        </div>
        <div class="form-group">
          <label>Price per Seat (₹) *</label>
          <div class="field-wrap"><span class="fi">💰</span>
            <input type="number" name="price" value="<%= price != null ? price : "" %>" min="1" step="0.01" required></div>
        </div>
        <div class="form-group">
          <label>Departure Time *</label>
          <div class="field-wrap"><span class="fi">🕐</span>
            <input type="time" name="depart_time" value="<%= depTimeStr %>" required></div>
        </div>
        <div class="form-group">
          <label>Arrival Time</label>
          <div class="field-wrap"><span class="fi">🕑</span>
            <input type="time" name="arrival_time" value="<%= arrTimeStr %>"></div>
        </div>
      </div>
      <hr class="divider">
      <div style="display:flex;gap:12px;justify-content:flex-end;">
        <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary">✅ Save Changes</button>
      </div>
    </form>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
