<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund Requests – SkyConnect Admin</title>
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
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link active">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">💸 Refund Requests</h1>
      <p class="page-subtitle"><%= refunds != null ? refunds.size() : 0 %> refund requests total</p>
    </div>
  </div>
  <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

  <div class="table-wrap animate-fadeup">
    <% if (refunds == null || refunds.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">💸</div><h3>No refund requests</h3><p>Refund requests will appear here when users cancel paid bookings.</p></div>
    <% } else { %>
    <table class="sc-table">
      <thead><tr><th>#</th><th>Refund ID</th><th>Passenger</th><th>Flight</th><th>Amount</th><th>Reason</th><th>Status</th><th>Approved At</th><th>Actions</th></tr></thead>
      <tbody>
      <% int ri = 0; for (Map<String,Object> r : refunds) { ri++;
         String status = r.get("status") != null ? r.get("status").toString() : "PENDING";
         String bc = status.equals("APPROVED") ? "badge-paid" : status.equals("REJECTED") ? "badge-cancelled" : "badge-pending";
      %>
      <tr>
        <td class="text-dim"><%= ri %></td>
        <td style="color:var(--sky-glow);font-weight:700;">#<%= r.get("id") %></td>
        <td style="font-weight:500;"><%= r.get("user") %></td>
        <td><strong><%= r.get("flight") %></strong></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f", (Double)r.get("amount")) %></td>
        <td style="font-size:.82rem;color:var(--muted);max-width:160px;"><%= r.get("reason") != null ? r.get("reason") : "—" %></td>
        <td><span class="badge <%= bc %>"><%= status %></span></td>
        <td style="font-size:.8rem;color:var(--muted);"><%= r.get("approvedAt") != null ? r.get("approvedAt").toString().substring(0,10) : "—" %></td>
        <td>
          <% if ("PENDING".equals(status)) { %>
          <div style="display:flex;gap:8px;">
            <form action="${pageContext.request.contextPath}/approveRefund" method="post" style="margin:0;">
              <input type="hidden" name="refundId" value="<%= r.get("id") %>">
              <input type="hidden" name="action" value="APPROVE">
              <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Approve this refund?')">✅ Approve</button>
            </form>
            <form action="${pageContext.request.contextPath}/approveRefund" method="post" style="margin:0;">
              <input type="hidden" name="refundId" value="<%= r.get("id") %>">
              <input type="hidden" name="action" value="REJECT">
              <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject this refund?')">❌ Reject</button>
            </form>
          </div>
          <% } else { %><span class="text-dim" style="font-size:.8rem;">Processed</span><% } %>
        </td>
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
