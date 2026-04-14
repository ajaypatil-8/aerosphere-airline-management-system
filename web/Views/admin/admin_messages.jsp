<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.skyconnect.util.CsrfUtil" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String _csrfToken = CsrfUtil.getToken(request);
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> messages = (List<Map<String,Object>>) request.getAttribute("messages");
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    Integer pendingRefunds = (Integer) request.getAttribute("pendingRefunds");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Contact Messages – AeroSphere Admin</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:opsz,wght@9..40,400;9..40,500;9..40,600;9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.as-admin-layout{display:flex;min-height:100vh}
.as-main{flex:1;min-width:0;overflow:auto}
.page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px}
.page-title{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800}
.msg-filters{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:20px}
.filter-btn{padding:7px 16px;border-radius:var(--radius-sm);border:1.5px solid var(--border);font-size:.83rem;font-weight:600;cursor:pointer;background:var(--surface-0);color:var(--text-muted);transition:all .2s;font-family:'DM Sans',sans-serif}
.filter-btn.active,.filter-btn:hover{border-color:var(--primary);color:var(--primary);background:var(--primary-glow)}
.msg-card{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);margin-bottom:16px;overflow:hidden;transition:border-color .2s}
.msg-card:hover{border-color:var(--primary)}
.msg-card.unread{border-left:3px solid var(--primary)}
.msg-header{padding:18px 22px;display:flex;align-items:flex-start;justify-content:space-between;gap:16px;cursor:pointer;user-select:none}
.msg-meta{flex:1;min-width:0}
.msg-sender{font-weight:700;font-size:.92rem;margin-bottom:3px;display:flex;align-items:center;gap:8px}
.msg-subject{font-size:.88rem;color:var(--text-muted);margin-bottom:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.msg-time{font-size:.75rem;color:var(--text-muted)}
.msg-badges{display:flex;gap:6px;align-items:center;flex-shrink:0}
.badge-new{background:var(--primary);color:#fff;font-size:.65rem;font-weight:700;padding:2px 7px;border-radius:99px}
.badge-replied{background:rgba(16,185,129,.12);color:#059669;font-size:.65rem;font-weight:700;padding:2px 7px;border-radius:99px;border:1px solid rgba(16,185,129,.3)}
.msg-arrow{color:var(--text-muted);transition:transform .3s;font-size:.85rem}
.msg-card.open .msg-arrow{transform:rotate(180deg)}
.msg-body{max-height:0;overflow:hidden;transition:max-height .35s ease}
.msg-card.open .msg-body{max-height:600px}
.msg-body-inner{padding:0 22px 22px;border-top:1px solid var(--border)}
.msg-content{background:var(--bg);border-radius:var(--radius-sm);padding:16px 18px;margin:16px 0;font-size:.88rem;line-height:1.75;color:var(--text);white-space:pre-wrap;word-break:break-word}
.reply-form{margin-top:16px}
.reply-form label{display:block;font-size:.75rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:7px}
.reply-form textarea{width:100%;padding:12px 14px;background:var(--bg);border:1.5px solid var(--border-2);border-radius:var(--radius-sm);color:var(--text);font-family:'DM Sans',sans-serif;font-size:.88rem;outline:none;resize:vertical;min-height:110px;transition:border-color .2s,box-shadow .2s}
.reply-form textarea:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.reply-actions{display:flex;gap:10px;margin-top:12px;align-items:center}
.btn-reply{padding:9px 20px;background:var(--grad-brand);color:#fff;border:none;border-radius:var(--radius-sm);font-weight:700;font-size:.85rem;cursor:pointer;font-family:'DM Sans',sans-serif;transition:opacity .2s}
.btn-reply:hover{opacity:.88}
.btn-delete{padding:9px 16px;background:transparent;color:var(--danger);border:1.5px solid var(--danger);border-radius:var(--radius-sm);font-weight:600;font-size:.83rem;cursor:pointer;font-family:'DM Sans',sans-serif;transition:all .2s}
.btn-delete:hover{background:var(--danger);color:#fff}
.replied-badge-row{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;background:rgba(16,185,129,.06);border:1px solid rgba(16,185,129,.25);border-radius:var(--radius-sm);font-size:.82rem;color:#059669;font-weight:600;margin-top:12px}
.empty-state{text-align:center;padding:56px 20px;color:var(--text-muted)}
.empty-state .icon{font-size:3rem;margin-bottom:12px;opacity:.4}
.alert-success{background:rgba(16,185,129,.08);border:1px solid rgba(16,185,129,.3);border-radius:var(--radius);padding:12px 18px;color:#059669;font-size:.88rem;margin-bottom:16px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.3);border-radius:var(--radius);padding:12px 18px;color:#DC2626;font-size:.88rem;margin-bottom:16px}
.topbar{display:flex;align-items:center;gap:14px;padding:16px 28px;border-bottom:1px solid var(--border);background:var(--surface-0)}
.topbar-title{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem}
.page-wrap{padding:28px}
.stat-row{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:24px}
.stat-mini{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius);padding:16px 20px;text-align:center}
.stat-mini-num{font-family:'Syne',sans-serif;font-size:1.6rem;font-weight:800;color:var(--primary)}
.stat-mini-label{font-size:.75rem;color:var(--text-muted);font-weight:600;text-transform:uppercase;letter-spacing:.04em}
</style>
</head>
<body>
<div class="as-admin-layout">
<%@ include file="/Views/common/sidebar.jsp" %>
<div class="as-main">
  <div class="topbar">
    <button class="as-sidebar-toggle" onclick="document.getElementById('asSidebar').classList.toggle('open')">☰</button>
    <span class="topbar-title">📧 Contact Messages</span>
    <div style="margin-left:auto;display:flex;gap:8px">
      <button class="theme-toggle" onclick="AS.toggleTheme()" style="width:34px;height:34px;border:1px solid var(--border);border-radius:8px;background:var(--surface-0);cursor:pointer;font-size:.9rem">🌙</button>
    </div>
  </div>

  <div class="page-wrap">
    <% if (success != null) { %><div class="alert-success">✅ <%= success %></div><% } %>
    <% if (error != null) { %><div class="alert-error">⚠️ <%= error %></div><% } %>

    <div class="page-header">
      <div class="page-title">📬 User Messages</div>
    </div>

    <%-- Stats --%>
    <%
      int total = messages != null ? messages.size() : 0;
      int unread = 0, replied = 0;
      if (messages != null) {
        for (Map<String,Object> m : messages) {
          String st = (String) m.get("status");
          if ("NEW".equals(st)) unread++;
          else if ("REPLIED".equals(st)) replied++;
        }
      }
    %>
    <div class="stat-row">
      <div class="stat-mini"><div class="stat-mini-num"><%= total %></div><div class="stat-mini-label">Total Messages</div></div>
      <div class="stat-mini"><div class="stat-mini-num" style="color:#F59E0B"><%= unread %></div><div class="stat-mini-label">Unread</div></div>
      <div class="stat-mini"><div class="stat-mini-num" style="color:#10B981"><%= replied %></div><div class="stat-mini-label">Replied</div></div>
    </div>

    <div class="msg-filters">
      <button class="filter-btn active" onclick="filterMsgs('all',this)">All (<%= total %>)</button>
      <button class="filter-btn" onclick="filterMsgs('NEW',this)">🔵 Unread (<%= unread %>)</button>
      <button class="filter-btn" onclick="filterMsgs('REPLIED',this)">✅ Replied (<%= replied %>)</button>
    </div>

    <% if (messages == null || messages.isEmpty()) { %>
      <div class="empty-state">
        <div class="icon">📭</div>
        <h3 style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:var(--text);margin-bottom:8px">No messages yet</h3>
        <p>When users submit the Contact Us form, their messages will appear here.</p>
      </div>
    <% } else { %>
      <% for (Map<String,Object> msg : messages) {
           String status = (String) msg.get("status");
           boolean isNew = "NEW".equals(status);
      %>
      <div class="msg-card <%= isNew ? "unread" : "" %>" data-status="<%= status %>">
        <div class="msg-header" onclick="toggleMsg(this.parentElement)">
          <div class="msg-meta">
            <div class="msg-sender">
              <%= msg.get("sender_name") %>
              <span style="font-weight:400;color:var(--text-muted);font-size:.82rem">&lt;<%= msg.get("sender_email") %>&gt;</span>
              <% if (msg.get("booking_id") != null && !msg.get("booking_id").toString().isEmpty()) { %>
                <span style="font-size:.75rem;color:var(--text-muted)">Booking: #<%= msg.get("booking_id") %></span>
              <% } %>
            </div>
            <div class="msg-subject">📌 <%= msg.get("subject") %></div>
            <div class="msg-time"><%= msg.get("created_at") %></div>
          </div>
          <div class="msg-badges">
            <% if (isNew) { %><span class="badge-new">NEW</span><% } %>
            <% if ("REPLIED".equals(status)) { %><span class="badge-replied">✓ Replied</span><% } %>
            <span class="msg-arrow">▾</span>
          </div>
        </div>
        <div class="msg-body">
          <div class="msg-body-inner">
            <div style="font-size:.78rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-top:16px;margin-bottom:6px">Message</div>
            <div class="msg-content"><%= msg.get("message") %></div>

            <% if ("REPLIED".equals(status) && msg.get("admin_reply") != null) { %>
              <div style="font-size:.78rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#059669;margin-top:16px;margin-bottom:6px">Your Reply (sent)</div>
              <div class="msg-content" style="border-left:3px solid #10B981"><%= msg.get("admin_reply") %></div>
            <% } %>

            <% if (!"REPLIED".equals(status)) { %>
            <form class="reply-form" action="${pageContext.request.contextPath}/adminMessages" method="post">
              <input type="hidden" name="action" value="reply">
              <input type="hidden" name="messageId" value="<%= msg.get("id") %>">
              <input type="hidden" name="replyTo" value="<%= msg.get("sender_email") %>">
              <input type="hidden" name="senderName" value="<%= msg.get("sender_name") %>">
              <input type="hidden" name="originalSubject" value="<%= msg.get("subject") %>">
              <input type="hidden" name="_csrf" value="<%= _csrfToken %>">
              <label>Reply to <%= msg.get("sender_email") %></label>
              <textarea name="replyText" placeholder="Type your reply here...&#10;&#10;This will be sent as an email to the user." required></textarea>
              <div class="reply-actions">
                <button type="submit" class="btn-reply">📤 Send Reply</button>
                <form action="${pageContext.request.contextPath}/adminMessages" method="post" style="display:inline">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="messageId" value="<%= msg.get("id") %>">
                  <input type="hidden" name="_csrf" value="<%= _csrfToken %>">
                  <button type="submit" class="btn-delete" onclick="return confirm('Delete this message?')">🗑 Delete</button>
                </form>
              </div>
            </form>
            <% } else { %>
            <div class="reply-actions">
              <div class="replied-badge-row">✅ Reply sent to <%= msg.get("sender_email") %></div>
              <form action="${pageContext.request.contextPath}/adminMessages" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="messageId" value="<%= msg.get("id") %>">
                <input type="hidden" name="_csrf" value="<%= _csrfToken %>">
                <button type="submit" class="btn-delete" onclick="return confirm('Delete this message?')">🗑 Delete</button>
              </form>
            </div>
            <% } %>
          </div>
        </div>
      </div>
      <% } %>
    <% } %>
  </div>
</div>
</div>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
function toggleMsg(card){
  var isOpen=card.classList.contains('open');
  document.querySelectorAll('.msg-card.open').forEach(function(c){c.classList.remove('open');});
  if(!isOpen) card.classList.add('open');
}
function filterMsgs(status,btn){
  document.querySelectorAll('.filter-btn').forEach(function(b){b.classList.remove('active');});
  btn.classList.add('active');
  document.querySelectorAll('.msg-card').forEach(function(c){
    c.style.display=(status==='all'||c.dataset.status===status)?'':'none';
  });
}
</script>
</body>
</html>
