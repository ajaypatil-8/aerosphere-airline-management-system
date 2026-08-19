<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>404 – Page Not Found | AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--sky:#2E4A3D;--sky-glow:rgba(46,74,61,.16);--em:#5B8A6E;--em-glow:rgba(91,138,110,.14);--grad:var(--sky);--bg:#FAFAF9;--s0:#FFFFFF;--text:#202A36;--muted:#6B7280;--border:#E7E5E4}
[data-theme="dark"]{--sky:#4A7A63;--sky-glow:rgba(74,122,99,.2);--em:#6FAE8B;--bg:#060B12;--s0:#11161D;--text:#F4F4F3;--muted:#A8ADB4;--border:#232A33}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;position:relative;overflow:hidden}
body::before{content:'';position:fixed;width:600px;height:600px;border-radius:50%;background:radial-gradient(circle,var(--sky-glow) 0%,transparent 70%);top:-200px;left:-200px;pointer-events:none}
body::after{content:'';position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,var(--em-glow) 0%,transparent 70%);bottom:-100px;right:-100px;pointer-events:none}
.card{text-align:center;max-width:440px;width:100%;padding:52px 40px;background:var(--s0);border:1px solid var(--border);border-radius:22px;box-shadow:0 16px 48px rgba(0,0,0,.08);animation:fadeUp .5s ease both;position:relative;overflow:hidden}
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.card-accent{position:absolute;top:0;left:0;right:0;height:4px;background:var(--grad)}
.err-icon{font-size:3.5rem;margin-bottom:10px;display:block}
.err-code{font-family:'Fraunces',sans-serif;font-size:6rem;font-weight:800;letter-spacing:-4px;line-height:1;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:4px}
.err-title{font-family:'Fraunces',sans-serif;font-size:1.35rem;font-weight:800;margin:12px 0 10px}
.err-desc{color:var(--muted);font-size:.88rem;line-height:1.6;margin-bottom:28px}
.actions{display:flex;gap:10px;justify-content:center;flex-wrap:wrap}
.btn{display:inline-flex;align-items:center;gap:7px;padding:11px 22px;border-radius:999px;font-family:'Inter',sans-serif;font-weight:700;font-size:.88rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none}
.btn-grad{background:var(--grad);color:#fff;box-shadow:0 4px 14px var(--sky-glow)}
.btn-grad:hover{opacity:.9;transform:translateY(-1px)}
.btn-ghost{background:var(--bg);border:1.5px solid var(--border);color:var(--muted)}
.btn-ghost:hover{border-color:var(--sky);color:var(--sky)}
.theme-btn{position:fixed;top:20px;right:20px;width:36px;height:36px;border:1px solid var(--border);border-radius:999px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.85rem;color:var(--muted)}
</style>
</head>
<body>
<button class="theme-btn" id="themeToggle"><i class="ph-bold ph-moon"></i></button>
<div class="card">
  <div class="card-accent"></div>
  <span class="err-icon"><i class="ph-bold ph-airplane-tilt"></i></span>
  <div class="err-code">404</div>
  <div class="err-title">Page Not Found</div>
  <p class="err-desc">The page you're looking for doesn't exist or has been moved. Let's get you back on track.</p>
  <div class="actions">
    <a href="${pageContext.request.contextPath}/" class="btn btn-grad"><i class="ph-bold ph-house"></i> Back to Home</a>
      <a href="javascript:history.back()" class="btn btn-ghost">← Go Back</a>
  </div>
  
</div>
<script>
(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);document.getElementById('themeToggle').innerHTML=t==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';})();
document.getElementById('themeToggle').addEventListener('click',function(){var c=document.documentElement.getAttribute('data-theme');var n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.innerHTML=n==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';});
</script>
</body>
</html>