<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.controller.ReportUsersServlet.UserRow" %>
<%
  String userName=(String)session.getAttribute("userName");
  String userRole=(String)session.getAttribute("userRole");
  if(userName==null||!"ADMIN".equals(userRole)){response.sendRedirect(request.getContextPath()+"/login");return;}
  @SuppressWarnings("unchecked") List<UserRow> users=(List<UserRow>)request.getAttribute("users");
  String gen=new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new Date());
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Users Report – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>

:root{
  --sky:#0EA5E9;--emerald:#10B981;--emerald-dark:#059669;
  --grad:linear-gradient(135deg,var(--sky),var(--emerald));
  --sky-glow:rgba(14,165,233,.18);--em-glow:rgba(16,185,129,.18);
  --bg:#F8FAFC;--card-bg:#FFFFFF;--text:#0F172A;--text-muted:#64748B;
  --border:#E2E8F0;--shadow:0 2px 12px rgba(0,0,0,.06);
  --shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px;
  --sidebar-w:248px;
}
[data-theme="dark"]{
  --bg:#0A0A0F;--card-bg:#111118;--text:#F1F5F9;--text-muted:#94A3B8;
  --border:#1E293B;--shadow:0 2px 12px rgba(0,0,0,.4);
  --shadow-lg:0 12px 40px rgba(0,0,0,.55);
}


*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Syne',sans-serif}


