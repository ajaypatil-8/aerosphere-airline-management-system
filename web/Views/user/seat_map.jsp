<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String flightId  = request.getParameter("flightId")     != null ? request.getParameter("flightId")     : "";
    String numSeats  = request.getParameter("numSeats")     != null ? request.getParameter("numSeats")     : "1";
    String flightNo  = request.getParameter("flightNo")     != null ? request.getParameter("flightNo")     : "";
    String source    = request.getParameter("source")       != null ? request.getParameter("source")       : "";
    String dest      = request.getParameter("destination")  != null ? request.getParameter("destination")  : "";
    int numSeatsInt = 1;
    try { numSeatsInt = Integer.parseInt(numSeats); if (numSeatsInt < 1) numSeatsInt = 1; } catch (NumberFormatException ignored) { numSeatsInt = 1; numSeats = "1"; }
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Select Seats – AeroSphere</title>
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
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.active{color:var(--primary);background:var(--primary-glow)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
/* PAGE */
.page-wrapper{max-width:1100px;margin:0 auto;padding:28px 24px}
.page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.page-title{font-size:1.4rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* FLIGHT INFO CARD */
.flight-info{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:18px 24px;display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:20px;box-shadow:var(--shadow);flex-wrap:wrap;animation:fadeUp .5s ease both .05s;position:relative;overflow:hidden}
.flight-info::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--primary),#34D399,var(--primary))}
.fi-route{display:flex;align-items:center;gap:14px}
.fi-code{font-size:1.6rem;font-weight:900;letter-spacing:-1px}
.fi-city{font-size:.76rem;color:var(--text-muted);margin-top:2px;text-align:center}
.fi-arrow{color:var(--primary);font-size:1.2rem;padding:0 4px}
.fi-meta{display:flex;gap:20px;flex-wrap:wrap}
.fi-item{text-align:center}
.fi-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted)}
.fi-value{font-weight:700;font-size:.9rem;margin-top:2px;color:var(--primary)}
/* LEGEND */
.legend{display:flex;gap:18px;align-items:center;margin-bottom:18px;flex-wrap:wrap;animation:fadeUp .5s ease both .1s}
.legend-item{display:flex;align-items:center;gap:7px;font-size:.82rem;color:var(--text-muted)}
.legend-dot{width:22px;height:22px;border-radius:6px}
.ld-available{background:var(--primary-glow);border:1.5px solid var(--primary)}
.ld-selected{background:var(--primary);border:1.5px solid var(--primary-dark)}
.ld-booked{background:rgba(239,68,68,.12);border:1.5px solid rgba(239,68,68,.3)}
/* TWO COL */
.two-col{display:grid;grid-template-columns:1fr 300px;gap:24px;align-items:start}
/* PLANE CARD */
.plane-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:22px;box-shadow:var(--shadow);animation:fadeUp .5s ease both .15s}
.plane-nose{text-align:center;margin-bottom:18px;font-size:2.2rem;opacity:.3}
.col-labels{display:grid;grid-template-columns:repeat(3,50px) 36px repeat(3,50px);gap:5px;justify-content:center;margin-bottom:8px}
.col-labels span{text-align:center;font-size:.68rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.05em}
.seat-row{display:grid;grid-template-columns:repeat(3,50px) 36px repeat(3,50px);gap:5px;justify-content:center;margin-bottom:5px;align-items:center}
.row-no{text-align:center;font-size:.74rem;color:var(--text-muted);line-height:50px}
.seat{width:50px;height:50px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:.76rem;font-weight:700;cursor:pointer;background:var(--primary-glow);border:1.5px solid var(--primary);color:var(--primary);transition:all .15s;user-select:none}
.seat:hover{background:rgba(16,185,129,.35);transform:scale(1.07)}
.seat.selected{background:var(--primary);border-color:var(--primary-dark);color:#fff;transform:scale(1.1);box-shadow:0 3px 10px var(--primary-glow)}
.seat.booked{background:rgba(239,68,68,.08);border-color:rgba(239,68,68,.25);color:rgba(239,68,68,.5);cursor:not-allowed}
.seat.booked:hover{transform:none}
/* SUMMARY PANEL */
.summary-panel{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:22px;position:sticky;top:74px;box-shadow:var(--shadow);animation:fadeUp .5s ease both .2s}
.sp-title{font-size:.82rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--primary);margin-bottom:16px;padding-bottom:10px;border-bottom:1px solid var(--border)}
.sp-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--border);font-size:.87rem}
.sp-row:last-of-type{border-bottom:none}
.sp-key{color:var(--text-muted)}
.sp-val{font-weight:600}
.selected-tags{display:flex;flex-wrap:wrap;gap:6px;margin-top:10px}
.seat-tag{background:var(--primary-glow);border:1px solid var(--primary);border-radius:6px;padding:4px 10px;font-size:.76rem;font-weight:700;color:var(--primary)}
.btn-proceed{width:100%;padding:13px;margin-top:16px;background:var(--primary);border:none;border-radius:10px;color:#fff;font-size:.92rem;font-weight:700;cursor:pointer;transition:all .2s;opacity:.45;pointer-events:none;box-shadow:0 3px 10px var(--primary-glow)}
.btn-proceed.ready{opacity:1;pointer-events:all}.btn-proceed.ready:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-back{display:block;text-decoration:none;color:var(--text-muted);border:1px solid var(--border);border-radius:8px;padding:9px 16px;text-align:center;font-size:.84rem;font-weight:600;margin-top:10px;transition:all .2s}
.btn-back:hover{border-color:var(--primary);color:var(--primary)}
@media(max-width:800px){.two-col{grid-template-columns:1fr}.summary-panel{position:static}}
@media(max-width:480px){.col-labels,.seat-row{grid-template-columns:repeat(3,42px) 28px repeat(3,42px)}.seat{width:42px;height:42px;font-size:.7rem}}
</style>
</head>
<body>
<nav class="navbar">
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
    <div class="page-header">
        <div>
            <div class="page-title">💺 Select Your Seats</div>
            <div class="page-subtitle">Choose <%= numSeatsInt %> seat<%= numSeatsInt > 1 ? "s" : "" %> for your journey</div>
        </div>
        <a href="${pageContext.request.contextPath}/searchFlights" class="nav-link" style="border:1px solid var(--border);border-radius:8px">← Change Flight</a>
    </div>

    <!-- FLIGHT INFO -->
    <div class="flight-info">
        <div class="fi-route">
            <div>
                <div class="fi-code"><%= source.length()>=3?source.substring(0,3).toUpperCase():source.toUpperCase() %></div>
                <div class="fi-city"><%= source %></div>
            </div>
            <div class="fi-arrow">✈ ──</div>
            <div>
                <div class="fi-code"><%= dest.length()>=3?dest.substring(0,3).toUpperCase():dest.toUpperCase() %></div>
                <div class="fi-city"><%= dest %></div>
            </div>
        </div>
        <div class="fi-meta">
            <div class="fi-item"><div class="fi-label">Flight</div><div class="fi-value"><%= flightNo %></div></div>
            <div class="fi-item"><div class="fi-label">Passengers</div><div class="fi-value"><%= numSeats %></div></div>
        </div>
    </div>

    <!-- LEGEND -->
    <div class="legend">
        <div class="legend-item"><div class="legend-dot ld-available"></div> Available</div>
        <div class="legend-item"><div class="legend-dot ld-selected"></div> Selected</div>
        <div class="legend-item"><div class="legend-dot ld-booked"></div> Booked</div>
    </div>

    <div class="two-col">
        <!-- SEAT MAP -->
        <div>
            <div class="plane-card">
                <div class="plane-nose">✈</div>
                <div class="col-labels">
                    <span>A</span><span>B</span><span>C</span><span></span><span>D</span><span>E</span><span>F</span>
                </div>
                <div id="seatMap"></div>
            </div>
        </div>

        <!-- SUMMARY -->
        <div class="summary-panel">
            <div class="sp-title">🎫 Booking Summary</div>
            <div class="sp-row"><span class="sp-key">Route</span><span class="sp-val" style="color:var(--primary)"><%= source.length()>=3?source.substring(0,3).toUpperCase():source %> → <%= dest.length()>=3?dest.substring(0,3).toUpperCase():dest %></span></div>
            <div class="sp-row"><span class="sp-key">Flight</span><span class="sp-val"><%= flightNo %></span></div>
            <div class="sp-row"><span class="sp-key">Passengers</span><span class="sp-val"><%= numSeats %></span></div>
            <div class="sp-row"><span class="sp-key">Selected</span><span class="sp-val" id="selectedCount" style="color:var(--primary)">0 / <%= numSeats %></span></div>
            <div class="selected-tags" id="selectedList"></div>
            <form action="${pageContext.request.contextPath}/bookFlight" method="post" id="proceedForm">
                <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
                <input type="hidden" name="flightId" value="<%= flightId %>">
                <input type="hidden" name="numSeats" value="<%= numSeats %>">
                <input type="hidden" name="selectedSeats" id="selectedSeatsInput" value="">
                <button type="submit" class="btn-proceed" id="proceedBtn">Proceed to Book →</button>
            </form>
            <a href="${pageContext.request.contextPath}/searchFlights" class="btn-back">← Back to Search</a>
        </div>
    </div>
</div>

<script>
// Theme
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}

