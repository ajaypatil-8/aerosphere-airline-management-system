<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.controller.ReportBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked") List<BookingRow> bookings = (List<BookingRow>) request.getAttribute("bookings");
    String gen = new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new Date());
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Bookings Report – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>
<nav class="navbar"><a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
<div class="nav-links"><a href="${pageContext.request.contextPath}/reports" class="nav-link">← Reports</a><button onclick="window.print()" class="btn btn-secondary btn-sm">🖨 Print</button></div></nav>
<div class="page-wrapper"><div class="page-header animate-fadeup"><div><h1 class="page-title">🎫 Bookings Report</h1><p class="page-subtitle">Generated: <%= gen %></p></div></div>
<div class="table-wrap animate-fadeup">
<% if (bookings == null || bookings.isEmpty()) { %><div class="empty-state"><div class="empty-icon">🎫</div><h3>No data</h3></div>
<% } else { %>
<table class="sc-table"><thead><tr><th>#</th><th>ID</th><th>Passenger</th><th>Flight</th><th>Route</th><th>Seats</th><th>Amount</th><th>Status</th><th>Payment</th><th>Date</th></tr></thead>
<tbody><% int i=0; for(BookingRow b : bookings) { i++;
  String st=b.status!=null?b.status.toLowerCase():"booked";
  String bc=st.equals("paid")?"badge-paid":st.equals("cancelled")?"badge-cancelled":"badge-booked"; %>
<tr><td><%= i %></td><td style="color:var(--sky-glow)">#<%= b.id %></td><td><%= b.userName %></td><td><strong><%= b.flightNo %></strong></td>
<td><%= b.source %> → <%= b.destination %></td><td><%= b.seats %></td>
<td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f",b.amount) %></td>
<td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
<td style="font-size:.8rem"><%= b.paymentStatus %></td>
<td style="font-size:.8rem;color:var(--muted)"><%= b.bookingDate!=null?b.bookingDate.toString().substring(0,10):"—" %></td></tr>
<% } %></tbody></table><% } %></div></div>
<script>const s=document.getElementById('stars');for(let i=0;i<40;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}</script>
</body></html>
