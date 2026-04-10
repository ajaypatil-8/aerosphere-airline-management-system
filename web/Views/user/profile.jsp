<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String name      = (String) request.getAttribute("name");
    String email     = (String) request.getAttribute("email");
    String phone     = (String) request.getAttribute("phone");
    String dob       = (String) request.getAttribute("dob");
    String gender    = (String) request.getAttribute("gender");
    String address   = (String) request.getAttribute("address");
    String role      = (String) request.getAttribute("role");
    Object createdAt = request.getAttribute("createdAt");
    String error     = (String) request.getAttribute("error");
    String initials  = (name != null && !name.isEmpty()) ? String.valueOf(name.charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Profile – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.active{color:var(--primary);background:var(--primary-glow)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
/* PAGE */
.page-wrapper{max-width:680px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* ALERT */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
/* AVATAR CARD */
.avatar-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:28px 24px;text-align:center;margin-bottom:16px;box-shadow:var(--shadow);animation:fadeUp .5s ease both .05s}
.avatar{width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--primary),var(--primary-dark));display:flex;align-items:center;justify-content:center;font-size:2rem;font-weight:900;color:#fff;margin:0 auto 16px;box-shadow:0 6px 20px var(--primary-glow)}
.avatar-name{font-size:1.3rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.avatar-email{color:var(--text-muted);font-size:.88rem}
.role-badge{display:inline-flex;align-items:center;padding:4px 12px;border-radius:99px;font-size:.76rem;font-weight:700;margin-top:10px}
.role-admin{background:rgba(16,185,129,.12);color:var(--primary);border:1px solid var(--primary)}
.role-user{background:rgba(59,130,246,.1);color:#2563EB;border:1px solid rgba(59,130,246,.3)}
[data-theme="dark"] .role-user{color:#93C5FD}
/* INFO CARD */
.info-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);margin-bottom:16px;animation:fadeUp .5s ease both .1s}
.info-card-header{padding:14px 20px;border-bottom:1px solid var(--border);font-size:.78rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--primary)}
.info-row{display:flex;align-items:center;gap:14px;padding:14px 20px;border-bottom:1px solid var(--border)}
.info-row:last-child{border-bottom:none}
.info-icon{width:36px;height:36px;background:var(--primary-glow);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0}
.info-label{font-size:.73rem;font-weight:600;text-transform:uppercase;letter-spacing:.3px;color:var(--text-muted)}
.info-value{font-size:.9rem;font-weight:500;margin-top:2px}
/* ACTIONS */
.action-row{display:flex;gap:12px;justify-content:center;margin-top:4px;animation:fadeUp .5s ease both .15s}
.btn{display:inline-flex;align-items:center;gap:6px;padding:10px 20px;border-radius:10px;font-size:.88rem;font-weight:600;text-decoration:none;border:1px solid var(--border);cursor:pointer;transition:all .2s;background:var(--card-bg);color:var(--text)}
.btn:hover{border-color:var(--primary);color:var(--primary)}
.btn-primary{background:var(--primary);color:#fff;border-color:var(--primary);box-shadow:0 3px 10px var(--primary-glow)}.btn-primary:hover{background:var(--primary-dark);color:#fff}
</style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link ">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link ">🔍 Search</a>
        <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link ">✈️ All Flights</a>
        <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link ">🎫 My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link ">💸 Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"           class="nav-link active">👤 Profile</a>
        <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">↩ Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div><div class="page-title">👤 My Profile</div><div class="page-subtitle">Your account details</div></div>
        <a href="${pageContext.request.contextPath}/editProfile" class="btn btn-primary">✏️ Edit Profile</a>
    </div>

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

    <!-- AVATAR CARD -->
    <div class="avatar-card">
        <div class="avatar"><%= initials %></div>
        <div class="avatar-name"><%= name != null ? name : "—" %></div>
        <div class="avatar-email"><%= email != null ? email : "—" %></div>
        <div><span class="role-badge <%= "ADMIN".equals(role) ? "role-admin" : "role-user" %>"><%= role != null ? role : "USER" %></span></div>
    </div>

    <!-- INFO CARD -->
    <div class="info-card">
        <div class="info-card-header">Personal Information</div>
        <div class="info-row"><div class="info-icon">📱</div><div><div class="info-label">Phone</div><div class="info-value"><%= (phone != null && !phone.isEmpty()) ? phone : "Not provided" %></div></div></div>
        <div class="info-row"><div class="info-icon">🎂</div><div><div class="info-label">Date of Birth</div><div class="info-value"><%= (dob != null && !dob.isEmpty()) ? dob : "Not provided" %></div></div></div>
        <div class="info-row"><div class="info-icon">⚧</div><div><div class="info-label">Gender</div><div class="info-value"><%= (gender != null && !gender.isEmpty()) ? gender : "Not provided" %></div></div></div>
        <div class="info-row"><div class="info-icon">📍</div><div><div class="info-label">Address</div><div class="info-value"><%= (address != null && !address.isEmpty()) ? address : "Not provided" %></div></div></div>
        <div class="info-row"><div class="info-icon">📅</div><div><div class="info-label">Member Since</div><div class="info-value"><%= createdAt != null ? createdAt.toString().substring(0,10) : "—" %></div></div></div>
    </div>

    <div class="action-row">
        <a href="${pageContext.request.contextPath}/editProfile" class="btn btn-primary">✏️ Edit Profile</a>
        <a href="${pageContext.request.contextPath}/userBookings" class="btn">🎫 My Bookings</a>
    </div>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
</script>
</body></html>
