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
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>

:root{
  --sky:#2E4A3D;--emerald:#5B8A6E;--emerald-dark:#3E6350;
  --grad:linear-gradient(135deg,var(--sky),var(--emerald));
  --sky-glow:rgba(46,74,61,.18);--em-glow:rgba(91,138,110,.18);
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
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Fraunces',serif}

@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .45s ease forwards}

.page-wrap{max-width:680px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:20px;flex-wrap:wrap;gap:10px}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.88rem}
.edit-link{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;background:var(--grad);color:#fff;border-radius:10px;text-decoration:none;font-weight:700;font-size:.83rem;font-family:'Fraunces',serif;transition:transform .15s,box-shadow .15s}
.edit-link:hover{transform:translateY(-1px);box-shadow:0 4px 14px var(--sky-glow)}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:16px;font-size:.85rem;font-weight:500;background:rgba(179,85,74,.08);border:1px solid rgba(179,85,74,.2);color:#96453B}
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
<%@ include file="/Views/common/navbar.jsp" %>
<div class="page-wrap">
  <div class="page-header fu">
    <div>
      <h1 class="page-title"><i class="ph-bold ph-user"></i> My Profile</h1>
      <p class="page-subtitle">Your account details and personal information</p>
    </div>
    <a href="${pageContext.request.contextPath}/editProfile" class="edit-link"><i class="ph-bold ph-pencil-simple"></i>️ Edit Profile</a>
  </div>
  <%if(error!=null){%><div class="alert fu"><i class="ph-bold ph-warning"></i> <%=error%></div><%}%>
  <div class="avatar-card fu">
    <div class="avatar"><%=initials%></div>
    <div class="avatar-name"><%=name!=null?name:"—"%></div>
    <div class="avatar-email"><%=email!=null?email:"—"%></div>
    <div><span class="role-badge <%="ADMIN".equals(role)?"role-admin":"role-user"%>"><%=role!=null?role:"USER"%></span></div>
  </div>
  <div class="info-card fu">
    <div class="info-card-header">Personal Information</div>
    <div class="info-row"><div class="info-icon"><i class="ph-bold ph-phone"></i></div><div><div class="info-label">Phone</div><div class="info-value"><%=phone!=null&&!phone.isEmpty()?phone:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon"><i class="ph-bold ph-cake"></i></div><div><div class="info-label">Date of Birth</div><div class="info-value"><%=dob!=null&&!dob.isEmpty()?dob:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon"><i class="ph-bold ph-user-circle"></i></div><div><div class="info-label">Gender</div><div class="info-value"><%=gender!=null&&!gender.isEmpty()?gender:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon"><i class="ph-bold ph-map-pin"></i></div><div><div class="info-label">Address</div><div class="info-value"><%=address!=null&&!address.isEmpty()?address:"Not provided"%></div></div></div>
    <div class="info-row"><div class="info-icon"><i class="ph-bold ph-calendar-blank"></i></div><div><div class="info-label">Member Since</div><div class="info-value"><%=createdAt!=null?createdAt.toString().substring(0,10):"—"%></div></div></div>
  </div>
</div>
<script>
(function(){
  var btn=document.getElementById('asThemeToggle');
  if(!btn)return;
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.textContent=t==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();
</script>
<%@ include file="/Views/common/Footer.jsp" %>
</body></html>