// Seat Map Logic
const ROWS = 30, COLS = ['A','B','C','D','E','F'];
const MAX_SEATS = parseInt('<%= numSeats %>');
let selected = [];
let bookedSeats = [];

// Fetch booked seats then render
fetch('${pageContext.request.contextPath}/getBookedSeats?flightId=<%= flightId %>')
    .then(r => r.json())
    .then(data => { bookedSeats = data || []; renderMap(); })
    .catch(() => renderMap());

function renderMap() {
    const map = document.getElementById('seatMap');
    map.innerHTML = '';
    for (let row = 1; row <= ROWS; row++) {
        const rowEl = document.createElement('div');
        rowEl.className = 'seat-row';
        COLS.forEach((col, ci) => {
            if (ci === 3) {
                const aisle = document.createElement('div');
                aisle.className = 'row-no';
                aisle.textContent = row;
                rowEl.appendChild(aisle);
            }
            const seatId = row + col;
            const seat = document.createElement('div');
            seat.className = 'seat';
            seat.textContent = seatId;
            seat.dataset.seat = seatId;
            if (bookedSeats.includes(seatId)) {
                seat.classList.add('booked');
            } else {
                seat.addEventListener('click', () => toggleSeat(seat, seatId));
            }
            rowEl.appendChild(seat);
        });
        map.appendChild(rowEl);
    }
    updateSummary();
}

function toggleSeat(el, seatId) {
    if (el.classList.contains('booked')) return;
    if (el.classList.contains('selected')) {
        el.classList.remove('selected');
        selected = selected.filter(s => s !== seatId);
    } else {
        if (selected.length >= MAX_SEATS) {
            const first = selected[0];
            const firstEl = document.querySelector(`[data-seat="${first}"]`);
            if (firstEl) firstEl.classList.remove('selected');
            selected.shift();
        }
        el.classList.add('selected');
        selected.push(seatId);
    }
    updateSummary();
}

function updateSummary() {
    document.getElementById('selectedCount').textContent = selected.length + ' / ' + MAX_SEATS;
    document.getElementById('selectedSeatsInput').value = selected.join(',');
    const listEl = document.getElementById('selectedList');
    listEl.innerHTML = selected.map(s => `<span class="seat-tag">${s}</span>`).join('');
    const btn = document.getElementById('proceedBtn');
    if (selected.length === MAX_SEATS) {
        btn.classList.add('ready');
    } else {
        btn.classList.remove('ready');
    }
}
</script>
</body></html>
