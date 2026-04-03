<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.skyconnect.util.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    String flightIdStr = request.getParameter("flightId");
    String numSeatsStr = request.getParameter("numSeats");
    if (flightIdStr == null) { response.sendRedirect("search_flights.jsp"); return; }

    int flightId = Integer.parseInt(flightIdStr);
    int numSeats = (numSeatsStr != null) ? Integer.parseInt(numSeatsStr) : 1;

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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Booking – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body>

<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="search_flights.jsp" class="nav-link">Search</a>
        <a href="userBookings" class="nav-link">My Bookings</a>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper narrow">

    <!-- STEPS -->
    <div class="steps">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">2</div><div class="step-label">Confirm</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">3</div><div class="step-label">Passengers</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
    </div>

    <div class="card card-top-line">
        <div class="card-pad">
            <h2 style="font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;margin-bottom:22px;">✈ Confirm Your Booking</h2>

            <!-- ROUTE STRIP -->
            <div class="route-strip" style="border-radius:12px;margin-bottom:20px;">
                <div class="route-city">
                    <div class="city"><%= source %></div>
                    <div class="label">Origin</div>
                </div>
                <div class="route-arrow">✈</div>
                <div class="route-city">
                    <div class="city"><%= destination %></div>
                    <div class="label">Destination</div>
                </div>
            </div>

            <!-- INFO GRID -->
            <div class="info-grid" style="margin-bottom:20px;">
                <div class="info-item">
                    <label>Flight No.</label>
                    <span style="color:var(--sky-glow)"><%= flightNo %></span>
                </div>
                <div class="info-item">
                    <label>Date</label>
                    <span><%= departDate %></span>
                </div>
                <div class="info-item">
                    <label>Departure</label>
                    <span><%= departTime %></span>
                </div>
                <div class="info-item">
                    <label>Arrival</label>
                    <span><%= (arrivalTime != null && !arrivalTime.isEmpty()) ? arrivalTime : "—" %></span>
                </div>
                <div class="info-item">
                    <label>Seats Available</label>
                    <span><%= seatsAvailable %></span>
                </div>
                <div class="info-item">
                    <label>Price per Seat</label>
                    <span>₹ <%= String.format("%.2f", price) %></span>
                </div>
            </div>

            <% if (seatsAvailable < numSeats) { %>
            <div class="alert alert-warning">⚠ Only <%= seatsAvailable %> seat(s) available. Please reduce seat count.</div>
            <% } %>

            <!-- FARE SUMMARY -->
            <div class="fare-box">
                <div class="section-label" style="margin-bottom:12px;">💰 Fare Summary</div>
                <div class="fare-row">
                    <span>Price per Seat</span>
                    <span>₹ <%= String.format("%.2f", price) %></span>
                </div>
                <div class="fare-row">
                    <span>Number of Seats</span>
                    <span id="seatsDisplay"><%= numSeats %></span>
                </div>
                <div class="fare-row total">
                    <span>Total Amount</span>
                    <span id="totalDisplay">₹ <%= String.format("%.2f", totalAmount) %></span>
                </div>
            </div>

            <hr class="divider">

            <form action="bookFlight" method="post">
                <input type="hidden" name="flightId" value="<%= flightId %>">
                <div class="field" style="margin-bottom:18px;">
                    <label>Number of Seats</label>
                    <div class="field-wrap">
                        <span class="field-icon">💺</span>
                        <input type="number" name="numSeats"
                               min="1" max="<%= seatsAvailable %>"
                               value="<%= numSeats %>" required
                               oninput="updateTotal(this.value)">
                    </div>
                </div>
                <button type="submit" class="btn btn-blue btn-lg" <%= seatsAvailable == 0 ? "disabled style='opacity:.5;cursor:not-allowed'" : "" %>>
                    ✅ Confirm Booking →
                </button>
            </form>

            <a href="javascript:history.back()" style="display:block;text-align:center;margin-top:14px;font-size:.85rem;color:var(--muted);text-decoration:none;">← Back to Results</a>
        </div>
    </div>

</div>

<script>
const pricePerSeat = <%= price %>;
function updateTotal(seats) {
    const n = Math.max(1, parseInt(seats) || 1);
    document.getElementById('seatsDisplay').textContent = n;
    document.getElementById('totalDisplay').textContent = '₹ ' + (pricePerSeat * n).toFixed(2);
}
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
