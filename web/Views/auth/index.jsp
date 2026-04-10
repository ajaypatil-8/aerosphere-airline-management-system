<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AeroSphere – Airline Reservation System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #10B981;
            --primary-dark: #059669;
            --primary-glow: rgba(16,185,129,0.2);
            --accent: #A7F3D0;
            --bg: #FAFAF9;
            --card-bg: #FFFFFF;
            --text: #1C1917;
            --text-muted: #6B7280;
            --border: #E5E7EB;
            --shadow: 0 4px 24px rgba(0,0,0,0.07);
            --shadow-lg: 0 12px 48px rgba(0,0,0,0.12);
            --radius: 14px;
            --navbar-bg: rgba(250,250,249,0.85);
        }
        [data-theme="dark"] {
            --primary: #10B981;
            --primary-dark: #34D399;
            --primary-glow: rgba(16,185,129,0.25);
            --accent: #34D399;
            --bg: #0A0A0A;
            --card-bg: #141414;
            --text: #F5F5F4;
            --text-muted: #9CA3AF;
            --border: #262626;
            --shadow: 0 4px 24px rgba(0,0,0,0.4);
            --shadow-lg: 0 12px 48px rgba(0,0,0,0.5);
            --navbar-bg: rgba(10,10,10,0.9);
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); transition: background 0.3s, color 0.3s; overflow-x: hidden; }

        /* === NAVBAR === */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 200;
            display: flex; align-items: center; justify-content: space-between;
            padding: 14px 48px;
            background: var(--navbar-bg);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            transition: all 0.3s;
        }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .brand-icon {
            width: 36px; height: 36px; background: var(--primary); border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 17px;
            box-shadow: 0 4px 12px var(--primary-glow);
        }
        .brand-name { font-weight: 800; font-size: 1.15rem; letter-spacing: -0.5px; }
        .brand-name span { color: var(--primary); }
        .nav-right { display: flex; align-items: center; gap: 8px; }
        .nav-link {
            text-decoration: none; color: var(--text-muted); padding: 8px 14px;
            border-radius: 8px; font-size: 0.88rem; font-weight: 500; transition: all 0.2s;
        }
        .nav-link:hover { color: var(--text); background: var(--border); }
        .nav-link.btn-nav {
            background: var(--primary); color: #fff; font-weight: 600;
            box-shadow: 0 4px 12px var(--primary-glow);
        }
        .nav-link.btn-nav:hover { background: var(--primary-dark); transform: translateY(-1px); }
        .user-pill {
            display: flex; align-items: center; gap: 8px;
            background: var(--primary-glow); border: 1px solid var(--primary);
            border-radius: 99px; padding: 6px 14px; font-size: 0.84rem;
            color: var(--primary); font-weight: 600;
        }
        .theme-toggle {
            width: 36px; height: 36px; border: 1px solid var(--border); border-radius: 8px;
            background: var(--card-bg); cursor: pointer; display: flex; align-items: center;
            justify-content: center; font-size: 16px; transition: all 0.2s; color: var(--text);
        }
        .theme-toggle:hover { border-color: var(--primary); background: var(--primary-glow); }

        /* === HERO === */
        .hero {
            min-height: 100vh; display: flex; flex-direction: column;
            align-items: center; justify-content: center; text-align: center;
            padding: 120px 20px 80px; position: relative;
        }
        .hero-bg {
            position: absolute; inset: 0; z-index: -1;
            background: radial-gradient(ellipse 70% 60% at 50% -10%, var(--primary-glow), transparent 60%);
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: var(--primary-glow); border: 1px solid var(--primary);
            border-radius: 99px; padding: 7px 18px; font-size: 0.78rem;
            color: var(--primary); font-weight: 600; letter-spacing: 0.8px;
            text-transform: uppercase; margin-bottom: 28px;
            animation: fadeUp 0.6s ease both 0.1s;
        }
        .hero-badge::before {
            content: ''; width: 6px; height: 6px; background: var(--primary);
            border-radius: 50%; animation: pulse 2s infinite;
        }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .hero-title {
            font-size: clamp(2.8rem, 7vw, 5.5rem); font-weight: 900;
            line-height: 1.05; letter-spacing: -2.5px; margin-bottom: 22px;
            animation: fadeUp 0.7s ease both 0.2s;
        }
        .hero-title .accent { color: var(--primary); }
        .hero-sub {
            color: var(--text-muted); font-size: 1.1rem; max-width: 480px;
            line-height: 1.7; margin-bottom: 38px;
            animation: fadeUp 0.7s ease both 0.3s;
        }
        .hero-actions {
            display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;
            animation: fadeUp 0.7s ease both 0.4s;
        }
        .btn-hero {
            display: inline-flex; align-items: center; gap: 8px; padding: 14px 26px;
            border-radius: 12px; text-decoration: none; font-weight: 600;
            font-size: 0.95rem; transition: all 0.25s; border: none; cursor: pointer;
        }
        .btn-hero.primary {
            background: var(--primary); color: #fff;
            box-shadow: 0 6px 24px var(--primary-glow);
        }
        .btn-hero.primary:hover { background: var(--primary-dark); transform: translateY(-2px); box-shadow: 0 10px 32px var(--primary-glow); }
        .btn-hero.secondary {
            background: var(--card-bg); color: var(--text);
            border: 1px solid var(--border); box-shadow: var(--shadow);
        }
        .btn-hero.secondary:hover { border-color: var(--primary); transform: translateY(-2px); }

        /* === SEARCH CARD === */
        .search-section { padding: 0 20px 80px; display: flex; justify-content: center; }
        .search-card {
            width: 100%; max-width: 860px; background: var(--card-bg);
            border: 1px solid var(--border); border-radius: 20px; padding: 32px 36px;
            box-shadow: var(--shadow-lg); position: relative; overflow: hidden;
        }
        .search-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
            background: linear-gradient(90deg, var(--primary), var(--accent), var(--primary));
        }
        .search-card-title {
            display: flex; align-items: center; gap: 10px; margin-bottom: 24px;
        }
        .search-card-title h2 { font-size: 1.2rem; font-weight: 700; }
        .search-card-title span { font-size: 0.82rem; color: var(--text-muted); }
        .search-grid {
            display: grid; grid-template-columns: 1fr 1fr 1fr 110px 110px;
            gap: 12px; align-items: end;
        }
        .sf { display: flex; flex-direction: column; gap: 6px; }
        .sf label { font-size: 0.73rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.6px; }
        .sf-wrap { position: relative; }
        .sf-wrap input, .sf-wrap select {
            width: 100%; padding: 11px 12px 11px 36px;
            background: var(--bg); border: 1.5px solid var(--border); border-radius: 10px;
            color: var(--text); font-family: 'Inter', sans-serif; font-size: 0.88rem;
            outline: none; transition: all 0.2s; appearance: none;
        }
        .sf-wrap input:focus, .sf-wrap select:focus {
            border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow);
        }
        .sf-icon { position: absolute; left: 11px; top: 50%; transform: translateY(-50%); font-size: 13px; pointer-events: none; }
        .btn-search {
            padding: 11px 16px; background: var(--primary); color: #fff; border: none;
            border-radius: 10px; font-weight: 700; font-size: 0.88rem; cursor: pointer;
            transition: all 0.2s; box-shadow: 0 4px 14px var(--primary-glow);
            white-space: nowrap;
        }
        .btn-search:hover { background: var(--primary-dark); transform: translateY(-1px); }

        /* === STATS === */
        .stats-section { padding: 0 20px 80px; display: flex; justify-content: center; }
        .stats-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; max-width: 860px; width: 100%; }
        .stat-card {
            background: var(--card-bg); border: 1px solid var(--border); border-radius: 16px;
            padding: 22px; text-align: center; transition: all 0.3s; box-shadow: var(--shadow);
        }
        .stat-card:hover { border-color: var(--primary); transform: translateY(-4px); box-shadow: var(--shadow-lg); }
        .stat-num { font-size: 2rem; font-weight: 900; color: var(--primary); letter-spacing: -1px; }
        .stat-label { font-size: 0.8rem; color: var(--text-muted); margin-top: 5px; font-weight: 500; }

        /* === FEATURES === */
        .features-section { padding: 0 20px 80px; text-align: center; }
        .section-title { font-size: 2.2rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 10px; }
        .section-sub { color: var(--text-muted); font-size: 0.95rem; margin-bottom: 40px; }
        .features-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 18px; max-width: 860px; margin: 0 auto; }
        .feature-card {
            background: var(--card-bg); border: 1px solid var(--border); border-radius: 18px;
            padding: 26px 22px; text-align: left; transition: all 0.3s; box-shadow: var(--shadow);
        }
        .feature-card:hover { border-color: var(--primary); transform: translateY(-5px); box-shadow: var(--shadow-lg); }
        .feature-icon {
            width: 46px; height: 46px; background: var(--primary-glow); border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; margin-bottom: 16px;
        }
        .feature-card h3 { font-size: 1rem; font-weight: 700; margin-bottom: 8px; }
        .feature-card p { color: var(--text-muted); font-size: 0.85rem; line-height: 1.65; }

        /* === FOOTER === */
        .footer {
            border-top: 1px solid var(--border); padding: 26px 48px;
            display: flex; align-items: center; justify-content: space-between;
            background: var(--card-bg);
        }
        .footer-brand { font-weight: 800; font-size: 1rem; }
        .footer-brand span { color: var(--primary); }
        .footer-text { color: var(--text-muted); font-size: 0.82rem; }

        /* Scroll hint */
        .scroll-hint {
            position: absolute; bottom: 28px; left: 50%; transform: translateX(-50%);
            display: flex; flex-direction: column; align-items: center; gap: 6px;
            color: var(--text-muted); font-size: 0.72rem; letter-spacing: 1px;
            text-transform: uppercase; animation: bob 2s ease-in-out infinite;
        }
        @keyframes bob { 0%,100%{transform:translateX(-50%) translateY(0)} 50%{transform:translateX(-50%) translateY(6px)} }
        .scroll-arrow { width: 18px; height: 18px; border-right: 1.5px solid var(--text-muted); border-bottom: 1.5px solid var(--text-muted); transform: rotate(45deg); }

        /* Responsive */
        @media(max-width:860px) { .search-grid{grid-template-columns:1fr 1fr} .stats-row{grid-template-columns:repeat(2,1fr)} .features-grid{grid-template-columns:1fr 1fr} }
        @media(max-width:600px) { .navbar{padding:12px 20px} .search-grid{grid-template-columns:1fr} .features-grid{grid-template-columns:1fr} .footer{flex-direction:column;gap:8px;text-align:center} .search-card{padding:24px 18px} }
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
        <a href="#search" class="nav-link">Search</a>
        <% if (userName != null) { %>
            <% if ("ADMIN".equals(userRole)) { %>
                <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">Search</a>
                <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link">✈️ All Flights</a>
                <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">My Bookings</a>
                <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">Refunds</a>
                <a href="${pageContext.request.contextPath}/profile"           class="nav-link">Profile</a>
            <% } %>
            <div class="user-pill">✈ <%= userName %></div>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-nav">Logout</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/login" class="nav-link">Sign In</a>
            <a href="${pageContext.request.contextPath}/register" class="nav-link btn-nav">Register →</a>
        <% } %>
        <button class="theme-toggle" id="themeToggle" onclick="toggleTheme()" title="Toggle theme">🌙</button>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-badge">✦ Airline Reservation System</div>
    <h1 class="hero-title">Fly Smarter,<br><span class="accent">Book Faster</span></h1>
    <p class="hero-sub">Discover flights, reserve seats and manage your travels — all in one seamless platform.</p>
    <div class="hero-actions">
        <% if (userName != null) { %>
            <% if ("ADMIN".equals(userRole)) { %>
                <a href="${pageContext.request.contextPath}/adminDashboard" class="btn-hero primary">Admin Dashboard →</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/userDashboard" class="btn-hero primary">My Dashboard →</a>
            <% } %>
            <a href="#search" class="btn-hero secondary">Search Flights</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/register" class="btn-hero primary">Get Started Free →</a>
            <a href="#search" class="btn-hero secondary">Search Flights</a>
        <% } %>
    </div>
    <div class="scroll-hint"><span>Scroll</span><div class="scroll-arrow"></div></div>