.as-admin-layout{display:flex;min-height:100vh}
.as-sidebar{width:var(--sidebar-w);background:var(--card-bg);border-right:1px solid var(--border);display:flex;flex-direction:column;position:sticky;top:0;height:100vh;overflow-y:auto;z-index:100;transition:transform .3s}
.as-sidebar-brand{padding:20px 18px 14px;display:flex;align-items:center;gap:9px;border-bottom:1px solid var(--border)}
.as-sidebar-logo{width:34px;height:34px;border-radius:9px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:16px;color:#fff}
.as-sidebar-brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.as-sidebar-badge{font-size:.58rem;background:rgba(245,158,11,.15);color:#D97706;border:1px solid rgba(245,158,11,.3);padding:2px 6px;border-radius:4px;font-weight:800;letter-spacing:.07em}
.as-sidebar-section{padding:10px 10px;flex:1}
.as-sidebar-label{font-size:.65rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--text-muted);padding:10px 8px 4px;opacity:.7}
.as-sidebar-link{display:flex;align-items:center;gap:9px;padding:9px 10px;border-radius:10px;text-decoration:none;color:var(--text-muted);font-size:.85rem;font-weight:500;transition:all .2s;position:relative;margin-bottom:1px}
.as-sidebar-link .icon{font-size:15px;width:20px;text-align:center}
.as-sidebar-link:hover{background:var(--sky-glow);color:var(--sky)}
.as-sidebar-link.active{background:var(--sky-glow);color:var(--sky);font-weight:600}
.as-sidebar-link.active::before{content:'';position:absolute;left:0;top:6px;bottom:6px;width:3px;background:var(--grad);border-radius:0 3px 3px 0}
.as-sidebar-link .badge{margin-left:auto;background:var(--grad);color:#fff;font-size:.65rem;font-weight:700;padding:1px 7px;border-radius:99px}
.as-sidebar-footer{padding:14px 12px;border-top:1px solid var(--border)}
.as-sidebar-user{display:flex;align-items:center;gap:9px;padding:10px;background:var(--bg);border-radius:10px;margin-bottom:8px}
.as-sidebar-user-avatar{width:32px;height:32px;border-radius:50%;background:var(--grad);color:#fff;display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:800;flex-shrink:0}
.as-sidebar-user-name{font-size:.83rem;font-weight:600;font-family:'Syne',sans-serif}
.as-sidebar-user-role{font-size:.7rem;color:var(--text-muted)}
.as-sidebar-logout{display:flex;align-items:center;gap:7px;padding:9px 12px;border-radius:10px;text-decoration:none;color:#EF4444;font-size:.83rem;font-weight:600;transition:background .2s}
.as-sidebar-logout:hover{background:rgba(239,68,68,.08)}
.as-main{flex:1;min-width:0;overflow:auto}
/* Mobile sidebar */
.as-sidebar-toggle{display:none;position:fixed;top:14px;left:14px;z-index:300;width:38px;height:38px;border-radius:9px;background:var(--card-bg);border:1px solid var(--border);cursor:pointer;align-items:center;justify-content:center;font-size:16px}
@media(max-width:900px){
  .as-sidebar{position:fixed;left:0;top:0;height:100vh;transform:translateX(-100%);z-index:250}
  .as-sidebar.open{transform:translateX(0)}
  .as-sidebar-toggle{display:flex}
  .as-main{padding-top:0}
}


.report-topbar{display:flex;align-items:center;justify-content:space-between;padding:24px 32px 0;flex-wrap:wrap;gap:12px}
.report-topbar-left{display:flex;align-items:center;gap:12px}
.as-back-link{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:9px;text-decoration:none;color:var(--text-muted);border:1.5px solid var(--border);font-size:.83rem;font-weight:500;transition:all .2s}
.as-back-link:hover{border-color:var(--sky);color:var(--sky)}
.btn-print{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:9px;background:var(--grad);color:#fff;border:none;font-family:'DM Sans',sans-serif;font-size:.83rem;font-weight:700;cursor:pointer;transition:transform .15s,box-shadow .15s}
.btn-print:hover{transform:translateY(-1px);box-shadow:0 4px 14px var(--sky-glow)}
.page-header{padding:20px 32px 16px}
.page-title{font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.87rem}
.table-wrap{margin:0 32px 32px;background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.sc-table{width:100%;border-collapse:collapse}
.sc-table th{padding:11px 16px;text-align:left;font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
.sc-table td{padding:12px 16px;font-size:.85rem;border-bottom:1px solid var(--border)}
.sc-table tr:last-child td{border-bottom:none}
.sc-table tbody tr{transition:background .15s}
.sc-table tbody tr:hover{background:var(--sky-glow)}
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.badge-paid,.badge-success{background:rgba(16,185,129,.12);color:#059669}
[data-theme="dark"] .badge-paid,[data-theme="dark"] .badge-success{color:#34D399}
.badge-cancelled,.badge-failed{background:rgba(239,68,68,.1);color:#DC2626}
[data-theme="dark"] .badge-cancelled,[data-theme="dark"] .badge-failed{color:#FCA5A5}
.badge-booked,.badge-pending{background:rgba(14,165,233,.1);color:#0284C7}
[data-theme="dark"] .badge-booked,[data-theme="dark"] .badge-pending{color:#7DD3FC}
.badge-refunded{background:rgba(99,102,241,.12);color:#4F46E5}
[data-theme="dark"] .badge-refunded{color:#A5B4FC}
.badge-admin{background:rgba(16,185,129,.12);color:#059669}
.badge-user{background:rgba(14,165,233,.1);color:#0284C7}
.empty-state{text-align:center;padding:56px 24px;color:var(--text-muted)}
.empty-icon{font-size:2.5rem;margin-bottom:12px}
.empty-state h3{font-family:'Syne',sans-serif;font-weight:700;color:var(--text)}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.animate-fadeup{animation:fadeUp .45s ease forwards}
@media print{.as-sidebar,.as-sidebar-toggle,.btn-print,.as-back-link,.as-theme-toggle{display:none!important}.as-main{padding:0!important}.table-wrap{margin:0;border:none;box-shadow:none}}

</style>
</head>
<body>
<%@ include file="/Views/common/sidebar.jsp" %>
<div class="as-main">
  <div class="report-topbar animate-fadeup">
    <div class="report-topbar-left">
      <a href="${pageContext.request.contextPath}/reports" class="as-back-link">← Reports</a>
    </div>
    <div style="display:flex;align-items:center;gap:10px">
      <button onclick="window.print()" class="btn-print">🖨 Print / PDF</button>
      <button class="as-theme-toggle" id="asThemeToggle">🌙</button>
    </div>
  </div>
  <div class="page-header animate-fadeup">
    <div class="page-title">👤 Users Report</div>
    <div class="page-subtitle">Generated: <%=gen%> &nbsp;·&nbsp; <%=users!=null?users.size():0%> records</div>
  </div>
  <div class="table-wrap animate-fadeup">
    <% if(users==null||users.isEmpty()){ %>
      <div class="empty-state"><div class="empty-icon">👤</div><h3>No data available</h3><p style="font-size:.83rem;margin-top:8px">The report servlet may not have returned data. Check your database connection and that the servlet is properly mapping the request attribute.</p></div>
    <%}else{%>
    <table class="sc-table">
      <thead><tr><th>#</th><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Joined</th></tr></thead>
      <tbody>
        <% int i=0; for(UserRow u:users){i++;
  String bc="ADMIN".equals(u.role)?"badge-admin":"badge-user";
  String ini=(u.name!=null&&u.name.length()>0)?String.valueOf(u.name.charAt(0)).toUpperCase():"?"; %>
<tr>
  <td style="color:var(--text-muted)"><%=i%></td>
  <td style="color:var(--sky);font-weight:700">#<%=u.id%></td>
  <td>
    <div style="display:flex;align-items:center;gap:8px">
      <span style="width:28px;height:28px;border-radius:50%;background:var(--grad);color:#fff;display:inline-flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:800;flex-shrink:0"><%=ini%></span>
      <span style="font-weight:600"><%=u.name%></span>
    </div>
  </td>
  <td style="font-size:.84rem;color:var(--text-muted)"><%=u.email%></td>
  <td style="font-size:.82rem"><%=u.phone!=null?u.phone:"—"%></td>
  <td><span class="badge <%=bc%>"><%=u.role%></span></td>
  <td style="font-size:.8rem;color:var(--text-muted)"><%=u.createdAt!=null?u.createdAt.toString().substring(0,10):"—"%></td>
</tr>
<%}%>
      </tbody>
    </table>
    <%}%>
  </div>
</div>
<script>

(function(){
  var btn=document.getElementById('asThemeToggle');
  if(!btn)return;
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.textContent=t==='dark'?'☀️':'🌙';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();

</script>
</body>
</html>
