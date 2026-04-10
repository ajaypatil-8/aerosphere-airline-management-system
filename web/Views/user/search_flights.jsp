<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    Boolean searched  = (Boolean) request.getAttribute("searched");
    String error      = (String)  request.getAttribute("error");
    String srcParam   = request.getParameter("source")      != null ? request.getParameter("source")      : "";
    String dstParam   = request.getParameter("destination") != null ? request.getParameter("destination")  : "";
    String datParam   = request.getParameter("departDate")  != null ? request.getParameter("departDate")   : "";
    String seatsParam = request.getParameter("numSeats")    != null ? request.getParameter("numSeats")     : "1";
    int numSeatsInt = 1;
    try { numSeatsInt = Integer.parseInt(seatsParam); if (numSeatsInt < 1) numSeatsInt = 1; }
    catch (Exception ignored) { numSeatsInt = 1; seatsParam = "1"; }
    String srcParamE  = HtmlUtils.e(srcParam);
    String dstParamE  = HtmlUtils.e(dstParam);
    String datParamE  = HtmlUtils.e(datParam);
    String firstName  = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Search Flights – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
/* ── SEARCH PAGE SPECIFIC ─────────────────────────────── */

/* Hero search bar */
.search-hero {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-xl);
  padding: 28px 32px;
  margin-bottom: 28px;
  box-shadow: var(--shadow-md);
  position: relative; overflow: hidden;
}
.search-hero::before {
  content: '';
  position: absolute; top: 0; left: 0; right: 0; height: 3px;
  background: var(--grad-brand);
}
.search-hero-head {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 20px; flex-wrap: wrap; gap: 10px;
}
.search-hero-title {
  font-family: 'Syne', sans-serif;
  font-size: 1.05rem; font-weight: 700;
  display: flex; align-items: center; gap: 8px;
}
.search-form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr auto;
  gap: 14px; align-items: end;
}
.sf-field label {
  display: block; font-size: .7rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .07em;
  color: var(--text-muted); margin-bottom: 7px;
}
.sf-field input, .sf-field select {
  width: 100%; padding: 10px 13px;
  background: var(--bg); border: 1.5px solid var(--border-2);
  border-radius: var(--radius-sm); color: var(--text);
  font-family: 'DM Sans', sans-serif; font-size: .875rem;
  outline: none;
  transition: border-color var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast);
}
.sf-field input:focus, .sf-field select:focus {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px var(--primary-glow);
  background: var(--surface-0);
}
.sf-field input::placeholder { color: var(--text-faint); }
.btn-search-main {
  padding: 11px 24px;
  background: var(--grad-brand); color: #fff; border: none;
  border-radius: var(--radius-sm);
  font-family: 'DM Sans', sans-serif;
  font-weight: 700; font-size: .9rem; cursor: pointer;
  box-shadow: 0 4px 14px var(--primary-glow-lg);
  white-space: nowrap;
  transition: transform var(--trans-fast), box-shadow var(--trans-fast);
  display: flex; align-items: center; gap: 8px;
  position: relative; overflow: hidden;
}
.btn-search-main:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px var(--primary-glow-lg);
}
.btn-search-main:active { transform: translateY(0); }

/* Swap button */
.swap-btn {
  width: 32px; height: 32px;
  background: var(--primary-glow);
  border: 1px solid rgba(14,165,233,.3);
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; font-size: 14px;
  transition: transform var(--trans-fast), background var(--trans-fast);
  color: var(--primary); align-self: flex-end; margin-bottom: 0;
}
.swap-btn:hover { background: rgba(14,165,233,.25); transform: rotate(180deg); }

/* Results header bar */
.results-meta {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 18px; flex-wrap: wrap; gap: 10px;
}
.results-summary {
  font-size: .9rem; color: var(--text-muted);
}
.results-summary strong { color: var(--primary); font-weight: 700; }
.results-count-chip {
  display: inline-flex; align-items: center; gap: 6px;
  background: var(--primary-glow);
  border: 1px solid rgba(14,165,233,.3);
  border-radius: var(--radius-full);
  padding: 5px 14px;
  font-size: .8rem; font-weight: 700; color: var(--primary);
}

/* Flight result card */
.fc {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  overflow: hidden; margin-bottom: 14px;
  box-shadow: var(--shadow);
  transition: transform var(--trans), box-shadow var(--trans), border-color var(--trans);
  animation: fadeUp .4s var(--ease) both;
  position: relative;
}
.fc::before {
  content: '';
  position: absolute; top: 0; left: 0; bottom: 0; width: 3px;
  background: var(--grad-brand);
  transform: scaleY(0); transform-origin: top;
  transition: transform var(--trans);
}
.fc:hover {
  transform: translateY(-3px);
  box-shadow: var(--shadow-lg);
  border-color: var(--border-2);
}
.fc:hover::before { transform: scaleY(1); }

