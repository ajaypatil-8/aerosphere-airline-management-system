<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!-- AeroSphere homepage — Premium redesign v1 (see aerosphere-redesign-master-prompt.md, Phase 1+2) -->
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>AeroSphere – Fly, Refined.</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>
:root{
  --bg:#FAFAF9;--s0:#FFFFFF;--s1:#F5F4F2;--s2:#EFEEEC;
  --text:#202A36;--muted:#6B7280;--faint:#9CA3AF;--border:#E7E5E4;
  --accent:#2E4A3D;--accent-dark:#253D33;--accent-glow:rgba(46,74,61,.14);
  --success:#5B8A6E;--error:#B3554A;--warning:#B8863F;
  --sh:0 1px 3px rgba(0,0,0,.05),0 4px 16px rgba(0,0,0,.04);
  --sh-lg:0 8px 32px rgba(0,0,0,.07);--sh-xl:0 24px 64px rgba(0,0,0,.10);--r:16px;
}
[data-theme="dark"]{
  --bg:#060B12;--s0:#11161D;--s1:#161C24;--s2:#1B222B;
  --text:#F4F4F3;--muted:#A8ADB4;--faint:#6B7280;--border:#232A33;
  --accent:#4A7A63;--accent-dark:#5B8F76;--accent-glow:rgba(74,122,99,.18);
  --success:#6FAE8B;--error:#C77A70;--warning:#D1A25C;
  --sh:0 1px 3px rgba(0,0,0,.35),0 4px 16px rgba(0,0,0,.25);
  --sh-lg:0 8px 32px rgba(0,0,0,.4);--sh-xl:0 24px 64px rgba(0,0,0,.55);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);overflow-x:hidden;min-height:100vh;transition:background .3s,color .3s}

