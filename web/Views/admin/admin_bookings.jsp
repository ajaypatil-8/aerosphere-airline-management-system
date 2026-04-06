<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<BookingRow> bookings = (List<BookingRow>) request.getAttribute("bookings");
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess"); session.removeAttribute("cancelError");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>All Bookings – AeroSphere Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}
.brand-name span{color:var(--primary)}
.admin-badge{font-size:.6rem;background:rgba(245,158,11,.15);color:#D97706;border:1px solid rgba(245,158,11,.3);padding:2px 7px;border-radius:4px;font-weight:700;letter-spacing:.05em;margin-left:4px;vertical-align:middle}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover,.nav-link.active{color:var(--primary);background:var(--primary-glow)}
.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.theme-toggle:hover{border-color:var(--primary)}
.page-wrapper{max-width:1200px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.alert-success{background:var(--primary-glow);border:1px solid var(--primary);color:var(--primary)}
.filter-bar{display:flex;align-items:center;gap:12px;margin-bottom:16px;flex-wrap:wrap}
.filter-wrap{display:flex;align-items:center;gap:10px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;padding:9px 14px;flex:1;min-width:200px;transition:border-color .2s}
.filter-wrap:focus-within{border-color:var(--primary)}
.filter-wrap input{border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.86rem;outline:none;width:100%}
.filter-wrap input::placeholder{color:var(--text-muted)}
.filter-select{padding:9px 14px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;color:var(--text);font-family:'Inter',sans-serif;font-size:.86rem;outline:none;cursor:pointer}
.filter-select:focus{border-color:var(--primary)}
.table-wrap{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.sc-table{width:100%;border-collapse:collapse}
.sc-table th{padding:12px 16px;text-align:left;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
.sc-table td{padding:13px 16px;font-size:.86rem;border-bottom:1px solid var(--border)}
.sc-table tr:last-child td{border-bottom:none}
.sc-table tbody tr:hover{background:var(--primary-glow)}
.text-dim{color:var(--text-muted)}
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.73rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.badge-paid{background:rgba(16,185,129,.12);color:#059669}
[data-theme="dark"] .badge-paid{color:#34D399}
.badge-cancelled{background:rgba(239,68,68,.1);color:#DC2626}
[data-theme="dark"] .badge-cancelled{color:#FCA5A5}
.badge-booked{background:rgba(59,130,246,.1);color:#2563EB}
[data-theme="dark"] .badge-booked{color:#93C5FD}
.btn{display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:7px;font-weight:600;font-size:.78rem;text-decoration:none;cursor:pointer;transition:all .2s;border:1px solid transparent;font-family:'Inter',sans-serif}
.btn-invoice{background:var(--bg);border-color:var(--border);color:var(--text)}
.btn-invoice:hover{border-color:var(--primary);color:var(--primary)}
.empty-state{text-align:center;padding:56px 24px;color:var(--text-muted)}
.empty-icon{font-size:2.5rem;margin-bottom:12px}
.empty-state h3{font-weight:700;color:var(--text);margin-bottom:6px}
@keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .5s ease forwards}
@media(max-width:600px){.page-wrapper{padding:20px 14px}.navbar{padding:10px 16px}.nav-links .nav-link:not(.btn-danger){display:none}}
</style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span><span class="admin-badge">ADMIN</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link active">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
    <button class="theme-toggle" id="themeToggle" title="Toggle theme">🌙</button>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">📋 All Bookings</h1>
      <p class="page-subtitle"><%= bookings != null ? bookings.size() : 0 %> total reservations</p>
    </div>
  </div>

  <% if (cancelError   != null) { %><div class="alert alert-error">⚠ <%= cancelError %></div><% } %>
  <% if (cancelSuccess != null) { %><div class="alert alert-success">✅ <%= cancelSuccess %></div><% } %>

  <div class="filter-bar animate-fadeup">
    <div class="filter-wrap"><span>🔍</span><input id="searchBox" type="text" placeholder="Search passenger, flight, route..."></div>
    <select class="filter-select" id="statusFilter">
      <option value="">All Statuses</option>
      <option value="booked">Booked</option>
      <option value="paid">Paid</option>
      <option value="cancelled">Cancelled</option>
    </select>
  </div>

  <div class="table-wrap animate-fadeup">
    <% if (bookings == null || bookings.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">📋</div><h3>No bookings yet</h3><p>Bookings will appear here once users start reserving flights.</p></div>
    <% } else { %>
    <table class="sc-table" id="bookTable">
      <thead><tr><th>#</th><th>ID</th><th>Passenger</th><th>Flight</th><th>Seats</th><th>Amount</th><th>Status</th><th>Booked On</th><th>Action</th></tr></thead>
      <tbody>
      <% int bi = 0; for (BookingRow b : bookings) { bi++;
         String st = b.status != null ? b.status.toLowerCase() : "booked";
         String bc = st.equals("paid") ? "badge-paid" : st.equals("cancelled") ? "badge-cancelled" : "badge-booked";
      %>
      <tr>
        <td class="text-dim"><%= bi %></td>
        <td style="color:var(--primary);font-weight:700;">#<%= b.id %></td>
        <td style="font-weight:500;"><%= b.userName %></td>
        <td><strong><%= b.flightNo %></strong></td>
        <td style="text-align:center"><%= b.seats %></td>
        <td style="color:var(--primary);font-weight:700;">₹<%= String.format("%,.0f", b.amount) %></td>
        <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
        <td style="font-size:.8rem;color:var(--text-muted);"><%= b.bookedOn != null ? b.bookedOn.toString().substring(0,10) : "—" %></td>
        <td>
          <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.id %>" class="btn btn-invoice">🎫 Invoice</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

<script>
(function(){const root=document.documentElement;const saved=localStorage.getItem('theme')||'light';root.setAttribute('data-theme',saved);document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const cur=document.documentElement.getAttribute('data-theme');const next=cur==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);this.textContent=next==='dark'?'☀️':'🌙';});
function filterTable(){const q=document.getElementById('searchBox').value.toLowerCase();const s=document.getElementById('statusFilter').value.toLowerCase();document.querySelectorAll('#bookTable tbody tr').forEach(r=>{const txt=r.textContent.toLowerCase();r.style.display=(txt.includes(q)&&(s===''||txt.includes(s)))?'':'none';});}
document.getElementById('searchBox')?.addEventListener('input',filterTable);
document.getElementById('statusFilter')?.addEventListener('change',filterTable);
</script>
</body>
</html>
