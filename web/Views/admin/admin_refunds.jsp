<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%!
  private String _ps(boolean a){
    String b="display:inline-flex;align-items:center;justify-content:center;min-width:32px;height:32px;padding:0 8px;border-radius:8px;text-decoration:none;font-size:.82rem;font-weight:600;border:1.5px solid;transition:all .15s;";
    return a ? b+"background:#2E4A3D;color:#fff;border-color:transparent;"
             : b+"background:transparent;color:var(--text-muted,#64748B);border-color:var(--border,#E2E8F0);";
  }
  private String _ps(){ return _ps(false); }
%>

<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String error = (String) request.getAttribute("error");
    String csrfToken = CsrfUtil.getToken(request);
    String adminFirst = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund Requests – AeroSphere Admin</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.admin-topbar{position:sticky;top:0;z-index:300;height:56px;display:flex;align-items:center;justify-content:space-between;padding:0 32px;background:var(--glass-bg);border-bottom:1px solid var(--border);backdrop-filter:var(--glass-blur);-webkit-backdrop-filter:var(--glass-blur)}
.topbar-left{display:flex;align-items:center;gap:12px}
.topbar-title{font-family:'Fraunces',sans-serif;font-size:.95rem;font-weight:700;color:var(--text);letter-spacing:-.02em}
.topbar-right{display:flex;align-items:center;gap:8px}
.sidebar-toggle-btn{display:none;width:36px;height:36px;background:var(--surface-0);border:1px solid var(--border-2);border-radius:var(--radius-sm);align-items:center;justify-content:center;font-size:1.1rem;cursor:pointer;transition:border-color .2s}
.sidebar-toggle-btn:hover{border-color:var(--primary)}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px}
.page-title{font-family:'Fraunces',sans-serif;font-size:1.55rem;font-weight:800;letter-spacing:-.04em;color:var(--text)}
.page-subtitle{font-size:.88rem;color:var(--text-muted);margin-top:4px}
.action-btns{display:flex;gap:8px;align-items:center}
.empty-state{text-align:center;padding:60px 24px}
@media(max-width:900px){
  .as-sidebar.open{transform:translateX(0);box-shadow:var(--shadow-lg)}
  .sidebar-toggle-btn{display:flex}
  .admin-topbar{padding:0 16px}
}
</style>
</head>
<body>

