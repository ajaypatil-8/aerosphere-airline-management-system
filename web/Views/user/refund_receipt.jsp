<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String userName=(String)session.getAttribute("userName");
  if(userName==null){response.sendRedirect(request.getContextPath()+"/login");return;}
  Integer refundId=(Integer)request.getAttribute("refundId");
  Double  amount  =(Double) request.getAttribute("amount");
  String  status  =(String) request.getAttribute("status");
  Object  approved=request.getAttribute("approvedAt");
  String  flightNo=(String) request.getAttribute("flightNo");
  String  paxName =(String) request.getAttribute("passengerName");
  if(amount==null)amount=0.0;
  String st=status!=null?status.toUpperCase():"PENDING";
  boolean isPending ="PENDING" .equals(st);
  boolean isApproved="APPROVED".equals(st);
  boolean isRejected="REJECTED".equals(st);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund Receipt – AeroSphere</title>
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

.page-wrap{max-width:480px;margin:0 auto;padding:36px 24px}
.receipt-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow-lg);text-align:center}
.receipt-top{padding:32px 24px 20px;border-bottom:1px solid var(--border);position:relative}
.receipt-top::before{content:'';position:absolute;top:0;left:0;right:0;height:4px;background:<%=isApproved?"var(--grad)":isRejected?"linear-gradient(135deg,#EF4444,#DC2626)":"linear-gradient(135deg,#F59E0B,#D97706)"%>}
.status-icon{font-size:3rem;margin-bottom:12px;display:block}
.status-title{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;letter-spacing:-.5px;margin-bottom:6px;color:<%=isApproved?"var(--emerald)":isRejected?"#EF4444":"#D97706"%>}
.status-msg{font-size:.85rem;color:var(--text-muted);margin-bottom:8px}
.receipt-id{font-size:.78rem;color:var(--text-muted)}
.info-box{margin:16px 20px 0;background:var(--bg);border:1px solid var(--border);border-radius:12px;overflow:hidden}
.info-row{display:flex;align-items:center;gap:12px;padding:13px 16px;border-bottom:1px solid var(--border);text-align:left}
.info-row:last-child{border-bottom:none}
.info-icon-box{width:32px;height:32px;background:var(--sky-glow);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0}
.info-label{font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:.4px;color:var(--text-muted)}
.info-value{font-size:.9rem;font-weight:600;margin-top:1px}
.amount-value{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;font-family:'Syne',sans-serif;font-size:1.15rem;font-weight:800}
.receipt-actions{padding:20px;display:flex;gap:10px;justify-content:center;border-top:1px solid var(--border)}
.btn-print{padding:9px 20px;background:var(--grad);color:#fff;border:none;border-radius:9px;font-family:'DM Sans',sans-serif;font-size:.83rem;font-weight:700;cursor:pointer;transition:transform .15s}
.btn-print:hover{transform:translateY(-1px)}
.btn-back{padding:9px 18px;border:1.5px solid var(--border);border-radius:9px;text-decoration:none;color:var(--text-muted);font-size:.83rem;font-weight:500;transition:all .2s}
.btn-back:hover{border-color:var(--sky);color:var(--sky)}
@media print{nav,.receipt-actions{display:none!important}}
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
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="as-nav-link active">💸 Refunds</a>
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
  <div class="receipt-card fu">
    <div class="receipt-top">
      <span class="status-icon"><%=isApproved?"✅":isRejected?"❌":"⏳"%></span>
      <div class="status-title"><%=isApproved?"Refund Approved":isRejected?"Refund Rejected":"Refund Pending"%></div>
      <div class="status-msg"><%=isApproved?"Your refund has been processed.":isRejected?"Your refund request was rejected.":"Your request is under review."%></div>
      <%if(refundId!=null){%><div class="receipt-id">Refund ID #<%=refundId%></div><%}%>
      <div class="info-box">
        <%if(flightNo!=null){%>
        <div class="info-row"><div class="info-icon-box">✈️</div><div><div class="info-label">Flight</div><div class="info-value"><%=flightNo%></div></div></div>
        <%}%>
        <%if(paxName!=null){%>
        <div class="info-row"><div class="info-icon-box">👤</div><div><div class="info-label">Passenger</div><div class="info-value"><%=paxName%></div></div></div>
        <%}%>
        <div class="info-row"><div class="info-icon-box">💰</div><div><div class="info-label">Refund Amount</div><div class="info-value amount-value">₹<%=String.format("%,.2f",amount)%></div></div></div>
        <div class="info-row"><div class="info-icon-box">📋</div><div><div class="info-label">Status</div><div class="info-value" style="color:<%=isApproved?"var(--emerald)":isRejected?"#EF4444":"#D97706"%>"><%=st%></div></div></div>
        <%if(isApproved&&approved!=null){%>
        <div class="info-row"><div class="info-icon-box">📅</div><div><div class="info-label">Processed On</div><div class="info-value"><%=approved.toString().substring(0,10)%></div></div></div>
        <%}%>
      </div>
    </div>
    <div class="receipt-actions">
      <button onclick="window.print()" class="btn-print">🖨 Print Receipt</button>
      <a href="${pageContext.request.contextPath}/userBookings" class="btn-back">← My Bookings</a>
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
