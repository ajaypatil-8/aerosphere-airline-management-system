<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.servlet.UserDashboardServlet.Booking" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<Booking> list = (List<Booking>) request.getAttribute("recentBookings");
    String initials = userName.length() > 0 ? String.valueOf(userName.charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="index.jsp" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="search_flights.jsp" class="nav-link">Search Flights</a>
        <a href="userBookings" class="nav-link">My Bookings</a>
        <a href="userRefundHistory" class="nav-link">Refunds</a>
        <a href="profile" class="nav-link">Profile</a>
        <div class="user-pill">👤 <%= userName %></div>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<!-- PAGE -->
<div class="page-wrapper">

    <!-- WELCOME -->
    <div class="welcome-card">
        <div style="display:flex;align-items:center;gap:16px;">
            <div class="avatar-ring"><%= initials %></div>
            <div>
                <h3>Welcome back, <%= userName %> 👋</h3>
                <p>Your travel dashboard — book flights, check tickets and manage bookings.</p>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="section-label">Quick Actions</div>
    <div class="actions-grid" style="margin-bottom:32px;">
        <a href="search_flights.jsp" class="action-card" style="animation-delay:.1s">
            <div class="action-icon">🔍</div>
            <div class="action-label">Search Flights</div>
        </a>
        <a href="userBookings" class="action-card" style="animation-delay:.15s">
            <div class="action-icon">🎫</div>
            <div class="action-label">My Bookings</div>
        </a>
        <a href="profile" class="action-card" style="animation-delay:.2s">
            <div class="action-icon">👤</div>
            <div class="action-label">My Profile</div>
        </a>
        <a href="userRefundHistory" class="action-card" style="animation-delay:.25s">
            <div class="action-icon">💸</div>
            <div class="action-label">My Refunds</div>
        </a>
    </div>

    <!-- RECENT BOOKINGS TABLE -->
    <div class="card card-top-line" style="animation-delay:.2s">
        <div class="card-header">
            <span class="card-header-title">✈ Recent Bookings</span>
            <a href="userBookings" class="btn btn-ghost btn-sm">View All →</a>
        </div>
        <div class="table-wrap">
            <table class="sky-table">
                <thead>
                    <tr>
                        <th>#ID</th>
                        <th>Flight</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Seats</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Invoice</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (list == null || list.isEmpty()) {
                %>
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <div class="empty-icon">🛫</div>
                                <p>No bookings yet.</p>
                                <a href="search_flights.jsp" class="btn btn-blue btn-sm">Book Your First Flight</a>
                            </div>
                        </td>
                    </tr>
                <%
                    } else {
                        for (Booking b : list) {
                %>
                    <tr>
                        <td style="color:var(--muted);font-size:.78rem;">#<%= b.bookingId %></td>
                        <td><strong style="color:var(--sky-glow)"><%= b.flightNo %></strong></td>
                        <td><%= b.source %></td>
                        <td><%= b.destination %></td>
                        <td style="text-align:center"><%= b.numSeats %></td>
                        <td><strong>₹ <%= String.format("%.2f", b.totalAmount) %></strong></td>
                        <td>
                            <span class="badge badge-<%= b.status.toLowerCase() %>"><%= b.status %></span>
                        </td>
                        <td>
                            <a href="invoice?bookingId=<%= b.bookingId %>" class="btn btn-ghost btn-sm">🧾 View</a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 100; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
