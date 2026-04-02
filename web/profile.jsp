<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    Integer id     = (Integer)           request.getAttribute("id");
    String  name   = (String)            request.getAttribute("name");
    String  email  = (String)            request.getAttribute("email");
    String  phone  = (String)            request.getAttribute("phone");
    String  dob    = (String)            request.getAttribute("dob");
    String  gender = (String)            request.getAttribute("gender");
    String  address= (String)            request.getAttribute("address");
    String  role   = (String)            request.getAttribute("role");
    java.sql.Timestamp createdAt = (java.sql.Timestamp) request.getAttribute("createdAt");
    if (id == null) { response.sendRedirect("login.jsp"); return; }
    String initials = (name != null && name.length() > 0) ? String.valueOf(name.charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – SkyConnect</title>
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
        <a href="userBookings" class="nav-link">My Bookings</a>
        <div class="user-pill">👤 <%= userName %></div>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper narrow">

    <div class="page-header">
        <div>
            <h1 class="page-title">👤 My Profile</h1>
            <p class="page-subtitle">Your account information</p>
        </div>
        <a href="editProfile" class="btn btn-blue">✏ Edit Profile</a>
    </div>

    <!-- PROFILE HERO CARD -->
    <div class="card card-top-line" style="margin-bottom:20px;">
        <div style="padding:28px 32px;display:flex;align-items:center;gap:20px;border-bottom:1px solid var(--border-2);">
            <div class="avatar-ring" style="width:80px;height:80px;font-size:32px;"><%= initials %></div>
            <div>
                <div style="font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;"><%= name %></div>
                <div style="color:var(--muted);font-size:.88rem;margin-top:4px;"><%= email %></div>
                <div style="margin-top:10px;display:flex;gap:8px;">
                    <span class="badge badge-<%= "ADMIN".equals(role) ? "paid" : "booked" %>"><%= role %></span>
                    <% if (createdAt != null) { %>
                        <span style="font-size:.72rem;color:var(--muted);padding:4px 10px;background:var(--glass);border-radius:99px;">
                            Joined <%= new java.text.SimpleDateFormat("MMM yyyy").format(createdAt) %>
                        </span>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="card-pad">
            <div class="section-label" style="margin-bottom:16px;">Personal Information</div>
            <div class="info-grid">
                <div class="info-item">
                    <label>📱 Phone</label>
                    <span><%= phone != null ? phone : "—" %></span>
                </div>
                <div class="info-item">
                    <label>🎂 Date of Birth</label>
                    <span><%= dob != null ? dob : "—" %></span>
                </div>
                <div class="info-item">
                    <label>⚧ Gender</label>
                    <span><%= gender != null ? gender : "—" %></span>
                </div>
                <div class="info-item">
                    <label>🆔 User ID</label>
                    <span style="color:var(--muted)">#<%= id %></span>
                </div>
            </div>

            <% if (address != null && !address.isEmpty()) { %>
            <div style="margin-top:16px;">
                <div class="info-item">
                    <label>📍 Address</label>
                    <span><%= address %></span>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- QUICK LINKS -->
    <div class="actions-grid" style="grid-template-columns:repeat(3,1fr);">
        <a href="userBookings" class="action-card"><div class="action-icon">🎫</div><div class="action-label">My Bookings</div></a>
        <a href="userRefundHistory" class="action-card"><div class="action-icon">💸</div><div class="action-label">My Refunds</div></a>
        <a href="editProfile" class="action-card"><div class="action-icon">✏</div><div class="action-label">Edit Profile</div></a>
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
