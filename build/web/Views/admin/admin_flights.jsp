<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminFlightsServlet.Flight" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Flight> flights    = (List<Flight>) request.getAttribute("flights");
    String deleteError   = (String) session.getAttribute("deleteError");
    String deleteSuccess = (String) session.getAttribute("deleteSuccess");
    session.removeAttribute("deleteError"); session.removeAttribute("deleteSuccess");
    String csrfToken = CsrfUtil.getToken(request);
    String adminFirst = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Manage Flights – AeroSphere Admin</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600;9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.admin-topbar{position:sticky;top:0;z-index:300;height:56px;display:flex;align-items:center;justify-content:space-between;padding:0 32px;background:var(--glass-bg);border-bottom:1px solid var(--border);backdrop-filter:var(--glass-blur);-webkit-backdrop-filter:var(--glass-blur)}
.topbar-left{display:flex;align-items:center;gap:12px}
.topbar-title{font-family:'Syne',sans-serif;font-size:.95rem;font-weight:700;color:var(--text);letter-spacing:-.02em}
.topbar-right{display:flex;align-items:center;gap:8px}
.sidebar-toggle-btn{display:none;width:36px;height:36px;background:var(--surface-0);border:1px solid var(--border-2);border-radius:var(--radius-sm);align-items:center;justify-content:center;font-size:1.1rem;cursor:pointer;transition:border-color .2s}
.sidebar-toggle-btn:hover{border-color:var(--primary)}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px}
.page-title{font-family:'Syne',sans-serif;font-size:1.55rem;font-weight:800;letter-spacing:-.04em;color:var(--text)}
.page-subtitle{font-size:.88rem;color:var(--text-muted);margin-top:4px}
.filter-bar{display:flex;align-items:center;gap:12px;margin-bottom:18px}
.filter-wrap{display:flex;align-items:center;gap:10px;background:var(--surface-0);border:1.5px solid var(--border);border-radius:var(--radius-sm);padding:9px 14px;flex:1;transition:border-color .2s}
.filter-wrap:focus-within{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.filter-wrap input{border:none;background:transparent;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.86rem;outline:none;width:100%}
.filter-wrap input::placeholder{color:var(--text-muted)}
.route-cell{display:flex;align-items:center;gap:6px}
.route-city{font-weight:600;font-size:.86rem}
.route-arrow{color:var(--primary);font-weight:700}
.action-row{display:flex;gap:8px;align-items:center}
.empty-state{text-align:center;padding:60px 24px}
@media(max-width:900px){
  .as-sidebar.open{transform:translateX(0);box-shadow:var(--shadow-lg)}
  .sidebar-toggle-btn{display:flex}
  .admin-topbar{padding:0 16px}
}
</style>
</head>
<body>

<div class="as-admin-layout">

  <%@ include file="/Views/common/sidebar.jsp" %>

  <main class="as-main">
    <div class="admin-topbar">
      <div class="topbar-left">
        <button class="sidebar-toggle-btn" id="as-sidebar-toggle" aria-label="Toggle sidebar">☰</button>
        <span class="topbar-title">Flight Schedule</span>
      </div>
      <div class="topbar-right">
        <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme">🌙</button>
        <div class="user-pill">
          <div class="user-avatar"><%= adminFirst.charAt(0) %></div>
          <span><%= adminFirst %></span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">↩ Logout</a>
      </div>
    </div>

    <div class="page-wrapper">

      <div class="page-header anim-fade-up">
        <div>
          <h1 class="page-title">✈ Flight Schedule</h1>
          <p class="page-subtitle"><%= flights != null ? flights.size() : 0 %> flights in the system</p>
        </div>
        <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary">➕ Add Flight</a>
      </div>

      <% if (deleteError   != null) { %><div class="alert alert-danger anim-fade-up"><span>⚠</span><span><%= deleteError %></span></div><% } %>
      <% if (deleteSuccess != null) { %><div class="alert alert-success anim-fade-up"><span>✅</span><span><%= deleteSuccess %></span></div><% } %>

      <div class="filter-bar anim-fade-up">
        <div class="filter-wrap"><span>🔍</span><input id="searchBox" type="text" placeholder="Search flight number, city…"></div>
      </div>

      <div class="table-wrap anim-fade-up">
        <% if (flights == null || flights.isEmpty()) { %>
          <div class="empty-state">
            <div style="font-size:2.5rem;margin-bottom:12px">✈</div>
            <h3 style="font-family:'Syne',sans-serif;font-weight:700;margin-bottom:6px">No flights scheduled</h3>
            <p style="color:var(--text-muted);font-size:.88rem;margin-bottom:16px">Add your first flight to get started.</p>
            <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary">➕ Add Flight</a>
          </div>
        <% } else { %>
        <table class="sc-table" id="flightTable">
          <thead>
            <tr>
              <th>#</th><th>Flight No</th><th>Route</th><th>Date</th>
              <th>Departure</th><th>Arrival</th><th>Price</th><th>Seats</th><th>Available</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <% int fi = 0; for (Flight f : flights) { fi++;
             int pct = f.totalSeats > 0 ? (f.availableSeats * 100 / f.totalSeats) : 0;
             String seatColor = pct > 50 ? "var(--secondary)" : pct > 20 ? "var(--warning)" : "var(--danger)";
          %>
          <tr>
            <td style="color:var(--text-muted)"><%= fi %></td>
            <td><strong style="font-family:'Syne',sans-serif;color:var(--primary)"><%= f.flightNo %></strong></td>
            <td>
              <div class="route-cell">
                <span class="route-city"><%= f.source %></span>
                <span class="route-arrow">→</span>
                <span class="route-city"><%= f.destination %></span>
              </div>
            </td>
            <td style="font-size:.85rem"><%= f.date %></td>
            <td style="font-size:.85rem"><%= f.departTime  != null ? f.departTime.toString().substring(0,5)  : "—" %></td>
            <td style="font-size:.85rem"><%= f.arrivalTime != null ? f.arrivalTime.toString().substring(0,5) : "—" %></td>
            <td style="color:var(--secondary);font-family:'Syne',sans-serif;font-weight:700">₹<%= String.format("%,.0f", f.price) %></td>
            <td style="font-weight:600"><%= f.totalSeats %></td>
            <td><span style="color:<%= seatColor %>;font-family:'Syne',sans-serif;font-weight:700"><%= f.availableSeats %></span></td>
            <td>
              <div class="action-row">
                <% if (f.availableSeats == f.totalSeats) { %>
                <a href="${pageContext.request.contextPath}/editFlight?id=<%= f.id %>" class="btn btn-ghost btn-xs">✏️ Edit</a>
                <form action="${pageContext.request.contextPath}/deleteFlight" method="post" style="margin:0"
                      onsubmit="return confirm('Delete flight <%= f.flightNo %>?')">
                  <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
                  <input type="hidden" name="id"   value="<%= f.id %>">
                  <button type="submit" class="btn btn-danger btn-xs">🗑 Delete</button>
                </form>
                <% } else { %>
                <span class="badge badge-warning">Has Bookings</span>
                <% } %>
              </div>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
        <% } %>
      </div>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/assests/js/darkmode.js"></script>
<script>
(function(){
  var btn = document.getElementById('themeToggle');
  if (btn) {
    btn.textContent = document.documentElement.getAttribute('data-theme') === 'dark' ? '☀️' : '🌙';
    btn.addEventListener('click', function() {
      var next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem('asTheme', next);
      btn.textContent = next === 'dark' ? '☀️' : '🌙';
    });
  }
  // Search filter
  var sb = document.getElementById('searchBox');
  if (sb) sb.addEventListener('input', function() {
    var q = this.value.toLowerCase();
    document.querySelectorAll('#flightTable tbody tr').forEach(function(r) {
      r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  });
  // Sidebar
  var tog = document.getElementById('as-sidebar-toggle');
  var sid = document.getElementById('as-sidebar');
  var ov  = document.getElementById('as-sidebar-overlay');
  if (tog && sid) {
    tog.addEventListener('click', function() { sid.classList.toggle('open'); if (ov) ov.classList.toggle('active'); });
    if (ov) ov.addEventListener('click', function() { sid.classList.remove('open'); ov.classList.remove('active'); });
  }
})();
</script>
</body>
</html>
