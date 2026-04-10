<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map, java.util.LinkedHashMap" %>
<%@ page import="java.sql.Date, java.sql.Time" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String userRole  = (String) session.getAttribute("userRole");
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
    String initials  = String.valueOf(userName.charAt(0)).toUpperCase();
    String servletPath = request.getServletPath();

    @SuppressWarnings("unchecked")
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    String error = (String) request.getAttribute("error");

    // Group flights by date
    Map<String, List<Map<String,Object>>> grouped = new LinkedHashMap<>();
    if (flights != null) {
        for (Map<String,Object> f : flights) {
            String dateKey = f.get("depart_date").toString(); // "YYYY-MM-DD"
            grouped.computeIfAbsent(dateKey, k -> new java.util.ArrayList<>()).add(f);
        }
    }

    SimpleDateFormat dayFmt  = new SimpleDateFormat("EEEE, d MMMM yyyy");
    SimpleDateFormat timeFmt = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>All Flights – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
/* ── Design tokens — identical to rest of project ── */
:root{
  --primary:#10B981;--primary-dark:#059669;--primary-light:#34D399;
  --primary-glow:rgba(16,185,129,.18);--accent:#A7F3D0;
  --bg:#FAFAF9;--bg-alt:#F3F4F6;--card-bg:#FFFFFF;
  --text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;
  --shadow:0 2px 12px rgba(0,0,0,.06);--shadow-md:0 4px 20px rgba(0,0,0,.08);--shadow-lg:0 12px 40px rgba(0,0,0,.1);
  --danger:#EF4444;--danger-bg:rgba(239,68,68,.08);
  --warning:#F59E0B;--warning-bg:rgba(245,158,11,.08);
  --radius:14px;
}
[data-theme="dark"]{
  --primary:#10B981;--primary-dark:#34D399;--primary-light:#34D399;
  --primary-glow:rgba(16,185,129,.22);--accent:#34D399;
  --bg:#0A0A0A;--bg-alt:#111111;--card-bg:#141414;
  --text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;
  --shadow:0 2px 12px rgba(0,0,0,.4);--shadow-md:0 4px 20px rgba(0,0,0,.5);--shadow-lg:0 12px 40px rgba(0,0,0,.6);
  --danger-bg:rgba(239,68,68,.12);--warning-bg:rgba(245,158,11,.12);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
a{text-decoration:none;color:inherit}

/* ── Navbar — exact copy from project ── */
.navbar{position:sticky;top:0;z-index:200;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow);backdrop-filter:blur(8px)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow);flex-shrink:0}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}
.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s;white-space:nowrap}
.nav-link:hover{color:var(--text);background:var(--border)}
.nav-link.active{color:var(--primary);background:var(--primary-glow);font-weight:600}
.nav-link.btn-danger{color:var(--danger);background:var(--danger-bg)}
.nav-link.btn-danger:hover{background:rgba(239,68,68,.14)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.theme-toggle:hover{border-color:var(--primary)}
.nav-right{display:flex;align-items:center;gap:8px}
.user-pill{display:flex;align-items:center;gap:8px;padding:5px 12px;border:1px solid var(--border);border-radius:9999px;text-decoration:none;color:var(--text);font-size:.84rem;font-weight:500;transition:all .2s}
.user-pill:hover{border-color:var(--primary)}
.user-avatar{width:26px;height:26px;background:var(--primary-glow);border:1.5px solid var(--primary);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:700;color:var(--primary)}
.hamburger{display:none;flex-direction:column;justify-content:center;gap:5px;width:32px;height:32px;cursor:pointer;border:1px solid var(--border);border-radius:8px;background:none;padding:6px}
.hamburger span{display:block;height:2px;width:100%;background:var(--text);border-radius:2px;transition:all .25s}
.mobile-nav{display:none;flex-direction:column;gap:4px;position:fixed;top:57px;left:0;right:0;background:var(--card-bg);border-bottom:1px solid var(--border);padding:12px 20px 16px;box-shadow:var(--shadow-md);z-index:190}
.mobile-nav.open{display:flex}

/* ── Page layout ── */
.page-wrapper{max-width:1100px;margin:0 auto;padding:32px 24px 60px}

/* ── Page header ── */
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}

