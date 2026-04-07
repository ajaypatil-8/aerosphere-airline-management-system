<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String error = (String) request.getAttribute("error");
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Login – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 4px 24px rgba(0,0,0,.08);--radius:16px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.16);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 4px 24px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;transition:background .3s,color .3s}
.theme-toggle{position:fixed;top:20px;right:20px;width:38px;height:38px;border:1.5px solid var(--border);border-radius:10px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all .2s;z-index:100}
.theme-toggle:hover{border-color:var(--primary)}
.card{width:100%;max-width:420px;background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);padding:40px 36px;animation:fadeUp .45s ease forwards}
.shield-icon{width:56px;height:56px;background:rgba(16,185,129,.1);border:2px solid var(--primary);border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px;margin:0 auto 20px}
.card-title{font-size:1.45rem;font-weight:800;letter-spacing:-.5px;text-align:center;margin-bottom:4px}
.card-title span{color:var(--primary)}
.card-subtitle{text-align:center;color:var(--text-muted);font-size:.86rem;margin-bottom:28px}
.admin-badge{display:inline-flex;align-items:center;gap:6px;background:rgba(16,185,129,.1);color:var(--primary);border:1px solid rgba(16,185,129,.3);border-radius:20px;padding:4px 12px;font-size:.76rem;font-weight:700;letter-spacing:.04em;text-transform:uppercase;margin-bottom:28px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.25);color:#DC2626;border-radius:10px;padding:10px 14px;font-size:.85rem;margin-bottom:20px;display:flex;align-items:center;gap:8px}
[data-theme="dark"] .alert-error{background:rgba(239,68,68,.12);color:#FCA5A5}
.form-group{margin-bottom:18px}
label{display:block;font-size:.82rem;font-weight:600;color:var(--text-muted);margin-bottom:6px;text-transform:uppercase;letter-spacing:.04em}
input[type="email"],input[type="password"]{width:100%;padding:11px 14px;background:var(--bg);border:1.5px solid var(--border);border-radius:10px;font-family:'Inter',sans-serif;font-size:.9rem;color:var(--text);transition:border-color .2s,box-shadow .2s;outline:none}
input:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
input::placeholder{color:var(--text-muted)}
.btn-submit{width:100%;padding:12px;background:var(--primary);color:#fff;border:none;border-radius:10px;font-family:'Inter',sans-serif;font-size:.95rem;font-weight:700;cursor:pointer;transition:all .2s;margin-top:6px;letter-spacing:-.2px}
.btn-submit:hover{background:var(--primary-dark);transform:translateY(-1px);box-shadow:0 4px 12px rgba(16,185,129,.35)}
.btn-submit:active{transform:translateY(0)}
.back-link{display:block;text-align:center;margin-top:20px;color:var(--text-muted);text-decoration:none;font-size:.86rem;transition:color .2s}
.back-link:hover{color:var(--primary)}
@keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
</style>
</head>
<body>
<button class="theme-toggle" id="themeToggle">🌙</button>

<div class="card">
  <div class="shield-icon">🛡️</div>
  <h1 class="card-title">Aero<span>Sphere</span></h1>
  <p class="card-subtitle">Administrator Portal</p>
  <div style="text-align:center"><span class="admin-badge">🔐 Secure Admin Access</span></div>

  <%
    if (error != null) {
  %>
  <div class="alert-error">⚠️ <%= HtmlUtils.e(error) %></div>
  <% } %>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <div class="form-group">
      <label>Admin Email</label>
      <input type="email" name="email" placeholder="admin@aerosphere.com" required>
    </div>
    <div class="form-group">
      <label>Password</label>
      <input type="password" name="password" placeholder="Enter your password" required>
    </div>
    <input type="hidden" name="loginType" value="ADMIN">
    <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
    <button type="submit" class="btn-submit">Login as Administrator →</button>
  </form>

  <a href="${pageContext.request.contextPath}/" class="back-link">← Back to Home</a>
</div>

<script>
  (function() {
    const saved = localStorage.getItem('aerosphere-theme');
    const sys = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    document.documentElement.setAttribute('data-theme', saved || sys);
  })();
  const btn = document.getElementById('themeToggle');
  function applyTheme(t) {
    document.documentElement.setAttribute('data-theme', t);
    btn.textContent = t === 'dark' ? '☀️' : '🌙';
    localStorage.setItem('aerosphere-theme', t);
  }
  applyTheme(document.documentElement.getAttribute('data-theme'));
  btn.addEventListener('click', () => {
    applyTheme(document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
  });
</script>
</body>
</html>
