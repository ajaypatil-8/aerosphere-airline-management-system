<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --sky: #0057FF;
            --sky-deep: #0039B5;
            --sky-glow: #4D8AFF;
            --gold: #FFB800;
            --ink: #080C1A;
            --white: #ffffff;
            --glass: rgba(255,255,255,0.06);
            --border-glass: rgba(255,255,255,0.12);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--ink);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* ===== SKY BACKGROUND ===== */
        .sky-bg {
            position: fixed;
            inset: 0;
            z-index: 0;
            background:
                radial-gradient(ellipse 70% 50% at 15% 20%, #061245 0%, transparent 55%),
                radial-gradient(ellipse 50% 60% at 85% 80%, #020d36 0%, transparent 55%),
                linear-gradient(170deg, #030710 0%, #06102a 50%, #030710 100%);
        }

        /* Orbiting glow circles */
        .glow-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            animation: orbit var(--duration, 20s) ease-in-out infinite alternate;
        }

        @keyframes orbit {
            from { transform: translate(0, 0); }
            to { transform: translate(var(--tx, 40px), var(--ty, 20px)); }
        }

        .orb-1 {
            width: 400px; height: 400px;
            background: rgba(0, 87, 255, 0.12);
            top: -100px; left: -80px;
            --tx: 60px; --ty: 40px;
            --duration: 15s;
        }

        .orb-2 {
            width: 300px; height: 300px;
            background: rgba(77, 138, 255, 0.08);
            bottom: -60px; right: -60px;
            --tx: -40px; --ty: -30px;
            --duration: 18s;
        }

        .stars { position: absolute; inset: 0; }
        .star {
            position: absolute;
            background: white;
            border-radius: 50%;
            animation: twinkle var(--dur, 3s) ease-in-out infinite;
            animation-delay: var(--delay, 0s);
            opacity: 0;
        }
        @keyframes twinkle {
            0%, 100% { opacity: 0; }
            50% { opacity: var(--opacity, 0.6); }
        }

        /* ===== NAVBAR ===== */
        .navbar {
            position: relative;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 48px;
            border-bottom: 1px solid var(--border-glass);
            background: rgba(3, 7, 16, 0.4);
            backdrop-filter: blur(20px);
            animation: slideDown 0.6s ease both;
        }

        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: white;
        }

        .brand-icon {
            width: 40px; height: 40px;
            background: var(--sky);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            box-shadow: 0 4px 20px rgba(0,87,255,0.4);
        }

        .brand-text {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            letter-spacing: -0.5px;
        }

        .brand-text span { color: var(--gold); }

        .nav-links { display: flex; gap: 8px; align-items: center; }

        .nav-link {
            color: rgba(255,255,255,0.65);
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .nav-link:hover { color: white; background: var(--glass); }

        .nav-link.outline {
            border: 1px solid rgba(255,255,255,0.2);
            color: white;
        }

        .nav-link.outline:hover { border-color: var(--sky-glow); background: rgba(0,87,255,0.1); }

        /* ===== TWO-COLUMN LAYOUT ===== */
        .page-wrapper {
            position: relative;
            z-index: 10;
            flex: 1;
            display: grid;
            grid-template-columns: 1fr 480px;
            min-height: calc(100vh - 81px);
        }

        /* ===== LEFT VISUAL PANEL ===== */
        .visual-panel {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px;
            overflow: hidden;
            animation: panelIn 0.8s ease both;
        }

        @keyframes panelIn {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .visual-panel::after {
            content: '';
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            width: 1px;
            background: linear-gradient(180deg, transparent, rgba(255,255,255,0.08), transparent);
        }

        .tag-line {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,183,0,0.1);
            border: 1px solid rgba(255,183,0,0.2);
            border-radius: 99px;
            padding: 6px 16px;
            font-size: 0.78rem;
            color: #ffd066;
            font-weight: 600;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            margin-bottom: 28px;
            width: fit-content;
        }

        .visual-heading {
            font-family: 'Syne', sans-serif;
            font-size: 3.5rem;
            font-weight: 800;
            color: white;
            line-height: 1.1;
            letter-spacing: -2px;
            margin-bottom: 20px;
        }

        .visual-heading .gradient-text {
            background: linear-gradient(90deg, #4D8AFF, #a8c5ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .visual-desc {
            color: rgba(255,255,255,0.45);
            font-size: 1rem;
            line-height: 1.7;
            max-width: 400px;
            margin-bottom: 40px;
        }

        /* Feature pills */
        .feature-pills {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .pill {
            display: flex;
            align-items: center;
            gap: 14px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 14px;
            padding: 14px 18px;
            max-width: 360px;
            animation: pillIn 0.5s ease both;
        }

        .pill:nth-child(1) { animation-delay: 0.5s; }
        .pill:nth-child(2) { animation-delay: 0.6s; }
        .pill:nth-child(3) { animation-delay: 0.7s; }

        @keyframes pillIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .pill-icon {
            width: 36px; height: 36px;
            background: rgba(0,87,255,0.15);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .pill-text strong {
            display: block;
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .pill-text span {
            color: rgba(255,255,255,0.4);
            font-size: 0.8rem;
        }

        /* Big plane decoration */
        .deco-plane {
            position: absolute;
            right: -20px;
            bottom: 60px;
            opacity: 0.04;
            font-size: 280px;
            line-height: 1;
            user-select: none;
            pointer-events: none;
            transform: rotate(-20deg);
        }

        /* ===== LOGIN PANEL ===== */
        .login-panel {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 48px;
            animation: panelInRight 0.7s cubic-bezier(0.16,1,0.3,1) both;
            animation-delay: 0.1s;
        }

        @keyframes panelInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .login-box { width: 100%; max-width: 360px; }

        .login-header { margin-bottom: 32px; }

        .login-header h2 {
            font-family: 'Syne', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: white;
            letter-spacing: -0.8px;
            margin-bottom: 8px;
        }

        .login-header p {
            color: rgba(255,255,255,0.4);
            font-size: 0.9rem;
        }

        /* Tabs */
        .login-tabs {
            display: flex;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 28px;
        }

        .tab-btn {
            flex: 1;
            padding: 10px;
            background: none;
            border: none;
            border-radius: 9px;
            color: rgba(255,255,255,0.4);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.88rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.25s;
        }

        .tab-btn.active {
            background: var(--sky);
            color: white;
            box-shadow: 0 4px 16px rgba(0,87,255,0.35);
        }

        /* Field */
        .field { margin-bottom: 18px; }

        .field label {
            display: block;
            font-size: 0.82rem;
            font-weight: 500;
            color: rgba(255,255,255,0.45);
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .input-wrap { position: relative; }

        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 15px;
            color: rgba(255,255,255,0.2);
            pointer-events: none;
            transition: color 0.2s;
        }

        .input-wrap input {
            width: 100%;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 13px 16px 13px 40px;
            color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.95rem;
            outline: none;
            transition: all 0.25s;
        }

        .input-wrap input::placeholder { color: rgba(255,255,255,0.2); }

        .input-wrap input:focus {
            border-color: var(--sky);
            background: rgba(0,87,255,0.08);
            box-shadow: 0 0 0 3px rgba(0,87,255,0.15);
        }

        .input-wrap input:focus ~ .input-icon { color: var(--sky-glow); }

        .pw-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: rgba(255,255,255,0.25);
            cursor: pointer;
            font-size: 15px;
            padding: 4px;
            transition: color 0.2s;
        }

        .pw-toggle:hover { color: rgba(255,255,255,0.6); }

        /* Alert */
        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.88rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(220,38,38,0.1);
            border: 1px solid rgba(220,38,38,0.2);
            color: #ff8080;
            animation: shake 0.4s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-6px); }
            75% { transform: translateX(6px); }
        }

        /* Submit */
        .btn-login {
            width: 100%;
            padding: 15px;
            background: var(--sky);
            border: none;
            border-radius: 13px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s;
            box-shadow: 0 8px 28px rgba(0,87,255,0.35);
            margin-top: 4px;
        }

        .btn-login::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.1) 50%, transparent 100%);
            transform: translateX(-100%);
            transition: transform 0.5s;
        }

        .btn-login:hover {
            background: var(--sky-glow);
            transform: translateY(-2px);
            box-shadow: 0 12px 36px rgba(0,87,255,0.45);
        }

        .btn-login:hover::after { transform: translateX(100%); }

        .btn-login-inner {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.07);
        }

        .divider span {
            font-size: 0.78rem;
            color: rgba(255,255,255,0.25);
            font-weight: 500;
        }

        .register-link-row {
            text-align: center;
            font-size: 0.88rem;
            color: rgba(255,255,255,0.4);
        }

        .register-link-row a {
            color: #7aaeff;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .register-link-row a:hover { color: white; }

        /* Admin form hidden by default */
        #adminForm { display: none; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 900px) {
            .page-wrapper { grid-template-columns: 1fr; }
            .visual-panel { display: none; }
            .login-panel { padding: 40px 24px; }
        }

        @media (max-width: 480px) {
            .navbar { padding: 16px 20px; }
            .login-panel { padding: 32px 20px; }
        }
    </style>
