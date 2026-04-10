<%@ page import="java.util.List, java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    String numSeatsStr = request.getParameter("numSeats");
    int numSeats = 1;
    try { if (numSeatsStr != null) numSeats = Integer.parseInt(numSeatsStr); } catch(Exception ignored){}
    String error = (String) request.getAttribute("error");
    String src = request.getParameter("source"); if (src == null) src = "";
    String dst = request.getParameter("destination"); if (dst == null) dst = "";
    // FIX: HTML-escape user-controlled params to prevent XSS
    String srcE = HtmlUtils.e(src);
    String dstE = HtmlUtils.e(dst);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Search Results – AeroSphere</title>
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
.page-wrapper{max-width:1000px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
/* FLIGHT CARD */
.flight-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;margin-bottom:14px;transition:all .25s;box-shadow:var(--shadow);animation:fadeUp .4s ease both}
.flight-card:hover{border-color:var(--primary);box-shadow:var(--shadow-lg);transform:translateY(-2px)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fc-body{padding:20px 24px;display:grid;grid-template-columns:1fr auto 1fr auto;align-items:center;gap:20px}
.city{font-size:1.6rem;font-weight:900;letter-spacing:-1px}
.city-lbl{font-size:.76rem;color:var(--text-muted);margin-top:2px}
.city-time{font-size:.84rem;color:var(--primary);font-weight:600;margin-top:4px}
.middle{display:flex;flex-direction:column;align-items:center;gap:5px}
.fno{font-size:.72rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.8px}
.fline{display:flex;align-items:center;gap:5px;width:80px}
.fline-bar{flex:1;height:1px;background:var(--border)}
.price-col{text-align:right}
.price{font-size:1.5rem;font-weight:900;letter-spacing:-.5px}
.price-sub{font-size:.74rem;color:var(--text-muted);margin:3px 0 10px}
.fc-footer{padding:10px 24px;background:var(--bg);border-top:1px solid var(--border);display:flex;align-items:center;gap:20px}
.fmeta{font-size:.76rem;color:var(--text-muted)}
/* EMPTY */
.empty-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:60px 24px;text-align:center;box-shadow:var(--shadow)}
.empty-icon{font-size:3rem;margin-bottom:16px;opacity:.4}
/* BUTTONS */
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:9px;font-size:.84rem;font-weight:600;text-decoration:none;border:none;cursor:pointer;transition:all .2s}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 2px 8px var(--primary-glow)}.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-ghost{background:transparent;color:var(--text-muted);border:1px solid var(--border)}.btn-ghost:hover{border-color:var(--primary);color:var(--primary)}
.btn-sm{padding:6px 12px;font-size:.8rem}
.badge-full{background:rgba(239,68,68,.1);color:#DC2626;border:1px solid rgba(239,68,68,.2);padding:4px 12px;border-radius:99px;font-size:.76rem;font-weight:700}
[data-theme="dark"] .badge-full{color:#FCA5A5}
@media(max-width:700px){.fc-body{grid-template-columns:1fr 1fr}.middle{display:none}.page-header{flex-direction:column}}
</style>
</head>
<body>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link ">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/searchFlights"     class="nav-link active">🔍 Search</a>
        <a href="${pageContext.request.contextPath}/allFlights"        class="nav-link ">✈️ All Flights</a>
        <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link ">🎫 My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link ">💸 Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"           class="nav-link ">👤 Profile</a>
        <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">↩ Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <div class="page-title">
                <% if (!src.isEmpty() && !dst.isEmpty()) { %><%= srcE %> → <%= dstE %><% } else { %>Available Flights<% } %>
            </div>
            <div class="page-subtitle">
                <% if (flights != null) { %><%= flights.size() %> flight(s) found &middot; <%= numSeats %> seat(s)<% } %>
            </div>
        </div>
        <a href="javascript:history.back()" class="btn btn-ghost">← Modify Search</a>
    </div>

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>

    <% if (flights == null || flights.isEmpty()) { %>
        <div class="empty-card">
            <div class="empty-icon">🛫</div>
            <p style="color:var(--text-muted);font-size:1rem;margin-bottom:20px">No flights found for the selected route and date.</p>
            <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-primary">Try Another Search</a>
        </div>
    <% } else { %>
    <% int fi=0; for (Map<String,Object> f : flights) {
       fi++; int seatsAvail = (Integer) f.get("seats_available"); %>
        <div class="flight-card" style="animation-delay:<%= fi*0.07 %>s">
            <div class="fc-body">
                <div>
                    <div class="city"><%= f.get("source") %></div>
                    <div class="city-lbl">🛫 Departure</div>
                    <div class="city-time"><%= f.get("depart_time") %></div>
                </div>
                <div class="middle">
                    <div class="fno"><%= f.get("flight_no") %></div>
                    <div class="fline"><div class="fline-bar"></div><span style="color:var(--primary)">✈</span><div class="fline-bar"></div></div>
                </div>
                <div>
                    <div class="city"><%= f.get("destination") %></div>
                    <div class="city-lbl">🛬 Arrival</div>
                    <div class="city-time"><%= f.get("arrival_time") != null ? f.get("arrival_time") : "—" %></div>
                </div>
                <div class="price-col">
                    <div class="price">₹<%= String.format("%.0f",(Double)f.get("price")) %></div>
                    <div class="price-sub">per seat · <%= seatsAvail %> left</div>
                    <% if (userName == null) { %>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">Login to Book</a>
                    <% } else if (seatsAvail >= numSeats) { %>
                        <form action="${pageContext.request.contextPath}/bookFlight" method="post" style="display:inline">
                            <input type="hidden" name="flightId" value="<%= f.get("id") %>">
                            <input type="hidden" name="numSeats" value="<%= numSeats %>">
                            <button type="submit" class="btn btn-primary btn-sm">Book Now →</button>
                        </form>
                    <% } else { %><span class="badge-full">Full</span><% } %>
                </div>
            </div>
            <div class="fc-footer">
                <span class="fmeta">📅 <%= f.get("depart_date") %></span>
                <span class="fmeta">💺 <%= seatsAvail %> seats available</span>
            </div>
        </div>
    <% } %>
    <% } %>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
</script>
</body></html>
