<%@ page import="java.util.List, java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String userName    = (String) session.getAttribute("userName");
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    String numSeatsStr = request.getParameter("numSeats");
    int numSeats = 1;
    try { if (numSeatsStr != null) numSeats = Integer.parseInt(numSeatsStr); } catch(Exception ignored){}
    String error = (String) request.getAttribute("error");
    String src   = request.getParameter("source");      if (src == null) src = "";
    String dst   = request.getParameter("destination"); if (dst == null) dst = "";
    String srcE  = HtmlUtils.e(src);
    String dstE  = HtmlUtils.e(dst);
    String firstName = userName != null ? (userName.contains(" ") ? userName.split(" ")[0] : userName) : "Guest";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%= srcE.isEmpty() ? "Search Results" : srcE + " → " + dstE %> – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
/* ── RESULTS PAGE ─────────────────────────────────── */
/* Route header badge */
.route-header-badge {
  display: inline-flex; align-items: center; gap: 10px;
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-full);
  padding: 8px 20px;
  font-family: 'Fraunces',serif;
  font-size: 1rem; font-weight: 700; color: var(--text);
  box-shadow: var(--shadow-sm);
  margin-bottom: 6px;
}
.route-header-badge .arrow { color: var(--primary); font-size: 1.1rem; }

/* Result card */
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
  transform: scaleY(0); transform-origin: top; transition: transform var(--trans);
}
.fc:hover { transform: translateY(-3px); box-shadow: var(--shadow-lg); border-color: var(--border-2); }
.fc:hover::before { transform: scaleY(1); }

.fc-body {
  padding: 22px 26px;
  display: grid;
  grid-template-columns: 1fr auto 1fr auto;
  align-items: center; gap: 20px;
}
.fc-city {
  font-family: 'Fraunces',serif;
  font-size: 1.65rem; font-weight: 800;
  letter-spacing: -.04em; color: var(--text); line-height: 1;
}
.fc-city-lbl { font-size: .75rem; color: var(--text-muted); margin-top: 3px; }
.fc-city-time { font-size: .85rem; color: var(--primary); font-weight: 600; margin-top: 5px; }
.fc-mid {
  display: flex; flex-direction: column;
  align-items: center; gap: 5px; padding: 0 10px;
}
.fc-fno {
  font-size: .68rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .09em; color: var(--text-faint);
}
.fc-line { display: flex; align-items: center; gap: 5px; width: 90px; }
.fc-line-bar { flex: 1; height: 1px; background: var(--border-2); }
.fc-plane { color: var(--primary); font-size: 1.05rem; }
.fc-price-col { text-align: right; }
.fc-price {
  font-family: 'Fraunces',serif;
  font-size: 1.55rem; font-weight: 800;
  color: var(--primary); letter-spacing: -.03em; line-height: 1;
}
.fc-price-sub { font-size: .72rem; color: var(--text-faint); margin: 4px 0 10px; }
.btn-book {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 8px 18px;
  background: var(--grad-brand); color: #fff; border: none;
  border-radius: var(--radius-sm); cursor: pointer;
  font-family: 'Inter',sans-serif;
  font-size: .84rem; font-weight: 700;
  box-shadow: 0 3px 12px var(--primary-glow-lg);
  transition: transform var(--trans-fast), box-shadow var(--trans-fast);
  white-space: nowrap;
}
.btn-book:hover { transform: translateY(-2px); box-shadow: 0 6px 18px var(--primary-glow-lg); }
.badge-full {
  display: inline-flex; align-items: center;
  background: var(--danger-bg); color: var(--danger);
  border: 1px solid var(--danger-border);
  padding: 5px 14px; border-radius: var(--radius-full);
  font-size: .76rem; font-weight: 700;
}
.fc-footer {
  padding: 10px 26px;
  background: var(--surface-1); border-top: 1px solid var(--border);
  display: flex; align-items: center; gap: 20px; flex-wrap: wrap;
}
.fc-meta { font-size: .75rem; color: var(--text-muted); display: flex; align-items: center; gap: 5px; }
.fc-meta-total { margin-left: auto; font-size: .82rem; font-weight: 700; color: var(--primary); }

/* Seats warning */
.seats-warn { color: var(--danger); font-size: .75rem; font-weight: 600; margin-top: 5px; }

/* No results */
.no-results {
  background: var(--surface-0); border: 1px solid var(--border);
  border-radius: var(--radius-xl); padding: 64px 24px; text-align: center;
  box-shadow: var(--shadow); animation: fadeUp .4s var(--ease) both;
}
.no-results-icon { font-size: 3.5rem; opacity: .35; margin-bottom: 16px; animation: floatAnim 3s ease-in-out infinite; }
.no-results h3   { font-family:'Fraunces',serif; font-size:1.2rem; font-weight:800; margin-bottom:10px; }
.no-results p    { color: var(--text-muted); font-size:.9rem; margin-bottom:20px; line-height:1.6; }

@media(max-width:700px){
  .fc-body { grid-template-columns: 1fr 1fr; }
  .fc-mid  { display: none; }
}
@media(max-width:480px){
  .fc-body { grid-template-columns: 1fr; gap: 14px; }
  .fc-price-col { text-align: left; }
}
</style>
</head>
<body>

