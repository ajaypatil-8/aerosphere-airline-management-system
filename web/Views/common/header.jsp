<%-- ═══════════════════════════════════════════════════════════════
     AeroSphere — header.jsp  (User Navbar)
     Include with: <%@ include file="/Views/common/header.jsp" %>
     Requires session attrs: userName, userRole
     ════════════════════════════════════════════════════════════════ --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String _hUserName = (String) session.getAttribute("userName");
    String _hUserRole = (String) session.getAttribute("userRole");
    String _hInitial  = (_hUserName != null && !_hUserName.isEmpty())
                        ? String.valueOf(_hUserName.charAt(0)).toUpperCase() : "U";
    String _hFirstName = (_hUserName != null && _hUserName.contains(" "))
                        ? _hUserName.split(" ")[0] : _hUserName;

    /* Determine current page for active link highlighting */
    String _hServletPath = request.getServletPath();
    String _hQS = request.getQueryString() != null ? request.getQueryString() : "";
%>

<%-- ── Dark Mode: apply before paint ── --%>
<script>
(function(){
  var t=localStorage.getItem('aerosphere-theme');
  if(!t){t=window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light';}
  document.documentElement.setAttribute('data-theme',t);
})();
</script>

<nav class="as-navbar" role="navigation" aria-label="Main Navigation">

  <%-- Brand --%>
  <a href="${pageContext.request.contextPath}/userDashboard" class="as-brand" aria-label="AeroSphere Home">
    <div class="as-brand-logo" aria-hidden="true">✈</div>
    <span class="as-brand-name">Aero<span class="accent">Sphere</span></span>
  </a>

  <%-- Desktop Nav Links --%>
  <div class="as-nav-links" role="menubar">
    <% if (_hUserName != null) { %>
      <a href="${pageContext.request.contextPath}/userDashboard"
         class="as-nav-link <%= _hServletPath.contains("userDashboard") ? "active" : "" %>"
         role="menuitem">
        🏠 <span>Dashboard</span>
      </a>
      <a href="${pageContext.request.contextPath}/searchFlights"
         class="as-nav-link <%= (_hServletPath.contains("searchFlights") || _hServletPath.contains("search")) ? "active" : "" %>"
         role="menuitem">
        🔍 <span>Search Flights</span>
      </a>
      <a href="${pageContext.request.contextPath}/allFlights"
         class="as-nav-link <%= _hServletPath.contains("allFlights") ? "active" : "" %>"
         role="menuitem">
        ✈️ <span>All Flights</span>
      </a>
      <a href="${pageContext.request.contextPath}/userBookings"
         class="as-nav-link <%= _hServletPath.contains("userBookings") ? "active" : "" %>"
         role="menuitem">
        🎫 <span>My Bookings</span>
      </a>
      <a href="${pageContext.request.contextPath}/userRefundHistory"
         class="as-nav-link <%= _hServletPath.contains("userRefundHistory") ? "active" : "" %>"
         role="menuitem">
        💸 <span>Refunds</span>
      </a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/index.jsp" class="as-nav-link" role="menuitem">
        Home
      </a>
      <a href="#features" class="as-nav-link" role="menuitem">Features</a>
      <a href="#about" class="as-nav-link" role="menuitem">About</a>
    <% } %>
  </div>

  <%-- Right controls --%>
  <div class="as-nav-right">

    <%-- Dark mode toggle --%>
    <button class="as-theme-toggle as-dark-toggle"
            aria-label="Toggle dark mode"
            title="Toggle dark/light mode">
      <span class="theme-icon">🌙</span>
    </button>

    <% if (_hUserName != null) { %>
      <%-- User pill --%>
      <a href="${pageContext.request.contextPath}/profile" class="as-user-pill" aria-label="User profile">
        <div class="as-user-avatar" aria-hidden="true"><%= _hInitial %></div>
        <span><%= _hFirstName %></span>
        <span style="color: var(--text-muted); font-size: 0.75rem;">▾</span>
      </a>
      <a href="${pageContext.request.contextPath}/logout"
         class="as-btn as-btn-ghost as-btn-sm"
         title="Sign out"
         aria-label="Log out">
        ↩ Logout
      </a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/login"
         class="as-btn as-btn-ghost as-btn-sm">
        Sign In
      </a>
      <a href="${pageContext.request.contextPath}/register"
         class="as-btn as-btn-primary as-btn-sm">
        Register
      </a>
    <% } %>

    <%-- Mobile hamburger --%>
    <button class="as-hamburger"
            id="as-hamburger"
            aria-label="Open mobile menu"
            aria-expanded="false"
            aria-controls="as-mobile-nav">
      <span></span><span></span><span></span>
    </button>
  </div>
</nav>

<%-- Mobile Nav Drawer --%>
<div class="as-mobile-nav" id="as-mobile-nav" role="menu" aria-label="Mobile navigation">
  <% if (_hUserName != null) { %>
    <a href="${pageContext.request.contextPath}/userDashboard" class="as-nav-link" role="menuitem">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"  class="as-nav-link" role="menuitem">🔍 Search Flights</a>
    <a href="${pageContext.request.contextPath}/allFlights"     class="as-nav-link" role="menuitem">✈️ All Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"   class="as-nav-link" role="menuitem">🎫 My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="as-nav-link" role="menuitem">💸 Refunds</a>
    <a href="${pageContext.request.contextPath}/profile"        class="as-nav-link" role="menuitem">👤 Profile</a>
    <div class="as-divider" style="margin: 6px 0;"></div>
    <a href="${pageContext.request.contextPath}/logout" class="as-nav-link" style="color: var(--danger);" role="menuitem">↩ Logout</a>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/login"    class="as-nav-link" role="menuitem">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="as-nav-link" role="menuitem">Register</a>
  <% } %>
</div>
