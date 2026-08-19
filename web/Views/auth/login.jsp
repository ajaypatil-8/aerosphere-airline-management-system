<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String err       = (String) request.getAttribute("error");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) activeTab = "USER";
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign In – AeroSphere</title>
  <script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
  <style>
    /* ── LOGIN PAGE — local token overrides (monochrome + racing-green accent) ── */
    :root{
      --primary:#2E4A3D; --primary-dark:#253D33;
      --primary-glow:rgba(46,74,61,.12); --primary-glow-lg:rgba(46,74,61,.22);
      --secondary-glow:rgba(32,42,54,.07); --grad-brand:var(--primary);
      --surface-0:#FFFFFF; --surface-1:#F5F4F2; --border:#E7E5E4; --border-2:#DDDBD8;
      --text:#202A36; --text-muted:#6B7280; --text-faint:#9CA3AF; --bg:#FAFAF9;
      --radius:16px; --radius-sm:10px; --radius-full:999px;
      --trans:250ms cubic-bezier(.4,0,.2,1); --trans-fast:150ms cubic-bezier(.4,0,.2,1); --ease:cubic-bezier(.4,0,.2,1);
      --glass-bg:rgba(255,255,255,.72); --glass-blur:blur(16px);
    }
    [data-theme="dark"]{
      --primary:#4A7A63; --primary-dark:#5B8F76;
      --primary-glow:rgba(74,122,99,.16); --primary-glow-lg:rgba(74,122,99,.26);
      --secondary-glow:rgba(244,244,243,.05); --grad-brand:var(--primary);
      --surface-0:#11161D; --surface-1:#161C24; --border:#232A33; --border-2:#2B333E;
      --text:#F4F4F3; --text-muted:#A8ADB4; --text-faint:#6B7280; --bg:#060B12;
      --glass-bg:rgba(6,11,18,.72); --glass-blur:blur(16px);
    }
    body{font-family:'Inter',sans-serif; min-height:100vh; display:flex; flex-direction:column;}

    .auth-nav {
      position:sticky; top:0; z-index:500;
      display:flex; align-items:center; justify-content:space-between;
      padding:0 40px; height:64px;
      background:var(--glass-bg);
      border-bottom:1px solid var(--border);
      backdrop-filter:var(--glass-blur);
      -webkit-backdrop-filter:var(--glass-blur);
      animation:navbarDrop .5s var(--ease) both;
    }
    .nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
    .brand-icon{width:34px;height:34px;border-radius:10px;background:var(--text);color:var(--surface-0);display:flex;align-items:center;justify-content:center;font-size:14px}
    .brand-name{font-family:'Fraunces',serif;font-weight:500;font-size:1.12rem;letter-spacing:-.01em;color:var(--text)}
    .btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:var(--radius-full);font-weight:500;font-size:.83rem;text-decoration:none;cursor:pointer;border:none;font-family:'Inter',sans-serif;transition:all var(--trans-fast)}
    .btn-ghost{background:transparent;border:1px solid var(--border);color:var(--text)}
    .btn-ghost:hover{border-color:var(--text)}
    .theme-toggle{width:34px;height:34px;border:1px solid var(--border);border-radius:var(--radius-full);background:transparent;cursor:pointer;display:flex;align-items:center;justify-content:center;color:var(--text);font-size:.9rem;transition:border-color var(--trans-fast)}
    .theme-toggle:hover{border-color:var(--text)}

    /* Split layout */
    .auth-layout { flex:1; display:grid; grid-template-columns: 1fr 480px; min-height: calc(100vh - 64px); }

    /* Left visual panel */
    .auth-visual {
      position:relative; display:flex; flex-direction:column;
      justify-content:center; padding:64px 56px;
      background:var(--surface-1); border-right:1px solid var(--border);
      overflow:hidden; animation:fadeRight .7s var(--ease) both;
    }
    .auth-visual-bg {
      position:absolute; inset:0; z-index:0; pointer-events:none;
      background: radial-gradient(ellipse 70% 50% at 10% 20%, var(--primary-glow) 0%, transparent 60%),
                  radial-gradient(ellipse 50% 40% at 90% 80%, var(--secondary-glow) 0%, transparent 60%);
    }
    .auth-visual-plane {
      position:absolute; right:-10px; bottom:40px; font-size:220px; opacity:.04; transform:rotate(-12deg);
      pointer-events:none; user-select:none; z-index:0; color:var(--text); animation:floatAnim 6s ease-in-out infinite;
    }
    .auth-visual > * { position:relative; z-index:1; }

    .auth-tag {
      display:inline-flex; align-items:center; gap:8px;
      background:var(--surface-0); border:1px solid var(--border);
      border-radius:var(--radius-full); padding:6px 16px;
      font-size:.72rem; font-weight:600; letter-spacing:.08em;
      text-transform:uppercase; color:var(--text-muted); margin-bottom:28px; width:fit-content;
    }
    .auth-tag::before { content:''; width:6px; height:6px; background:var(--primary); border-radius:50%; animation:pulseDot 2s infinite; }
    @keyframes pulseDot { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.4;transform:scale(.8)} }

    .auth-heading { font-family:'Fraunces',serif; font-size:clamp(2.1rem,4vw,2.9rem); font-weight:400; letter-spacing:-.02em; line-height:1.06; margin-bottom:18px; color:var(--text); }
    .auth-desc { color:var(--text-muted); font-size:.95rem; line-height:1.7; max-width:380px; margin-bottom:36px; }

    .feature-pills { display:flex; flex-direction:column; gap:10px; }
    .fp { display:flex; align-items:center; gap:12px; background:var(--surface-0); border:1px solid var(--border);
      border-radius:var(--radius); padding:14px 16px; max-width:360px; box-shadow:var(--shadow-sm,0 1px 3px rgba(0,0,0,.05));
      transition:border-color var(--trans), transform var(--trans); }
    .fp:hover { border-color:var(--primary); transform:translateX(5px); }
    .fp-icon { width:36px; height:36px; background:var(--surface-1); border-radius:var(--radius-sm); display:flex;
      align-items:center; justify-content:center; font-size:15px; flex-shrink:0; color:var(--text); }
    .fp-title { font-size:.875rem; font-weight:600; margin-bottom:2px; }
    .fp-sub   { font-size:.76rem; color:var(--text-muted); }

    .auth-form-panel { display:flex; align-items:center; justify-content:center; padding:40px 48px; background:var(--bg);
      animation:fadeLeft .7s var(--ease) .1s both; overflow-y:auto; max-height:calc(100vh - 64px); }
    .auth-form-box { width:100%; max-width:360px; }
    .auth-form-header { margin-bottom:28px; }
    .auth-form-header h2 { font-family:'Fraunces',serif; font-size:1.65rem; font-weight:500; letter-spacing:-.02em; margin-bottom:6px; }
    .auth-form-header p { color:var(--text-muted); font-size:.9rem; }

    .auth-tabs { display:flex; background:var(--surface-1); border:1px solid var(--border-2); border-radius:var(--radius); padding:3px; margin-bottom:24px; position:relative; }
    .auth-tab-btn { flex:1; padding:9px; background:none; border:none; border-radius:11px; color:var(--text-muted);
      font-family:'Inter',sans-serif; font-size:.85rem; font-weight:500; cursor:pointer;
      transition:color var(--trans-fast), background var(--trans-fast); position:relative; z-index:1;
      display:inline-flex; align-items:center; justify-content:center; gap:6px; }
    .auth-tab-btn.active { background:var(--primary); color:#fff; box-shadow:0 3px 12px var(--primary-glow-lg); }

    .login-field { margin-bottom:18px; }
    .login-field label { display:block; font-size:.7rem; font-weight:600; text-transform:uppercase; letter-spacing:.06em;
      color:var(--text-muted); margin-bottom:7px; transition:color var(--trans-fast); }
    .login-field:focus-within label { color:var(--primary); }
    .input-wrap{display:flex;align-items:center;gap:9px;background:var(--surface-1);border:1.5px solid var(--border-2);
      border-radius:var(--radius-sm);padding:0 13px;transition:border-color var(--trans-fast),box-shadow var(--trans-fast)}
    .input-wrap:focus-within{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
    .input-icon{font-size:.9rem;flex-shrink:0;color:var(--text-faint)}
    .form-input{flex:1;border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.9rem;padding:11px 0;outline:none}
    .form-input::placeholder{color:var(--text-faint)}
    .pw-toggle{border:none;background:none;cursor:pointer;color:var(--text-faint);padding:2px 2px;font-size:.95rem;transition:color var(--trans-fast)}
    .pw-toggle:hover{color:var(--primary)}

    .alert{padding:12px 14px;border-radius:var(--radius-sm);font-size:.84rem;margin-bottom:18px;display:flex;align-items:flex-start;gap:8px}
    .alert-error{background:rgba(179,85,74,.09);border:1px solid rgba(179,85,74,.25);color:#B3554A}
    [data-theme="dark"] .alert-error{color:#D99089}

    .btn-login-submit {
      width:100%; padding:14px; margin-top:6px; background:var(--primary); border:none;
      border-radius:var(--radius-full); color:#fff; font-family:'Inter',sans-serif; font-size:.92rem; font-weight:500;
      cursor:pointer; box-shadow:0 6px 20px var(--primary-glow-lg);
      transition:transform var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast);
      display:flex; align-items:center; justify-content:center; gap:8px; position:relative; overflow:hidden;
    }
    .btn-login-submit:hover { background:var(--primary-dark); transform:translateY(-1px); box-shadow:0 10px 28px var(--primary-glow-lg); }
    .btn-login-submit:active { transform:translateY(0); }

    .divider{display:flex;align-items:center;gap:12px;margin:22px 0;color:var(--text-faint);font-size:.78rem}
    .divider::before,.divider::after{content:'';flex:1;height:1px;background:var(--border)}

    .auth-bottom { text-align:center; font-size:.875rem; color:var(--text-muted); margin-top:20px; }
    .auth-bottom a { color:var(--primary); font-weight:600; text-decoration:none; }
    .auth-bottom a:hover { color:var(--primary-dark); text-decoration:underline; }

    #adminForm { display:none; }

    @media(max-width:860px) { .auth-layout { grid-template-columns:1fr } .auth-visual { display:none } .auth-form-panel { padding:40px 24px } }
    @media(max-width:480px) { .auth-nav { padding:0 20px } .auth-form-panel { padding:32px 16px } }
  </style>
</head>
<body>

<nav class="auth-nav">
  <a href="${pageContext.request.contextPath}/" class="nav-brand">
    <div class="brand-icon"><i class="ph-bold ph-airplane-tilt"></i></div>
    <span class="brand-name">AeroSphere</span>
  </a>
  <div style="display:flex;align-items:center;gap:8px">
    <a href="${pageContext.request.contextPath}/" class="btn btn-ghost">Home</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-ghost">Create Account</a>
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle theme"><i class="ph-bold ph-moon"></i></button>
  </div>
</nav>

<div class="auth-layout">

  <div class="auth-visual">
    <div class="auth-visual-bg"></div>
    <div class="auth-visual-plane"><i class="ph-bold ph-airplane-tilt"></i></div>

    <div class="auth-tag"><i class="ph-bold ph-sparkle"></i> AeroSphere Airlines</div>

    <h1 class="auth-heading">Your next adventure awaits.</h1>

    <p class="auth-desc">Book flights, manage reservations, and track your journeys — all from one beautifully designed platform.</p>

    <div class="feature-pills">
      <div class="fp fade-up d1">
        <div class="fp-icon"><i class="ph-bold ph-airplane-tilt"></i></div>
        <div><div class="fp-title">Instant Booking</div><div class="fp-sub">Reserve seats in under 2 minutes</div></div>
      </div>
      <div class="fp fade-up d2">
        <div class="fp-icon"><i class="ph-bold ph-clipboard-text"></i></div>
        <div><div class="fp-title">Manage Trips</div><div class="fp-sub">View, modify or cancel any booking</div></div>
      </div>
      <div class="fp fade-up d3">
        <div class="fp-icon"><i class="ph-bold ph-lock-key"></i></div>
        <div><div class="fp-title">Secure Payments</div><div class="fp-sub">Safe checkout &amp; instant invoices</div></div>
      </div>
    </div>
  </div>

  <div class="auth-form-panel">
    <div class="auth-form-box">

      <div class="auth-form-header">
        <h2>Welcome back</h2>
        <p>Sign in to your AeroSphere account</p>
      </div>

      <div class="auth-tabs">
        <button class="auth-tab-btn active" id="tabUser"  onclick="switchTab('user')"><i class="ph-bold ph-airplane-tilt"></i> Passenger</button>
        <button class="auth-tab-btn"        id="tabAdmin" onclick="switchTab('admin')"><i class="ph-bold ph-shield-check"></i> Admin</button>
      </div>

      <% if (err != null) { %>
        <div class="alert alert-error">
          <span><i class="ph-bold ph-warning"></i></span>
          <span><%= HtmlUtils.e(err) %></span>
        </div>
      <% } %>

      <!-- USER FORM (all name/action attributes kept exactly) -->
      <form action="${pageContext.request.contextPath}/login" method="post" id="userForm">
        <input type="hidden" name="loginType" value="USER">
        <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">

        <div class="login-field">
          <label>Email Address</label>
          <div class="input-wrap">
            <span class="input-icon"><i class="ph-bold ph-envelope-simple"></i></span>
            <input type="email" name="email" class="form-input" placeholder="you@example.com" required autocomplete="email">
          </div>
        </div>

        <div class="login-field">
          <label>Password</label>
          <div class="input-wrap">
            <span class="input-icon"><i class="ph-bold ph-lock-simple"></i></span>
            <input type="password" name="password" id="userPw" class="form-input" placeholder="Enter your password" required autocomplete="current-password">
            <button type="button" class="pw-toggle" onclick="togglePw('userPw')" tabindex="-1"><i class="ph-bold ph-eye"></i></button>
          </div>
        </div>

        <button type="submit" class="btn-login-submit"><span>Sign In</span><span>→</span></button>
        <div style="text-align:right;margin-top:10px">
          <a href="${pageContext.request.contextPath}/forgotPassword" style="font-size:.8rem;color:var(--text-muted);text-decoration:none;transition:color .2s" onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='var(--text-muted)'">Forgot password?</a>
        </div>
      </form>

      <!-- ADMIN FORM (all name/action attributes kept exactly) -->
      <form action="${pageContext.request.contextPath}/login" method="post" id="adminForm">
        <input type="hidden" name="loginType" value="ADMIN">
        <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">

        <div class="login-field">
          <label>Admin Email</label>
          <div class="input-wrap">
            <span class="input-icon"><i class="ph-bold ph-shield-check"></i></span>
            <input type="email" name="email" class="form-input" placeholder="admin@aerosphere.com" required autocomplete="email">
          </div>
        </div>

        <div class="login-field">
          <label>Admin Password</label>
          <div class="input-wrap">
            <span class="input-icon"><i class="ph-bold ph-key"></i></span>
            <input type="password" name="password" id="adminPw" class="form-input" placeholder="Admin password" required autocomplete="current-password">
            <button type="button" class="pw-toggle" onclick="togglePw('adminPw')" tabindex="-1"><i class="ph-bold ph-eye"></i></button>
          </div>
        </div>

        <button type="submit" class="btn-login-submit"><span>Admin Sign In</span><span>→</span></button>
      </form>

      <div class="divider"><span>New to AeroSphere?</span></div>

      <div class="auth-bottom"><a href="${pageContext.request.contextPath}/register">Create a free account →</a></div>
      <div class="auth-bottom" style="margin-top:10px"><a href="${pageContext.request.contextPath}/" style="color:var(--text-muted);font-size:.82rem">← Back to Home</a></div>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  // Tab switching — logic unchanged
  var initialTab = '<%= HtmlUtils.escapeJs(activeTab) %>'.toLowerCase() === 'admin' ? 'admin' : 'user';
  switchTab(initialTab);

  function switchTab(tab) {
    document.getElementById('userForm').style.display  = tab === 'user'  ? 'block' : 'none';
    document.getElementById('adminForm').style.display = tab === 'admin' ? 'block' : 'none';
    document.getElementById('tabUser').classList.toggle('active',  tab === 'user');
    document.getElementById('tabAdmin').classList.toggle('active', tab === 'admin');
  }

  function togglePw(id) {
    var i = document.getElementById(id);
    i.type = i.type === 'password' ? 'text' : 'password';
  }

  document.querySelectorAll('.btn-login-submit').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
      var r    = document.createElement('span');
      var rect = this.getBoundingClientRect();
      var size = Math.max(rect.width, rect.height);
      r.className = 'btn-ripple';
      r.style.cssText = 'position:absolute;border-radius:50%;background:rgba(255,255,255,.28);transform:scale(0);animation:rippleAnim .6s linear;pointer-events:none;width:'+size+'px;height:'+size+'px;left:'+(e.clientX-rect.left-size/2)+'px;top:'+(e.clientY-rect.top-size/2)+'px';
      this.appendChild(r);
      r.addEventListener('animationend', function() { r.remove(); });
    });
  });
</script>
</body>
</html>
