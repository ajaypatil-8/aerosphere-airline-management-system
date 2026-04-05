<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund History – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link active">Refunds</a>
    <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">Logout</a>
  </div>
</nav>
<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div><h1 class="page-title">💸 Refund History</h1><p class="page-subtitle"><%= refunds != null ? refunds.size() : 0 %> refund request(s)</p></div>
  </div>
  <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>
  <div class="table-wrap animate-fadeup">
    <% if (refunds == null || refunds.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">💸</div><h3>No refund requests</h3><p>When you cancel a paid booking (24h+ before departure), a refund request will appear here.</p></div>
    <% } else { %>
    <table class="sc-table">
      <thead><tr><th>#</th><th>Refund ID</th><th>Flight</th><th>Route</th><th>Amount</th><th>Reason</th><th>Status</th><th>Approved</th></tr></thead>
      <tbody>
      <% int ri=0; for(Map<String,Object> r : refunds) { ri++;
         String status = r.get("status") != null ? r.get("status").toString() : "PENDING";
         String bc = "APPROVED".equals(status)?"badge-paid":"REJECTED".equals(status)?"badge-cancelled":"badge-pending";
      %>
      <tr>
        <td class="text-dim"><%= ri %></td>
        <td style="color:var(--sky-glow);font-weight:700;">#<%= r.get("id") %></td>
        <td><strong><%= r.get("flight") %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= r.get("source") %></span><span class="route-arrow">→</span><span class="route-city"><%= r.get("destination") %></span></div></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f",(Double)r.get("amount")) %></td>
        <td style="font-size:.82rem;color:var(--muted);"><%= r.get("reason") != null ? r.get("reason") : "—" %></td>
        <td><span class="badge <%= bc %>"><%= status %></span></td>
        <td style="font-size:.8rem;color:var(--muted);"><%= r.get("approvedAt") != null ? r.get("approvedAt").toString().substring(0,10) : "Pending" %></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
