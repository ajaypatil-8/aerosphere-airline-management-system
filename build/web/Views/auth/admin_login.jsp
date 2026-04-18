<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String error = (String) request.getAttribute("error");
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Login – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--sky:#0EA5E9;--sky-dark:#0284C7;--sky-glow:rgba(14,165,233,.18);--em:#10B981;--em-dark:#059669;--em-glow:rgba(16,185,129,.18);--grad:linear-gradient(135deg,var(--sky),var(--em));--bg:#F0F9FF;--s0:#FFFFFF;--s1:#F8FAFC;--text:#0F172A;--muted:#64748B;--border:#E2E8F0;--sh:0 1px 3px rgba(0,0,0,.06),0 4px 16px rgba(0,0,0,.04);--sh-lg:0 16px 48px rgba(0,0,0,.1);--r:16px}
[data-theme="dark"]{--bg:#060A12;--s0:#0D1117;--s1:#111827;--text:#F1F5F9;--muted:#94A3B8;--border:#1E293B;--sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);--sh-lg:0 16px 48px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;position:relative;overflow:hidden}
/* Mesh background */
body::before{content:'';position:fixed;width:700px;height:700px;border-radius:50%;background:radial-gradient(circle,var(--sky-glow) 0%,transparent 70%);top:-200px;left:-200px;pointer-events:none}
body::after{content:'';position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,var(--em-glow) 0%,transparent 70%);bottom:-100px;right:-100px;pointer-events:none}
.theme-btn{position:fixed;top:20px;right:20px;width:38px;height:38px;border:1px solid var(--border);border-radius:10px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;color:var(--muted);transition:all .2s;z-index:10}
.theme-btn:hover{border-color:var(--sky);color:var(--sky)}
.back-home{position:fixed;top:20px;left:20px;display:flex;align-items:center;gap:6px;text-decoration:none;color:var(--muted);font-size:.82rem;font-weight:600;transition:color .2s;z-index:10}
.back-home:hover{color:var(--sky)}
/* Card */
.card{width:100%;max-width:400px;background:var(--s0);border:1px solid var(--border);border-radius:var(--r);box-shadow:var(--sh-lg);overflow:hidden;position:relative;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.card-top{height:4px;background:linear-gradient(90deg,var(--sky),var(--em),var(--sky))}
.card-body{padding:36px 32px}
.shield-wrap{width:58px;height:58px;border-radius:14px;background:linear-gradient(135deg,rgba(14,165,233,.12),rgba(16,185,129,.12));border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.6rem;margin:0 auto 18px}
.card-title{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;letter-spacing:-.5px;text-align:center;margin-bottom:4px}
.card-title span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.card-sub{text-align:center;color:var(--muted);font-size:.84rem;margin-bottom:20px}
.admin-badge{display:inline-flex;align-items:center;gap:6px;background:rgba(245,158,11,.1);color:#D97706;border:1px solid rgba(245,158,11,.3);border-radius:99px;padding:4px 13px;font-size:.72rem;font-weight:700;letter-spacing:.05em;text-transform:uppercase;margin:0 auto 24px;display:flex;justify-content:center;width:fit-content;margin:0 auto 24px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626;border-radius:10px;padding:11px 14px;font-size:.84rem;margin-bottom:20px;display:flex;align-items:center;gap:8px}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.form-group{margin-bottom:16px}
.form-label{display:block;font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);margin-bottom:7px}
.field-wrap{display:flex;align-items:center;gap:9px;background:var(--s1);border:1.5px solid var(--border);border-radius:10px;padding:0 13px;transition:border-color .2s,box-shadow .2s}
.field-wrap:focus-within{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.fi{font-size:.9rem;flex-shrink:0;opacity:.7}
.field-wrap input{flex:1;border:none;background:transparent;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.9rem;padding:11px 0;outline:none}
.field-wrap input::placeholder{color:var(--muted);opacity:.65}
.btn-submit{width:100%;padding:12px;background:var(--grad);color:#fff;border:none;border-radius:10px;font-family:'DM Sans',sans-serif;font-size:.92rem;font-weight:700;cursor:pointer;transition:all .2s;box-shadow:0 4px 14px var(--sky-glow);margin-top:6px}
.btn-submit:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 6px 20px var(--sky-glow)}
.back-link{display:block;text-align:center;margin-top:20px;color:var(--muted);text-decoration:none;font-size:.84rem;transition:color .2s}
.back-link:hover{color:var(--sky)}
</style>
</head>
<body>
<button class="theme-btn" id="themeToggle">🌙</button>
<a href="${pageContext.request.contextPath}/" class="back-home">← Home</a>

<div class="card">
  <div class="card-top"></div>
  <div class="card-body">
    <div class="shield-wrap">🛡️</div>
    <h1 class="card-title">Aero<span>Sphere</span></h1>
    <p class="card-sub">Administrator Portal</p>
    <div class="admin-badge">🔐 Secure Admin Access</div>

    <% if (error != null) { %>
    <div class="alert-error">⚠ <%= HtmlUtils.e(error) %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
      <div class="form-group">
        <label class="form-label">Admin Email</label>
        <div class="field-wrap"><span class="fi">📧</span>
          <input type="email" name="email" placeholder="admin@aerosphere.com" required autocomplete="email">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <div class="field-wrap" style="position:relative"><span class="fi">🔐</span>
          <input type="password" name="password" id="adminPwd" placeholder="Enter admin password" required>
          <button type="button" onclick="var i=document.getElementById('adminPwd');i.type=i.type==='password'?'text':'password'" style="border:none;background:none;cursor:pointer;color:var(--muted);padding:0 4px;font-size:.85rem">👁</button>
        </div>
        <div style="text-align:right;margin-top:6px">
          <a href="${pageContext.request.contextPath}/forgotPassword" style="font-size:.76rem;color:var(--muted);text-decoration:none">Forgot password?</a>
        </div>
      </div>
      <input type="hidden" name="loginType" value="ADMIN">
      <button type="submit" class="btn-submit">Sign In to Admin Panel →</button>
    </form>
    <a href="${pageContext.request.contextPath}/login" class="back-link">← Back to User Login</a>
  </div>
</div>

<script>
(function(){const s=localStorage.getItem('asTheme')||'light';document.documentElement.setAttribute('data-theme',s);document.getElementById('themeToggle').textContent=s==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.textContent=n==='dark'?'☀️':'🌙';});
</script>
</body>
</html>
