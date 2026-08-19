<%-- AeroSphere sidebar.jsp — Admin sidebar include
     Include: <%@ include file="/Views/common/sidebar.jsp" %>
     Requires session: userName, userRole --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String _sbUser = (String) session.getAttribute("userName");
  String _sbInit = (_sbUser!=null&&!_sbUser.isEmpty()) ? String.valueOf(_sbUser.charAt(0)).toUpperCase() : "A";
  String _sbPath = request.getServletPath();
  java.util.function.Function<String,String> _sbActive = (kw) -> _sbPath.contains(kw) ? "active" : "";
  Object _pRefs = request.getAttribute("pendingRefunds");
%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>

:root{
  --sky:#2E4A3D;--emerald:#5B8A6E;--emerald-dark:#3E6350;
  --grad:var(--sky);
  --sky-glow:rgba(46,74,61,.16);--em-glow:rgba(91,138,110,.14);
  --warning:#B8863F;--warning-glow:rgba(184,134,63,.15);
  --danger:#B3554A;--danger-glow:rgba(179,85,74,.08);
  --bg:#FAFAF9;--card-bg:#FFFFFF;--text:#202A36;--text-muted:#6B7280;
  --border:#E7E5E4;--shadow:0 2px 12px rgba(15,23,42,.05);
  --shadow-lg:0 12px 40px rgba(15,23,42,.09);--radius:14px;
  --sidebar-w:248px;
}
[data-theme="dark"]{
  --sky:#4A7A63;--emerald:#6FAE8B;--emerald-dark:#5B9977;
  --warning:#D1A25C;--warning-glow:rgba(209,162,92,.18);
  --danger:#C77A70;--danger-glow:rgba(199,122,112,.12);
  --bg:#060B12;--card-bg:#11161D;--text:#F4F4F3;--text-muted:#A8ADB4;
  --border:#232A33;--shadow:0 2px 12px rgba(0,0,0,.4);
  --shadow-lg:0 12px 40px rgba(0,0,0,.55);
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Fraunces',serif}

.as-admin-layout{display:flex;min-height:100vh}
.as-sidebar{width:var(--sidebar-w);background:var(--card-bg);border-right:1px solid var(--border);display:flex;flex-direction:column;position:sticky;top:0;height:100vh;overflow-y:auto;z-index:100;transition:transform .3s}
.as-sidebar-brand{padding:20px 18px 14px;display:flex;align-items:center;gap:9px;border-bottom:1px solid var(--border)}
.as-sidebar-logo{width:34px;height:34px;border-radius:9px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:16px;color:#fff}
.as-sidebar-brand-name{font-family:'Fraunces',serif;font-weight:800;font-size:1rem;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.as-sidebar-badge{font-size:.58rem;background:var(--warning-glow);color:var(--warning);border:1px solid var(--warning-glow);padding:2px 7px;border-radius:999px;font-weight:700;letter-spacing:.07em}
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
.as-sidebar-user-name{font-size:.83rem;font-weight:600;font-family:'Fraunces',serif}
.as-sidebar-user-role{font-size:.7rem;color:var(--text-muted)}
.as-sidebar-logout{display:flex;align-items:center;gap:7px;padding:9px 12px;border-radius:10px;text-decoration:none;color:var(--danger);font-size:.83rem;font-weight:600;transition:background .2s}
.as-sidebar-logout:hover{background:var(--danger-glow)}
.as-main{flex:1;min-width:0;overflow:auto}
/* Mobile sidebar */
.as-sidebar-toggle{display:none;position:fixed;top:14px;left:14px;z-index:300;width:38px;height:38px;border-radius:9px;background:var(--card-bg);border:1px solid var(--border);cursor:pointer;align-items:center;justify-content:center;font-size:16px}
@media(max-width:900px){
  .as-sidebar{position:fixed;left:0;top:0;height:100vh;transform:translateX(-100%);z-index:250}
  .as-sidebar.open{transform:translateX(0)}
  .as-sidebar-toggle{display:flex}
  .as-main{padding-top:0}
}

</style>

<button class="as-sidebar-toggle" id="asSidebarToggle" aria-label="Toggle sidebar"><i class="ph-bold ph-list"></i></button>

<aside class="as-sidebar" id="asSidebar" role="navigation" aria-label="Admin navigation">
  <div class="as-sidebar-brand">
    <div class="as-sidebar-logo"><i class="ph-bold ph-airplane-tilt"></i></div>
    <span class="as-sidebar-brand-name">AeroSphere</span>
    <span class="as-sidebar-badge">ADMIN</span>
  </div>
  <div class="as-sidebar-section">
    <div class="as-sidebar-label">Overview</div>
    <a href="${pageContext.request.contextPath}/adminDashboard" class="as-sidebar-link <%= _sbActive.apply("adminDashboard") %>"><span class="icon"><i class="ph-bold ph-house"></i></span>Dashboard</a>

    <div class="as-sidebar-label" style="margin-top:12px">Flights</div>
    <a href="${pageContext.request.contextPath}/adminFlights"  class="as-sidebar-link <%= _sbActive.apply("adminFlights") %>"><span class="icon"><i class="ph-bold ph-airplane-tilt"></i></span>All Flights</a>
    <a href="${pageContext.request.contextPath}/addFlight"     class="as-sidebar-link <%= _sbActive.apply("addFlight") %>"><span class="icon"><i class="ph-bold ph-plus"></i></span>Add Flight</a>

    <div class="as-sidebar-label" style="margin-top:12px">Bookings &amp; Users</div>
    <a href="${pageContext.request.contextPath}/adminBookings" class="as-sidebar-link <%= _sbActive.apply("adminBookings") %>"><span class="icon"><i class="ph-bold ph-ticket"></i></span>All Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"  class="as-sidebar-link <%= _sbActive.apply("adminRefunds") %>">
      <span class="icon"><i class="ph-bold ph-hand-coins"></i></span>Refund Requests
      <% if(_pRefs!=null&&(Integer)_pRefs>0){%><span class="badge"><%= _pRefs %></span><%}%>
    </a>
    <a href="${pageContext.request.contextPath}/adminMessages" class="as-sidebar-link <%= _sbActive.apply("adminMessages") %>">
      <span class="icon"><i class="ph-bold ph-envelope-simple"></i></span>Contact Messages
    </a>

    <div class="as-sidebar-label" style="margin-top:12px">Reports</div>
    <a href="${pageContext.request.contextPath}/reports"          class="as-sidebar-link <%= _sbActive.apply("reports").isEmpty()?_sbActive.apply("report"):"active" %>"><span class="icon"><i class="ph-bold ph-chart-bar"></i></span>All Reports</a>
    <a href="${pageContext.request.contextPath}/reportBookings"   class="as-sidebar-link <%= _sbActive.apply("reportBookings") %>"><span class="icon"><i class="ph-bold ph-clipboard-text"></i></span>Booking Report</a>
    <a href="${pageContext.request.contextPath}/reportFlights"    class="as-sidebar-link <%= _sbActive.apply("reportFlights") %>"><span class="icon"><i class="ph-bold ph-trend-up"></i></span>Flight Report</a>
    <a href="${pageContext.request.contextPath}/reportPayments"   class="as-sidebar-link <%= _sbActive.apply("reportPayments") %>"><span class="icon"><i class="ph-bold ph-coins"></i></span>Revenue Report</a>
    <a href="${pageContext.request.contextPath}/reportUsers"      class="as-sidebar-link <%= _sbActive.apply("reportUsers") %>"><span class="icon"><i class="ph-bold ph-users"></i></span>User Report</a>
    <a href="${pageContext.request.contextPath}/reportCancelled"  class="as-sidebar-link <%= _sbActive.apply("reportCancelled") %>"><span class="icon"><i class="ph-bold ph-x-circle"></i></span>Cancellation Report</a>
    <a href="${pageContext.request.contextPath}/reportPassengers" class="as-sidebar-link <%= _sbActive.apply("reportPassengers") %>"><span class="icon"><i class="ph-bold ph-suitcase"></i></span>Passenger Report</a>
  </div>
  <div class="as-sidebar-footer">
    <div class="as-sidebar-user">
      <div class="as-sidebar-user-avatar"><%= _sbInit %></div>
      <div>
        <div class="as-sidebar-user-name"><%= _sbUser!=null?_sbUser:"Admin" %></div>
        <div class="as-sidebar-user-role">Administrator</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="as-sidebar-logout"><i class="ph-bold ph-sign-out"></i> Sign Out</a>
  </div>
</aside>

<div id="asSidebarOverlay" onclick="document.getElementById('asSidebar').classList.remove('open');this.style.display='none';"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:240;backdrop-filter:blur(2px)"></div>

<script>
var _stBtn=document.getElementById('asSidebarToggle'),_sb=document.getElementById('asSidebar'),_ov=document.getElementById('asSidebarOverlay');
if(_stBtn&&_sb){_stBtn.addEventListener('click',function(){_sb.classList.toggle('open');_ov.style.display=_sb.classList.contains('open')?'block':'none';});}
</script>
