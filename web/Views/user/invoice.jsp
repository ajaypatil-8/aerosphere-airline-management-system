<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat, java.util.*" %>
<%@ page import="com.skyconnect.controller.InvoiceServlet.Passenger" %>
<%
    String userName2 = (String) session.getAttribute("userName");
    if (userName2 == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    DecimalFormat df = new DecimalFormat("0.00");
    Integer bookingId   = (Integer) request.getAttribute("bookingId");
    String  uName       = (String)  request.getAttribute("userName");
    String  userEmail   = (String)  request.getAttribute("userEmail");
    String  flightNo    = (String)  request.getAttribute("flightNo");
    String  source      = (String)  request.getAttribute("source");
    String  destination = (String)  request.getAttribute("destination");
    String  departDate  = (String)  request.getAttribute("departDate");
    String  departTime  = (String)  request.getAttribute("departTime");
    String  arrivalTime = (String)  request.getAttribute("arrivalTime");
    Integer seats       = (Integer) request.getAttribute("seats");
    Double  amount      = (Double)  request.getAttribute("amount");
    String  status      = (String)  request.getAttribute("status");
    Double  paidAmount  = (Double)  request.getAttribute("paidAmount");
    String  payMethod   = (String)  request.getAttribute("paymentMethod");
    String  payStatus   = (String)  request.getAttribute("paymentStatus");
    @SuppressWarnings("unchecked")
    List<Passenger> passengers = (List<Passenger>) request.getAttribute("passengers");
    if (amount == null) amount = 0.0;
    String statusClass = "paid".equalsIgnoreCase(status) ? "badge-paid" : "cancelled".equalsIgnoreCase(status) ? "badge-cancelled" : "badge-booked";
    // Only show download button if booking is paid/booked (not cancelled/pending)
    boolean showDownload = !"CANCELLED".equalsIgnoreCase(status) && !"PENDING".equalsIgnoreCase(status);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Invoice #<%= bookingId %> – AeroSphere</title>
<%-- FIX: Apply theme BEFORE any rendering to prevent flash --%>
<script>
(function(){
  var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');
  document.documentElement.setAttribute('data-theme',t);
})();
</script>
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
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:8px;font-size:.82rem;font-weight:600;text-decoration:none;border:1px solid var(--border);cursor:pointer;transition:all .2s;background:var(--card-bg);color:var(--text)}
.btn:hover{border-color:var(--primary);color:var(--primary)}
.btn-primary{background:var(--primary);color:#fff!important;border-color:var(--primary);box-shadow:0 3px 10px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);color:#fff}
.btn-pdf{background:rgba(239,68,68,.08);color:#DC2626;border-color:rgba(239,68,68,.2)}
.btn-pdf:hover{background:rgba(239,68,68,.14);color:#DC2626;border-color:rgba(239,68,68,.4)}
/* PAGE */
.page-wrapper{max-width:820px;margin:0 auto;padding:28px 24px}
/* INVOICE CARD */
.invoice-card{background:var(--card-bg);border:1px solid var(--border);border-top:3px solid var(--primary);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow-lg);animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.invoice-header{text-align:center;padding:28px 24px 24px;border-bottom:1px solid var(--border)}
.invoice-logo{font-size:1.5rem;font-weight:900;letter-spacing:-.5px;margin-top:6px}
.invoice-logo span{color:var(--primary)}
.invoice-id{font-size:.78rem;font-weight:600;color:var(--text-muted);letter-spacing:1px;text-transform:uppercase;margin-top:4px}
.badge{display:inline-flex;align-items:center;padding:4px 12px;border-radius:99px;font-size:.76rem;font-weight:700;margin-top:10px}
.badge-paid{background:rgba(16,185,129,.12);color:var(--primary);border:1px solid var(--primary)}
.badge-booked{background:rgba(59,130,246,.1);color:#2563EB;border:1px solid rgba(59,130,246,.3)}
[data-theme="dark"] .badge-booked{color:#93C5FD}
.badge-cancelled{background:rgba(239,68,68,.1);color:#DC2626;border:1px solid rgba(239,68,68,.2)}
[data-theme="dark"] .badge-cancelled{color:#FCA5A5}
.route-banner{display:flex;align-items:center;justify-content:space-between;background:var(--primary-glow);border-bottom:1px solid var(--border);padding:20px 28px}
.route-city{font-size:1.8rem;font-weight:900;letter-spacing:-1px}
.route-lbl{font-size:.74rem;color:var(--text-muted);margin-top:3px}
.route-mid{text-align:center}
.route-fno{font-size:.72rem;font-weight:700;color:var(--primary);text-transform:uppercase;letter-spacing:.8px;margin-bottom:6px}
.route-icon{font-size:1.5rem;color:var(--primary)}
.route-date{font-size:.72rem;color:var(--text-muted);margin-top:4px}
.invoice-body{padding:24px 28px}
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:28px}
.sec-title{font-size:.76rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--primary);margin-bottom:14px;padding-bottom:8px;border-bottom:1px solid var(--border)}
.info-row{display:flex;align-items:center;gap:12px;padding:8px 0;border-bottom:1px solid var(--border)}
.info-row:last-child{border-bottom:none}
.info-icon{width:30px;height:30px;background:var(--primary-glow);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0}
.info-label{font-size:.72rem;color:var(--text-muted);font-weight:600;text-transform:uppercase;letter-spacing:.3px}
.info-value{font-size:.88rem;font-weight:600;margin-top:1px}
.invoice-row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:.88rem}
.invoice-row:last-child{border-bottom:none}
.invoice-row .label{color:var(--text-muted)}
.invoice-total{display:flex;justify-content:space-between;padding:12px 0;border-top:2px solid var(--primary);margin-top:4px}
.invoice-total .label{font-weight:700;font-size:.95rem}
.invoice-total .value{font-size:1.2rem;font-weight:900;color:var(--primary)}
.table-section{padding:0 28px 20px}
.table-title{font-size:.76rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--primary);margin-bottom:12px;padding-bottom:8px;border-bottom:1px solid var(--border)}
table{width:100%;border-collapse:collapse}
thead th{padding:9px 12px;text-align:left;font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
tbody td{padding:10px 12px;font-size:.86rem;border-bottom:1px solid var(--border)}
tbody tr:last-child td{border-bottom:none}
.thank-you{margin:16px 28px 24px;background:var(--primary-glow);border:1px solid var(--primary);border-radius:11px;padding:16px 20px;text-align:center}
.thank-you strong{display:block;color:var(--primary);font-weight:700;margin-bottom:4px}
.thank-you small{font-size:.78rem;color:var(--text-muted)}
.actions{display:flex;gap:12px;justify-content:center;margin-top:20px;flex-wrap:wrap;animation:fadeUp .5s ease both .1s}
@media print{
    .navbar,.no-print,.actions{display:none!important}
    body{background:#fff;color:#000}
    .invoice-card{box-shadow:none;border:1px solid #ddd}
    :root{--bg:#fff;--card-bg:#fff;--text:#000;--text-muted:#555;--border:#ddd;--primary:#059669;--primary-glow:rgba(5,150,105,.1)}
}
@media(max-width:640px){.two-col{grid-template-columns:1fr}.route-banner{flex-direction:column;gap:12px;text-align:center}}
</style>
</head>
<body>

<nav class="navbar no-print">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link ">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link ">🔍 Search</a>
        <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link ">✈️ All Flights</a>
        <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link ">🎫 My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link ">💸 Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"           class="nav-link ">👤 Profile</a>
        <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">↩ Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="invoice-card">
        <!-- HEADER -->
        <div class="invoice-header">
            <div style="font-size:2rem">✈</div>
            <div class="invoice-logo">Aero<span>Sphere</span></div>
            <div class="invoice-id">Booking Invoice · #<%= bookingId %></div>
            <div><span class="badge <%= statusClass %>"><%= status != null ? status.toUpperCase() : "—" %></span></div>
        </div>

        <!-- ROUTE BANNER -->
        <div class="route-banner">
            <div>
                <div class="route-city"><%= source %></div>
                <div class="route-lbl">Departure · <%= departTime != null ? departTime.substring(0,5) : "—" %></div>
            </div>
            <div class="route-mid">
                <div class="route-fno"><%= flightNo %></div>
                <div class="route-icon">✈</div>
                <div class="route-date"><%= departDate %></div>
            </div>
            <div style="text-align:right">
                <div class="route-city"><%= destination %></div>
                <div class="route-lbl">Arrival · <%= arrivalTime != null && !arrivalTime.isEmpty() ? arrivalTime.substring(0,5) : "—" %></div>
            </div>
        </div>

        <!-- BODY -->
        <div class="invoice-body">
            <div class="two-col">
                <!-- PASSENGER INFO -->
                <div>
                    <div class="sec-title">Passenger Details</div>
                    <div class="info-row"><div class="info-icon">👤</div><div><div class="info-label">Name</div><div class="info-value"><%= uName %></div></div></div>
                    <div class="info-row"><div class="info-icon">✉</div><div><div class="info-label">Email</div><div class="info-value"><%= userEmail %></div></div></div>
                    <div class="info-row"><div class="info-icon">💺</div><div><div class="info-label">Seats</div><div class="info-value"><%= seats %></div></div></div>
                </div>
                <!-- PAYMENT INFO -->
                <div>
                    <div class="sec-title">Payment Details</div>
                    <div class="invoice-row"><span class="label">Base Fare</span><span>₹<%= df.format(amount) %></span></div>
                    <div class="invoice-row"><span class="label">GST (5%)</span><span>₹<%= df.format(amount * 0.05) %></span></div>
                    <% if (payMethod != null) { %>
                    <div class="invoice-row"><span class="label">Method</span><span><%= payMethod.replace("_"," ") %></span></div>
                    <% } %>
                    <div class="invoice-total">
                        <span class="label">Total Paid</span>
                        <span class="value">₹<%= paidAmount != null ? df.format(paidAmount) : df.format(amount * 1.05) %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- SEAT TABLE -->
        <% if (passengers != null && !passengers.isEmpty()) { %>
        <div class="table-section">
            <div class="table-title">Seat Allocation</div>
            <table>
                <thead><tr><th>#</th><th>Passenger Name</th><th>Age</th><th>Gender</th><th>Seat No</th></tr></thead>
                <tbody>
                <% int p=0; for(Passenger pass : passengers) { p++; %>
                <tr>
                    <td style="color:var(--text-muted)"><%= p %></td>
                    <td style="font-weight:600"><%= pass.name %></td>
                    <td><%= pass.age %></td>
                    <td><%= pass.gender %></td>
                    <td><strong style="color:var(--primary)"><%= pass.seatNo != null ? pass.seatNo : "Auto" %></strong></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <!-- THANK YOU -->
        <div class="thank-you">
            <strong>✅ Thank you for flying with AeroSphere!</strong>
            <small>Please carry a valid photo ID. Arrive at least 2 hours before departure.</small>
        </div>
    </div>

    <!-- ACTIONS — PDF download button added here -->
    <div class="actions no-print">
        <a href="${pageContext.request.contextPath}/userBookings" class="btn">← My Bookings</a>
        <button onclick="window.print()" class="btn btn-primary">🖨 Print Invoice</button>
        <% if (showDownload) { %>
        <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= bookingId %>&download=true"
           class="btn btn-pdf" title="Download PDF">
            📄 Download PDF
        </a>
        <% } %>
    </div>
</div>

<script>
// FIX: Read localStorage theme and set toggle icon immediately (no flash, no wrong icon)
(function(){
  var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');
  document.documentElement.setAttribute('data-theme',t);
  var btn=document.getElementById('themeToggle');
  if(btn) btn.textContent=t==='dark'?'☀️':'🌙';
})();
function toggleTheme(){
  var n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';
  document.documentElement.setAttribute('data-theme',n);
  localStorage.setItem('aerosphere-theme',n);
  document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';
}
</script>
</body></html>
