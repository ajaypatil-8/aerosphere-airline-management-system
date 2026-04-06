<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.UserDashboardServlet.Booking" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String firstName = userName.contains(" ") ? userName.split(" ")[0] : userName;
    @SuppressWarnings("unchecked")
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    String error        = (String) request.getAttribute("error");
    String bookingError = (String) session.getAttribute("bookingError");
    session.removeAttribute("bookingError");
    int totalB=0, paidB=0, cancelledB=0; double amtSpent=0;
    if (recentBookings != null) {
        totalB = recentBookings.size();
        for (Booking b : recentBookings) {
            if ("PAID".equalsIgnoreCase(b.status)) { paidB++; amtSpent += b.totalAmount; }
            if ("CANCELLED".equalsIgnoreCase(b.status)) cancelledB++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--accent:#A7F3D0;--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px;--sidebar-w:240px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--accent:#34D399;--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
/* NAVBAR */
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}
.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover,.nav-link.active{color:var(--text);background:var(--border)}
.nav-link.active{color:var(--primary);background:var(--primary-glow)}
.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}
.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.theme-toggle:hover{border-color:var(--primary)}
/* PAGE */
.page-wrapper{max-width:1100px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;flex-wrap:wrap;gap:12px}
.greeting{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.greeting span{color:var(--primary)}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* ALERT */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.alert-success{background:var(--primary-glow);border:1px solid var(--primary);color:var(--primary)}
/* SEARCH HERO */
.search-hero{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:24px 28px;margin-bottom:24px;position:relative;overflow:hidden;box-shadow:var(--shadow)}
.search-hero::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--primary),var(--accent),var(--primary))}
.search-hero::after{content:'✈';position:absolute;right:20px;top:50%;transform:translateY(-50%);font-size:6rem;opacity:.04;pointer-events:none}
.search-title{font-weight:700;font-size:1rem;margin-bottom:18px;display:flex;align-items:center;gap:8px}
.search-grid{display:grid;grid-template-columns:1fr 1fr 1fr 1fr auto;gap:12px;align-items:end}
.search-grid label{display:block;font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:6px}
.search-grid input,.search-grid select{width:100%;padding:10px 12px;background:var(--bg);border:1.5px solid var(--border);border-radius:9px;color:var(--text);font-family:'Inter',sans-serif;font-size:.86rem;outline:none;transition:border-color .2s}
.search-grid input:focus,.search-grid select:focus{border-color:var(--primary)}
.search-grid input::placeholder{color:var(--text-muted);opacity:.6}
.btn-search{padding:10px 18px;background:var(--primary);color:#fff;border:none;border-radius:9px;font-weight:700;font-size:.86rem;cursor:pointer;transition:all .2s;box-shadow:0 3px 10px var(--primary-glow);white-space:nowrap}
.btn-search:hover{background:var(--primary-dark);transform:translateY(-1px)}
/* STATS */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.stat-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:20px;text-align:center;transition:all .3s;box-shadow:var(--shadow)}
.stat-card:hover{border-color:var(--primary);transform:translateY(-3px);box-shadow:var(--shadow-lg)}
.stat-icon{font-size:1.6rem;margin-bottom:6px}
.stat-num{font-size:1.7rem;font-weight:900;letter-spacing:-.8px}
.stat-label{color:var(--text-muted);font-size:.78rem;margin-top:4px;font-weight:500}
/* SECTION HEADER */
.section-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}
.section-title-sm{font-weight:700;font-size:1rem}
/* TABLE */
.table-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
table{width:100%;border-collapse:collapse}
thead th{padding:12px 16px;text-align:left;font-size:.74rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
tbody td{padding:12px 16px;font-size:.87rem;border-bottom:1px solid var(--border)}
tbody tr:last-child td{border-bottom:none}
tbody tr:hover{background:var(--bg)}
/* BADGES */
.badge{display:inline-flex;align-items:center;padding:3px 10px;border-radius:99px;font-size:.74rem;font-weight:700}
.badge-paid{background:rgba(16,185,129,.12);color:var(--primary);border:1px solid var(--primary)}
.badge-booked{background:rgba(59,130,246,.1);color:#2563EB;border:1px solid rgba(59,130,246,.3)}
[data-theme="dark"] .badge-booked{color:#93C5FD}
.badge-cancelled{background:rgba(239,68,68,.1);color:#DC2626;border:1px solid rgba(239,68,68,.2)}
[data-theme="dark"] .badge-cancelled{color:#FCA5A5}
/* ROUTE */
.route-cell{display:flex;align-items:center;gap:6px;font-size:.85rem}
.route-arrow{color:var(--primary);font-size:.8rem}
/* BUTTONS */
.btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;font-size:.82rem;font-weight:600;text-decoration:none;border:none;cursor:pointer;transition:all .2s}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 2px 8px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-secondary{background:var(--bg);color:var(--text);border:1px solid var(--border)}
.btn-secondary:hover{border-color:var(--primary);color:var(--primary)}
.btn-sm{padding:5px 11px;font-size:.78rem}
/* EMPTY */
.empty-state{padding:60px 20px;text-align:center}
.empty-icon{font-size:3rem;margin-bottom:14px;opacity:.4}
.empty-state h3{font-size:1.1rem;font-weight:700;margin-bottom:8px}
.empty-state p{color:var(--text-muted);font-size:.88rem}
/* AMOUNT */
.amount{color:var(--primary);font-weight:700}
/* ANIM */
.fade-up{animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.d1{animation-delay:.05s}.d2{animation-delay:.1s}.d3{animation-delay:.15s}.d4{animation-delay:.2s}
@media(max-width:800px){.search-grid{grid-template-columns:1fr 1fr}.search-grid .sb{grid-column:1/-1}.stats-grid{grid-template-columns:1fr 1fr}}
@media(max-width:500px){.stats-grid{grid-template-columns:1fr 1fr}.nav-link.nav-hide{display:none}}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"      class="nav-link active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/userBookings"       class="nav-link nav-hide">My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory"  class="nav-link nav-hide">Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"            class="nav-link nav-hide">Profile</a>
        <a href="${pageContext.request.contextPath}/logout"             class="nav-link btn-danger">Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">

    <!-- HEADER -->
    <div class="page-header fade-up">
        <div>
            <div class="greeting">Welcome back, <span><%= firstName %></span> 👋</div>
            <div class="page-subtitle">Search flights, manage bookings, and track your journey</div>
        </div>
    </div>

    <% if (error != null)        { %><div class="alert alert-error">⚠ <%= error %></div><% } %>
    <% if (bookingError != null) { %><div class="alert alert-error">⚠ <%= bookingError %></div><% } %>

    <!-- SEARCH -->
    <div class="search-hero fade-up d1">
        <div class="search-title">✈ Search Flights</div>
        <form action="${pageContext.request.contextPath}/searchFlights" method="get" class="search-grid">
            <div><label>From</label><input type="text" name="source" placeholder="e.g. Mumbai" required></div>
            <div><label>To</label><input type="text" name="destination" placeholder="e.g. Delhi" required></div>
            <div><label>Date</label><input type="date" name="departDate" required></div>
            <div><label>Passengers</label>
                <select name="numSeats"><% for(int i=1;i<=9;i++){%><option value="<%= i %>"><%= i %> Passenger<%= i>1?"s":"" %></option><%}%></select>
            </div>
            <div class="sb"><button type="submit" class="btn-search">🔍 Search</button></div>
        </form>
    </div>

    <!-- STATS -->
    <div class="stats-grid">
        <div class="stat-card fade-up d1"><div class="stat-icon">🎫</div><div class="stat-num"><%= totalB %></div><div class="stat-label">Total Bookings</div></div>
        <div class="stat-card fade-up d2"><div class="stat-icon">✅</div><div class="stat-num" style="color:var(--primary)"><%= paidB %></div><div class="stat-label">Paid</div></div>
        <div class="stat-card fade-up d3"><div class="stat-icon">❌</div><div class="stat-num" style="color:#DC2626"><%= cancelledB %></div><div class="stat-label">Cancelled</div></div>
        <div class="stat-card fade-up d4"><div class="stat-icon">💰</div><div class="stat-num amount" style="font-size:1.3rem">₹<%= String.format("%,.0f", amtSpent) %></div><div class="stat-label">Amount Spent</div></div>
    </div>

    <!-- RECENT BOOKINGS -->
    <div class="section-header fade-up">
        <div class="section-title-sm">Recent Bookings</div>
        <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-secondary btn-sm">View All →</a>
    </div>

    <div class="table-card fade-up">
        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
            <div class="empty-state"><div class="empty-icon">✈</div><h3>No bookings yet</h3><p>Search for a flight above to get started!</p></div>
        <% } else { %>
        <table>
            <thead><tr><th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Seats</th><th>Amount</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
            <% int sno=1; for(Booking b : recentBookings) {
               String st = b.status != null ? b.status.toLowerCase() : "booked";
               String bc = st.equals("paid")?"badge-paid":st.equals("cancelled")?"badge-cancelled":"badge-booked"; %>
            <tr>
                <td style="color:var(--text-muted);font-size:.8rem"><%= sno++ %></td>
                <td><strong><%= b.flightNo %></strong></td>
                <td><div class="route-cell"><span><%= b.source %></span><span class="route-arrow">→</span><span><%= b.destination %></span></div></td>
                <td style="color:var(--text-muted);font-size:.82rem"><%= b.bookingDate != null ? b.bookingDate.substring(0,10) : "—" %></td>
                <td style="text-align:center"><%= b.numSeats %></td>
                <td class="amount">₹<%= String.format("%,.0f",b.totalAmount) %></td>
                <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
                <td><a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.bookingId %>" class="btn btn-secondary btn-sm">🎫 Invoice</a></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>

<script>
const savedTheme = localStorage.getItem('aerosphere-theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
document.documentElement.setAttribute('data-theme', savedTheme);
document.getElementById('themeToggle').textContent = savedTheme === 'dark' ? '☀️' : '🌙';
function toggleTheme() {
    const n = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', n);
    localStorage.setItem('aerosphere-theme', n);
    document.getElementById('themeToggle').textContent = n === 'dark' ? '☀️' : '🌙';
}
document.querySelector('input[name="departDate"]').min = new Date().toISOString().split('T')[0];
</script>
</body></html>
