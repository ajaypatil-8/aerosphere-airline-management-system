<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect("login.jsp"); return; }
    List<com.skyconnect.servlet.AdminBookingsServlet.BookingRow> bookings =
        (List<com.skyconnect.servlet.AdminBookingsServlet.BookingRow>) request.getAttribute("bookings");
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess");
    session.removeAttribute("cancelError");

    int total = 0, paid = 0, pending = 0, cancelled = 0;
    double revenue = 0;
    if (bookings != null) for (var b : bookings) {
        total++;
        if ("PAID".equalsIgnoreCase(b.paymentStatus)) { paid++; revenue += b.totalAmount; }
        else if ("PENDING".equalsIgnoreCase(b.paymentStatus)) pending++;
        if ("CANCELLED".equalsIgnoreCase(b.status)) cancelled++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings – SkyConnect Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
    <style>
        .stats-row { display:grid; grid-template-columns:repeat(auto-fit,minmax(150px,1fr)); gap:14px; margin-bottom:24px; }
        .s-chip {
            background:rgba(13,20,39,.7); border:1px solid var(--border);
            border-radius:var(--radius); padding:18px 20px;
            animation:fadeUp .4s ease both; transition:border-color .2s;
        }
        .s-chip:hover { border-color:var(--border-glow); }
        .s-chip-label { font-size:.72rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); }
        .s-chip-value { font-family:'Syne',sans-serif; font-size:1.8rem; font-weight:800; margin-top:4px; }

        .filter-row {
            display:flex; gap:12px; flex-wrap:wrap; align-items:center;
            margin-bottom:20px; animation:fadeUp .4s .2s ease both; opacity:0; animation-fill-mode:forwards;
        }
        .filter-row input, .filter-row select {
            background:rgba(13,20,39,.7); border:1px solid var(--border);
            border-radius:10px; color:var(--white);
            padding:10px 14px; font-family:'DM Sans',sans-serif;
            font-size:.875rem; outline:none; transition:border-color .2s;
        }
        .filter-row input { flex:1; min-width:220px; }
        .filter-row input:focus, .filter-row select:focus { border-color:var(--sky-glow); }
        .filter-row input::placeholder { color:rgba(255,255,255,.25); }
        .filter-row select option { background:var(--ink-3); }

        .bookings-table { width:100%; border-collapse:collapse; }
        .bookings-table thead th {
            font-size:.72rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em;
            color:var(--muted); padding:12px 16px;
            border-bottom:1px solid var(--border); text-align:left;
        }
        .bookings-table tbody td { padding:13px 16px; border-bottom:1px solid var(--border); font-size:.875rem; }
        .bookings-table tbody tr:hover td { background:rgba(255,255,255,.025); }
        .bookings-table tbody tr:last-child td { border-bottom:none; }

        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.72rem; font-weight:700; }
        .badge-paid      { background:rgba(16,185,129,.15); color:#10B981; }
        .badge-pending   { background:rgba(245,158,11,.15);  color:#F59E0B; }
        .badge-cancelled { background:rgba(239,68,68,.15);   color:#EF4444; }
        .badge-booked    { background:rgba(139,92,246,.15);  color:#8B5CF6; }
        .badge-refunded  { background:rgba(0,87,255,.15);    color:var(--sky-glow); }

        .action-group { display:flex; gap:7px; flex-wrap:wrap; }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="adminDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span> <span style="font-size:.7rem;color:var(--gold);font-weight:600;margin-left:6px;">ADMIN</span></span>
    </a>
    <div class="nav-links">
        <a href="adminDashboard" class="nav-link">Dashboard</a>
        <a href="adminFlights"   class="nav-link">Flights</a>
        <a href="adminBookings"  class="nav-link active">Bookings</a>
        <a href="adminRefunds"   class="nav-link">Refunds</a>
        <a href="reports.jsp"    class="nav-link">Reports</a>
        <a href="logout"         class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">📋 Manage Bookings</h1>
            <p class="page-subtitle">All bookings across every flight</p>
        </div>
    </div>

    <% if (cancelError   != null) { %><div class="alert alert-error">⚠ <%= cancelError %></div><% } %>
    <% if (cancelSuccess != null) { %><div class="alert alert-success">✔ <%= cancelSuccess %></div><% } %>

    <!-- STATS -->
    <div class="stats-row">
        <div class="s-chip" style="animation-delay:.05s">
            <div class="s-chip-label">Total Bookings</div>
            <div class="s-chip-value"><%= total %></div>
        </div>
        <div class="s-chip" style="animation-delay:.10s">
            <div class="s-chip-label">Paid</div>
            <div class="s-chip-value" style="color:#10B981;"><%= paid %></div>
        </div>
        <div class="s-chip" style="animation-delay:.15s">
            <div class="s-chip-label">Pending</div>
            <div class="s-chip-value" style="color:#F59E0B;"><%= pending %></div>
        </div>
        <div class="s-chip" style="animation-delay:.20s">
            <div class="s-chip-label">Cancelled</div>
            <div class="s-chip-value" style="color:#EF4444;"><%= cancelled %></div>
        </div>
        <div class="s-chip" style="animation-delay:.25s">
            <div class="s-chip-label">Revenue (Paid)</div>
            <div class="s-chip-value" style="color:var(--gold);">₹<%= String.format("%,.0f", revenue) %></div>
        </div>
    </div>

    <!-- FILTER -->
    <div class="filter-row">
        <input type="text" id="searchInput" placeholder="🔍  Search by name, flight, route…">
        <select id="statusFilter">
            <option value="">All Status</option>
            <option value="paid">Paid</option>
            <option value="pending">Pending</option>
            <option value="cancelled">Cancelled</option>
        </select>
    </div>

    <!-- TABLE -->
    <div class="card" style="animation:fadeUp .4s .3s ease both;opacity:0;animation-fill-mode:forwards;">
        <div class="card-header">
            <span class="card-title">All Bookings</span>
            <span style="font-size:.8rem;color:var(--muted);"><%= total %> records</span>
        </div>
        <div style="overflow-x:auto;">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div style="text-align:center;padding:80px 24px;color:var(--muted);">
                <div style="font-size:4rem;margin-bottom:16px;">📋</div>
                <p style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:rgba(255,255,255,.5);">No bookings yet</p>
            </div>
        <% } else { %>
        <table class="bookings-table" id="bookingsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Booking ID</th>
                    <th>Passenger</th>
                    <th>Flight</th>
                    <th>Route</th>
                    <th>Seats</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Payment</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% int bi = 0; for (com.skyconnect.servlet.AdminBookingsServlet.BookingRow b : bookings) { bi++; %>
            <tr data-name="<%= b.userName.toLowerCase() %>" data-flight="<%= b.flightNo.toLowerCase() %>"
                data-src="<%= b.source.toLowerCase() %>" data-dst="<%= b.destination.toLowerCase() %>"
                data-status="<%= b.paymentStatus.toLowerCase() %>"
                style="animation:fadeUp .4s <%= bi * 0.04 %>s ease both;opacity:0;animation-fill-mode:forwards;">
                <td style="color:var(--muted);font-size:.8rem;"><%= bi %></td>
                <td style="font-family:'Syne',sans-serif;font-size:.85rem;color:var(--sky-glow);">#<%= b.bookingId %></td>
                <td style="font-weight:500;"><%= b.userName %></td>
                <td style="color:var(--sky-glow);font-weight:600;">✈ <%= b.flightNo %></td>
                <td>
                    <span style="color:var(--gold);font-weight:700;font-size:.85rem;"><%= b.source.length()>=3?b.source.substring(0,3).toUpperCase():b.source %></span>
                    <span style="color:var(--muted);margin:0 4px;">→</span>
                    <span style="color:var(--sky-glow);font-weight:700;font-size:.85rem;"><%= b.destination.length()>=3?b.destination.substring(0,3).toUpperCase():b.destination %></span>
                </td>
                <td style="text-align:center;"><%= b.numSeats %></td>
                <td style="font-weight:700;color:var(--gold);">₹<%= String.format("%,.0f", b.totalAmount) %></td>
                <td style="color:var(--muted);font-size:.82rem;"><%= b.bookingDate %></td>
                <td><span class="badge badge-<%= b.paymentStatus.toLowerCase() %>"><%= b.paymentStatus %></span></td>
                <td><span class="badge badge-<%= b.status.toLowerCase() %>"><%= b.status %></span></td>
                <td>
                    <div class="action-group">
                        <a href="viewInvoice?bookingId=<%= b.bookingId %>" class="btn btn-ghost btn-sm">📄 Invoice</a>
                        <% if (!"CANCELLED".equalsIgnoreCase(b.status)) { %>
                        <form action="cancelBooking" method="post" style="margin:0;" onsubmit="return confirm('Cancel booking #<%= b.bookingId %>?')">
                            <input type="hidden" name="bookingId" value="<%= b.bookingId %>">
                            <button type="submit" class="btn btn-danger btn-sm">✕ Cancel</button>
                        </form>
                        <% } %>
                    </div>
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
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.2+Math.random()*.45};`;
    s.appendChild(el);
}
const searchInput  = document.getElementById('searchInput');
const statusFilter = document.getElementById('statusFilter');
function filterTable() {
    const q  = searchInput.value.toLowerCase().trim();
    const st = statusFilter.value;
    document.querySelectorAll('#bookingsTable tbody tr').forEach(row => {
        const matchQ  = !q  || row.dataset.name.includes(q) || row.dataset.flight.includes(q) || row.dataset.src.includes(q) || row.dataset.dst.includes(q);
        const matchSt = !st || row.dataset.status === st;
        row.style.display = matchQ && matchSt ? '' : 'none';
    });
}
searchInput.addEventListener('input', filterTable);
statusFilter.addEventListener('change', filterTable);
</script>
</body>
</html>
