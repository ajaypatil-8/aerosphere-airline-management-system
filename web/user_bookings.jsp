<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.servlet.UserBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<BookingRow> bookings = (List<BookingRow>) request.getAttribute("bookings");
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess");
    session.removeAttribute("cancelError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
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
        <a href="userDashboard"       class="nav-link">Dashboard</a>
        <a href="userBookings"        class="nav-link active">My Bookings</a>
        <a href="userRefundHistory"   class="nav-link">Refunds</a>
        <a href="profile"             class="nav-link">Profile</a>
        <a href="logout"              class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper">

    <div class="page-header">
        <div>
            <h1 class="page-title">🎫 My Bookings</h1>
            <p class="page-subtitle">View and manage all your flight bookings</p>
        </div>
        <a href="userDashboard" class="btn btn-ghost">← Search Flights</a>
    </div>

    <% if (cancelError   != null) { %><div class="alert alert-error">⚠ <%= cancelError %></div><% } %>
    <% if (cancelSuccess != null) { %><div class="alert alert-success">✔ <%= cancelSuccess %></div><% } %>

    <!-- Stats -->
    <%
        int total = 0, paid = 0, cancelled = 0, pending = 0;
        double spent = 0;
        if (bookings != null) {
            total = bookings.size();
            for (BookingRow b : bookings) {
                String s = b.status != null ? b.status.toUpperCase() : "";
                if (s.equals("PAID")) { paid++; spent += b.totalAmount; }
                else if (s.equals("CANCELLED")) cancelled++;
                else pending++;
            }
        }
    %>
    <div class="stats-grid" style="margin-bottom:24px;">
        <div class="stat-card" style="animation-delay:.05s"><div class="stat-icon">🎫</div><div class="stat-label">Total</div><div class="stat-value"><%= total %></div></div>
        <div class="stat-card" style="animation-delay:.10s"><div class="stat-icon">✅</div><div class="stat-label">Paid</div><div class="stat-value green"><%= paid %></div></div>
        <div class="stat-card" style="animation-delay:.15s"><div class="stat-icon">⏳</div><div class="stat-label">Pending</div><div class="stat-value"><%= pending %></div></div>
        <div class="stat-card" style="animation-delay:.20s"><div class="stat-icon">❌</div><div class="stat-label">Cancelled</div><div class="stat-value red"><%= cancelled %></div></div>
        <div class="stat-card" style="animation-delay:.25s"><div class="stat-icon">💰</div><div class="stat-label">Total Spent</div><div class="stat-value gold" style="font-size:1.2rem;">₹<%= String.format("%,.0f", spent) %></div></div>
    </div>

    <!-- Filter -->
    <div class="filter-bar" style="animation:fadeUp .5s ease both;">
        <div class="filter-wrap">
            <span class="filter-icon">🔍</span>
            <input class="filter-input" type="text" id="searchInput" placeholder="Search by flight, route…" onkeyup="filterRows()">
        </div>
        <select class="filter-select" id="statusFilter" onchange="filterRows()">
            <option value="">All Statuses</option>
            <option value="paid">Paid</option>
            <option value="booked">Booked</option>
            <option value="pending">Pending</option>
            <option value="cancelled">Cancelled</option>
        </select>
    </div>

    <div class="table-wrap">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">✈</div>
                <h3>No bookings yet</h3>
                <p>Search for a flight to make your first booking!</p>
            </div>
        <% } else { %>
        <table>
            <thead><tr>
                <th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Seats</th><th>Amount</th><th>Status</th><th>Payment</th><th>Actions</th>
            </tr></thead>
            <tbody id="bookingsBody">
            <% int sno = 1; for (BookingRow b : bookings) {
                String st = b.status != null ? b.status.toLowerCase() : "booked";
                String bc = "badge-booked";
                if (st.equals("paid"))       bc = "badge-paid";
                else if (st.equals("cancelled")) bc = "badge-cancelled";
                else if (st.equals("pending"))   bc = "badge-pending";
                boolean canCancel = !st.equals("cancelled") && !st.equals("refunded");
            %>
            <tr style="animation:fadeUp .4s ease both;animation-delay:<%= sno * 0.04 %>s">
                <td class="sno-cell"><%= sno++ %></td>
                <td><strong><%= b.flightNo %></strong></td>
                <td>
                    <div class="route-display">
                        <span><%= b.source %></span>
                        <span class="route-arrow">→</span>
                        <span><%= b.destination %></span>
                    </div>
                </td>
                <td style="color:var(--muted);font-size:.8rem;"><%= b.departDate %></td>
                <td style="text-align:center;"><%= b.numSeats %></td>
                <td style="font-weight:700;color:var(--sky-glow);">₹<%= String.format("%,.0f", b.totalAmount) %></td>
                <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase() + st.substring(1) %></span></td>
                <td>
                    <% String ps = b.paymentStatus != null ? b.paymentStatus.toLowerCase() : "pending";
                       String pbc = "badge-pending";
                       if (ps.equals("paid")) pbc = "badge-paid";
                       else if (ps.equals("refunded")) pbc = "badge-refunded";
                    %>
                    <span class="badge <%= pbc %>" style="font-size:.68rem;"><%= ps.substring(0,1).toUpperCase() + ps.substring(1) %></span>
                </td>
                <td>
                    <div style="display:flex;gap:6px;flex-wrap:wrap;">
                        <a href="invoice?bookingId=<%= b.id %>" class="btn btn-purple-sm btn-sm">🎫 Invoice</a>
                        <% if (canCancel) { %>
                        <button class="btn btn-danger-sm btn-sm" onclick="openCancel(<%= b.id %>, '<%= b.flightNo %>')">✖ Cancel</button>
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

<!-- Cancel Modal -->
<div class="modal-overlay" id="cancelModal">
    <div class="modal-box">
        <div class="modal-icon">⚠</div>
        <h3>Cancel Booking?</h3>
        <p id="modalTxt">This will cancel your booking and request a refund if applicable.</p>
        <div class="modal-btns">
            <button class="btn btn-ghost" onclick="closeCancel()">Keep It</button>
            <form id="cancelForm" method="post" action="cancelBooking" style="flex:1;">
                <input type="hidden" name="bookingId" id="cancelBookingId">
                <button type="submit" class="btn btn-danger-sm" style="width:100%;border-radius:10px;padding:10px;">Yes, Cancel</button>
            </form>
        </div>
    </div>
</div>

<script>
function openCancel(id, flight) {
    document.getElementById('cancelBookingId').value = id;
    document.getElementById('modalTxt').innerHTML = 'Cancel booking for flight <strong>' + flight + '</strong>? A refund will be requested if you paid.';
    document.getElementById('cancelModal').classList.add('active');
}
function closeCancel() { document.getElementById('cancelModal').classList.remove('active'); }
document.getElementById('cancelModal').addEventListener('click', e => { if (e.target === document.getElementById('cancelModal')) closeCancel(); });

function filterRows() {
    const q = document.getElementById('searchInput').value.toLowerCase();
    const f = document.getElementById('statusFilter').value.toLowerCase();
    document.querySelectorAll('#bookingsBody tr').forEach(row => {
        const text = row.textContent.toLowerCase();
        const badge = row.querySelector('.badge');
        const st = badge ? badge.textContent.trim().toLowerCase() : '';
        row.style.display = (text.includes(q) && (!f || st === f)) ? '' : 'none';
    });
}

const s = document.getElementById('stars');
for (let i = 0; i < 70; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
