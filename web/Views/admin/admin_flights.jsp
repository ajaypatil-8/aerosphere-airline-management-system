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
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Manage Flights – AeroSphere Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--accent:#A7F3D0;--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--accent:#34D399;--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
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
.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
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
.filter-bar{display:flex;align-items:center;gap:12px;margin-bottom:16px}
.filter-wrap{display:flex;align-items:center;gap:10px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;padding:9px 14px;flex:1;transition:border-color .2s}
.filter-wrap:focus-within{border-color:var(--primary)}
.filter-wrap input{border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.86rem;outline:none;width:100%}
.filter-wrap input::placeholder{color:var(--text-muted)}
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:9px;font-weight:600;font-size:.84rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none;font-family:'Inter',sans-serif}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 3px 10px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-secondary{background:var(--bg);border:1px solid var(--border);color:var(--text)}
.btn-secondary:hover{border-color:var(--primary);color:var(--primary)}
.btn-danger-sm{background:rgba(220,38,38,.08);border:1px solid rgba(220,38,38,.2);color:#DC2626;padding:5px 12px;border-radius:7px;font-size:.78rem;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s}
.btn-danger-sm:hover{background:rgba(220,38,38,.15)}
.btn-edit{background:rgba(59,130,246,.08);border:1px solid rgba(59,130,246,.2);color:#2563EB;padding:5px 12px;border-radius:7px;font-size:.78rem;font-weight:600;text-decoration:none;transition:all .2s;display:inline-flex;align-items:center;gap:4px}
.btn-edit:hover{background:rgba(59,130,246,.15)}
[data-theme="dark"] .btn-edit{color:#93C5FD}
.table-wrap{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.sc-table{width:100%;border-collapse:collapse}
.sc-table th{padding:12px 16px;text-align:left;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
.sc-table td{padding:13px 16px;font-size:.86rem;border-bottom:1px solid var(--border)}
.sc-table tr:last-child td{border-bottom:none}
.sc-table tbody tr:hover{background:var(--primary-glow)}
.text-dim{color:var(--text-muted)}
.route-display{display:flex;align-items:center;gap:6px}
.route-city{font-weight:600;font-size:.84rem}
.route-arrow{color:var(--primary);font-weight:700}
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.73rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.badge-booked{background:rgba(245,158,11,.12);color:#D97706}
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
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link active">Flights</a>
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
      <h1 class="page-title">✈ Flight Schedule</h1>
      <p class="page-subtitle"><%= flights != null ? flights.size() : 0 %> flights in the system</p>
    </div>
    <a href="${pageContext.request.contextPath}/addFlight" class="btn btn-primary">+ Add Flight</a>
  </div>

  <% if (deleteError != null)   { %><div class="alert alert-error">⚠ <%= deleteError %></div><% } %>
  <% if (deleteSuccess != null) { %><div class="alert alert-success">✅ <%= deleteSuccess %></div><% } %>

  <div class="filter-bar animate-fadeup">
    <div class="filter-wrap"><span>🔍</span><input id="searchBox" type="text" placeholder="Search by flight number, city..."></div>
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
         String seatColor = pct > 50 ? "var(--primary)" : pct > 20 ? "#F59E0B" : "#EF4444";
      %>
      <tr>
        <td class="text-dim"><%= fi %></td>
        <td><strong style="color:var(--primary)"><%= f.flightNo %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= f.source %></span><span class="route-arrow">→</span><span class="route-city"><%= f.destination %></span></div></td>
        <td style="font-size:.85rem;"><%= f.date %></td>
        <td style="font-size:.85rem;"><%= f.departTime != null ? f.departTime.toString().substring(0,5) : "—" %></td>
        <td style="font-size:.85rem;"><%= f.arrivalTime != null ? f.arrivalTime.toString().substring(0,5) : "—" %></td>
        <td style="color:var(--primary);font-weight:700;">₹<%= String.format("%,.0f", f.price) %></td>
        <td><%= f.totalSeats %></td>
        <td><span style="color:<%= seatColor %>;font-weight:700;"><%= f.availableSeats %></span></td>
        <td>
          <div style="display:flex;gap:8px;align-items:center;">
            <% if (f.availableSeats == f.totalSeats) { %>
            <a href="${pageContext.request.contextPath}/editFlight?id=<%= f.id %>" class="btn-edit">✏️ Edit</a>
            <form action="${pageContext.request.contextPath}/deleteFlight" method="post" style="margin:0;" onsubmit="return confirm('Delete flight <%= f.flightNo %>?')">
              <input type="hidden" name="id" value="<%= f.id %>">
              <button type="submit" class="btn-danger-sm">🗑 Delete</button>
            </form>
            <% } else { %>
            <span class="badge badge-booked">Has Bookings</span>
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

<script>
(function(){const root=document.documentElement;const saved=localStorage.getItem('theme')||'light';root.setAttribute('data-theme',saved);document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const cur=document.documentElement.getAttribute('data-theme');const next=cur==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);this.textContent=next==='dark'?'☀️':'🌙';});
document.getElementById('searchBox')?.addEventListener('input',function(){const q=this.value.toLowerCase();document.querySelectorAll('#flightTable tbody tr').forEach(r=>{r.style.display=r.textContent.toLowerCase().includes(q)?'':'none';});});
</script>
</body>
</html>
