<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.servlet.UserDashboardServlet.Booking" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    String error = (String) request.getAttribute("error");
    String bookingError = (String) session.getAttribute("bookingError");
    session.removeAttribute("bookingError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .search-card {
            background: linear-gradient(135deg, rgba(0,57,200,.35), rgba(0,87,255,.15));
            border: 1px solid rgba(0,87,255,.35);
            border-radius: 18px; padding: 32px;
            backdrop-filter: blur(24px);
            margin-bottom: 28px;
            animation: fadeUp .5s ease both;
            position: relative; overflow: hidden;
        }
        .search-card::before {
            content: '✈';
            position: absolute; right: 28px; top: 50%; transform: translateY(-50%);
            font-size: 6rem; opacity: .06;
        }
        .search-title { font-family: 'Syne',sans-serif; font-size: 1.3rem; font-weight: 800; margin-bottom: 20px; }
        .search-form { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr auto; gap: 12px; align-items: end; }
        @media (max-width: 800px) { .search-form { grid-template-columns: 1fr 1fr; } .search-form .btn { grid-column: 1/-1; } }
        .search-form .field label { color: rgba(255,255,255,.6); }
        .search-form input, .search-form select {
            width: 100%; padding: 11px 14px;
            background: rgba(255,255,255,.06);
            border: 1px solid rgba(255,255,255,.12);
            border-radius: 10px; color: var(--white);
            font-family: 'DM Sans', sans-serif; font-size: .875rem; outline: none;
            transition: border-color .2s;
        }
        .search-form input:focus, .search-form select:focus { border-color: var(--sky-glow); }
        .search-form input::placeholder { color: rgba(255,255,255,.25); }
        .search-form select option { background: var(--ink-3); }
        .greeting { font-family: 'Syne',sans-serif; font-size: 1.6rem; font-weight: 800; }
        .greeting span { color: var(--sky-glow); }
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
        <a href="userDashboard" class="nav-link active">Dashboard</a>
        <a href="userBookings"  class="nav-link">My Bookings</a>
        <a href="userRefundHistory" class="nav-link">Refunds</a>
        <a href="profile"       class="nav-link">Profile</a>
        <a href="logout"        class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper">

    <div class="page-header">
        <div>
            <p class="greeting">Welcome back, <span><%= firstName %></span> 👋</p>
            <p class="page-subtitle">Search flights, manage bookings, and track your journey</p>
        </div>
    </div>

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>
    <% if (bookingError != null) { %><div class="alert alert-error">⚠ <%= bookingError %></div><% } %>

    <!-- SEARCH CARD -->
    <div class="search-card">
        <div class="search-title">✈ Search Flights</div>
        <form action="searchFlights" method="get" class="search-form">
            <div class="field">
                <label>From</label>
                <input type="text" name="source" placeholder="e.g. Mumbai" required>
            </div>
            <div class="field">
                <label>To</label>
                <input type="text" name="destination" placeholder="e.g. Delhi" required>
            </div>
            <div class="field">
                <label>Date</label>
                <input type="date" name="departDate" required>
            </div>
            <div class="field">
                <label>Passengers</label>
                <select name="numSeats">
                    <% for (int i = 1; i <= 9; i++) { %><option value="<%= i %>"><%= i %> Passenger<%= i > 1 ? "s" : "" %></option><% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-blue" style="padding:11px 24px;white-space:nowrap;">🔍 Search</button>
        </form>
    </div>

    <!-- QUICK STATS -->
    <%
        int totalB = 0, paidB = 0, cancelledB = 0;
        double amtSpent = 0;
        if (recentBookings != null) {
            totalB = recentBookings.size();
            for (Booking b : recentBookings) {
                if ("PAID".equalsIgnoreCase(b.status)) { paidB++; amtSpent += b.totalAmount; }
                if ("CANCELLED".equalsIgnoreCase(b.status)) cancelledB++;
            }
        }
    %>
    <div class="stats-grid" style="margin-bottom:28px;">
        <div class="stat-card" style="animation-delay:.05s">
            <div class="stat-icon">🎫</div>
            <div class="stat-label">Total Bookings</div>
            <div class="stat-value"><%= totalB %></div>
        </div>
        <div class="stat-card" style="animation-delay:.1s">
            <div class="stat-icon">✅</div>
            <div class="stat-label">Paid</div>
            <div class="stat-value green"><%= paidB %></div>
        </div>
        <div class="stat-card" style="animation-delay:.15s">
            <div class="stat-icon">❌</div>
            <div class="stat-label">Cancelled</div>
            <div class="stat-value red"><%= cancelledB %></div>
        </div>
        <div class="stat-card" style="animation-delay:.2s">
            <div class="stat-icon">💰</div>
            <div class="stat-label">Amount Spent</div>
            <div class="stat-value gold" style="font-size:1.3rem;">₹<%= String.format("%,.0f", amtSpent) %></div>
        </div>
    </div>

    <!-- RECENT BOOKINGS -->
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;animation:fadeUp .5s ease both;">
        <div class="section-label" style="margin:0;">Recent Bookings</div>
        <a href="userBookings" class="btn btn-ghost btn-sm">View All →</a>
    </div>

    <div class="table-wrap">
        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">✈</div>
                <h3>No bookings yet</h3>
                <p>Search for a flight above to get started!</p>
            </div>
        <% } else { %>
        <table>
            <thead><tr>
                <th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Seats</th><th>Amount</th><th>Status</th><th>Actions</th>
            </tr></thead>
            <tbody>
            <% int sno = 1; for (Booking b : recentBookings) {
                String st = b.status != null ? b.status.toLowerCase() : "booked";
                String bc = "badge-booked";
                if (st.equals("paid")) bc = "badge-paid";
                else if (st.equals("cancelled")) bc = "badge-cancelled";
                else if (st.equals("pending")) bc = "badge-pending";
            %>
            <tr style="animation:fadeUp .4s ease both;animation-delay:<%= sno * 0.05 %>s">
                <td class="sno-cell"><%= sno++ %></td>
                <td><strong><%= b.flightNo %></strong></td>
                <td>
                    <div class="route-display">
                        <span class="route-city"><%= b.source %></span>
                        <span class="route-arrow">→</span>
                        <span class="route-city"><%= b.destination %></span>
                    </div>
                </td>
                <td style="color:var(--muted);font-size:.8rem;"><%= b.bookingDate != null ? b.bookingDate.substring(0,10) : "—" %></td>
                <td style="text-align:center;"><%= b.numSeats %></td>
                <td style="font-weight:700;color:var(--sky-glow);">₹<%= String.format("%,.0f", b.totalAmount) %></td>
                <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase() + st.substring(1) %></span></td>
                <td>
                    <a href="invoice?bookingId=<%= b.bookingId %>" class="btn btn-purple-sm btn-sm">🎫 Invoice</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
// Set min date for flight search
document.querySelector('input[name="departDate"]').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
