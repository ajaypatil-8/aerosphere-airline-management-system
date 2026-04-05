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
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Profile – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
<style>
.avatar{width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--sky),var(--sky-glow));display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;color:#fff;margin:0 auto 16px;}
</style>
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">My Bookings</a>
    <a href="${pageContext.request.contextPath}/profile"       class="nav-link active">Profile</a>
    <a href="${pageContext.request.contextPath}/logout"        class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper medium">
  <div class="page-header animate-fadeup">
    <div><h1 class="page-title">👤 My Profile</h1><p class="page-subtitle">Your account details</p></div>
    <a href="${pageContext.request.contextPath}/editProfile" class="btn btn-primary">✏️ Edit Profile</a>
  </div>

  <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

  <div class="card animate-fadeup" style="text-align:center;padding-top:32px;padding-bottom:28px;">
    <div class="avatar"><%= initials %></div>
    <div style="font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;"><%= name != null ? name : "—" %></div>
    <div style="color:var(--muted);font-size:.9rem;margin-top:4px;"><%= email != null ? email : "—" %></div>
    <div style="margin-top:10px;"><span class="badge <%= "ADMIN".equals(role) ? "badge-paid" : "badge-booked" %>"><%= role != null ? role : "USER" %></span></div>
  </div>

  <div class="card animate-fadeup delay-2">
    <div class="section-label">Personal Information</div>
    <div class="info-row"><div class="info-icon">📱</div><div><div class="info-label">Phone</div><div class="info-value"><%= (phone != null && !phone.isEmpty()) ? phone : "Not provided" %></div></div></div>
    <div class="info-row"><div class="info-icon">🎂</div><div><div class="info-label">Date of Birth</div><div class="info-value"><%= (dob != null && !dob.isEmpty()) ? dob : "Not provided" %></div></div></div>
    <div class="info-row"><div class="info-icon">⚧</div><div><div class="info-label">Gender</div><div class="info-value"><%= (gender != null && !gender.isEmpty()) ? gender : "Not provided" %></div></div></div>
    <div class="info-row"><div class="info-icon">📍</div><div><div class="info-label">Address</div><div class="info-value"><%= (address != null && !address.isEmpty()) ? address : "Not provided" %></div></div></div>
    <div class="info-row"><div class="info-icon">📅</div><div><div class="info-label">Member Since</div><div class="info-value"><%= createdAt != null ? createdAt.toString().substring(0,10) : "—" %></div></div></div>
  </div>

  <div style="display:flex;gap:12px;justify-content:center;margin-top:8px;">
    <a href="${pageContext.request.contextPath}/editProfile" class="btn btn-primary">✏️ Edit Profile</a>
    <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-secondary">🎫 My Bookings</a>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
