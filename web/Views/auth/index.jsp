<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>AeroSphere – Fly Smarter, Book Faster</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{
  --sky:#0EA5E9;--sky-dark:#0284C7;--sky-glow:rgba(14,165,233,.18);
  --em:#10B981;--em-dark:#059669;--em-glow:rgba(16,185,129,.18);
  --grad:linear-gradient(135deg,var(--sky),var(--em));
  --grad-r:linear-gradient(135deg,var(--em),var(--sky));
  --bg:#F0F9FF;--s0:#FFFFFF;--s1:#F8FAFC;--s2:#F0F9FF;
  --text:#0F172A;--muted:#64748B;--border:#E2E8F0;
  --sh:0 1px 3px rgba(0,0,0,.06),0 4px 16px rgba(0,0,0,.04);
  --sh-lg:0 8px 32px rgba(0,0,0,.08);--sh-xl:0 24px 64px rgba(0,0,0,.12);--r:14px;
}
[data-theme="dark"]{
  --bg:#060A12;--s0:#0D1117;--s1:#111827;--s2:#1A2232;
  --text:#F1F5F9;--muted:#94A3B8;--border:#1E293B;
  --sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);
  --sh-lg:0 8px 32px rgba(0,0,0,.5);--sh-xl:0 24px 64px rgba(0,0,0,.6);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);overflow-x:hidden;min-height:100vh}

/* ── Navbar ── */
.navbar{position:fixed;top:0;left:0;right:0;z-index:300;
  display:flex;align-items:center;padding:0 48px;height:66px;
  background:rgba(255,255,255,.82);backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
  border-bottom:1px solid var(--border);transition:box-shadow .3s}
