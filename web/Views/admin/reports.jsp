<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Reports – SkyConnect Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span> <small style="font-size:.6rem;color:var(--gold);font-weight:700;">ADMIN</small></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link active">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>
<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div><h1 class="page-title">📊 Reports</h1><p class="page-subtitle">Download and view system reports</p></div>
  </div>
  <div class="quick-grid animate-fadeup">
    <a href="${pageContext.request.contextPath}/reportBookings"   class="quick-card"><div class="qc-icon">🎫</div><div class="qc-title">Bookings Report</div><div class="qc-sub">All reservations</div></a>
    <a href="${pageContext.request.contextPath}/reportFlights"    class="quick-card"><div class="qc-icon">✈️</div><div class="qc-title">Flights Report</div><div class="qc-sub">All scheduled flights</div></a>
    <a href="${pageContext.request.contextPath}/reportPassengers" class="quick-card"><div class="qc-icon">👥</div><div class="qc-title">Passengers Report</div><div class="qc-sub">All passenger records</div></a>
    <a href="${pageContext.request.contextPath}/reportPayments"   class="quick-card"><div class="qc-icon">💳</div><div class="qc-title">Payments Report</div><div class="qc-sub">All transactions</div></a>
    <a href="${pageContext.request.contextPath}/reportCancelled"  class="quick-card"><div class="qc-icon">❌</div><div class="qc-title">Cancellations Report</div><div class="qc-sub">Cancelled bookings</div></a>
    <a href="${pageContext.request.contextPath}/reportUsers"      class="quick-card"><div class="qc-icon">👤</div><div class="qc-title">Users Report</div><div class="qc-sub">Registered users</div></a>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
