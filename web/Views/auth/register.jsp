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
    <title>Register – AeroSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <%-- ══ THEME: apply BEFORE body renders to kill the white flash ══ --%>
    <script>
        (function(){
            var t = localStorage.getItem('aerosphere-theme') ||
                    (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-theme', t);
        })();
    </script>

    <style>
        :root {
            --primary:#10B981; --primary-dark:#059669; --primary-glow:rgba(16,185,129,0.18);
            --bg:#FAFAF9; --card-bg:#FFFFFF; --text:#1C1917; --text-muted:#6B7280;
            --border:#E5E7EB; --shadow:0 4px 24px rgba(0,0,0,0.07);
            --shadow-lg:0 20px 60px rgba(0,0,0,0.12); --input-bg:#F9FAFB;
        }
        [data-theme="dark"] {
            --primary:#10B981; --primary-dark:#34D399; --primary-glow:rgba(16,185,129,0.22);
            --bg:#0A0A0A; --card-bg:#141414; --text:#F5F5F4; --text-muted:#9CA3AF;
            --border:#262626; --shadow:0 4px 24px rgba(0,0,0,0.5);
            --shadow-lg:0 20px 60px rgba(0,0,0,0.6); --input-bg:#1A1A1A;
        }
        *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:'Inter',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; display:flex; flex-direction:column; transition:background 0.3s, color 0.3s; }

        .navbar { display:flex; align-items:center; justify-content:space-between; padding:16px 48px; border-bottom:1px solid var(--border); background:var(--card-bg); animation:slideDown 0.5s ease both; }
        @keyframes slideDown { from{transform:translateY(-20px);opacity:0} to{transform:translateY(0);opacity:1} }
        .nav-brand { display:flex; align-items:center; gap:10px; text-decoration:none; color:var(--text); }
        .brand-icon { width:36px; height:36px; background:var(--primary); border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:17px; box-shadow:0 4px 12px var(--primary-glow); }
        .brand-name { font-weight:800; font-size:1.15rem; letter-spacing:-0.5px; }
        .brand-name span { color:var(--primary); }
        .nav-right { display:flex; align-items:center; gap:8px; }
        .nav-link { text-decoration:none; color:var(--text-muted); padding:8px 14px; border-radius:8px; font-size:0.88rem; font-weight:500; transition:all 0.2s; }
        .nav-link:hover { color:var(--text); background:var(--border); }
        .nav-link.cta { background:var(--primary); color:#fff; font-weight:600; box-shadow:0 4px 12px var(--primary-glow); }
        .nav-link.cta:hover { background:var(--primary-dark); }
        .theme-toggle { width:34px; height:34px; border:1px solid var(--border); border-radius:8px; background:var(--card-bg); cursor:pointer; display:flex; align-items:center; justify-content:center; font-size:15px; transition:all 0.2s; }
        .theme-toggle:hover { border-color:var(--primary); }

        /* PAGE */
        .page-wrapper { flex:1; display:flex; align-items:flex-start; justify-content:center; padding:40px 20px 60px; }
        .register-container { width:100%; max-width:660px; animation:riseUp 0.6s cubic-bezier(0.16,1,0.3,1) both 0.1s; }
        @keyframes riseUp { from{transform:translateY(30px);opacity:0} to{transform:translateY(0);opacity:1} }

        /* HEADER */
        .form-header { text-align:center; margin-bottom:28px; }
        .header-badge { display:inline-flex; align-items:center; gap:8px; background:var(--primary-glow); border:1px solid var(--primary); border-radius:99px; padding:6px 16px; font-size:0.78rem; font-weight:600; color:var(--primary); margin-bottom:16px; letter-spacing:0.5px; }
        .header-badge::before { content:''; width:6px; height:6px; background:var(--primary); border-radius:50%; animation:pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }
        .form-header h1 { font-size:2.2rem; font-weight:900; letter-spacing:-1px; margin-bottom:10px; }
        .form-header h1 span { color:var(--primary); }
        .form-header p { color:var(--text-muted); font-size:0.92rem; }

        /* CARD */
        .form-card {
            background:var(--card-bg); border:1px solid var(--border); border-radius:20px;
            padding:36px; box-shadow:var(--shadow-lg); position:relative; overflow:hidden;
        }
        .form-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:linear-gradient(90deg, var(--primary), #34D399, var(--primary)); }

        /* ALERTS */
        .alert { padding:11px 14px; border-radius:10px; margin-bottom:20px; font-size:0.86rem; font-weight:500; display:flex; align-items:center; gap:8px; animation:alertIn 0.3s ease; }
        @keyframes alertIn { from{transform:translateX(-8px);opacity:0} to{transform:translateX(0);opacity:1} }
        .alert-error { background:rgba(239,68,68,0.08); border:1px solid rgba(239,68,68,0.2); color:#DC2626; }
        [data-theme="dark"] .alert-error { color:#FCA5A5; }
        .alert-success { background:rgba(16,185,129,0.08); border:1px solid var(--primary); color:var(--primary); }

        /* GRID */
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:18px; }
        .form-grid .full { grid-column:1/-1; }

        /* SECTION DIVIDER */
        .section-label { display:flex; align-items:center; gap:10px; grid-column:1/-1; margin:4px 0; }
        .section-label span { font-size:0.72rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:1px; white-space:nowrap; }
        .section-label::before, .section-label::after { content:''; flex:1; height:1px; background:var(--border); }

        /* FIELDS */
        .field { display:flex; flex-direction:column; gap:7px; }
        .field label { font-size:0.76rem; font-weight:600; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.5px; }
        .field-wrap { position:relative; }
        .field-icon { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:14px; pointer-events:none; }
        .field-wrap input, .field-wrap select, .field-wrap textarea {
            width:100%; background:var(--input-bg); border:1.5px solid var(--border);
            border-radius:10px; padding:12px 14px 12px 40px; color:var(--text);
            font-family:'Inter',sans-serif; font-size:0.9rem; outline:none;
            transition:all 0.2s; appearance:none;
        }
        .field-wrap textarea { padding:12px 14px 12px 40px; height:80px; resize:none; }
        .field-wrap input::placeholder, .field-wrap textarea::placeholder { color:var(--text-muted); opacity:0.6; }
        .field-wrap input:focus, .field-wrap select:focus, .field-wrap textarea:focus { border-color:var(--primary); background:var(--card-bg); box-shadow:0 0 0 3px var(--primary-glow); }
        input[type="date"]::-webkit-calendar-picker-indicator { cursor:pointer; opacity:0.6; }
        [data-theme="dark"] input[type="date"]::-webkit-calendar-picker-indicator { filter:invert(1); }
        .toggle-pw { position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; color:var(--text-muted); cursor:pointer; font-size:14px; transition:color 0.2s; }
        .toggle-pw:hover { color:var(--primary); }

        /* STRENGTH BAR */
        .strength-bar { display:flex; gap:4px; margin-top:6px; }
        .strength-seg { flex:1; height:3px; border-radius:99px; background:var(--border); transition:background 0.3s; }
        .seg-weak { background:#EF4444; }
        .seg-medium { background:#F59E0B; }
        .seg-strong { background:var(--primary); }

        /* SUBMIT */
        .btn-submit {
            width:100%; padding:15px; background:var(--primary); border:none;
            border-radius:12px; color:#fff; font-family:'Inter',sans-serif;
            font-size:0.95rem; font-weight:700; cursor:pointer; transition:all 0.25s;
            box-shadow:0 6px 20px var(--primary-glow); margin-top:10px;
            display:flex; align-items:center; justify-content:center; gap:8px;
        }
        .btn-submit:hover { background:var(--primary-dark); transform:translateY(-2px); box-shadow:0 10px 28px var(--primary-glow); }

        /* FOOTER LINK */
        .form-footer { text-align:center; margin-top:20px; color:var(--text-muted); font-size:0.88rem; }
        .form-footer a { color:var(--primary); text-decoration:none; font-weight:600; }
        .form-footer a:hover { color:var(--primary-dark); }

        @media(max-width:600px) { .navbar{padding:14px 20px} .form-card{padding:24px 18px} .form-header h1{font-size:1.7rem} .form-grid{grid-template-columns:1fr} .form-grid .full{grid-column:1} }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
        <a href="${pageContext.request.contextPath}/login" class="nav-link cta">Sign In</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="register-container">
        <div class="form-header">
            <div class="header-badge">✦ Create Account</div>
            <h1>Join <span>AeroSphere</span> Today</h1>
            <p>Book flights, manage trips, fly smarter.</p>
        </div>

        <div class="form-card">
            <% if (error != null) { %>
                <div class="alert alert-error">⚠ <%= HtmlUtils.e(error) %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="alert alert-success">✓ <%= HtmlUtils.e(success) %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
                <%-- CSRF Token — protects against cross-site request forgery --%>
                <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">

                <div class="form-grid">
                    <div class="section-label"><span>Personal Info</span></div>

                    <div class="field full">
                        <label>Full Name</label>
                        <div class="field-wrap"><span class="field-icon">👤</span><input type="text" name="name" placeholder="Your full name" required autocomplete="name" maxlength="100"></div>
                    </div>
                    <div class="field">
                        <label>Email Address</label>
                        <div class="field-wrap"><span class="field-icon">✉</span><input type="email" name="email" placeholder="you@example.com" required autocomplete="email"></div>
                    </div>
                    <div class="field">
                        <label>Phone Number</label>
                        <div class="field-wrap"><span class="field-icon">📱</span><input type="tel" name="phone" maxlength="10" pattern="[6-9][0-9]{9}" placeholder="10-digit number"></div>
                    </div>
                    <div class="field">
                        <label>Date of Birth</label>
                        <div class="field-wrap"><span class="field-icon">🎂</span><input type="date" name="dob"></div>
                    </div>
                    <div class="field">
                        <label>Gender</label>
                        <div class="field-wrap">
                            <span class="field-icon">⚧</span>
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
                        <div class="field-wrap"><span class="field-icon" style="top:18px;transform:none">📍</span><textarea name="address" placeholder="Your full residential address"></textarea></div>
                    </div>

                    <div class="section-label"><span>Security</span></div>
                    <div class="field full">
                        <label>Password</label>
                        <div class="field-wrap">
                            <span class="field-icon">🔒</span>
                            <input type="password" name="password" id="pwInput" placeholder="Min 8 characters" required autocomplete="new-password" minlength="8">
                            <button type="button" class="toggle-pw" onclick="togglePw()">👁</button>
                        </div>
                        <div class="strength-bar"><div class="strength-seg" id="s1"></div><div class="strength-seg" id="s2"></div><div class="strength-seg" id="s3"></div><div class="strength-seg" id="s4"></div></div>
                    </div>
                </div>

                <button type="submit" class="btn-submit"><span>Create My Account</span><span>→</span></button>
            </form>
        </div>

        <p class="form-footer">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
    </div>
</div>

<script>
    // ── Theme: apply correct icon after DOM renders ───────────────────
    (function() {
        var t = document.documentElement.getAttribute('data-theme') || 'light';
        var btn = document.getElementById('themeToggle');
        if (btn) btn.textContent = t === 'dark' ? '☀️' : '🌙';
    })();

    function toggleTheme() {
        var n = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', n);
        localStorage.setItem('aerosphere-theme', n);
        document.getElementById('themeToggle').textContent = n === 'dark' ? '☀️' : '🌙';
    }

    function togglePw() {
        var i = document.getElementById('pwInput');
        i.type = i.type === 'password' ? 'text' : 'password';
    }

    document.getElementById('pwInput').addEventListener('input', function() {
        var v = this.value;
        var segs = ['s1','s2','s3','s4'].map(function(id){ return document.getElementById(id); });
        var score = 0;
        if (v.length >= 8) score++;
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
        f.style.transition = 'all 0.4s ease ' + (0.2 + i * 0.04) + 's';
        setTimeout(function(){ f.style.opacity = '1'; f.style.transform = 'translateY(0)'; }, 50);
    });
</script>
</body>
</html>
