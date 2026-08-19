<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String error    = (String) request.getAttribute("error");
    String success  = (String) request.getAttribute("success");
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Account – AeroSphere</title>
  <script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
  <style>
    :root{
      --primary:#2E4A3D; --primary-dark:#253D33;
      --primary-glow:rgba(46,74,61,.12); --primary-glow-lg:rgba(46,74,61,.22);
      --grad-brand:var(--primary);
      --surface-0:#FFFFFF; --surface-1:#F5F4F2; --border:#E7E5E4; --border-2:#DDDBD8;
      --text:#202A36; --text-muted:#6B7280; --text-faint:#9CA3AF; --bg:#FAFAF9;
      --radius:16px; --radius-sm:10px; --radius-full:999px; --radius-xl:22px;
      --trans:250ms cubic-bezier(.4,0,.2,1); --trans-fast:150ms cubic-bezier(.4,0,.2,1); --ease:cubic-bezier(.4,0,.2,1);
      --glass-bg:rgba(255,255,255,.72); --glass-blur:blur(16px);
      --danger:#B3554A; --warning:#B8863F; --success:#5B8A6E;
      --shadow-xl:0 24px 64px rgba(0,0,0,.10);
    }
    [data-theme="dark"]{
      --primary:#4A7A63; --primary-dark:#5B8F76;
      --primary-glow:rgba(74,122,99,.16); --primary-glow-lg:rgba(74,122,99,.26);
      --grad-brand:var(--primary);
      --surface-0:#11161D; --surface-1:#161C24; --border:#232A33; --border-2:#2B333E;
      --text:#F4F4F3; --text-muted:#A8ADB4; --text-faint:#6B7280; --bg:#060B12;
      --glass-bg:rgba(6,11,18,.72); --glass-blur:blur(16px);
      --danger:#C77A70; --warning:#D1A25C; --success:#6FAE8B;
      --shadow-xl:0 24px 64px rgba(0,0,0,.55);
    }
    body{font-family:'Inter',sans-serif; min-height:100vh; display:flex; flex-direction:column;}

    .auth-nav { position:sticky; top:0; z-index:500; display:flex; align-items:center; justify-content:space-between;
      padding:0 40px; height:64px; background:var(--glass-bg); border-bottom:1px solid var(--border);
      backdrop-filter:var(--glass-blur); -webkit-backdrop-filter:var(--glass-blur); animation:navbarDrop .5s var(--ease) both; }
    .nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
    .brand-icon{width:34px;height:34px;border-radius:10px;background:var(--text);color:var(--surface-0);display:flex;align-items:center;justify-content:center;font-size:14px}
    .brand-name{font-family:'Fraunces',serif;font-weight:500;font-size:1.12rem;letter-spacing:-.01em;color:var(--text)}
    .btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:var(--radius-full);font-weight:500;font-size:.83rem;text-decoration:none;cursor:pointer;border:none;font-family:'Inter',sans-serif;transition:all var(--trans-fast)}
    .btn-ghost{background:transparent;border:1px solid var(--border);color:var(--text)}
    .btn-ghost:hover{border-color:var(--text)}
    .btn-primary{background:var(--primary);color:#fff}
    .btn-primary:hover{background:var(--primary-dark)}
    .theme-toggle{width:34px;height:34px;border:1px solid var(--border);border-radius:var(--radius-full);background:transparent;cursor:pointer;display:flex;align-items:center;justify-content:center;color:var(--text);font-size:.9rem}

    .page-outer { flex:1; display:flex; align-items:flex-start; justify-content:center; padding:40px 20px 60px;
      background: radial-gradient(ellipse 80% 50% at 50% 0%, var(--primary-glow) 0%, transparent 60%); }
    .reg-container { width:100%; max-width:680px; animation:fadeUp .6s var(--ease) .1s both; }

    .reg-header { text-align:center; margin-bottom:28px; }
    .reg-badge { display:inline-flex; align-items:center; gap:8px; background:var(--surface-0); border:1px solid var(--border);
      border-radius:var(--radius-full); padding:6px 16px; font-size:.72rem; font-weight:600; letter-spacing:.08em;
      text-transform:uppercase; color:var(--text-muted); margin-bottom:16px; }
    .reg-badge::before { content:''; width:6px; height:6px; background:var(--primary); border-radius:50%; animation:pulseDot 2s infinite; }
    @keyframes pulseDot{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.4;transform:scale(.8)}}
    .reg-header h1 { font-family:'Fraunces',serif; font-size:2rem; font-weight:400; letter-spacing:-.02em; margin-bottom:8px; }
    .reg-header h1 span { color:var(--primary); }
    .reg-header p { color:var(--text-muted); font-size:.9rem; }

    .reg-card { background:var(--surface-0); border:1px solid var(--border); border-radius:var(--radius-xl);
      padding:36px; box-shadow:var(--shadow-xl); position:relative; overflow:hidden; }
    .reg-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:var(--grad-brand); }

    .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:18px; }
    .form-grid .full { grid-column:1/-1; }
    .section-sep { grid-column:1/-1; display:flex; align-items:center; gap:10px; margin:6px 0; }
    .section-sep span { font-size:.68rem; font-weight:600; color:var(--text-faint); text-transform:uppercase; letter-spacing:.09em; white-space:nowrap; }
    .section-sep::before,.section-sep::after { content:''; flex:1; height:1px; background:var(--border); }

    .field { display:flex; flex-direction:column; gap:7px; }
    .field label { font-size:.7rem; font-weight:600; text-transform:uppercase; letter-spacing:.06em; color:var(--text-muted); }
    .field:focus-within label { color:var(--primary); }
    .field-wrap { position:relative; }
    .field-icon { position:absolute; left:13px; top:50%; transform:translateY(-50%); font-size:14px; pointer-events:none; z-index:1; color:var(--text-faint); transition:color var(--trans-fast); }
    .field:focus-within .field-icon { color:var(--primary); }
    .field-wrap input, .field-wrap select, .field-wrap textarea {
      width:100%; background:var(--surface-1); border:1.5px solid var(--border-2); border-radius:var(--radius-sm);
      padding:12px 14px 12px 40px; color:var(--text); font-family:'Inter',sans-serif; font-size:.9rem; outline:none;
      transition:border-color var(--trans-fast),box-shadow var(--trans-fast),background var(--trans-fast); appearance:none; }
    .field-wrap textarea { padding:12px 14px 12px 40px; height:76px; resize:none; }
    .field-wrap input::placeholder, .field-wrap textarea::placeholder { color:var(--text-faint); }
    .field-wrap input:focus, .field-wrap select:focus, .field-wrap textarea:focus {
      border-color:var(--primary); background:var(--surface-0); box-shadow:0 0 0 3px var(--primary-glow); }
    [data-theme="dark"] input[type="date"]::-webkit-calendar-picker-indicator { filter:invert(1); }
    .toggle-pw { position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; color:var(--text-faint); cursor:pointer; font-size:14px; }
    .toggle-pw:hover { color:var(--primary); }

    .strength-bar { display:flex; gap:4px; margin-top:6px; }
    .strength-seg { flex:1; height:3px; border-radius:var(--radius-full); background:var(--border-2); transition:background .3s; }
    .seg-weak   { background:var(--danger); }
    .seg-medium { background:var(--warning); }
    .seg-strong { background:var(--success); }

    .email-otp-row { display:flex; gap:8px; align-items:flex-end; }
    .email-otp-row .field-wrap { flex:1; }
    .btn-send-otp { flex-shrink:0; padding:0 18px; height:46px; background:var(--primary); border:none; border-radius:var(--radius-full);
      color:#fff; font-family:'Inter',sans-serif; font-size:.8rem; font-weight:500; cursor:pointer; white-space:nowrap;
      box-shadow:0 4px 14px var(--primary-glow-lg); transition:transform var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast); }
    .btn-send-otp:hover { background:var(--primary-dark); transform:translateY(-1px); }
    .btn-send-otp:disabled { opacity:.5; cursor:not-allowed; transform:none; }
    .otp-status { font-size:.75rem; margin-top:5px; min-height:16px; }
    .otp-status.ok  { color:var(--success); font-weight:600; }
    .otp-status.err { color:var(--danger); font-weight:600; }

    .btn-submit { width:100%; padding:15px; margin-top:10px; background:var(--primary); border:none; border-radius:var(--radius-full);
      color:#fff; font-family:'Inter',sans-serif; font-size:.92rem; font-weight:500; cursor:pointer; box-shadow:0 6px 20px var(--primary-glow-lg);
      display:flex; align-items:center; justify-content:center; gap:8px; transition:transform var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast); }
    .btn-submit:hover { background:var(--primary-dark); transform:translateY(-1px); }
    .btn-submit:disabled { opacity:.5; cursor:not-allowed; transform:none; }

    .form-footer { text-align:center; margin-top:20px; color:var(--text-muted); font-size:.875rem; }
    .form-footer a { color:var(--primary); font-weight:600; text-decoration:none; }
    .form-footer a:hover { text-decoration:underline; }

    .alert{padding:12px 14px;border-radius:var(--radius-sm);font-size:.84rem;margin-bottom:18px;display:flex;align-items:flex-start;gap:8px}
    .alert-error{background:rgba(179,85,74,.09);border:1px solid rgba(179,85,74,.25);color:#B3554A}
    .alert-success{background:rgba(91,138,110,.1);border:1px solid rgba(91,138,110,.3);color:#3E6350}
    [data-theme="dark"] .alert-error{color:#D99089}
    [data-theme="dark"] .alert-success{color:#8FC5A8}

    .modal-overlay { display:none; position:fixed; inset:0; background:rgba(6,11,18,.6); backdrop-filter:blur(8px);
      z-index:1000; align-items:center; justify-content:center; }
    .modal-overlay.open { display:flex; }
    .modal-box { background:var(--surface-0); border:1px solid var(--border-2); border-radius:var(--radius-xl);
      padding:36px 32px; max-width:420px; width:90%; box-shadow:var(--shadow-xl); animation:zoomIn .35s var(--ease); position:relative; overflow:hidden; }
    .modal-box::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:var(--grad-brand); }
    .modal-icon { font-size:2.2rem; text-align:center; margin-bottom:12px; color:var(--primary); }
    .modal-title { font-family:'Fraunces',serif; font-size:1.25rem; font-weight:500; text-align:center; margin-bottom:6px; letter-spacing:-.01em; }
    .modal-sub { font-size:.875rem; color:var(--text-muted); text-align:center; margin-bottom:24px; line-height:1.6; }
    .modal-sub strong { color:var(--primary); }

    .otp-input-wrap { display:flex; gap:8px; justify-content:center; margin-bottom:20px; }
    .otp-digit { width:48px; height:56px; text-align:center; font-family:'Fraunces',serif; font-size:1.4rem; font-weight:500;
      border:2px solid var(--border-2); border-radius:var(--radius-sm); background:var(--surface-1); color:var(--text); outline:none;
      transition:border-color var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast); }
    .otp-digit:focus { border-color:var(--primary); box-shadow:0 0 0 3px var(--primary-glow); background:var(--surface-0); }
    .otp-digit:not(:placeholder-shown) { border-color:var(--primary); background:var(--primary-glow); }

    .modal-error { color:var(--danger); font-size:.82rem; text-align:center; min-height:18px; margin-bottom:12px; font-weight:600; }
    .btn-verify { width:100%; padding:14px; background:var(--primary); border:none; border-radius:var(--radius-full); color:#fff;
      font-family:'Inter',sans-serif; font-size:.92rem; font-weight:500; cursor:pointer; box-shadow:0 6px 20px var(--primary-glow-lg);
      transition:transform var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast); }
    .btn-verify:hover { background:var(--primary-dark); transform:translateY(-1px); }
    .btn-verify:disabled { opacity:.45; cursor:not-allowed; transform:none; }
    .modal-resend { text-align:center; margin-top:14px; font-size:.82rem; color:var(--text-muted); }
    .modal-resend button { background:none; border:none; color:var(--primary); cursor:pointer; font-weight:600; font-size:.82rem; }
    .modal-resend button:hover { color:var(--primary-dark); }
    .modal-resend button:disabled { color:var(--text-faint); cursor:not-allowed; }

    @media(max-width:600px) {
      .auth-nav { padding:0 20px } .reg-card { padding:24px 18px } .reg-header h1 { font-size:1.6rem }
      .form-grid { grid-template-columns:1fr } .form-grid .full { grid-column:1 }
      .email-otp-row { flex-direction:column; align-items:stretch } .btn-send-otp { height:46px }
      .otp-digit { width:42px; height:50px; font-size:1.15rem }
    }
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
    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Sign In</a>
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()" aria-label="Toggle theme"><i class="ph-bold ph-moon"></i></button>
  </div>
</nav>

<!-- OTP MODAL (IDs kept identical to original for JS compatibility) -->
<div class="modal-overlay" id="otpModal">
  <div class="modal-box">
    <div class="modal-icon"><i class="ph-bold ph-envelope-simple-open"></i></div>
    <div class="modal-title">Verify your email</div>
    <div class="modal-sub">We sent a 6-digit code to<br><strong id="modalEmailDisplay"></strong></div>
    <div class="otp-input-wrap">
      <input class="otp-digit" type="text" maxlength="1" inputmode="numeric" id="d0" oninput="otpInput(this,0)" placeholder="·">
      <input class="otp-digit" type="text" maxlength="1" inputmode="numeric" id="d1" oninput="otpInput(this,1)" placeholder="·">
      <input class="otp-digit" type="text" maxlength="1" inputmode="numeric" id="d2" oninput="otpInput(this,2)" placeholder="·">
      <input class="otp-digit" type="text" maxlength="1" inputmode="numeric" id="d3" oninput="otpInput(this,3)" placeholder="·">
      <input class="otp-digit" type="text" maxlength="1" inputmode="numeric" id="d4" oninput="otpInput(this,4)" placeholder="·">
      <input class="otp-digit" type="text" maxlength="1" inputmode="numeric" id="d5" oninput="otpInput(this,5)" placeholder="·">
    </div>
    <div class="modal-error" id="modalError"></div>
    <button class="btn-verify" id="btnVerify" onclick="submitWithOtp()" disabled>Verify &amp; create account</button>
    <div class="modal-resend">
      Didn't receive it? <button id="btnResend" onclick="resendOtp()">Resend OTP</button>
      <span id="resendTimer" style="display:none"></span>
    </div>
  </div>
</div>

<div class="page-outer">
  <div class="reg-container">

    <div class="reg-header">
      <div class="reg-badge"><i class="ph-bold ph-sparkle"></i> Create Account</div>
      <h1>Join <span>AeroSphere</span> today</h1>
      <p>Book flights, manage trips, fly smarter.</p>
    </div>

    <div class="reg-card">

      <% if (error != null) { %>
        <div class="alert alert-error"><span><i class="ph-bold ph-warning"></i></span><span><%= HtmlUtils.e(error) %></span></div>
      <% } %>
      <% if (success != null) { %>
        <div class="alert alert-success"><span><i class="ph-bold ph-check-circle"></i></span><span><%= HtmlUtils.e(success) %></span></div>
      <% } %>

      <%-- FORM: action, method, all name attrs kept EXACTLY as original --%>
      <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
        <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="otp" id="otpHidden">

        <div class="form-grid">

          <div class="section-sep"><span>Personal information</span></div>

          <div class="field full">
            <label>Full Name <span style="color:var(--danger)">*</span></label>
            <div class="field-wrap">
              <span class="field-icon"><i class="ph-bold ph-user"></i></span>
              <input type="text" name="name" placeholder="Your full name" required autocomplete="name" maxlength="100">
            </div>
          </div>

          <div class="field full">
            <label>Email Address <span style="color:var(--danger)">*</span></label>
            <div class="email-otp-row">
              <div class="field-wrap">
                <span class="field-icon"><i class="ph-bold ph-envelope-simple"></i></span>
                <input type="email" name="email" id="emailInput" placeholder="you@example.com" required autocomplete="email">
              </div>
              <button type="button" class="btn-send-otp" id="btnSendOtp" onclick="sendOtp()">Send OTP</button>
            </div>
            <div class="otp-status" id="otpStatus"></div>
          </div>

          <div class="field">
            <label>Phone Number</label>
            <div class="field-wrap">
              <span class="field-icon"><i class="ph-bold ph-device-mobile"></i></span>
              <input type="tel" name="phone" maxlength="10" pattern="[6-9][0-9]{9}" placeholder="10-digit number">
            </div>
          </div>

          <div class="field">
            <label>Date of Birth</label>
            <div class="field-wrap">
              <span class="field-icon"><i class="ph-bold ph-cake"></i></span>
              <input type="date" name="dob">
            </div>
          </div>

          <div class="field">
            <label>Gender</label>
            <div class="field-wrap">
              <span class="field-icon"><i class="ph-bold ph-user-circle"></i></span>
              <select name="gender">
                <option value="">Select gender</option>
                <option value="MALE">Male</option>
                <option value="FEMALE">Female</option>
                <option value="OTHER">Other</option>
              </select>
            </div>
          </div>

          <div class="field full">
            <label>Address</label>
            <div class="field-wrap">
              <span class="field-icon" style="top:18px;transform:none"><i class="ph-bold ph-map-pin"></i></span>
              <textarea name="address" placeholder="Your full residential address"></textarea>
            </div>
          </div>

          <div class="section-sep"><span>Security</span></div>

          <div class="field full">
            <label>Password <span style="color:var(--danger)">*</span></label>
            <div class="field-wrap">
              <span class="field-icon"><i class="ph-bold ph-lock-simple"></i></span>
              <input type="password" name="password" id="pwInput" placeholder="Min 8 characters" required autocomplete="new-password" minlength="8">
              <button type="button" class="toggle-pw" onclick="togglePw()" tabindex="-1"><i class="ph-bold ph-eye"></i></button>
            </div>
            <div class="strength-bar">
              <div class="strength-seg" id="s1"></div>
              <div class="strength-seg" id="s2"></div>
              <div class="strength-seg" id="s3"></div>
              <div class="strength-seg" id="s4"></div>
            </div>
          </div>

        </div><!-- /form-grid -->

        <%-- Submit intercepted by JS — opens OTP modal --%>
        <button type="button" class="btn-submit" id="btnCreateAccount" onclick="handleCreateAccount()">
          <span>Create my account</span><span>→</span>
        </button>
      </form>
    </div><!-- /reg-card -->

    <p class="form-footer">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here →</a></p>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  /* ── ALL BUSINESS LOGIC BELOW IS UNCHANGED FROM ORIGINAL ───── */

  function togglePw() {
    var i = document.getElementById('pwInput');
    i.type = i.type === 'password' ? 'text' : 'password';
  }

  document.getElementById('pwInput').addEventListener('input', function() {
    var v = this.value;
    var segs = ['s1','s2','s3','s4'].map(function(id){ return document.getElementById(id); });
    var score = 0;
    if (v.length >= 8)  score++;
    if (v.length >= 12) score++;
    if (/[A-Z]/.test(v) && /[0-9]/.test(v)) score++;
    if (/[^A-Za-z0-9]/.test(v)) score++;
    var cls = score <= 1 ? 'seg-weak' : score <= 2 ? 'seg-medium' : 'seg-strong';
    segs.forEach(function(s, i) {
      s.className = 'strength-seg';
      if (i < score) s.classList.add(cls);
    });
  });

  document.querySelectorAll('.field').forEach(function(f, i) {
    f.style.opacity = '0'; f.style.transform = 'translateY(12px)';
    f.style.transition = 'all 0.4s ease ' + (0.15 + i * 0.05) + 's';
    setTimeout(function(){ f.style.opacity = '1'; f.style.transform = 'translateY(0)'; }, 50);
  });

  var otpVerified   = false;
  var otpEmail      = null;
  var resendInterval = null;

  function sendOtp() {
    var email = document.getElementById('emailInput').value.trim();
    if (!email || !/^[\w.+-]+@[\w-]+\.[\w.]{2,}$/.test(email)) {
      setOtpStatus('Please enter a valid email address first.', false);
      return;
    }
    var btn = document.getElementById('btnSendOtp');
    btn.disabled = true; btn.textContent = 'Sending...';
    setOtpStatus('', null);

    fetch('${pageContext.request.contextPath}/sendOtp', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'email=' + encodeURIComponent(email)
    })
    .then(function(r){ return r.json(); })
    .then(function(data) {
      if (data.success) {
        otpEmail = email;
        setOtpStatus('✓ OTP sent to ' + email + '. Check your inbox.', true);
        btn.textContent = 'Resend OTP'; btn.disabled = false;
        openOtpModal(email); startResendTimer();
      } else {
        setOtpStatus('✗ ' + data.error, false);
        btn.textContent = 'Send OTP'; btn.disabled = false;
      }
    })
    .catch(function() {
      setOtpStatus('✗ Network error. Please try again.', false);
      btn.textContent = 'Send OTP'; btn.disabled = false;
    });
  }

  function setOtpStatus(msg, ok) {
    var el = document.getElementById('otpStatus');
    el.textContent = msg;
    el.className = 'otp-status' + (ok === true ? ' ok' : ok === false ? ' err' : '');
  }

  function openOtpModal(email) {
    document.getElementById('modalEmailDisplay').textContent = email;
    document.getElementById('modalError').textContent = '';
    clearOtpDigits();
    document.getElementById('otpModal').classList.add('open');
    setTimeout(function(){ document.getElementById('d0').focus(); }, 100);
  }

  function closeOtpModal() {
    document.getElementById('otpModal').classList.remove('open');
  }

  document.getElementById('otpModal').addEventListener('click', function(e) {
    if (e.target === this) closeOtpModal();
  });

  function clearOtpDigits() {
    for (var i = 0; i < 6; i++) document.getElementById('d' + i).value = '';
    document.getElementById('btnVerify').disabled = true;
  }

  function otpInput(el, idx) {
    el.value = el.value.replace(/\D/g, '');
    if (el.value && idx < 5) document.getElementById('d' + (idx + 1)).focus();
    var filled = true;
    for (var i = 0; i < 6; i++) { if (!document.getElementById('d' + i).value) { filled = false; break; } }
    document.getElementById('btnVerify').disabled = !filled;
    document.getElementById('modalError').textContent = '';
  }

  document.querySelectorAll('.otp-digit').forEach(function(d, idx) {
    d.addEventListener('keydown', function(e) {
      if (e.key === 'Backspace' && !this.value && idx > 0) {
        document.getElementById('d' + (idx - 1)).focus();
      }
    });
  });

  function getOtpValue() {
    var otp = '';
    for (var i = 0; i < 6; i++) otp += document.getElementById('d' + i).value;
    return otp;
  }

  function submitWithOtp() {
    var otp = getOtpValue();
    if (otp.length !== 6) { document.getElementById('modalError').textContent = 'Please enter all 6 digits.'; return; }
    var currentEmail = document.getElementById('emailInput').value.trim().toLowerCase();
    if (otpEmail && currentEmail !== otpEmail.toLowerCase()) {
      document.getElementById('modalError').textContent = 'Email changed! Please send OTP again.'; return;
    }
    document.getElementById('otpHidden').value = otp;
    closeOtpModal();
    document.getElementById('btnCreateAccount').disabled = true;
    document.getElementById('btnCreateAccount').innerHTML = '<span>Creating account...</span>';
    document.getElementById('regForm').submit();
  }

  function resendOtp() { document.getElementById('btnResend').disabled = true; sendOtp(); }

  function startResendTimer() {
    var secs = 60;
    var timerEl = document.getElementById('resendTimer');
    var resendBtn = document.getElementById('btnResend');
    resendBtn.disabled = true; timerEl.style.display = 'inline';
    timerEl.textContent = '(resend in ' + secs + 's)';
    if (resendInterval) clearInterval(resendInterval);
    resendInterval = setInterval(function() {
      secs--;
      if (secs <= 0) { clearInterval(resendInterval); timerEl.style.display = 'none'; resendBtn.disabled = false; }
      else { timerEl.textContent = '(resend in ' + secs + 's)'; }
    }, 1000);
  }

  function handleCreateAccount() {
    var form     = document.getElementById('regForm');
    var name     = form.querySelector('[name="name"]').value.trim();
    var email    = document.getElementById('emailInput').value.trim();
    var password = form.querySelector('[name="password"]').value;
    if (!name || !email || !password) { alert('Please fill in all required fields (Name, Email, Password).'); return; }
    if (password.length < 8) { alert('Password must be at least 8 characters.'); return; }
    if (!otpEmail || otpEmail.toLowerCase() !== email.toLowerCase()) {
      setOtpStatus('Please send and verify an OTP for your email first.', false);
      document.getElementById('emailInput').focus(); return;
    }
    openOtpModal(otpEmail);
  }
</script>
</body>
</html>