/* ── Stats row ── */
.stats-row{display:flex;gap:12px;margin-bottom:28px;flex-wrap:wrap}
.stat-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:14px 20px;flex:1;min-width:130px;box-shadow:var(--shadow)}
.stat-num{font-size:1.5rem;font-weight:900;color:var(--primary);letter-spacing:-.5px}
.stat-lbl{font-size:.74rem;color:var(--text-muted);margin-top:2px;font-weight:500}

/* ── Filter bar ── */
.filter-bar{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:14px 18px;margin-bottom:24px;display:flex;align-items:center;gap:8px;flex-wrap:wrap;box-shadow:var(--shadow);position:relative;overflow:hidden}
.filter-bar::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--primary),var(--accent),var(--primary))}
.filter-label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);white-space:nowrap;margin-right:4px}
.filter-btn{background:var(--bg-alt);border:1px solid var(--border);color:var(--text-muted);padding:5px 14px;border-radius:9999px;font-size:.8rem;font-weight:500;cursor:pointer;font-family:'Inter',sans-serif;transition:all .2s;white-space:nowrap}
.filter-btn:hover{border-color:var(--primary);color:var(--primary)}
.filter-btn.active{background:var(--primary);border-color:var(--primary);color:#fff;font-weight:600}
.filter-sep{width:1px;height:22px;background:var(--border);margin:0 4px}
.search-wrap{margin-left:auto;position:relative}
.search-wrap input{background:var(--bg-alt);border:1.5px solid var(--border);color:var(--text);padding:7px 12px 7px 34px;border-radius:9999px;font-size:.83rem;font-family:'Inter',sans-serif;width:210px;outline:none;transition:all .2s}
.search-wrap input::placeholder{color:var(--text-muted)}
.search-wrap input:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow);width:250px}
.search-wrap svg{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--text-muted);width:15px;height:15px;pointer-events:none}

/* ── Date section ── */
.date-section{margin-bottom:36px}
.date-header{display:flex;align-items:center;gap:14px;margin-bottom:14px}
.date-pill{background:var(--primary-glow);border:1px solid var(--primary);color:var(--primary);padding:5px 14px;border-radius:9999px;font-size:.8rem;font-weight:700;white-space:nowrap}
.date-line{flex:1;height:1px;background:var(--border)}
.date-count{font-size:.76rem;color:var(--text-muted);white-space:nowrap}

