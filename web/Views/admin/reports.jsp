<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String userName=(String)session.getAttribute("userName");
  String userRole=(String)session.getAttribute("userRole");
  if(userName==null||!"ADMIN".equals(userRole)){response.sendRedirect(request.getContextPath()+"/login");return;}
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Reports – AeroSphere Admin</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>

:root{
  --sky:#0EA5E9;--emerald:#10B981;--emerald-dark:#059669;
  --grad:linear-gradient(135deg,var(--sky),var(--emerald));
  --sky-glow:rgba(14,165,233,.18);--em-glow:rgba(16,185,129,.18);
  --bg:#F8FAFC;--card-bg:#FFFFFF;--text:#0F172A;--text-muted:#64748B;
  --border:#E2E8F0;--shadow:0 2px 12px rgba(0,0,0,.06);
  --shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px;
  --sidebar-w:248px;
}
[data-theme="dark"]{
  --bg:#0A0A0F;--card-bg:#111118;--text:#F1F5F9;--text-muted:#94A3B8;
  --border:#1E293B;--shadow:0 2px 12px rgba(0,0,0,.4);
  --shadow-lg:0 12px 40px rgba(0,0,0,.55);
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Syne',sans-serif}

.as-admin-layout{display:flex;min-height:100vh}
.as-sidebar{width:var(--sidebar-w);background:var(--card-bg);border-right:1px solid var(--border);display:flex;flex-direction:column;position:sticky;top:0;height:100vh;overflow-y:auto;z-index:100;transition:transform .3s}
.as-sidebar-brand{padding:20px 18px 14px;display:flex;align-items:center;gap:9px;border-bottom:1px solid var(--border)}
.as-sidebar-logo{width:34px;height:34px;border-radius:9px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:16px;color:#fff}
.as-sidebar-brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.as-sidebar-badge{font-size:.58rem;background:rgba(245,158,11,.15);color:#D97706;border:1px solid rgba(245,158,11,.3);padding:2px 6px;border-radius:4px;font-weight:800;letter-spacing:.07em}
.as-sidebar-section{padding:10px 10px;flex:1}
.as-sidebar-label{font-size:.65rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--text-muted);padding:10px 8px 4px;opacity:.7}
.as-sidebar-link{display:flex;align-items:center;gap:9px;padding:9px 10px;border-radius:10px;text-decoration:none;color:var(--text-muted);font-size:.85rem;font-weight:500;transition:all .2s;position:relative;margin-bottom:1px}
.as-sidebar-link .icon{font-size:15px;width:20px;text-align:center}
.as-sidebar-link:hover{background:var(--sky-glow);color:var(--sky)}
.as-sidebar-link.active{background:var(--sky-glow);color:var(--sky);font-weight:600}
.as-sidebar-link.active::before{content:'';position:absolute;left:0;top:6px;bottom:6px;width:3px;background:var(--grad);border-radius:0 3px 3px 0}
.as-sidebar-link .badge{margin-left:auto;background:var(--grad);color:#fff;font-size:.65rem;font-weight:700;padding:1px 7px;border-radius:99px}
.as-sidebar-footer{padding:14px 12px;border-top:1px solid var(--border)}
.as-sidebar-user{display:flex;align-items:center;gap:9px;padding:10px;background:var(--bg);border-radius:10px;margin-bottom:8px}
.as-sidebar-user-avatar{width:32px;height:32px;border-radius:50%;background:var(--grad);color:#fff;display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:800;flex-shrink:0}
.as-sidebar-user-name{font-size:.83rem;font-weight:600;font-family:'Syne',sans-serif}
.as-sidebar-user-role{font-size:.7rem;color:var(--text-muted)}
.as-sidebar-logout{display:flex;align-items:center;gap:7px;padding:9px 12px;border-radius:10px;text-decoration:none;color:#EF4444;font-size:.83rem;font-weight:600;transition:background .2s}
.as-sidebar-logout:hover{background:rgba(239,68,68,.08)}
.as-main{flex:1;min-width:0;overflow:auto}
/* Mobile sidebar */
.as-sidebar-toggle{display:none;position:fixed;top:14px;left:14px;z-index:300;width:38px;height:38px;border-radius:9px;background:var(--card-bg);border:1px solid var(--border);cursor:pointer;align-items:center;justify-content:center;font-size:16px}
@media(max-width:900px){
  .as-sidebar{position:fixed;left:0;top:0;height:100vh;transform:translateX(-100%);z-index:250}
  .as-sidebar.open{transform:translateX(0)}
  .as-sidebar-toggle{display:flex}
  .as-main{padding-top:0}
}

.page-wrap{padding:32px 36px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem;margin-bottom:28px}
.reports-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
.report-card{display:flex;flex-direction:column;gap:10px;padding:24px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:var(--radius);text-decoration:none;color:var(--text);transition:all .25s;box-shadow:var(--shadow);position:relative;overflow:hidden}
.report-card::before{content:'';position:absolute;inset:0;background:var(--grad);opacity:0;transition:opacity .3s}
.report-card:hover{border-color:var(--sky);transform:translateY(-3px);box-shadow:var(--shadow-lg)}
.report-card:hover::before{opacity:.04}
.report-card::after{content:'';position:absolute;bottom:0;left:0;right:0;height:3px;background:var(--grad);transform:scaleX(0);transition:transform .3s;transform-origin:left}
.report-card:hover::after{transform:scaleX(1)}
.report-icon{width:50px;height:50px;border-radius:12px;background:var(--sky-glow);display:flex;align-items:center;justify-content:center;font-size:1.6rem;position:relative;z-index:1}
.report-title{font-family:'Syne',sans-serif;font-weight:700;font-size:.95rem;position:relative;z-index:1}
.report-sub{color:var(--text-muted);font-size:.8rem;line-height:1.5;position:relative;z-index:1}
.report-arrow{color:var(--sky);font-size:.85rem;font-weight:700;margin-top:auto;position:relative;z-index:1}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .45s ease forwards}
.topbar{display:flex;align-items:center;justify-content:space-between;padding:0 36px;height:62px;border-bottom:1px solid var(--border);background:var(--card-bg)}
.topbar-title{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem}
@media(max-width:700px){.reports-grid{grid-template-columns:1fr 1fr}.page-wrap{padding:20px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/sidebar.jsp" %>
<div class="as-main">
  <div class="topbar">
    <span class="topbar-title">📊 Reports &amp; Analytics</span>
    <button class="as-theme-toggle" id="asThemeToggle" aria-label="Toggle theme">🌙</button>
  </div>
  <div class="page-wrap">
    <h1 class="page-title fu">Reports</h1>
    <p class="page-subtitle fu">Download and view system analytics &amp; exports</p>
    <div class="reports-grid fu">
      <a href="${pageContext.request.contextPath}/reportBookings" class="report-card">
        <div class="report-icon">🎫</div>
        <div class="report-title">Bookings Report</div>
        <div class="report-sub">All reservations with status and payment details</div>
        <div class="report-arrow">View report →</div>
      </a>
      <a href="${pageContext.request.contextPath}/reportFlights" class="report-card">
        <div class="report-icon">✈️</div>
        <div class="report-title">Flights Report</div>
        <div class="report-sub">Flight schedule, capacity and occupancy overview</div>
        <div class="report-arrow">View report →</div>
      </a>
      <a href="${pageContext.request.contextPath}/reportPayments" class="report-card">
        <div class="report-icon">💳</div>
        <div class="report-title">Revenue Report</div>
        <div class="report-sub">All payment transactions and revenue breakdown</div>
        <div class="report-arrow">View report →</div>
      </a>
      <a href="${pageContext.request.contextPath}/reportUsers" class="report-card">
        <div class="report-icon">👥</div>
        <div class="report-title">Users Report</div>
        <div class="report-sub">Registered user list with roles and join dates</div>
        <div class="report-arrow">View report →</div>
      </a>
      <a href="${pageContext.request.contextPath}/reportCancelled" class="report-card">
        <div class="report-icon">❌</div>
        <div class="report-title">Cancellation Report</div>
        <div class="report-sub">All cancelled bookings with refund status</div>
        <div class="report-arrow">View report →</div>
      </a>
      <a href="${pageContext.request.contextPath}/reportPassengers" class="report-card">
        <div class="report-icon">🧳</div>
        <div class="report-title">Passenger Report</div>
        <div class="report-sub">Passenger manifests linked to active bookings</div>
        <div class="report-arrow">View report →</div>
      </a>
    </div>
  </div>
</div>
<script>

(function(){
  var btn=document.getElementById('asThemeToggle');
  if(!btn)return;
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.textContent=t==='dark'?'☀️':'🌙';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();

</script>
</body>
</html>
