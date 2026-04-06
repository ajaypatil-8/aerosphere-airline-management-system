<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer id        = (Integer) request.getAttribute("id");
    String  flightNo  = (String)  request.getAttribute("flightNo");
    String  source    = (String)  request.getAttribute("source");
    String  dest      = (String)  request.getAttribute("destination");
    Object  date      = request.getAttribute("date");
    Object  depTime   = request.getAttribute("departTime");
    Object  arrTime   = request.getAttribute("arrivalTime");
    Double  price     = (Double)  request.getAttribute("price");
    Integer totalSeats= (Integer) request.getAttribute("totalSeats");
    Integer availSeats= (Integer) request.getAttribute("availableSeats");
    String depTimeStr = depTime != null ? depTime.toString().substring(0,5) : "";
    String arrTimeStr = arrTime != null ? arrTime.toString().substring(0,5) : "";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Edit Flight – AeroSphere Admin</title>
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
.page-wrapper{max-width:680px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.page-subtitle strong{color:var(--primary)}
.info-box{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;background:var(--primary-glow);border:1px solid var(--primary);border-radius:12px;padding:18px 20px;margin-bottom:22px}
.info-item-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:4px}
.info-item-val{font-weight:700;font-size:.92rem}
.info-item-val.emerald{color:var(--primary)}
.card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:28px 32px;box-shadow:var(--shadow)}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.form-group{display:flex;flex-direction:column;gap:6px}
.form-group label{font-size:.78rem;font-weight:600;text-transform:uppercase;letter-spacing:.04em;color:var(--text-muted)}
.field-wrap{display:flex;align-items:center;gap:10px;background:var(--bg);border:1.5px solid var(--border);border-radius:10px;padding:0 14px;transition:border-color .2s}
.field-wrap:focus-within{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.field-wrap .fi{font-size:1rem;flex-shrink:0}
.field-wrap input{flex:1;border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.88rem;padding:11px 0;outline:none}
.divider{border:none;border-top:1px solid var(--border);margin:24px 0}
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 18px;border-radius:9px;font-weight:600;font-size:.84rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none;font-family:'Inter',sans-serif}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 3px 10px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-secondary{background:var(--bg);border:1px solid var(--border);color:var(--text)}
.btn-secondary:hover{border-color:var(--primary);color:var(--primary)}
.form-actions{display:flex;gap:10px;justify-content:flex-end}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .45s ease forwards}
@media(max-width:600px){.form-grid{grid-template-columns:1fr}.info-box{grid-template-columns:1fr 1fr}.page-wrapper{padding:20px 14px}.navbar{padding:10px 16px}.nav-links .nav-link:not(.btn-danger){display:none}}
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
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
    <button class="theme-toggle" id="themeToggle" title="Toggle theme">🌙</button>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">✏️ Edit Flight</h1>
      <p class="page-subtitle">Flight <strong><%= flightNo %></strong> — <%= source %> → <%= dest %></p>
    </div>
    <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-secondary">← Back</a>
  </div>

  <!-- Read-only info strip -->
  <div class="info-box animate-fadeup">
    <div><div class="info-item-label">Flight No</div><div class="info-item-val emerald"><%= flightNo %></div></div>
    <div><div class="info-item-label">From</div><div class="info-item-val"><%= source %></div></div>
    <div><div class="info-item-label">To</div><div class="info-item-val"><%= dest %></div></div>
    <div><div class="info-item-label">Total Seats</div><div class="info-item-val"><%= totalSeats %></div></div>
    <div><div class="info-item-label">Available</div><div class="info-item-val emerald"><%= availSeats %></div></div>
  </div>

  <div class="card animate-fadeup">
    <form action="${pageContext.request.contextPath}/editFlight" method="post">
      <input type="hidden" name="id" value="<%= id %>">
      <div class="form-grid">
        <div class="form-group">
          <label>Departure Date *</label>
          <div class="field-wrap"><span class="fi">📅</span><input type="date" name="depart_date" value="<%= date %>" required></div>
        </div>
        <div class="form-group">
          <label>Price per Seat (₹) *</label>
          <div class="field-wrap"><span class="fi">💰</span><input type="number" name="price" value="<%= price != null ? price : "" %>" min="1" step="0.01" required></div>
        </div>
        <div class="form-group">
          <label>Departure Time *</label>
          <div class="field-wrap"><span class="fi">🕐</span><input type="time" name="depart_time" value="<%= depTimeStr %>" required></div>
        </div>
        <div class="form-group">
          <label>Arrival Time</label>
          <div class="field-wrap"><span class="fi">🕑</span><input type="time" name="arrival_time" value="<%= arrTimeStr %>"></div>
        </div>
      </div>
      <div class="divider"></div>
      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary">✅ Save Changes</button>
      </div>
    </form>
  </div>
</div>

<script>
(function(){const root=document.documentElement;const saved=localStorage.getItem('theme')||'light';root.setAttribute('data-theme',saved);document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const cur=document.documentElement.getAttribute('data-theme');const next=cur==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);this.textContent=next==='dark'?'☀️':'🌙';});
</script>
</body>
</html>
