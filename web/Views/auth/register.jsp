<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --sky: #0057FF;
            --sky-deep: #0039B5;
            --sky-glow: #4D8AFF;
            --gold: #FFB800;
            --ink: #080C1A;
            --ink-2: #1A2240;
            --mist: #F0F4FF;
            --white: #ffffff;
            --glass: rgba(255,255,255,0.07);
            --border-glass: rgba(255,255,255,0.15);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--ink);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        /* ===== ANIMATED SKY BACKGROUND ===== */
        .sky-bg {
            position: fixed;
            inset: 0;
            z-index: 0;
            background: radial-gradient(ellipse 80% 60% at 20% 30%, #0a1a5c 0%, transparent 60%),
                        radial-gradient(ellipse 60% 50% at 80% 70%, #001466 0%, transparent 60%),
                        linear-gradient(160deg, #040812 0%, #080d20 50%, #040812 100%);
            overflow: hidden;
        }

        .stars {
            position: absolute;
            inset: 0;
        }

        .star {
            position: absolute;
            background: white;
            border-radius: 50%;
            animation: twinkle var(--dur, 3s) ease-in-out infinite;
            animation-delay: var(--delay, 0s);
            opacity: 0;
        }

        @keyframes twinkle {
            0%, 100% { opacity: 0; transform: scale(0.8); }
            50% { opacity: var(--opacity, 0.7); transform: scale(1); }
        }

        .plane-trail {
            position: absolute;
            top: 15%;
            left: -200px;
            animation: flyAcross 18s linear infinite;
            animation-delay: 3s;
            opacity: 0;
        }

        @keyframes flyAcross {
            0% { left: -200px; opacity: 0; }
            5% { opacity: 1; }
            90% { opacity: 1; }
            100% { left: 110%; opacity: 0; }
        }

        .plane-svg { width: 48px; filter: drop-shadow(0 0 12px #4D8AFF); }

        .trail-line {
            position: absolute;
            top: 50%;
            right: 52px;
            transform: translateY(-50%);
            width: 120px;
            height: 2px;
            background: linear-gradient(to left, rgba(77,138,255,0.6), transparent);
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
            background: rgba(4, 8, 18, 0.5);
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
            color: var(--white);
        }

        .brand-icon {
            width: 40px;
            height: 40px;
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

        .nav-links {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .nav-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .nav-link:hover {
            color: white;
            background: var(--glass);
        }

        .nav-link.cta {
            background: var(--sky);
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 16px rgba(0,87,255,0.35);
        }

        .nav-link.cta:hover {
            background: var(--sky-glow);
            transform: translateY(-1px);
            box-shadow: 0 6px 24px rgba(0,87,255,0.5);
        }

        /* ===== MAIN LAYOUT ===== */
        .page-wrapper {
            position: relative;
            z-index: 10;
            flex: 1;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 40px 20px 60px;
        }

        .register-container {
            width: 100%;
            max-width: 680px;
            animation: riseUp 0.7s cubic-bezier(0.16, 1, 0.3, 1) both;
            animation-delay: 0.2s;
        }

        @keyframes riseUp {
            from { transform: translateY(40px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* ===== HEADER ===== */
        .form-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(0,87,255,0.15);
            border: 1px solid rgba(0,87,255,0.3);
            border-radius: 99px;
            padding: 6px 16px;
            font-size: 0.8rem;
            font-weight: 500;
            color: #7aaeff;
            margin-bottom: 20px;
            letter-spacing: 0.5px;
        }

        .header-badge::before {
            content: '';
            width: 6px;
            height: 6px;
            background: #7aaeff;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }

        .form-header h1 {
            font-family: 'Syne', sans-serif;
            font-size: 2.4rem;
            font-weight: 800;
            color: var(--white);
            line-height: 1.15;
            letter-spacing: -1px;
            margin-bottom: 12px;
        }

        .form-header h1 span {
            background: linear-gradient(90deg, #4D8AFF, #a5c4ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-header p {
            color: rgba(255,255,255,0.5);
            font-size: 0.95rem;
        }

        /* ===== CARD ===== */
        .form-card {
            background: rgba(10, 18, 45, 0.7);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 40px;
            backdrop-filter: blur(30px);
            box-shadow: 0 32px 80px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.05) inset;
            position: relative;
            overflow: hidden;
        }

        .form-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--sky), var(--sky-glow), transparent);
        }

        /* ===== ALERTS ===== */
        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: alertIn 0.4s ease;
        }

        @keyframes alertIn {
            from { transform: translateX(-10px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        .alert-error {
            background: rgba(220, 38, 38, 0.12);
            border: 1px solid rgba(220, 38, 38, 0.25);
            color: #ff8080;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.12);
            border: 1px solid rgba(16, 185, 129, 0.25);
            color: #6ee7b7;
        }

        /* ===== FORM GRID ===== */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-grid .full { grid-column: 1 / -1; }

        /* ===== FORM FIELDS ===== */
        .field {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .field label {
            font-size: 0.82rem;
            font-weight: 500;
            color: rgba(255,255,255,0.5);
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .field-wrap {
            position: relative;
        }

        .field-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255,255,255,0.25);
            font-size: 16px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .field-wrap input,
        .field-wrap select,
        .field-wrap textarea {
            width: 100%;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 13px 16px 13px 42px;
            color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.95rem;
            transition: all 0.25s;
            outline: none;
            appearance: none;
        }

        .field-wrap textarea {
            padding: 14px 16px 14px 42px;
            resize: none;
            height: 90px;
        }

        .field-wrap select option {
            background: #0d1533;
            color: white;
        }

        .field-wrap input::placeholder,
        .field-wrap textarea::placeholder {
            color: rgba(255,255,255,0.2);
        }

        .field-wrap input:focus,
        .field-wrap select:focus,
        .field-wrap textarea:focus {
            border-color: var(--sky);
            background: rgba(0,87,255,0.08);
            box-shadow: 0 0 0 3px rgba(0,87,255,0.15);
        }

        .field-wrap input:focus + .field-icon,
        .field-wrap select:focus + .field-icon {
            color: var(--sky-glow);
        }

        /* Fix icon for inputs (icon before not after) */
        .field-wrap input,
        .field-wrap select,
        .field-wrap textarea {
            padding-left: 42px;
        }

        /* password toggle */
        .toggle-pw {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: rgba(255,255,255,0.3);
            cursor: pointer;
            font-size: 16px;
            padding: 4px;
            transition: color 0.2s;
        }

        .toggle-pw:hover { color: rgba(255,255,255,0.7); }

        /* date input fix */
        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(0.5);
            cursor: pointer;
        }

        /* ===== DIVIDER ===== */
        .section-label {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 8px 0;
            grid-column: 1 / -1;
        }

        .section-label span {
            font-size: 0.75rem;
            color: rgba(255,255,255,0.25);
            font-weight: 500;
            letter-spacing: 1px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .section-label::before,
        .section-label::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.07);
        }

        /* ===== SUBMIT BUTTON ===== */
        .btn-submit {
            width: 100%;
            padding: 16px;
            background: var(--sky);
            border: none;
            border-radius: 14px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 0.3px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s;
            box-shadow: 0 8px 32px rgba(0,87,255,0.35);
            margin-top: 8px;
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }

        .btn-submit:hover {
            background: var(--sky-glow);
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(0,87,255,0.5);
        }

        .btn-submit:hover::before { transform: translateX(100%); }
        .btn-submit:active { transform: translateY(0); }

        .btn-inner {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        /* ===== FOOTER LINK ===== */
        .form-footer {
            text-align: center;
            margin-top: 24px;
            color: rgba(255,255,255,0.4);
            font-size: 0.9rem;
        }

        .form-footer a {
            color: #7aaeff;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .form-footer a:hover { color: white; }

        /* ===== STRENGTH INDICATOR ===== */
        .strength-bar {
            display: flex;
            gap: 4px;
            margin-top: 8px;
        }

        .strength-seg {
            flex: 1;
            height: 3px;
            border-radius: 99px;
            background: rgba(255,255,255,0.1);
            transition: background 0.3s;
        }

        .strength-seg.active-weak { background: #ef4444; }
        .strength-seg.active-medium { background: var(--gold); }
        .strength-seg.active-strong { background: #10b981; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 640px) {
            .navbar { padding: 16px 20px; }
            .form-card { padding: 28px 20px; }
            .form-header h1 { font-size: 1.8rem; }
            .form-grid { grid-template-columns: 1fr; }
            .form-grid .full { grid-column: 1; }
        }
    </style>
</head>
<body>

<!-- ANIMATED BACKGROUND -->
<div class="sky-bg">
    <div class="stars" id="stars"></div>
    <!-- Flying plane -->
    <div class="plane-trail">
        <div class="trail-line"></div>
        <svg class="plane-svg" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M44 20L8 4L12 22L8 24L4 20L2 24L10 30L8 44L12 42L22 28L44 28L44 20Z" fill="white" fill-opacity="0.9"/>
        </svg>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="/Views/auth/index.jsp" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-text">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="/Views/auth/index.jsp" class="nav-link">Home</a>
        <a href="/Views/auth/login.jsp" class="nav-link cta">Sign In</a>
    </div>
</nav>

<!-- PAGE -->
<div class="page-wrapper">
    <div class="register-container">

        <!-- HEADER -->
        <div class="form-header">
            <div class="header-badge">✦ Create Account</div>
            <h1>Join <span>SkyConnect</span><br>Today</h1>
            <p>Book flights, manage trips, fly smarter.</p>
        </div>

        <!-- CARD -->
        <div class="form-card">

            <!-- ALERTS -->
            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
            %>
            <% if (error != null) { %>
                <div class="alert alert-error">⚠ <%= error %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="alert alert-success">✓ <%= success %></div>
            <% } %>

            <form action="register" method="post" id="regForm">
                <div class="form-grid">

                    <!-- PERSONAL INFO LABEL -->
                    <div class="section-label">
                        <span>Personal Info</span>
                    </div>

                    <!-- Full Name -->
                    <div class="field full">
                        <label>Full Name</label>
                        <div class="field-wrap">
                            <span class="field-icon">👤</span>
                            <input type="text" name="name" placeholder="Your full name" required autocomplete="name">
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="field">
                        <label>Email Address</label>
                        <div class="field-wrap">
                            <span class="field-icon">✉</span>
                            <input type="email" name="email" placeholder="you@example.com" required autocomplete="email">
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="field">
                        <label>Phone Number</label>
                        <div class="field-wrap">
                            <span class="field-icon">📱</span>
                            <input type="text" name="phone" maxlength="10" placeholder="10-digit number" required>
                        </div>
                    </div>

                    <!-- DOB -->
                    <div class="field">
                        <label>Date of Birth</label>
                        <div class="field-wrap">
                            <span class="field-icon">🎂</span>
                            <input type="date" name="dob" required>
                        </div>
                    </div>

                    <!-- Gender -->
                    <div class="field">
                        <label>Gender</label>
                        <div class="field-wrap">
                            <span class="field-icon">⚧</span>
                            <select name="gender" required>
                                <option value="">Select gender</option>
                                <option value="MALE">Male</option>
                                <option value="FEMALE">Female</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="field full">
                        <label>Address</label>
                        <div class="field-wrap">
                            <span class="field-icon" style="top:22px;transform:none;">📍</span>
                            <textarea name="address" placeholder="Your full residential address" required></textarea>
                        </div>
                    </div>

                    <!-- SECURITY LABEL -->
                    <div class="section-label">
                        <span>Security</span>
                    </div>

                    <!-- Password -->
                    <div class="field full">
                        <label>Password</label>
                        <div class="field-wrap">
                            <span class="field-icon">🔒</span>
                            <input type="password" name="password" id="pwInput" placeholder="Create a strong password" required autocomplete="new-password">
                            <button type="button" class="toggle-pw" id="togglePw" onclick="togglePassword()">👁</button>
                        </div>
                        <div class="strength-bar">
                            <div class="strength-seg" id="s1"></div>
                            <div class="strength-seg" id="s2"></div>
                            <div class="strength-seg" id="s3"></div>
                            <div class="strength-seg" id="s4"></div>
                        </div>
                    </div>

                </div>

                <input type="hidden" name="role" value="USER">

                <button type="submit" class="btn-submit">
                    <div class="btn-inner">
                        <span>Create My Account</span>
                        <span>→</span>
                    </div>
                </button>
            </form>

        </div>

        <p class="form-footer">
            Already have an account? <a href="/Views/auth/login.jsp">Sign in here</a>
        </p>

    </div>
</div>

<script>
    // Generate stars
    const starsEl = document.getElementById('stars');
    for (let i = 0; i < 120; i++) {
        const s = document.createElement('div');
        s.className = 'star';
        const size = Math.random() * 2.5 + 0.5;
        s.style.cssText = `
            width:${size}px;height:${size}px;
            top:${Math.random()*100}%;left:${Math.random()*100}%;
            --dur:${2+Math.random()*4}s;
            --delay:${Math.random()*5}s;
            --opacity:${0.3+Math.random()*0.7};
        `;
        starsEl.appendChild(s);
    }

    // Password toggle
    function togglePassword() {
        const inp = document.getElementById('pwInput');
        inp.type = inp.type === 'password' ? 'text' : 'password';
    }

    // Password strength
    document.getElementById('pwInput').addEventListener('input', function() {
        const val = this.value;
        const segs = [document.getElementById('s1'),document.getElementById('s2'),document.getElementById('s3'),document.getElementById('s4')];
        let score = 0;
        if (val.length >= 6) score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val) && /[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;

        const cls = score <= 1 ? 'active-weak' : score <= 2 ? 'active-medium' : 'active-strong';
        segs.forEach((seg, i) => {
            seg.className = 'strength-seg';
            if (i < score) seg.classList.add(cls);
        });
    });

    // Field focus animations
    document.querySelectorAll('.field-wrap input, .field-wrap select, .field-wrap textarea').forEach(el => {
        el.addEventListener('focus', function() {
            const icon = this.parentElement.querySelector('.field-icon');
            if (icon) icon.style.color = '#4D8AFF';
        });
        el.addEventListener('blur', function() {
            const icon = this.parentElement.querySelector('.field-icon');
            if (icon) icon.style.color = 'rgba(255,255,255,0.25)';
        });
    });

    // Stagger field animations
    document.querySelectorAll('.field').forEach((f, i) => {
        f.style.opacity = '0';
        f.style.transform = 'translateY(16px)';
        f.style.transition = `all 0.4s ease ${0.35 + i * 0.05}s`;
        setTimeout(() => {
            f.style.opacity = '1';
            f.style.transform = 'translateY(0)';
        }, 100);
    });
</script>

</body>
</html>
