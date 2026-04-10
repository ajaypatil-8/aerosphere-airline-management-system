<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund History – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.active{color:var(--primary);background:var(--primary-glow)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.page-wrapper{max-width:1100px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert{color:#FCA5A5}
.table-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);animation:fadeUp .5s ease both .05s}
.table-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse;min-width:700px}
thead th{padding:12px 16px;text-align:left;font-size:.73rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
tbody td{padding:12px 16px;font-size:.87rem;border-bottom:1px solid var(--border);vertical-align:middle}
tbody tr:last-child td{border-bottom:none}
tbody tr:hover{background:var(--bg)}
.badge{display:inline-flex;align-items:center;padding:3px 10px;border-radius:99px;font-size:.74rem;font-weight:700}
.badge-approved{background:rgba(16,185,129,.12);color:var(--primary);border:1px solid var(--primary)}
.badge-pending{background:rgba(245,158,11,.1);color:#D97706;border:1px solid rgba(245,158,11,.3)}
[data-theme="dark"] .badge-pending{color:#FCD34D}
.badge-rejected{background:rgba(239,68,68,.1);color:#DC2626;border:1px solid rgba(239,68,68,.2)}
[data-theme="dark"] .badge-rejected{color:#FCA5A5}
.route-cell{display:flex;align-items:center;gap:5px}
.route-arrow{color:var(--primary)}
.amount{color:var(--primary);font-weight:700}
.empty-state{padding:60px 20px;text-align:center}
.empty-icon{font-size:3rem;margin-bottom:14px;opacity:.4}
.empty-state h3{font-size:1.1rem;font-weight:700;margin-bottom:8px}
.empty-state p{color:var(--text-muted);font-size:.88rem}
</style>
</head>
<body>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link ">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link ">🔍 Search</a>
        <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link ">✈️ All Flights</a>
        <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link ">🎫 My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link active">💸 Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"           class="nav-link ">👤 Profile</a>
        <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">↩ Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>
<div class="page-wrapper">
    <div class="page-header">
        <div>
            <div class="page-title">💸 Refund History</div>
            <div class="page-subtitle"><%= refunds != null ? refunds.size() : 0 %> refund request(s)</div>
        </div>
    </div>
    <% if (error != null) { %><div class="alert">⚠ <%= error %></div><% } %>
    <div class="table-card">
        <% if (refunds == null || refunds.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">💸</div>
                <h3>No refund requests</h3>
                <p>When you cancel a paid booking (24h+ before departure), a refund request will appear here.</p>
            </div>
        <% } else { %>
        <div class="table-wrap">
        <table>
            <thead><tr><th>#</th><th>Refund ID</th><th>Flight</th><th>Route</th><th>Amount</th><th>Reason</th><th>Status</th><th>Approved</th></tr></thead>
            <tbody>
            <% int ri=0; for(Map<String,Object> r : refunds) { ri++;
               String status = r.get("status") != null ? r.get("status").toString() : "PENDING";
               String bc = "APPROVED".equals(status)?"badge-approved":"REJECTED".equals(status)?"badge-rejected":"badge-pending";
            %>
            <tr>
                <td style="color:var(--text-muted);font-size:.8rem"><%= ri %></td>
                <td style="color:var(--primary);font-weight:700">#<%= r.get("id") %></td>
                <td><strong><%= r.get("flight") %></strong></td>
                <td><div class="route-cell"><span><%= r.get("source") %></span><span class="route-arrow">→</span><span><%= r.get("destination") %></span></div></td>
                <td class="amount">₹<%= String.format("%,.0f",(Double)r.get("amount")) %></td>
                <td style="font-size:.82rem;color:var(--text-muted)"><%= r.get("reason") != null ? r.get("reason") : "—" %></td>
                <td><span class="badge <%= bc %>"><%= status %></span></td>
                <td style="font-size:.8rem;color:var(--text-muted)"><%= r.get("approvedAt") != null ? r.get("approvedAt").toString().substring(0,10) : "Pending" %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>
        <% } %>
    </div>
</div>
<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
</script>
</body></html>
