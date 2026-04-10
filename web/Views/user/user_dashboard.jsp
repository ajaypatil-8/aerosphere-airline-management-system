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
            if ("PAID".equalsIgnoreCase(b.status))      { paidB++; amtSpent += b.totalAmount; }
            if ("CANCELLED".equalsIgnoreCase(b.status)) cancelledB++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
/* ── USER DASHBOARD SPECIFIC ───────────────────────────── */

/* Greeting banner */
.greeting-banner {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-xl);
  padding: 28px 32px;
  margin-bottom: 24px;
  position: relative;
  overflow: hidden;
  box-shadow: var(--shadow);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}
.greeting-banner::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; height: 3px;
  background: var(--grad-brand);
}
.greeting-bg-plane {
  position: absolute;
  right: 24px; top: 50%;
  transform: translateY(-50%);
  font-size: 7rem;
  opacity: .04;
  pointer-events: none;
  user-select: none;
  animation: floatAnim 6s ease-in-out infinite;
}
.greeting-content { position: relative; z-index: 1; }
.greeting-label {
  font-size: .72rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .1em;
  color: var(--text-faint); margin-bottom: 8px;
}
.greeting-name {
  font-family: 'Syne', sans-serif;
  font-size: 1.8rem; font-weight: 800;
  letter-spacing: -.04em; margin-bottom: 6px;
}
.greeting-name span { color: var(--primary); }
.greeting-sub { color: var(--text-muted); font-size: .9rem; }
.greeting-actions { display: flex; gap: 10px; flex-shrink: 0; position: relative; z-index: 1; }

/* Search hero */
.search-hero {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-xl);
  padding: 24px 28px;
  margin-bottom: 24px;
  box-shadow: var(--shadow);
  position: relative; overflow: hidden;
}
.search-hero::before {
  content: '';
  position: absolute; top: 0; left: 0; right: 0; height: 3px;
  background: var(--grad-brand);
}
.search-hero-title {
  font-family: 'Syne', sans-serif;
  font-size: .95rem; font-weight: 700;
  margin-bottom: 18px;
  display: flex; align-items: center; gap: 8px;
}
.search-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr auto;
  gap: 14px; align-items: end;
}
.search-field label {
  display: block; font-size: .7rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .07em;
  color: var(--text-muted); margin-bottom: 7px;
}
.search-field input,
.search-field select {
  width: 100%; padding: 10px 13px;
  background: var(--bg); border: 1.5px solid var(--border-2);
  border-radius: var(--radius-sm); color: var(--text);
  font-family: 'DM Sans', sans-serif; font-size: .875rem;
  outline: none;
  transition: border-color var(--trans-fast), box-shadow var(--trans-fast);
}
.search-field input:focus,
.search-field select:focus {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px var(--primary-glow);
}
.search-field input::placeholder { color: var(--text-faint); }
.btn-search {
  padding: 10px 22px; background: var(--grad-brand);
  color: #fff; border: none; border-radius: var(--radius-sm);
  font-family: 'DM Sans', sans-serif;
  font-weight: 700; font-size: .875rem; cursor: pointer;
  box-shadow: 0 4px 14px var(--primary-glow-lg); white-space: nowrap;
  transition: transform var(--trans-fast), box-shadow var(--trans-fast);
}
.btn-search:hover { transform: translateY(-2px); box-shadow: 0 8px 24px var(--primary-glow-lg); }

/* Stats grid — 4 col */
.stats-grid-4 {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px; margin-bottom: 28px;
}
.dash-stat {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 22px 18px;
  box-shadow: var(--shadow);
  position: relative; overflow: hidden;
  transition: transform var(--trans), box-shadow var(--trans), border-color var(--trans);
}
.dash-stat::after {
  content: '';
  position: absolute; bottom: 0; left: 0; right: 0; height: 3px;
  transform: scaleX(0); transform-origin: left;
  transition: transform var(--trans);
}
.dash-stat:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
.dash-stat:hover::after { transform: scaleX(1); }
.dash-stat.c-blue::after   { background: var(--primary); }
.dash-stat.c-green::after  { background: var(--secondary); }
.dash-stat.c-red::after    { background: var(--danger); }
.dash-stat.c-amber::after  { background: var(--accent); }
.dash-stat:hover.c-blue    { border-color: rgba(14,165,233,.3); }
.dash-stat:hover.c-green   { border-color: rgba(16,185,129,.3); }
.dash-stat:hover.c-red     { border-color: rgba(239,68,68,.3); }
.dash-stat:hover.c-amber   { border-color: rgba(245,158,11,.3); }

