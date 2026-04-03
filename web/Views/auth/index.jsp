<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkyConnect – Airline Reservation System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --sky: #0057FF;
            --sky-deep: #0039B5;
            --sky-glow: #4D8AFF;
            --gold: #FFB800;
            --ink: #080C1A;
            --ink-2: #0d1530;
            --white: #ffffff;
            --text-muted: rgba(255,255,255,0.45);
            --glass: rgba(255,255,255,0.05);
            --border: rgba(255,255,255,0.1);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--ink);
            color: white;
            overflow-x: hidden;
        }

        /* ===== BACKGROUND ===== */
        .bg-canvas {
            position: fixed;
            inset: 0;
            z-index: 0;
            background:
                radial-gradient(ellipse 80% 55% at 10% 15%, #05174d 0%, transparent 55%),
                radial-gradient(ellipse 60% 45% at 90% 85%, #030e36 0%, transparent 55%),
                linear-gradient(160deg, #040812, #080d20 50%, #040812);
        }

        .stars { position: fixed; inset: 0; z-index: 0; pointer-events: none; }
        .star {
            position: absolute; border-radius: 50%; background: white;
            animation: twinkle var(--dur, 3s) ease-in-out infinite;
            animation-delay: var(--delay, 0s); opacity: 0;
        }
        @keyframes twinkle {
            0%, 100% { opacity: 0; }
            50% { opacity: var(--op, 0.6); }
        }

        /* Floating planes */
        .float-plane {
            position: fixed;
            z-index: 1;
            pointer-events: none;
            animation: floatPlane var(--dur, 25s) linear infinite;
            opacity: 0;
        }
        @keyframes floatPlane {
            0% { left: -80px; top: var(--ty, 20%); opacity: 0; }
            5% { opacity: var(--op, 0.12); }
            95% { opacity: var(--op, 0.12); }
            100% { left: 110%; top: var(--ty2, 15%); opacity: 0; }
        }

        /* ===== NAVBAR ===== */
        .navbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 200;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 48px;
            background: rgba(4, 8, 18, 0.6);
            backdrop-filter: blur(24px);
            border-bottom: 1px solid rgba(255,255,255,0.06);
            transition: background 0.3s;
        }

        .navbar.scrolled { background: rgba(4, 8, 18, 0.92); }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: white;
        }

        .brand-icon {
            width: 38px; height: 38px;
            background: var(--sky);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px;
            box-shadow: 0 4px 16px rgba(0,87,255,0.4);
        }

        .brand-name {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.2rem;
            letter-spacing: -0.3px;
        }

        .brand-name span { color: var(--gold); }

        .nav-links { display: flex; gap: 4px; align-items: center; }

        .nav-link {
            text-decoration: none;
            color: rgba(255,255,255,0.6);
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        .nav-link:hover { color: white; background: var(--glass); }
        .nav-link.btn-nav {
            background: var(--sky);
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(0,87,255,0.3);
        }
        .nav-link.btn-nav:hover { background: var(--sky-glow); transform: translateY(-1px); }

        .user-pill {
            display: flex; align-items: center; gap: 8px;
            background: rgba(255,255,255,0.07);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 99px;
            padding: 6px 14px;
            font-size: 0.85rem;
            color: rgba(255,255,255,0.8);
        }

        /* ===== HERO ===== */
        .hero {
            position: relative;
            z-index: 10;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 120px 20px 80px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(0,87,255,0.12);
            border: 1px solid rgba(0,87,255,0.25);
            border-radius: 99px;
            padding: 8px 20px;
            font-size: 0.78rem;
            color: #7aaeff;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 28px;
            animation: badgeIn 0.6s ease both 0.2s;
        }

        @keyframes badgeIn {
            from { opacity: 0; transform: translateY(10px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .hero-badge::before {
            content: '';
            width: 6px; height: 6px;
            background: #4D8AFF;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }

        .hero-title {
            font-family: 'Syne', sans-serif;
            font-size: clamp(3rem, 8vw, 6.5rem);
            font-weight: 800;
            line-height: 1.05;
            letter-spacing: -3px;
            color: white;
            margin-bottom: 24px;
            animation: titleIn 0.8s cubic-bezier(0.16,1,0.3,1) both 0.3s;
        }

        @keyframes titleIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-title .accent {
            background: linear-gradient(90deg, #4D8AFF, #a5c4ff 60%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-sub {
            color: var(--text-muted);
            font-size: 1.15rem;
            max-width: 500px;
            line-height: 1.7;
            margin-bottom: 40px;
            animation: titleIn 0.8s cubic-bezier(0.16,1,0.3,1) both 0.45s;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
            animation: titleIn 0.8s cubic-bezier(0.16,1,0.3,1) both 0.55s;
        }

        .btn-hero {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            border-radius: 13px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
        }

        .btn-hero.primary {
            background: var(--sky);
            color: white;
            box-shadow: 0 8px 32px rgba(0,87,255,0.35);
        }

        .btn-hero.primary:hover {
            background: var(--sky-glow);
            transform: translateY(-3px);
            box-shadow: 0 14px 40px rgba(0,87,255,0.5);
        }

        .btn-hero.secondary {
            background: rgba(255,255,255,0.07);
            color: white;
            border: 1px solid rgba(255,255,255,0.15);
        }

        .btn-hero.secondary:hover {
            background: rgba(255,255,255,0.12);
            transform: translateY(-2px);
        }

        /* Scroll indicator */
        .scroll-hint {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            color: rgba(255,255,255,0.2);
            font-size: 0.75rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            animation: bobUp 2s ease-in-out infinite;
        }

        @keyframes bobUp {
            0%, 100% { transform: translateX(-50%) translateY(0); }
            50% { transform: translateX(-50%) translateY(6px); }
        }

        .scroll-arrow {
            width: 20px; height: 20px;
            border-right: 1.5px solid rgba(255,255,255,0.2);
            border-bottom: 1.5px solid rgba(255,255,255,0.2);
            transform: rotate(45deg);
        }

        /* ===== SEARCH SECTION ===== */
        .search-section {
            position: relative;
            z-index: 10;
            padding: 0 20px 100px;
            display: flex;
            justify-content: center;
        }

        .search-card {
            width: 100%;
            max-width: 900px;
            background: rgba(10, 18, 45, 0.75);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 36px 40px;
            backdrop-filter: blur(30px);
            box-shadow: 0 32px 80px rgba(0,0,0,0.5);
            position: relative;
            overflow: hidden;
        }

        .search-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--sky), var(--sky-glow), transparent);
        }

        .search-card-title {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
        }

        .search-card-title h2 {
            font-family: 'Syne', sans-serif;
            font-size: 1.4rem;
            font-weight: 700;
            color: white;
        }

        .search-card-title span {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.35);
            font-weight: 400;
        }

        .search-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 120px 120px;
            gap: 14px;
            align-items: end;
        }

        .sf {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .sf label {
            font-size: 0.75rem;
            font-weight: 600;
            color: rgba(255,255,255,0.35);
            letter-spacing: 0.8px;
            text-transform: uppercase;
        }

        .sf-wrap { position: relative; }

        .sf-icon {
            position: absolute;
            left: 13px; top: 50%;
            transform: translateY(-50%);
            font-size: 14px;
            color: rgba(255,255,255,0.2);
            pointer-events: none;
        }

        .sf-wrap input,
        .sf-wrap select {
            width: 100%;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 12px 14px 12px 38px;
            color: white;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            outline: none;
            transition: all 0.2s;
            appearance: none;
        }

        .sf-wrap input::placeholder { color: rgba(255,255,255,0.2); }

        .sf-wrap input:focus,
        .sf-wrap select:focus {
            border-color: var(--sky);
            background: rgba(0,87,255,0.08);
            box-shadow: 0 0 0 3px rgba(0,87,255,0.12);
        }

        .sf-wrap select option { background: #0d1533; }

        input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.5); cursor: pointer; }

        .btn-search {
            padding: 13px 20px;
            background: var(--sky);
            color: white;
            border: none;
            border-radius: 12px;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 6px 20px rgba(0,87,255,0.3);
            white-space: nowrap;
        }

        .btn-search:hover { background: var(--sky-glow); transform: translateY(-2px); box-shadow: 0 10px 30px rgba(0,87,255,0.45); }

        /* ===== STATS ===== */
        .stats-section {
            position: relative;
            z-index: 10;
            padding: 0 20px 100px;
            display: flex;
            justify-content: center;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            max-width: 900px;
            width: 100%;
        }

        .stat-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 18px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s;
        }

        .stat-card:hover {
            background: rgba(0,87,255,0.08);
            border-color: rgba(0,87,255,0.25);
            transform: translateY(-4px);
        }

        .stat-num {
            font-family: 'Syne', sans-serif;
            font-size: 2.2rem;
            font-weight: 800;
            color: white;
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 6px;
            font-weight: 500;
        }

        /* ===== FEATURES ===== */
        .features-section {
            position: relative;
            z-index: 10;
            padding: 0 20px 100px;
            text-align: center;
        }

        .section-title {
            font-family: 'Syne', sans-serif;
            font-size: 2.4rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 12px;
        }

        .section-sub {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-bottom: 48px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            max-width: 900px;
            margin: 0 auto;
        }

        .feature-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 20px;
            padding: 28px 24px;
            text-align: left;
            transition: all 0.35s;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(0,87,255,0.05), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .feature-card:hover {
            border-color: rgba(0,87,255,0.3);
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
        }

        .feature-card:hover::before { opacity: 1; }

        .feature-icon {
            width: 48px; height: 48px;
            background: rgba(0,87,255,0.15);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px;
            margin-bottom: 18px;
        }

        .feature-card h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.05rem;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
        }

        .feature-card p {
            color: var(--text-muted);
            font-size: 0.87rem;
            line-height: 1.65;
        }

        /* ===== FOOTER ===== */
        .footer {
            position: relative;
            z-index: 10;
            border-top: 1px solid rgba(255,255,255,0.06);
            padding: 30px 48px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(4,8,18,0.5);
        }

        .footer-brand {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            color: white;
        }

        .footer-brand span { color: var(--gold); }

        .footer-text { color: rgba(255,255,255,0.25); font-size: 0.82rem; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 900px) {
            .search-grid { grid-template-columns: 1fr 1fr; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .features-grid { grid-template-columns: 1fr 1fr; }
        }

        @media (max-width: 640px) {
            .navbar { padding: 14px 20px; }
            .search-grid { grid-template-columns: 1fr; }
            .features-grid { grid-template-columns: 1fr; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .footer { flex-direction: column; gap: 10px; text-align: center; }
            .search-card { padding: 28px 20px; }
        }
    </style>
</head>
<body>

<!-- BACKGROUND -->
<div class="bg-canvas"></div>
<div class="stars" id="stars"></div>

<!-- Floating planes -->
<div class="float-plane" style="--ty:12%;--ty2:8%;--dur:28s;font-size:32px;animation-delay:0s;--op:0.1">✈</div>
<div class="float-plane" style="--ty:55%;--ty2:50%;--dur:35s;font-size:22px;animation-delay:8s;--op:0.07">✈</div>
<div class="float-plane" style="--ty:75%;--ty2:70%;--dur:22s;font-size:18px;animation-delay:14s;--op:0.08">✈</div>

<!-- NAVBAR -->
<nav class="navbar" id="navbar">
    <a href="/Views/auth/index.jsp" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="#search" class="nav-link">Search</a>

        <% if (userName != null) { %>
            <% if ("ADMIN".equals(userRole)) { %>
                <a href="adminDashboard" class="nav-link">Dashboard</a>
            <% } else { %>
                <a href="userDashboard" class="nav-link">Dashboard</a>
                <a href="userBookings" class="nav-link">My Bookings</a>
            <% } %>
            <div class="user-pill">👤 <%= userName %></div>
            <a href="logout" class="nav-link btn-nav">Logout</a>
        <% } else { %>
            <a href="/Views/auth/login.jsp" class="nav-link">Sign In</a>
            <a href="register.jsp" class="nav-link btn-nav">Register →</a>
        <% } %>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-badge">✦ Airline Reservation System</div>

    <h1 class="hero-title">
        Fly Smarter,<br>
        <span class="accent">Book Faster</span>
    </h1>

    <p class="hero-sub">
        Discover flights, reserve seats and manage your travels — all in one seamless platform.
    </p>

    <div class="hero-actions">
        <% if (userName != null) { %>
            <% if ("ADMIN".equals(userRole)) { %>
                <a href="adminDashboard" class="btn-hero primary">Admin Dashboard →</a>
            <% } else { %>
                <a href="userDashboard" class="btn-hero primary">My Dashboard →</a>
            <% } %>
            <a href="#search" class="btn-hero secondary">Search Flights</a>
        <% } else { %>
            <a href="register.jsp" class="btn-hero primary">Get Started Free →</a>
            <a href="#search" class="btn-hero secondary">Search Flights</a>
        <% } %>
    </div>

    <div class="scroll-hint">
        <span>Scroll</span>
        <div class="scroll-arrow"></div>
    </div>
</section>

<!-- FLIGHT SEARCH -->
<section class="search-section" id="search">
    <div class="search-card">
        <div class="search-card-title">
            <span style="font-size:22px">🔍</span>
            <h2>Search Available Flights</h2>
            <span>Find the best routes instantly</span>
        </div>

        <form action="searchFlights" method="get">
            <div class="search-grid">

                <div class="sf">
                    <label>From</label>
                    <div class="sf-wrap">
                        <span class="sf-icon">🛫</span>
                        <input type="text" name="source" placeholder="e.g. Mumbai" required>
                    </div>
                </div>

                <div class="sf">
                    <label>To</label>
                    <div class="sf-wrap">
                        <span class="sf-icon">🛬</span>
                        <input type="text" name="destination" placeholder="e.g. Delhi" required>
                    </div>
                </div>

                <div class="sf">
                    <label>Departure Date</label>
                    <div class="sf-wrap">
                        <span class="sf-icon">📅</span>
                        <input type="date" name="departDate" min="<%= java.time.LocalDate.now() %>" required>
                    </div>
                </div>

                <div class="sf">
                    <label>Seats</label>
                    <div class="sf-wrap">
                        <span class="sf-icon">👥</span>
                        <input type="number" name="numSeats" min="1" max="9" value="1" required style="padding-left:38px;">
                    </div>
                </div>

                <div class="sf">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn-search">Search ✈</button>
                </div>

            </div>
        </form>
    </div>
</section>

<!-- STATS -->
<section class="stats-section">
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-num">50+</div>
            <div class="stat-label">Daily Flights</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">20+</div>
            <div class="stat-label">Destinations</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">10K+</div>
            <div class="stat-label">Happy Passengers</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">99%</div>
            <div class="stat-label">On-Time Rate</div>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="features-section">
    <h2 class="section-title">Everything You Need</h2>
    <p class="section-sub">From booking to boarding, we've got it covered.</p>

    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">✈</div>
            <h3>Smart Flight Search</h3>
            <p>Find flights by source, destination and date with real-time seat availability.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">💺</div>
            <h3>Seat Selection</h3>
            <p>Interactive seat map lets you pick your preferred seat before you fly.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">💳</div>
            <h3>Secure Payments</h3>
            <p>Multiple payment methods with instant confirmation and digital invoices.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📋</div>
            <h3>Booking Management</h3>
            <p>View, modify or cancel bookings anytime from your personal dashboard.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">↩</div>
            <h3>Easy Refunds</h3>
            <p>Cancellation and refund requests processed quickly with full transparency.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🛡</div>
            <h3>Admin Controls</h3>
            <p>Full admin panel to manage flights, users, bookings and generate reports.</p>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    <span class="footer-brand">Sky<span>Connect</span></span>
    <span class="footer-text">© 2026 SkyConnect Airline Reservation System — Built with Java, JSP & MySQL</span>
</footer>

<script>
    // Stars
    const starsEl = document.getElementById('stars');
    for (let i = 0; i < 130; i++) {
        const s = document.createElement('div');
        s.className = 'star';
        const sz = Math.random() * 2 + 0.5;
        s.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*6}s;--op:${0.3+Math.random()*0.6};`;
        starsEl.appendChild(s);
    }

    // Navbar scroll effect
    window.addEventListener('scroll', () => {
        document.getElementById('navbar').classList.toggle('scrolled', scrollY > 50);
    });

    // Scroll reveal for stat/feature cards
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((e, i) => {
            if (e.isIntersecting) {
                setTimeout(() => {
                    e.target.style.opacity = '1';
                    e.target.style.transform = 'translateY(0)';
                }, e.target.dataset.delay || 0);
                observer.unobserve(e.target);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.stat-card, .feature-card').forEach((el, i) => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'all 0.5s ease';
        el.dataset.delay = i * 60;
        observer.observe(el);
    });
</script>

</body>
</html>
