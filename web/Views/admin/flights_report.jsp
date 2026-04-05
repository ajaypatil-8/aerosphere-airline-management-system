<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.controller.ReportFlightsServlet.FlightRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked") List<FlightRow> flights = (List<FlightRow>) request.getAttribute("flights");
    String gen = new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new Date());
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Flights Report – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>
<nav class="navbar"><a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
<div class="nav-links"><a href="${pageContext.request.contextPath}/reports" class="nav-link">← Reports</a><button onclick="window.print()" class="btn btn-secondary btn-sm">🖨 Print</button></div></nav>
<div class="page-wrapper"><div class="page-header animate-fadeup"><div><h1 class="page-title">✈ Flights Report</h1><p class="page-subtitle">Generated: <%= gen %></p></div></div>
<div class="table-wrap animate-fadeup">
<% if (flights == null || flights.isEmpty()) { %><div class="empty-state"><div class="empty-icon">✈</div><h3>No data</h3></div>
<% } else { %>
<table class="sc-table"><thead><tr><th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Dep</th><th>Arr</th><th>Price</th><th>Total</th><th>Available</th></tr></thead>
<tbody><% int i=0; for(FlightRow f : flights) { i++; %>
<tr><td><%= i %></td><td style="color:var(--sky-glow);font-weight:700"><%= f.flightNo %></td>
<td><%= f.source %> → <%= f.destination %></td><td style="font-size:.82rem"><%= f.departDate %></td>
<td style="font-size:.82rem"><%= f.departTime!=null?f.departTime.toString().substring(0,5):"—" %></td>
<td style="font-size:.82rem"><%= f.arrivalTime!=null?f.arrivalTime.toString().substring(0,5):"—" %></td>
<td style="color:var(--gold);font-weight:700">₹<%= String.format("%,.0f",f.price) %></td>
<td><%= f.totalSeats %></td><td style="color:#34D399;font-weight:600"><%= f.availableSeats %></td></tr>
<% } %></tbody></table><% } %></div></div>
<script>const s=document.getElementById('stars');for(let i=0;i<40;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}</script>
</body></html>
