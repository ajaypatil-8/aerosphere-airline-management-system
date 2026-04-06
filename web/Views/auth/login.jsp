<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In – AeroSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #10B981; --primary-dark: #059669; --primary-glow: rgba(16,185,129,0.2);
            --accent: #A7F3D0; --bg: #FAFAF9; --card-bg: #FFFFFF; --text: #1C1917;
            --text-muted: #6B7280; --border: #E5E7EB; --shadow: 0 4px 24px rgba(0,0,0,0.07);
            --shadow-lg: 0 20px 60px rgba(0,0,0,0.12); --input-bg: #F9FAFB;
        }
        [data-theme="dark"] {
            --primary: #10B981; --primary-dark: #34D399; --primary-glow: rgba(16,185,129,0.25);
            --accent: #34D399; --bg: #0A0A0A; --card-bg: #141414; --text: #F5F5F4;
            --text-muted: #9CA3AF; --border: #262626; --shadow: 0 4px 24px rgba(0,0,0,0.5);
            --shadow-lg: 0 20px 60px rgba(0,0,0,0.6); --input-bg: #1A1A1A;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; display: flex; flex-direction: column; transition: background 0.3s, color 0.3s; }

        /* NAVBAR */
        .navbar {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px 48px; border-bottom: 1px solid var(--border);
            background: var(--card-bg); animation: slideDown 0.5s ease both;
        }
        @keyframes slideDown { from{transform:translateY(-20px);opacity:0} to{transform:translateY(0);opacity:1} }
        .nav-brand { display:flex; align-items:center; gap:10px; text-decoration:none; color:var(--text); }
        .brand-icon { width:36px; height:36px; background:var(--primary); border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:17px; box-shadow:0 4px 12px var(--primary-glow); }
        .brand-name { font-weight:800; font-size:1.15rem; letter-spacing:-0.5px; }
        .brand-name span { color:var(--primary); }
        .nav-right { display:flex; align-items:center; gap:8px; }
        .nav-link { text-decoration:none; color:var(--text-muted); padding:8px 14px; border-radius:8px; font-size:0.88rem; font-weight:500; transition:all 0.2s; }
        .nav-link:hover { color:var(--text); background:var(--border); }
        .nav-link.outline { border:1px solid var(--border); color:var(--text); }
        .nav-link.outline:hover { border-color:var(--primary); color:var(--primary); background:var(--primary-glow); }
        .theme-toggle { width:34px; height:34px; border:1px solid var(--border); border-radius:8px; background:var(--card-bg); cursor:pointer; display:flex; align-items:center; justify-content:center; font-size:15px; transition:all 0.2s; color:var(--text); }
        .theme-toggle:hover { border-color:var(--primary); }

        /* LAYOUT */
        .page-wrapper { flex:1; display:grid; grid-template-columns:1fr 480px; min-height:calc(100vh - 69px); }

        /* LEFT PANEL */
        .visual-panel {
            display:flex; flex-direction:column; justify-content:center; padding:60px;
            background: linear-gradient(135deg, var(--primary-glow) 0%, transparent 60%);
            border-right:1px solid var(--border); position:relative; overflow:hidden;
            animation: panelIn 0.7s ease both;
        }
        @keyframes panelIn { from{opacity:0;transform:translateX(-24px)} to{opacity:1;transform:translateX(0)} }
        .visual-panel::after { content:'✈'; position:absolute; right:-20px; bottom:40px; font-size:220px; opacity:0.04; transform:rotate(-15deg); user-select:none; pointer-events:none; }
        .tag-line {
            display:inline-flex; align-items:center; gap:8px;
            background:var(--primary-glow); border:1px solid var(--primary);
            border-radius:99px; padding:6px 16px; font-size:0.76rem;
            color:var(--primary); font-weight:600; letter-spacing:0.8px;
            text-transform:uppercase; margin-bottom:28px; width:fit-content;
        }
        .visual-heading { font-size:3rem; font-weight:900; line-height:1.1; letter-spacing:-1.5px; margin-bottom:18px; }
        .visual-heading .g { color:var(--primary); }
        .visual-desc { color:var(--text-muted); font-size:0.95rem; line-height:1.7; max-width:380px; margin-bottom:36px; }
        .feature-pills { display:flex; flex-direction:column; gap:10px; }
        .pill {
            display:flex; align-items:center; gap:12px;
            background:var(--card-bg); border:1px solid var(--border);
            border-radius:12px; padding:14px 16px; max-width:340px;
            box-shadow:var(--shadow); transition:all 0.3s;
        }
        .pill:hover { border-color:var(--primary); transform:translateX(4px); }
        .pill-icon { width:34px; height:34px; background:var(--primary-glow); border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:16px; flex-shrink:0; }
        .pill-text strong { display:block; font-size:0.88rem; font-weight:600; }
        .pill-text span { font-size:0.78rem; color:var(--text-muted); }

        /* LOGIN PANEL */
        .login-panel {
            display:flex; align-items:center; justify-content:center; padding:40px 48px;
            background:var(--bg); animation: panelInR 0.7s cubic-bezier(0.16,1,0.3,1) both 0.1s;
        }
        @keyframes panelInR { from{opacity:0;transform:translateX(24px)} to{opacity:1;transform:translateX(0)} }
        .login-box { width:100%; max-width:340px; }
        .login-header { margin-bottom:28px; }
        .login-header h2 { font-size:1.8rem; font-weight:800; letter-spacing:-0.5px; margin-bottom:6px; }
        .login-header p { color:var(--text-muted); font-size:0.9rem; }

        /* Tabs */
        .login-tabs {
            display:flex; background:var(--input-bg); border:1px solid var(--border);
            border-radius:10px; padding:3px; margin-bottom:24px;
        }
        .tab-btn {
            flex:1; padding:9px; background:none; border:none; border-radius:8px;
            color:var(--text-muted); font-family:'Inter',sans-serif; font-size:0.85rem;
            font-weight:600; cursor:pointer; transition:all 0.2s;
        }
        .tab-btn.active { background:var(--primary); color:#fff; box-shadow:0 3px 10px var(--primary-glow); }

        /* Alert */
        .alert {
            padding:11px 14px; border-radius:10px; margin-bottom:18px;
            font-size:0.86rem; font-weight:500; display:flex; align-items:center; gap:8px;
            background:rgba(239,68,68,0.08); border:1px solid rgba(239,68,68,0.2);
            color:#DC2626; animation:shake 0.4s ease;
        }
        [data-theme="dark"] .alert { color:#FCA5A5; }
        @keyframes shake { 0%,100%{transform:translateX(0)} 25%{transform:translateX(-5px)} 75%{transform:translateX(5px)} }

        /* Fields */
        .field { margin-bottom:16px; }
        .field label { display:block; font-size:0.78rem; font-weight:600; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.5px; margin-bottom:7px; }
        .input-wrap { position:relative; }
        .input-icon { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:14px; pointer-events:none; transition:0.2s; }
        .input-wrap input {
            width:100%; background:var(--input-bg); border:1.5px solid var(--border);
            border-radius:10px; padding:12px 14px 12px 38px; color:var(--text);
            font-family:'Inter',sans-serif; font-size:0.92rem; outline:none; transition:all 0.2s;
        }
        .input-wrap input::placeholder { color:var(--text-muted); opacity:0.6; }
        .input-wrap input:focus { border-color:var(--primary); background:var(--card-bg); box-shadow:0 0 0 3px var(--primary-glow); }
        .pw-toggle {
            position:absolute; right:10px; top:50%; transform:translateY(-50%);
            background:none; border:none; color:var(--text-muted); cursor:pointer;
            font-size:14px; padding:4px; transition:color 0.2s;
        }
        .pw-toggle:hover { color:var(--primary); }

        /* Submit */
        .btn-login {
            width:100%; padding:14px; background:var(--primary); border:none;
            border-radius:11px; color:#fff; font-family:'Inter',sans-serif;
            font-size:0.95rem; font-weight:700; cursor:pointer; transition:all 0.25s;
            box-shadow:0 6px 20px var(--primary-glow); margin-top:4px;
            display:flex; align-items:center; justify-content:center; gap:8px;
        }
        .btn-login:hover { background:var(--primary-dark); transform:translateY(-2px); box-shadow:0 10px 28px var(--primary-glow); }
        .btn-login:active { transform:translateY(0); }

        .divider { display:flex; align-items:center; gap:10px; margin:20px 0; }
        .divider::before, .divider::after { content:''; flex:1; height:1px; background:var(--border); }
        .divider span { font-size:0.76rem; color:var(--text-muted); }

        .register-link { text-align:center; font-size:0.86rem; color:var(--text-muted); }
        .register-link a { color:var(--primary); text-decoration:none; font-weight:600; }
        .register-link a:hover { color:var(--primary-dark); }

        #adminForm { display:none; }

        @media(max-width:860px) { .page-wrapper{grid-template-columns:1fr} .visual-panel{display:none} .login-panel{padding:40px 24px} }
        @media(max-width:480px) { .navbar{padding:14px 20px} }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
        <a href="${pageContext.request.contextPath}/register" class="nav-link outline">Create Account</a>
        <button class="theme-toggle" onclick="toggleTheme()" title="Toggle theme" id="themeToggle">🌙</button>
    </div>
</nav>

<!-- MAIN -->
<div class="page-wrapper">

    <!-- LEFT VISUAL -->
    <div class="visual-panel">
        <div class="tag-line">✦ AeroSphere Airlines</div>
        <h1 class="visual-heading">Your Next<br><span class="g">Adventure</span><br>Awaits.</h1>
        <p class="visual-desc">Book flights, manage reservations and track your journeys — all in one place. Built for the modern traveller.</p>
        <div class="feature-pills">
            <div class="pill"><div class="pill-icon">✈</div><div class="pill-text"><strong>Instant Booking</strong><span>Reserve seats in under 2 minutes</span></div></div>
            <div class="pill"><div class="pill-icon">📋</div><div class="pill-text"><strong>Manage Trips</strong><span>View, modify or cancel any booking</span></div></div>
            <div class="pill"><div class="pill-icon">🔒</div><div class="pill-text"><strong>Secure Payments</strong><span>Safe checkout &amp; instant invoices</span></div></div>
        </div>
    </div>

    <!-- LOGIN PANEL -->
    <div class="login-panel">
        <div class="login-box">
            <div class="login-header">
                <h2>Welcome back</h2>
                <p>Sign in to your AeroSphere account</p>
            </div>

            <!-- TABS -->
            <div class="login-tabs">
                <button class="tab-btn active" id="tabUser" onclick="switchTab('user')">Passenger</button>
                <button class="tab-btn" id="tabAdmin" onclick="switchTab('admin')">Admin</button>
            </div>

            <%
                String err = (String) request.getAttribute("error");
                String activeTab = (String) request.getAttribute("activeTab");
                if (activeTab == null) activeTab = "USER";
            %>
            <% if (err != null) { %>
                <div class="alert">⚠ <%= err %></div>
            <% } %>

            <!-- USER FORM -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="userForm">
                <input type="hidden" name="loginType" value="USER">
                <div class="field">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <span class="input-icon">✉</span>
                        <input type="email" name="email" placeholder="you@example.com" required autocomplete="email">
                        </div>
                </div>
                <div class="field">
                    <label>Password</label>
                    <div class="input-wrap">
                        <span class="input-icon">🔒</span>
                        <input type="password" name="password" id="userPw" placeholder="Enter your password" required autocomplete="current-password">
                        <button type="button" class="pw-toggle" onclick="togglePw('userPw')">👁</button>
                    </div>
                </div>
                <button type="submit" class="btn-login"><span>Sign In</span><span>→</span></button>
            </form>

            <!-- ADMIN FORM -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="adminForm">
                <input type="hidden" name="loginType" value="ADMIN">
                <div class="field">
                    <label>Admin Email</label>
                    <div class="input-wrap">
                        <span class="input-icon">🛡</span>
                        <input type="email" name="email" placeholder="admin@aerosphere.com" required autocomplete="email">
                    </div>
                </div>
                <div class="field">
                    <label>Admin Password</label>
                    <div class="input-wrap">
                        <span class="input-icon">🔑</span>
                        <input type="password" name="password" id="adminPw" placeholder="Admin password" required autocomplete="current-password">
                        <button type="button" class="pw-toggle" onclick="togglePw('adminPw')">👁</button>
                    </div>
                </div>
                <button type="submit" class="btn-login"><span>Admin Sign In</span><span>→</span></button>
            </form>

            <div class="divider"><span>New to AeroSphere?</span></div>
            <div class="register-link"><a href="${pageContext.request.contextPath}/register">Create a free account →</a></div>
        </div>
    </div>
</div>

<script>
    const savedTheme = localStorage.getItem('aerosphere-theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    document.documentElement.setAttribute('data-theme', savedTheme);
    document.getElementById('themeToggle').textContent = savedTheme === 'dark' ? '☀️' : '🌙';
    function toggleTheme() {
        const n = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', n);
        localStorage.setItem('aerosphere-theme', n);
        document.getElementById('themeToggle').textContent = n === 'dark' ? '☀️' : '🌙';
    }

    const initialTab = '<%= activeTab %>'.toLowerCase() === 'admin' ? 'admin' : 'user';
    switchTab(initialTab);
    function switchTab(tab) {
        document.getElementById('userForm').style.display  = tab === 'user' ? 'block' : 'none';
        document.getElementById('adminForm').style.display = tab === 'admin' ? 'block' : 'none';
        document.getElementById('tabUser').classList.toggle('active', tab === 'user');
        document.getElementById('tabAdmin').classList.toggle('active', tab === 'admin');
    }
    function togglePw(id) { const i=document.getElementById(id); i.type=i.type==='password'?'text':'password'; }
</script>
</body>
</html>
