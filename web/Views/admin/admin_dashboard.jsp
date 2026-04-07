<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminDashboardServlet.RecentBooking" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
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
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--accent:#A7F3D0;--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--accent:#34D399;--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
/* NAVBAR */
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}
.brand-name span{color:var(--primary)}
.admin-badge{font-size:.6rem;background:rgba(245,158,11,.15);color:#D97706;border:1px solid rgba(245,158,11,.3);padding:2px 7px;border-radius:4px;font-weight:700;letter-spacing:.05em;margin-left:4px;vertical-align:middle}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover,.nav-link.active{color:var(--text);background:var(--border)}
.nav-link.active{color:var(--primary);background:var(--primary-glow)}
.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}
.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.theme-toggle:hover{border-color:var(--primary)}
/* PAGE */
.page-wrapper{max-width:1140px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.page-subtitle strong{color:var(--primary)}
/* ALERT */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
/* STATS */
.stats-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:16px;margin-bottom:28px}
.stat-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:22px 18px;text-align:center;transition:all .3s;box-shadow:var(--shadow);position:relative;overflow:hidden}
.stat-card::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;background:var(--primary);transform:scaleX(0);transition:transform .3s;transform-origin:left}
.stat-card:hover{border-color:var(--primary);transform:translateY(-3px);box-shadow:var(--shadow-lg)}
.stat-card:hover::after{transform:scaleX(1)}
.stat-icon{font-size:1.7rem;margin-bottom:8px}
.stat-num{font-size:1.7rem;font-weight:900;letter-spacing:-.8px}
.stat-num.revenue{color:var(--primary);font-size:1.4rem}
.stat-num.danger{color:#EF4444}
.stat-label{color:var(--text-muted);font-size:.75rem;margin-top:4px;font-weight:500;text-transform:uppercase;letter-spacing:.05em}
/* QUICK ACTIONS */
.section-label{font-weight:700;font-size:.8rem;text-transform:uppercase;letter-spacing:.08em;color:var(--text-muted);margin-bottom:14px}
.quick-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:14px;margin-bottom:32px}
.quick-card{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;padding:22px 14px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:var(--radius);text-decoration:none;color:var(--text);transition:all .25s;text-align:center;box-shadow:var(--shadow)}
.quick-card:hover{border-color:var(--primary);background:var(--primary-glow);transform:translateY(-3px);box-shadow:var(--shadow-lg)}
.qc-icon{font-size:1.8rem}
.qc-title{font-weight:700;font-size:.85rem}
.qc-sub{color:var(--text-muted);font-size:.75rem}
/* TABLE */
.section-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}
.section-title{font-weight:700;font-size:1rem}
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:9px;font-weight:600;font-size:.84rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none;font-family:'Inter',sans-serif}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 3px 10px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-secondary{background:var(--bg);border:1px solid var(--border);color:var(--text)}
.btn-secondary:hover{border-color:var(--primary);color:var(--primary)}
.btn-sm{padding:5px 12px;font-size:.78rem}
.table-wrap{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.sc-table{width:100%;border-collapse:collapse}
.sc-table th{padding:12px 16px;text-align:left;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
.sc-table td{padding:13px 16px;font-size:.86rem;border-bottom:1px solid var(--border)}
.sc-table tr:last-child td{border-bottom:none}
.sc-table tbody tr{transition:background .15s}
.sc-table tbody tr:hover{background:var(--primary-glow)}
.text-dim{color:var(--text-muted)}
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.73rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.badge-paid{background:rgba(16,185,129,.12);color:#059669}
[data-theme="dark"] .badge-paid{color:#34D399}
.badge-cancelled{background:rgba(239,68,68,.1);color:#DC2626}
[data-theme="dark"] .badge-cancelled{color:#FCA5A5}
.badge-booked{background:rgba(59,130,246,.1);color:#2563EB}
[data-theme="dark"] .badge-booked{color:#93C5FD}
.badge-pending{background:rgba(245,158,11,.1);color:#D97706}
.route-display{display:flex;align-items:center;gap:6px}
.route-city{font-weight:600;font-size:.84rem}
.route-arrow{color:var(--primary);font-weight:700}
.empty-state{text-align:center;padding:56px 24px;color:var(--text-muted)}
.empty-icon{font-size:2.5rem;margin-bottom:12px}
.empty-state h3{font-weight:700;color:var(--text);margin-bottom:6px}
/* ANIMATIONS */
@keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .5s ease forwards}
.delay-1{animation-delay:.08s;opacity:0}
.delay-2{animation-delay:.16s;opacity:0}
.delay-3{animation-delay:.24s;opacity:0}
.delay-4{animation-delay:.32s;opacity:0}
.delay-5{animation-delay:.40s;opacity:0}
/* RESPONSIVE */
@media(max-width:900px){.stats-grid{grid-template-columns:repeat(3,1fr)}.quick-grid{grid-template-columns:repeat(3,1fr)}}
@media(max-width:600px){.stats-grid{grid-template-columns:repeat(2,1fr)}.quick-grid{grid-template-columns:repeat(2,1fr)}.page-wrapper{padding:20px 14px}.navbar{padding:10px 16px}.nav-links .nav-link:not(.btn-danger){display:none}}
</style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span><span class="admin-badge">ADMIN</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
    <button class="theme-toggle" id="themeToggle" title="Toggle theme">🌙</button>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">🛡️ Admin Dashboard</h1>
      <p class="page-subtitle">Welcome back, <strong><%= userName %></strong> — system overview</p>
    </div>
    <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary">+ Add Flight</a>
  </div>

  <% if (error != null) { %><div class="alert alert-error">⚠ <%= HtmlUtils.e(error) %></div><% } %>

  <!-- STATS -->
  <div class="stats-grid">
    <div class="stat-card animate-fadeup delay-1">
      <div class="stat-icon">✈️</div>
      <div class="stat-num"><%= totalFlights %></div>
      <div class="stat-label">Total Flights</div>
    </div>
    <div class="stat-card animate-fadeup delay-2">
      <div class="stat-icon">🎫</div>
      <div class="stat-num"><%= totalBookings %></div>
      <div class="stat-label">Total Bookings</div>
    </div>
    <div class="stat-card animate-fadeup delay-3">
      <div class="stat-icon">👥</div>
      <div class="stat-num"><%= totalUsers %></div>
      <div class="stat-label">Registered Users</div>
    </div>
    <div class="stat-card animate-fadeup delay-4">
      <div class="stat-icon">💰</div>
      <div class="stat-num revenue">₹<%= String.format("%,.0f", totalRevenue) %></div>
      <div class="stat-label">Total Revenue</div>
    </div>
    <div class="stat-card animate-fadeup delay-5">
      <div class="stat-icon">🔄</div>
      <div class="stat-num danger"><%= pendingRefunds %></div>
      <div class="stat-label">Pending Refunds</div>
    </div>
  </div>

  <!-- QUICK ACTIONS -->
  <div class="section-label">Quick Actions</div>
  <div class="quick-grid animate-fadeup">
    <a href="${pageContext.request.contextPath}/addFlight"    class="quick-card"><div class="qc-icon">➕</div><div class="qc-title">Add Flight</div><div class="qc-sub">Schedule new route</div></a>
    <a href="${pageContext.request.contextPath}/adminFlights"  class="quick-card"><div class="qc-icon">✈️</div><div class="qc-title">Manage Flights</div><div class="qc-sub">Edit or remove</div></a>
    <a href="${pageContext.request.contextPath}/adminBookings" class="quick-card"><div class="qc-icon">📋</div><div class="qc-title">All Bookings</div><div class="qc-sub">View reservations</div></a>
    <a href="${pageContext.request.contextPath}/adminRefunds"  class="quick-card"><div class="qc-icon">💸</div><div class="qc-title">Refund Requests</div><div class="qc-sub"><%= pendingRefunds %> pending</div></a>
    <a href="${pageContext.request.contextPath}/reports"       class="quick-card"><div class="qc-icon">📊</div><div class="qc-title">Reports</div><div class="qc-sub">Analytics & exports</div></a>
  </div>

  <!-- RECENT BOOKINGS -->
  <div class="section-row">
    <div class="section-title">Recent Bookings</div>
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
        <td style="color:var(--primary);font-weight:700;">#<%= b.bookingId %></td>
        <td style="font-weight:500;"><%= b.userName %></td>
        <td><strong><%= b.flightNo %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= b.source %></span><span class="route-arrow">→</span><span class="route-city"><%= b.destination %></span></div></td>
        <td style="color:var(--primary);font-weight:700;">₹<%= String.format("%,.0f", b.totalAmount) %></td>
        <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
        <td style="font-size:.8rem;color:var(--text-muted);"><%= b.bookingDate != null ? b.bookingDate.toString().substring(0,10) : "—" %></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

<script>
(function(){
  const root=document.documentElement;
  const saved=localStorage.getItem('theme')||'light';
  root.setAttribute('data-theme',saved);
  document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';
})();
document.getElementById('themeToggle').addEventListener('click',function(){
  const cur=document.documentElement.getAttribute('data-theme');
  const next=cur==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',next);
  localStorage.setItem('theme',next);
  this.textContent=next==='dark'?'☀️':'🌙';
});
</script>
</body>
</html>
