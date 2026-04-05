<%@ page import="java.util.List, java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    String numSeatsStr = request.getParameter("numSeats");
    int numSeats = 1;
    try { if (numSeatsStr != null) numSeats = Integer.parseInt(numSeatsStr); } catch(Exception ignored){}
    String error = (String) request.getAttribute("error");
    String src = request.getParameter("source");
    String dst = request.getParameter("destination");
    if (src == null) src = "";
    if (dst == null) dst = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <% if (userName != null) { %>
            <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">Dashboard</a>
            <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">My Bookings</a>
            <a href="${pageContext.request.contextPath}/logout"        class="nav-link btn-danger">Logout</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/login" class="nav-link btn-primary">Sign In</a>
        <% } %>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <h1 class="page-title">
                <% if (!src.isEmpty() && !dst.isEmpty()) { %><%= src %> → <%= dst %><% } else { %>Available Flights<% } %>
            </h1>
            <p class="page-subtitle">
                <% if (flights != null) { %><%= flights.size() %> flight(s) found &middot; <%= numSeats %> seat(s)<% } %>
            </p>
        </div>
        <a href="javascript:history.back()" class="btn btn-ghost">← Modify Search</a>
    </div>

    <% if (error != null) { %>
        <div class="alert alert-error">⚠ <%= error %></div>
    <% } %>

    <% if (flights == null || flights.isEmpty()) { %>
        <div class="card card-pad" style="text-align:center;padding:60px 20px;">
            <div style="font-size:48px;margin-bottom:16px">🛫</div>
            <p style="color:var(--muted);font-size:1rem;margin-bottom:20px;">No flights found for the selected route and date.</p>
            <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-blue">Try Another Search</a>
        </div>
    <% } else { %>
    <div style="display:flex;flex-direction:column;gap:14px;">
    <% for (Map<String,Object> f : flights) {
           int seatsAvail = (Integer) f.get("seats_available"); %>
        <div class="card card-top-line">
            <div style="padding:20px 24px;display:grid;grid-template-columns:1fr auto 1fr auto;align-items:center;gap:20px;">
                <div>
                    <div style="font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;"><%= f.get("source") %></div>
                    <div style="font-size:.8rem;color:var(--muted);margin-top:2px;">🛫 <%= f.get("depart_time") %></div>
                </div>
                <div style="text-align:center;">
                    <div style="font-size:.7rem;color:var(--sky-glow);font-weight:700;text-transform:uppercase;letter-spacing:.8px;margin-bottom:6px;"><%= f.get("flight_no") %></div>
                    <div style="display:flex;align-items:center;gap:6px;">
                        <div style="width:40px;height:1px;background:rgba(255,255,255,.15);"></div>
                        <span style="color:var(--sky-glow);font-size:18px;">✈</span>
                        <div style="width:40px;height:1px;background:rgba(255,255,255,.15);"></div>
                    </div>
                </div>
                <div>
                    <div style="font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;"><%= f.get("destination") %></div>
                    <div style="font-size:.8rem;color:var(--muted);margin-top:2px;">🛬 <%= f.get("arrival_time") != null ? f.get("arrival_time") : "—" %></div>
                </div>
                <div style="text-align:right;">
                    <div style="font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;color:var(--white);">₹<%= String.format("%.0f", (Double) f.get("price")) %></div>
                    <div style="font-size:.72rem;color:var(--muted);margin-bottom:10px;">per seat · <%= seatsAvail %> left</div>
                    <% if (userName == null) { %>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-blue btn-sm">Login to Book</a>
                    <% } else if (seatsAvail >= numSeats) { %>
                        <form action="${pageContext.request.contextPath}/bookFlight" method="post" style="display:inline;">
                            <input type="hidden" name="flightId" value="<%= f.get("id") %>">
                            <input type="hidden" name="numSeats" value="<%= numSeats %>">
                            <button type="submit" class="btn btn-blue btn-sm">Book Now →</button>
                        </form>
                    <% } else { %>
                        <span class="badge badge-cancelled">Full</span>
                    <% } %>
                </div>
            </div>
            <div style="padding:10px 24px;border-top:1px solid var(--border-2);display:flex;gap:20px;">
                <span style="font-size:.75rem;color:var(--muted);">📅 <%= f.get("depart_date") %></span>
                <span style="font-size:.75rem;color:var(--muted);">💺 <%= seatsAvail %> seats available</span>
            </div>
        </div>
    <% } %>
    </div>
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
</script>
</body>
</html>
