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
    @SuppressWarnings("unchecked")
    List<RecentBooking> recentBookings = (List<RecentBooking>) request.getAttribute("recentBookings");
    if (totalFlights   == null) totalFlights   = 0;
    if (totalBookings  == null) totalBookings  = 0;
    if (totalUsers     == null) totalUsers     = 0;
    if (totalRevenue   == null) totalRevenue   = 0.0;
    if (pendingRefunds == null) pendingRefunds = 0;
    String error = (String) request.getAttribute("error");
    String adminFirst = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
/* ── ADMIN DASHBOARD SPECIFIC ──────────────────────────── */

/* Top admin bar (inside main content, above page header) */
.admin-topbar {
  position: sticky; top: 0; z-index: 300;
  height: 56px;
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 32px;
  background: var(--glass-bg);
  border-bottom: 1px solid var(--border);
  backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur);
  animation: navbarDrop .5s var(--ease) both;
}
.topbar-left {
  display: flex; align-items: center; gap: 12px;
}
.topbar-title {
  font-family: 'Syne', sans-serif;
  font-size: .95rem; font-weight: 700; color: var(--text);
  letter-spacing: -.02em;
}
.topbar-right {
  display: flex; align-items: center; gap: 8px;
}

/* Admin layout — sidebar + main */
.as-admin-layout {
  display: grid;
  grid-template-columns: var(--sidebar-w) 1fr;
  min-height: 100vh;
}
.as-main { overflow-x: hidden; }