[data-theme="dark"] .navbar{background:rgba(6,10,18,.82)}
.navbar.scrolled{box-shadow:var(--sh-lg)}
.nav-brand{display:flex;align-items:center;gap:11px;text-decoration:none;color:var(--text);margin-right:auto}
.brand-icon{width:38px;height:38px;border-radius:11px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:20px;box-shadow:0 4px 14px var(--sky-glow)}
.brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1.15rem;letter-spacing:-.5px}
.brand-name span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.nav-links{display:flex;align-items:center;gap:2px;margin:0 24px}
.nav-link{text-decoration:none;color:var(--muted);padding:6px 12px;border-radius:8px;font-size:.84rem;font-weight:500;transition:all .18s}
.nav-link:hover{color:var(--text);background:var(--s2)}
.nav-right{display:flex;align-items:center;gap:8px}
.theme-btn{width:36px;height:36px;border:1px solid var(--border);border-radius:9px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;color:var(--muted);transition:all .2s}
.theme-btn:hover{border-color:var(--sky);color:var(--sky)}
.btn{display:inline-flex;align-items:center;gap:6px;padding:9px 20px;border-radius:9px;font-weight:600;font-size:.85rem;text-decoration:none;cursor:pointer;border:none;font-family:'DM Sans',sans-serif;transition:all .2s}
.btn-outline{background:var(--s0);border:1.5px solid var(--border);color:var(--muted)}
.btn-outline:hover{border-color:var(--sky);color:var(--sky)}
.btn-grad{background:var(--grad);color:#fff;box-shadow:0 4px 14px var(--sky-glow)}
.btn-grad:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 6px 20px var(--sky-glow)}
.user-pill{display:flex;align-items:center;gap:7px;text-decoration:none;color:var(--text);padding:6px 14px 6px 6px;border:1px solid var(--border);border-radius:99px;font-size:.83rem;font-weight:600;transition:border-color .2s}
.user-pill:hover{border-color:var(--sky)}
.user-av{width:28px;height:28px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:800;color:#fff}
.hamburger{display:none;width:36px;height:36px;border:1px solid var(--border);border-radius:8px;background:var(--s0);flex-direction:column;align-items:center;justify-content:center;gap:4px;cursor:pointer;padding:0}
.hamburger span{width:16px;height:1.5px;background:var(--muted);border-radius:2px;transition:all .3s;display:block}
.hamburger.open span:nth-child(1){transform:translateY(5.5px) rotate(45deg)}
.hamburger.open span:nth-child(2){opacity:0}
.hamburger.open span:nth-child(3){transform:translateY(-5.5px) rotate(-45deg)}
.mobile-drawer{position:fixed;top:66px;left:0;right:0;z-index:299;background:var(--s0);border-bottom:1px solid var(--border);box-shadow:var(--sh-lg);padding:12px 20px 20px;flex-direction:column;gap:4px;transform:translateY(-100%);opacity:0;transition:transform .3s,opacity .3s;pointer-events:none;display:flex}
.mobile-drawer.open{transform:translateY(0);opacity:1;pointer-events:all}

/* ── Hero ── */
.hero{min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:flex-start;text-align:center;padding:100px 24px 60px;position:relative;overflow:hidden}
@media(min-height:800px){.hero{justify-content:center}}
@media(max-height:799px){.hero{padding-top:88px;padding-bottom:32px}}
@media(max-height:700px){.hero{padding-top:76px}.hero-title{font-size:clamp(2rem,5vw,3.2rem);margin-bottom:12px}.hero-sub{margin-bottom:18px;font-size:.9rem}.hero-actions{margin-bottom:28px}}
.hero-mesh{position:absolute;inset:0;pointer-events:none;overflow:hidden}
.hero-mesh::before{content:'';position:absolute;width:800px;height:800px;border-radius:50%;background:radial-gradient(circle,var(--sky-glow) 0%,transparent 70%);top:-200px;left:50%;transform:translateX(-50%);animation:float 8s ease-in-out infinite}
.hero-mesh::after{content:'';position:absolute;width:600px;height:600px;border-radius:50%;background:radial-gradient(circle,var(--em-glow) 0%,transparent 70%);bottom:-100px;right:0;animation:float 10s ease-in-out infinite reverse}
@keyframes float{0%,100%{transform:translateX(-50%) translateY(0)}50%{transform:translateX(-50%) translateY(-24px)}}
.hero-badge{display:inline-flex;align-items:center;gap:7px;background:var(--s0);border:1px solid var(--border);border-radius:99px;padding:6px 16px;font-size:.8rem;font-weight:700;color:var(--muted);letter-spacing:.04em;text-transform:uppercase;margin-bottom:24px;box-shadow:var(--sh);position:relative}
.hero-badge::before{content:'';width:6px;height:6px;border-radius:50%;background:var(--em);display:inline-block;animation:blink 2s infinite}
@keyframes blink{0%,100%{opacity:1}50%{opacity:.3}}
.hero-title{font-family:'Syne',sans-serif;font-size:clamp(2.8rem,7vw,5.5rem);font-weight:800;letter-spacing:-2px;line-height:1.06;margin-bottom:20px;position:relative}
.hero-title .grad{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.hero-sub{color:var(--muted);font-size:clamp(1rem,2vw,1.2rem);line-height:1.6;max-width:580px;margin:0 auto 36px}
.hero-actions{display:flex;gap:12px;justify-content:center;flex-wrap:wrap;position:relative;margin-bottom:56px}
.btn-hero{padding:13px 28px;font-size:.95rem;border-radius:11px}
/* Search card */
.hero-search{background:var(--s0);border:1px solid var(--border);border-radius:18px;padding:22px 28px;box-shadow:var(--sh-xl);max-width:1100px;width:100%;margin:0 auto;position:relative;overflow:hidden}
.hero-search::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad);border-radius:18px 18px 0 0}
.search-label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--muted);margin-bottom:14px;text-align:left}
.search-grid{display:grid;grid-template-columns:minmax(0,1fr) 40px minmax(0,1fr) minmax(100px,1fr) minmax(110px,1fr) auto;gap:8px;align-items:end}
.sf-group{display:flex;flex-direction:column;gap:6px;text-align:left;justify-content:flex-end}
.sf-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted)}
.sf-wrap{display:flex;align-items:center;gap:8px;background:var(--s1);border:1.5px solid var(--border);border-radius:10px;padding:0 12px;transition:border-color .2s,box-shadow .2s}
.sf-wrap:focus-within{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.sf-icon{font-size:.9rem;flex-shrink:0;opacity:.7}
.sf-wrap input,.sf-wrap select{flex:1;border:none;background:transparent;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.87rem;padding:10px 0;outline:none}
.sf-wrap input::placeholder{color:var(--muted);opacity:.65}
.sf-wrap select{appearance:none;cursor:pointer}
input[type="date"]{color-scheme:light}
[data-theme="dark"] input[type="date"]{color-scheme:dark}
.swap-btn{width:46px;height:42px;border:1.5px solid var(--border);border-radius:10px;background:var(--s1);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1rem;color:var(--muted);transition:all .2s;align-self:flex-end;font-family:inherit}
.swap-btn:hover{border-color:var(--sky);color:var(--sky);transform:rotate(180deg)}
.btn-search{height:42px;padding:0 16px;font-size:.85rem;align-self:flex-end;white-space:nowrap;border-radius:10px;flex-shrink:0}
/* Route row: from + swap + to side by side */
.search-route-row{display:grid;grid-template-columns:1fr 46px 1fr;gap:10px;align-items:end}
.search-bottom-row{display:grid;grid-template-columns:1fr 1fr auto;gap:10px;align-items:end;margin-top:10px}

/* ── Stats ── */
.stats{padding:0 24px 80px;display:flex;justify-content:center}
.stats-inner{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;max-width:900px;width:100%}
.stat-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:22px 20px;text-align:center;box-shadow:var(--sh);transition:all .25s}
.stat-card:hover{transform:translateY(-4px);box-shadow:var(--sh-lg);border-color:var(--sky)}
.stat-num{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;letter-spacing:-1px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.stat-lbl{color:var(--muted);font-size:.8rem;font-weight:500;margin-top:4px}

/* ── Section common ── */
.section{padding:80px 24px;text-align:center}
.section-inner{max-width:900px;margin:0 auto}
.section-eyebrow{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:10px}
.section-title{font-family:'Syne',sans-serif;font-size:clamp(1.8rem,4vw,2.6rem);font-weight:800;letter-spacing:-1px;margin-bottom:10px}
.section-sub{color:var(--muted);font-size:.95rem;line-height:1.6;max-width:520px;margin:0 auto 44px}

/* ── Features ── */
.features-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;text-align:left}
.feature-card{background:var(--s0);border:1.5px solid var(--border);border-radius:var(--r);padding:26px 22px;box-shadow:var(--sh);transition:all .25s;position:relative;overflow:hidden}
.feature-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad);transform:scaleX(0);transition:transform .3s;transform-origin:left}
.feature-card:hover{border-color:var(--sky);transform:translateY(-4px);box-shadow:var(--sh-lg)}
.feature-card:hover::before{transform:scaleX(1)}
.feature-icon{width:46px;height:46px;border-radius:12px;background:var(--sky-glow);display:flex;align-items:center;justify-content:center;font-size:1.4rem;margin-bottom:14px;transition:transform .25s}
.feature-card:hover .feature-icon{transform:scale(1.1)}
.feature-title{font-family:'Syne',sans-serif;font-weight:700;font-size:.96rem;margin-bottom:6px}
.feature-desc{color:var(--muted);font-size:.83rem;line-height:1.55}

