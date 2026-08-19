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
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>
:root{--sky:#2E4A3D;--sky-dark:#253D33;--sky-glow:rgba(46,74,61,.14);--em:#5B8A6E;--em-dark:#3E6350;--em-glow:rgba(91,138,110,.14);--warn:#B8863F;--warn-glow:rgba(184,134,63,.12);--grad:var(--sky);--bg:#FAFAF9;--s0:#FFFFFF;--s1:#F5F4F2;--text:#202A36;--muted:#6B7280;--border:#E7E5E4;--sh:0 1px 3px rgba(0,0,0,.05),0 4px 16px rgba(0,0,0,.04);--sh-lg:0 16px 48px rgba(0,0,0,.08);--r:16px}
[data-theme="dark"]{--sky:#4A7A63;--sky-dark:#5B8F76;--sky-glow:rgba(74,122,99,.18);--em:#6FAE8B;--em-dark:#5B9977;--em-glow:rgba(111,174,139,.16);--warn:#D1A25C;--warn-glow:rgba(209,162,92,.14);--bg:#060B12;--s0:#11161D;--s1:#161C24;--text:#F4F4F3;--muted:#A8ADB4;--border:#232A33;--sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);--sh-lg:0 16px 48px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;position:relative;overflow:hidden}
body::before{content:'';position:fixed;width:700px;height:700px;border-radius:50%;background:radial-gradient(circle,var(--sky-glow) 0%,transparent 70%);top:-200px;left:-200px;pointer-events:none}
body::after{content:'';position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,var(--em-glow) 0%,transparent 70%);bottom:-100px;right:-100px;pointer-events:none}
.theme-btn{position:fixed;top:20px;right:20px;width:38px;height:38px;border:1px solid var(--border);border-radius:999px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;color:var(--muted);transition:all .2s;z-index:10}
.theme-btn:hover{border-color:var(--sky);color:var(--sky)}
.back-home{position:fixed;top:20px;left:20px;display:flex;align-items:center;gap:6px;text-decoration:none;color:var(--muted);font-size:.82rem;font-weight:500;transition:color .2s;z-index:10}
.back-home:hover{color:var(--sky)}
.card{width:100%;max-width:400px;background:var(--s0);border:1px solid var(--border);border-radius:var(--r);box-shadow:var(--sh-lg);overflow:hidden;position:relative;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.card-top{height:4px;background:var(--grad)}
.card-body{padding:36px 32px}
.shield-wrap{width:56px;height:56px;border-radius:14px;background:var(--sky-glow);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.5rem;margin:0 auto 18px;color:var(--sky)}
.card-title{font-family:'Fraunces',serif;font-size:1.35rem;font-weight:400;letter-spacing:-.01em;text-align:center;margin-bottom:4px}
.card-title span{color:var(--sky)}
.card-sub{text-align:center;color:var(--muted);font-size:.84rem;margin-bottom:20px}
.admin-badge{display:flex;align-items:center;gap:6px;background:var(--warn-glow);color:var(--warn);border:1px solid rgba(184,134,63,.3);border-radius:999px;padding:5px 14px;font-size:.7rem;font-weight:600;letter-spacing:.05em;text-transform:uppercase;width:fit-content;margin:0 auto 24px}
.alert-error{background:rgba(179,85,74,.09);border:1px solid rgba(179,85,74,.22);color:#B3554A;border-radius:10px;padding:11px 14px;font-size:.84rem;margin-bottom:20px;display:flex;align-items:center;gap:8px}
[data-theme="dark"] .alert-error{color:#D99089}
.form-group{margin-bottom:16px}
.form-label{display:block;font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);margin-bottom:7px}
.field-wrap{display:flex;align-items:center;gap:9px;background:var(--s1);border:1.5px solid var(--border);border-radius:10px;padding:0 13px;transition:border-color .2s,box-shadow .2s}
.field-wrap:focus-within{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.fi{font-size:.9rem;flex-shrink:0;color:var(--muted)}
.field-wrap input{flex:1;border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.9rem;padding:11px 0;outline:none}
.field-wrap input::placeholder{color:var(--muted);opacity:.65}
.btn-submit{width:100%;padding:13px;background:var(--sky);color:#fff;border:none;border-radius:999px;font-family:'Inter',sans-serif;font-size:.92rem;font-weight:500;cursor:pointer;transition:all .2s;box-shadow:0 4px 14px var(--sky-glow);margin-top:6px}
.btn-submit:hover{background:var(--sky-dark);transform:translateY(-1px);box-shadow:0 6px 20px var(--sky-glow)}
.back-link{display:block;text-align:center;margin-top:20px;color:var(--muted);text-decoration:none;font-size:.84rem;transition:color .2s}
.back-link:hover{color:var(--sky)}
.pw-toggle-btn{border:none;background:none;cursor:pointer;color:var(--muted);padding:0 4px;font-size:.9rem;transition:color .2s}
.pw-toggle-btn:hover{color:var(--sky)}
</style>
</head>
<body>
<button class="theme-btn" id="themeToggle"><i class="ph-bold ph-moon"></i></button>
<a href="${pageContext.request.contextPath}/" class="back-home"><i class="ph-bold ph-arrow-left"></i> Home</a>

<div class="card">
  <div class="card-top"></div>
  <div class="card-body">
    <div class="shield-wrap"><i class="ph-bold ph-shield-check"></i></div>
    <h1 class="card-title">Aero<span>Sphere</span></h1>
    <p class="card-sub">Administrator Portal</p>
    <div class="admin-badge"><i class="ph-bold ph-lock-key"></i> Secure Admin Access</div>

    <% if (error != null) { %>
    <div class="alert-error"><i class="ph-bold ph-warning"></i> <%= HtmlUtils.e(error) %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
      <div class="form-group">
        <label class="form-label">Admin Email</label>
        <div class="field-wrap"><span class="fi"><i class="ph-bold ph-envelope-simple"></i></span>
          <input type="email" name="email" placeholder="admin@aerosphere.com" required autocomplete="email">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <div class="field-wrap" style="position:relative"><span class="fi"><i class="ph-bold ph-lock-simple"></i></span>
          <input type="password" name="password" id="adminPwd" placeholder="Enter admin password" required>
          <button type="button" class="pw-toggle-btn" onclick="var i=document.getElementById('adminPwd');i.type=i.type==='password'?'text':'password'"><i class="ph-bold ph-eye"></i></button>
        </div>
        <div style="text-align:right;margin-top:6px">
          <a href="${pageContext.request.contextPath}/forgotPassword" style="font-size:.76rem;color:var(--muted);text-decoration:none">Forgot password?</a>
        </div>
      </div>
      <input type="hidden" name="loginType" value="ADMIN">
      <button type="submit" class="btn-submit">Sign in to admin panel →</button>
    </form>
    <a href="${pageContext.request.contextPath}/login" class="back-link">← Back to user login</a>
  </div>
</div>

<script>
(function(){const s=localStorage.getItem('asTheme')||'light';document.documentElement.setAttribute('data-theme',s);document.getElementById('themeToggle').innerHTML=s==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';})();
document.getElementById('themeToggle').addEventListener('click',function(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.innerHTML=n==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';});
</script>
</body>
</html>