.ds-icon {
  width: 44px; height: 44px; border-radius: var(--radius-sm);
  display: flex; align-items: center; justify-content: center;
  font-size: 1.25rem; margin-bottom: 14px;
  transition: transform var(--trans-fast);
}
.dash-stat:hover .ds-icon { transform: scale(1.1) rotate(-5deg); }
.ds-icon.blue   { background: var(--info-bg); }
.ds-icon.green  { background: var(--success-bg); }
.ds-icon.red    { background: var(--danger-bg); }
.ds-icon.amber  { background: var(--warning-bg); }

.ds-num {
  font-family: 'Syne', sans-serif;
  font-size: 1.9rem; font-weight: 800;
  letter-spacing: -.04em; line-height: 1;
  margin-bottom: 4px;
}
.ds-num.blue  { color: var(--primary); }
.ds-num.green { color: var(--secondary); }
.ds-num.red   { color: var(--danger); }
.ds-num.amber { color: var(--accent); font-size: 1.55rem; }
.ds-label {
  font-size: .72rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .07em;
  color: var(--text-muted);
}

/* Bookings table section */
.bookings-section { margin-top: 4px; }
.section-header {
  display: flex; align-items: center;
  justify-content: space-between;
  margin-bottom: 16px; gap: 12px;
}
.section-title {
  font-family: 'Syne', sans-serif;
  font-size: 1.05rem; font-weight: 700;
  letter-spacing: -.02em;
}

/* Amount cell */
.amount-cell { color: var(--primary); font-weight: 700; }

/* Action link */
.tbl-action {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 5px 11px; border-radius: var(--radius-xs);
  font-size: .78rem; font-weight: 600;
  background: var(--surface-2); border: 1px solid var(--border-2);
  color: var(--text-2); text-decoration: none;
  transition: border-color var(--trans-fast), color var(--trans-fast), background var(--trans-fast);
}
.tbl-action:hover {
  border-color: var(--primary); color: var(--primary);
  background: var(--primary-glow);
}

@media(max-width:900px){
  .stats-grid-4 { grid-template-columns: repeat(2,1fr); }
  .search-grid  { grid-template-columns: 1fr 1fr; }
  .search-grid .sb { grid-column: 1 / -1; }
  .greeting-banner { flex-direction: column; align-items: flex-start; }
}
@media(max-width:560px){
  .stats-grid-4 { grid-template-columns: 1fr 1fr; }
  .search-grid  { grid-template-columns: 1fr; }
  .greeting-actions { width: 100%; }
  .greeting-actions .btn { flex: 1; justify-content: center; }
}
</style>
</head>
<body>

<%-- ── NAVBAR (uses global include pattern inline for self-contained page) ──%>
<nav class="navbar" role="navigation">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link active">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refunds</a>
    <a href="${pageContext.request.contextPath}/profile"           class="nav-link">👤 Profile</a>
  </div>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle theme">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="user-pill">
      <div class="user-avatar"><%= firstName.charAt(0) %></div>
      <span><%= firstName %></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">↩ Logout</a>
    <button class="hamburger" id="as-hamburger" aria-label="Menu"><span></span><span></span><span></span></button>
  </div>
</nav>

<%-- Mobile nav --%>
<div class="mobile-nav" id="as-mobile-nav">
  <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
  <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">🔍 Search Flights</a>
  <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 My Bookings</a>
  <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refund History</a>
  <a href="${pageContext.request.contextPath}/profile"           class="nav-link">👤 Profile</a>
  <hr style="border:none;border-top:1px solid var(--border);margin:6px 0">
  <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">↩ Logout</a>
</div>