</section>

<!-- SEARCH -->
<section class="search-section" id="search">
    <div class="search-card">
        <div class="search-card-title">
            <span style="font-size:20px">🔍</span>
            <h2>Search Available Flights</h2>
            <span>Find the best routes instantly</span>
        </div>
        <form action="${pageContext.request.contextPath}/searchFlights" method="get">
            <div class="search-grid">
                <div class="sf">
                    <label>From</label>
                    <div class="sf-wrap"><span class="sf-icon">🛫</span><input type="text" name="source" placeholder="e.g. Mumbai" required></div>
                </div>
                <div class="sf">
                    <label>To</label>
                    <div class="sf-wrap"><span class="sf-icon">🛬</span><input type="text" name="destination" placeholder="e.g. Delhi" required></div>
                </div>
                <div class="sf">
                    <label>Departure Date</label>
                    <div class="sf-wrap"><span class="sf-icon">📅</span><input type="date" name="departDate" min="<%= java.time.LocalDate.now() %>" required></div>
                </div>
                <div class="sf">
                    <label>Seats</label>
                    <div class="sf-wrap"><span class="sf-icon">👥</span><input type="number" name="numSeats" min="1" max="9" value="1" required></div>
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
        <div class="stat-card"><div class="stat-num">50+</div><div class="stat-label">Daily Flights</div></div>
        <div class="stat-card"><div class="stat-num">20+</div><div class="stat-label">Destinations</div></div>
        <div class="stat-card"><div class="stat-num">10K+</div><div class="stat-label">Happy Passengers</div></div>
        <div class="stat-card"><div class="stat-num">99%</div><div class="stat-label">On-Time Rate</div></div>
    </div>
