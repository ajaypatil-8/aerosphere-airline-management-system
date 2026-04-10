<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Map<String,Object>> flights = (List<Map<String,Object>>) request.getAttribute("flights");
    Boolean searched = (Boolean) request.getAttribute("searched");
    String error     = (String)  request.getAttribute("error");
    String srcParam  = request.getParameter("source")      != null ? request.getParameter("source") : "";
    String dstParam  = request.getParameter("destination")  != null ? request.getParameter("destination") : "";
    String datParam  = request.getParameter("departDate")   != null ? request.getParameter("departDate") : "";
    String seatsParam= request.getParameter("numSeats")     != null ? request.getParameter("numSeats") : "1";
    // FIX: safe parseInt — prevents NumberFormatException crash if URL is tampered
    int numSeatsInt = 1;
    try { numSeatsInt = Integer.parseInt(seatsParam); if (numSeatsInt < 1) numSeatsInt = 1; } catch (Exception ignored) { numSeatsInt = 1; seatsParam = "1"; }
    // FIX: HTML-escape user-controlled params to prevent XSS
    String srcParamE = HtmlUtils.e(srcParam);
    String dstParamE = HtmlUtils.e(dstParam);
    String datParamE = HtmlUtils.e(datParam);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Search Flights – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--accent:#A7F3D0;--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.active{color:var(--primary);background:var(--primary-glow)}
