<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil,com.skyconnect.util.HtmlUtils" %>
<%
  String userName=(String)session.getAttribute("userName");
  if(userName==null){response.sendRedirect(request.getContextPath()+"/login");return;}
  String curName   =(String)request.getAttribute("curName");
  String curEmail  =(String)request.getAttribute("curEmail");
  String curPhone  =(String)request.getAttribute("curPhone");
  String curDob    =(String)request.getAttribute("curDob");
  String curGender =(String)request.getAttribute("curGender");
  String curAddress=(String)request.getAttribute("curAddress");
  String error     =(String)request.getAttribute("error");
  String csrfToken =CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Edit Profile – AeroSphere</title>
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

:root{--input-bg:#F8FAFC}[data-theme="dark"]{--input-bg:#1A1A2E}
.page-wrap{max-width:700px;margin:0 auto;padding:32px 24px}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.88rem;margin-bottom:20px}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:16px;font-size:.85rem;font-weight:500;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
.card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);position:relative}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:4px;background:var(--grad)}
.card-inner{padding:28px}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.full{grid-column:1/-1}
.form-group{display:flex;flex-direction:column;gap:6px}
.form-group label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted)}
.field-wrap{position:relative}
.fi{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:13px;pointer-events:none}
.fi.top{top:16px;transform:none}
.field-wrap input,.field-wrap select,.field-wrap textarea{width:100%;background:var(--input-bg);border:1.5px solid var(--border);border-radius:10px;padding:11px 13px 11px 38px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.9rem;outline:none;transition:all .2s;appearance:none}
.field-wrap textarea{height:80px;resize:none;padding-top:12px}
.field-wrap input:focus,.field-wrap select:focus,.field-wrap textarea:focus{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow);background:var(--card-bg)}
.btn-row{display:flex;gap:10px;margin-top:8px}
.btn-save{padding:11px 28px;background:var(--grad);color:#fff;border:none;border-radius:10px;font-family:'Syne',sans-serif;font-size:.9rem;font-weight:700;cursor:pointer;transition:transform .15s,box-shadow .15s}
.btn-save:hover{transform:translateY(-1px);box-shadow:0 4px 14px var(--sky-glow)}
.btn-back{padding:11px 20px;border:1.5px solid var(--border);border-radius:10px;text-decoration:none;color:var(--text-muted);font-size:.88rem;font-weight:500;transition:all .2s}
.btn-back:hover{border-color:var(--sky);color:var(--sky)}
@media(max-width:600px){.form-grid{grid-template-columns:1fr}}
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
  <h1 class="page-title fu">✏️ Edit Profile</h1>
  <p class="page-subtitle fu">Update your personal information</p>
  <%if(error!=null){%><div class="alert fu">⚠️ <%=error%></div><%}%>
  <div class="card fu">
    <div class="card-inner">
      <form method="post" action="${pageContext.request.contextPath}/editProfile">
        <input type="hidden" name="_csrf" value="<%=csrfToken%>">
        <div class="form-grid">
          <div class="form-group"><label>Full Name</label><div class="field-wrap"><span class="fi">👤</span><input type="text" name="name" value="<%=HtmlUtils.e(curName)%>" required placeholder="Your full name"></div></div>
          <div class="form-group"><label>Email</label><div class="field-wrap"><span class="fi">✉️</span><input type="email" name="email" value="<%=HtmlUtils.e(curEmail)%>" required placeholder="email@example.com"></div></div>
          <div class="form-group"><label>Phone</label><div class="field-wrap"><span class="fi">📞</span><input type="tel" name="phone" value="<%=HtmlUtils.e(curPhone)%>" placeholder="+91 XXXXX XXXXX"></div></div>
          <div class="form-group"><label>Date of Birth</label><div class="field-wrap"><span class="fi">🎂</span><input type="date" name="dob" value="<%=curDob!=null?curDob:""%>"></div></div>
          <div class="form-group"><label>Gender</label><div class="field-wrap"><span class="fi">⚧</span>
            <select name="gender">
              <option value="">Select gender</option>
              <option value="Male"   <%="Male"  .equals(curGender)?"selected":""%>>Male</option>
              <option value="Female" <%="Female".equals(curGender)?"selected":""%>>Female</option>
              <option value="Other"  <%="Other" .equals(curGender)?"selected":""%>>Other</option>
            </select></div></div>
          <div class="form-group full"><label>Address</label><div class="field-wrap"><span class="fi top">📍</span><textarea name="address" placeholder="Your full address"><%=HtmlUtils.e(curAddress)%></textarea></div></div>
        </div>
        <div class="btn-row" style="margin-top:22px">
          <button type="submit" class="btn-save">💾 Save Changes</button>
          <a href="${pageContext.request.contextPath}/profile" class="btn-back">← Cancel</a>
        </div>
      </form>
    </div>
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
