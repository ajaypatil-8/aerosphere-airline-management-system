<%--
    AeroSphere — navbar.jsp  (Premium UI v3)
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
  var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');
  document.documentElement.setAttribute('data-theme',t);
})();
</script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">

<nav class="navbar" role="navigation" aria-label="Main navigation">

  <%-- Brand --%>
  <a href="${pageContext.request.contextPath}/<%= "ADMIN".equals(_nvRole) ? "adminDashboard" : "userDashboard" %>"
     class="nav-brand" aria-label="AeroSphere Home">
    <div class="brand-icon" aria-hidden="true">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>

  <%-- Desktop Nav Links --%>
  <div class="nav-links" role="menubar">
    <% if (_nvUser != null && !"ADMIN".equals(_nvRole)) { %>
      <a href="${pageContext.request.contextPath}/userDashboard"
         class="nav-link <%= _nvPath.contains("userDashboard") ? "active" : "" %>">🏠 Dashboard</a>
      <a href="${pageContext.request.contextPath}/searchFlights"
         class="nav-link <%= _nvPath.contains("searchFlights") || _nvPath.contains("search") ? "active" : "" %>">🔍 Search</a>
      <a href="${pageContext.request.contextPath}/userBookings"
         class="nav-link <%= _nvPath.contains("userBookings") ? "active" : "" %>">🎫 Bookings</a>
      <a href="${pageContext.request.contextPath}/userRefundHistory"
         class="nav-link <%= _nvPath.contains("Refund") ? "active" : "" %>">💸 Refunds</a>
    <% } else if (_nvUser != null && "ADMIN".equals(_nvRole)) { %>
      <a href="${pageContext.request.contextPath}/adminDashboard"
         class="nav-link <%= _nvPath.contains("adminDashboard") ? "active" : "" %>">🏠 Dashboard</a>
      <a href="${pageContext.request.contextPath}/adminFlights"
         class="nav-link <%= _nvPath.contains("adminFlights") ? "active" : "" %>">✈️ Flights</a>
      <a href="${pageContext.request.contextPath}/adminBookings"
         class="nav-link <%= _nvPath.contains("adminBookings") ? "active" : "" %>">🎫 Bookings</a>
      <a href="${pageContext.request.contextPath}/reports"
         class="nav-link <%= _nvPath.contains("report") ? "active" : "" %>">📊 Reports</a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
      <a href="#features" class="nav-link">Features</a>
    <% } %>
  </div>

  <%-- Right Controls --%>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle dark mode">🌙</button>

    <% if (_nvUser != null) { %>
      <a href="${pageContext.request.contextPath}/profile" class="user-pill" aria-label="Profile">
        <div class="user-avatar"><%= _nvInit %></div>
        <span><%= _nvFirst %></span>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger" title="Sign out">↩ Logout</a>
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
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">🔍 Search Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refund History</a>
    <a href="${pageContext.request.contextPath}/profile"           class="nav-link">👤 Profile</a>
    <hr style="border:none;border-top:1px solid var(--border);margin:6px 0;">
    <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger">↩ Logout</a>
  <% } else if (_nvUser != null) { %>
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">✈️ Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">🎫 Bookings</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">📊 Reports</a>
    <hr style="border:none;border-top:1px solid var(--border);margin:6px 0;">
    <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger">↩ Logout</a>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/login"    class="nav-link">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="nav-link">Get Started</a>
  <% } %>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js" defer></script>
