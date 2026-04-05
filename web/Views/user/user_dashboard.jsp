<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.UserDashboardServlet.Booking" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
    @SuppressWarnings("unchecked")
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    String error        = (String) request.getAttribute("error");
    String bookingError = (String) session.getAttribute("bookingError");
    session.removeAttribute("bookingError");
    int totalB=0, paidB=0, cancelledB=0; double amtSpent=0;
    if (recentBookings != null) {
        totalB = recentBookings.size();
        for (Booking b : recentBookings) {
            if ("PAID".equalsIgnoreCase(b.status)) { paidB++; amtSpent += b.totalAmount; }
            if ("CANCELLED".equalsIgnoreCase(b.status)) cancelledB++;
        }
    }
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
<style>
.search-hero{background:linear-gradient(135deg,rgba(0,57,200,.35),rgba(0,87,255,.12));border:1px solid rgba(0,87,255,.3);border-radius:18px;padding:28px 32px;margin-bottom:28px;position:relative;overflow:hidden;}
.search-hero::before{content:'✈';position:absolute;right:28px;top:50%;transform:translateY(-50%);font-size:7rem;opacity:.05;}
.search-grid{display:grid;grid-template-columns:1fr 1fr 1fr 1fr auto;gap:12px;align-items:end;}
@media(max-width:800px){.search-grid{grid-template-columns:1fr 1fr;}.search-grid .sb{grid-column:1/-1;}}
.search-grid label{display:block;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);margin-bottom:6px;}
.search-grid input,.search-grid select{width:100%;padding:11px 14px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.12);border-radius:10px;color:#fff;font-family:'DM Sans',sans-serif;font-size:.875rem;outline:none;transition:border-color .2s;}
.search-grid input:focus,.search-grid select:focus{border-color:var(--sky-glow);}
.search-grid input::placeholder{color:rgba(255,255,255,.25);}
.search-grid select option{background:var(--ink-3);}
.greeting-text{font-family:'Syne',sans-serif;font-size:1.7rem;font-weight:800;margin-bottom:4px;}
</style>
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"      class="nav-link active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/userBookings"       class="nav-link">My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory"  class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/profile"            class="nav-link">Profile</a>
    <a href="${pageContext.request.contextPath}/logout"             class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <p class="greeting-text">Welcome back, <span style="color:var(--sky-glow)"><%= firstName %></span> 👋</p>
      <p class="page-subtitle">Search flights, manage bookings, and track your journey</p>
    </div>
  </div>

  <% if (error != null)        { %><div class="alert alert-error">⚠ <%= error %></div><% } %>
  <% if (bookingError != null) { %><div class="alert alert-error">⚠ <%= bookingError %></div><% } %>

  <!-- SEARCH -->
  <div class="search-hero animate-fadeup">
    <div style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:800;margin-bottom:18px;">✈ Search Flights</div>
    <form action="${pageContext.request.contextPath}/searchFlights" method="get" class="search-grid">
      <div><label>From</label><input type="text" name="source" placeholder="e.g. Mumbai" required></div>
      <div><label>To</label><input type="text" name="destination" placeholder="e.g. Delhi" required></div>
      <div><label>Date</label><input type="date" name="departDate" required></div>
      <div><label>Passengers</label>
        <select name="numSeats"><% for(int i=1;i<=9;i++){%><option value="<%= i %>"><%= i %> Passenger<%= i>1?"s":"" %></option><%}%></select>
      </div>
      <button type="submit" class="btn btn-primary sb" style="padding:11px 24px;white-space:nowrap;">🔍 Search</button>
    </form>
  </div>

  <!-- STATS -->
  <div class="stats-grid" style="margin-bottom:28px;">
    <div class="stat-card animate-fadeup delay-1"><div style="font-size:1.8rem;margin-bottom:6px;">🎫</div><div class="stat-num"><%= totalB %></div><div class="stat-label">Total Bookings</div></div>
    <div class="stat-card animate-fadeup delay-2"><div style="font-size:1.8rem;margin-bottom:6px;">✅</div><div class="stat-num" style="color:#34D399;"><%= paidB %></div><div class="stat-label">Paid</div></div>
    <div class="stat-card animate-fadeup delay-3"><div style="font-size:1.8rem;margin-bottom:6px;">❌</div><div class="stat-num" style="color:#FCA5A5;"><%= cancelledB %></div><div class="stat-label">Cancelled</div></div>
    <div class="stat-card animate-fadeup delay-4"><div style="font-size:1.8rem;margin-bottom:6px;">💰</div><div class="stat-num" style="color:var(--gold);font-size:1.5rem;">₹<%= String.format("%,.0f",amtSpent) %></div><div class="stat-label">Amount Spent</div></div>
  </div>

  <!-- RECENT BOOKINGS -->
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;">
    <div class="section-label" style="margin:0;">Recent Bookings</div>
    <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-secondary btn-sm">View All →</a>
  </div>

  <div class="table-wrap animate-fadeup">
    <% if (recentBookings == null || recentBookings.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">✈</div><h3>No bookings yet</h3><p>Search for a flight above to get started!</p></div>
    <% } else { %>
    <table class="sc-table">
      <thead><tr><th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Seats</th><th>Amount</th><th>Status</th><th>Actions</th></tr></thead>
      <tbody>
      <% int sno=1; for(Booking b : recentBookings) {
         String st = b.status != null ? b.status.toLowerCase() : "booked";
         String bc = st.equals("paid")?"badge-paid":st.equals("cancelled")?"badge-cancelled":"badge-booked"; %>
      <tr>
        <td class="text-dim"><%= sno++ %></td>
        <td><strong><%= b.flightNo %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= b.source %></span><span class="route-arrow">→</span><span class="route-city"><%= b.destination %></span></div></td>
        <td style="font-size:.8rem;color:var(--muted);"><%= b.bookingDate != null ? b.bookingDate.substring(0,10) : "—" %></td>
        <td style="text-align:center"><%= b.numSeats %></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f",b.totalAmount) %></td>
        <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
        <td><a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.bookingId %>" class="btn btn-secondary btn-sm">🎫 Invoice</a></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<80;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
document.querySelector('input[name="departDate"]').min = new Date().toISOString().split('T')[0];
</script>
</body></html>