<!-- NAVBAR -->
<%@ include file="/Views/common/navbar.jsp" %>
<div class="mobile-nav" id="as-mobile-nav">
  <% if (userName != null) { %>
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link"><i class="ph-bold ph-house"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights" class="nav-link"><i class="ph-bold ph-magnifying-glass"></i> Search Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link"><i class="ph-bold ph-ticket"></i> My Bookings</a>
    <hr style="border:none;border-top:1px solid var(--border);margin:6px 0">
    <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger">↩ Logout</a>
  <% } else { %>
    <a href="${pageContext.request.contextPath}/login" class="nav-link">Sign In</a>
  <% } %>
</div>

<!-- PAGE CONTENT -->
<div class="page-wrapper">

  <!-- Page header -->
  <div class="page-header fade-up">
    <div>
      <% if (!src.isEmpty() && !dst.isEmpty()) { %>
        <div class="route-header-badge">
          <span><%= srcE %></span>
          <span class="arrow"><i class="ph-bold ph-airplane-tilt"></i></span>
          <span><%= dstE %></span>
        </div>
      <% } %>
      <div class="page-subheading">
        <% if (flights != null) { %>
          <strong><%= flights.size() %></strong> flight<%= flights.size() != 1 ? "s" : "" %> found
          &nbsp;·&nbsp; <%= numSeats %> seat<%= numSeats > 1 ? "s" : "" %> requested
        <% } %>
      </div>
    </div>
    <a href="javascript:history.back()" class="btn btn-ghost btn-sm">← Modify Search</a>
  </div>

  <% if (error != null) { %>
    <div class="alert alert-error"><span><i class="ph-bold ph-warning"></i></span><span><%= error %></span></div>
  <% } %>

  <% if (flights == null || flights.isEmpty()) { %>
    <div class="no-results">
      <div class="no-results-icon"><i class="ph-bold ph-airplane-takeoff"></i></div>
      <h3>No flights available</h3>
      <p>We couldn't find any flights for <strong><%= srcE %> → <%= dstE %></strong>.<br>Try adjusting the date, route, or number of passengers.</p>
      <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-primary">Try Another Search</a>
    </div>
  <% } else { %>

    <%-- Flight cards (all form actions/inputs preserved exactly) --%>
    <% int fi=0; for (Map<String,Object> f : flights) {
       fi++;
       int seatsAvail = (Integer) f.get("seats_available");
       double pricePer = (Double) f.get("price");
       double total = pricePer * numSeats;
    %>
    <div class="fc" style="animation-delay:<%= fi * 0.07 %>s">
      <div class="fc-body">

        <!-- Origin -->
        <div>
          <div class="fc-city"><%= f.get("source") %></div>
          <div class="fc-city-lbl"><i class="ph-bold ph-airplane-takeoff"></i> Departure</div>
          <div class="fc-city-time"><%= f.get("depart_time") %></div>
        </div>

        <!-- Route line -->
        <div class="fc-mid">
          <div class="fc-fno"><%= f.get("flight_no") %></div>
          <div class="fc-line">
            <div class="fc-line-bar"></div>
            <div class="fc-plane"><i class="ph-bold ph-airplane-tilt"></i></div>
            <div class="fc-line-bar"></div>
          </div>
        </div>

        <!-- Destination -->
        <div>
          <div class="fc-city"><%= f.get("destination") %></div>
          <div class="fc-city-lbl"><i class="ph-bold ph-airplane-landing"></i> Arrival</div>
          <div class="fc-city-time"><%= f.get("arrival_time") != null ? f.get("arrival_time") : "—" %></div>
        </div>

        <!-- Price + CTA -->
        <div class="fc-price-col">
          <div class="fc-price">₹<%= String.format("%.0f", pricePer) %></div>
          <div class="fc-price-sub">per seat · <%= seatsAvail %> left</div>
          <% if (seatsAvail <= 5 && seatsAvail > 0) { %>
            <div class="seats-warn"><i class="ph-bold ph-warning"></i> Only <%= seatsAvail %> seats left!</div>
          <% } %>
          <% if (userName == null) { %>
            <a href="${pageContext.request.contextPath}/login" class="btn-book">Login to Book</a>
          <% } else if (seatsAvail >= numSeats) { %>
            <form action="${pageContext.request.contextPath}/bookFlight" method="post" style="display:inline;margin-top:8px">
              <input type="hidden" name="flightId" value="<%= f.get("id") %>">
              <input type="hidden" name="numSeats" value="<%= numSeats %>">
              <button type="submit" class="btn-book">Book Now →</button>
            </form>
          <% } else { %>
            <span class="badge-full">✗ Full</span>
          <% } %>
        </div>
      </div>

      <!-- Footer meta -->
      <div class="fc-footer">
        <span class="fc-meta"><i class="ph-bold ph-calendar-blank"></i> <%= f.get("depart_date") %></span>
        <span class="fc-meta"><i class="ph-bold ph-armchair"></i> <%= seatsAvail %> seats available</span>
        <span class="fc-meta-total">
          Total for <%= numSeats %> seat<%= numSeats > 1 ? "s" : "" %>: ₹<%= String.format("%.0f", total) %>
        </span>
      </div>
    </div>
    <% } %>

  <% } %>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<%@ include file="/Views/common/Footer.jsp" %>
</body>
</html>