/* ── Navbar (transparent over hero, solid once scrolled) ── */
.navbar{position:fixed;top:0;left:0;right:0;z-index:300;display:flex;align-items:center;padding:0 48px;height:66px;background:transparent;transition:background .3s,box-shadow .3s;--nav-fg:#fff;--nav-fg-muted:rgba(255,255,255,.82);--nav-border:rgba(255,255,255,.22)}
.navbar.scrolled{background:var(--s0);box-shadow:var(--sh-lg);--nav-fg:var(--text);--nav-fg-muted:var(--muted);--nav-border:var(--border)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--nav-fg);margin-right:auto;transition:color .3s}
.brand-icon{width:36px;height:36px;border-radius:10px;background:var(--nav-fg);color:var(--navbar-scrolled,var(--bg));display:flex;align-items:center;justify-content:center;font-size:16px;transition:background .3s}
.navbar.scrolled .brand-icon{background:var(--text);color:var(--s0)}
.navbar:not(.scrolled) .brand-icon{background:#fff;color:var(--accent)}
.brand-name{font-family:'Fraunces',serif;font-weight:500;font-size:1.2rem;letter-spacing:-.01em}
.nav-links{display:flex;align-items:center;gap:4px;margin:0 24px}
.nav-link{text-decoration:none;color:var(--nav-fg-muted);padding:8px 14px;border-radius:999px;font-size:.87rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--nav-fg);background:rgba(128,128,128,.12)}
.nav-right{display:flex;align-items:center;gap:10px}
.theme-btn{width:36px;height:36px;border:1px solid var(--nav-border);border-radius:999px;background:transparent;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.95rem;color:var(--nav-fg);transition:all .2s}
.theme-btn:hover{border-color:var(--nav-fg)}
.btn{display:inline-flex;align-items:center;gap:6px;padding:10px 20px;border-radius:999px;font-weight:500;font-size:.87rem;text-decoration:none;cursor:pointer;border:none;font-family:'Inter',sans-serif;transition:all .2s}
.btn-outline{background:transparent;border:1px solid var(--nav-border);color:var(--nav-fg)}
.btn-outline:hover{border-color:var(--nav-fg);background:rgba(128,128,128,.1)}
.btn-primary{background:var(--accent);color:#fff}
.btn-primary:hover{background:var(--accent-dark)}
.user-pill{display:flex;align-items:center;gap:7px;text-decoration:none;color:var(--nav-fg);padding:6px 14px 6px 6px;border:1px solid var(--nav-border);border-radius:999px;font-size:.85rem;font-weight:500;transition:border-color .2s}
.user-pill:hover{border-color:var(--nav-fg)}
.user-av{width:26px;height:26px;border-radius:50%;background:var(--accent);display:flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:600;color:#fff}
.hamburger{display:none;width:36px;height:36px;border:1px solid var(--nav-border);border-radius:999px;background:transparent;flex-direction:column;align-items:center;justify-content:center;gap:4px;cursor:pointer;padding:0}
.hamburger span{width:16px;height:1.5px;background:var(--nav-fg);border-radius:2px;transition:all .3s;display:block}
.hamburger.open span:nth-child(1){transform:translateY(5.5px) rotate(45deg)}
.hamburger.open span:nth-child(2){opacity:0}
.hamburger.open span:nth-child(3){transform:translateY(-5.5px) rotate(-45deg)}
.mobile-drawer{position:fixed;top:66px;left:12px;right:12px;z-index:299;background:color-mix(in srgb,var(--s0) 95%,transparent);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);border:1px solid var(--border);border-radius:18px;box-shadow:var(--sh-xl);padding:14px;flex-direction:column;gap:2px;transform:translateY(-12px);opacity:0;transition:transform .25s,opacity .25s;pointer-events:none;display:flex}
.mobile-drawer.open{transform:translateY(0);opacity:1;pointer-events:all}
.mobile-drawer .nav-link{color:var(--text);padding:12px 14px}
.mobile-drawer .nav-link:hover{background:var(--s1)}

/* ── Hero (video, 100vh) ── */
.hero{position:relative;height:100vh;overflow:hidden;background:#0B0F14}
.hero-video{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.hero-overlay{position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,rgba(6,10,16,.45) 0%,rgba(6,10,16,.35) 45%,rgba(6,10,16,.6) 100%)}
.hero-content{position:relative;z-index:2;height:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:0 24px}
.hero-badge{display:inline-flex;align-items:center;gap:8px;background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.28);backdrop-filter:blur(6px);border-radius:999px;padding:7px 16px 7px 12px;font-size:.72rem;font-weight:600;color:#fff;letter-spacing:.08em;text-transform:uppercase;margin-bottom:28px}
.hero-badge .dot{width:6px;height:6px;border-radius:50%;background:var(--accent-dark,#4A7A63);background:#7DBE9E;animation:blink 2s infinite}
@keyframes blink{0%,100%{opacity:1}50%{opacity:.35}}
.hero-title{font-family:'Fraunces',serif;font-weight:400;line-height:.96;letter-spacing:-.02em;margin-bottom:24px}
.hero-title .l1{display:block;color:rgba(255,255,255,.68);font-size:clamp(3rem,8vw,6.5rem)}
.hero-title .l2{display:block;color:#fff;font-size:clamp(3rem,8vw,6.5rem);margin-top:-8px}
.hero-sub{color:rgba(255,255,255,.85);font-size:clamp(1rem,2vw,1.2rem);line-height:1.6;max-width:560px;margin:0 auto 36px}
.hero-actions{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}
.btn-hero{padding:14px 30px;font-size:.95rem;border-radius:999px}
.btn-hero-ghost{background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.35);color:#fff;backdrop-filter:blur(6px)}
.btn-hero-ghost:hover{background:rgba(255,255,255,.2)}

/* ── Quick search (own section, just below hero) ── */
.search-section{padding:0 24px;margin-top:-46px;position:relative;z-index:5;display:flex;justify-content:center}
.hero-search{background:var(--s0);border:1px solid var(--border);border-radius:22px;padding:26px 30px;box-shadow:var(--sh-xl);max-width:1100px;width:100%}
.search-label{font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:.08em;color:var(--muted);margin-bottom:16px;text-align:left;display:flex;align-items:center;gap:8px}
.search-grid{display:grid;grid-template-columns:minmax(0,1fr) 40px minmax(0,1fr) minmax(100px,1fr) minmax(110px,1fr) auto;gap:8px;align-items:end}
.sf-group{display:flex;flex-direction:column;gap:6px;text-align:left;justify-content:flex-end}
.sf-label{font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:.06em;color:var(--muted)}
.sf-wrap{display:flex;align-items:center;gap:8px;background:var(--s1);border:1.5px solid var(--border);border-radius:12px;padding:0 12px;transition:border-color .2s,box-shadow .2s}
.sf-wrap:focus-within{border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-glow)}
.sf-icon{font-size:.9rem;flex-shrink:0;color:var(--faint)}
.sf-wrap input,.sf-wrap select{flex:1;border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.87rem;padding:10px 0;outline:none}
.sf-wrap input::placeholder{color:var(--faint)}
.sf-wrap select{appearance:none;cursor:pointer}
input[type="date"]{color-scheme:light}
[data-theme="dark"] input[type="date"]{color-scheme:dark}
.swap-btn{width:44px;height:42px;border:1.5px solid var(--border);border-radius:12px;background:var(--s1);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1rem;color:var(--muted);transition:all .2s;align-self:flex-end;font-family:inherit}
.swap-btn:hover{border-color:var(--accent);color:var(--accent);transform:rotate(180deg)}
.btn-search{height:42px;padding:0 18px;font-size:.85rem;align-self:flex-end;white-space:nowrap;border-radius:12px;flex-shrink:0}
.search-route-row{display:grid;grid-template-columns:1fr 46px 1fr;gap:10px;align-items:end}
.search-bottom-row{display:grid;grid-template-columns:1fr 1fr auto;gap:10px;align-items:end;margin-top:10px}
.search-mobile-row{display:none}

/* ── Stats ── */
.stats{padding:96px 24px 80px;display:flex;justify-content:center}
.stats-inner{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;max-width:900px;width:100%}
.stat-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:24px 20px;text-align:center;box-shadow:var(--sh);transition:all .25s}
.stat-card:hover{transform:translateY(-4px);box-shadow:var(--sh-lg);border-color:var(--accent)}
.stat-num{font-family:'Fraunces',serif;font-size:2.1rem;font-weight:500;letter-spacing:-.02em;color:var(--text)}
.stat-lbl{color:var(--muted);font-size:.8rem;font-weight:500;margin-top:4px}

/* ── Section common ── */
.section{padding:80px 24px;text-align:center}
.section-inner{max-width:960px;margin:0 auto}
.section-eyebrow{font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:.1em;color:var(--accent);margin-bottom:12px}
.section-title{font-family:'Fraunces',serif;font-size:clamp(1.8rem,4vw,2.7rem);font-weight:500;letter-spacing:-.02em;margin-bottom:12px}
.section-sub{color:var(--muted);font-size:.95rem;line-height:1.6;max-width:520px;margin:0 auto 48px}

/* ── Testimonials ── */
.testimonial-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;text-align:left}
.testimonial-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:26px 24px;box-shadow:var(--sh)}
.testimonial-quote{color:var(--text);font-size:.92rem;line-height:1.6;margin-bottom:18px}
.testimonial-who{display:flex;align-items:center;gap:10px}
.testimonial-av{width:34px;height:34px;border-radius:50%;background:var(--s1);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-family:'Fraunces',serif;font-size:.85rem;color:var(--text)}
.testimonial-name{font-size:.83rem;font-weight:600;color:var(--text)}
.testimonial-route{font-size:.76rem;color:var(--muted)}

/* ── Popular routes ── */
.routes-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}
.route-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:20px;text-align:left;transition:all .25s}
.route-card:hover{border-color:var(--accent);transform:translateY(-3px);box-shadow:var(--sh-lg)}
.route-cities{font-weight:600;font-size:.9rem;color:var(--text);display:flex;align-items:center;gap:6px}
.route-price{color:var(--muted);font-size:.78rem;margin-top:6px}
.route-price b{color:var(--accent);font-weight:600}

