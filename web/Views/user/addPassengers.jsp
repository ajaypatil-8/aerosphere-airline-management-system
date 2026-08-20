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
.field-wrap input,.field-wrap select{width:100%;background:var(--input-bg);border:1.5px solid var(--border);border-radius:9px;padding:10px 12px 10px 36px;color:var(--text);font-family:'Inter',sans-serif;font-size:.88rem;outline:none;transition:all .2s;appearance:none}
.field-wrap input:focus,.field-wrap select:focus{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow);background:var(--card-bg)}
.btn-submit{padding:12px 32px;background:var(--grad);color:#fff;border:none;border-radius:10px;font-family:'Fraunces',serif;font-size:.95rem;font-weight:700;cursor:pointer;transition:transform .15s,box-shadow .15s}
.btn-submit:hover{transform:translateY(-1px);box-shadow:0 5px 16px var(--sky-glow)}
input[type="date"]{color-scheme:light}
[data-theme="dark"] input[type="date"]{color-scheme:dark}
@media(max-width:640px){.pax-grid{grid-template-columns:1fr 1fr}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>
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
  <h1 class="page-title fu"><i class="ph-bold ph-suitcase"></i> Passenger Details</h1>
  <p class="page-subtitle fu">Enter details for all <%=seats%> passenger<%=seats>1?"s":""%></p>
  <form method="post" action="${pageContext.request.contextPath}/savePassengers">
    <input type="hidden" name="_csrf"      value="<%=csrfToken%>">
    <input type="hidden" name="bookingId"  value="<%=bookingId%>">
    <input type="hidden" name="seats"      value="<%=seats%>">
    <% for(int p=1;p<=seats;p++){ %>
    <div class="pax-card fu" style="animation-delay:<%=(p-1)*0.07%>s">
      <div class="pax-badge">Passenger <%=p%></div>
      <div class="pax-grid">
        <div class="form-group"><label>Full Name</label><div class="field-wrap"><span class="fi"><i class="ph-bold ph-user"></i></span><input type="text" name="full_name[]" required placeholder="Full name"></div></div>
        <div class="form-group"><label>Date of Birth</label><div class="field-wrap"><span class="fi"><i class="ph-bold ph-calendar-blank"></i></span><input type="date" name="dob[]" class="dob-input" required max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"></div></div>
        <div class="form-group"><label>Gender</label><div class="field-wrap"><span class="fi"><i class="ph-bold ph-user-circle"></i></span><select name="gender[]" required><option value="">Select</option><option value="Male">Male</option><option value="Female">Female</option><option value="Other">Other</option></select></div></div>
        <div class="form-group"><label>Phone</label><div class="field-wrap"><span class="fi"><i class="ph-bold ph-phone"></i></span><input type="tel" name="phone[]" required placeholder="Phone number"></div></div>
        <div class="form-group"><label>Email</label><div class="field-wrap"><span class="fi"><i class="ph-bold ph-envelope-simple"></i></span><input type="email" name="email[]" required placeholder="Email address"></div></div>
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
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.textContent=t==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();

// Auto-calculate age from DOB
function calcAge(dob){
  if(!dob) return '';
  var today=new Date(), birth=new Date(dob);
  var age=today.getFullYear()-birth.getFullYear();
  var m=today.getMonth()-birth.getMonth();
  if(m<0||(m===0&&today.getDate()<birth.getDate())) age--;
  return age;
}
document.querySelectorAll('.dob-input').forEach(function(input){
  input.addEventListener('change',function(){
    var age=calcAge(this.value);
    // Show age feedback next to the label
    var card=this.closest('.pax-card');
    var ageDisplay=card.querySelector('.age-display');
    if(!ageDisplay){
      ageDisplay=document.createElement('span');
      ageDisplay.className='age-display';
      ageDisplay.style.cssText='font-size:.75rem;color:var(--sky);font-weight:600;margin-left:6px';
      this.closest('.form-group').querySelector('label').appendChild(ageDisplay);
    }
    ageDisplay.textContent=age>=0?'('+age+' yrs)':'';
  });
});
</script>
<%@ include file="/Views/common/Footer.jsp" %>
</body></html>
