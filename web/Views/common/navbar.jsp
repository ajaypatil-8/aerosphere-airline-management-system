<%--
    AeroSphere — navbar.jsp  (Premium UI v4 — monochrome + racing green)
    Usage: <%@ include file="/Views/common/navbar.jsp" %>
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String _nvUser  = (String) session.getAttribute("userName");
    String _nvRole  = (String) session.getAttribute("userRole");
    String _nvInit  = (_nvUser != null && !_nvUser.isEmpty())
                      ? String.valueOf(_nvUser.charAt(0)).toUpperCase() : "U";
    String _nvFirst = (_nvUser != null && _nvUser.contains(" "))
                      ? _nvUser.split(" ")[0] : _nvUser;
    String _nvPath  = request.getServletPath();
%>
<script>
(function(){
  var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');
  document.documentElement.setAttribute('data-theme',t);
})();
</script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">

<nav class="navbar" role="navigation" aria-label="Main navigation">

  <%-- Brand --%>
  <a href="${pageContext.request.contextPath}/<%= "ADMIN".equals(_nvRole) ? "adminDashboard" : (_nvUser != null ? "userDashboard" : "") %>"
     class="nav-brand" aria-label="AeroSphere Home">
    <div class="brand-icon" aria-hidden="true"><i class="ph-bold ph-airplane-tilt"></i></div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>

  <%-- Desktop Nav Links --%>
  <div class="nav-links" role="menubar">
    <% if (_nvUser != null && !"ADMIN".equals(_nvRole)) { %>
      <a href="${pageContext.request.contextPath}/userDashboard"
         class="nav-link <%= _nvPath.contains("userDashboard") ? "active" : "" %>"><i class="ph-bold ph-house"></i> Dashboard</a>
      <a href="${pageContext.request.contextPath}/searchFlights"
         class="nav-link <%= _nvPath.contains("searchFlights") || _nvPath.contains("search") ? "active" : "" %>"><i class="ph-bold ph-magnifying-glass"></i> Search</a>
      <a href="${pageContext.request.contextPath}/allFlights"
         class="nav-link <%= _nvPath.contains("allFlights") ? "active" : "" %>"><i class="ph-bold ph-airplane-takeoff"></i> All Flights</a>
      <a href="${pageContext.request.contextPath}/userBookings"
         class="nav-link <%= _nvPath.contains("userBookings") ? "active" : "" %>"><i class="ph-bold ph-ticket"></i> Bookings</a>
      <a href="${pageContext.request.contextPath}/userRefundHistory"
         class="nav-link <%= _nvPath.contains("Refund") ? "active" : "" %>"><i class="ph-bold ph-hand-coins"></i> Refunds</a>
    <% } else if (_nvUser != null && "ADMIN".equals(_nvRole)) { %>
      <a href="${pageContext.request.contextPath}/adminDashboard"
         class="nav-link <%= _nvPath.contains("adminDashboard") ? "active" : "" %>"><i class="ph-bold ph-house"></i> Dashboard</a>
      <a href="${pageContext.request.contextPath}/adminFlights"
         class="nav-link <%= _nvPath.contains("adminFlights") ? "active" : "" %>"><i class="ph-bold ph-airplane-tilt"></i> Flights</a>
      <a href="${pageContext.request.contextPath}/adminBookings"
         class="nav-link <%= _nvPath.contains("adminBookings") ? "active" : "" %>"><i class="ph-bold ph-ticket"></i> Bookings</a>
      <a href="${pageContext.request.contextPath}/reports"
         class="nav-link <%= _nvPath.contains("report") ? "active" : "" %>"><i class="ph-bold ph-chart-bar"></i> Reports</a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/" class="nav-link <%= "/".equals(_nvPath) || _nvPath.contains("index") ? "active" : "" %>">Home</a>
      <a href="${pageContext.request.contextPath}/#features" class="nav-link">Features</a>
      <a href="${pageContext.request.contextPath}/faqs" class="nav-link <%= _nvPath.contains("faqs") ? "active" : "" %>">FAQ</a>
      <a href="${pageContext.request.contextPath}/contact" class="nav-link <%= _nvPath.contains("contact") ? "active" : "" %>">Contact</a>
    <% } %>
  </div>

  <%-- Right Controls --%>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle dark mode"><i class="ph-bold ph-moon"></i></button>

    <% if (_nvUser != null) { %>
      <a href="${pageContext.request.contextPath}/profile" class="user-pill" aria-label="Profile">
        <div class="user-avatar"><%= _nvInit %></div>
        <span><%= _nvFirst %></span>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger" title="Sign out"><i class="ph-bold ph-sign-out"></i> Logout</a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/login"    class="btn btn-ghost btn-sm">Sign In</a>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Get Started</a>
    <% } %>

    <button class="hamburger" id="as-hamburger" aria-label="Open menu" aria-expanded="false">
      <span></span><span></span><span></span>
    </button>
  </div>
</nav>

<%-- Mobile Drawer --%>
<div class="mobile-nav" id="as-mobile-nav" role="menu">
  <% if (_nvUser != null && !"ADMIN".equals(_nvRole)) { %>
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link"><i class="ph-bold ph-house"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link"><i class="ph-bold ph-magnifying-glass"></i> Search Flights</a>
    <a href="${pageContext.request.contextPath}/allFlights"       class="nav-link"><i class="ph-bold ph-airplane-takeoff"></i> All Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link"><i class="ph-bold ph-ticket"></i> My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link"><i class="ph-bold ph-hand-coins"></i> Refund History</a>
    <a href="${pageContext.request.contextPath}/profile"           class="nav-link"><i class="ph-bold ph-user-circle"></i> Profile</a>
    <hr style="border:none;border-top:1px solid var(--border);margin:6px 0;">
    <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger"><i class="ph-bold ph-sign-out"></i> Logout</a>
  <% } else if (_nvUser != null) { %>
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link"><i class="ph-bold ph-house"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link"><i class="ph-bold ph-airplane-tilt"></i> Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link"><i class="ph-bold ph-ticket"></i> Bookings</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link"><i class="ph-bold ph-chart-bar"></i> Reports</a>
    <hr style="border:none;border-top:1px solid var(--border);margin:6px 0;">
    <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger"><i class="ph-bold ph-sign-out"></i> Logout</a>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
    <a href="${pageContext.request.contextPath}/#features" class="nav-link">Features</a>
    <a href="${pageContext.request.contextPath}/faqs" class="nav-link">FAQ</a>
    <a href="${pageContext.request.contextPath}/contact" class="nav-link">Contact</a>
    <hr style="border:none;border-top:1px solid var(--border);margin:6px 0;">
    <a href="${pageContext.request.contextPath}/login"    class="nav-link">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="nav-link">Get Started</a>
  <% } %>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js" defer></script>
