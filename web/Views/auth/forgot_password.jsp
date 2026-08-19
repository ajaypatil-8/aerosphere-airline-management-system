<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String step    = (String) request.getAttribute("step");
    String email   = (String) request.getAttribute("email");
    if (step   == null) step  = "choose";
    if (email  == null) email = "";
    String csrfToken = "";
    try {
        csrfToken = com.skyconnect.util.CsrfUtil.getToken(request);
    } catch(Exception e) { /* csrf util may not exist yet */ }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>
:root{
  --sky:#2E4A3D;--sky-dark:#253D33;--sky-glow:rgba(46,74,61,.14);
  --em:#5B8A6E;--em-dark:#3E6350;--em-glow:rgba(91,138,110,.14);
  --grad:var(--sky);
  --bg:#FAFAF9;--s0:#FFFFFF;--s1:#F5F4F2;
  --text:#202A36;--muted:#6B7280;--border:#E7E5E4;
  --sh:0 1px 3px rgba(0,0,0,.05),0 4px 16px rgba(0,0,0,.04);
  --sh-lg:0 16px 56px rgba(0,0,0,.08);--r:16px;
}
[data-theme="dark"]{
  --sky:#4A7A63;--sky-dark:#5B8F76;--sky-glow:rgba(74,122,99,.18);
  --em:#6FAE8B;--em-dark:#5B9977;--em-glow:rgba(111,174,139,.16);
  --grad:var(--sky);
  --bg:#060B12;--s0:#11161D;--s1:#161C24;
  --text:#F4F4F3;--muted:#A8ADB4;--border:#232A33;
  --sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);
  --sh-lg:0 16px 56px rgba(0,0,0,.5);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px;position:relative;overflow:hidden}
body::before{content:'';position:fixed;width:700px;height:700px;border-radius:50%;background:radial-gradient(circle,var(--sky-glow),transparent 70%);top:-200px;left:-200px;pointer-events:none}
body::after{content:'';position:fixed;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,var(--em-glow),transparent 70%);bottom:-100px;right:-100px;pointer-events:none}

.fp-nav{position:fixed;top:20px;left:0;right:0;display:flex;justify-content:space-between;padding:0 24px;z-index:10;pointer-events:none}
.fp-nav a,.fp-nav button{pointer-events:all;display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:999px;font-size:.82rem;font-weight:500;text-decoration:none;border:1px solid var(--border);background:var(--s0);color:var(--muted);cursor:pointer;transition:all .2s;font-family:'Inter',sans-serif}
.fp-nav a:hover,.fp-nav button:hover{border-color:var(--sky);color:var(--sky)}

.fp-card{width:100%;max-width:480px;background:var(--s0);border:1px solid var(--border);border-radius:var(--r);box-shadow:var(--sh-lg);overflow:hidden;position:relative;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}
.fp-card-top{height:4px;background:var(--grad)}
.fp-card-body{padding:40px 36px}

.fp-icon{width:56px;height:56px;border-radius:16px;background:var(--sky-glow);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;margin:0 auto 18px;color:var(--sky)}
.fp-title{font-family:'Fraunces',serif;font-size:1.5rem;font-weight:400;letter-spacing:-.01em;text-align:center;margin-bottom:6px}
.fp-title span{color:var(--sky)}
.fp-sub{text-align:center;color:var(--muted);font-size:.86rem;line-height:1.55;margin-bottom:28px}