/* Card body — route + price */
.fc-body {
  padding: 22px 26px;
  display: grid;
  grid-template-columns: 1fr auto 1fr 1fr auto;
  align-items: center;
  gap: 16px;
}

/* City block */
.fc-city-code {
  font-family: 'Syne', sans-serif;
  font-size: 1.7rem; font-weight: 800;
  letter-spacing: -.04em; color: var(--text);
  line-height: 1;
}
.fc-city-name { font-size: .75rem; color: var(--text-muted); margin-top: 3px; }
.fc-city-time {
  font-size: .85rem; color: var(--primary);
  font-weight: 600; margin-top: 5px;
}

/* Flight centre — route line */
.fc-route {
  display: flex; flex-direction: column;
  align-items: center; gap: 5px; padding: 0 8px;
}
.fc-fno {
  font-size: .68rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .08em;
  color: var(--text-faint);
}
.fc-line {
  display: flex; align-items: center; gap: 5px; width: 90px;
}
.fc-line-bar { flex: 1; height: 1px; background: var(--border-2); }
.fc-plane { color: var(--primary); font-size: 1.05rem; }

/* Seats badge */
.fc-seats {
  text-align: center;
}
.seats-num {
  font-family: 'Syne', sans-serif;
  font-size: 1.3rem; font-weight: 800;
  color: var(--text); line-height: 1;
}
.seats-label { font-size: .7rem; color: var(--text-muted); margin-top: 3px; }
.seats-low { color: var(--danger); }

/* Price block */
.fc-price { text-align: right; }
.fc-price-big {
  font-family: 'Syne', sans-serif;
  font-size: 1.55rem; font-weight: 800;
  color: var(--primary); letter-spacing: -.03em; line-height: 1;
}
.fc-price-sub { font-size: .72rem; color: var(--text-faint); margin: 4px 0 12px; }
.fc-total {
  font-size: .8rem; font-weight: 700;
  color: var(--text-2); margin-bottom: 10px;
}
.fc-total span { color: var(--primary); }

/* Book button */
.btn-book {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 8px 18px;
  background: var(--grad-brand); color: #fff; border: none;
  border-radius: var(--radius-sm);
  font-family: 'DM Sans', sans-serif;
  font-size: .84rem; font-weight: 700; cursor: pointer;
  box-shadow: 0 3px 12px var(--primary-glow-lg);
  transition: transform var(--trans-fast), box-shadow var(--trans-fast);
  white-space: nowrap;
}
.btn-book:hover { transform: translateY(-2px); box-shadow: 0 6px 18px var(--primary-glow-lg); }
.badge-full {
  display: inline-flex; align-items: center; gap: 4px;
  background: var(--danger-bg); color: var(--danger);
  border: 1px solid var(--danger-border);
  padding: 5px 14px; border-radius: var(--radius-full);
  font-size: .76rem; font-weight: 700;
}

/* Footer meta bar */
.fc-footer {
  padding: 10px 26px;
  background: var(--surface-1);
  border-top: 1px solid var(--border);
  display: flex; align-items: center; gap: 20px;
  flex-wrap: wrap;
}
.fc-meta {
  font-size: .75rem; color: var(--text-muted);
  display: flex; align-items: center; gap: 5px;
}
.fc-meta-total {
  margin-left: auto;
  font-size: .82rem; font-weight: 700; color: var(--primary);
}

/* Empty / no-results */
.no-results {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-xl);
  padding: 64px 24px;
  text-align: center;
  box-shadow: var(--shadow);
  animation: fadeUp .4s var(--ease) both;
}
.no-results-icon { font-size: 3.5rem; opacity: .35; margin-bottom: 16px; animation: floatAnim 3s ease-in-out infinite; }
.no-results h3 { font-family:'Syne',sans-serif; font-size:1.2rem; font-weight:800; margin-bottom:10px; }
.no-results p  { color: var(--text-muted); font-size:.9rem; margin-bottom: 20px; }

/* Page header strip */
.page-topbar {
  display: flex; align-items: flex-start;
  justify-content: space-between; flex-wrap: wrap;
  gap: 12px; margin-bottom: 24px;
}
.page-topbar-title {
  font-family: 'Syne', sans-serif;
  font-size: 1.6rem; font-weight: 800;
  letter-spacing: -.04em; margin-bottom: 4px;
}
.page-topbar-sub { color: var(--text-muted); font-size: .9rem; }

