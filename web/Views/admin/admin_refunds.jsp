<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String error = (String) request.getAttribute("error");
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund Requests – AeroSphere Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}
.brand-name span{color:var(--primary)}
.admin-badge{font-size:.6rem;background:rgba(245,158,11,.15);color:#D97706;border:1px solid rgba(245,158,11,.3);padding:2px 7px;border-radius:4px;font-weight:700;letter-spacing:.05em;margin-left:4px;vertical-align:middle}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover,.nav-link.active{color:var(--primary);background:var(--primary-glow)}
.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.theme-toggle:hover{border-color:var(--primary)}
.page-wrapper{max-width:1200px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.table-wrap{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.sc-table{width:100%;border-collapse:collapse}
.sc-table th{padding:12px 16px;text-align:left;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
.sc-table td{padding:13px 16px;font-size:.86rem;border-bottom:1px solid var(--border);vertical-align:middle}
.sc-table tr:last-child td{border-bottom:none}
.sc-table tbody tr:hover{background:var(--primary-glow)}
.text-dim{color:var(--text-muted)}
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.73rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.badge-paid{background:rgba(16,185,129,.12);color:#059669}
[data-theme="dark"] .badge-paid{color:#34D399}
.badge-cancelled{background:rgba(239,68,68,.1);color:#DC2626}
[data-theme="dark"] .badge-cancelled{color:#FCA5A5}
.badge-pending{background:rgba(245,158,11,.12);color:#D97706}
.action-btns{display:flex;gap:8px;align-items:center}
.btn-approve{background:rgba(16,185,129,.12);border:1px solid rgba(16,185,129,.3);color:#059669;padding:5px 12px;border-radius:7px;font-size:.78rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s}
.btn-approve:hover{background:rgba(16,185,129,.22)}
[data-theme="dark"] .btn-approve{color:#34D399}
.btn-reject{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626;padding:5px 12px;border-radius:7px;font-size:.78rem;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s}
.btn-reject:hover{background:rgba(239,68,68,.15)}
[data-theme="dark"] .btn-reject{color:#FCA5A5}
.empty-state{text-align:center;padding:56px 24px;color:var(--text-muted)}
.empty-icon{font-size:2.5rem;margin-bottom:12px}
.empty-state h3{font-weight:700;color:var(--text);margin-bottom:6px}
@keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .5s ease forwards}
@media(max-width:600px){.page-wrapper{padding:20px 14px}.navbar{padding:10px 16px}.nav-links .nav-link:not(.btn-danger){display:none}}
</style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span><span class="admin-badge">ADMIN</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link active">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
    <button class="theme-toggle" id="themeToggle" title="Toggle theme">🌙</button>
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
      <div class="empty-state"><div class="empty-icon">💸</div><h3>No refund requests</h3><p>Refund requests appear here when users cancel paid bookings.</p></div>
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
        <td style="color:var(--primary);font-weight:700;">#<%= r.get("id") %></td>
        <td style="font-weight:500;"><%= r.get("user") %></td>
        <td><strong><%= r.get("flight") %></strong></td>
        <td style="color:var(--primary);font-weight:700;">₹<%= String.format("%,.0f", (Double)r.get("amount")) %></td>
        <td style="font-size:.82rem;color:var(--text-muted);max-width:160px;"><%= r.get("reason") != null ? r.get("reason") : "—" %></td>
        <td><span class="badge <%= bc %>"><%= status %></span></td>
        <td style="font-size:.8rem;color:var(--text-muted);"><%= r.get("approvedAt") != null ? r.get("approvedAt").toString().substring(0,10) : "—" %></td>
        <td>
          <% if ("PENDING".equals(status)) { %>
          <div class="action-btns">
            <form action="${pageContext.request.contextPath}/approveRefund" method="post" style="margin:0;">
              <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
              <input type="hidden" name="refundId" value="<%= r.get("id") %>">
              <input type="hidden" name="action" value="APPROVE">
              <button type="submit" class="btn-approve" onclick="return confirm('Approve this refund?')">✅ Approve</button>
            </form>
            <form action="${pageContext.request.contextPath}/approveRefund" method="post" style="margin:0;">
              <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
              <input type="hidden" name="refundId" value="<%= r.get("id") %>">
              <input type="hidden" name="action" value="REJECT">
              <button type="submit" class="btn-reject" onclick="return confirm('Reject this refund?')">❌ Reject</button>
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
(function(){const root=document.documentElement;const saved=localStorage.getItem('theme')||'light';root.setAttribute('data-theme',saved);document.getElementById('themeToggle').textContent=saved==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const cur=document.documentElement.getAttribute('data-theme');const next=cur==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',next);localStorage.setItem('theme',next);this.textContent=next==='dark'?'☀️':'🌙';});
</script>
</body>
</html>