/* Stats — 5 col */
.stats-grid-5 {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 16px; margin-bottom: 28px;
}
.admin-stat {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 22px 18px; text-align: center;
  box-shadow: var(--shadow);
  position: relative; overflow: hidden;
  transition: transform var(--trans), box-shadow var(--trans), border-color var(--trans);
}
.admin-stat::after {
  content: ''; position: absolute;
  bottom: 0; left: 0; right: 0; height: 3px;
  transform: scaleX(0); transform-origin: left;
  transition: transform var(--trans);
}
.admin-stat.c-blue::after  { background: var(--primary); }
.admin-stat.c-green::after { background: var(--secondary); }
.admin-stat.c-purple::after{ background: #8B5CF6; }
.admin-stat.c-amber::after { background: var(--accent); }
.admin-stat.c-red::after   { background: var(--danger); }
.admin-stat:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
.admin-stat:hover::after { transform: scaleX(1); }
.admin-stat:hover.c-blue   { border-color: rgba(14,165,233,.3); }
.admin-stat:hover.c-green  { border-color: rgba(16,185,129,.3); }
.admin-stat:hover.c-purple { border-color: rgba(139,92,246,.3); }
.admin-stat:hover.c-amber  { border-color: rgba(245,158,11,.3); }
.admin-stat:hover.c-red    { border-color: rgba(239,68,68,.3); }

.as-icon {
  width: 48px; height: 48px; border-radius: var(--radius-sm);
  display: flex; align-items: center; justify-content: center;
  font-size: 1.4rem; margin: 0 auto 14px;
  transition: transform var(--trans-fast);
}
.admin-stat:hover .as-icon { transform: scale(1.1) rotate(-5deg); }
.as-icon.blue   { background: var(--info-bg); }
.as-icon.green  { background: var(--success-bg); }
.as-icon.purple { background: rgba(139,92,246,.1); }
.as-icon.amber  { background: var(--warning-bg); }
.as-icon.red    { background: var(--danger-bg); }

.as-num {
  font-family: 'Syne', sans-serif;
  font-size: 1.8rem; font-weight: 800;
  letter-spacing: -.04em; line-height: 1;
  margin-bottom: 5px;
}
.as-num.blue   { color: var(--primary); }
.as-num.green  { color: var(--secondary); }
.as-num.purple { color: #8B5CF6; }
.as-num.amber  { color: var(--accent); font-size: 1.4rem; }
.as-num.red    { color: var(--danger); }
.as-label {
  font-size: .7rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .08em;
  color: var(--text-muted);
}

/* Quick actions */
.quick-grid-5 {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 14px; margin-bottom: 32px;
}

/* Revenue callout bar */
.revenue-bar {
  background: var(--grad-hero);
  border-radius: var(--radius-lg);
  padding: 20px 24px;
  display: flex; align-items: center;
  justify-content: space-between; gap: 16px;
  margin-bottom: 28px;
  box-shadow: var(--shadow-md);
  position: relative; overflow: hidden;
}
.revenue-bar::after {
  content: '₹'; position: absolute; right: 20px; top: 50%;
  transform: translateY(-50%); font-family: 'Syne', sans-serif;
  font-size: 6rem; opacity: .06; pointer-events: none;
  font-weight: 800; color: #fff;
}
.rb-label {
  font-size: .75rem; font-weight: 700; text-transform: uppercase;
  letter-spacing: .1em; color: rgba(255,255,255,.6);
  margin-bottom: 6px;
}
.rb-amount {
  font-family: 'Syne', sans-serif;
  font-size: 2rem; font-weight: 800;
  letter-spacing: -.04em; color: #fff;
}
.rb-meta { font-size: .82rem; color: rgba(255,255,255,.65); margin-top: 4px; }
.rb-right { display: flex; gap: 10px; flex-shrink: 0; }

/* Pending refunds badge on sidebar */
.refund-pill {
  display: inline-flex; align-items: center; gap: 6px;
  background: rgba(239,68,68,.15); border: 1px solid rgba(239,68,68,.3);
  color: #FCA5A5; padding: 6px 12px; border-radius: var(--radius-full);
  font-size: .78rem; font-weight: 700;
}

/* Sidebar toggle for mobile */
.sidebar-toggle-btn {
  display: none;
  width: 36px; height: 36px;
  background: var(--surface-0); border: 1px solid var(--border-2);
  border-radius: var(--radius-sm); align-items: center; justify-content: center;
  font-size: 1.1rem; cursor: pointer;
  transition: border-color var(--trans-fast);
}
.sidebar-toggle-btn:hover { border-color: var(--primary); }

/* Amount col */
.amt-col { color: var(--primary); font-weight: 700; }

@media(max-width:1100px) {
  .stats-grid-5  { grid-template-columns: repeat(3,1fr); }
  .quick-grid-5  { grid-template-columns: repeat(3,1fr); }
}
@media(max-width:900px) {
  .as-admin-layout { grid-template-columns: 1fr; }
  .as-main { grid-column: 1; }
  .as-sidebar { transform: translateX(-100%); z-index: 600; }
  .as-sidebar.open { transform: translateX(0); }
  .as-sidebar-toggle { display: flex; }
  .sidebar-toggle-btn { display: flex; }
  .stats-grid-5 { grid-template-columns: repeat(2,1fr); }
  .quick-grid-5 { grid-template-columns: repeat(2,1fr); }
  .admin-topbar { padding: 0 16px; }
}
@media(max-width:560px) {
  .stats-grid-5 { grid-template-columns: 1fr 1fr; }
  .quick-grid-5 { grid-template-columns: 1fr 1fr; }
  .revenue-bar  { flex-direction: column; align-items: flex-start; }
}
</style>
</head>
<body>

<%-- ══════════════════════════════════════════════
     ADMIN LAYOUT: sidebar + main
     ══════════════════════════════════════════════ --%>
<div class="as-admin-layout">

  <%-- ── SIDEBAR ─────────────────────────────────────────────── --%>
  <aside class="as-sidebar" id="as-sidebar" role="navigation" aria-label="Admin sidebar">

    <div class="as-sidebar-brand">
      <div class="as-sidebar-logo">✈</div>
      <span class="as-sidebar-brand-name">Aero<span class="accent">Sphere</span></span>
      <span class="as-sidebar-badge">ADMIN</span>
    </div>

    <div class="as-sidebar-section">
      <div class="as-sidebar-label">Overview</div>
      <a href="${pageContext.request.contextPath}/adminDashboard" class="as-sidebar-link active">
        <span class="icon">🏠</span>Dashboard
      </a>

      <div class="as-sidebar-label">Flight Management</div>
      <a href="${pageContext.request.contextPath}/adminFlights" class="as-sidebar-link">
        <span class="icon">✈️</span>All Flights
      </a>
      <a href="${pageContext.request.contextPath}/addFlight" class="as-sidebar-link">
        <span class="icon">➕</span>Add Flight
      </a>

      <div class="as-sidebar-label">Bookings & Users</div>
      <a href="${pageContext.request.contextPath}/adminBookings" class="as-sidebar-link">
        <span class="icon">🎫</span>All Bookings
      </a>
      <a href="${pageContext.request.contextPath}/adminRefunds" class="as-sidebar-link">
        <span class="icon">💸</span>Refund Requests
        <% if (pendingRefunds > 0) { %>
          <span class="badge"><%= pendingRefunds %></span>
        <% } %>
      </a>

      <div class="as-sidebar-label">Reports</div>
      <a href="${pageContext.request.contextPath}/reports"           class="as-sidebar-link"><span class="icon">📊</span>All Reports</a>
      <a href="${pageContext.request.contextPath}/reportBookings"    class="as-sidebar-link"><span class="icon">📋</span>Booking Report</a>
      <a href="${pageContext.request.contextPath}/reportFlights"     class="as-sidebar-link"><span class="icon">📈</span>Flight Report</a>
      <a href="${pageContext.request.contextPath}/reportPayments"    class="as-sidebar-link"><span class="icon">💰</span>Revenue Report</a>
      <a href="${pageContext.request.contextPath}/reportUsers"       class="as-sidebar-link"><span class="icon">👥</span>User Report</a>
      <a href="${pageContext.request.contextPath}/reportCancelled"   class="as-sidebar-link"><span class="icon">❌</span>Cancellation Report</a>
      <a href="${pageContext.request.contextPath}/reportPassengers"  class="as-sidebar-link"><span class="icon">🧳</span>Passenger Report</a>
    </div>

    <div class="as-sidebar-footer">
      <div class="as-sidebar-user">
        <div class="as-sidebar-user-avatar"><%= adminFirst.charAt(0) %></div>
        <div>
          <div class="as-sidebar-user-name"><%= userName %></div>
          <div class="as-sidebar-user-role">Administrator</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/logout" class="as-sidebar-logout">
        <span>↩</span>Sign Out
      </a>
    </div>
  </aside>

  <%-- Sidebar overlay (mobile) --%>
  <div id="as-sidebar-overlay" aria-hidden="true"></div>

  <%-- ── MAIN CONTENT ─────────────────────────────────────────── --%>
  <main class="as-main" role="main">

    <%-- Sticky top bar --%>
    <div class="admin-topbar">
      <div class="topbar-left">
        <button class="sidebar-toggle-btn" id="as-sidebar-toggle" aria-label="Toggle sidebar">☰</button>
        <span class="topbar-title">Admin Dashboard</span>
        <% if (pendingRefunds > 0) { %>
          <span class="refund-pill">🔔 <%= pendingRefunds %> pending refund<%= pendingRefunds > 1 ? "s" : "" %></span>
        <% } %>
      </div>
      <div class="topbar-right">
        <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle theme">🌙</button>
        <div class="user-pill">
          <div class="user-avatar"><%= adminFirst.charAt(0) %></div>
          <span><%= adminFirst %></span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">↩ Logout</a>
      </div>
    </div>

    <div class="page-wrapper">

      <% if (error != null) { %>
        <div class="alert alert-error"><span>⚠</span><span><%= HtmlUtils.e(error) %></span></div>
      <% } %>

      <%-- ── PAGE HEADER ─────────────────────────────────────── --%>
      <div class="page-header fade-up">
        <div>
          <div class="page-heading">🛡️ Admin <span>Dashboard</span></div>
          <div class="page-subheading">Welcome back, <strong><%= userName %></strong> — here's your system overview</div>
        </div>
        <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary">
          ➕ Add New Flight
        </a>
      </div>

      <%-- ── REVENUE CALLOUT BAR ─────────────────────────────── --%>
      <div class="revenue-bar fade-up d1">
        <div>
          <div class="rb-label">Total Platform Revenue</div>
          <div class="rb-amount count-up" data-target="<%= (long)totalRevenue.doubleValue() %>" data-prefix="₹">₹<%= String.format("%,.0f", totalRevenue) %></div>
          <div class="rb-meta">Across all confirmed bookings</div>
        </div>
        <div class="rb-right">
          <a href="${pageContext.request.contextPath}/reportPayments" class="btn btn-ghost">💰 Revenue Report</a>
          <a href="${pageContext.request.contextPath}/reports"        class="btn btn-ghost">📊 All Reports</a>
        </div>
      </div>

      <%-- ── KPI STATS ──────────────────────────────────────── --%>
      <div class="stats-grid-5">
        <div class="admin-stat c-blue fade-up d1">
          <div class="as-icon blue">✈️</div>
          <div class="as-num blue count-up" data-target="<%= totalFlights %>"><%= totalFlights %></div>
          <div class="as-label">Total Flights</div>
        </div>
        <div class="admin-stat c-green fade-up d2">
          <div class="as-icon green">🎫</div>
          <div class="as-num green count-up" data-target="<%= totalBookings %>"><%= totalBookings %></div>
          <div class="as-label">Total Bookings</div>
        </div>
        <div class="admin-stat c-purple fade-up d3">
          <div class="as-icon purple">👥</div>
          <div class="as-num purple count-up" data-target="<%= totalUsers %>"><%= totalUsers %></div>
          <div class="as-label">Registered Users</div>
        </div>
        <div class="admin-stat c-amber fade-up d4">
          <div class="as-icon amber">💰</div>
          <div class="as-num amber" style="font-size:1.2rem">₹<%= String.format("%,.0f", totalRevenue) %></div>
          <div class="as-label">Revenue</div>
        </div>
        <div class="admin-stat c-red fade-up d5">
          <div class="as-icon red">🔄</div>
          <div class="as-num red count-up" data-target="<%= pendingRefunds %>"><%= pendingRefunds %></div>
          <div class="as-label">Pending Refunds</div>
        </div>
      </div>

      <%-- ── QUICK ACTIONS ───────────────────────────────────── --%>
      <div class="section-label">Quick Actions</div>
      <div class="quick-grid-5 fade-up d2">
        <a href="${pageContext.request.contextPath}/addFlight"    class="quick-card">
          <div class="qc-icon">➕</div>
          <div class="qc-title">Add Flight</div>
          <div class="qc-sub">Schedule new route</div>
        </a>
        <a href="${pageContext.request.contextPath}/adminFlights" class="quick-card">
          <div class="qc-icon">✈️</div>
          <div class="qc-title">Manage Flights</div>
          <div class="qc-sub">Edit or remove</div>
        </a>
        <a href="${pageContext.request.contextPath}/adminBookings" class="quick-card">
          <div class="qc-icon">📋</div>
          <div class="qc-title">All Bookings</div>
          <div class="qc-sub">View reservations</div>
        </a>
        <a href="${pageContext.request.contextPath}/adminRefunds"  class="quick-card">
          <div class="qc-icon">💸</div>
          <div class="qc-title">Refund Requests</div>
          <div class="qc-sub"><%= pendingRefunds %> pending</div>
        </a>
        <a href="${pageContext.request.contextPath}/reports"       class="quick-card">
          <div class="qc-icon">📊</div>
          <div class="qc-title">Reports</div>
          <div class="qc-sub">Analytics & exports</div>
        </a>
      </div>

      <%-- ── RECENT BOOKINGS TABLE ───────────────────────────── --%>
      <div class="section-header fade-up d3">
        <div class="section-title">Recent Bookings</div>
        <a href="${pageContext.request.contextPath}/adminBookings" class="btn btn-ghost btn-sm">View All →</a>
      </div>

      <div class="table-wrap fade-up d3">
        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
          <div class="empty-state">
            <div class="empty-icon">📋</div>
            <h3>No bookings yet</h3>
            <p>Bookings will appear here once passengers start booking flights.</p>
          </div>
        <% } else { %>
          <table class="sc-table zebra">
            <thead>
              <tr>
                <th>#</th>
                <th>Booking ID</th>
                <th>Passenger</th>
                <th>Flight</th>
                <th>Route</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Date</th>
              </tr>
            </thead>
            <tbody>
            <% int si=0; for(RecentBooking b : recentBookings) { si++;
               String st = b.paymentStatus != null ? b.paymentStatus.toLowerCase() : "booked";
               String bc = st.equals("paid") ? "badge-paid" : st.equals("cancelled") ? "badge-cancelled" : "badge-booked";
            %>
              <tr>
                <td style="color:var(--text-faint);font-size:.78rem"><%= si %></td>
                <td style="color:var(--primary);font-weight:700;font-family:'Syne',sans-serif">#<%= b.bookingId %></td>
                <td style="font-weight:500"><%= b.userName %></td>
                <td><strong><%= b.flightNo %></strong></td>
                <td>
                  <div class="route-display">
                    <span class="route-city"><%= b.source %></span>
                    <span class="route-arrow">→</span>
                    <span class="route-city"><%= b.destination %></span>
                  </div>
                </td>
                <td class="amt-col">₹<%= String.format("%,.0f", b.totalAmount) %></td>
                <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
                <td style="font-size:.8rem;color:var(--text-muted)"><%= b.bookingDate != null ? b.bookingDate.toString().substring(0,10) : "—" %></td>
              </tr>
            <% } %>
            </tbody>
          </table>
        <% } %>
      </div>

    </div><%-- /page-wrapper --%>
  </main>

</div><%-- /as-admin-layout --%>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  // Sidebar toggle for mobile
  (function(){
    var toggle  = document.getElementById('as-sidebar-toggle');
    var sidebar = document.getElementById('as-sidebar');
    var overlay = document.getElementById('as-sidebar-overlay');
    if (!toggle || !sidebar) return;
    toggle.addEventListener('click', function() {
      var open = sidebar.classList.toggle('open');
      if (overlay) overlay.classList.toggle('active', open);
    });
    if (overlay) overlay.addEventListener('click', function() {
      sidebar.classList.remove('open');
      overlay.classList.remove('active');
    });
  })();
</script>
</body>
</html>
