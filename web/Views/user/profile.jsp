<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String name      = (String) request.getAttribute("name");
    String email     = (String) request.getAttribute("email");
    String phone     = (String) request.getAttribute("phone");
    String dob       = (String) request.getAttribute("dob");
    String gender    = (String) request.getAttribute("gender");
    String address   = (String) request.getAttribute("address");
    String role      = (String) request.getAttribute("role");
    Object createdAt = request.getAttribute("createdAt");
    String error     = (String) request.getAttribute("error");
    String success   = (String) request.getAttribute("success");
    String initials  = (name != null && name.length() > 0) ? name.substring(0,1).toUpperCase() : "?";
    boolean isAdmin  = "ADMIN".equals(role);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .avatar-ring {
            width: 90px; height: 90px; border-radius: 50%;
            background: linear-gradient(135deg, var(--sky), var(--sky-glow));
            display: flex; align-items: center; justify-content: center;
            font-family: 'Syne', sans-serif; font-size: 2.2rem; font-weight: 800;
            flex-shrink: 0;
            box-shadow: 0 0 0 4px rgba(0,87,255,.2), 0 0 30px rgba(0,87,255,.25);
        }
        .profile-header {
            display: flex; align-items: center; gap: 24px;
            padding: 28px; border-bottom: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .profile-header-info h2 {
            font-family: 'Syne', sans-serif; font-size: 1.4rem; font-weight: 800;
        }
        .profile-header-info p { color: var(--muted); font-size: .875rem; margin-top: 3px; }
        .profile-body { padding: 24px 28px; }
        .field-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0; }
        @media (max-width: 600px) { .field-grid { grid-template-columns: 1fr; } .profile-header { gap: 16px; } }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="<%= isAdmin ? "adminDashboard" : "userDashboard" %>" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <% if (isAdmin) { %>
            <a href="adminDashboard" class="nav-link">Dashboard</a>
            <a href="adminFlights" class="nav-link">Flights</a>
            <a href="adminBookings" class="nav-link">Bookings</a>
        <% } else { %>
            <a href="userDashboard" class="nav-link">Dashboard</a>
            <a href="userBookings" class="nav-link">My Bookings</a>
            <a href="profile" class="nav-link active">Profile</a>
        <% } %>
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

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>
    <% if (success != null) { %><div class="alert alert-success">✔ <%= success %></div><% } %>

    <div class="card-glow" style="padding:0;overflow:hidden;">

        <div class="profile-header">
            <div class="avatar-ring"><%= initials %></div>
            <div class="profile-header-info">
                <h2><%= name != null ? name : "—" %></h2>
                <p><%= email != null ? email : "—" %></p>
                <div style="margin-top:8px;display:flex;gap:8px;flex-wrap:wrap;">
                    <span class="badge <%= isAdmin ? "badge-admin" : "badge-user" %>">
                        <%= isAdmin ? "⚡ Admin" : "✈ Passenger" %>
                    </span>
                    <% if (phone != null && !phone.isEmpty()) { %>
                        <span class="badge badge-booked">📱 <%= phone %></span>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="profile-body">
            <div class="section-label">Personal Information</div>

            <div class="field-grid">
                <div class="info-row">
                    <div class="info-icon">👤</div>
                    <div>
                        <div class="info-label">Full Name</div>
                        <div class="info-value"><%= name != null && !name.isEmpty() ? name : "—" %></div>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-icon">✉</div>
                    <div>
                        <div class="info-label">Email Address</div>
                        <div class="info-value"><%= email != null && !email.isEmpty() ? email : "—" %></div>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-icon">📱</div>
                    <div>
                        <div class="info-label">Phone Number</div>
                        <div class="info-value"><%= phone != null && !phone.isEmpty() ? phone : "Not set" %></div>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-icon">🎂</div>
                    <div>
                        <div class="info-label">Date of Birth</div>
                        <div class="info-value"><%= dob != null && !dob.isEmpty() ? dob : "Not set" %></div>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-icon">⚧</div>
                    <div>
                        <div class="info-label">Gender</div>
                        <div class="info-value"><%= gender != null && !gender.isEmpty() ? gender : "Not set" %></div>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-icon">🗓</div>
                    <div>
                        <div class="info-label">Member Since</div>
                        <div class="info-value"><%= createdAt != null ? createdAt.toString().substring(0,10) : "—" %></div>
                    </div>
                </div>
                <div class="info-row" style="grid-column:1/-1;">
                    <div class="info-icon">🏠</div>
                    <div>
                        <div class="info-label">Address</div>
                        <div class="info-value"><%= address != null && !address.isEmpty() ? address : "Not set" %></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div style="display:flex;gap:12px;margin-top:16px;flex-wrap:wrap;">
        <a href="editProfile" class="btn btn-blue" style="flex:1;min-width:160px;justify-content:center;">✏ Edit Profile</a>
        <% if (!isAdmin) { %>
        <a href="userRefundHistory" class="btn btn-ghost" style="flex:1;min-width:160px;justify-content:center;">💸 Refund History</a>
        <a href="userBookings" class="btn btn-ghost" style="flex:1;min-width:160px;justify-content:center;">🎫 My Bookings</a>
        <% } %>
    </div>
</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 60; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