/* ── Features ── */
.features-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;text-align:left}
.feature-card{background:var(--s0);border:1.5px solid var(--border);border-radius:var(--r);padding:26px 22px;box-shadow:var(--sh);transition:all .25s;position:relative;overflow:hidden}
.feature-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--accent);transform:scaleX(0);transition:transform .3s;transform-origin:left}
.feature-card:hover{border-color:var(--accent);transform:translateY(-4px);box-shadow:var(--sh-lg)}
.feature-card:hover::before{transform:scaleX(1)}
.feature-icon{width:44px;height:44px;border-radius:12px;background:var(--s1);display:flex;align-items:center;justify-content:center;font-size:1.15rem;margin-bottom:14px;color:var(--text);transition:all .25s}
.feature-card:hover .feature-icon{background:var(--accent);color:#fff;transform:scale(1.08)}
.feature-title{font-family:'Fraunces',serif;font-weight:500;font-size:1.02rem;margin-bottom:6px}
.feature-desc{color:var(--muted);font-size:.85rem;line-height:1.55}

/* ── How it works ── */
.how-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;text-align:center;position:relative}
.how-grid::before{content:'';position:absolute;top:28px;left:12%;right:12%;height:1px;background:var(--border)}
.step-num{width:56px;height:56px;border-radius:50%;background:var(--text);display:flex;align-items:center;justify-content:center;font-family:'Fraunces',serif;font-size:1.2rem;font-weight:500;color:var(--s0);margin:0 auto 14px;position:relative}
.step-title{font-family:'Fraunces',serif;font-weight:500;font-size:.98rem;margin-bottom:6px}
.step-desc{color:var(--muted);font-size:.82rem;line-height:1.55}

