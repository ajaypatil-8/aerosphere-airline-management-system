<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.skyconnect.servlet.UserBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<BookingRow> list = (List<BookingRow>) request.getAttribute("bookings");
    String cancelError = (String) session.getAttribute("cancelError");
    if (cancelError != null) session.removeAttribute("cancelError");
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
    <a href="index.jsp" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="search_flights.jsp" class="nav-link">Search Flights</a>
        <a href="userRefundHistory" class="nav-link">Refunds</a>
        <a href="profile" class="nav-link">Profile</a>
        <div class="user-pill">👤 <%= userName %></div>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper">

    <div class="page-header">
        <div>
            <h1 class="page-title">🎫 My Bookings</h1>
            <p class="page-subtitle">All your flight reservations</p>
        </div>
        <a href="search_flights.jsp" class="btn btn-blue">+ Search New Flight</a>
    </div>

    <% if (cancelError != null) { %>
        <div class="alert alert-error">⚠ <%= cancelError %></div>
    <% } %>

    <div class="card card-top-line">
        <div class="table-wrap">
            <table class="sky-table">
                <thead>
                    <tr>
                        <th>#ID</th>
                        <th>Flight</th>
                        <th>Route</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Seats</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (list == null || list.isEmpty()) {
                %>
                    <tr>
                        <td colspan="10">
                            <div class="empty-state">
                                <div class="empty-icon">🛫</div>
                                <p>You haven't made any bookings yet.</p>
                                <a href="search_flights.jsp" class="btn btn-blue btn-sm">Search Flights</a>
                            </div>
                        </td>
                    </tr>
                <%
                    } else {
                        for (BookingRow b : list) {
                            boolean canCancel = "BOOKED".equals(b.status) || "PAID".equals(b.status);
                %>
                    <tr>
                        <td style="color:var(--muted);font-size:.78rem">#<%= b.bookingId %></td>
                        <td><strong style="color:var(--sky-glow)"><%= b.flightNo %></strong></td>
                        <td style="white-space:nowrap"><%= b.source %> → <%= b.destination %></td>
                        <td><%= b.departDate %></td>
                        <td><%= b.departTime %></td>
                        <td style="text-align:center"><%= b.numSeats %></td>
                        <td><strong>₹ <%= String.format("%.2f", b.totalAmount) %></strong></td>
                        <td><span class="badge badge-<%= b.status.toLowerCase() %>"><%= b.status %></span></td>
                        <td><span class="badge badge-<%= b.paymentStatus.toLowerCase() %>"><%= b.paymentStatus %></span></td>
                        <td style="white-space:nowrap;display:flex;gap:6px;align-items:center;padding:10px 16px;">
                            <a href="invoice?bookingId=<%= b.bookingId %>" class="btn btn-ghost btn-sm">🧾</a>
                            <% if ("PAID".equals(b.status)) { %>
                                <a href="payment?bookingId=<%= b.bookingId %>" class="btn btn-green btn-sm">💳</a>
                            <% } %>
                            <% if (canCancel) { %>
                                <form action="cancelBooking" method="post" style="display:inline;" onsubmit="return confirm('Cancel this booking?');">
                                    <input type="hidden" name="bookingId" value="<%= b.bookingId %>">
                                    <button type="submit" class="btn btn-red btn-sm">✕</button>
                                </form>
                            <% } %>
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
for (let i = 0; i < 90; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
