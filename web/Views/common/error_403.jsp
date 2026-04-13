<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>403 – Access Denied | AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--sky:#0EA5E9;--sky-glow:rgba(14,165,233,.18);--em:#10B981;--em-glow:rgba(16,185,129,.18);--grad:linear-gradient(135deg,var(--sky),var(--em));--bg:#F0F9FF;--s0:#FFFFFF;--text:#0F172A;--muted:#64748B;--border:#E2E8F0}
[data-theme="dark"]{--bg:#060A12;--s0:#0D1117;--text:#F1F5F9;--muted:#94A3B8;--border:#1E293B}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;position:relative;overflow:hidden}
body::before{content:'';position:fixed;width:600px;height:600px;border-radius:50%;background:radial-gradient(circle,var(--sky-glow) 0%,transparent 70%);top:-200px;left:-200px;pointer-events:none}
body::after{content:'';position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,var(--em-glow) 0%,transparent 70%);bottom:-100px;right:-100px;pointer-events:none}
.card{text-align:center;max-width:440px;width:100%;padding:52px 40px;background:var(--s0);border:1px solid var(--border);border-radius:22px;box-shadow:0 16px 48px rgba(0,0,0,.08);animation:fadeUp .5s ease both;position:relative;overflow:hidden}
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.card-accent{position:absolute;top:0;left:0;right:0;height:4px;background:var(--grad)}
.err-icon{font-size:3.5rem;margin-bottom:10px;display:block}
.err-code{font-family:'Syne',sans-serif;font-size:6rem;font-weight:800;letter-spacing:-4px;line-height:1;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:4px}
.err-title{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;margin:12px 0 10px}
.err-desc{color:var(--muted);font-size:.88rem;line-height:1.6;margin-bottom:28px}
.actions{display:flex;gap:10px;justify-content:center;flex-wrap:wrap}
.btn{display:inline-flex;align-items:center;gap:7px;padding:11px 22px;border-radius:9px;font-family:'DM Sans',sans-serif;font-weight:700;font-size:.88rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none}
.btn-grad{background:var(--grad);color:#fff;box-shadow:0 4px 14px var(--sky-glow)}
.btn-grad:hover{opacity:.9;transform:translateY(-1px)}
.btn-ghost{background:var(--bg);border:1.5px solid var(--border);color:var(--muted)}
.btn-ghost:hover{border-color:var(--sky);color:var(--sky)}
.theme-btn{position:fixed;top:20px;right:20px;width:36px;height:36px;border:1px solid var(--border);border-radius:9px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.85rem;color:var(--muted)}
</style>
</head>
<body>
<button class="theme-btn" id="themeToggle">🌙</button>
<div class="card">
  <div class="card-accent"></div>
  <span class="err-icon">🔒</span>
  <div class="err-code">403</div>
  <div class="err-title">Access Denied</div>
  <p class="err-desc">You don't have permission to view this page. Please sign in with an appropriate account.</p>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/login" class="btn btn-grad">Sign In</a>
      <a href="${pageContext.request.contextPath}/" class="btn btn-ghost">← Home</a>
  </div>
  
</div>
<script>
(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){var c=document.documentElement.getAttribute('data-theme');var n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.textContent=n==='dark'?'☀️':'🌙';});
</script>
</body>
</html>