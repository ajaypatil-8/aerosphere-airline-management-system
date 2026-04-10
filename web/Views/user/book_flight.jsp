<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.skyconnect.util.DBConnection, com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    String flightIdStr = request.getParameter("flightId");
    String numSeatsStr = request.getParameter("numSeats");
    if (flightIdStr == null) { response.sendRedirect(request.getContextPath() + "/searchFlights"); return; }

    int flightId;
    int numSeats;
    try {
        flightId = Integer.parseInt(flightIdStr);
        numSeats = (numSeatsStr != null) ? Integer.parseInt(numSeatsStr) : 1;
        if (numSeats < 1) numSeats = 1;
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/searchFlights"); return;
    }
    String csrfToken = CsrfUtil.getToken(request);

    String flightNo="", source="", destination="", departDate="", departTime="", arrivalTime="";
    double price = 0;
    int seatsAvailable = 0;

    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM flights WHERE id = ?");
        ps.setInt(1, flightId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            flightNo       = rs.getString("flight_no");
            source         = rs.getString("source");
            destination    = rs.getString("destination");
            departDate     = rs.getString("depart_date");
            departTime     = rs.getString("depart_time");
            arrivalTime    = rs.getString("arrival_time");
            price          = rs.getDouble("price");
            seatsAvailable = rs.getInt("seats_available");
        }
    } catch (Exception e) { e.printStackTrace(); }

    double totalAmount = price * numSeats;
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Confirm Booking – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
/* ── BOOK FLIGHT PAGE ────────────────────────────────── */
.booking-wrapper { max-width: 680px; margin: 0 auto; padding: 32px 24px; }

/* Route strip */
.route-strip {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 24px 28px;
  margin-bottom: 20px;
  position: relative; overflow: hidden;
  box-shadow: var(--shadow);
  display: flex; align-items: center; justify-content: space-between;
  gap: 12px;
  animation: fadeUp .5s var(--ease) .1s both;
}
.route-strip::before {
  content: '';
  position: absolute; top: 0; left: 0; right: 0; height: 3px;
  background: var(--grad-brand);
}
.route-strip-bg {
  position: absolute; right: 16px; top: 50%;
  transform: translateY(-50%); font-size: 5rem;
  opacity: .04; pointer-events: none;
  animation: floatAnim 5s ease-in-out infinite;
}
.rs-city {
  font-family: 'Syne', sans-serif;
  font-size: 1.75rem; font-weight: 800;
  letter-spacing: -.04em; color: var(--text); line-height: 1;
}
.rs-label { font-size: .72rem; color: var(--text-muted); margin-top: 4px; font-weight: 600; text-transform: uppercase; letter-spacing: .06em; }
.rs-time  { font-size: .85rem; color: var(--primary); font-weight: 600; margin-top: 5px; }
.rs-icon  { font-size: 1.8rem; color: var(--primary); flex-shrink: 0; animation: floatAnim 3s ease-in-out infinite; }

/* Flight info grid */
.info-grid {
  display: grid; grid-template-columns: 1fr 1fr;
  gap: 10px; margin-bottom: 20px;
  animation: fadeUp .5s var(--ease) .15s both;
}
.info-tile {
  background: var(--surface-1);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 13px 16px;
  transition: border-color var(--trans-fast);
}
.info-tile:hover { border-color: var(--primary); }
.info-tile-label {
  font-size: .68rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .08em;
  color: var(--text-faint); margin-bottom: 5px;
}
.info-tile-val { font-size: .9rem; font-weight: 600; color: var(--text); }
.info-tile-val.highlight { color: var(--primary); }

/* Warning */
.alert-warn {
  background: var(--warning-bg); border: 1px solid var(--warning-border);
  color: #92400E; border-radius: var(--radius); padding: 12px 16px;
  font-size: .875rem; font-weight: 500;
  display: flex; align-items: center; gap: 8px; margin-bottom: 16px;
}
[data-theme="dark"] .alert-warn { color: #FCD34D; }

/* Fare summary */
.fare-card {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  overflow: hidden; margin-bottom: 24px;
  box-shadow: var(--shadow);
  animation: fadeUp .5s var(--ease) .2s both;
}
.fare-head {
  padding: 14px 20px;
  background: var(--surface-1); border-bottom: 1px solid var(--border);
  font-family: 'Syne', sans-serif;
  font-size: .85rem; font-weight: 700; letter-spacing: -.01em;
  display: flex; align-items: center; gap: 8px;
}
.fare-body { padding: 4px 0; }
.fare-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 13px 20px; font-size: .9rem;
  border-bottom: 1px solid var(--border);
}
.fare-row:last-child { border-bottom: none; }
.fare-row-label { color: var(--text-muted); }
.fare-row-val   { font-weight: 600; color: var(--text); }
.fare-total-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 16px 20px;
  border-top: 2px solid var(--primary);
  background: var(--primary-glow);
}
.fare-total-label {
  font-family: 'Syne', sans-serif;
  font-size: 1rem; font-weight: 800; color: var(--text);
}
.fare-total-val {
  font-family: 'Syne', sans-serif;
  font-size: 1.4rem; font-weight: 800;
  color: var(--primary); letter-spacing: -.03em;
}