/* ── Flight cards — same structure as search_results.jsp ── */
.flight-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;margin-bottom:12px;transition:all .25s;box-shadow:var(--shadow);animation:fadeUp .4s ease both}
.flight-card:hover{border-color:var(--primary);box-shadow:var(--shadow-lg);transform:translateY(-2px)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fc-body{padding:18px 22px;display:grid;grid-template-columns:auto 1fr auto 1fr auto;align-items:center;gap:16px}
.city-block{}
.city-code{font-size:1.6rem;font-weight:900;letter-spacing:-1px}
.city-name{font-size:.74rem;color:var(--text-muted);margin-top:2px}
.city-time{font-size:.82rem;color:var(--primary);font-weight:600;margin-top:4px}
.flight-center{display:flex;flex-direction:column;align-items:center;gap:5px;padding:0 8px}
.flight-no{font-size:.7rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.8px}
.flight-line{display:flex;align-items:center;gap:5px;width:100%}
.flight-line-bar{flex:1;height:1px;background:var(--border)}
.flight-line-icon{color:var(--primary);font-size:.95rem}
.flight-duration{font-size:.68rem;color:var(--text-muted);font-weight:500}
.price-block{text-align:right}
.price-big{font-size:1.45rem;font-weight:900;letter-spacing:-.5px}
.price-sub{font-size:.72rem;color:var(--text-muted);margin-bottom:10px;margin-top:2px}
.fc-footer{padding:10px 22px;background:var(--bg-alt);border-top:1px solid var(--border);display:flex;align-items:center;gap:16px;flex-wrap:wrap}
.fmeta{font-size:.75rem;color:var(--text-muted)}
.badge{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;border-radius:9999px;font-size:.72rem;font-weight:700}
.badge-ok{background:rgba(16,185,129,.1);color:var(--primary);border:1px solid rgba(16,185,129,.2)}
.badge-warn{background:var(--warning-bg);color:var(--warning);border:1px solid rgba(245,158,11,.2)}
.badge-full{background:var(--danger-bg);color:var(--danger);border:1px solid rgba(239,68,68,.2)}
[data-theme="dark"] .badge-full{color:#FCA5A5}

/* ── Buttons — exact match ── */
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:9px;font-size:.84rem;font-weight:600;text-decoration:none;border:none;cursor:pointer;transition:all .2s;font-family:'Inter',sans-serif}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 2px 8px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-ghost{background:transparent;color:var(--text-muted);border:1px solid var(--border)}
.btn-ghost:hover{border-color:var(--primary);color:var(--primary)}
.btn-sm{padding:6px 14px;font-size:.8rem}

/* ── Alert ── */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:var(--danger-bg);border:1px solid rgba(239,68,68,.2);color:var(--danger)}
[data-theme="dark"] .alert-error{color:#FCA5A5}

/* ── Empty state ── */
.empty-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:60px 24px;text-align:center;box-shadow:var(--shadow)}
.empty-icon{font-size:3rem;margin-bottom:16px;opacity:.4}

/* ── Date quick-jump ── */
.jump-bar{display:flex;gap:6px;overflow-x:auto;padding:4px 0 14px;scrollbar-width:none;margin-bottom:8px}
.jump-bar::-webkit-scrollbar{display:none}
.jump-btn{background:var(--card-bg);border:1px solid var(--border);color:var(--text-muted);padding:4px 12px;border-radius:9999px;font-size:.75rem;font-weight:600;cursor:pointer;white-space:nowrap;transition:all .2s;font-family:'Inter',sans-serif}
.jump-btn:hover{border-color:var(--primary);color:var(--primary)}

/* ── Back to top ── */
#backTop{position:fixed;bottom:24px;right:24px;background:var(--primary);color:#fff;border:none;width:42px;height:42px;border-radius:10px;font-size:1.1rem;cursor:pointer;display:none;align-items:center;justify-content:center;box-shadow:0 4px 16px var(--primary-glow);transition:all .2s;z-index:99}
#backTop:hover{transform:translateY(-2px)}
#backTop.show{display:flex}

/* ── Responsive ── */
@media(max-width:900px){.fc-body{grid-template-columns:1fr 1fr}.flight-center{display:none}.stats-row{gap:8px}}
@media(max-width:640px){.nav-links{display:none}.hamburger{display:flex}.fc-body{grid-template-columns:1fr 1fr}.search-wrap{display:none}}
</style>
</head>
<body>

<!-- Apply theme immediately to avoid flash -->
<script>
(function(){
  var t = localStorage.getItem('aerosphere-theme') ||
    (window.matchMedia('(prefers-color-scheme:dark)').matches ? 'dark' : 'light');
  document.documentElement.setAttribute('data-theme', t);
})();
</script>

<!-- ── NAVBAR ── -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link ">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link ">🔍 Search</a>
        <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link active">✈️ All Flights</a>
        <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link ">🎫 My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link ">💸 Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"           class="nav-link ">👤 Profile</a>
        <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">↩ Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<!-- Mobile nav -->
