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
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Refund Receipt – AeroSphere</title>
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
.nav-links{display:flex;align-items:center;gap:8px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;font-size:.82rem;font-weight:600;text-decoration:none;border:1px solid var(--border);cursor:pointer;transition:all .2s;background:var(--card-bg);color:var(--text)}
.btn:hover{border-color:var(--primary);color:var(--primary)}
/* PAGE */
.page-wrapper{max-width:480px;margin:0 auto;padding:36px 24px}
/* RECEIPT CARD */
.receipt-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow-lg);text-align:center;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.receipt-top{padding:32px 24px 24px;border-bottom:1px solid var(--border)}
.status-icon{font-size:3rem;margin-bottom:12px;display:block}
.status-title{font-size:1.4rem;font-weight:800;letter-spacing:-.5px;margin-bottom:6px}
.receipt-id{font-size:.8rem;color:var(--text-muted)}
/* INFO BOX */
.info-box{margin:20px;background:var(--bg);border:1px solid var(--border);border-radius:12px;overflow:hidden}
.info-row{display:flex;align-items:center;gap:12px;padding:14px 18px;border-bottom:1px solid var(--border)}
.info-row:last-child{border-bottom:none}
.info-icon{width:32px;height:32px;background:var(--primary-glow);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0}
.info-label{font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:.3px;color:var(--text-muted)}
.info-value{font-size:.9rem;font-weight:600;margin-top:1px}
.amount-value{color:var(--primary);font-size:1.1rem;font-weight:800}
/* ACTIONS */
.receipt-actions{padding:20px;display:flex;gap:12px;justify-content:center;border-top:1px solid var(--border)}
.btn-primary{background:var(--primary);color:#fff;border-color:var(--primary);box-shadow:0 3px 10px var(--primary-glow)}.btn-primary:hover{background:var(--primary-dark);color:#fff}
/* PRINT */
@media print{.navbar,.no-print{display:none!important}body{background:#fff}:root{--bg:#fff;--card-bg:#fff;--text:#000;--border:#ddd;--primary:#059669;--primary-glow:rgba(5,150,105,.1)}}
</style>
</head>
<body>
<nav class="navbar no-print">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">← Refunds</a>
        <button onclick="window.print()" class="btn">🖨 Print</button>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="receipt-card">
        <div class="receipt-top">
            <span class="status-icon"><%= "APPROVED".equals(status) ? "✅" : "REJECTED".equals(status) ? "❌" : "⏳" %></span>
            <div class="status-title">Refund <%= status != null ? status : "Pending" %></div>
            <div class="receipt-id">Receipt #<%= refundId %></div>
        </div>
        <div class="info-box">
            <div class="info-row"><div class="info-icon">✈</div><div><div class="info-label">Flight</div><div class="info-value"><%= flightNo %></div></div></div>
            <div class="info-row"><div class="info-icon">👤</div><div><div class="info-label">Passenger</div><div class="info-value"><%= paxName %></div></div></div>
            <div class="info-row"><div class="info-icon">💰</div><div><div class="info-label">Refund Amount</div><div class="info-value amount-value">₹<%= String.format("%,.2f", amount) %></div></div></div>
            <div class="info-row"><div class="info-icon">📅</div><div><div class="info-label">Processed On</div><div class="info-value"><%= approved != null ? approved.toString().substring(0,10) : "Pending" %></div></div></div>
        </div>
        <div class="receipt-actions">
            <a href="${pageContext.request.contextPath}/userRefundHistory" class="btn">← Back</a>
            <button onclick="window.print()" class="btn btn-primary">🖨 Print</button>
        </div>
    </div>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
</script>
</body></html>