.alert{padding:12px 14px;border-radius:10px;font-size:.84rem;margin-bottom:20px;display:flex;align-items:flex-start;gap:8px}
.alert-error{background:rgba(179,85,74,.09);border:1px solid rgba(179,85,74,.22);color:#B3554A}
.alert-success{background:var(--em-glow);border:1px solid var(--em);color:var(--em-dark)}
[data-theme="dark"] .alert-error{color:#D99089}
[data-theme="dark"] .alert-success{color:#8FC5A8}

.method-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:24px}
.method-card{border:2px solid var(--border);border-radius:14px;padding:20px 16px;text-align:center;cursor:pointer;transition:all .2s;background:var(--s1);user-select:none}
.method-card:hover{border-color:var(--sky);background:var(--sky-glow)}
.method-card.selected{border-color:var(--sky);background:var(--sky-glow)}
.method-icon{font-size:1.6rem;margin-bottom:8px;color:var(--text)}
.method-card.selected .method-icon,.method-card:hover .method-icon{color:var(--sky)}
.method-title{font-family:'Fraunces',serif;font-weight:500;font-size:.92rem;margin-bottom:4px}
.method-desc{color:var(--muted);font-size:.75rem;line-height:1.4}

.fp-field{margin-bottom:16px}
.fp-field label{display:block;font-size:.68rem;font-weight:600;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);margin-bottom:7px}
.fp-field:focus-within label{color:var(--sky)}
.field-wrap{display:flex;align-items:center;gap:9px;background:var(--s1);border:1.5px solid var(--border);border-radius:10px;padding:0 13px;transition:border-color .2s,box-shadow .2s}
.field-wrap:focus-within{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.fi{font-size:.9rem;flex-shrink:0;color:var(--muted)}
.field-wrap input{flex:1;border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.9rem;padding:11px 0;outline:none}
.field-wrap input::placeholder{color:var(--muted);opacity:.65}
.pw-toggle{border:none;background:none;cursor:pointer;color:var(--muted);padding:0 4px;font-size:.85rem;transition:color .2s}
.pw-toggle:hover{color:var(--sky)}

.pw-strength{margin-top:6px;height:4px;border-radius:2px;background:var(--border);overflow:hidden}
.pw-strength-bar{height:100%;width:0;border-radius:2px;transition:width .3s,background .3s}
.pw-strength-label{font-size:.72rem;color:var(--muted);margin-top:4px}

.otp-row{display:flex;gap:10px;justify-content:center;margin:8px 0 20px}
.otp-box{width:48px;height:54px;border:1.5px solid var(--border);border-radius:10px;background:var(--s1);text-align:center;font-size:1.25rem;font-weight:500;font-family:'Fraunces',serif;color:var(--text);outline:none;transition:border-color .2s,box-shadow .2s}
.otp-box:focus{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.otp-hint{text-align:center;color:var(--muted);font-size:.8rem;margin-bottom:16px}
.resend-link{text-align:center;margin-top:10px;font-size:.82rem;color:var(--muted)}
.resend-link a{color:var(--sky);font-weight:600;cursor:pointer;text-decoration:none}
.resend-link a:hover{text-decoration:underline}

.btn-fp{width:100%;padding:14px;background:var(--grad);border:none;border-radius:999px;color:#fff;font-family:'Inter',sans-serif;font-size:.92rem;font-weight:500;cursor:pointer;box-shadow:0 6px 18px var(--sky-glow);transition:all .2s;display:flex;align-items:center;justify-content:center;gap:8px;margin-top:4px}
.btn-fp:hover{background:var(--sky-dark);transform:translateY(-1px);box-shadow:0 8px 22px var(--sky-glow)}
.btn-fp:active{transform:translateY(0)}
.btn-fp:disabled{opacity:.55;cursor:not-allowed;transform:none}

.step-indicator{display:flex;align-items:center;justify-content:center;gap:8px;margin-bottom:24px}
.step-dot{width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:600;border:2px solid var(--border);color:var(--muted);transition:all .3s}
.step-dot.active{border-color:var(--sky);background:var(--sky);color:#fff}
.step-dot.done{border-color:var(--em);background:var(--em);color:#fff}
.step-line{flex:1;height:2px;background:var(--border);border-radius:1px;max-width:40px;transition:background .3s}
.step-line.done{background:var(--em)}

.fp-back{text-align:center;margin-top:20px;font-size:.84rem;color:var(--muted)}
.fp-back a{color:var(--sky);font-weight:600;text-decoration:none}
.fp-back a:hover{text-decoration:underline}

@media(max-width:480px){
  .fp-card-body{padding:28px 20px}
  .method-grid{grid-template-columns:1fr}
  .otp-box{width:40px;height:48px;font-size:1.1rem}
}
</style>
</head>
<body>

<div class="fp-nav">
  <a href="${pageContext.request.contextPath}/"><i class="ph-bold ph-arrow-left"></i> Home</a>
  <button id="themeToggle"><i class="ph-bold ph-moon"></i></button>
</div>

<div class="fp-card">
  <div class="fp-card-top"></div>
  <div class="fp-card-body">

    <div class="fp-icon"><i class="ph-bold ph-key"></i></div>
    <h1 class="fp-title">Reset <span>password</span></h1>

    <%-- ═══ STEP: CHOOSE METHOD ═══ --%>
    <% if ("choose".equals(step)) { %>
      <p class="fp-sub">Choose how you'd like to reset your password</p>

      <% if (error != null) { %>
        <div class="alert alert-error"><span><i class="ph-bold ph-warning"></i></span><span><%= HtmlUtils.e(error) %></span></div>
      <% } %>

      <div class="method-grid">
        <div class="method-card" id="methodOtp" onclick="selectMethod('otp')">
          <div class="method-icon"><i class="ph-bold ph-envelope-simple"></i></div>
          <div class="method-title">Email OTP</div>
          <div class="method-desc">Get a one-time code sent to your registered email</div>
        </div>
        <div class="method-card" id="methodOld" onclick="selectMethod('old')">
          <div class="method-icon"><i class="ph-bold ph-lock-simple"></i></div>
          <div class="method-title">Old Password</div>
          <div class="method-desc">Use your current password to set a new one</div>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/forgotPassword" method="post" id="chooseForm">
        <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="action" id="chooseAction" value="sendOtp">

        <div class="fp-field" id="emailField">
          <label>Your Email Address</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-envelope-simple"></i></span>
            <input type="email" name="email" placeholder="you@example.com" required autocomplete="email" id="emailInput">
          </div>
        </div>

        <button type="submit" class="btn-fp" id="chooseBtn"><i class="ph-bold ph-envelope-simple"></i> Send OTP</button>
      </form>

    <%-- ═══ STEP: ENTER OTP ═══ --%>
    <% } else if ("otp".equals(step)) { %>

      <div class="step-indicator">
        <div class="step-dot done"><i class="ph-bold ph-check"></i></div>
        <div class="step-line done"></div>
        <div class="step-dot active">2</div>
        <div class="step-line"></div>
        <div class="step-dot">3</div>
      </div>

      <p class="fp-sub">Enter the 6-digit code we sent to <strong><%= HtmlUtils.e(email) %></strong></p>

      <% if (error != null) { %>
        <div class="alert alert-error"><span><i class="ph-bold ph-warning"></i></span><span><%= HtmlUtils.e(error) %></span></div>
      <% } %>

      <form action="${pageContext.request.contextPath}/forgotPassword" method="post" id="otpForm">
        <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="action" value="verifyOtp">
        <input type="hidden" name="email" value="<%= HtmlUtils.e(email) %>">
        <input type="hidden" name="otp" id="otpHidden" value="">

        <div class="otp-hint">Code expires in <span id="otpTimer" style="color:var(--sky);font-weight:700">10:00</span></div>
        <div class="otp-row">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o1" autocomplete="one-time-code">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o2">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o3">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o4">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o5">
          <input class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" id="o6">
        </div>

        <button type="submit" class="btn-fp" id="verifyBtn" disabled><i class="ph-bold ph-check"></i> Verify code</button>

        <div class="resend-link">
          Didn't receive it? <a href="${pageContext.request.contextPath}/forgotPassword?resend=1&email=<%= HtmlUtils.e(email) %>">Resend OTP</a>
        </div>
      </form>

    <%-- ═══ STEP: NEW PASSWORD (after OTP verified) ═══ --%>
    <% } else if ("newpass".equals(step)) { %>

      <div class="step-indicator">
        <div class="step-dot done"><i class="ph-bold ph-check"></i></div>
        <div class="step-line done"></div>
        <div class="step-dot done"><i class="ph-bold ph-check"></i></div>
        <div class="step-line done"></div>
        <div class="step-dot active">3</div>
      </div>

      <p class="fp-sub">OTP verified — set your new password</p>

      <% if (error != null) { %>
        <div class="alert alert-error"><span><i class="ph-bold ph-warning"></i></span><span><%= HtmlUtils.e(error) %></span></div>
      <% } %>

      <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
        <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="action" value="resetPassword">
        <input type="hidden" name="email" value="<%= HtmlUtils.e(email) %>">

        <div class="fp-field">
          <label>New Password</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-lock-simple"></i></span>
            <input type="password" name="newPassword" id="newPw" placeholder="Min. 8 characters" required minlength="8" oninput="checkPwStrength(this.value)">
            <button type="button" class="pw-toggle" onclick="togglePw('newPw')"><i class="ph-bold ph-eye"></i></button>
          </div>
          <div class="pw-strength"><div class="pw-strength-bar" id="pwBar"></div></div>
          <div class="pw-strength-label" id="pwLabel"> </div>
        </div>

        <div class="fp-field">
          <label>Confirm New Password</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-key"></i></span>
            <input type="password" name="confirmPassword" id="confPw" placeholder="Repeat your password" required minlength="8" oninput="checkMatch()">
            <button type="button" class="pw-toggle" onclick="togglePw('confPw')"><i class="ph-bold ph-eye"></i></button>
          </div>
          <div style="font-size:.74rem;margin-top:4px" id="matchLabel"> </div>
        </div>

        <button type="submit" class="btn-fp"><i class="ph-bold ph-key"></i> Reset password</button>
      </form>

    <%-- ═══ STEP: OLD PASSWORD METHOD ═══ --%>
    <% } else if ("oldpass".equals(step)) { %>

      <p class="fp-sub">Verify your identity with your current password, then set a new one</p>

      <% if (error != null) { %>
        <div class="alert alert-error"><span><i class="ph-bold ph-warning"></i></span><span><%= HtmlUtils.e(error) %></span></div>
      <% } %>

      <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
        <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="action" value="changeWithOld">

        <div class="fp-field">
          <label>Email Address</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-envelope-simple"></i></span>
            <input type="email" name="email" placeholder="you@example.com" required autocomplete="email">
          </div>
        </div>

        <div class="fp-field">
          <label>Current Password</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-lock-simple"></i></span>
            <input type="password" name="oldPassword" id="oldPw" placeholder="Your current password" required>
            <button type="button" class="pw-toggle" onclick="togglePw('oldPw')"><i class="ph-bold ph-eye"></i></button>
          </div>
        </div>

        <div class="fp-field">
          <label>New Password</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-key"></i></span>
            <input type="password" name="newPassword" id="newPw2" placeholder="Min. 8 characters" required minlength="8" oninput="checkPwStrength(this.value)">
            <button type="button" class="pw-toggle" onclick="togglePw('newPw2')"><i class="ph-bold ph-eye"></i></button>
          </div>
          <div class="pw-strength"><div class="pw-strength-bar" id="pwBar"></div></div>
          <div class="pw-strength-label" id="pwLabel"> </div>
        </div>

        <div class="fp-field">
          <label>Confirm New Password</label>
          <div class="field-wrap">
            <span class="fi"><i class="ph-bold ph-key"></i></span>
            <input type="password" name="confirmPassword" id="confPw2" placeholder="Repeat new password" required minlength="8" oninput="checkMatch2()">
            <button type="button" class="pw-toggle" onclick="togglePw('confPw2')"><i class="ph-bold ph-eye"></i></button>
          </div>
          <div style="font-size:.74rem;margin-top:4px" id="matchLabel2"> </div>
        </div>

        <button type="submit" class="btn-fp"><i class="ph-bold ph-key"></i> Change password</button>
      </form>

    <%-- ═══ STEP: SUCCESS ═══ --%>
    <% } else if ("success".equals(step)) { %>

      <div style="text-align:center;padding:16px 0">
        <div style="font-size:2.6rem;margin-bottom:16px;color:var(--em)"><i class="ph-bold ph-confetti"></i></div>
        <% if (success != null) { %>
          <div class="alert alert-success" style="text-align:left"><span><i class="ph-bold ph-check-circle"></i></span><span><%= HtmlUtils.e(success) %></span></div>
        <% } else { %>
          <div class="alert alert-success"><span><i class="ph-bold ph-check-circle"></i></span><span>Password reset successfully!</span></div>
        <% } %>
        <p style="color:var(--muted);font-size:.88rem;margin-bottom:24px">You can now sign in with your new password.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn-fp" style="display:inline-flex;text-decoration:none;width:auto;padding:12px 32px">Sign In →</a>
      </div>

    <% } %>

    <div class="fp-back">
      <a href="${pageContext.request.contextPath}/login">← Back to Login</a>
    </div>

  </div>
</div>

<script>
(function(){
  var t=localStorage.getItem('asTheme')||'light';
  document.documentElement.setAttribute('data-theme',t);
  document.getElementById('themeToggle').innerHTML=t==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';
})();
document.getElementById('themeToggle').addEventListener('click',function(){
  var c=document.documentElement.getAttribute('data-theme');
  var n=c==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',n);
  localStorage.setItem('asTheme',n);
  this.innerHTML=n==='dark'?'<i class="ph-bold ph-sun"></i>':'<i class="ph-bold ph-moon"></i>';
});

var selectedMethod='otp';
function selectMethod(m){
  selectedMethod=m;
  document.getElementById('methodOtp').classList.toggle('selected', m==='otp');
  document.getElementById('methodOld').classList.toggle('selected', m==='old');
  if(m==='otp'){
    document.getElementById('chooseAction').value='sendOtp';
    document.getElementById('chooseBtn').innerHTML='<i class="ph-bold ph-envelope-simple"></i> Send OTP';
  } else {
    document.getElementById('chooseAction').value='useOldPass';
    document.getElementById('chooseBtn').innerHTML='<i class="ph-bold ph-lock-simple"></i> Continue with old password';
  }
}
if(document.getElementById('methodOtp')) selectMethod('otp');

var boxes=['o1','o2','o3','o4','o5','o6'].map(id=>document.getElementById(id)).filter(Boolean);
boxes.forEach(function(box,i){
  box.addEventListener('input',function(){
    this.value=this.value.replace(/\D/,'');
    if(this.value&&i<boxes.length-1) boxes[i+1].focus();
    checkOtpComplete();
  });
  box.addEventListener('keydown',function(e){
    if(e.key==='Backspace'&&!this.value&&i>0) boxes[i-1].focus();
    if(e.key==='ArrowLeft'&&i>0) boxes[i-1].focus();
    if(e.key==='ArrowRight'&&i<boxes.length-1) boxes[i+1].focus();
  });
  box.addEventListener('paste',function(e){
    e.preventDefault();
    var paste=(e.clipboardData||window.clipboardData).getData('text').replace(/\D/g,'').slice(0,6);
    paste.split('').forEach(function(ch,j){ if(boxes[i+j]) boxes[i+j].value=ch; });
    var last=Math.min(i+paste.length,boxes.length-1);
    boxes[last].focus();
    checkOtpComplete();
  });
});
function checkOtpComplete(){
  var code=boxes.map(b=>b.value).join('');
  var hidden=document.getElementById('otpHidden');
  var btn=document.getElementById('verifyBtn');
  if(hidden) hidden.value=code;
  if(btn) btn.disabled=code.length<6;
}

if(document.getElementById('otpTimer')){
  var secs=600;
  var timer=setInterval(function(){
    secs--;
    if(secs<=0){clearInterval(timer);document.getElementById('otpTimer').textContent='Expired';document.getElementById('otpTimer').style.color='#B3554A';if(document.getElementById('verifyBtn'))document.getElementById('verifyBtn').disabled=true;return;}
    var m=Math.floor(secs/60), s=secs%60;
    document.getElementById('otpTimer').textContent=(m<10?'0':'')+m+':'+(s<10?'0':'')+s;
  },1000);
}

function checkPwStrength(pw){
  var bar=document.getElementById('pwBar');
  var lbl=document.getElementById('pwLabel');
  if(!bar||!lbl) return;
  var score=0;
  if(pw.length>=8) score++;
  if(/[A-Z]/.test(pw)) score++;
  if(/[0-9]/.test(pw)) score++;
  if(/[^A-Za-z0-9]/.test(pw)) score++;
  var labels=['','Weak','Fair','Good','Strong'];
  var colors=['','#B3554A','#B8863F','#2E4A3D','#5B8A6E'];
  bar.style.width=(score*25)+'%';
  bar.style.background=colors[score]||'#B3554A';
  lbl.textContent=pw.length>0?(labels[score]||'Weak'):'';
  lbl.style.color=colors[score]||'';
}

function checkMatch(){
  var n=document.getElementById('newPw'), c=document.getElementById('confPw'), l=document.getElementById('matchLabel');
  if(!n||!c||!l) return;
  if(!c.value){l.textContent='';return;}
  l.textContent=n.value===c.value?'✓ Passwords match':'✗ Passwords do not match';
  l.style.color=n.value===c.value?'#5B8A6E':'#B3554A';
}
function checkMatch2(){
  var n=document.getElementById('newPw2'), c=document.getElementById('confPw2'), l=document.getElementById('matchLabel2');
  if(!n||!c||!l) return;
  if(!c.value){l.textContent='';return;}
  l.textContent=n.value===c.value?'✓ Passwords match':'✗ Passwords do not match';
  l.style.color=n.value===c.value?'#5B8A6E':'#B3554A';
}

function togglePw(id){
  var i=document.getElementById(id);
  if(i) i.type=i.type==='password'?'text':'password';
}
</script>
</body>
</html>