/* ── How it works ── */
.how-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;text-align:center;position:relative}
.how-grid::before{content:'';position:absolute;top:30px;left:12%;right:12%;height:2px;background:linear-gradient(90deg,var(--sky),var(--em));opacity:.3}
.how-step{}
.step-num{width:60px;height:60px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;color:#fff;margin:0 auto 14px;box-shadow:0 4px 16px var(--sky-glow)}
.step-title{font-family:'Syne',sans-serif;font-weight:700;font-size:.92rem;margin-bottom:6px}
.step-desc{color:var(--muted);font-size:.81rem;line-height:1.55}

/* ── CTA ── */
.cta-section{padding:80px 24px;display:flex;justify-content:center}
.cta-card{max-width:700px;width:100%;background:var(--grad);border-radius:22px;padding:52px 40px;text-align:center;position:relative;overflow:hidden;box-shadow:0 16px 48px var(--sky-glow)}
.cta-card::before{content:'✈';position:absolute;font-size:12rem;opacity:.06;right:-40px;top:-30px;color:#fff;line-height:1}
.cta-title{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;color:#fff;letter-spacing:-.8px;margin-bottom:10px}
.cta-sub{color:rgba(255,255,255,.8);font-size:.95rem;margin-bottom:28px}
.btn-cta-white{background:#fff;color:var(--sky-dark);border:none;font-weight:700;padding:12px 28px;border-radius:10px;font-size:.92rem}
.btn-cta-white:hover{opacity:.94;transform:translateY(-1px)}
.btn-cta-ghost{background:rgba(255,255,255,.15);color:#fff;border:1.5px solid rgba(255,255,255,.35)}
.btn-cta-ghost:hover{background:rgba(255,255,255,.25)}

/* ── Footer ── */
.footer{background:var(--s0);border-top:1px solid var(--border);padding:32px 48px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px}
.footer-brand{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem}
.footer-brand span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.footer-text{color:var(--muted);font-size:.8rem}
.footer-links{display:flex;gap:16px}
.footer-links a{color:var(--muted);text-decoration:none;font-size:.8rem;transition:color .2s}
.footer-links a:hover{color:var(--sky)}

/* ── Animations ── */
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .6s ease both}
.fu-1{animation-delay:.1s}.fu-2{animation-delay:.2s}.fu-3{animation-delay:.3s}
.fu-4{animation-delay:.4s}.fu-5{animation-delay:.5s}

/* ── Responsive ── */
.search-mobile-row{display:none}
@media(max-width:900px){
  .navbar{padding:0 24px}
  .nav-links{display:none}
  .hamburger{display:flex}
  .stats-inner{grid-template-columns:repeat(2,1fr)}
  .features-grid{grid-template-columns:1fr 1fr}
  .how-grid{grid-template-columns:1fr 1fr}
  .how-grid::before{display:none}
  .search-grid{display:none}
  .search-route-row,.search-bottom-row{display:grid}
  .search-mobile-row{display:grid}
}
@media(max-width:760px){
  .hero-search{padding:18px 16px}
}
@media(max-width:580px){
  .hero{padding:90px 16px 48px}
  .features-grid{grid-template-columns:1fr}
  .how-grid{grid-template-columns:1fr}
  .hero-search{padding:16px 14px}
  .search-route-row{grid-template-columns:1fr 36px 1fr;gap:7px}
  .search-bottom-row{grid-template-columns:1fr 1fr;gap:7px}
  .btn-search-mobile{grid-column:1/-1;width:100%;justify-content:center}
  .cta-card{padding:36px 20px}
  .footer{padding:20px 20px;flex-direction:column;text-align:center}
}
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar" id="navbar">
  <a href="${pageContext.request.contextPath}/" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>
  <div class="nav-links">
    <a href="#features" class="nav-link">Features</a>
    <a href="#how"      class="nav-link">How it Works</a>
  </div>
  <div class="nav-right">
    <button class="theme-btn" id="themeToggle">🌙</button>
    <% if (userName != null) { %>
      <a href="${pageContext.request.contextPath}/userDashboard" class="user-pill">
        <div class="user-av"><%= userName.substring(0,1).toUpperCase() %></div>
        <span><%= userName.contains(" ") ? userName.split(" ")[0] : userName %></span>
      </a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/login"    class="btn btn-outline">Sign In</a>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-grad">Get Started →</a>
    <% } %>
    <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
  </div>
</nav>
<div class="mobile-drawer" id="mobileDrawer">
  <a href="#features" class="nav-link" onclick="closeMobile()">Features</a>
  <a href="#how"      class="nav-link" onclick="closeMobile()">How it Works</a>
  <hr style="border:none;border-top:1px solid var(--border);margin:6px 0">
  <% if (userName != null) { %>
    <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-grad" style="justify-content:center">Dashboard</a>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/login"    class="btn btn-outline" style="justify-content:center">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-grad"    style="justify-content:center">Get Started →</a>
  <% } %>
</div>

<!-- Hero -->
<section class="hero">
  <div class="hero-mesh"></div>
  <div class="hero-badge fu">✦ Airline Reservation System</div>
  <h1 class="hero-title fu-1">Fly Smarter,<br><span class="grad">Book Faster</span></h1>
  <p class="hero-sub fu-2">Search, compare and book flights across India in seconds. Real-time seat availability, secure payments, and instant invoices.</p>
  <div class="hero-actions fu-2">
    <% if (userName != null) { %>
      <a href="${pageContext.request.contextPath}/searchFlights" class="btn btn-grad btn-hero">🔍 Search Flights</a>
      <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-outline btn-hero">Dashboard →</a>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-grad btn-hero">Get Started Free</a>
      <a href="${pageContext.request.contextPath}/login"    class="btn btn-outline btn-hero">Sign In</a>
    <% } %>
  </div>
  <!-- Quick search card -->
  <div class="hero-search fu-3">
    <div class="search-label">✈ Quick Flight Search</div>
    <form action="${pageContext.request.contextPath}/searchFlights" method="get">
      <%-- Desktop single-row grid (hidden on mobile via CSS) --%>
      <div class="search-grid">
        <div class="sf-group">
          <label class="sf-label">From</label>
          <div class="sf-wrap"><span class="sf-icon">🛫</span>
            <input type="text" name="source" id="srcInput" placeholder="Mumbai, Delhi…" autocomplete="off">
          </div>
        </div>
        <button type="button" class="swap-btn" id="swapBtn" title="Swap cities">⇄</button>
        <div class="sf-group">
          <label class="sf-label">To</label>
          <div class="sf-wrap"><span class="sf-icon">🛬</span>
            <input type="text" name="destination" id="dstInput" placeholder="Chennai, Kolkata…" autocomplete="off">
          </div>
        </div>
        <div class="sf-group">
          <label class="sf-label">Date</label>
          <div class="sf-wrap"><span class="sf-icon">📅</span>
            <input type="date" name="date" id="dateInput">
          </div>
        </div>
        <div class="sf-group">
          <label class="sf-label">Passengers</label>
          <div class="sf-wrap"><span class="sf-icon">👥</span>
            <select name="seats">
              <option value="1">1 Passenger</option>
              <option value="2">2 Passengers</option>
              <option value="3">3 Passengers</option>
              <option value="4">4 Passengers</option>
              <option value="5">5 Passengers</option>
            </select>
          </div>
        </div>
        <button type="submit" class="btn btn-grad btn-search">🔍 Search</button>
      </div>
      <%-- Mobile responsive layout (shown on ≤900px) --%>
      <div class="search-route-row search-mobile-row">
        <div class="sf-group">
          <label class="sf-label">From</label>
          <div class="sf-wrap"><span class="sf-icon">🛫</span>
            <input type="text" name="source" id="srcInputM" placeholder="Mumbai…" autocomplete="off">
          </div>
        </div>
        <button type="button" class="swap-btn" id="swapBtnM" title="Swap">⇄</button>
        <div class="sf-group">
          <label class="sf-label">To</label>
          <div class="sf-wrap"><span class="sf-icon">🛬</span>
            <input type="text" name="destination" id="dstInputM" placeholder="Delhi…" autocomplete="off">
          </div>
        </div>
      </div>
      <div class="search-bottom-row search-mobile-row" style="margin-top:10px">
        <div class="sf-group">
          <label class="sf-label">Date</label>
          <div class="sf-wrap"><span class="sf-icon">📅</span>
            <input type="date" name="date" id="dateInputM">
          </div>
        </div>
        <div class="sf-group">
          <label class="sf-label">Passengers</label>
          <div class="sf-wrap"><span class="sf-icon">👥</span>
            <select name="seats">
              <option value="1">1 Passenger</option>
              <option value="2">2 Passengers</option>
              <option value="3">3 Passengers</option>
              <option value="4">4 Passengers</option>
              <option value="5">5 Passengers</option>
            </select>
          </div>
        </div>
        <button type="submit" class="btn btn-grad btn-search btn-search-mobile" style="height:42px;padding:0 18px">🔍</button>
      </div>
    </form>
  </div>
</section>

<!-- Stats -->
<div class="stats">
  <div class="stats-inner">
    <div class="stat-card"><div class="stat-num">6+</div><div class="stat-lbl">Major Cities</div></div>
    <div class="stat-card"><div class="stat-num">50K+</div><div class="stat-lbl">Bookings Made</div></div>
    <div class="stat-card"><div class="stat-num">99.9%</div><div class="stat-lbl">Uptime</div></div>
    <div class="stat-card"><div class="stat-num">4.9★</div><div class="stat-lbl">User Rating</div></div>
  </div>
</div>

<!-- Features -->
<section class="section" id="features">
  <div class="section-inner">
    <div class="section-eyebrow">Why AeroSphere</div>
    <h2 class="section-title">Everything you need to fly</h2>
    <p class="section-sub">From real-time availability to automated refunds — we've thought of everything.</p>
    <div class="features-grid">
      <div class="feature-card">
        <div class="feature-icon">🔍</div>
        <div class="feature-title">Smart Search</div>
        <div class="feature-desc">Search flights by city, date and passengers. See real-time availability and lowest fares instantly.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">💺</div>
        <div class="feature-title">Seat Selection</div>
        <div class="feature-desc">Interactive seat map lets you pick your preferred seat before confirming your booking.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">💳</div>
        <div class="feature-title">Secure Payments</div>
        <div class="feature-desc">Razorpay-powered payment gateway with end-to-end encryption. Pay confidently every time.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">📄</div>
        <div class="feature-title">Instant Invoice</div>
        <div class="feature-desc">PDF invoices generated and emailed instantly after booking. Always ready when you need them.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">💸</div>
        <div class="feature-title">Smart Refunds</div>
        <div class="feature-desc">Cancel anytime with tiered refund policy — 100% before 24h, 50% within 24h of departure.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">📧</div>
        <div class="feature-title">Email Alerts</div>
        <div class="feature-desc">Booking confirmations, cancellations, refund updates and OTP verification — all via email.</div>
      </div>
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
      <div class="how-step">
        <div class="step-num">1</div>
        <div class="step-title">Search Flights</div>
        <div class="step-desc">Enter your origin, destination and travel date to see all available options.</div>
      </div>
      <div class="how-step">
        <div class="step-num">2</div>
        <div class="step-title">Select Seats</div>
        <div class="step-desc">Choose your preferred seats from the interactive seat map.</div>
      </div>
      <div class="how-step">
        <div class="step-num">3</div>
        <div class="step-title">Secure Payment</div>
        <div class="step-desc">Pay safely via Razorpay — cards, UPI, net banking all supported.</div>
      </div>
      <div class="how-step">
        <div class="step-num">4</div>
        <div class="step-title">Get Invoice</div>
        <div class="step-desc">Receive your PDF invoice by email instantly. You're all set to fly!</div>
      </div>
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
        <a href="${pageContext.request.contextPath}/searchFlights" class="btn btn-cta-white">🔍 Search Flights</a>
        <a href="${pageContext.request.contextPath}/userDashboard"  class="btn btn-cta-ghost">Dashboard →</a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-cta-white">Create Free Account</a>
        <a href="${pageContext.request.contextPath}/login"    class="btn btn-cta-ghost">Sign In →</a>
      <% } %>
    </div>
  </div>
</section>

<!-- Footer -->
<footer class="footer">
  <div class="footer-brand">Aero<span>Sphere</span></div>
  <p class="footer-text">&copy; <%= new java.util.Date().getYear() + 1900 %> AeroSphere. Built with ☕ and ✈</p>
  <div class="footer-links">
    <a href="#">Privacy</a><a href="#">Terms</a><a href="#">Support</a>
  </div>
</footer>

<script>
// Theme
(function(){const s=localStorage.getItem('asTheme')||'light';document.documentElement.setAttribute('data-theme',s);document.getElementById('themeToggle').textContent=s==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.textContent=n==='dark'?'☀️':'🌙';});

// Navbar scroll shadow
window.addEventListener('scroll',()=>document.getElementById('navbar').classList.toggle('scrolled',scrollY>10));

// Hamburger
const ham=document.getElementById('hamburger'),drawer=document.getElementById('mobileDrawer');
ham.addEventListener('click',()=>{ham.classList.toggle('open');drawer.classList.toggle('open');});
function closeMobile(){ham.classList.remove('open');drawer.classList.remove('open');}

// Swap cities (desktop)
document.getElementById('swapBtn').addEventListener('click',()=>{
  const s=document.getElementById('srcInput'),d=document.getElementById('dstInput');
  [s.value,d.value]=[d.value,s.value];
  s.closest('.sf-wrap').style.boxShadow='0 0 0 3px var(--sky-glow)';
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

// Responsive: show correct layout
// Layout handled by CSS media queries

// Date min = today
const today=new Date().toISOString().split('T')[0];
document.getElementById('dateInput').min=today;
document.getElementById('dateInputM').min=today;

// Scroll-reveal (IntersectionObserver)
const obs=new IntersectionObserver(entries=>{
  entries.forEach(e=>{if(e.isIntersecting){e.target.style.opacity='1';e.target.style.transform='translateY(0)';}});
},{threshold:.12});
document.querySelectorAll('.feature-card,.stat-card,.how-step,.cta-card').forEach(el=>{
  el.style.cssText='opacity:0;transform:translateY(20px);transition:opacity .6s ease,transform .6s ease';
  obs.observe(el);
});
</script>
</body>
</html>