@media(max-width:860px) {
  .search-form-grid { grid-template-columns: 1fr 1fr; }
  .search-form-grid .btn-col { grid-column: 1/-1; }
  .fc-body { grid-template-columns: 1fr auto 1fr; }
  .fc-route, .fc-seats { display: none; }
}
@media(max-width:560px) {
  .search-form-grid { grid-template-columns: 1fr; }
  .fc-body { grid-template-columns: 1fr; gap: 12px; }
  .fc-price { text-align: left; }
  .fc-footer { gap: 10px; }
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" role="navigation">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
    <div class="brand-icon">✈</div>
    <span class="brand-name">Aero<span>Sphere</span></span>
  </a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link active">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refunds</a>
    <a href="${pageContext.request.contextPath}/profile"           class="nav-link">👤 Profile</a>
  </div>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="user-pill">
      <div class="user-avatar"><%= firstName.charAt(0) %></div>
      <span><%= firstName %></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">↩ Logout</a>
    <button class="hamburger" id="as-hamburger"><span></span><span></span><span></span></button>
  </div>
</nav>
<div class="mobile-nav" id="as-mobile-nav">
  <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">🏠 Dashboard</a>
  <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link active">🔍 Search Flights</a>
  <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link">🎫 My Bookings</a>
  <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">💸 Refund History</a>
  <a href="${pageContext.request.contextPath}/profile"           class="nav-link">👤 Profile</a>
  <hr style="border:none;border-top:1px solid var(--border);margin:6px 0">
  <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger">↩ Logout</a>
</div>

<!-- PAGE -->
<div class="page-wrapper">

  <!-- Page heading -->
  <div class="page-topbar fade-up">
    <div>
      <div class="page-topbar-title">🔍 Search <span style="color:var(--primary)">Flights</span></div>
      <div class="page-topbar-sub">Find and book the best flights for your journey</div>
    </div>
  </div>

  <!-- SEARCH FORM (all name/action attrs preserved exactly) -->
  <div class="search-hero fade-up d1">
    <div class="search-hero-head">
      <div class="search-hero-title">✈ Enter your travel details</div>
      <% if (Boolean.TRUE.equals(searched) && flights != null) { %>
        <div class="results-count-chip">
          ✈ <%= flights.size() %> flight<%= flights.size() != 1 ? "s" : "" %> found
        </div>
      <% } %>
    </div>
    <form action="${pageContext.request.contextPath}/searchFlights" method="get" class="search-form-grid" id="searchForm">
      <div class="sf-field">
        <label>From</label>
        <input type="text" name="source" value="<%= srcParamE %>" id="srcInput"
               placeholder="e.g. Mumbai" required autocomplete="off">
      </div>

      <%-- Swap button sits between From and To (cosmetic only, handled by JS) --%>
      <div style="display:flex;align-items:flex-end;padding-bottom:1px">
        <button type="button" class="swap-btn" onclick="swapCities()" title="Swap cities">⇄</button>
      </div>

      <div class="sf-field">
        <label>To</label>
        <input type="text" name="destination" value="<%= dstParamE %>" id="dstInput"
               placeholder="e.g. Delhi" required autocomplete="off">
      </div>
      <div class="sf-field">
        <label>Departure Date</label>
        <input type="date" name="departDate" value="<%= datParamE %>" id="datInput" required>
      </div>
      <div class="sf-field">
        <label>Passengers</label>
        <select name="numSeats" id="seatsSelect">
          <% for (int i=1;i<=9;i++){ %>
            <option value="<%= i %>" <%= seatsParam.equals(String.valueOf(i)) ? "selected" : "" %>>
              <%= i %> Passenger<%= i>1 ? "s" : "" %>
            </option>
          <% } %>
        </select>
      </div>
      <div class="btn-col">
        <button type="submit" class="btn-search-main">
          <span>🔍</span><span>Search</span>
        </button>
      </div>
    </form>
  </div>

  <%-- Alerts --%>
  <% if (error != null) { %>
    <div class="alert alert-error"><span>⚠</span><span><%= HtmlUtils.e(error) %></span></div>
  <% } %>

  <%-- RESULTS --%>
  <% if (Boolean.TRUE.equals(searched)) { %>
    <% if (flights == null || flights.isEmpty()) { %>

      <!-- No results -->
      <div class="no-results">
        <div class="no-results-icon">🛫</div>
        <h3>No flights found</h3>
        <p>We couldn't find flights for <strong><%= srcParamE %> → <%= dstParamE %></strong> on <strong><%= datParamE %></strong>.<br>Try a different date, route, or fewer passengers.</p>
        <button onclick="document.getElementById('srcInput').focus()" class="btn btn-primary">Modify Search</button>
      </div>

    <% } else { %>

      <!-- Results meta -->
      <div class="results-meta fade-up">
        <div class="results-summary">
          Showing <strong><%= flights.size() %></strong> flight<%= flights.size() != 1 ? "s" : "" %>
          for <strong><%= srcParamE %> → <%= dstParamE %></strong>
          on <strong><%= datParamE %></strong> · <%= numSeatsInt %> passenger<%= numSeatsInt > 1 ? "s" : "" %>
        </div>
      </div>

      <%-- Flight cards (form actions/inputs preserved exactly) --%>
      <% int fi=0; for (Map<String,Object> f : flights) { fi++;
         int avail = (Integer) f.get("seats_available");
         double pricePer = (Double) f.get("price");
         double total    = pricePer * numSeatsInt;
         String srcCode  = ((String)f.get("source")).substring(0, Math.min(3,((String)f.get("source")).length())).toUpperCase();
         String dstCode  = ((String)f.get("destination")).substring(0, Math.min(3,((String)f.get("destination")).length())).toUpperCase();
      %>
      <div class="fc" style="animation-delay:<%= fi * 0.07 %>s">
        <div class="fc-body">

          <!-- Origin -->
          <div>
            <div class="fc-city-code"><%= srcCode %></div>
            <div class="fc-city-name"><%= f.get("source") %></div>
            <div class="fc-city-time">🛫 <%= f.get("depart_time") %></div>
          </div>

          <!-- Route line -->
          <div class="fc-route">
            <div class="fc-fno"><%= f.get("flight_no") %></div>
            <div class="fc-line">
              <div class="fc-line-bar"></div>
              <div class="fc-plane">✈</div>
              <div class="fc-line-bar"></div>
            </div>
          </div>

          <!-- Destination -->
          <div>
            <div class="fc-city-code"><%= dstCode %></div>
            <div class="fc-city-name"><%= f.get("destination") %></div>
            <div class="fc-city-time">🛬 <%= f.get("arrival_time") != null ? f.get("arrival_time") : "—" %></div>
          </div>

          <!-- Seats -->
          <div class="fc-seats">
            <div class="seats-num <%= avail <= 5 ? "seats-low" : "" %>"><%= avail %></div>
            <div class="seats-label">seats left<%= avail <= 5 ? " ⚠" : "" %></div>
          </div>

          <!-- Price + CTA -->
          <div class="fc-price">
            <div class="fc-price-big">₹<%= String.format("%,.0f", pricePer) %></div>
            <div class="fc-price-sub">per seat</div>
            <div class="fc-total">Total: <span>₹<%= String.format("%,.0f", total) %></span></div>
            <% if (avail >= numSeatsInt) { %>
              <form action="${pageContext.request.contextPath}/bookFlight" method="post" style="margin:0">
                <input type="hidden" name="flightId" value="<%= f.get("id") %>">
                <input type="hidden" name="numSeats" value="<%= seatsParam %>">
                <button type="submit" class="btn-book">Book Now →</button>
              </form>
            <% } else { %>
              <span class="badge-full">✗ Full</span>
            <% } %>
          </div>
        </div>

        <!-- Footer meta -->
        <div class="fc-footer">
          <span class="fc-meta">📅 <%= f.get("depart_date") %></span>
          <span class="fc-meta">💺 <%= avail %> seat<%= avail != 1 ? "s" : "" %> available</span>
          <span class="fc-meta">👥 <%= numSeatsInt %> passenger<%= numSeatsInt > 1 ? "s" : "" %></span>
          <span class="fc-meta-total">Total for <%= numSeatsInt %> seat<%= numSeatsInt > 1 ? "s" : "" %>: ₹<%= String.format("%,.0f", total) %></span>
        </div>
      </div>
      <% } %>

    <% } %>
  <% } %>

</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  // Set minimum date
  document.getElementById('datInput').min = new Date().toISOString().split('T')[0];

  // Swap cities
  function swapCities() {
    var src = document.getElementById('srcInput');
    var dst = document.getElementById('dstInput');
    var tmp = src.value;
    src.value = dst.value;
    dst.value = tmp;
    // brief flash animation
    [src, dst].forEach(function(el) {
      el.style.transition = 'background .2s';
      el.style.background = 'var(--primary-glow)';
      setTimeout(function() { el.style.background = ''; }, 300);
    });
  }

  // Ripple on search button
  document.querySelector('.btn-search-main').addEventListener('click', function(e) {
    var r = document.createElement('span');
    var rect = this.getBoundingClientRect();
    var size = Math.max(rect.width, rect.height);
    r.style.cssText = 'position:absolute;border-radius:50%;background:rgba(255,255,255,.28);width:'+size+'px;height:'+size+'px;left:'+(e.clientX-rect.left-size/2)+'px;top:'+(e.clientY-rect.top-size/2)+'px;transform:scale(0);animation:rippleAnim .6s linear;pointer-events:none';
    this.appendChild(r);
    r.addEventListener('animationend', function() { r.remove(); });
  });
</script>
</body>
</html>
