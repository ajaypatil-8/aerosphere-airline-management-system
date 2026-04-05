<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminDashboardServlet.RecentBooking" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    Integer totalFlights  = (Integer) request.getAttribute("totalFlights");
    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer totalUsers    = (Integer) request.getAttribute("totalUsers");
    Double  totalRevenue  = (Double)  request.getAttribute("totalRevenue");
    Integer pendingRefunds= (Integer) request.getAttribute("pendingRefunds");
    List<RecentBooking> recentBookings = (List<RecentBooking>) request.getAttribute("recentBookings");
    if (totalFlights   == null) totalFlights   = 0;
    if (totalBookings  == null) totalBookings  = 0;
    if (totalUsers     == null) totalUsers     = 0;
    if (totalRevenue   == null) totalRevenue   = 0.0;
    if (pendingRefunds == null) pendingRefunds = 0;
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Sky<span>Connect</span> <small style="font-size:.6rem;color:var(--gold);font-weight:700;letter-spacing:.05em;">ADMIN</small></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">Admin Dashboard 🛡️</h1>
      <p class="page-subtitle">Welcome back, <strong style="color:var(--sky-glow)"><%= userName %></strong> — here's your system overview</p>
    </div>
    <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-blue" style="background:var(--sky);color:#fff;padding:10px 20px;border-radius:10px;font-weight:700;text-decoration:none;">+ Add Flight</a>
  </div>

  <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

  <!-- STATS -->
  <div class="stats-grid" style="margin-bottom:28px;">
    <div class="stat-card animate-fadeup delay-1">
      <div style="font-size:2rem;margin-bottom:6px;">✈️</div>
      <div class="stat-num"><%= totalFlights %></div>
      <div class="stat-label">Total Flights</div>
    </div>
    <div class="stat-card animate-fadeup delay-2">
      <div style="font-size:2rem;margin-bottom:6px;">🎫</div>
      <div class="stat-num"><%= totalBookings %></div>
      <div class="stat-label">Total Bookings</div>
    </div>
    <div class="stat-card animate-fadeup delay-3">
      <div style="font-size:2rem;margin-bottom:6px;">👥</div>
      <div class="stat-num"><%= totalUsers %></div>
      <div class="stat-label">Registered Users</div>
    </div>
    <div class="stat-card animate-fadeup delay-4">
      <div style="font-size:2rem;margin-bottom:6px;">💰</div>
      <div class="stat-num" style="color:var(--gold);font-size:1.5rem;">₹<%= String.format("%,.0f", totalRevenue) %></div>
      <div class="stat-label">Total Revenue</div>
    </div>
    <div class="stat-card animate-fadeup delay-5">
      <div style="font-size:2rem;margin-bottom:6px;">🔄</div>
      <div class="stat-num" style="color:#FCA5A5;"><%= pendingRefunds %></div>
      <div class="stat-label">Pending Refunds</div>
    </div>
  </div>

  <!-- QUICK ACTIONS -->
  <div class="section-label">Quick Actions</div>
  <div class="quick-grid animate-fadeup" style="margin-bottom:32px;">
    <a href="${pageContext.request.contextPath}/addFlight"    class="quick-card"><div class="qc-icon">➕</div><div class="qc-title">Add Flight</div><div class="qc-sub">Schedule new route</div></a>
    <a href="${pageContext.request.contextPath}/adminFlights"  class="quick-card"><div class="qc-icon">✈️</div><div class="qc-title">Manage Flights</div><div class="qc-sub">Edit or remove</div></a>
    <a href="${pageContext.request.contextPath}/adminBookings" class="quick-card"><div class="qc-icon">📋</div><div class="qc-title">All Bookings</div><div class="qc-sub">View all reservations</div></a>
    <a href="${pageContext.request.contextPath}/adminRefunds"  class="quick-card"><div class="qc-icon">💸</div><div class="qc-title">Refund Requests</div><div class="qc-sub"><%= pendingRefunds %> pending</div></a>
    <a href="${pageContext.request.contextPath}/reports"       class="quick-card"><div class="qc-icon">📊</div><div class="qc-title">Reports</div><div class="qc-sub">Analytics & exports</div></a>
  </div>

  <!-- RECENT BOOKINGS -->
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;">
    <div class="section-label" style="margin:0;">Recent Bookings</div>
    <a href="${pageContext.request.contextPath}/adminBookings" class="btn btn-secondary btn-sm">View All →</a>
  </div>

  <div class="table-wrap animate-fadeup">
    <% if (recentBookings == null || recentBookings.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">📋</div><h3>No bookings yet</h3><p>Bookings will appear here once users start booking.</p></div>
    <% } else { %>
    <table class="sc-table">
      <thead><tr><th>#</th><th>Booking ID</th><th>Passenger</th><th>Flight</th><th>Route</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead>
      <tbody>
      <% int si = 0; for (RecentBooking b : recentBookings) { si++;
         String st = b.paymentStatus != null ? b.paymentStatus.toLowerCase() : "booked";
         String bc = st.equals("paid") ? "badge-paid" : st.equals("cancelled") ? "badge-cancelled" : "badge-booked";
      %>
      <tr>
        <td class="text-dim"><%= si %></td>
        <td style="color:var(--sky-glow);font-weight:700;">#<%= b.bookingId %></td>
        <td style="color:var(--white);font-weight:500;"><%= b.userName %></td>
        <td><strong><%= b.flightNo %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= b.source %></span><span class="route-arrow">→</span><span class="route-city"><%= b.destination %></span></div></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f", b.totalAmount) %></td>
        <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
        <td style="font-size:.8rem;color:var(--muted);"><%= b.bookingDate != null ? b.bookingDate.toString().substring(0,10) : "—" %></td>
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
</script>
</body></html>
