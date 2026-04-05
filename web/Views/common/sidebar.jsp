<%-- ═══════════════════════════════════════════════════════════════
     AeroSphere — sidebar.jsp  (Admin Navigation)
     Include with: <%@ include file="/Views/common/sidebar.jsp" %>
     Requires session attrs: userName, userRole
     Usage: place inside .as-admin-layout > div.as-sidebar
     ════════════════════════════════════════════════════════════════ --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String _sbUserName = (String) session.getAttribute("userName");
    String _sbInitial  = (_sbUserName != null && !_sbUserName.isEmpty())
                         ? String.valueOf(_sbUserName.charAt(0)).toUpperCase() : "A";
    String _sbPath     = request.getServletPath();

    /* Helper to build active class */
    java.util.function.Function<String, String> _sbActive = (keyword) ->
        _sbPath.contains(keyword) ? "active" : "";
%>

<aside class="as-sidebar" id="as-sidebar" role="navigation" aria-label="Admin sidebar">

  <%-- Brand --%>
  <div class="as-sidebar-brand">
    <div class="as-sidebar-logo" aria-hidden="true">✈</div>
    <span class="as-sidebar-brand-name">Aero<span class="accent">Sphere</span></span>
    <span class="as-sidebar-badge">ADMIN</span>
  </div>

  <%-- Navigation --%>
  <div class="as-sidebar-section">

    <div class="as-sidebar-label">Overview</div>
    <a href="${pageContext.request.contextPath}/adminDashboard"
       class="as-sidebar-link <%= _sbActive.apply("adminDashboard") %>"
       aria-label="Dashboard">
      <span class="icon">🏠</span>
      Dashboard
    </a>

    <div class="as-sidebar-label" style="margin-top:16px;">Flight Management</div>
    <a href="${pageContext.request.contextPath}/adminFlights"
       class="as-sidebar-link <%= _sbActive.apply("adminFlights") || _sbActive.apply("adminflights") %>"
       aria-label="Manage Flights">
      <span class="icon">✈️</span>
      All Flights
    </a>
    <a href="${pageContext.request.contextPath}/addFlight"
       class="as-sidebar-link <%= _sbActive.apply("addFlight") %>"
       aria-label="Add new flight">
      <span class="icon">➕</span>
      Add Flight
    </a>

    <div class="as-sidebar-label" style="margin-top:16px;">Bookings & Users</div>
    <a href="${pageContext.request.contextPath}/adminBookings"
       class="as-sidebar-link <%= _sbActive.apply("adminBookings") %>"
       aria-label="All Bookings">
      <span class="icon">🎫</span>
      All Bookings
    </a>
    <a href="${pageContext.request.contextPath}/adminRefunds"
       class="as-sidebar-link <%= _sbActive.apply("adminRefunds") %>"
       aria-label="Refund Requests">
      <span class="icon">💸</span>
      Refund Requests
      <%-- Dynamic badge for pending refunds --%>
      <%
        Object _pendingRefunds = request.getAttribute("pendingRefunds");
        if (_pendingRefunds != null && (Integer)_pendingRefunds > 0) {
      %>
        <span class="badge"><%= _pendingRefunds %></span>
      <% } %>
    </a>

    <div class="as-sidebar-label" style="margin-top:16px;">Reports & Analytics</div>
    <a href="${pageContext.request.contextPath}/reports"
       class="as-sidebar-link <%= _sbActive.apply("reports") || _sbActive.apply("report") %>"
       aria-label="Reports">
      <span class="icon">📊</span>
      All Reports
    </a>
    <a href="${pageContext.request.contextPath}/reportBookings"
       class="as-sidebar-link <%= _sbActive.apply("reportBookings") %>"
       aria-label="Booking Reports">
      <span class="icon">📋</span>
      Booking Report
    </a>
    <a href="${pageContext.request.contextPath}/reportFlights"
       class="as-sidebar-link <%= _sbActive.apply("reportFlights") %>"
       aria-label="Flight Reports">
      <span class="icon">📈</span>
      Flight Report
    </a>
    <a href="${pageContext.request.contextPath}/reportPayments"
       class="as-sidebar-link <%= _sbActive.apply("reportPayments") %>"
       aria-label="Revenue Reports">
      <span class="icon">💰</span>
      Revenue Report
    </a>
    <a href="${pageContext.request.contextPath}/reportUsers"
       class="as-sidebar-link <%= _sbActive.apply("reportUsers") %>"
       aria-label="User Reports">
      <span class="icon">👥</span>
      User Report
    </a>
    <a href="${pageContext.request.contextPath}/reportCancelled"
       class="as-sidebar-link <%= _sbActive.apply("reportCancelled") %>"
       aria-label="Cancellation Reports">
      <span class="icon">❌</span>
      Cancellation Report
    </a>
    <a href="${pageContext.request.contextPath}/reportPassengers"
       class="as-sidebar-link <%= _sbActive.apply("reportPassengers") %>"
       aria-label="Passenger Reports">
      <span class="icon">🧳</span>
      Passenger Report
    </a>

  </div>

  <%-- Footer: user info + logout --%>
  <div class="as-sidebar-footer">
    <div class="as-sidebar-user">
      <div class="as-sidebar-user-avatar" aria-hidden="true"><%= _sbInitial %></div>
      <div>
        <div class="as-sidebar-user-name"><%= _sbUserName != null ? _sbUserName : "Admin" %></div>
        <div class="as-sidebar-user-role">Administrator</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/logout"
       class="as-sidebar-logout"
       aria-label="Log out">
      <span>↩</span>
      Sign Out
    </a>
  </div>
</aside>

<%-- Sidebar overlay for mobile --%>
<div id="as-sidebar-overlay"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:1050;backdrop-filter:blur(2px);"
     onclick="document.getElementById('as-sidebar').classList.remove('open');this.style.display='none';document.getElementById('as-sidebar-toggle')&&document.getElementById('as-sidebar-toggle').classList.remove('open');"
     aria-hidden="true">
</div>
<style>
#as-sidebar-overlay.active { display: block !important; }
</style>