.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
.page-wrapper{max-width:1000px;margin:0 auto;padding:32px 24px}
.page-header{margin-bottom:24px}
.page-title{font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* SEARCH BAR */
.search-bar{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:22px 24px;margin-bottom:24px;display:grid;grid-template-columns:1fr 1fr 1fr 1fr auto;gap:12px;align-items:end;box-shadow:var(--shadow);position:relative;overflow:hidden}
.search-bar::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--primary),var(--accent),var(--primary))}
.search-bar label{display:block;font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:6px}
.search-bar input,.search-bar select{width:100%;padding:10px 12px;background:var(--bg);border:1.5px solid var(--border);border-radius:9px;color:var(--text);font-family:'Inter',sans-serif;font-size:.86rem;outline:none;transition:border-color .2s}
.search-bar input:focus,.search-bar select:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.search-bar input::placeholder{color:var(--text-muted);opacity:.6}
.btn-search{padding:10px 20px;background:var(--primary);color:#fff;border:none;border-radius:9px;font-weight:700;font-size:.86rem;cursor:pointer;transition:all .2s;box-shadow:0 3px 10px var(--primary-glow);white-space:nowrap}
.btn-search:hover{background:var(--primary-dark);transform:translateY(-1px)}
/* ALERTS */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
/* RESULTS COUNT */
.results-count{font-size:.86rem;color:var(--text-muted);margin-bottom:16px}
.results-count strong{color:var(--primary);font-weight:700}
/* FLIGHT CARD */
.flight-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;margin-bottom:14px;transition:all .25s;box-shadow:var(--shadow);animation:fadeUp .4s ease both}
.flight-card:hover{border-color:var(--primary);box-shadow:var(--shadow-lg);transform:translateY(-2px)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.flight-card-body{padding:20px 24px;display:grid;grid-template-columns:auto 1fr auto 1fr auto;align-items:center;gap:16px}
.city-block{}
.city-code{font-size:1.7rem;font-weight:900;letter-spacing:-1px}
.city-name{font-size:.76rem;color:var(--text-muted);margin-top:2px}
.flight-time{font-size:.82rem;color:var(--primary);font-weight:600;margin-top:4px}
.flight-center{display:flex;flex-direction:column;align-items:center;gap:6px;padding:0 8px}
.flight-no{font-size:.72rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.8px}
.flight-line{display:flex;align-items:center;gap:6px;width:100%}
.flight-line-bar{flex:1;height:1px;background:var(--border)}
.flight-line-icon{color:var(--primary);font-size:1rem}
.price-block{text-align:right}
.price-big{font-size:1.5rem;font-weight:900;letter-spacing:-.5px}
.price-sub{font-size:.74rem;color:var(--text-muted);margin-bottom:10px}
.flight-footer{padding:10px 24px;background:var(--bg);border-top:1px solid var(--border);display:flex;align-items:center;gap:20px}
.flight-meta-item{font-size:.76rem;color:var(--text-muted)}
/* EMPTY */
.empty-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:60px 24px;text-align:center;box-shadow:var(--shadow)}
.empty-icon{font-size:3rem;margin-bottom:16px;opacity:.4}
/* BUTTONS */
.btn{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:9px;font-size:.84rem;font-weight:600;text-decoration:none;border:none;cursor:pointer;transition:all .2s}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 2px 8px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-secondary{background:var(--bg);color:var(--text);border:1px solid var(--border)}
.btn-secondary:hover{border-color:var(--primary);color:var(--primary)}
.btn-sm{padding:6px 12px;font-size:.8rem}
/* FULL badge */
.badge-full{background:rgba(239,68,68,.1);color:#DC2626;border:1px solid rgba(239,68,68,.2);padding:4px 12px;border-radius:99px;font-size:.76rem;font-weight:700}
[data-theme="dark"] .badge-full{color:#FCA5A5}
@media(max-width:800px){.search-bar{grid-template-columns:1fr 1fr}.search-bar .btn-col{grid-column:1/-1}.flight-card-body{grid-template-columns:1fr auto 1fr;gap:12px}.flight-center{display:none}}
@media(max-width:500px){.search-bar{grid-template-columns:1fr}}
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
        <div class="page-title">🔍 Search Flights</div>
        <div class="page-subtitle">Find available flights for your journey</div>
    </div>

    <!-- SEARCH BAR -->
    <form action="${pageContext.request.contextPath}/searchFlights" method="get" class="search-bar">
        <div>
            <label>From</label>
            <input type="text" name="source" value="<%= srcParamE %>" placeholder="e.g. Mumbai" required>
        </div>
        <div>
            <label>To</label>
            <input type="text" name="destination" value="<%= dstParamE %>" placeholder="e.g. Delhi" required>
        </div>
        <div>
            <label>Date</label>
            <input type="date" name="departDate" value="<%= datParamE %>" required>
        </div>
        <div>
            <label>Passengers</label>
            <select name="numSeats">
                <% for (int i=1;i<=9;i++){%><option value="<%= i %>" <%= seatsParam.equals(String.valueOf(i))?"selected":"" %>><%= i %> Passenger<%= i>1?"s":"" %></option><%}%>
            </select>
        </div>
        <div class="btn-col"><button type="submit" class="btn-search">🔍 Search</button></div>
    </form>

    <% if (error != null) { %><div class="alert alert-error">⚠ <%= HtmlUtils.e(error) %></div><% } %>

    <% if (Boolean.TRUE.equals(searched)) { %>
        <% if (flights == null || flights.isEmpty()) { %>
            <div class="empty-card">
                <div class="empty-icon">✈</div>
                <h3 style="font-size:1.1rem;font-weight:700;margin-bottom:8px">No flights found</h3>
                <p style="color:var(--text-muted);font-size:.88rem">Try a different date or route</p>
            </div>
        <% } else { %>
            <p class="results-count"><strong><%= flights.size() %></strong> flight<%= flights.size()!=1?"s":"" %> found for <strong><%= srcParamE %> → <%= dstParamE %></strong> on <%= datParamE %></p>
            <% int fi=0; for (Map<String,Object> f : flights) { fi++;
               int avail = (Integer)f.get("seats_available"); %>
            <div class="flight-card" style="animation-delay:<%= fi*0.07 %>s">
                <div class="flight-card-body">
                    <div class="city-block">
                        <div class="city-code"><%= ((String)f.get("source")).substring(0,Math.min(3,((String)f.get("source")).length())).toUpperCase() %></div>
                        <div class="city-name"><%= f.get("source") %></div>
                        <div class="flight-time"><%= f.get("depart_time") %></div>
                    </div>
                    <div class="flight-center">
                        <div class="flight-no"><%= f.get("flight_no") %></div>
                        <div class="flight-line">
                            <div class="flight-line-bar"></div>
                            <div class="flight-line-icon">✈</div>
                            <div class="flight-line-bar"></div>
                        </div>
                    </div>
                    <div class="city-block">
                        <div class="city-code"><%= ((String)f.get("destination")).substring(0,Math.min(3,((String)f.get("destination")).length())).toUpperCase() %></div>
                        <div class="city-name"><%= f.get("destination") %></div>
                        <div class="flight-time"><%= f.get("arrival_time") != null ? f.get("arrival_time") : "—" %></div>
                    </div>
                    <div></div>
                    <div class="price-block">
                        <div class="price-big">₹<%= String.format("%,.0f",(Double)f.get("price")) %></div>
                        <div class="price-sub">per seat · <%= avail %> left</div>
                        <% if (avail >= numSeatsInt) { %>
                        <form action="${pageContext.request.contextPath}/bookFlight" method="post" style="margin:0">
                            <input type="hidden" name="flightId" value="<%= f.get("id") %>">
                            <input type="hidden" name="numSeats" value="<%= seatsParam %>">
                            <button type="submit" class="btn btn-primary btn-sm">Book Now →</button>
                        </form>
                        <% } else { %><span class="badge-full">Full</span><% } %>
                    </div>
                </div>
                <div class="flight-footer">
                    <span class="flight-meta-item">📅 <%= f.get("depart_date") %></span>
                    <span class="flight-meta-item">💺 <%= avail %> seats available</span>
                    <span class="flight-meta-item">👥 <%= seatsParam %> passenger<%= numSeatsInt>1?"s":"" %></span>
                    <span class="flight-meta-item" style="margin-left:auto;font-weight:700;color:var(--primary)">Total: ₹<%= String.format("%,.0f",(Double)f.get("price")*numSeatsInt) %></span>
                </div>
            </div>
            <% } %>
        <% } %>
    <% } %>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
document.querySelector('input[name="departDate"]').min=new Date().toISOString().split('T')[0];
</script>
</body></html>