<%-- ── PAGE CONTENT ─────────────────────────────────────────────── --%>
<div class="page-wrapper">

  <%-- Alerts --%>
  <% if (error != null) { %>
    <div class="alert alert-error"><span>⚠</span><span><%= error %></span></div>
  <% } %>
  <% if (bookingError != null) { %>
    <div class="alert alert-error"><span>⚠</span><span><%= bookingError %></span></div>
  <% } %>

  <%-- ── GREETING BANNER ─────────────────────────────────────── --%>
  <div class="greeting-banner fade-up">
    <div class="greeting-bg-plane">✈</div>
    <div class="greeting-content">
      <div class="greeting-label" id="timeLabel">Good morning</div>
      <div class="greeting-name">Welcome back, <span><%= firstName %></span> 👋</div>
      <div class="greeting-sub">Where do you want to fly today?</div>
    </div>
    <div class="greeting-actions">
      <a href="${pageContext.request.contextPath}/searchFlights" class="btn btn-primary">🔍 Search Flights</a>
      <a href="${pageContext.request.contextPath}/userBookings"  class="btn btn-ghost">🎫 My Bookings</a>
    </div>
  </div>

  <%-- ── STATS ─────────────────────────────────────────────────── --%>
  <div class="stats-grid-4">
    <div class="dash-stat c-blue fade-up d1">
      <div class="ds-icon blue">🎫</div>
      <div class="ds-num blue count-up" data-target="<%= totalB %>"><%= totalB %></div>
      <div class="ds-label">Total Bookings</div>
    </div>
    <div class="dash-stat c-green fade-up d2">
      <div class="ds-icon green">✅</div>
      <div class="ds-num green count-up" data-target="<%= paidB %>"><%= paidB %></div>
      <div class="ds-label">Paid</div>
    </div>
    <div class="dash-stat c-red fade-up d3">
      <div class="ds-icon red">❌</div>
      <div class="ds-num red count-up" data-target="<%= cancelledB %>"><%= cancelledB %></div>
      <div class="ds-label">Cancelled</div>
    </div>
    <div class="dash-stat c-amber fade-up d4">
      <div class="ds-icon amber">💰</div>
      <div class="ds-num amber count-up" data-target="<%= (long)amtSpent %>" data-prefix="₹">₹<%= String.format("%,.0f", amtSpent) %></div>
      <div class="ds-label">Amount Spent</div>
    </div>
  </div>

  <%-- ── SEARCH HERO ─────────────────────────────────────────────── --%>
  <div class="search-hero fade-up d2">
    <div class="search-hero-title">✈ Search & Book a Flight</div>
    <%-- FORM: action, method, all name attrs UNCHANGED --%>
    <form action="${pageContext.request.contextPath}/searchFlights" method="get" class="search-grid">
      <div class="search-field">
        <label>From</label>
        <input type="text" name="source" placeholder="e.g. Mumbai" required>
      </div>
      <div class="search-field">
        <label>To</label>
        <input type="text" name="destination" placeholder="e.g. Delhi" required>
      </div>
      <div class="search-field">
        <label>Date</label>
        <input type="date" name="departDate" id="departDateInput" required>
      </div>
      <div class="search-field">
        <label>Passengers</label>
        <select name="numSeats">
          <% for(int i=1;i<=9;i++){%>
            <option value="<%= i %>"><%= i %> Passenger<%= i>1?"s":"" %></option>
          <%}%>
        </select>
      </div>
      <div class="sb">
        <button type="submit" class="btn-search">🔍 Search</button>
      </div>
    </form>
  </div>

  <%-- ── RECENT BOOKINGS ──────────────────────────────────────────── --%>
  <div class="bookings-section fade-up d3">
    <div class="section-header">
      <div class="section-title">Recent Bookings</div>
      <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-ghost btn-sm">View All →</a>
    </div>

    <div class="table-wrap">
      <% if (recentBookings == null || recentBookings.isEmpty()) { %>
        <div class="empty-state">
          <div class="empty-icon">✈</div>
          <h3>No bookings yet</h3>
          <p>Search for a flight above to get started on your journey!</p>
          <a href="${pageContext.request.contextPath}/searchFlights" class="btn btn-primary" style="margin-top:16px">🔍 Search Flights</a>
        </div>
      <% } else { %>
        <table class="sc-table zebra">
          <thead>
            <tr>
              <th>#</th>
              <th>Flight</th>
              <th>Route</th>
              <th>Date</th>
              <th>Seats</th>
              <th>Amount</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <% int sno=1; for(Booking b : recentBookings) {
             String st = b.status != null ? b.status.toLowerCase() : "booked";
             String bc = st.equals("paid") ? "badge-paid" : st.equals("cancelled") ? "badge-cancelled" : "badge-booked";
          %>
            <tr>
              <td style="color:var(--text-faint);font-size:.78rem"><%= sno++ %></td>
              <td><strong style="font-family:'Syne',sans-serif"><%= b.flightNo %></strong></td>
              <td>
                <div class="route-display">
                  <span class="route-city"><%= b.source %></span>
                  <span class="route-arrow">→</span>
                  <span class="route-city"><%= b.destination %></span>
                </div>
              </td>
              <td style="color:var(--text-muted);font-size:.82rem"><%= b.bookingDate != null ? b.bookingDate.substring(0,10) : "—" %></td>
              <td style="text-align:center;font-weight:600"><%= b.numSeats %></td>
              <td class="amount-cell">₹<%= String.format("%,.0f", b.totalAmount) %></td>
              <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
              <td>
                <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.bookingId %>" class="tbl-action">
                  🎫 Invoice
                </a>
              </td>
            </tr>
          <% } %>
          </tbody>
        </table>
      <% } %>
    </div>
  </div>

</div><%-- /page-wrapper --%>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  // Set minimum date for search
  document.getElementById('departDateInput').min = new Date().toISOString().split('T')[0];

  // Time-based greeting
  (function(){
    var h = new Date().getHours();
    var label = document.getElementById('timeLabel');
    if (label) {
      if (h < 12)      label.textContent = '🌅 Good morning';
      else if (h < 17) label.textContent = '☀️ Good afternoon';
      else if (h < 21) label.textContent = '🌆 Good evening';
      else             label.textContent = '🌙 Good night';
    }
  })();
</script>
</body>
</html>