</section>

<!-- FEATURES -->
<section class="features-section">
    <h2 class="section-title">Everything You Need</h2>
    <p class="section-sub">From booking to boarding, we've got it covered.</p>
    <div class="features-grid">
        <div class="feature-card"><div class="feature-icon">✈</div><h3>Smart Flight Search</h3><p>Find flights by source, destination and date with real-time seat availability.</p></div>
        <div class="feature-card"><div class="feature-icon">💺</div><h3>Seat Selection</h3><p>Interactive seat map lets you pick your preferred seat before you fly.</p></div>
        <div class="feature-card"><div class="feature-icon">💳</div><h3>Secure Payments</h3><p>Multiple payment methods with instant confirmation and digital invoices.</p></div>
        <div class="feature-card"><div class="feature-icon">📋</div><h3>Booking Management</h3><p>View, modify or cancel bookings anytime from your personal dashboard.</p></div>
        <div class="feature-card"><div class="feature-icon">↩</div><h3>Easy Refunds</h3><p>Cancellation and refund requests processed quickly with full transparency.</p></div>
        <div class="feature-card"><div class="feature-icon">🛡</div><h3>Admin Controls</h3><p>Full admin panel to manage flights, users, bookings and generate reports.</p></div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    <span class="footer-brand">Aero<span>Sphere</span></span>
    <span class="footer-text">© 2026 AeroSphere Airline Reservation System — Built with Java, JSP &amp; MySQL</span>
</footer>

<script>
    // Theme system
    const savedTheme = localStorage.getItem('aerosphere-theme') || 
        (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    document.documentElement.setAttribute('data-theme', savedTheme);
    document.getElementById('themeToggle').textContent = savedTheme === 'dark' ? '☀️' : '🌙';

    function toggleTheme() {
        const current = document.documentElement.getAttribute('data-theme');
        const next = current === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        localStorage.setItem('aerosphere-theme', next);
        document.getElementById('themeToggle').textContent = next === 'dark' ? '☀️' : '🌙';
    }

    // Scroll reveal
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(e => {
            if (e.isIntersecting) {
                e.target.style.opacity = '1';
                e.target.style.transform = 'translateY(0)';
                observer.unobserve(e.target);
            }
        });
    }, { threshold: 0.1 });
    document.querySelectorAll('.stat-card, .feature-card').forEach((el, i) => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(24px)';
        el.style.transition = `all 0.5s ease ${i * 0.06}s`;
        observer.observe(el);
    });
</script>
</body>
</html>
