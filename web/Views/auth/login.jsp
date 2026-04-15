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
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
  <style>
    /* ── LOGIN PAGE SPECIFIC ──────────────────────────────────── */
    body { min-height:100vh; display:flex; flex-direction:column; }

    /* Navbar override for auth pages */
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

    /* Split layout */
    .auth-layout {
      flex:1;
      display:grid;
      grid-template-columns: 1fr 480px;
      min-height: calc(100vh - 64px);
    }

    /* Left visual panel */
    .auth-visual {
      position:relative;
      display:flex; flex-direction:column;
      justify-content:center; padding:64px 56px;
      background:var(--surface-0);
      border-right:1px solid var(--border);
      overflow:hidden;
      animation:fadeRight .7s var(--ease) both;
    }
    .auth-visual-bg {
      position:absolute; inset:0; z-index:0; pointer-events:none;
      background:
        radial-gradient(ellipse 70% 50% at 10% 20%, var(--primary-glow) 0%, transparent 60%),
        radial-gradient(ellipse 50% 40% at 90% 80%, var(--secondary-glow) 0%, transparent 60%);
    }
    .auth-visual-plane {
      position:absolute; right:-10px; bottom:40px;
      font-size:220px; opacity:.035; transform:rotate(-12deg);
      pointer-events:none; user-select:none; z-index:0;
      animation:floatAnim 6s ease-in-out infinite;
    }
    .auth-visual > * { position:relative; z-index:1; }

    .auth-tag {
      display:inline-flex; align-items:center; gap:8px;
      background:var(--primary-glow); border:1px solid rgba(14,165,233,.35);
      border-radius:var(--radius-full); padding:6px 16px;
      font-size:.76rem; font-weight:700; letter-spacing:.09em;
      text-transform:uppercase; color:var(--primary); margin-bottom:28px; width:fit-content;
    }
    .auth-tag::before {
      content:''; width:6px; height:6px; background:var(--primary);
      border-radius:50%; animation:pulseDot 2s infinite;
    }
    @keyframes pulseDot { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.4;transform:scale(.8)} }

    .auth-heading {
      font-family:'Syne',sans-serif;
      font-size:clamp(2.2rem,4vw,3rem);
      font-weight:800; letter-spacing:-.05em; line-height:1.08;
      margin-bottom:18px; color:var(--text);
    }
    .auth-heading .g {
      background:var(--grad-brand);
      -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
    }
    .auth-desc {
      color:var(--text-muted); font-size:.95rem; line-height:1.7;
      max-width:380px; margin-bottom:36px;
    }

    /* Feature pills */
    .feature-pills { display:flex; flex-direction:column; gap:10px; }
    .fp {
      display:flex; align-items:center; gap:12px;
      background:var(--surface-0); border:1px solid var(--border);
      border-radius:var(--radius); padding:14px 16px; max-width:360px;
      box-shadow:var(--shadow-sm);
      transition:border-color var(--trans), transform var(--trans);
    }
    .fp:hover { border-color:var(--primary); transform:translateX(5px); }
    .fp-icon {
      width:36px; height:36px; background:var(--primary-glow);
      border-radius:var(--radius-sm); display:flex;
      align-items:center; justify-content:center; font-size:16px; flex-shrink:0;
    }
    .fp-title { font-size:.875rem; font-weight:600; margin-bottom:2px; }
    .fp-sub   { font-size:.76rem; color:var(--text-muted); }

    /* Right form panel */
    .auth-form-panel {
      display:flex; align-items:center; justify-content:center;
      padding:40px 48px; background:var(--bg);
      animation:fadeLeft .7s var(--ease) .1s both;
    }
    .auth-form-box { width:100%; max-width:360px; }

    .auth-form-header { margin-bottom:28px; }
    .auth-form-header h2 {
      font-family:'Syne',sans-serif;
      font-size:1.75rem; font-weight:800; letter-spacing:-.05em; margin-bottom:6px;
    }
    .auth-form-header p { color:var(--text-muted); font-size:.9rem; }

    /* Tab switcher */
    .auth-tabs {
      display:flex; background:var(--surface-1);
      border:1px solid var(--border-2); border-radius:var(--radius);
      padding:3px; margin-bottom:24px;
      position:relative;
    }
    .auth-tab-btn {
      flex:1; padding:9px; background:none; border:none;
      border-radius:9px; color:var(--text-muted);
      font-family:'DM Sans',sans-serif; font-size:.875rem; font-weight:600;
      cursor:pointer; transition:color var(--trans-fast), background var(--trans-fast);
      position:relative; z-index:1;
    }
    .auth-tab-btn.active {
      background:var(--grad-brand); color:#fff;
      box-shadow:0 3px 12px var(--primary-glow-lg);
    }

    /* Field */
    .login-field { margin-bottom:18px; }
    .login-field label {
      display:block; font-size:.72rem; font-weight:700;
      text-transform:uppercase; letter-spacing:.07em;
      color:var(--text-muted); margin-bottom:7px;
      transition:color var(--trans-fast);
    }
    .login-field:focus-within label { color:var(--primary); }

    /* Submit btn */
    .btn-login-submit {
      width:100%; padding:14px; margin-top:6px;
      background:var(--grad-brand); border:none;
      border-radius:var(--radius); color:#fff;
      font-family:'DM Sans',sans-serif; font-size:.95rem; font-weight:700;
      cursor:pointer; box-shadow:0 6px 20px var(--primary-glow-lg);
      transition:transform var(--trans-fast), box-shadow var(--trans-fast);
      display:flex; align-items:center; justify-content:center; gap:8px;
      position:relative; overflow:hidden;
    }
    .btn-login-submit:hover {
      transform:translateY(-2px);
      box-shadow:0 10px 28px var(--primary-glow-lg);
    }
    .btn-login-submit:active { transform:translateY(0); }

    /* Register link */
    .auth-bottom { text-align:center; font-size:.875rem; color:var(--text-muted); margin-top:20px; }
    .auth-bottom a { color:var(--primary); font-weight:600; }
    .auth-bottom a:hover { color:var(--primary-dark); text-decoration:underline; }

    #adminForm { display:none; }

    @media(max-width:860px) {
      .auth-layout { grid-template-columns:1fr }
      .auth-visual  { display:none }
      .auth-form-panel { padding:40px 24px }
    }
    @media(max-width:480px) {
      .auth-nav { padding:0 20px }
      .auth-form-panel { padding:32px 16px }
    }
  </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="auth-nav">
  <a href="${pageContext.request.contextPath}/" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>
  <div style="display:flex;align-items:center;gap:8px">
    <a href="${pageContext.request.contextPath}/" class="btn btn-ghost btn-sm">Home</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-ghost btn-sm">Create Account</a>
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle theme">🌙</button>
  </div>
