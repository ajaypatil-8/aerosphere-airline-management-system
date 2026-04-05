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
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Invoice #<%= bookingId %> – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar no-print">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userBookings" class="nav-link">← My Bookings</a>
    <button onclick="window.print()" class="btn btn-secondary btn-sm">🖨 Print</button>
    <a href="${pageContext.request.contextPath}/logout" class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper medium" style="padding-top:28px;">
  <div class="card animate-fadeup" style="border-top:3px solid var(--sky);">
    <!-- Invoice Header -->
    <div class="invoice-header" style="text-align:center;padding:20px 0 24px;">
      <div style="font-size:2rem;margin-bottom:4px;">✈</div>
      <div class="invoice-logo">SkyConnect</div>
      <div class="invoice-id">BOOKING INVOICE · #<%= bookingId %></div>
      <div style="margin-top:12px;"><span class="badge <%= statusClass %>" style="font-size:.85rem;padding:5px 16px;"><%= status != null ? status.toUpperCase() : "—" %></span></div>
    </div>

    <!-- Route Banner -->
    <div style="display:flex;align-items:center;justify-content:space-between;background:rgba(0,87,255,.08);border:1px solid rgba(0,87,255,.18);border-radius:14px;padding:20px 28px;margin-bottom:24px;">
      <div style="text-align:left;">
        <div style="font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;letter-spacing:-1px;"><%= source %></div>
        <div style="font-size:.78rem;color:var(--muted);">Departure · <%= departTime != null ? departTime.substring(0,5) : "—" %></div>
      </div>
      <div style="text-align:center;">
        <div style="color:var(--sky-glow);font-weight:700;font-size:.82rem;margin-bottom:6px;"><%= flightNo %></div>
        <div style="font-size:1.8rem;">✈</div>
        <div style="font-size:.72rem;color:var(--muted);margin-top:4px;"><%= departDate %></div>
      </div>
      <div style="text-align:right;">
        <div style="font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;letter-spacing:-1px;"><%= destination %></div>
        <div style="font-size:.78rem;color:var(--muted);">Arrival · <%= arrivalTime != null && !arrivalTime.isEmpty() ? arrivalTime.substring(0,5) : "—" %></div>
      </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">
      <!-- Passenger Info -->
      <div>
        <div class="section-label">Passenger Details</div>
        <div class="info-row"><div class="info-icon">👤</div><div><div class="info-label">Name</div><div class="info-value"><%= uName %></div></div></div>
        <div class="info-row"><div class="info-icon">✉️</div><div><div class="info-label">Email</div><div class="info-value"><%= userEmail %></div></div></div>
        <div class="info-row"><div class="info-icon">💺</div><div><div class="info-label">Seats</div><div class="info-value"><%= seats %></div></div></div>
      </div>
      <!-- Payment Info -->
      <div>
        <div class="section-label">Payment Details</div>
        <div class="invoice-row"><span class="label">Base Fare</span><span class="value">₹<%= df.format(amount) %></span></div>
        <div class="invoice-row"><span class="label">GST (5%)</span><span class="value">₹<%= df.format(amount * 0.05) %></span></div>
        <% if (payMethod != null) { %>
        <div class="invoice-row"><span class="label">Method</span><span class="value"><%= payMethod.replace("_"," ") %></span></div>
        <% } %>
        <div class="invoice-total">
          <span class="label">Total</span>
          <span class="value">₹<%= paidAmount != null ? df.format(paidAmount) : df.format(amount * 1.05) %></span>
        </div>
      </div>
    </div>

    <!-- Seats table -->
    <% if (passengers != null && !passengers.isEmpty()) { %>
    <div style="margin-top:24px;">
      <div class="section-label">Seat Allocation</div>
      <div class="table-wrap">
        <table class="sc-table">
          <thead><tr><th>#</th><th>Passenger Name</th><th>Age</th><th>Gender</th><th>Seat No</th></tr></thead>
          <tbody>
          <% int p=0; for(Passenger pass : passengers) { p++; %>
          <tr>
            <td class="text-dim"><%= p %></td>
            <td style="font-weight:600"><%= pass.name %></td>
            <td><%= pass.age %></td>
            <td><%= pass.gender %></td>
            <td><strong style="color:var(--sky-glow)"><%= pass.seatNo != null ? pass.seatNo : "Auto" %></strong></td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
    <% } %>

    <div style="text-align:center;margin-top:24px;padding:16px;background:rgba(16,185,129,.05);border:1px solid rgba(16,185,129,.15);border-radius:10px;">
      <div style="color:#34D399;font-weight:600;margin-bottom:4px;">✅ Thank you for flying with SkyConnect!</div>
      <div style="font-size:.78rem;color:var(--muted);">Please carry a valid photo ID. Arrive at least 2 hours before departure.</div>
    </div>
  </div>

  <div style="display:flex;gap:12px;justify-content:center;margin-top:20px;">
    <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-secondary">← My Bookings</a>
    <button onclick="window.print()" class="btn btn-primary">🖨 Print Invoice</button>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
