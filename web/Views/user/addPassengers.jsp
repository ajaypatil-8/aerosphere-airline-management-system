<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil,com.skyconnect.util.HtmlUtils" %>
<%
  String userName=(String)session.getAttribute("userName");
  if(userName==null){response.sendRedirect(request.getContextPath()+"/login");return;}
  Integer bookingId=(Integer)request.getAttribute("bookingId");
  Integer seats    =(Integer)request.getAttribute("seats");
  if(seats==null)seats=1;
  String csrfToken=CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Passenger Details – AeroSphere</title>
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
.page-wrap{max-width:820px;margin:0 auto;padding:32px 24px}
/* STEPS */
.steps{display:flex;align-items:center;margin-bottom:28px}
.step{display:flex;flex-direction:column;align-items:center;gap:5px}
.step-circle{width:34px;height:34px;border-radius:50%;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:700;color:var(--text-muted);background:var(--card-bg);transition:all .3s}
.step.done .step-circle{background:var(--grad);border-color:transparent;color:#fff}
.step.active .step-circle{border-color:var(--sky);color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.step-label{font-size:.7rem;font-weight:600;color:var(--text-muted);white-space:nowrap}
.step.done .step-label,.step.active .step-label{color:var(--sky)}
.step-line{flex:1;height:2px;background:var(--border);margin:0 6px;margin-bottom:16px;transition:background .3s}
.step-line.done{background:var(--grad)}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.88rem;margin-bottom:22px}
/* PASSENGER CARD */
.pax-card{background:var(--card-bg);border:1.5px solid var(--border);border-radius:var(--radius);padding:24px 24px 20px;margin-bottom:18px;position:relative;box-shadow:var(--shadow);transition:border-color .2s}
.pax-card:hover{border-color:var(--sky)}
.pax-badge{position:absolute;top:-12px;left:20px;background:var(--grad);color:#fff;font-size:.73rem;font-weight:700;padding:3px 14px;border-radius:99px;letter-spacing:.3px}
.pax-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;margin-top:10px}
.pax-grid .full{grid-column:1/-1}
.form-group{display:flex;flex-direction:column;gap:6px}
.form-group label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.4px;color:var(--text-muted)}
.field-wrap{position:relative}
.fi{position:absolute;left:11px;top:50%;transform:translateY(-50%);font-size:13px;pointer-events:none}
.field-wrap input,.field-wrap select{width:100%;background:var(--input-bg);border:1.5px solid var(--border);border-radius:9px;padding:10px 12px 10px 36px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.88rem;outline:none;transition:all .2s;appearance:none}
.field-wrap input:focus,.field-wrap select:focus{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow);background:var(--card-bg)}
.btn-submit{padding:12px 32px;background:var(--grad);color:#fff;border:none;border-radius:10px;font-family:'Syne',sans-serif;font-size:.95rem;font-weight:700;cursor:pointer;transition:transform .15s,box-shadow .15s}
.btn-submit:hover{transform:translateY(-1px);box-shadow:0 5px 16px var(--sky-glow)}
@media(max-width:640px){.pax-grid{grid-template-columns:1fr 1fr}}
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
  <div class="steps fu">
    <div class="step done"><div class="step-circle">✓</div><div class="step-label">Select Flight</div></div>
    <div class="step-line done"></div>
    <div class="step done"><div class="step-circle">✓</div><div class="step-label">Review Booking</div></div>
    <div class="step-line done"></div>
    <div class="step active"><div class="step-circle">3</div><div class="step-label">Passengers</div></div>
    <div class="step-line"></div>
    <div class="step"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
  </div>
  <h1 class="page-title fu">🧳 Passenger Details</h1>
  <p class="page-subtitle fu">Enter details for all <%=seats%> passenger<%=seats>1?"s":""%></p>
  <form method="post" action="${pageContext.request.contextPath}/addPassengers">
    <input type="hidden" name="_csrf"      value="<%=csrfToken%>">
    <input type="hidden" name="bookingId"  value="<%=bookingId%>">
    <input type="hidden" name="seats"      value="<%=seats%>">
    <% for(int p=1;p<=seats;p++){ %>
    <div class="pax-card fu" style="animation-delay:<%=(p-1)*0.07%>s">
      <div class="pax-badge">Passenger <%=p%></div>
      <div class="pax-grid">
        <div class="form-group"><label>First Name</label><div class="field-wrap"><span class="fi">👤</span><input type="text" name="firstName_<%=p%>" required placeholder="First name"></div></div>
        <div class="form-group"><label>Last Name</label><div class="field-wrap"><span class="fi">👤</span><input type="text" name="lastName_<%=p%>" required placeholder="Last name"></div></div>
        <div class="form-group"><label>Age</label><div class="field-wrap"><span class="fi">🔢</span><input type="number" name="age_<%=p%>" min="1" max="120" required placeholder="Age"></div></div>
        <div class="form-group"><label>Gender</label><div class="field-wrap"><span class="fi">⚧</span><select name="gender_<%=p%>" required><option value="">Select</option><option value="Male">Male</option><option value="Female">Female</option><option value="Other">Other</option></select></div></div>
        <div class="form-group"><label>Nationality</label><div class="field-wrap"><span class="fi">🌍</span><input type="text" name="nationality_<%=p%>" placeholder="e.g. Indian"></div></div>
        <div class="form-group"><label>Passport / ID</label><div class="field-wrap"><span class="fi">🪪</span><input type="text" name="passportNo_<%=p%>" placeholder="ID number (optional)"></div></div>
      </div>
    </div>
    <%}%>
    <div class="fu" style="margin-top:8px">
      <button type="submit" class="btn-submit">Continue to Payment →</button>
    </div>
  </form>
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
