<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<BookingRow> bookings   = (List<BookingRow>) request.getAttribute("bookings");
    int currentPage   = request.getAttribute("currentPage")   != null ? (Integer) request.getAttribute("currentPage")   : 1;
    int totalPages    = request.getAttribute("totalPages")    != null ? (Integer) request.getAttribute("totalPages")    : 1;
    int totalBookings = request.getAttribute("totalBookings") != null ? (Integer) request.getAttribute("totalBookings") : 0;
    String search     = request.getAttribute("search")        != null ? (String)  request.getAttribute("search")        : "";
    String statusFilt = request.getAttribute("statusFilter")  != null ? (String)  request.getAttribute("statusFilter")  : "";
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess"); session.removeAttribute("cancelError");
    String adminFirst = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>All Bookings – AeroSphere Admin</title>
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
.filter-bar{display:flex;align-items:center;gap:12px;margin-bottom:18px;flex-wrap:wrap}
.filter-wrap{display:flex;align-items:center;gap:10px;background:var(--surface-0);border:1.5px solid var(--border);border-radius:var(--radius-sm);padding:9px 14px;flex:1;min-width:200px;transition:border-color .2s}
.filter-wrap:focus-within{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.filter-wrap input{border:none;background:transparent;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.86rem;outline:none;width:100%}
.filter-wrap input::placeholder{color:var(--text-muted)}
.filter-select{padding:9px 14px;background:var(--surface-0);border:1.5px solid var(--border);border-radius:var(--radius-sm);color:var(--text);font-family:'DM Sans',sans-serif;font-size:.86rem;outline:none;cursor:pointer;transition:border-color .2s}
.filter-select:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.empty-state{text-align:center;padding:60px 24px}
@media(max-width:900px){
  .as-sidebar.open{transform:translateX(0);box-shadow:var(--shadow-lg)}
  .sidebar-toggle-btn{display:flex}
  .admin-topbar{padding:0 16px}
}

.pagination{display:flex;align-items:center;justify-content:center;gap:6px;margin:24px 0 8px;flex-wrap:wrap}
.pg-btn{display:inline-flex;align-items:center;justify-content:center;min-width:34px;height:34px;padding:0 10px;
  border-radius:7px;font-size:.83rem;font-weight:600;text-decoration:none;border:1.5px solid var(--border);
  color:var(--text);background:var(--card);transition:.2s}
.pg-btn:hover{border-color:var(--primary);color:var(--primary)}
.pg-btn.active{background:var(--primary);color:#fff;border-color:var(--primary)}
.pg-btn.disabled{opacity:.4;pointer-events:none}
</style>
</head>
<body>

<div class="as-admin-layout">

  <%@ include file="/Views/common/sidebar.jsp" %>

  <main class="as-main">
    <div class="admin-topbar">
      <div class="topbar-left">
        <button class="sidebar-toggle-btn" id="as-sidebar-toggle" aria-label="Toggle sidebar">☰</button>
        <span class="topbar-title">All Bookings</span>
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
          <h1 class="page-title">🎫 All Bookings</h1>
          <p class="page-subtitle"><%= totalBookings %> total reservations — page <%= currentPage %> of <%= totalPages %></p>
        </div>
      </div>

      <% if (cancelError   != null) { %><div class="alert alert-danger anim-fade-up"><span>⚠</span><span><%= cancelError %></span></div><% } %>
      <% if (cancelSuccess != null) { %><div class="alert alert-success anim-fade-up"><span>✅</span><span><%= cancelSuccess %></span></div><% } %>

      <div class="filter-bar anim-fade-up">
        <div class="filter-wrap"><span>🔍</span><input id="searchBox" type="text" placeholder="Search passenger, flight, route…"></div>
        <select class="filter-select" id="statusFilter">
          <option value="">All Statuses</option>
          <option value="booked">Booked</option>
          <option value="paid">Paid</option>
          <option value="cancelled">Cancelled</option>
        </select>
      </div>

      <div class="table-wrap anim-fade-up">
        <% if (bookings == null || bookings.isEmpty()) { %>
          <div class="empty-state">
            <div style="font-size:2.5rem;margin-bottom:12px">🎫</div>
            <h3 style="font-family:'Syne',sans-serif;font-weight:700;margin-bottom:6px">No bookings yet</h3>
            <p style="color:var(--text-muted);font-size:.88rem">Bookings will appear here once users start reserving flights.</p>
          </div>
        <% } else { %>
        <table class="sc-table" id="bookTable">
          <thead>
            <tr>
              <th>#</th><th>ID</th><th>Passenger</th><th>Flight</th>
              <th>Seats</th><th>Amount</th><th>Status</th><th>Booked On</th><th>Action</th>
            </tr>
          </thead>
          <tbody>
          <% int bi = 0; for (BookingRow b : bookings) { bi++;
             String st = b.status != null ? b.status.toLowerCase() : "booked";
             String bc = st.equals("paid") ? "badge-paid" : st.equals("cancelled") ? "badge-cancelled" : "badge-booked";
          %>
          <tr>
            <td style="color:var(--text-muted)"><%= bi %></td>
            <td style="color:var(--primary);font-family:'Syne',sans-serif;font-weight:700">#<%= b.id %></td>
            <td style="font-weight:600"><%= b.userName %></td>
            <td><strong style="font-family:'Syne',sans-serif;color:var(--primary)"><%= b.flightNo %></strong></td>
            <td style="text-align:center;font-weight:600"><%= b.seats %></td>
            <td style="color:var(--secondary);font-family:'Syne',sans-serif;font-weight:700">₹<%= String.format("%,.0f", b.amount) %></td>
            <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
            <td style="font-size:.82rem;color:var(--text-muted)"><%= b.bookedOn != null ? b.bookedOn.toString().substring(0,10) : "—" %></td>
            <td>
              <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.id %>" class="btn btn-ghost btn-xs">🎫 Invoice</a>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
        <% } %>
  
        <%-- ── Pagination ── --%>
        <% if (totalPages > 1) { %>
        <div class="pagination">
          <% String qStr = "search=" + java.net.URLEncoder.encode(search,"UTF-8") + "&status=" + java.net.URLEncoder.encode(statusFilt,"UTF-8"); %>
          <% if (currentPage > 1) { %>
            <a class="pg-btn" href="?page=<%= currentPage-1 %>&<%= qStr %>">‹</a>
          <% } else { %><span class="pg-btn disabled">‹</span><% } %>
          <% int ps = Math.max(1, currentPage-2), pe = Math.min(totalPages, ps+4); ps = Math.max(1, pe-4);
             if (ps > 1) { %><a class="pg-btn" href="?page=1&<%= qStr %>">1</a><% if(ps>2){%><span style="color:var(--text-muted)">…</span><%}}
             for (int pg = ps; pg <= pe; pg++) { %>
            <a class="pg-btn <%= pg==currentPage?"active":"" %>" href="?page=<%= pg %>&<%= qStr %>"><%= pg %></a>
          <% } if (pe < totalPages) { if(pe<totalPages-1){%><span style="color:var(--text-muted)">…</span><%}
               %><a class="pg-btn" href="?page=<%= totalPages %>&<%= qStr %>"><%= totalPages %></a><% } %>
          <% if (currentPage < totalPages) { %>
            <a class="pg-btn" href="?page=<%= currentPage+1 %>&<%= qStr %>">›</a>
          <% } else { %><span class="pg-btn disabled">›</span><% } %>
        </div>
        <p style="text-align:center;font-size:.8rem;color:var(--text-muted);margin-bottom:16px">
          Showing <%= ((currentPage-1)*25)+1 %>–<%= Math.min(currentPage*25,totalBookings) %> of <%= totalBookings %> bookings
        </p>
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
  // Filter
  // Search/filter handled server-side via form submission
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
