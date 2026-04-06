<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.skyconnect.util.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    String flightIdStr = request.getParameter("flightId");
    String numSeatsStr = request.getParameter("numSeats");
    if (flightIdStr == null) { response.sendRedirect(request.getContextPath() + "/searchFlights"); return; }

    int flightId = Integer.parseInt(flightIdStr);
    int numSeats = (numSeatsStr != null) ? Integer.parseInt(numSeatsStr) : 1;

    String flightNo="", source="", destination="", departDate="", departTime="", arrivalTime="";
    double price = 0;
    int seatsAvailable = 0;

    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM flights WHERE id = ?");
        ps.setInt(1, flightId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            flightNo       = rs.getString("flight_no");
            source         = rs.getString("source");
            destination    = rs.getString("destination");
            departDate     = rs.getString("depart_date");
            departTime     = rs.getString("depart_time");
            arrivalTime    = rs.getString("arrival_time");
            price          = rs.getDouble("price");
            seatsAvailable = rs.getInt("seats_available");
        }
    } catch (Exception e) { e.printStackTrace(); }

    double totalAmount = price * numSeats;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Confirm Booking – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
/* NAVBAR */
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
/* PAGE */
.page-wrapper{max-width:680px;margin:0 auto;padding:32px 24px}
/* STEPS */
.steps{display:flex;align-items:center;margin-bottom:32px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.step{display:flex;flex-direction:column;align-items:center;gap:5px}
.step-circle{width:34px;height:34px;border-radius:50%;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:700;color:var(--text-muted);background:var(--card-bg);transition:all .3s}
.step.done .step-circle{background:var(--primary);border-color:var(--primary);color:#fff}
.step.active .step-circle{border-color:var(--primary);color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.step-label{font-size:.7rem;font-weight:600;color:var(--text-muted);white-space:nowrap}
.step.done .step-label,.step.active .step-label{color:var(--primary)}
.step-line{flex:1;height:2px;background:var(--border);margin:0 6px;margin-bottom:18px;transition:background .3s}
.step-line.done{background:var(--primary)}
/* CARD */
.card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);animation:fadeUp .5s ease both .1s}
.card-inner{padding:28px}
/* ROUTE STRIP */
.route-strip{display:flex;align-items:center;justify-content:space-between;background:var(--primary-glow);border:1px solid var(--primary);border-radius:12px;padding:18px 24px;margin-bottom:20px}
.route-city-name{font-size:1.6rem;font-weight:900;letter-spacing:-1px}
.route-city-lbl{font-size:.74rem;color:var(--text-muted);margin-top:3px}
.route-icon{font-size:1.6rem;color:var(--primary)}
/* INFO GRID */
.info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px}
.info-item{background:var(--bg);border:1px solid var(--border);border-radius:10px;padding:12px 14px}
.info-item label{display:block;font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted);margin-bottom:4px}
.info-item span{font-size:.9rem;font-weight:600}
/* FARE BOX */
.fare-box{background:var(--bg);border:1px solid var(--border);border-radius:12px;padding:18px;margin-bottom:20px}
.fare-title{font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted);margin-bottom:12px}
.fare-row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:.88rem}
.fare-row:last-child{border-bottom:none}
.fare-row.total{font-weight:800;font-size:1rem;color:var(--primary);border-top:2px solid var(--primary);padding-top:12px;margin-top:4px}
.fare-row.total span:last-child{font-size:1.2rem}
/* FORM */
.field{margin-bottom:16px}
.field label{display:block;font-size:.76rem;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted);margin-bottom:7px}
.field-wrap{position:relative}
.field-icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:14px;pointer-events:none}
.field-wrap input{width:100%;background:var(--bg);border:1.5px solid var(--border);border-radius:10px;padding:11px 14px 11px 38px;color:var(--text);font-family:'Inter',sans-serif;font-size:.9rem;outline:none;transition:all .2s}
.field-wrap input:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
/* BUTTONS */
.btn-primary{display:flex;align-items:center;justify-content:center;gap:8px;width:100%;padding:14px;background:var(--primary);border:none;border-radius:11px;color:#fff;font-family:'Inter',sans-serif;font-size:.95rem;font-weight:700;cursor:pointer;transition:all .25s;box-shadow:0 5px 18px var(--primary-glow)}
.btn-primary:hover{background:var(--primary-dark);transform:translateY(-2px);box-shadow:0 8px 24px var(--primary-glow)}
.btn-primary:disabled{opacity:.5;cursor:not-allowed;transform:none}
.back-link{display:block;text-align:center;margin-top:14px;font-size:.84rem;color:var(--text-muted);text-decoration:none;transition:color .2s}
.back-link:hover{color:var(--primary)}
/* ALERT */
.alert-warn{padding:12px 16px;border-radius:10px;margin-bottom:16px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px;background:rgba(245,158,11,.08);border:1px solid rgba(245,158,11,.25);color:#D97706}
[data-theme="dark"] .alert-warn{color:#FCD34D}
hr.divider{border:none;border-top:1px solid var(--border);margin:20px 0}
</style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/searchFlights" class="nav-link">Search</a>
        <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">My Bookings</a>
        <a href="${pageContext.request.contextPath}/logout"        class="nav-link btn-danger">Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <!-- STEPS -->
    <div class="steps">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">2</div><div class="step-label">Confirm</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">3</div><div class="step-label">Passengers</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
    </div>

    <div class="card">
        <div class="card-inner">
            <h2 style="font-weight:800;font-size:1.3rem;margin-bottom:22px">✈ Confirm Your Booking</h2>

            <!-- ROUTE -->
            <div class="route-strip">
                <div><div class="route-city-name"><%= source %></div><div class="route-city-lbl">Origin</div></div>
                <div class="route-icon">✈</div>
                <div style="text-align:right"><div class="route-city-name"><%= destination %></div><div class="route-city-lbl">Destination</div></div>
            </div>

            <!-- INFO -->
            <div class="info-grid">
                <div class="info-item"><label>Flight No.</label><span style="color:var(--primary)"><%= flightNo %></span></div>
                <div class="info-item"><label>Date</label><span><%= departDate %></span></div>
                <div class="info-item"><label>Departure</label><span><%= departTime %></span></div>
                <div class="info-item"><label>Arrival</label><span><%= (arrivalTime != null && !arrivalTime.isEmpty()) ? arrivalTime : "—" %></span></div>
                <div class="info-item"><label>Seats Available</label><span><%= seatsAvailable %></span></div>
                <div class="info-item"><label>Price per Seat</label><span>₹ <%= String.format("%.2f", price) %></span></div>
            </div>

            <% if (seatsAvailable < numSeats) { %>
            <div class="alert-warn">⚠ Only <%= seatsAvailable %> seat(s) available. Please reduce seat count.</div>
            <% } %>

            <!-- FARE SUMMARY -->
            <div class="fare-box">
                <div class="fare-title">💰 Fare Summary</div>
                <div class="fare-row"><span>Price per Seat</span><span>₹ <%= String.format("%.2f", price) %></span></div>
                <div class="fare-row"><span>Number of Seats</span><span id="seatsDisplay"><%= numSeats %></span></div>
                <div class="fare-row total"><span>Total Amount</span><span id="totalDisplay">₹ <%= String.format("%.2f", totalAmount) %></span></div>
            </div>

            <hr class="divider">

            <form action="${pageContext.request.contextPath}/bookFlight" method="post">
                <input type="hidden" name="flightId" value="<%= flightId %>">
                <div class="field">
                    <label>Number of Seats</label>
                    <div class="field-wrap">
                        <span class="field-icon">💺</span>
                        <input type="number" name="numSeats" min="1" max="<%= seatsAvailable %>"
                               value="<%= numSeats %>" required oninput="updateTotal(this.value)">
                    </div>
                </div>
                <button type="submit" class="btn-primary" <%= seatsAvailable == 0 ? "disabled" : "" %>>
                    ✅ Confirm Booking →
                </button>
            </form>

            <a href="javascript:history.back()" class="back-link">← Back to Results</a>
        </div>
    </div>
</div>

<script>
const savedTheme=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',savedTheme);
document.getElementById('themeToggle').textContent=savedTheme==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
const pricePerSeat = <%= price %>;
function updateTotal(seats) {
    const n = Math.max(1, parseInt(seats)||1);
    document.getElementById('seatsDisplay').textContent = n;
    document.getElementById('totalDisplay').textContent = '₹ ' + (pricePerSeat * n).toFixed(2);
}
</script>
</body></html>