<div class="mobile-nav" id="mobileNav">
  <a href="${pageContext.request.contextPath}/userDashboard"      class="nav-link">🏠 Dashboard</a>
  <a href="${pageContext.request.contextPath}/searchFlights"      class="nav-link">🔍 Search Flights</a>
  <a href="${pageContext.request.contextPath}/allFlights"         class="nav-link active">✈️ All Flights</a>
  <a href="${pageContext.request.contextPath}/userBookings"       class="nav-link">🎫 My Bookings</a>
  <a href="${pageContext.request.contextPath}/userRefundHistory"  class="nav-link">💸 Refund History</a>
  <a href="${pageContext.request.contextPath}/profile"            class="nav-link">👤 Profile</a>
  <hr style="border:none;border-top:1px solid var(--border);margin:6px 0">
  <a href="${pageContext.request.contextPath}/logout"             class="nav-link btn-danger">↩ Logout</a>
</div>

<!-- ── PAGE ── -->
<div class="page-wrapper">

  <!-- Header -->
  <div class="page-header">
    <div>
      <div class="page-title">✈️ All Flights</div>
      <div class="page-subtitle">Browse every available flight — no search needed</div>
    </div>
    <a href="${pageContext.request.contextPath}/searchFlights" class="btn btn-ghost">🔍 Advanced Search</a>
  </div>

  <!-- Error -->
  <% if (error != null) { %>
    <div class="alert alert-error">⚠ <%= error %></div>
  <% } %>

  <%
    int totalFlights = (flights != null) ? flights.size() : 0;
    int totalDays    = grouped.size();
    // find lowest price
    double minPrice = Double.MAX_VALUE;
    if (flights != null) {
      for (Map<String,Object> f : flights) {
        double p = (Double) f.get("price");
        if (p < minPrice) minPrice = p;
      }
    }
    if (minPrice == Double.MAX_VALUE) minPrice = 0;
  %>

  <!-- Stats -->
  <div class="stats-row">
    <div class="stat-card">
      <div class="stat-num"><%= totalFlights %></div>
      <div class="stat-lbl">Total Flights</div>
    </div>
    <div class="stat-card">
      <div class="stat-num"><%= totalDays %></div>
      <div class="stat-lbl">Days with Flights</div>
    </div>
    <div class="stat-card">
      <div class="stat-num">6</div>
      <div class="stat-lbl">City Routes</div>
    </div>
    <div class="stat-card">
      <div class="stat-num">₹<%= minPrice > 0 ? String.format("%.0f", minPrice) : "—" %></div>
      <div class="stat-lbl">Starting From</div>
    </div>
  </div>

  <!-- Filter bar -->
  <div class="filter-bar">
    <span class="filter-label">Route:</span>
    <button class="filter-btn active" onclick="setFilter('all',this)">All</button>
    <button class="filter-btn" onclick="setFilter('Mumbai',this)">Mumbai</button>
    <button class="filter-btn" onclick="setFilter('Delhi',this)">Delhi</button>
    <button class="filter-btn" onclick="setFilter('Bengaluru',this)">Bengaluru</button>
    <button class="filter-btn" onclick="setFilter('Chennai',this)">Chennai</button>
    <button class="filter-btn" onclick="setFilter('Kolkata',this)">Kolkata</button>
    <button class="filter-btn" onclick="setFilter('Hyderabad',this)">Hyderabad</button>
    <div class="filter-sep"></div>
    <div class="search-wrap">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
      </svg>
      <input type="text" id="searchInput" placeholder="City or flight no..." oninput="applySearch(this.value)">
    </div>
  </div>

  <!-- Date quick-jump -->
  <% if (!grouped.isEmpty()) { %>
  <div class="jump-bar" id="jumpBar">
    <% for (String dateKey : grouped.keySet()) {
         java.util.Date d = Date.valueOf(dateKey);
         String shortLabel = new java.text.SimpleDateFormat("d MMM").format(d);
    %>
      <button class="jump-btn" onclick="document.getElementById('date-<%= dateKey %>').scrollIntoView({behavior:'smooth',block:'start'})"><%= shortLabel %></button>
    <% } %>
  </div>
  <% } %>

  <!-- No flights -->
  <% if (totalFlights == 0) { %>
    <div class="empty-card">
      <div class="empty-icon">🛫</div>
      <p style="color:var(--text-muted);font-size:1rem;margin-bottom:20px">No flights scheduled right now.</p>
      <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-primary">Go to Dashboard</a>
    </div>

  <% } else { %>

  <!-- Flight groups by date -->
  <div id="flightsContainer">
    <%
      int globalIdx = 0;
      for (Map.Entry<String, List<Map<String,Object>>> entry : grouped.entrySet()) {
        String dateKey = entry.getKey();
        List<Map<String,Object>> dayFlights = entry.getValue();
        java.util.Date dateObj = Date.valueOf(dateKey);
        String dateFormatted = dayFmt.format(dateObj);
    %>

    <div class="date-section" id="date-<%= dateKey %>" data-date="<%= dateKey %>">
      <div class="date-header">
        <div class="date-pill"><%= dateFormatted %></div>
        <div class="date-line"></div>
        <div class="date-count"><%= dayFlights.size() %> flight<%= dayFlights.size() > 1 ? "s" : "" %></div>
      </div>

      <%
        for (Map<String,Object> f : dayFlights) {
          globalIdx++;
          int seatsAvail = (Integer) f.get("seats_available");
          int seatsTotal = (Integer) f.get("seats_total");
          double price   = (Double)  f.get("price");
          String flightId  = String.valueOf(f.get("id"));
          String src       = (String) f.get("source");
          String dst       = (String) f.get("destination");
          String flightNo  = (String) f.get("flight_no");
          String depTime   = timeFmt.format((Time) f.get("depart_time"));
          Time arrT        = (Time)   f.get("arrival_time");
          String arrTime   = (arrT != null) ? timeFmt.format(arrT) : "—";

          // City codes
          java.util.Map<String,String> codeMap = new java.util.HashMap<>();
          codeMap.put("Mumbai","BOM"); codeMap.put("Delhi","DEL");
          codeMap.put("Bengaluru","BLR"); codeMap.put("Chennai","MAA");
          codeMap.put("Kolkata","CCU"); codeMap.put("Hyderabad","HYD");
          codeMap.put("mumbai","BOM"); codeMap.put("delhi","DEL");
          String srcCode = codeMap.getOrDefault(src, src.substring(0,Math.min(3,src.length())).toUpperCase());
          String dstCode = codeMap.getOrDefault(dst, dst.substring(0,Math.min(3,dst.length())).toUpperCase());

          // Duration
          long depMs = ((Time) f.get("depart_time")).getTime();
          long arrMs = (arrT != null) ? arrT.getTime() : depMs;
          long diffMs = arrMs - depMs;
          if (diffMs < 0) diffMs += 86400000L;
          long durH = diffMs / 3600000;
          long durM = (diffMs % 3600000) / 60000;
          String duration = durH > 0 ? durH + "h " + durM + "m" : durM + "m";

          // Seats badge
          double pct = (double) seatsAvail / seatsTotal;
          String badgeCls, badgeTxt;
          if (seatsAvail == 0) { badgeCls = "badge-full"; badgeTxt = "⛔ Sold Out"; }
          else if (pct < 0.15) { badgeCls = "badge-warn"; badgeTxt = "🔥 " + seatsAvail + " left"; }
          else                  { badgeCls = "badge-ok";   badgeTxt = "✅ " + seatsAvail + " seats"; }
      %>

      <div class="flight-card"
           style="animation-delay:<%= globalIdx * 0.04 %>s"
           data-src="<%= src.toLowerCase() %>"
           data-dst="<%= dst.toLowerCase() %>"
           data-fno="<%= flightNo.toLowerCase() %>">

        <div class="fc-body">
          <!-- Source -->
          <div class="city-block">
            <div class="city-code"><%= srcCode %></div>
            <div class="city-name"><%= src %></div>
            <div class="city-time"><%= depTime %></div>
          </div>

          <!-- Center line -->
          <div class="flight-center">
            <div class="flight-no"><%= flightNo %></div>
            <div class="flight-line">
              <div class="flight-line-bar"></div>
              <span class="flight-line-icon">✈</span>
              <div class="flight-line-bar"></div>
            </div>
            <div class="flight-duration"><%= duration %> · Non-stop</div>
          </div>

          <!-- Destination -->
          <div class="city-block">
            <div class="city-code"><%= dstCode %></div>
            <div class="city-name"><%= dst %></div>
            <div class="city-time"><%= arrTime %></div>
          </div>

          <!-- Price + Book -->
          <div class="price-block">
            <div class="price-big">₹<%= String.format("%.0f", price) %></div>
            <div class="price-sub">per seat</div>
            <% if (seatsAvail > 0) { %>
              <form action="${pageContext.request.contextPath}/bookFlight" method="post" style="display:inline">
                <input type="hidden" name="flightId" value="<%= flightId %>">
                <input type="hidden" name="numSeats"  value="1">
                <button type="submit" class="btn btn-primary btn-sm">Book Now →</button>
              </form>
            <% } else { %>
              <span class="badge badge-full">Sold Out</span>
            <% } %>
          </div>
        </div>

        <div class="fc-footer">
          <span class="fmeta">📅 <%= dateFormatted %></span>
          <span class="badge <%= badgeCls %>"><%= badgeTxt %></span>
        </div>

      </div>
      <% } // end dayFlights loop %>
    </div><!-- end date-section -->

    <% } // end grouped loop %>
  </div><!-- end flightsContainer -->

  <% } // end else %>