</head>
<body>

<!-- BACKGROUND -->
<div class="sky-bg">
    <div class="glow-orb orb-1"></div>
    <div class="glow-orb orb-2"></div>
    <div class="stars" id="stars"></div>
</div>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="/Views/auth/index.jsp" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-text">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="/Views/auth/index.jsp" class="nav-link">Home</a>
        <a href="register.jsp" class="nav-link outline">Create Account</a>
    </div>
</nav>

<!-- MAIN -->
<div class="page-wrapper">

    <!-- LEFT VISUAL PANEL -->
    <div class="visual-panel">
        <div class="deco-plane">✈</div>

        <div class="tag-line">✦ SkyConnect Airlines</div>

        <h1 class="visual-heading">
            Your Next<br>
            <span class="gradient-text">Adventure</span><br>
            Awaits.
        </h1>

        <p class="visual-desc">
            Book flights, manage reservations and track your journeys — all in one place. Built for the modern traveller.
        </p>

        <div class="feature-pills">
            <div class="pill">
                <div class="pill-icon">✈</div>
                <div class="pill-text">
                    <strong>Instant Booking</strong>
                    <span>Reserve seats in under 2 minutes</span>
                </div>
            </div>
            <div class="pill">
                <div class="pill-icon">📋</div>
                <div class="pill-text">
                    <strong>Manage Trips</strong>
                    <span>View, modify or cancel any booking</span>
                </div>
            </div>
            <div class="pill">
                <div class="pill-icon">🔒</div>
                <div class="pill-text">
                    <strong>Secure Payments</strong>
                    <span>Safe checkout & instant invoices</span>
                </div>
            </div>
        </div>
    </div>

    <!-- LOGIN PANEL -->
    <div class="login-panel">
        <div class="login-box">

            <div class="login-header">
                <h2>Welcome back</h2>
                <p>Sign in to your SkyConnect account</p>
            </div>

            <!-- TABS -->
            <div class="login-tabs">
                <button class="tab-btn active" id="tabUser" onclick="switchTab('user')">Passenger</button>
                <button class="tab-btn" id="tabAdmin" onclick="switchTab('admin')">Admin</button>
            </div>

            <!-- Error -->
            <%
                String err = (String) request.getAttribute("error");
            %>
            <% if (err != null) { %>
                <div class="alert">⚠ <%= err %></div>
            <% } %>

            <!-- USER FORM -->
            <form action="login" method="post" id="userForm">
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

                <button type="submit" class="btn-login">
                    <div class="btn-login-inner">
                        <span>Sign In</span>
                        <span>→</span>
                    </div>
                </button>
            </form>

            <!-- ADMIN FORM -->
            <form action="login" method="post" id="adminForm">
                <input type="hidden" name="loginType" value="ADMIN">

                <div class="field">
                    <label>Admin Email</label>
                    <div class="input-wrap">
                        <span class="input-icon">🛡</span>
                        <input type="email" name="email" placeholder="admin@skyconnect.com" required autocomplete="email">
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

                <button type="submit" class="btn-login">
                    <div class="btn-login-inner">
                        <span>Admin Sign In</span>
                        <span>→</span>
                    </div>
                </button>
            </form>

            <div class="divider"><span>New to SkyConnect?</span></div>

            <div class="register-link-row">
                <a href="register.jsp">Create a free account →</a>
            </div>

        </div>
    </div>

