<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminFlightsServlet.Flight" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Flight> flights    = (List<Flight>) request.getAttribute("flights");
    String deleteError   = (String) session.getAttribute("deleteError");
    String deleteSuccess = (String) session.getAttribute("deleteSuccess");
    session.removeAttribute("deleteError"); session.removeAttribute("deleteSuccess");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Manage Flights – SkyConnect Admin</title>
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
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">✈ Flight Schedule</h1>
      <p class="page-subtitle"><%= flights != null ? flights.size() : 0 %> flights in the system</p>
    </div>
    <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary">+ Add Flight</a>
  </div>

  <% if (deleteError != null)   { %><div class="alert alert-error">⚠ <%= deleteError %></div><% } %>
  <% if (deleteSuccess != null) { %><div class="alert alert-success">✅ <%= deleteSuccess %></div><% } %>

  <!-- Search/Filter -->
  <div class="filter-bar animate-fadeup" style="margin-bottom:20px;">
    <div class="filter-wrap" style="flex:2;"><span class="filter-icon">🔍</span><input class="filter-input" id="searchBox" type="text" placeholder="Search flight, city..."></div>
  </div>

  <div class="table-wrap animate-fadeup">
    <% if (flights == null || flights.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">✈</div><h3>No flights scheduled</h3><p>Add your first flight to get started.</p>
        <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary" style="margin-top:16px;">+ Add Flight</a>
      </div>
    <% } else { %>
    <table class="sc-table" id="flightTable">
      <thead><tr><th>#</th><th>Flight No</th><th>Route</th><th>Date</th><th>Departure</th><th>Arrival</th><th>Price</th><th>Seats</th><th>Available</th><th>Actions</th></tr></thead>
      <tbody>
      <% int fi = 0; for (Flight f : flights) { fi++;
         int pct = f.totalSeats > 0 ? (f.availableSeats * 100 / f.totalSeats) : 0;
         String seatColor = pct > 50 ? "#34D399" : pct > 20 ? "#FCD34D" : "#FCA5A5";
      %>
      <tr>
        <td class="text-dim"><%= fi %></td>
        <td><strong style="color:var(--sky-glow)"><%= f.flightNo %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= f.source %></span><span class="route-arrow">→</span><span class="route-city"><%= f.destination %></span></div></td>
        <td style="font-size:.85rem;"><%= f.date %></td>
        <td style="font-size:.85rem;"><%= f.departTime != null ? f.departTime.toString().substring(0,5) : "—" %></td>
        <td style="font-size:.85rem;"><%= f.arrivalTime != null ? f.arrivalTime.toString().substring(0,5) : "—" %></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f", f.price) %></td>
        <td><%= f.totalSeats %></td>
        <td><span style="color:<%= seatColor %>;font-weight:700;"><%= f.availableSeats %></span></td>
        <td>
          <div style="display:flex;gap:8px;">
            <a href="${pageContext.request.contextPath}/editFlight?id=<%= f.id %>" class="btn btn-secondary btn-sm">✏️ Edit</a>
            <form action="${pageContext.request.contextPath}/deleteFlight" method="post" style="margin:0;" onsubmit="return confirm('Delete flight <%= f.flightNo %>? This cannot be undone.');">
              <input type="hidden" name="id" value="<%= f.id %>">
              <button type="submit" class="btn btn-danger btn-sm">🗑 Delete</button>
            </form>
          </div>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

<script>
document.getElementById('searchBox')?.addEventListener('input', function(){
  const q = this.value.toLowerCase();
  document.querySelectorAll('#flightTable tbody tr').forEach(r => {
    r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
});
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