<div class="as-admin-layout">

  <%@ include file="/Views/common/sidebar.jsp" %>

  <main class="as-main">
    <div class="admin-topbar">
      <div class="topbar-left">
        <button class="sidebar-toggle-btn" id="as-sidebar-toggle" aria-label="Toggle sidebar"><i class="ph-bold ph-list"></i></button>
        <span class="topbar-title">Refund Requests</span>
      </div>
      <div class="topbar-right">
        <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme"><i class="ph-bold ph-moon"></i></button>
        <div class="user-pill">
          <div class="user-avatar"><%= adminFirst.charAt(0) %></div>
          <span><%= adminFirst %></span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">↩ Logout</a>
      </div>
    </div>

    <div class="page-wrapper">

      <div class="page-header anim-fade-up">
        <div>
          <h1 class="page-title"><i class="ph-bold ph-hand-coins"></i> Refund Requests</h1>
          <p class="page-subtitle"><%= refunds != null ? refunds.size() : 0 %> refund requests total</p>
        </div>
      </div>

      <% if (error != null) { %><div class="alert alert-danger anim-fade-up"><span><i class="ph-bold ph-warning"></i></span><span><%= error %></span></div><% } %>

      <div class="table-wrap anim-fade-up">
        <% if (refunds == null || refunds.isEmpty()) { %>
          <div class="empty-state">
            <div style="font-size:2.5rem;margin-bottom:12px"><i class="ph-bold ph-hand-coins"></i></div>
            <h3 style="font-family:'Fraunces',sans-serif;font-weight:700;margin-bottom:6px">No refund requests</h3>
            <p style="color:var(--text-muted);font-size:.88rem">Refund requests appear here when users cancel paid bookings.</p>
          </div>
        <% } else { %>
        <table class="sc-table">
          <thead>
            <tr>
              <th>#</th><th>Refund ID</th><th>Passenger</th><th>Flight</th>
              <th>Amount</th><th>Reason</th><th>Status</th><th>Processed At</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
          <% int ri = 0; for (Map<String,Object> r : refunds) { ri++;
             String status = r.get("status") != null ? r.get("status").toString() : "PENDING";
             String bc = status.equals("APPROVED") ? "badge-paid" : status.equals("REJECTED") ? "badge-cancelled" : "badge-pending";
          %>
          <tr>
            <td style="color:var(--text-muted)"><%= ri %></td>
            <td style="color:var(--primary);font-family:'Fraunces',sans-serif;font-weight:700">#<%= r.get("id") %></td>
            <td style="font-weight:600"><%= r.get("user") %></td>
            <td><strong style="font-family:'Fraunces',sans-serif;color:var(--primary)"><%= r.get("flight") %></strong></td>
            <td style="color:var(--secondary);font-family:'Fraunces',sans-serif;font-weight:700">₹<%= String.format("%,.0f", (Double)r.get("amount")) %></td>
            <td style="font-size:.82rem;color:var(--text-muted);max-width:160px"><%= r.get("reason") != null ? r.get("reason") : "—" %></td>
            <td><span class="badge <%= bc %>"><%= status %></span></td>
            <td style="font-size:.82rem;color:var(--text-muted)"><%= r.get("approvedAt") != null ? r.get("approvedAt").toString().substring(0,10) : "—" %></td>
            <td>
              <% if ("PENDING".equals(status)) { %>
              <div class="action-btns">
                <form action="${pageContext.request.contextPath}/approveRefund" method="post" style="margin:0">
                  <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">
                  <input type="hidden" name="refundId"  value="<%= r.get("id") %>">
                  <input type="hidden" name="action"    value="APPROVE">
                  <button type="submit" class="btn btn-success btn-xs"
                          onclick="return confirm('Approve this refund?')"><i class="ph-bold ph-check-circle"></i> Approve</button>
                </form>
                <form action="${pageContext.request.contextPath}/approveRefund" method="post" style="margin:0">
                  <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">
                  <input type="hidden" name="refundId"  value="<%= r.get("id") %>">
                  <input type="hidden" name="action"    value="REJECT">
                  <button type="submit" class="btn btn-danger btn-xs"
                          onclick="return confirm('Reject this refund?')"><i class="ph-bold ph-x-circle"></i> Reject</button>
                </form>
              </div>
              <% } else { %>
              <span style="color:var(--text-muted);font-size:.82rem">Processed</span>
              <% } %>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
        <% } %>
      </div>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/assests/js/darkmode.js"></script>
<script>
(function(){
  var btn = document.getElementById('themeToggle');
  if (btn) {
    btn.textContent = document.documentElement.getAttribute('data-theme') === 'dark' ? '<i class="ph-bold ph-sun"></i>' : '<i class="ph-bold ph-moon"></i>';
    btn.addEventListener('click', function() {
      var next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem('asTheme', next);
      btn.textContent = next === 'dark' ? '<i class="ph-bold ph-sun"></i>' : '<i class="ph-bold ph-moon"></i>';
    });
  }
  // Sidebar
  var tog = document.getElementById('as-sidebar-toggle');
  var sid = document.getElementById('as-sidebar');
  var ov  = document.getElementById('as-sidebar-overlay');
  if (tog && sid) {
    tog.addEventListener('click', function() { sid.classList.toggle('open'); if (ov) ov.classList.toggle('active'); });
    if (ov) ov.addEventListener('click', function() { sid.classList.remove('open'); ov.classList.remove('active'); });
  }
})();
</script>
</body>
</html>


<%{ int _cp=(request.getAttribute("currentPage")!=null)?(Integer)request.getAttribute("currentPage"):1;
     int _tp=(request.getAttribute("totalPages")!=null)?(Integer)request.getAttribute("totalPages"):1;
     int _tc=(request.getAttribute("totalCount")!=null)?(Integer)request.getAttribute("totalCount"):0;
     if(_tp>1){
       int _s=Math.max(1,_cp-2),_e=Math.min(_tp,_cp+2); %>
<div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px;padding:16px 0 4px">
  <small style="color:var(--text-muted,#64748B);font-size:.8rem">Page <%=_cp%> of <%=_tp%> &nbsp;·&nbsp; <%=_tc%> total records</small>
  <div style="display:flex;gap:4px;flex-wrap:wrap">
    <%if(_cp>1){%><a href="?page=1" style="<%=_ps()%>">«</a><%}%>
    <%if(_cp>1){%><a href="?page=<%=_cp-1%>" style="<%=_ps()%>">‹</a><%}%>
    <%for(int _pg=_s;_pg<=_e;_pg++){%><a href="?page=<%=_pg%>" style="<%=_ps(_pg==_cp)%>"><%=_pg%></a><%}%>
    <%if(_cp<_tp){%><a href="?page=<%=_cp+1%>" style="<%=_ps()%>">›</a><%}%>
    <%if(_cp<_tp){%><a href="?page=<%=_tp%>" style="<%=_ps()%>">»</a><%}%>
  </div>
</div>
<%}}%>