<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    Integer totalFlights  = (Integer) request.getAttribute("totalFlights");
    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer totalUsers    = (Integer) request.getAttribute("totalUsers");
    Double  totalRevenue  = (Double)  request.getAttribute("totalRevenue");
    Integer pendingRefunds= (Integer) request.getAttribute("pendingRefunds");
    List<com.skyconnect.servlet.AdminDashboardServlet.RecentBooking> recentBookings =
        (List<com.skyconnect.servlet.AdminDashboardServlet.RecentBooking>) request.getAttribute("recentBookings");

    if (totalFlights  == null) totalFlights  = 0;
    if (totalBookings == null) totalBookings = 0;
    if (totalUsers    == null) totalUsers    = 0;
    if (totalRevenue  == null) totalRevenue  = 0.0;
    if (pendingRefunds== null) pendingRefunds= 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .admin-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 32px; }
        .stat-card {
            background: rgba(13,20,39,.7); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 24px 20px;
            animation: fadeUp .5s ease both;
            transition: border-color .2s, transform .2s;
            position: relative; overflow: hidden;
        }
        .stat-card::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(0,87,255,.08) 0%, transparent 70%);
            pointer-events: none;
        }
        .stat-card:hover { border-color: var(--border-glow); transform: translateY(-3px); }
        .stat-icon { font-size: 2rem; margin-bottom: 12px; }
        .stat-label { font-size: .75rem; font-weight: 700; text-transform: uppercase; letter-spacing: .06em; color: var(--muted); }
        .stat-value { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; color: var(--white); margin-top: 4px; }
        .stat-value.gold { color: var(--gold); }
        .stat-value.danger { color: var(--danger); }

        .quick-actions { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 14px; margin-bottom: 32px; }
        .qa-btn {
            display: flex; align-items: center; gap: 12px;
            background: rgba(13,20,39,.7); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 18px 20px;
            text-decoration: none; color: var(--white);
            font-weight: 600; font-size: .9rem;
            transition: all .2s; animation: fadeUp .5s ease both;
        }
        .qa-btn:hover { border-color: var(--sky-glow); background: rgba(0,87,255,.12); transform: translateY(-2px); }
        .qa-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; flex-shrink: 0; }
        .qa-icon.blue   { background: rgba(0,87,255,.2); }
        .qa-icon.gold   { background: rgba(255,184,0,.15); }
        .qa-icon.green  { background: rgba(16,185,129,.15); }
        .qa-icon.purple { background: rgba(139,92,246,.15); }

        .recent-table { width: 100%; border-collapse: collapse; }
        .recent-table thead th {
            font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .06em;
            color: var(--muted); padding: 10px 16px; border-bottom: 1px solid var(--border);
            text-align: left;
        }
        .recent-table tbody td { padding: 13px 16px; border-bottom: 1px solid var(--border); font-size: .875rem; }
        .recent-table tbody tr:hover td { background: rgba(255,255,255,.03); }
        .recent-table tbody tr:last-child td { border-bottom: none; }

        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: .72rem; font-weight: 700; }
        .badge-paid     { background: rgba(16,185,129,.15); color: #10B981; }
        .badge-pending  { background: rgba(245,158,11,.15); color: #F59E0B; }
        .badge-cancelled{ background: rgba(239,68,68,.15);  color: #EF4444; }
        .badge-booked   { background: rgba(139,92,246,.15); color: #8B5CF6; }
        .badge-refunded { background: rgba(0,87,255,.15);   color: var(--sky-glow); }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="adminDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span> <span style="font-size:.7rem;color:var(--gold);font-weight:600;margin-left:6px;vertical-align:middle;">ADMIN</span></span>
    </a>
    <div class="nav-links">
        <a href="adminDashboard"   class="nav-link active">Dashboard</a>
        <a href="adminFlights"     class="nav-link">Flights</a>
        <a href="adminBookings"    class="nav-link">Bookings</a>
        <a href="adminRefunds"     class="nav-link">Refunds</a>
        <a href="reports.jsp"      class="nav-link">Reports</a>
        <a href="logout"           class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation: fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">🛠 Admin Dashboard</h1>
            <p class="page-subtitle">Welcome back, <%= userName %> — here's what's happening today</p>
        </div>
        <a href="admin_add_flight.jsp" class="btn btn-blue">+ Add New Flight</a>
    </div>

    <!-- STAT CARDS -->
    <div class="admin-grid">
        <div class="stat-card" style="animation-delay:.05s">
            <div class="stat-icon">✈</div>
            <div class="stat-label">Total Flights</div>
            <div class="stat-value"><%= totalFlights %></div>
        </div>
        <div class="stat-card" style="animation-delay:.10s">
            <div class="stat-icon">📋</div>
            <div class="stat-label">Total Bookings</div>
            <div class="stat-value"><%= totalBookings %></div>
        </div>
        <div class="stat-card" style="animation-delay:.15s">
            <div class="stat-icon">👥</div>
            <div class="stat-label">Registered Users</div>
            <div class="stat-value"><%= totalUsers %></div>
        </div>
        <div class="stat-card" style="animation-delay:.20s">
            <div class="stat-icon">💰</div>
            <div class="stat-label">Total Revenue</div>
            <div class="stat-value gold">₹<%= String.format("%,.0f", totalRevenue) %></div>
        </div>
        <div class="stat-card" style="animation-delay:.25s">
            <div class="stat-icon">⏳</div>
            <div class="stat-label">Pending Refunds</div>
            <div class="stat-value <%= pendingRefunds > 0 ? "danger" : "" %>"><%= pendingRefunds %></div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="card" style="margin-bottom:28px;animation:fadeUp .5s .3s ease both;opacity:0;animation-fill-mode:forwards;">
        <div class="card-header">
            <span class="card-title">⚡ Quick Actions</span>
        </div>
        <div style="padding: 20px;">
            <div class="quick-actions">
                <a href="admin_add_flight.jsp" class="qa-btn" style="animation-delay:.35s">
                    <div class="qa-icon blue">➕</div>
                    <div><div style="font-weight:700;">Add Flight</div><div style="font-size:.75rem;color:var(--muted);">Schedule new route</div></div>
                </a>
                <a href="adminFlights" class="qa-btn" style="animation-delay:.40s">
                    <div class="qa-icon gold">✈</div>
                    <div><div style="font-weight:700;">Manage Flights</div><div style="font-size:.75rem;color:var(--muted);">Edit or remove flights</div></div>
                </a>
                <a href="adminBookings" class="qa-btn" style="animation-delay:.45s">
                    <div class="qa-icon green">📋</div>
                    <div><div style="font-weight:700;">View Bookings</div><div style="font-size:.75rem;color:var(--muted);">All booking records</div></div>
                </a>
                <a href="adminRefunds" class="qa-btn" style="animation-delay:.50s">
                    <div class="qa-icon purple">💸</div>
                    <div><div style="font-weight:700;">Refund Requests</div><div style="font-size:.75rem;color:var(--muted);"><%= pendingRefunds %> pending</div></div>
                </a>
                <a href="reports.jsp" class="qa-btn" style="animation-delay:.55s">
                    <div class="qa-icon blue">📊</div>
                    <div><div style="font-weight:700;">Reports</div><div style="font-size:.75rem;color:var(--muted);">Analytics & exports</div></div>
                </a>
            </div>
        </div>
    </div>

    <!-- RECENT BOOKINGS -->
    <div class="card" style="animation:fadeUp .5s .4s ease both;opacity:0;animation-fill-mode:forwards;">
        <div class="card-header">
            <span class="card-title">🕐 Recent Bookings</span>
            <a href="adminBookings" class="btn btn-ghost btn-sm">View All →</a>
        </div>
        <div style="overflow-x:auto;">
            <% if (recentBookings == null || recentBookings.isEmpty()) { %>
                <div style="text-align:center;padding:60px 24px;color:var(--muted);">
                    <div style="font-size:3rem;margin-bottom:12px;">📋</div>
                    <p>No bookings yet</p>
                </div>
            <% } else { %>
            <table class="recent-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Passenger</th>
                        <th>Flight</th>
                        <th>Route</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
<% int ri = 0; for (com.skyconnect.servlet.AdminDashboardServlet.RecentBooking b : recentBookings) { ri++; %>

<tr style="animation:fadeUp .4s <%= ri * 0.06 %>s ease both;opacity:0;animation-fill-mode:forwards;">

    <td>#<%= b.bookingId %></td>

    <td><%= b.userName %></td>

    <td><%= b.flightNo %></td>

    <td>
        <span style="color:var(--gold)">
            <%= b.source.length() >= 3 ? b.source.substring(0,3).toUpperCase() : b.source %>
        </span>
        →
        <span style="color:var(--sky-glow)">
            <%= b.destination.length() >= 3 ? b.destination.substring(0,3).toUpperCase() : b.destination %>
        </span>
    </td>

    <td><%= b.bookingDate %></td>

    <td>₹<%= String.format("%,.0f", b.totalAmount) %></td>

    <td>
        <span class="badge badge-<%= b.paymentStatus.toLowerCase() %>">
            <%= b.paymentStatus %>
        </span>
    </td>

    <td>
        <a href="viewInvoice?bookingId=<%= b.bookingId %>" class="btn btn-ghost btn-sm">
            Invoice
        </a>
    </td>

</tr>

<% } %>
</tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 100; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2.5 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*6}s;--op:${.2+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