/* Form section */
.form-section {
  background: var(--surface-0);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  overflow: hidden; box-shadow: var(--shadow);
  animation: fadeUp .5s var(--ease) .25s both;
}
.form-section-head {
  padding: 14px 20px; background: var(--surface-1);
  border-bottom: 1px solid var(--border);
  font-family: 'Syne', sans-serif;
  font-size: .85rem; font-weight: 700;
}
.form-section-body { padding: 20px; }
.seat-field { margin-bottom: 0; }
.seat-field label {
  display: block; font-size: .72rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: .07em;
  color: var(--text-muted); margin-bottom: 8px;
}
.seat-input-wrap { position: relative; }
.seat-input-icon {
  position: absolute; left: 13px; top: 50%; transform: translateY(-50%);
  font-size: 14px; color: var(--text-faint); pointer-events: none;
  transition: color var(--trans-fast);
}
.seat-field:focus-within .seat-input-icon { color: var(--primary); }
.seat-input-wrap input {
  width: 100%; padding: 12px 14px 12px 40px;
  background: var(--surface-1); border: 1.5px solid var(--border-2);
  border-radius: var(--radius); color: var(--text);
  font-family: 'DM Sans', sans-serif; font-size: .95rem;
  outline: none;
  transition: border-color var(--trans-fast), box-shadow var(--trans-fast), background var(--trans-fast);
}
.seat-input-wrap input:focus {
  border-color: var(--primary);
  background: var(--surface-0);
  box-shadow: 0 0 0 3px var(--primary-glow);
}

/* Confirm button */
.btn-confirm {
  width: 100%; padding: 15px; margin-top: 16px;
  background: var(--grad-brand); border: none;
  border-radius: var(--radius); color: #fff;
  font-family: 'DM Sans', sans-serif;
  font-size: 1rem; font-weight: 700; cursor: pointer;
  box-shadow: 0 6px 20px var(--primary-glow-lg);
  display: flex; align-items: center; justify-content: center; gap: 8px;
  transition: transform var(--trans-fast), box-shadow var(--trans-fast);
  position: relative; overflow: hidden;
}
.btn-confirm:hover { transform: translateY(-2px); box-shadow: 0 10px 28px var(--primary-glow-lg); }
.btn-confirm:active { transform: translateY(0); }
.btn-confirm:disabled { opacity: .5; cursor: not-allowed; transform: none; }

.back-link {
  display: block; text-align: center; margin-top: 14px;
  font-size: .85rem; color: var(--text-muted); text-decoration: none;
  transition: color var(--trans-fast);
}
.back-link:hover { color: var(--primary); }