</div><!-- end page-wrapper -->

<!-- Back to top -->
<button id="backTop" onclick="window.scrollTo({top:0,behavior:'smooth'})">↑</button>

<script>
/* ── Theme ── */
var _t = localStorage.getItem('aerosphere-theme') ||
  (window.matchMedia('(prefers-color-scheme:dark)').matches ? 'dark' : 'light');
document.documentElement.setAttribute('data-theme', _t);
document.getElementById('themeToggle').textContent = _t === 'dark' ? '☀️' : '🌙';

function toggleTheme() {
  var n = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', n);
  localStorage.setItem('aerosphere-theme', n);
  document.getElementById('themeToggle').textContent = n === 'dark' ? '☀️' : '🌙';
}

/* ── Mobile nav ── */
function toggleMobileNav() {
  document.getElementById('mobileNav').classList.toggle('open');
}

/* ── Filter by city ── */
var activeFilter = 'all';
var searchTerm = '';

function setFilter(val, btn) {
  activeFilter = val;
  document.querySelectorAll('.filter-btn').forEach(function(b){ b.classList.remove('active'); });
  btn.classList.add('active');
  applyFilters();
}

function applySearch(val) {
  searchTerm = val.toLowerCase().trim();
  applyFilters();
}

function applyFilters() {
  var cards = document.querySelectorAll('.flight-card');
  var sections = document.querySelectorAll('.date-section');

  cards.forEach(function(card) {
    var src = card.dataset.src || '';
    var dst = card.dataset.dst || '';
    var fno = card.dataset.fno || '';

    var matchFilter = activeFilter === 'all' ||
                      src.indexOf(activeFilter.toLowerCase()) >= 0 ||
                      dst.indexOf(activeFilter.toLowerCase()) >= 0;

    var matchSearch = !searchTerm ||
                      src.indexOf(searchTerm) >= 0 ||
                      dst.indexOf(searchTerm) >= 0 ||
                      fno.indexOf(searchTerm) >= 0;

    card.style.display = (matchFilter && matchSearch) ? '' : 'none';
  });

  // Hide date sections with no visible cards
  sections.forEach(function(section) {
    var visible = section.querySelectorAll('.flight-card:not([style*="display: none"])');
    section.style.display = visible.length > 0 ? '' : 'none';
  });
}

/* ── Back to top ── */
window.addEventListener('scroll', function() {
  var btn = document.getElementById('backTop');
  if (window.scrollY > 400) btn.classList.add('show');
  else btn.classList.remove('show');
});
</script>
</body>
</html>
