<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.controller.ReportFlightsServlet.FlightRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked") List<FlightRow> flights = (List<FlightRow>) request.getAttribute("flights");
    String gen = new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new Date());
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Flights Report – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}
.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:8px}
.nav-back{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;border:1px solid var(--border);transition:all .2s}
.nav-back:hover{border-color:var(--primary);color:var(--primary)}
.btn-print{padding:7px 16px;background:var(--primary);color:#fff;border:none;border-radius:8px;font-weight:600;font-size:.84rem;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s}
.btn-print:hover{background:var(--primary-dark)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;margin-left:4px}
.theme-toggle:hover{border-color:var(--primary)}
.page-wrapper{max-width:1100px;margin:0 auto;padding:32px 24px}
.page-header{margin-bottom:24px;padding-bottom:18px;border-bottom:1px solid var(--border)}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.86rem}
.table-wrap{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.sc-table{width:100%;border-collapse:collapse}
.sc-table th{padding:12px 16px;text-align:left;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
.sc-table td{padding:12px 16px;font-size:.86rem;border-bottom:1px solid var(--border)}
.sc-table tr:last-child td{border-bottom:none}
.sc-table tbody tr:hover{background:var(--primary-glow)}
.empty-state{text-align:center;padding:56px 24px;color:var(--text-muted)}
.empty-icon{font-size:2.5rem;margin-bottom:12px}
.empty-state h3{font-weight:700;color:var(--text)}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .45s ease forwards}
@media print{.navbar{display:none}.page-wrapper{padding:0}}
</style>
</head>
<body>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/reports" class="nav-back">← Reports</a>
    <button onclick="window.print()" class="btn-print">🖨 Print</button>
    <button class="theme-toggle" id="themeToggle">🌙</button>
  </div>
</nav>
<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div class="page-title">✈ Flights Report</div>
    <div class="page-subtitle">Generated: <%= gen %> &nbsp;·&nbsp; <%= flights != null ? flights.size() : 0 %> records</div>
  </div>
  <div class="table-wrap animate-fadeup">
    <% if (flights == null || flights.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">✈</div><h3>No flights data</h3></div>
    <% } else { %>
    <table class="sc-table"><thead><tr><th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Departure</th><th>Arrival</th><th>Price</th><th>Total Seats</th><th>Available</th></tr></thead>
    <tbody><% int i=0; for(FlightRow f : flights) { i++;
      int pct=f.totalSeats>0?(f.availableSeats*100/f.totalSeats):0;
      String sc=pct>50?"var(--primary)":pct>20?"#F59E0B":"#EF4444"; %>
    <tr><td style="color:var(--text-muted)"><%= i %></td>
    <td><strong style="color:var(--primary)"><%= f.flightNo %></strong></td>
    <td style="font-size:.84rem"><%= f.source %> → <%= f.destination %></td>
    <td style="font-size:.82rem"><%= f.departDate %></td>
    <td style="font-size:.82rem"><%= f.departTime!=null?f.departTime.toString().substring(0,5):"—" %></td>
    <td style="font-size:.82rem"><%= f.arrivalTime!=null?f.arrivalTime.toString().substring(0,5):"—" %></td>
    <td style="color:var(--primary);font-weight:700">₹<%= String.format("%,.0f",f.price) %></td>
    <td><%= f.totalSeats %></td>
    <td><span style="color:<%= sc %>;font-weight:700"><%= f.availableSeats %></span></td></tr>
    <% } %></tbody></table>
    <% } %>
  </div>
</div>
<script>
(function(){const root=document.documentElement;const saved=localStorage.getItem('theme')||'light';root.setAttribute('data-theme',saved);document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const cur=document.documentElement.getAttribute('data-theme');const next=cur==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);this.textContent=next==='dark'?'☀️':'🌙';});
</script>
</body>
</html>
