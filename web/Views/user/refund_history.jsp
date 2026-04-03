<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<Map<String, Object>> refunds = (List<Map<String, Object>>) request.getAttribute("refunds");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Refunds – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
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
        <a href="userBookings" class="nav-link">My Bookings</a>
        <div class="user-pill">👤 <%= userName %></div>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper medium">

    <div class="page-header">
        <div>
            <h1 class="page-title">💸 My Refunds</h1>
            <p class="page-subtitle">Track your refund requests</p>
        </div>
    </div>

    <div class="card card-top-line">
        <div class="table-wrap">
            <table class="sky-table">
                <thead>
                    <tr>
                        <th>Refund ID</th>
                        <th>Booking</th>
                        <th>Flight</th>
                        <th>Route</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Requested</th>
                        <th>Receipt</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (refunds == null || refunds.isEmpty()) {
                %>
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <div class="empty-icon">📋</div>
                                <p>No refund requests found.</p>
                                <a href="userBookings" class="btn btn-blue btn-sm">View Bookings</a>
                            </div>
                        </td>
                    </tr>
                <%
                    } else {
                        for (Map<String, Object> r : refunds) {
                            String st = String.valueOf(r.get("refund_status"));
                            String badgeCls = "pending";
                            if ("APPROVED".equalsIgnoreCase(st)) badgeCls = "approved";
                            else if ("REJECTED".equalsIgnoreCase(st)) badgeCls = "rejected";
                %>
                    <tr>
                        <td style="color:var(--muted);font-size:.78rem">#<%= r.get("id") %></td>
                        <td style="color:var(--muted);font-size:.78rem">#<%= r.get("booking_id") %></td>
                        <td><strong style="color:var(--sky-glow)"><%= r.get("flight_no") %></strong></td>
                        <td style="white-space:nowrap"><%= r.get("source") %> → <%= r.get("destination") %></td>
                        <td><strong style="color:var(--gold)">₹ <%= String.format("%.2f", ((Number)r.get("refund_amount")).doubleValue()) %></strong></td>
                        <td><span class="badge badge-<%= badgeCls %>"><%= st %></span></td>
                        <td style="color:var(--muted);font-size:.8rem"><%= r.get("requested_at") %></td>
                        <td>
                            <% if (r.get("id") != null) { %>
                                <a href="refundReceipt?refundId=<%= r.get("id") %>" class="btn btn-ghost btn-sm">🧾 View</a>
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
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