@media(max-width:560px){
  .route-strip { flex-direction: column; align-items: flex-start; }
  .info-grid   { grid-template-columns: 1fr; }
  .booking-wrapper { padding: 20px 16px; }
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
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights" class="nav-link">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">🎫 Bookings</a>
  </div>
  <div class="nav-right">
    <button class="theme-toggle" id="themeToggle" onclick="AS.toggleTheme()">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="user-pill">
      <div class="user-avatar"><%= firstName.charAt(0) %></div>
      <span><%= firstName %></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">↩ Logout</a>
  </div>
</nav>

<div class="booking-wrapper">

  <!-- STEP PROGRESS -->
  <div class="steps fade-up">
    <div class="step done">
      <div class="step-circle">✓</div>
      <div class="step-label">Search</div>
    </div>
    <div class="step-line done"></div>
    <div class="step active">
      <div class="step-circle">2</div>
      <div class="step-label">Confirm</div>
    </div>
    <div class="step-line"></div>
    <div class="step">
      <div class="step-circle">3</div>
      <div class="step-label">Passengers</div>
    </div>
    <div class="step-line"></div>
    <div class="step">
      <div class="step-circle">4</div>
      <div class="step-label">Payment</div>
    </div>
    <div class="step-line"></div>
    <div class="step">
      <div class="step-circle">5</div>
      <div class="step-label">Ticket</div>
    </div>
  </div>

  <!-- ROUTE CARD -->
  <div class="route-strip">
    <div class="route-strip-bg">✈</div>
    <div>
      <div class="rs-city"><%= source %></div>
      <div class="rs-label">Origin</div>
      <div class="rs-time">🛫 <%= departTime %></div>
    </div>
    <div class="rs-icon">✈</div>
    <div style="text-align:right">
      <div class="rs-city"><%= destination %></div>
      <div class="rs-label">Destination</div>
      <div class="rs-time">🛬 <%= (arrivalTime != null && !arrivalTime.isEmpty()) ? arrivalTime : "—" %></div>
    </div>
  </div>

  <!-- FLIGHT INFO GRID -->
  <div class="info-grid">
    <div class="info-tile">
      <div class="info-tile-label">Flight No.</div>
      <div class="info-tile-val highlight"><%= flightNo %></div>
    </div>
    <div class="info-tile">
      <div class="info-tile-label">Departure Date</div>
      <div class="info-tile-val"><%= departDate %></div>
    </div>
    <div class="info-tile">
      <div class="info-tile-label">Departure Time</div>
      <div class="info-tile-val"><%= departTime %></div>
    </div>
    <div class="info-tile">
      <div class="info-tile-label">Arrival Time</div>
      <div class="info-tile-val"><%= (arrivalTime != null && !arrivalTime.isEmpty()) ? arrivalTime : "—" %></div>
    </div>
    <div class="info-tile">
      <div class="info-tile-label">Available Seats</div>
      <div class="info-tile-val <%= seatsAvailable <= 5 ? "highlight" : "" %>"><%= seatsAvailable %><%= seatsAvailable <= 5 ? " ⚠" : "" %></div>
    </div>
    <div class="info-tile">
      <div class="info-tile-label">Price per Seat</div>
      <div class="info-tile-val highlight">₹ <%= String.format("%.2f", price) %></div>
    </div>
  </div>

  <% if (seatsAvailable < numSeats) { %>
    <div class="alert-warn">
      <span>⚠</span>
      <span>Only <strong><%= seatsAvailable %></strong> seat(s) available. Please reduce your seat count below.</span>
    </div>
  <% } %>

  <!-- FARE SUMMARY -->
  <div class="fare-card">
    <div class="fare-head">💰 Fare Summary</div>
    <div class="fare-body">
      <div class="fare-row">
        <span class="fare-row-label">Price per Seat</span>
        <span class="fare-row-val">₹ <%= String.format("%.2f", price) %></span>
      </div>
      <div class="fare-row">
        <span class="fare-row-label">Number of Seats</span>
        <span class="fare-row-val" id="seatsDisplay"><%= numSeats %></span>
      </div>
    </div>
    <div class="fare-total-row">
      <span class="fare-total-label">Total Amount</span>
      <span class="fare-total-val" id="totalDisplay">₹ <%= String.format("%.2f", totalAmount) %></span>
    </div>
  </div>

  <!-- BOOKING FORM (action, method, all name attrs preserved exactly) -->
  <div class="form-section">
    <div class="form-section-head">✈ Confirm Your Booking</div>
    <div class="form-section-body">
      <form action="${pageContext.request.contextPath}/bookFlight" method="post" id="bookForm">
        <input type="hidden" name="_csrf"     value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="flightId"  value="<%= flightId %>">

        <div class="seat-field">
          <label>Number of Seats</label>
          <div class="seat-input-wrap">
            <span class="seat-input-icon">💺</span>
            <input type="number" name="numSeats"
                   min="1" max="<%= seatsAvailable %>"
                   value="<%= numSeats %>" required
                   oninput="updateTotal(this.value)">
          </div>
        </div>

        <button type="submit" class="btn-confirm" id="btnConfirm"
                <%= seatsAvailable == 0 ? "disabled" : "" %>>
          <span>✅ Confirm Booking</span><span>→</span>
        </button>
      </form>
    </div>
  </div>

  <a href="javascript:history.back()" class="back-link">← Back to Results</a>

</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
  var pricePerSeat = <%= price %>;

  function updateTotal(seats) {
    var n = Math.max(1, parseInt(seats) || 1);
    document.getElementById('seatsDisplay').textContent = n;
    document.getElementById('totalDisplay').textContent = '₹ ' + (pricePerSeat * n).toFixed(2);
  }

  // Ripple on confirm button
  document.getElementById('btnConfirm').addEventListener('click', function(e) {
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