</div>

<script>
    // Stars
    const starsEl = document.getElementById('stars');
    for (let i = 0; i < 100; i++) {
        const s = document.createElement('div');
        s.className = 'star';
        const size = Math.random() * 2.5 + 0.5;
        s.style.cssText = `width:${size}px;height:${size}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--opacity:${0.3+Math.random()*0.6};`;
        starsEl.appendChild(s);
    }

    // Tab switch
    function switchTab(tab) {
        const userForm = document.getElementById('userForm');
        const adminForm = document.getElementById('adminForm');
        const tabUser = document.getElementById('tabUser');
        const tabAdmin = document.getElementById('tabAdmin');

        if (tab === 'user') {
            userForm.style.display = 'block';
            adminForm.style.display = 'none';
            tabUser.classList.add('active');
            tabAdmin.classList.remove('active');
        } else {
            userForm.style.display = 'none';
            adminForm.style.display = 'block';
            tabAdmin.classList.add('active');
            tabUser.classList.remove('active');
        }
    }

    // Password toggle
    function togglePw(id) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
    }

    // Icon focus effect
    document.querySelectorAll('.input-wrap input').forEach(el => {
        el.addEventListener('focus', function() {
            const icon = this.parentElement.querySelector('.input-icon');
            if (icon) icon.style.color = '#4D8AFF';
        });
        el.addEventListener('blur', function() {
            const icon = this.parentElement.querySelector('.input-icon');
            if (icon) icon.style.color = 'rgba(255,255,255,0.2)';
        });
    });
</script>

</body>
</html>
