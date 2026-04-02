<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    Boolean searched = (Boolean) request.getAttribute("searched");
    String error     = (String)  request.getAttribute("error");
    String srcParam  = request.getParameter("source")      != null ? request.getParameter("source") : "";
    String dstParam  = request.getParameter("destination")  != null ? request.getParameter("destination") : "";
    String datParam  = request.getParameter("departDate")   != null ? request.getParameter("departDate") : "";
    String seatsParam= request.getParameter("numSeats")     != null ? request.getParameter("numSeats") : "1";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Flights – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
    <style>
        .search-bar {
            background: rgba(10,18,45,.7); border: 1px solid var(--border-glow);
            border-radius: 14px; padding: 22px 24px; margin-bottom: 28px;
            display: grid; grid-template-columns: 1fr 1fr 1fr 1fr auto; gap: 14px; align-items: end;
            animation: fadeUp .4s ease both;
        }
        @media (max-width: 800px) { .search-bar { grid-template-columns: 1fr 1fr; } .search-bar .btn { grid-column: 1/-1; } }
        .search-bar input, .search-bar select {
            width: 100%; padding: 11px 14px;
            background: rgba(255,255,255,.05); border: 1px solid var(--border);
            border-radius: 10px; color: var(--white);
            font-family: 'DM Sans',sans-serif; font-size: .875rem; outline: none;
            transition: border-color .2s;
        }
        .search-bar input:focus, .search-bar select:focus { border-color: var(--sky-glow); }
        .search-bar input::placeholder { color: rgba(255,255,255,.25); }
        .search-bar select option { background: var(--ink-3); }
        .search-bar label { display: block; font-size: .75rem; font-weight: 700; text-transform: uppercase; letter-spacing: .05em; color: var(--muted); margin-bottom: 7px; }
        .results-count { font-size: .875rem; color: var(--muted); margin-bottom: 16px; animation: fadeIn .4s ease both; }
        .results-count strong { color: var(--sky-glow); }
    </style>
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
        <a href="userDashboard"  class="nav-link">Dashboard</a>
        <a href="userBookings"   class="nav-link">My Bookings</a>
        <a href="profile"        class="nav-link">Profile</a>
        <a href="logout"         class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <h1 class="page-title">🔍 Search Flights</h1>
            <p class="page-subtitle">Find available flights for your journey</p>
        </div>
    </div>

    <!-- SEARCH BAR -->
    <form action="searchFlights" method="get" class="search-bar">
        <div>
            <label>From</label>
            <input type="text" name="source" value="<%= srcParam %>" placeholder="e.g. Mumbai" required>
        </div>
        <div>
            <label>To</label>
            <input type="text" name="destination" value="<%= dstParam %>" placeholder="e.g. Delhi" required>
        </div>
        <div>
            <label>Date</label>
            <input type="date" name="departDate" value="<%= datParam %>" required>
        </div>
        <div>
            <label>Passengers</label>
            <select name="numSeats">
                <% for (int i = 1; i <= 9; i++) { %><option value="<%= i %>" <%= seatsParam.equals(String.valueOf(i)) ? "selected" : "" %>><%= i %> Passenger<%= i > 1 ? "s" : "" %></option><% } %>
            </select>
        </div>
        <button type="submit" class="btn btn-blue" style="white-space:nowrap;">🔍 Search</button>
    </form>

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

    <% if (Boolean.TRUE.equals(searched)) { %>
        <% if (flights == null || flights.isEmpty()) { %>
            <div class="card" style="padding:60px 24px;text-align:center;">
                <div class="empty-icon">✈</div>
                <h3 style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:rgba(255,255,255,.6);">No flights found</h3>
                <p style="color:var(--muted);font-size:.875rem;margin-top:8px;">Try a different date or route</p>
            </div>
        <% } else { %>
            <p class="results-count"><strong><%= flights.size() %></strong> flight<%= flights.size() != 1 ? "s" : "" %> found for <%= srcParam %> → <%= dstParam %> on <%= datParam %></p>
            <% int fi = 0; for (Map<String,Object> f : flights) { fi++; %>
            <div class="flight-card" style="margin-bottom:14px;animation-delay:<%= fi * 0.07 %>s">
                <div class="flight-card-header">
                    <span class="flight-number">✈ <%= f.get("flight_no") %></span>
                    <div>
                        <div class="flight-price" style="color:var(--gold);">₹<%= String.format("%,.0f", (Double)f.get("price")) %></div>
                        <div style="font-size:.75rem;color:var(--muted);text-align:right;">per person</div>
                    </div>
                </div>
                <div class="flight-route">
                    <div>
                        <div class="city-code"><%= ((String)f.get("source")).substring(0,3).toUpperCase() %></div>
                        <div class="city-name"><%= f.get("source") %></div>
                        <div style="font-size:.8rem;color:var(--sky-glow);margin-top:4px;"><%= f.get("depart_time") %></div>
                    </div>
                    <div class="flight-line"></div>
                    <div style="text-align:right;">
                        <div class="city-code"><%= ((String)f.get("destination")).substring(0,3).toUpperCase() %></div>
                        <div class="city-name"><%= f.get("destination") %></div>
                        <div style="font-size:.8rem;color:var(--sky-glow);margin-top:4px;"><%= f.get("arrival_time") %></div>
                    </div>
                </div>
                <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-top:4px;">
                    <div class="flight-meta">
                        <span>📅 <%= f.get("depart_date") %></span>
                        <span>💺 <%= f.get("seats_available") %> seats left</span>
                        <span>👥 <%= seatsParam %> passenger<%= Integer.parseInt(seatsParam) > 1 ? "s" : "" %></span>
                    </div>
                    <div style="display:flex;align-items:center;gap:12px;">
                        <div style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:800;color:var(--gold);">
                            Total: ₹<%= String.format("%,.0f", (Double)f.get("price") * Integer.parseInt(seatsParam)) %>
                        </div>
                        <form action="bookFlight" method="post" style="margin:0;">
                            <input type="hidden" name="flightId"  value="<%= f.get("id") %>">
                            <input type="hidden" name="numSeats"  value="<%= seatsParam %>">
                            <button type="submit" class="btn btn-blue btn-sm">Book Now →</button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        <% } %>
    <% } %>
</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
document.querySelector('input[name="departDate"]').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
