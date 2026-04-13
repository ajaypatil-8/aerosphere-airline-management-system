<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map, java.util.LinkedHashMap" %>
<%@ page import="java.sql.Date, java.sql.Time" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
    String initials  = String.valueOf(userName.charAt(0)).toUpperCase();

    @SuppressWarnings("unchecked")
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    String error = (String) request.getAttribute("error");

    Map<String, List<Map<String,Object>>> grouped = new LinkedHashMap<>();
    if (flights != null) {
        for (Map<String,Object> f : flights) {
            String dateKey = f.get("depart_date").toString();
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
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--sky:#0EA5E9;--sky-dark:#0284C7;--sky-glow:rgba(14,165,233,.18);--em:#10B981;--em-dark:#059669;--em-glow:rgba(16,185,129,.18);--grad:linear-gradient(135deg,var(--sky),var(--em));--bg:#F0F9FF;--s0:#FFFFFF;--s1:#F8FAFC;--s2:#F0F9FF;--text:#0F172A;--muted:#64748B;--border:#E2E8F0;--warn:#F59E0B;--danger:#EF4444;--sh:0 1px 3px rgba(0,0,0,.06),0 4px 16px rgba(0,0,0,.04);--sh-lg:0 8px 32px rgba(0,0,0,.08);--r:14px}
[data-theme="dark"]{--bg:#060A12;--s0:#0D1117;--s1:#111827;--s2:#1A2232;--text:#F1F5F9;--muted:#94A3B8;--border:#1E293B;--sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);--sh-lg:0 8px 32px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
/* ── Navbar ── */
.navbar{position:sticky;top:0;z-index:200;display:flex;align-items:center;padding:0 32px;height:62px;background:rgba(255,255,255,.88);backdrop-filter:blur(14px);border-bottom:1px solid var(--border);box-shadow:var(--sh);gap:6px}
[data-theme="dark"] .navbar{background:rgba(13,17,23,.88)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text);margin-right:10px}
.brand-icon{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 3px 10px var(--sky-glow)}
.brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1.05rem;letter-spacing:-.4px}
.brand-name span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.nav-links{display:flex;align-items:center;gap:2px;flex:1}
.nav-link{text-decoration:none;color:var(--muted);padding:6px 11px;border-radius:8px;font-size:.83rem;font-weight:500;transition:all .18s;white-space:nowrap}
.nav-link:hover{color:var(--text);background:var(--s2)}.nav-link.active{color:var(--sky);background:var(--sky-glow);font-weight:600}
.nav-link.btn-danger{color:var(--danger);background:rgba(239,68,68,.08)}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.user-pill{display:flex;align-items:center;gap:7px;text-decoration:none;color:var(--text);padding:5px 10px 5px 5px;border:1px solid var(--border);border-radius:99px;font-size:.82rem;font-weight:500;transition:border-color .2s}
.user-pill:hover{border-color:var(--sky)}
.user-av{width:26px;height:26px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:800;color:#fff}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--s0);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.85rem;color:var(--muted)}
.theme-toggle:hover{border-color:var(--sky)}
.btn-logout{text-decoration:none;font-size:.82rem;font-weight:600;color:var(--danger);background:rgba(239,68,68,.08);padding:6px 12px;border-radius:8px}
.hamburger{display:none;width:34px;height:34px;border:1px solid var(--border);border-radius:8px;background:var(--s0);flex-direction:column;align-items:center;justify-content:center;gap:4px;cursor:pointer;padding:0}
.hamburger span{display:block;width:16px;height:1.5px;background:var(--muted);border-radius:2px;transition:all .3s}
.mobile-nav{position:fixed;top:62px;left:0;right:0;z-index:199;background:var(--s0);border-bottom:1px solid var(--border);box-shadow:var(--sh-lg);padding:10px 16px 16px;flex-direction:column;gap:4px;display:none}
.mobile-nav.open{display:flex}
/* ── Page ── */
.page-wrap{max-width:1100px;margin:0 auto;padding:32px 28px 60px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px}
.page-title{font-family:'Syne',sans-serif;font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--muted);font-size:.9rem}
/* ── Stats ── */
.stats-row{display:flex;gap:12px;margin-bottom:24px;flex-wrap:wrap}
.stat-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:14px 20px;flex:1;min-width:130px;box-shadow:var(--sh)}
.stat-num{font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;letter-spacing:-.5px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.stat-lbl{font-size:.74rem;color:var(--muted);font-weight:500;margin-top:2px}
/* ── Filter bar ── */
.filter-bar{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:14px 18px;margin-bottom:22px;display:flex;align-items:center;gap:8px;flex-wrap:wrap;box-shadow:var(--sh);position:relative;overflow:hidden}
.filter-bar::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad)}
.filter-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--muted);white-space:nowrap;margin-right:4px}
.filter-btn{background:var(--s1);border:1.5px solid var(--border);color:var(--muted);padding:5px 13px;border-radius:99px;font-size:.79rem;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;transition:all .2s;white-space:nowrap}
.filter-btn:hover{border-color:var(--sky);color:var(--sky)}
.filter-btn.active{background:var(--grad);border-color:transparent;color:#fff}
.filter-sep{width:1px;height:22px;background:var(--border);margin:0 4px;flex-shrink:0}
.search-wrap{margin-left:auto;position:relative}
.search-wrap input{background:var(--s1);border:1.5px solid var(--border);color:var(--text);padding:7px 12px 7px 34px;border-radius:99px;font-size:.82rem;font-family:'DM Sans',sans-serif;width:200px;outline:none;transition:all .2s}
.search-wrap input:focus{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow);width:240px}
.search-wrap input::placeholder{color:var(--muted);opacity:.7}
.search-wrap svg{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--muted);width:14px;height:14px;pointer-events:none}
/* ── Date section ── */
.date-section{margin-bottom:32px}
.date-header{display:flex;align-items:center;gap:14px;margin-bottom:12px}
.date-pill{background:var(--sky-glow);border:1px solid var(--sky);color:var(--sky-dark);padding:4px 13px;border-radius:99px;font-size:.78rem;font-weight:700;white-space:nowrap}
[data-theme="dark"] .date-pill{color:var(--sky)}
.date-line{flex:1;height:1px;background:var(--border)}
.date-count{font-size:.74rem;color:var(--muted);white-space:nowrap}
/* ── Flight card ── */
.flight-card{background:var(--s0);border:1.5px solid var(--border);border-radius:var(--r);overflow:hidden;margin-bottom:10px;transition:all .22s;box-shadow:var(--sh)}
.flight-card:hover{border-color:var(--sky);box-shadow:var(--sh-lg);transform:translateY(-2px)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fc-body{padding:18px 22px;display:grid;grid-template-columns:auto 1fr auto 1fr auto;align-items:center;gap:14px}
.city-code{font-family:'Syne',sans-serif;font-size:1.6rem;font-weight:800;letter-spacing:-1px}
.city-name{font-size:.73rem;color:var(--muted);margin-top:2px}
.city-time{font-size:.8rem;font-weight:600;margin-top:4px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.flight-center{display:flex;flex-direction:column;align-items:center;gap:4px;padding:0 6px}
.flight-no-lbl{font-size:.68rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.8px}
.flight-line{display:flex;align-items:center;gap:4px;width:100%}
.fl-bar{flex:1;height:1px;background:var(--border)}
.fl-icon{color:var(--sky);font-size:.9rem}
.flight-dur{font-size:.67rem;color:var(--muted)}
.price-block{text-align:right}
.price-big{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;letter-spacing:-.5px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.price-sub{font-size:.71rem;color:var(--muted);margin-bottom:10px;margin-top:1px}
.btn-book{display:inline-flex;align-items:center;gap:5px;padding:8px 18px;background:var(--grad);color:#fff;border:none;border-radius:9px;font-family:'DM Sans',sans-serif;font-size:.83rem;font-weight:700;cursor:pointer;text-decoration:none;box-shadow:0 3px 10px var(--sky-glow);transition:all .2s}
.btn-book:hover{opacity:.9;transform:translateY(-1px)}
.btn-book.sold{background:var(--s1);color:var(--muted);cursor:not-allowed;pointer-events:none;box-shadow:none}
.fc-footer{padding:9px 22px;background:var(--s1);border-top:1px solid var(--border);display:flex;align-items:center;gap:14px;flex-wrap:wrap}
.fmeta{font-size:.74rem;color:var(--muted)}
.badge{display:inline-flex;align-items:center;gap:4px;padding:3px 9px;border-radius:99px;font-size:.7rem;font-weight:700;white-space:nowrap}
.badge-ok{background:rgba(16,185,129,.1);color:var(--em);border:1px solid rgba(16,185,129,.2)}
.badge-warn{background:rgba(245,158,11,.1);color:var(--warn);border:1px solid rgba(245,158,11,.2)}
.badge-full{background:rgba(239,68,68,.08);color:var(--danger);border:1px solid rgba(239,68,68,.2)}
/* ── Jump bar ── */
.jump-bar{display:flex;gap:6px;overflow-x:auto;padding:2px 0 14px;scrollbar-width:none;margin-bottom:6px}
.jump-bar::-webkit-scrollbar{display:none}
.jump-btn{background:var(--s0);border:1.5px solid var(--border);color:var(--muted);padding:4px 12px;border-radius:99px;font-size:.74rem;font-weight:600;cursor:pointer;white-space:nowrap;transition:all .2s;font-family:'DM Sans',sans-serif}
.jump-btn:hover{border-color:var(--sky);color:var(--sky)}
/* ── Alert + Empty ── */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:var(--danger)}
.empty-card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);padding:60px 24px;text-align:center;box-shadow:var(--sh)}
.empty-icon{font-size:3rem;margin-bottom:14px;opacity:.4}
/* ── Back to top ── */
#backTop{position:fixed;bottom:24px;right:24px;background:var(--grad);color:#fff;border:none;width:42px;height:42px;border-radius:10px;font-size:1.1rem;cursor:pointer;display:none;align-items:center;justify-content:center;box-shadow:0 4px 16px var(--sky-glow);transition:all .2s;z-index:99}
#backTop:hover{transform:translateY(-2px)}
#backTop.show{display:flex}
@media(max-width:768px){.navbar{padding:0 16px}.nav-links{display:none}.hamburger{display:flex}.page-wrap{padding:20px 14px}}
@media(max-width:640px){.fc-body{grid-template-columns:1fr 1fr}.flight-center{display:none}.search-wrap{display:none}}
</style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link active">✈ All Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refunds</a>
  </div>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="user-pill">
      <div class="user-av"><%= initials %></div><span><%= firstName %></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">↩</a>
    <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
  </div>
</nav>
<div class="mobile-nav" id="mobileNav">
  <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
  <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link">🔍 Search</a>
  <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link active">✈ All Flights</a>
  <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 My Bookings</a>
  <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refunds</a>
  <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger" style="color:var(--danger)">↩ Logout</a>
</div>

<div class="page-wrap">
  <div class="page-header">
    <div>
      <h1 class="page-title">✈ All Flights</h1>
      <p class="page-subtitle">Browse every available flight — no search needed</p>
    </div>
    <a href="${pageContext.request.contextPath}/searchFlights" class="btn-book" style="padding:9px 18px;font-size:.84rem">🔍 Advanced Search</a>
  </div>

  <% if (error != null) { %><div class="alert">⚠ <%= error %></div><% } %>

  <%
    int totalFlights = (flights != null) ? flights.size() : 0;
    int totalDays    = grouped.size();
    double minPrice  = Double.MAX_VALUE;
    if (flights != null) {
      for (Map<String,Object> f : flights) {
        double p = (Double) f.get("price");
        if (p < minPrice) minPrice = p;
      }
    }
    if (minPrice == Double.MAX_VALUE) minPrice = 0;
  %>

  <div class="stats-row">
    <div class="stat-card"><div class="stat-num"><%= totalFlights %></div><div class="stat-lbl">Total Flights</div></div>
    <div class="stat-card"><div class="stat-num"><%= totalDays %></div><div class="stat-lbl">Days with Flights</div></div>
    <div class="stat-card"><div class="stat-num">6</div><div class="stat-lbl">City Routes</div></div>
    <div class="stat-card"><div class="stat-num">₹<%= minPrice > 0 ? String.format("%.0f", minPrice) : "—" %></div><div class="stat-lbl">Prices From</div></div>
  </div>

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
      <input type="text" id="searchInput" placeholder="City or flight no…" oninput="applySearch(this.value)">
    </div>
  </div>

  <% if (!grouped.isEmpty()) { %>
  <div class="jump-bar" id="jumpBar">
    <% for (String dk : grouped.keySet()) {
         java.util.Date d = Date.valueOf(dk);
         String sl = new java.text.SimpleDateFormat("d MMM").format(d); %>
      <button class="jump-btn" onclick="document.getElementById('date-<%= dk %>').scrollIntoView({behavior:'smooth',block:'start'})"><%= sl %></button>
    <% } %>
  </div>
  <% } %>

  <% if (totalFlights == 0) { %>
    <div class="empty-card">
      <div class="empty-icon">🛫</div>
      <p style="color:var(--muted);font-size:1rem;margin-bottom:20px">No flights scheduled right now.</p>
      <a href="${pageContext.request.contextPath}/userDashboard" class="btn-book">Go to Dashboard</a>
    </div>
  <% } else { %>

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
          String flightId = String.valueOf(f.get("id"));
          String src      = (String) f.get("source");
          String dst      = (String) f.get("destination");
          String flightNo = (String) f.get("flight_no");
          String depTime  = timeFmt.format((Time) f.get("depart_time"));
          Time arrT       = (Time)   f.get("arrival_time");
          String arrTime  = (arrT != null) ? timeFmt.format(arrT) : "—";

          java.util.Map<String,String> codes = new java.util.HashMap<>();
          codes.put("Mumbai","BOM");codes.put("Delhi","DEL");codes.put("Bengaluru","BLR");
          codes.put("Chennai","MAA");codes.put("Kolkata","CCU");codes.put("Hyderabad","HYD");
          String srcCode = codes.getOrDefault(src, src.substring(0,Math.min(3,src.length())).toUpperCase());
          String dstCode = codes.getOrDefault(dst, dst.substring(0,Math.min(3,dst.length())).toUpperCase());

          long depMs = ((Time)f.get("depart_time")).getTime();
          long arrMs = (arrT != null) ? arrT.getTime() : depMs;
          long diff  = arrMs - depMs; if (diff < 0) diff += 86400000L;
          long dh = diff/3600000, dm = (diff%3600000)/60000;
          String dur = dh > 0 ? dh+"h "+dm+"m" : dm+"m";

          double pct = (double) seatsAvail / seatsTotal;
          String badgeCls, badgeTxt;
          if      (seatsAvail == 0) { badgeCls="badge-full"; badgeTxt="⛔ Sold Out"; }
          else if (pct < 0.15)      { badgeCls="badge-warn"; badgeTxt="🔥 "+seatsAvail+" left"; }
          else                      { badgeCls="badge-ok";   badgeTxt="✅ "+seatsAvail+" seats"; }
      %>
      <div class="flight-card"
           style="animation:fadeUp .4s ease both <%= globalIdx * 0.04 %>s"
           data-src="<%= src.toLowerCase() %>"
           data-dst="<%= dst.toLowerCase() %>"
           data-fno="<%= flightNo.toLowerCase() %>">

        <div class="fc-body">
          <div>
            <div class="city-code"><%= srcCode %></div>
            <div class="city-name"><%= src %></div>
            <div class="city-time"><%= depTime %></div>
          </div>
          <div class="flight-center">
            <div class="flight-no-lbl"><%= flightNo %></div>
            <div class="flight-line"><div class="fl-bar"></div><span class="fl-icon">✈</span><div class="fl-bar"></div></div>
            <div class="flight-dur"><%= dur %> · Non-stop</div>
          </div>
          <div>
            <div class="city-code"><%= dstCode %></div>
            <div class="city-name"><%= dst %></div>
            <div class="city-time"><%= arrTime %></div>
          </div>
          <div></div>
          <div class="price-block">
            <div class="price-big">₹<%= String.format("%.0f", price) %></div>
            <div class="price-sub">per seat</div>
            <% if (seatsAvail > 0) { %>
              <a href="${pageContext.request.contextPath}/bookFlight?flightId=<%= flightId %>" class="btn-book">Book Now →</a>
            <% } else { %>
              <span class="btn-book sold">Sold Out</span>
            <% } %>
          </div>
        </div>

        <div class="fc-footer">
          <span class="fmeta">✈ <%= flightNo %></span>
          <span class="fmeta"><%= src %> → <%= dst %></span>
          <span class="fmeta">⏱ <%= dur %></span>
          <span class="badge <%= badgeCls %>"><%= badgeTxt %></span>
        </div>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>
  <% } %>
</div>

<button id="backTop" onclick="window.scrollTo({top:0,behavior:'smooth'})">↑</button>

<script>
// Theme
(function(){const s=localStorage.getItem('asTheme')||'light';document.documentElement.setAttribute('data-theme',s);document.getElementById('themeToggle').textContent=s==='dark'?'☀️':'🌙';})();
document.getElementById('themeToggle').addEventListener('click',function(){const c=document.documentElement.getAttribute('data-theme');const n=c==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('asTheme',n);this.textContent=n==='dark'?'☀️':'🌙';});
// Hamburger
const ham=document.getElementById('hamburger'),mn=document.getElementById('mobileNav');
ham.addEventListener('click',()=>mn.classList.toggle('open'));
// Back to top
const bt=document.getElementById('backTop');
window.addEventListener('scroll',()=>bt.classList.toggle('show',scrollY>400));
// Route filter
let activeFilter='all';
function setFilter(v,btn){
  activeFilter=v;
  document.querySelectorAll('.filter-btn').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  applyFilters();
}
function applySearch(v){applyFilters();}
function applyFilters(){
  const q=document.getElementById('searchInput').value.toLowerCase();
  document.querySelectorAll('.flight-card').forEach(card=>{
    const src=card.dataset.src||'',dst=card.dataset.dst||'',fno=card.dataset.fno||'';
    const routeMatch=activeFilter==='all'||src.includes(activeFilter.toLowerCase())||dst.includes(activeFilter.toLowerCase());
    const searchMatch=!q||src.includes(q)||dst.includes(q)||fno.includes(q);
    card.style.display=(routeMatch&&searchMatch)?'':'none';
  });
  // Hide empty date sections
  document.querySelectorAll('.date-section').forEach(ds=>{
    const visible=[...ds.querySelectorAll('.flight-card')].some(c=>c.style.display!=='none');
    ds.style.display=visible?'':'none';
  });
}
</script>
</body>
</html>
