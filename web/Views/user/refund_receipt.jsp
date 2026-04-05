<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer refundId = (Integer) request.getAttribute("refundId");
    Double  amount   = (Double)  request.getAttribute("amount");
    String  status   = (String)  request.getAttribute("status");
    Object  approved = request.getAttribute("approvedAt");
    String  flightNo = (String)  request.getAttribute("flightNo");
    String  paxName  = (String)  request.getAttribute("passengerName");
    if (amount == null) amount = 0.0;
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund Receipt – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">← Refunds</a>
    <button onclick="window.print()" class="btn btn-secondary btn-sm">🖨 Print</button>
  </div>
</nav>
<div class="page-wrapper" style="max-width:520px;">
  <div class="card animate-fadeup" style="text-align:center;">
    <div style="font-size:3rem;margin-bottom:10px;"><%= "APPROVED".equals(status) ? "✅" : "REJECTED".equals(status) ? "❌" : "⏳" %></div>
    <div style="font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;margin-bottom:6px;">Refund <%= status != null ? status : "Pending" %></div>
    <div style="color:var(--muted);margin-bottom:24px;">Receipt #<%= refundId %></div>
    <div style="background:rgba(0,87,255,.06);border:1px solid rgba(0,87,255,.15);border-radius:12px;padding:20px;text-align:left;">
      <div class="info-row"><div class="info-icon">✈</div><div><div class="info-label">Flight</div><div class="info-value"><%= flightNo %></div></div></div>
      <div class="info-row"><div class="info-icon">👤</div><div><div class="info-label">Passenger</div><div class="info-value"><%= paxName %></div></div></div>
      <div class="info-row"><div class="info-icon">💰</div><div><div class="info-label">Refund Amount</div><div class="info-value" style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.2f", amount) %></div></div></div>
      <div class="info-row"><div class="info-icon">📅</div><div><div class="info-label">Processed On</div><div class="info-value"><%= approved != null ? approved.toString().substring(0,10) : "Pending" %></div></div></div>
    </div>
    <div style="margin-top:24px;display:flex;gap:12px;justify-content:center;">
      <a href="${pageContext.request.contextPath}/userRefundHistory" class="btn btn-secondary">← Back</a>
      <button onclick="window.print()" class="btn btn-primary">🖨 Print</button>
    </div>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<40;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