</nav>

<!-- LAYOUT -->
<div class="auth-layout">

  <!-- LEFT VISUAL PANEL -->
  <div class="auth-visual">
    <div class="auth-visual-bg"></div>
    <div class="auth-visual-plane">✈</div>

    <div class="auth-tag">✦ AeroSphere Airlines</div>

    <h1 class="auth-heading">
      Your Next<br>
      <span class="g">Adventure</span><br>
      Awaits.
    </h1>

    <p class="auth-desc">
      Book flights, manage reservations, and track your journeys —
      all from one beautifully designed platform.
    </p>

    <div class="feature-pills">
      <div class="fp fade-up d1">
        <div class="fp-icon">✈</div>
        <div>
          <div class="fp-title">Instant Booking</div>
          <div class="fp-sub">Reserve seats in under 2 minutes</div>
        </div>
      </div>
      <div class="fp fade-up d2">
        <div class="fp-icon">📋</div>
        <div>
          <div class="fp-title">Manage Trips</div>
          <div class="fp-sub">View, modify or cancel any booking</div>
        </div>
      </div>
      <div class="fp fade-up d3">
        <div class="fp-icon">🔒</div>
        <div>
          <div class="fp-title">Secure Payments</div>
          <div class="fp-sub">Safe checkout &amp; instant invoices</div>
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT FORM PANEL -->
  <div class="auth-form-panel">
    <div class="auth-form-box">

      <div class="auth-form-header">
        <h2>Welcome back</h2>
        <p>Sign in to your AeroSphere account</p>
      </div>

      <!-- TABS -->
      <div class="auth-tabs">
        <button class="auth-tab-btn active" id="tabUser"  onclick="switchTab('user')">✈ Passenger</button>
        <button class="auth-tab-btn"        id="tabAdmin" onclick="switchTab('admin')">🛡 Admin</button>
      </div>

      <% if (err != null) { %>
        <div class="alert alert-error">
          <span>⚠</span>
          <span><%= HtmlUtils.e(err) %></span>
        </div>
      <% } %>

      <!-- USER FORM (KEEP ALL name/action ATTRIBUTES EXACTLY) -->
      <form action="${pageContext.request.contextPath}/login" method="post" id="userForm">
        <input type="hidden" name="loginType" value="USER">
        <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">

        <div class="login-field">
          <label>Email Address</label>
          <div class="input-wrap">
            <span class="input-icon">✉</span>
            <input type="email" name="email" class="form-input"
                   placeholder="you@example.com" required autocomplete="email">
          </div>
        </div>

        <div class="login-field">
          <label>Password</label>
          <div class="input-wrap" style="position:relative">
            <span class="input-icon">🔒</span>
            <input type="password" name="password" id="userPw" class="form-input"
                   placeholder="Enter your password" required autocomplete="current-password">
            <button type="button" class="pw-toggle" onclick="togglePw('userPw')" tabindex="-1">👁</button>
          </div>
        </div>

        <button type="submit" class="btn-login-submit">
          <span>Sign In</span><span>→</span>
        </button>
        <div style="text-align:right;margin-top:10px">
          <a href="${pageContext.request.contextPath}/forgotPassword" style="font-size:.8rem;color:var(--text-muted);text-decoration:none;transition:color .2s" onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='var(--text-muted)'">Forgot password?</a>
        </div>
      </form>

      <!-- ADMIN FORM (KEEP ALL name/action ATTRIBUTES EXACTLY) -->
      <form action="${pageContext.request.contextPath}/login" method="post" id="adminForm">
        <input type="hidden" name="loginType" value="ADMIN">
        <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">

        <div class="login-field">
          <label>Admin Email</label>
          <div class="input-wrap">
            <span class="input-icon">🛡</span>
            <input type="email" name="email" class="form-input"
                   placeholder="admin@aerosphere.com" required autocomplete="email">
          </div>
        </div>

        <div class="login-field">
          <label>Admin Password</label>
          <div class="input-wrap" style="position:relative">
            <span class="input-icon">🔑</span>
            <input type="password" name="password" id="adminPw" class="form-input"
                   placeholder="Admin password" required autocomplete="current-password">
            <button type="button" class="pw-toggle" onclick="togglePw('adminPw')" tabindex="-1">👁</button>
          </div>
        </div>

        <button type="submit" class="btn-login-submit">
          <span>Admin Sign In</span><span>→</span>
        </button>
      </form>

      <div class="divider"><span>New to AeroSphere?</span></div>

      <div class="auth-bottom">
        <a href="${pageContext.request.contextPath}/register">Create a free account →</a>
      </div>
      <div class="auth-bottom" style="margin-top:10px">
        <a href="${pageContext.request.contextPath}/" style="color:var(--text-muted);font-size:.82rem">← Back to Home</a>
      </div>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  // Tab switching — keep EXACTLY the same logic
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

  // Ripple on submit buttons
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
