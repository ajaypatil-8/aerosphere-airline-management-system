<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String userName=(String)session.getAttribute("userName");
  if(userName==null){response.sendRedirect(request.getContextPath()+"/login");return;}
  String name    =(String)request.getAttribute("name");
  String email   =(String)request.getAttribute("email");
  String phone   =(String)request.getAttribute("phone");
  String dob     =(String)request.getAttribute("dob");
  String gender  =(String)request.getAttribute("gender");
  String address =(String)request.getAttribute("address");
  String role    =(String)request.getAttribute("role");
  Object createdAt=request.getAttribute("createdAt");
  String error   =(String)request.getAttribute("error");
  String initials=(name!=null&&!name.isEmpty())?String.valueOf(name.charAt(0)).toUpperCase():"U";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Profile – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>

:root{
  --sky:#0EA5E9;--emerald:#10B981;--emerald-dark:#059669;
  --grad:linear-gradient(135deg,var(--sky),var(--emerald));
  --sky-glow:rgba(14,165,233,.18);--em-glow:rgba(16,185,129,.18);
  --bg:#F8FAFC;--card-bg:#FFFFFF;--text:#0F172A;--text-muted:#64748B;
  --border:#E2E8F0;--shadow:0 2px 12px rgba(0,0,0,.06);
  --shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px;
  --sidebar-w:248px;
}
[data-theme="dark"]{
  --bg:#0A0A0F;--card-bg:#111118;--text:#F1F5F9;--text-muted:#94A3B8;
  --border:#1E293B;--shadow:0 2px 12px rgba(0,0,0,.4);
  --shadow-lg:0 12px 40px rgba(0,0,0,.55);
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Syne',sans-serif}

.as-navbar{position:sticky;top:0;z-index:200;display:flex;align-items:center;justify-content:space-between;padding:0 32px;height:62px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.as-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.as-brand-logo{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:17px;color:#fff;box-shadow:0 3px 12px var(--sky-glow)}
.as-brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem;letter-spacing:-.4px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.as-nav-links{display:flex;align-items:center;gap:2px}
.as-nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:9px;font-size:.85rem;font-weight:500;transition:all .2s}
.as-nav-link:hover,.as-nav-link.active{color:var(--sky);background:var(--sky-glow)}
.as-nav-link.danger{color:#EF4444}
.as-theme-toggle{width:33px;height:33px;border:1px solid var(--border);border-radius:9px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px}
.as-user-pill{display:flex;align-items:center;gap:7px;padding:5px 12px 5px 5px;border:1px solid var(--border);border-radius:99px;text-decoration:none;color:var(--text);font-size:.82rem;font-weight:600;transition:all .2s}
.as-user-pill:hover{border-color:var(--sky)}
.as-user-avatar-sm{width:26px;height:26px;border-radius:50%;background:var(--grad);color:#fff;display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:800}
.as-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:9px;font-size:.83rem;font-weight:600;text-decoration:none;border:1.5px solid var(--border);cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif;color:var(--text-muted);background:transparent}
.as-btn:hover{border-color:var(--sky);color:var(--sky)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .45s ease forwards}

.page-wrap{max-width:680px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:20px;flex-wrap:wrap;gap:10px}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.88rem}
.edit-link{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;background:var(--grad);color:#fff;border-radius:10px;text-decoration:none;font-weight:700;font-size:.83rem;font-family:'Syne',sans-serif;transition:transform .15s,box-shadow .15s}
.edit-link:hover{transform:translateY(-1px);box-shadow:0 4px 14px var(--sky-glow)}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:16px;font-size:.85rem;font-weight:500;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
.avatar-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:28px 24px;text-align:center;margin-bottom:16px;box-shadow:var(--shadow);position:relative;overflow:hidden}
.avatar-card::before{content:'';position:absolute;top:0;left:0;right:0;height:4px;background:var(--grad)}
.avatar{width:80px;height:80px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:2rem;font-weight:900;color:#fff;margin:0 auto 14px;box-shadow:0 6px 20px var(--sky-glow)}
.avatar-name{font-size:1.3rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.avatar-email{color:var(--text-muted);font-size:.87rem}
.role-badge{display:inline-flex;align-items:center;padding:4px 12px;border-radius:99px;font-size:.73rem;font-weight:700;margin-top:10px;border:1px solid}
.role-admin{background:var(--em-glow);color:var(--emerald);border-color:var(--emerald)}
.role-user{background:var(--sky-glow);color:var(--sky);border-color:var(--sky)}
.info-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);margin-bottom:16px}
.info-card-header{padding:12px 20px;border-bottom:1px solid var(--border);font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.info-row{display:flex;align-items:center;gap:14px;padding:13px 20px;border-bottom:1px solid var(--border)}
.info-row:last-child{border-bottom:none}
.info-icon{width:34px;height:34px;background:var(--sky-glow);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0}
.info-label{font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted);margin-bottom:2px}
.info-value{font-size:.9rem;font-weight:500}
</style>
</head>
<body>
<%
  String _nUser=(String)session.getAttribute("userName");
  String _nInit=(_nUser!=null&&!_nUser.isEmpty())?String.valueOf(_nUser.charAt(0)).toUpperCase():"U";
  String _nFirst=(_nUser!=null&&_nUser.contains(" "))?_nUser.split(" ")[0]:_nUser;
%>
<nav class="as-navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="as-brand">
    <div class="as-brand-logo">✈</div>
    <span class="as-brand-name">AeroSphere</span>
  </a>
  <div class="as-nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="as-nav-link ">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="as-nav-link ">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/allFlights"        class="as-nav-link ">✈️ Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="as-nav-link ">🎫 My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="as-nav-link ">💸 Refunds</a>
  </div>
  <div style="display:flex;align-items:center;gap:8px">
    <button class="as-theme-toggle" id="asThemeToggle">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="as-user-pill">
      <div class="as-user-avatar-sm"><%=_nInit%></div>
      <span><%=_nFirst%></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="as-btn">↩ Logout</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header fu">
    <div>
      <h1 class="page-title">👤 My Profile</h1>
      <p class="page-subtitle">Your account details and personal information</p>
    </div>
    <a href="${pageContext.request.contextPath}/editProfile" class="edit-link">✏️ Edit Profile</a>
  </div>
  <%if(error!=null){%><div class="alert fu">⚠️ <%=error%></div><%}%>
  <div class="avatar-card fu">
    <div class="avatar"><%=initials%></div>
    <div class="avatar-name"><%=name!=null?name:"—"%></div>
    <div class="avatar-email"><%=email!=null?email:"—"%></div>
    <div><span class="role-badge <%="ADMIN".equals(role)?"role-admin":"role-user"%>"><%=role!=null?role:"USER"%></span></div>
  </div>
  <div class="info-card fu">
    <div class="info-card-header">Personal Information</div>
    <div class="info-row"><div class="info-icon">📞</div><div><div class="info-label">Phone</div><div class="info-value"><%=phone!=null&&!phone.isEmpty()?phone:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon">🎂</div><div><div class="info-label">Date of Birth</div><div class="info-value"><%=dob!=null&&!dob.isEmpty()?dob:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon">⚧</div><div><div class="info-label">Gender</div><div class="info-value"><%=gender!=null&&!gender.isEmpty()?gender:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon">📍</div><div><div class="info-label">Address</div><div class="info-value"><%=address!=null&&!address.isEmpty()?address:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon">📅</div><div><div class="info-label">Member Since</div><div class="info-value"><%=createdAt!=null?createdAt.toString().substring(0,10):"—"%></div></div></div>
  </div>
</div>
<script>
(function(){
  var btn=document.getElementById('asThemeToggle');
  if(!btn)return;
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.textContent=t==='dark'?'☀️':'🌙';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();
</script>
</body></html>
