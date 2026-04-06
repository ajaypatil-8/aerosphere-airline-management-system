<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Reports – AeroSphere Admin</title>
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
.page-wrapper{max-width:900px;margin:0 auto;padding:32px 24px}
.page-header{margin-bottom:32px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.reports-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
.report-card{display:flex;flex-direction:column;align-items:flex-start;gap:12px;padding:26px 22px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:var(--radius);text-decoration:none;color:var(--text);transition:all .25s;box-shadow:var(--shadow);position:relative;overflow:hidden}
.report-card::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;background:var(--primary);transform:scaleX(0);transition:transform .3s;transform-origin:left}
.report-card:hover{border-color:var(--primary);transform:translateY(-4px);box-shadow:var(--shadow-lg)}
.report-card:hover::after{transform:scaleX(1)}
.report-icon{font-size:2rem;width:52px;height:52px;display:flex;align-items:center;justify-content:center;background:var(--primary-glow);border-radius:12px}
.report-title{font-weight:700;font-size:.95rem}
.report-sub{color:var(--text-muted);font-size:.8rem;line-height:1.4}
.report-arrow{color:var(--primary);font-size:.9rem;font-weight:700;margin-top:auto}
@keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .5s ease forwards}
@media(max-width:700px){.reports-grid{grid-template-columns:1fr 1fr}}
@media(max-width:450px){.reports-grid{grid-template-columns:1fr}.page-wrapper{padding:20px 14px}.navbar{padding:10px 16px}.nav-links .nav-link:not(.btn-danger){display:none}}
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
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link active">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
    <button class="theme-toggle" id="themeToggle" title="Toggle theme">🌙</button>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <h1 class="page-title">📊 Reports</h1>
    <p class="page-subtitle">Download and view system analytics & exports</p>
  </div>

  <div class="reports-grid animate-fadeup">
    <a href="${pageContext.request.contextPath}/reportBookings" class="report-card">
      <div class="report-icon">🎫</div>
      <div class="report-title">Bookings Report</div>
      <div class="report-sub">All reservations with status and payment details</div>
      <div class="report-arrow">View report →</div>
    </a>
    <a href="${pageContext.request.contextPath}/reportFlights" class="report-card">
      <div class="report-icon">✈️</div>
      <div class="report-title">Flights Report</div>
      <div class="report-sub">All scheduled flights with seat availability</div>
      <div class="report-arrow">View report →</div>
    </a>
    <a href="${pageContext.request.contextPath}/reportPassengers" class="report-card">
      <div class="report-icon">👥</div>
      <div class="report-title">Passengers Report</div>
      <div class="report-sub">Complete passenger records with seat assignments</div>
      <div class="report-arrow">View report →</div>
    </a>
    <a href="${pageContext.request.contextPath}/reportPayments" class="report-card">
      <div class="report-icon">💳</div>
      <div class="report-title">Payments Report</div>
      <div class="report-sub">All payment transactions and methods</div>
      <div class="report-arrow">View report →</div>
    </a>
    <a href="${pageContext.request.contextPath}/reportCancelled" class="report-card">
      <div class="report-icon">❌</div>
      <div class="report-title">Cancellations Report</div>
      <div class="report-sub">Cancelled bookings and refund status</div>
      <div class="report-arrow">View report →</div>
    </a>
    <a href="${pageContext.request.contextPath}/reportUsers" class="report-card">
      <div class="report-icon">👤</div>
      <div class="report-title">Users Report</div>
      <div class="report-sub">All registered users and account details</div>
      <div class="report-arrow">View report →</div>
    </a>
  </div>
</div>

<script>
(function(){const root=document.documentElement;const saved=localStorage.getItem('theme')||'light';root.setAttribute('data-theme',saved);document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const cur=document.documentElement.getAttribute('data-theme');const next=cur==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);this.textContent=next==='dark'?'☀️':'🌙';});
</script>
</body>
</html>
