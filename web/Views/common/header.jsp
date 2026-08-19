<%-- AeroSphere header.jsp — User Navbar include (Premium UI v4)
     Include: <%@ include file="/Views/common/header.jsp" %>
     Requires session: userName, userRole --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String _hUser  = (String) session.getAttribute("userName");
  String _hRole  = (String) session.getAttribute("userRole");
  String _hInit  = (_hUser!=null&&!_hUser.isEmpty()) ? String.valueOf(_hUser.charAt(0)).toUpperCase() : "U";
  String _hFirst = (_hUser!=null&&_hUser.contains(" ")) ? _hUser.split(" ")[0] : _hUser;
  String _hPath  = request.getServletPath();
%>
<script>
(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();
</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>

:root{
  --sky:#2E4A3D;--emerald:#5B8A6E;--emerald-dark:#3E6350;--danger:#B3554A;
  --grad:var(--sky);
  --sky-glow:rgba(46,74,61,.16);--em-glow:rgba(91,138,110,.14);
  --bg:#FAFAF9;--card-bg:#FFFFFF;--text:#202A36;--text-muted:#6B7280;
  --border:#E7E5E4;--shadow:0 2px 12px rgba(15,23,42,.05);
  --shadow-lg:0 12px 40px rgba(15,23,42,.09);--radius:14px;
  --sidebar-w:248px;
}
[data-theme="dark"]{
  --sky:#4A7A63;--emerald:#6FAE8B;--emerald-dark:#5B9977;--danger:#C77A70;
  --bg:#060B12;--card-bg:#11161D;--text:#F4F4F3;--text-muted:#A8ADB4;
  --border:#232A33;--shadow:0 2px 12px rgba(0,0,0,.4);
  --shadow-lg:0 12px 40px rgba(0,0,0,.55);
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Fraunces',serif}

.as-navbar{position:sticky;top:0;z-index:200;display:flex;align-items:center;justify-content:space-between;padding:0 32px;height:62px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.as-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.as-brand-logo{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:17px;color:#fff;box-shadow:0 3px 12px var(--sky-glow)}
.as-brand-name{font-family:'Fraunces',serif;font-weight:500;font-size:1.1rem;letter-spacing:-.01em;color:var(--text)}
.as-nav-links{display:flex;align-items:center;gap:2px}
.as-nav-link{display:inline-flex;align-items:center;gap:6px;text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:9px;font-size:.85rem;font-weight:500;transition:all .2s}
.as-nav-link:hover,.as-nav-link.active{color:var(--sky);background:var(--sky-glow)}
.as-nav-link.danger{color:var(--danger)}
.as-nav-right{display:flex;align-items:center;gap:8px}
.as-theme-toggle{width:33px;height:33px;border:1px solid var(--border);border-radius:999px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;color:var(--text)}
.as-theme-toggle:hover{border-color:var(--sky)}
.as-user-pill{display:flex;align-items:center;gap:7px;padding:5px 12px 5px 5px;border:1px solid var(--border);border-radius:99px;text-decoration:none;color:var(--text);font-size:.82rem;font-weight:600;transition:all .2s}
.as-user-pill:hover{border-color:var(--sky)}
.as-user-avatar{width:26px;height:26px;border-radius:50%;background:var(--grad);color:#fff;display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:600}
.as-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:999px;font-size:.83rem;font-weight:500;text-decoration:none;border:1.5px solid transparent;cursor:pointer;transition:all .2s;font-family:'Inter',sans-serif}
.as-btn-ghost{border-color:var(--border);color:var(--text-muted);background:transparent}.as-btn-ghost:hover{border-color:var(--sky);color:var(--sky)}
.as-hamburger{display:none;flex-direction:column;gap:5px;background:none;border:none;cursor:pointer;padding:6px}
.as-hamburger span{display:block;width:22px;height:2px;background:var(--text-muted);border-radius:2px;transition:all .3s}
.as-mobile-nav{display:none;position:fixed;top:62px;left:0;right:0;background:var(--card-bg);border-bottom:1px solid var(--border);padding:12px 16px;z-index:199;flex-direction:column;gap:2px;box-shadow:var(--shadow-lg)}
.as-mobile-nav.open{display:flex}
@media(max-width:768px){.as-nav-links{display:none}.as-hamburger{display:flex}}

</style>

<nav class="as-navbar" role="navigation">
  <a href="${pageContext.request.contextPath}/<%= "ADMIN".equals(_hRole) ? "adminDashboard" : (_hUser != null ? "userDashboard" : "") %>" class="as-brand" aria-label="AeroSphere Home">
    <div class="as-brand-logo"><i class="ph-bold ph-airplane-tilt"></i></div>
    <span class="as-brand-name">AeroSphere</span>
  </a>
  <div class="as-nav-links">
    <% if(_hUser!=null){ %>
      <a href="${pageContext.request.contextPath}/userDashboard"     class="as-nav-link <%= _hPath.contains("userDashboard")?"active":"" %>"><i class="ph-bold ph-house"></i> Dashboard</a>
      <a href="${pageContext.request.contextPath}/searchFlights"     class="as-nav-link <%= _hPath.contains("search")?"active":"" %>"><i class="ph-bold ph-magnifying-glass"></i> Search</a>
      <a href="${pageContext.request.contextPath}/allFlights"        class="as-nav-link <%= _hPath.contains("allFlights")?"active":"" %>"><i class="ph-bold ph-airplane-takeoff"></i> Flights</a>
      <a href="${pageContext.request.contextPath}/userBookings"      class="as-nav-link <%= _hPath.contains("userBookings")?"active":"" %>"><i class="ph-bold ph-ticket"></i> My Bookings</a>
      <a href="${pageContext.request.contextPath}/userRefundHistory" class="as-nav-link <%= _hPath.contains("Refund")?"active":"" %>"><i class="ph-bold ph-hand-coins"></i> Refunds</a>
    <% }else{ %>
      <a href="${pageContext.request.contextPath}/" class="as-nav-link">Home</a>
      <a href="${pageContext.request.contextPath}/#features" class="as-nav-link">Features</a>
      <a href="${pageContext.request.contextPath}/faqs" class="as-nav-link">FAQ</a>
      <a href="${pageContext.request.contextPath}/contact" class="as-nav-link">Contact</a>
    <% } %>
  </div>
  <div class="as-nav-right">
    <button class="as-theme-toggle" id="asThemeToggle" aria-label="Toggle theme"><i class="ph-bold ph-moon"></i></button>
    <% if(_hUser!=null){ %>
      <a href="${pageContext.request.contextPath}/profile" class="as-user-pill">
        <div class="as-user-avatar"><%= _hInit %></div>
        <span><%= _hFirst %></span>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="as-btn as-btn-ghost"><i class="ph-bold ph-sign-out"></i> Logout</a>
    <% }else{ %>
      <a href="${pageContext.request.contextPath}/login"    class="as-btn as-btn-ghost">Sign In</a>
      <a href="${pageContext.request.contextPath}/register" class="as-btn" style="background:var(--grad);color:#fff;border-color:transparent">Register</a>
    <% } %>
    <button class="as-hamburger" id="asHamburger" aria-label="Open menu"><span></span><span></span><span></span></button>
  </div>
</nav>
<div class="as-mobile-nav" id="asMobileNav">
  <% if(_hUser!=null){ %>
    <a href="${pageContext.request.contextPath}/userDashboard"     class="as-nav-link"><i class="ph-bold ph-house"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="as-nav-link"><i class="ph-bold ph-magnifying-glass"></i> Search Flights</a>
    <a href="${pageContext.request.contextPath}/allFlights"        class="as-nav-link"><i class="ph-bold ph-airplane-takeoff"></i> All Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="as-nav-link"><i class="ph-bold ph-ticket"></i> My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="as-nav-link"><i class="ph-bold ph-hand-coins"></i> Refunds</a>
    <a href="${pageContext.request.contextPath}/profile"           class="as-nav-link"><i class="ph-bold ph-user-circle"></i> Profile</a>
    <a href="${pageContext.request.contextPath}/logout"            class="as-nav-link danger"><i class="ph-bold ph-sign-out"></i> Logout</a>
  <% }else{ %>
    <a href="${pageContext.request.contextPath}/" class="as-nav-link">Home</a>
    <a href="${pageContext.request.contextPath}/faqs" class="as-nav-link">FAQ</a>
    <a href="${pageContext.request.contextPath}/contact" class="as-nav-link">Contact</a>
    <a href="${pageContext.request.contextPath}/login"    class="as-nav-link">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="as-nav-link">Register</a>
  <% } %>
</div>
<script>

(function(){
  var btn=document.getElementById('asThemeToggle');
  if(!btn)return;
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.innerHTML=t==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();

var ham=document.getElementById('asHamburger'),mob=document.getElementById('asMobileNav');
if(ham&&mob){ham.addEventListener('click',function(){mob.classList.toggle('open');});}
</script>