/* ── CTA ── */
.cta-section{padding:80px 24px;display:flex;justify-content:center}
.cta-card{max-width:720px;width:100%;background:var(--accent);border-radius:28px;padding:56px 40px;text-align:center;position:relative;overflow:hidden}
.cta-card::before{content:'\2708';position:absolute;font-size:12rem;opacity:.08;right:-30px;top:-30px;color:#fff;line-height:1}
.cta-title{font-family:'Fraunces',serif;font-size:2.1rem;font-weight:500;letter-spacing:-.02em;color:#fff;margin-bottom:10px}
.cta-sub{color:rgba(255,255,255,.82);font-size:.95rem;margin-bottom:30px}
.btn-cta-white{background:#fff;color:var(--accent-dark);border:none;font-weight:600;padding:13px 28px;border-radius:999px;font-size:.92rem}
.btn-cta-white:hover{opacity:.94;transform:translateY(-1px)}
.btn-cta-ghost{background:rgba(255,255,255,.14);color:#fff;border:1px solid rgba(255,255,255,.35);border-radius:999px;padding:13px 28px;font-size:.92rem;font-weight:500}
.btn-cta-ghost:hover{background:rgba(255,255,255,.24)}

/* ── Footer ── */
.footer{background:var(--s0);border-top:1px solid var(--border);padding:32px 48px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px}
.footer-brand{font-family:'Fraunces',serif;font-weight:500;font-size:1.05rem;color:var(--text)}
.footer-text{color:var(--muted);font-size:.8rem}
.footer-links{display:flex;gap:18px}
.footer-links a{color:var(--muted);text-decoration:none;font-size:.8rem;transition:color .2s}
.footer-links a:hover{color:var(--accent)}

/* ── Animations ── */
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .7s cubic-bezier(.4,0,.2,1) both}
.fu-1{animation-delay:.1s}.fu-2{animation-delay:.2s}.fu-3{animation-delay:.3s}

/* ── Responsive ── */
@media(max-width:900px){
  .navbar{padding:0 20px}
  .nav-links{display:none}
  .hamburger{display:flex}
  .stats-inner{grid-template-columns:repeat(2,1fr)}
  .features-grid,.testimonial-grid{grid-template-columns:1fr 1fr}
  .how-grid{grid-template-columns:1fr 1fr}
  .how-grid::before{display:none}
  .routes-grid{grid-template-columns:1fr 1fr}
  .search-grid{display:none}
  .search-route-row,.search-bottom-row{display:grid}
  .search-mobile-row{display:grid}
}
@media(max-width:760px){.hero-search{padding:20px 16px}}
@media(max-width:580px){
  .features-grid,.how-grid,.testimonial-grid,.routes-grid{grid-template-columns:1fr}
  .hero-search{padding:16px 14px}
  .search-section{margin-top:-30px}
  .search-route-row{grid-template-columns:1fr 36px 1fr;gap:7px}
  .search-bottom-row{grid-template-columns:1fr 1fr;gap:7px}
  .btn-search-mobile{grid-column:1/-1;width:100%;justify-content:center}
  .cta-card{padding:40px 22px}
  .footer{padding:20px 20px;flex-direction:column;text-align:center}
}
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar" id="navbar">
  <a href="${pageContext.request.contextPath}/" class="nav-brand">
    <div class="brand-icon"><i class="ph-bold ph-airplane-tilt"></i></div>
    <span class="brand-name">AeroSphere</span>
  </a>
  <div class="nav-links">
    <a href="#features" class="nav-link">Features</a>
    <a href="#how"      class="nav-link">How it Works</a>
    <a href="${pageContext.request.contextPath}/faqs"    class="nav-link">FAQ</a>
    <a href="${pageContext.request.contextPath}/contact" class="nav-link">Contact</a>
  </div>
  <div class="nav-right">
    <button class="theme-btn" id="themeToggle"><i class="ph-bold ph-moon"></i></button>
    <% if (userName != null) { %>
      <a href="${pageContext.request.contextPath}/userDashboard" class="user-pill">
        <div class="user-av"><%= userName.substring(0,1).toUpperCase() %></div>
        <span><%= userName.contains(" ") ? userName.split(" ")[0] : userName %></span>
      </a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/login"    class="btn btn-outline">Sign In</a>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Get Started</a>
    <% } %>
    <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
  </div>
</nav>
<div class="mobile-drawer" id="mobileDrawer">
  <a href="#features" class="nav-link" onclick="closeMobile()">Features</a>
  <a href="#how"      class="nav-link" onclick="closeMobile()">How it Works</a>
  <a href="${pageContext.request.contextPath}/faqs"    class="nav-link" onclick="closeMobile()">FAQ</a>
  <a href="${pageContext.request.contextPath}/contact" class="nav-link" onclick="closeMobile()">Contact</a>
  <hr style="border:none;border-top:1px solid var(--border);margin:6px 0">
  <% if (userName != null) { %>
    <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-primary" style="justify-content:center">Dashboard</a>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/login"    class="btn btn-outline" style="justify-content:center">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="justify-content:center">Get Started</a>
  <% } %>
</div>

<!-- Hero -->
<section class="hero">
  <video class="hero-video" autoplay muted loop playsinline
    src="https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260328_091828_e240eb17-6edc-4129-ad9d-98678e3fd238.mp4">
  </video>
  <div class="hero-overlay"></div>
  <div class="hero-content">
    <div class="hero-badge fu"><span class="dot"></span>Air travel, elevated</div>
    <h1 class="hero-title fu-1"><span class="l1">Fly.</span><span class="l2">Refined.</span></h1>
    <p class="hero-sub fu-2">Real-time fares, instant seat selection, and secure booking — search to boarding pass in minutes.</p>
    <div class="hero-actions fu-2">
      <a href="#quick-search" class="btn btn-primary btn-hero">Search flights</a>
      <% if (userName != null) { %>
        <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-hero btn-hero-ghost">Dashboard →</a>
      <% } else { %>
        <a href="#how" class="btn btn-hero btn-hero-ghost">How it works</a>
      <% } %>
    </div>
  </div>
</section>

<!-- Quick search -->
<div class="search-section" id="quick-search">
  <div class="hero-search fu-3">
    <div class="search-label"><i class="ph-bold ph-magnifying-glass"></i>Quick Flight Search</div>
    <form action="${pageContext.request.contextPath}/searchFlights" method="get">
      <div class="search-grid">
        <div class="sf-group">
          <label class="sf-label">From</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-airplane-takeoff"></i></span>
            <input type="text" name="source" id="srcInput" placeholder="Mumbai, Delhi…" autocomplete="off">
          </div>
        </div>
        <button type="button" class="swap-btn" id="swapBtn" title="Swap cities"><i class="ph-bold ph-arrows-left-right"></i></button>
        <div class="sf-group">
          <label class="sf-label">To</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-airplane-landing"></i></span>
            <input type="text" name="destination" id="dstInput" placeholder="Chennai, Kolkata…" autocomplete="off">
          </div>
        </div>
        <div class="sf-group">
          <label class="sf-label">Date</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-calendar-blank"></i></span>
            <input type="date" name="date" id="dateInput">
          </div>
        </div>
        <div class="sf-group">
          <label class="sf-label">Passengers</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-users"></i></span>
            <select name="seats">
              <option value="1">1 Passenger</option>
              <option value="2">2 Passengers</option>
              <option value="3">3 Passengers</option>
              <option value="4">4 Passengers</option>
              <option value="5">5 Passengers</option>
            </select>
          </div>
        </div>
        <button type="submit" class="btn btn-primary btn-search"><i class="ph-bold ph-magnifying-glass"></i> Search</button>
      </div>
      <div class="search-route-row search-mobile-row">
        <div class="sf-group">
          <label class="sf-label">From</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-airplane-takeoff"></i></span>
            <input type="text" name="source" id="srcInputM" placeholder="Mumbai…" autocomplete="off">
          </div>
        </div>
        <button type="button" class="swap-btn" id="swapBtnM" title="Swap"><i class="ph-bold ph-arrows-left-right"></i></button>
        <div class="sf-group">
          <label class="sf-label">To</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-airplane-landing"></i></span>
            <input type="text" name="destination" id="dstInputM" placeholder="Delhi…" autocomplete="off">
          </div>
        </div>
      </div>
      <div class="search-bottom-row search-mobile-row" style="margin-top:10px">
        <div class="sf-group">
          <label class="sf-label">Date</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-calendar-blank"></i></span>
            <input type="date" name="date" id="dateInputM">
          </div>
        </div>
        <div class="sf-group">
          <label class="sf-label">Passengers</label>
          <div class="sf-wrap"><span class="sf-icon"><i class="ph-bold ph-users"></i></span>
            <select name="seats">
              <option value="1">1 Passenger</option>
              <option value="2">2 Passengers</option>
              <option value="3">3 Passengers</option>
              <option value="4">4 Passengers</option>
              <option value="5">5 Passengers</option>
            </select>
          </div>
        </div>
        <button type="submit" class="btn btn-primary btn-search btn-search-mobile" style="height:42px;padding:0 18px"><i class="ph-bold ph-magnifying-glass"></i></button>
      </div>
    </form>
  </div>
</div>

<!-- Stats -->
<div class="stats">
  <div class="stats-inner">
    <div class="stat-card"><div class="stat-num" data-count>6+</div><div class="stat-lbl">Major Cities</div></div>
    <div class="stat-card"><div class="stat-num" data-count>50K+</div><div class="stat-lbl">Bookings Made</div></div>
    <div class="stat-card"><div class="stat-num" data-count>99.9%</div><div class="stat-lbl">Uptime</div></div>
    <div class="stat-card"><div class="stat-num" data-count>4.9★</div><div class="stat-lbl">User Rating</div></div>
  </div>
</div>

<!-- Features -->
<section class="section" id="features">
  <div class="section-inner">
    <div class="section-eyebrow">Why AeroSphere</div>
    <h2 class="section-title">Everything you need to fly</h2>
    <p class="section-sub">From real-time availability to automated refunds — we've thought of everything.</p>
    <div class="features-grid">
      <div class="feature-card"><div class="feature-icon"><i class="ph-bold ph-magnifying-glass"></i></div>
        <div class="feature-title">Smart Search</div>
        <div class="feature-desc">Search flights by city, date and passengers. See real-time availability and lowest fares instantly.</div></div>
      <div class="feature-card"><div class="feature-icon"><i class="ph-bold ph-armchair"></i></div>
        <div class="feature-title">Seat Selection</div>
        <div class="feature-desc">Interactive seat map lets you pick your preferred seat before confirming your booking.</div></div>
      <div class="feature-card"><div class="feature-icon"><i class="ph-bold ph-credit-card"></i></div>
        <div class="feature-title">Secure Payments</div>
        <div class="feature-desc">Razorpay-powered payment gateway with end-to-end encryption. Pay confidently every time.</div></div>
      <div class="feature-card"><div class="feature-icon"><i class="ph-bold ph-file-text"></i></div>
        <div class="feature-title">Instant Invoice</div>
        <div class="feature-desc">PDF invoices generated and emailed instantly after booking. Always ready when you need them.</div></div>
      <div class="feature-card"><div class="feature-icon"><i class="ph-bold ph-hand-coins"></i></div>
        <div class="feature-title">Smart Refunds</div>
        <div class="feature-desc">Cancel anytime with tiered refund policy — 100% before 24h, 50% within 24h of departure.</div></div>
      <div class="feature-card"><div class="feature-icon"><i class="ph-bold ph-envelope-simple"></i></div>
        <div class="feature-title">Email Alerts</div>
        <div class="feature-desc">Booking confirmations, cancellations, refund updates and OTP verification — all via email.</div></div>
    </div>
  </div>
</section>

<!-- Popular routes -->
<section class="section" style="background:var(--s1)">
  <div class="section-inner">
    <div class="section-eyebrow">Trending Now</div>
    <h2 class="section-title">Popular routes</h2>
    <p class="section-sub">Fares travellers are booking most this month.</p>
    <div class="routes-grid">
      <div class="route-card"><div class="route-cities"><i class="ph-bold ph-airplane-tilt"></i> Mumbai → Delhi</div><div class="route-price">From <b>₹3,499</b></div></div>
      <div class="route-card"><div class="route-cities"><i class="ph-bold ph-airplane-tilt"></i> Bengaluru → Goa</div><div class="route-price">From <b>₹2,199</b></div></div>
      <div class="route-card"><div class="route-cities"><i class="ph-bold ph-airplane-tilt"></i> Delhi → Chennai</div><div class="route-price">From <b>₹4,299</b></div></div>
      <div class="route-card"><div class="route-cities"><i class="ph-bold ph-airplane-tilt"></i> Kolkata → Mumbai</div><div class="route-price">From <b>₹3,899</b></div></div>
    </div>
  </div>
</section>

<!-- Testimonials -->
<section class="section">
  <div class="section-inner">
    <div class="section-eyebrow">Traveller Stories</div>
    <h2 class="section-title">Loved by frequent flyers</h2>
    <p class="section-sub">A few words from people who book with AeroSphere.</p>
    <div class="testimonial-grid">
      <div class="testimonial-card"><p class="testimonial-quote">"Booked a same-day flight in under two minutes. The seat map alone saved me from a middle seat."</p>
        <div class="testimonial-who"><div class="testimonial-av">R</div><div><div class="testimonial-name">Riya M.</div><div class="testimonial-route">Mumbai ⇄ Delhi, frequent flyer</div></div></div></div>
      <div class="testimonial-card"><p class="testimonial-quote">"Had to cancel last minute — refund landed in my account the same day, no calls needed."</p>
        <div class="testimonial-who"><div class="testimonial-av">A</div><div><div class="testimonial-name">Arjun K.</div><div class="testimonial-route">Bengaluru, business traveller</div></div></div></div>
      <div class="testimonial-card"><p class="testimonial-quote">"Cleanest booking flow I've used. Invoice was in my inbox before I even closed the tab."</p>
        <div class="testimonial-who"><div class="testimonial-av">S</div><div><div class="testimonial-name">Sana P.</div><div class="testimonial-route">Kolkata, first-time user</div></div></div></div>
    </div>
  </div>
</section>

<!-- How it works -->
<section class="section" id="how" style="background:var(--s1)">
  <div class="section-inner">
    <div class="section-eyebrow">Simple 4-Step Process</div>
    <h2 class="section-title">Book a flight in minutes</h2>
    <p class="section-sub">From search to boarding pass — the whole process takes under 5 minutes.</p>
    <div class="how-grid">
      <div class="how-step"><div class="step-num">1</div><div class="step-title">Search Flights</div>
        <div class="step-desc">Enter your origin, destination and travel date to see all available options.</div></div>
      <div class="how-step"><div class="step-num">2</div><div class="step-title">Select Seats</div>
        <div class="step-desc">Choose your preferred seats from the interactive seat map.</div></div>
      <div class="how-step"><div class="step-num">3</div><div class="step-title">Secure Payment</div>
        <div class="step-desc">Pay safely via Razorpay — cards, UPI, net banking all supported.</div></div>
      <div class="how-step"><div class="step-num">4</div><div class="step-title">Get Invoice</div>
        <div class="step-desc">Receive your PDF invoice by email instantly. You're all set to fly!</div></div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="cta-section">
  <div class="cta-card">
    <h2 class="cta-title">Ready to take off?</h2>
    <p class="cta-sub">Join thousands of travellers who book smarter with AeroSphere every day.</p>
    <div style="display:flex;gap:10px;justify-content:center;flex-wrap:wrap">
      <% if (userName != null) { %>
        <a href="${pageContext.request.contextPath}/searchFlights" class="btn-cta-white" style="display:inline-flex;align-items:center;gap:6px;text-decoration:none"><i class="ph-bold ph-magnifying-glass"></i> Search Flights</a>
        <a href="${pageContext.request.contextPath}/userDashboard"  class="btn-cta-ghost" style="display:inline-flex;align-items:center;gap:6px;text-decoration:none">Dashboard →</a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/register" class="btn-cta-white" style="text-decoration:none">Create Free Account</a>
        <a href="${pageContext.request.contextPath}/login"    class="btn-cta-ghost" style="text-decoration:none">Sign In →</a>
      <% } %>
    </div>
  </div>
</section>

<!-- Footer -->
<footer class="footer">
  <div class="footer-brand">AeroSphere</div>
  <p class="footer-text">&copy; <%= new java.util.Date().getYear() + 1900 %> AeroSphere. Built with ☕ and ✈</p>
  <div class="footer-links">
    <a href="${pageContext.request.contextPath}/privacyPolicy">Privacy</a><a href="${pageContext.request.contextPath}/termsOfService">Terms</a><a href="${pageContext.request.contextPath}/helpCenter">Support</a>
  </div>
</footer>

<script>
// Theme (icon-based toggle)
(function(){
  const s=document.documentElement.getAttribute('data-theme')||'light';
  document.getElementById('themeToggle').innerHTML = s==='dark' ? '<i class="ph-bold ph-sun"></i>' : '<i class="ph-bold ph-moon"></i>';
})();
document.getElementById('themeToggle').addEventListener('click',function(){
  const c=document.documentElement.getAttribute('data-theme');
  const n=c==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',n);
  localStorage.setItem('asTheme',n);
  this.innerHTML = n==='dark' ? '<i class="ph-bold ph-sun"></i>' : '<i class="ph-bold ph-moon"></i>';
});

// Navbar scroll state (transparent-over-hero -> solid)
window.addEventListener('scroll',()=>document.getElementById('navbar').classList.toggle('scrolled',scrollY>10));

// Hamburger
const ham=document.getElementById('hamburger'),drawer=document.getElementById('mobileDrawer');
ham.addEventListener('click',()=>{ham.classList.toggle('open');drawer.classList.toggle('open');});
function closeMobile(){ham.classList.remove('open');drawer.classList.remove('open');}

// Swap cities (desktop)
document.getElementById('swapBtn').addEventListener('click',()=>{
  const s=document.getElementById('srcInput'),d=document.getElementById('dstInput');
  [s.value,d.value]=[d.value,s.value];
  s.closest('.sf-wrap').style.boxShadow='0 0 0 3px var(--accent-glow)';
  setTimeout(()=>s.closest('.sf-wrap').style.boxShadow='',400);
});
// Swap cities (mobile)
document.getElementById('swapBtnM').addEventListener('click',()=>{
  const s=document.getElementById('srcInputM'),d=document.getElementById('dstInputM');
  [s.value,d.value]=[d.value,s.value];
});

// Sync mobile inputs from desktop and vice versa
function syncInputs(fromId, toId){
  const from=document.getElementById(fromId), to=document.getElementById(toId);
  if(from&&to) from.addEventListener('input',()=>to.value=from.value);
}
syncInputs('srcInput','srcInputM'); syncInputs('srcInputM','srcInput');
syncInputs('dstInput','dstInputM'); syncInputs('dstInputM','dstInput');
syncInputs('dateInput','dateInputM'); syncInputs('dateInputM','dateInput');

// Date min = today
const today=new Date().toISOString().split('T')[0];
document.getElementById('dateInput').min=today;
document.getElementById('dateInputM').min=today;

// Animated stat counters
function animateStat(el){
  const raw=el.textContent.trim();
  const m=raw.match(/^([\d.]+)(.*)$/);
  if(!m) return;
  const end=parseFloat(m[1]), decimals=(m[1].split('.')[1]||'').length, suffix=m[2];
  const dur=1100, start=performance.now();
  function tick(now){
    const p=Math.min((now-start)/dur,1), eased=1-Math.pow(1-p,3);
    el.textContent=(end*eased).toFixed(decimals)+suffix;
    if(p<1) requestAnimationFrame(tick);
  }
  requestAnimationFrame(tick);
}

// Scroll-reveal (IntersectionObserver) + one-time stat animation
const obs=new IntersectionObserver(entries=>{
  entries.forEach(e=>{
    if(e.isIntersecting){
      e.target.style.opacity='1';e.target.style.transform='translateY(0)';
      const num=e.target.querySelector('[data-count]');
      if(num && !num.dataset.done){ num.dataset.done='1'; animateStat(num); }
      obs.unobserve(e.target);
    }
  });
},{threshold:.15});
document.querySelectorAll('.feature-card,.stat-card,.how-step,.cta-card,.testimonial-card,.route-card').forEach(el=>{
  el.style.cssText='opacity:0;transform:translateY(20px);transition:opacity .6s ease,transform .6s ease';
  obs.observe(el);
});
</script>
</body>
</html>
