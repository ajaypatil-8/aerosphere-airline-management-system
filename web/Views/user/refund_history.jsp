<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String error   = (String) request.getAttribute("error");
    String initials = userName.substring(0,1).toUpperCase();
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund History – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--sky:#0EA5E9;--sky-dark:#0284C7;--sky-glow:rgba(14,165,233,.18);--em:#10B981;--em-dark:#059669;--em-glow:rgba(16,185,129,.18);--grad:linear-gradient(135deg,var(--sky),var(--em));--bg:#F0F9FF;--s0:#FFFFFF;--s1:#F8FAFC;--s2:#F0F9FF;--text:#0F172A;--muted:#64748B;--border:#E2E8F0;--sh:0 1px 3px rgba(0,0,0,.06),0 4px 16px rgba(0,0,0,.04);--sh-lg:0 8px 32px rgba(0,0,0,.08);--r:14px}
[data-theme="dark"]{--bg:#060A12;--s0:#0D1117;--s1:#111827;--s2:#1A2232;--text:#F1F5F9;--muted:#94A3B8;--border:#1E293B;--sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);--sh-lg:0 8px 32px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
.navbar{position:sticky;top:0;z-index:200;display:flex;align-items:center;padding:0 32px;height:62px;background:rgba(255,255,255,.88);backdrop-filter:blur(14px);border-bottom:1px solid var(--border);box-shadow:var(--sh);gap:6px}
[data-theme="dark"] .navbar{background:rgba(13,17,23,.88)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text);margin-right:10px}
.brand-icon{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 3px 10px var(--sky-glow)}
.brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1.05rem;letter-spacing:-.4px}
.brand-name span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.nav-links{display:flex;align-items:center;gap:2px;flex:1}
.nav-link{text-decoration:none;color:var(--muted);padding:6px 11px;border-radius:8px;font-size:.83rem;font-weight:500;transition:all .18s}
.nav-link:hover{color:var(--text);background:var(--s2)}.nav-link.active{color:var(--sky);background:var(--sky-glow);font-weight:600}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.user-pill{display:flex;align-items:center;gap:7px;text-decoration:none;color:var(--text);padding:5px 10px 5px 5px;border:1px solid var(--border);border-radius:99px;font-size:.82rem;font-weight:500;transition:border-color .2s}
.user-pill:hover{border-color:var(--sky)}
.user-av{width:26px;height:26px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:800;color:#fff}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.85rem;color:var(--muted)}
.theme-toggle:hover{border-color:var(--sky)}
.btn-logout{text-decoration:none;font-size:.82rem;font-weight:600;color:#EF4444;background:rgba(239,68,68,.08);padding:6px 12px;border-radius:8px}
/* ── Page ── */
.page-wrap{max-width:1100px;margin:0 auto;padding:32px 28px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px}
.page-title{font-family:'Syne',sans-serif;font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--muted);font-size:.9rem}
.alert{padding:13px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert{color:#FCA5A5}
/* ── Info banner ── */
.info-banner{background:var(--sky-glow);border:1px solid var(--sky);border-radius:11px;padding:13px 16px;margin-bottom:20px;font-size:.84rem;color:var(--sky-dark);display:flex;align-items:flex-start;gap:8px;line-height:1.5}
[data-theme="dark"] .info-banner{color:var(--sky)}
/* ── Table card ── */
.table-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;box-shadow:var(--sh)}
.table-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse;min-width:700px}
thead th{padding:11px 14px;text-align:left;font-size:.71rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);background:var(--s1);border-bottom:1px solid var(--border);white-space:nowrap}
tbody td{padding:12px 14px;font-size:.86rem;border-bottom:1px solid var(--border);vertical-align:middle}
tbody tr:last-child td{border-bottom:none}
tbody tr:hover{background:var(--sky-glow)}
.badge{display:inline-flex;align-items:center;padding:3px 9px;border-radius:99px;font-size:.72rem;font-weight:700}
.badge-approved{background:rgba(16,185,129,.12);color:var(--em-dark);border:1px solid rgba(16,185,129,.3)}
[data-theme="dark"] .badge-approved{color:#34D399}
.badge-pending{background:rgba(245,158,11,.1);color:#D97706;border:1px solid rgba(245,158,11,.3)}
[data-theme="dark"] .badge-pending{color:#FCD34D}
.badge-rejected{background:rgba(239,68,68,.08);color:#DC2626;border:1px solid rgba(239,68,68,.2)}
[data-theme="dark"] .badge-rejected{color:#FCA5A5}
.route-cell{display:flex;align-items:center;gap:5px;font-size:.84rem}
.route-arrow{color:var(--sky)}
.amount{font-weight:700;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.dim{color:var(--muted)}
.empty-state{padding:60px 20px;text-align:center;color:var(--muted)}
.empty-icon{font-size:3rem;margin-bottom:14px;opacity:.4}
.empty-state h3{font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:var(--text);margin-bottom:8px}
.empty-state a{color:var(--sky);font-weight:600;text-decoration:none}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .45s ease both}.fu-1{animation-delay:.05s}.fu-2{animation-delay:.1s}
@media(max-width:768px){.navbar{padding:0 16px}.nav-links{display:none}.page-wrap{padding:20px 14px}}
</style>
</head>
<body>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link">✈ All Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link active">💸 Refunds</a>
  </div>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="user-pill">
      <div class="user-av"><%= initials %></div><span><%= firstName %></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">↩ Logout</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header fu">
    <div>
      <h1 class="page-title">💸 Refund History</h1>
      <p class="page-subtitle"><%= refunds != null ? refunds.size() : 0 %> refund request(s)</p>
    </div>
    <a href="${pageContext.request.contextPath}/userBookings" style="text-decoration:none;font-size:.84rem;font-weight:600;color:var(--muted);padding:8px 14px;border:1.5px solid var(--border);border-radius:9px;transition:all .2s">← My Bookings</a>
  </div>

  <% if (error != null) { %><div class="alert fu">⚠ <%= error %></div><% } %>

  <div class="info-banner fu-1">
    ℹ️ <div>Refunds are processed within <strong>3–5 business days</strong> after admin approval. The amount is credited back to your original payment method. Cancellation more than 24h before departure = 100% refund; 2–24h before = 50% refund.</div>
  </div>

  <div class="table-card fu-2">
    <% if (refunds == null || refunds.isEmpty()) { %>
      <div class="empty-state">
        <div class="empty-icon">💸</div>
        <h3>No refund requests</h3>
        <p>Refunds appear here when you cancel a paid booking.</p>
        <br><a href="${pageContext.request.contextPath}/userBookings">View My Bookings →</a>
      </div>
    <% } else { %>
    <div class="table-wrap">
    <table>
      <thead><tr>
        <th>#</th><th>Refund ID</th><th>Flight</th><th>Route</th>
        <th>Amount</th><th>Reason</th><th>Status</th><th>Processed On</th>
      </tr></thead>
      <tbody>
      <% int i=0; for (Map<String,Object> r : refunds) { i++;
         String status = r.get("status") != null ? r.get("status").toString() : "PENDING";
         String bc = "APPROVED".equals(status) ? "badge-approved" : "REJECTED".equals(status) ? "badge-rejected" : "badge-pending";
         Object approvedAt = r.get("approvedAt");
      %>
      <tr>
        <td class="dim"><%= i %></td>
        <td style="font-weight:700;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent">#<%= r.get("id") %></td>
        <td class="fw7" style="font-weight:600"><%= r.get("flight") != null ? r.get("flight") : "—" %></td>
        <td>
          <div class="route-cell">
            <%= r.get("source") != null ? r.get("source") : "—" %>
            <span class="route-arrow">→</span>
            <%= r.get("destination") != null ? r.get("destination") : "—" %>
          </div>
        </td>
        <td class="amount">₹<%= r.get("amount") != null ? String.format("%,.0f", (Double) r.get("amount")) : "0" %></td>
        <td style="font-size:.82rem;color:var(--muted);max-width:160px"><%= r.get("reason") != null ? r.get("reason") : "—" %></td>
        <td><span class="badge <%= bc %>"><%= status %></span></td>
        <td style="font-size:.8rem;color:var(--muted)"><%= approvedAt != null ? approvedAt.toString().substring(0,10) : "—" %></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    </div>
    <% } %>
  </div>
</div>

<script>
(function(){const s=localStorage.getItem('asTheme')||'light';document.documentElement.setAttribute('data-theme',s);document.getElementById('themeToggle').textContent=s==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.textContent=n==='dark'?'☀️':'🌙';});
</script>
</body>
</html>
