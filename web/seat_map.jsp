<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String flightId  = request.getParameter("flightId")  != null ? request.getParameter("flightId")  : "";
    String numSeats  = request.getParameter("numSeats")  != null ? request.getParameter("numSeats")  : "1";
    String flightNo  = request.getParameter("flightNo")  != null ? request.getParameter("flightNo")  : "";
    String source    = request.getParameter("source")    != null ? request.getParameter("source")    : "";
    String dest      = request.getParameter("destination") != null ? request.getParameter("destination") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
    <style>
        .seat-page { max-width: 900px; margin: 0 auto; }

        /* Flight Info Card */
        .flight-info-card {
            background: rgba(0,87,255,.08); border: 1px solid var(--border-glow);
            border-radius: var(--radius); padding: 20px 24px;
            display: flex; align-items: center; justify-content: space-between;
            gap: 20px; margin-bottom: 24px; flex-wrap: wrap;
            animation: fadeUp .4s ease both;
        }
        .fi-route { display: flex; align-items: center; gap: 16px; }
        .fi-city-code { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; }
        .fi-arrow { color: var(--sky-glow); font-size: 1.5rem; }
        .fi-city-name { font-size: .78rem; color: var(--muted); margin-top: 2px; text-align: center; }
        .fi-meta { display: flex; gap: 20px; flex-wrap: wrap; }
        .fi-meta-item { text-align: center; }
        .fi-meta-label { font-size: .72rem; color: var(--muted); font-weight: 600; text-transform: uppercase; }
        .fi-meta-value { font-weight: 700; font-size: .95rem; margin-top: 2px; }

        /* Legend */
        .seat-legend {
            display: flex; gap: 20px; flex-wrap: wrap; align-items: center;
            margin-bottom: 20px; animation: fadeUp .4s .1s ease both; opacity: 0; animation-fill-mode: forwards;
        }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: .82rem; color: var(--muted); }
        .legend-dot { width: 20px; height: 20px; border-radius: 6px; }
        .legend-dot.available { background: rgba(0,87,255,.4); border: 1px solid var(--sky-glow); }
        .legend-dot.selected  { background: var(--gold); border: 1px solid var(--gold); }
        .legend-dot.booked    { background: rgba(239,68,68,.3); border: 1px solid rgba(239,68,68,.4); }

        /* Plane container */
        .plane-container {
            background: rgba(13,20,39,.7); border: 1px solid var(--border);
            border-radius: 20px; padding: 24px; margin-bottom: 24px;
            animation: fadeUp .4s .2s ease both; opacity: 0; animation-fill-mode: forwards;
        }
        .plane-nose {
            text-align: center; margin-bottom: 20px;
            font-size: 2.5rem; opacity: .4;
        }
        .aisle-label {
            display: grid; grid-template-columns: repeat(3, 52px) 40px repeat(3, 52px);
            gap: 6px; justify-content: center; margin-bottom: 8px;
        }
        .aisle-label span {
            text-align: center; font-size: .7rem; font-weight: 700;
            color: var(--muted); text-transform: uppercase; letter-spacing: .05em;
        }
        .seat-row {
            display: grid; grid-template-columns: repeat(3, 52px) 40px repeat(3, 52px);
            gap: 6px; justify-content: center; margin-bottom: 6px; align-items: center;
        }
        .seat-row-no {
            text-align: center; font-size: .75rem; color: var(--muted);
            line-height: 52px;
        }
        .seat {
            width: 52px; height: 52px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: .78rem; font-weight: 700; cursor: pointer;
            background: rgba(0,87,255,.15); border: 1px solid rgba(77,138,255,.3);
            color: var(--sky-glow); transition: all .15s; user-select: none;
        }
        .seat:hover { background: rgba(0,87,255,.3); border-color: var(--sky-glow); transform: scale(1.05); }
        .seat.selected { background: var(--gold); border-color: var(--gold); color: var(--ink); transform: scale(1.08); }
        .seat.booked { background: rgba(239,68,68,.15); border-color: rgba(239,68,68,.3); color: rgba(239,68,68,.6); cursor: not-allowed; }
        .seat.booked:hover { transform: none; }

        /* Summary panel */
        .summary-panel {
            background: rgba(13,20,39,.9); border: 1px solid var(--border-glow);
            border-radius: var(--radius); padding: 24px;
            position: sticky; top: 80px;
        }
        .sp-title { font-family: 'Syne', sans-serif; font-size: 1rem; font-weight: 700; margin-bottom: 16px; color: var(--sky-glow); }
        .sp-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid var(--border); font-size: .875rem; }
        .sp-row:last-of-type { border-bottom: none; }
        .sp-key { color: var(--muted); }
        .sp-val { font-weight: 600; }
        .selected-seats-list { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 8px; }
        .seat-tag { background: rgba(255,184,0,.15); border: 1px solid rgba(255,184,0,.3); border-radius: 6px; padding: 4px 10px; font-size: .78rem; font-weight: 700; color: var(--gold); }

        .two-col { display: grid; grid-template-columns: 1fr 300px; gap: 24px; align-items: start; }
        @media(max-width: 800px) { .two-col { grid-template-columns: 1fr; } .summary-panel { position: static; } }

        .btn-proceed { width: 100%; padding: 14px; margin-top: 16px; background: linear-gradient(90deg,var(--sky),var(--sky-glow)); border: none; border-radius: 10px; color: #fff; font-size: 1rem; font-weight: 700; cursor: pointer; transition: .2s; opacity: .5; pointer-events: none; }
        .btn-proceed.ready { opacity: 1; pointer-events: all; }
        .btn-proceed.ready:hover { opacity: .9; transform: translateY(-1px); }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="searchFlights"  class="nav-link">Search Flights</a>
        <a href="userBookings"   class="nav-link">My Bookings</a>
        <a href="logout"         class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">💺 Select Your Seats</h1>
            <p class="page-subtitle">Choose <%= numSeats %> seat<%= Integer.parseInt(numSeats) > 1 ? "s" : "" %> for your journey</p>
        </div>
        <a href="searchFlights" class="btn btn-ghost">← Change Flight</a>
    </div>

    <div class="seat-page">

        <!-- Flight Info -->
        <div class="flight-info-card">
            <div class="fi-route">
                <div>
                    <div class="fi-city-code" style="color:var(--gold);"><%= source.length()>=3?source.substring(0,3).toUpperCase():source.toUpperCase() %></div>
                    <div class="fi-city-name"><%= source %></div>
                </div>
                <div class="fi-arrow">✈ ───</div>
                <div>
                    <div class="fi-city-code" style="color:var(--sky-glow);"><%= dest.length()>=3?dest.substring(0,3).toUpperCase():dest.toUpperCase() %></div>
                    <div class="fi-city-name"><%= dest %></div>
                </div>
            </div>
            <div class="fi-meta">
                <div class="fi-meta-item">
                    <div class="fi-meta-label">Flight</div>
                    <div class="fi-meta-value" style="color:var(--sky-glow);">✈ <%= flightNo %></div>
                </div>
                <div class="fi-meta-item">
                    <div class="fi-meta-label">Passengers</div>
                    <div class="fi-meta-value"><%= numSeats %></div>
                </div>
            </div>
        </div>

        <!-- Legend -->
        <div class="seat-legend">
            <div class="legend-item"><div class="legend-dot available"></div> Available</div>
            <div class="legend-item"><div class="legend-dot selected"></div>  Selected</div>
            <div class="legend-item"><div class="legend-dot booked"></div>    Booked</div>
        </div>

        <div class="two-col">
            <!-- Seat Map -->
            <div>
                <div class="plane-container">
                    <div class="plane-nose">✈</div>
                    <div class="aisle-label">
                        <span>A</span><span>B</span><span>C</span><span></span><span>D</span><span>E</span><span>F</span>
                    </div>
                    <div id="seatMap">
                        <!-- Rows will be rendered by JS -->
                    </div>
                </div>
            </div>

            <!-- Summary Panel -->
            <div class="summary-panel">
                <div class="sp-title">🎫 Booking Summary</div>
                <div class="sp-row"><span class="sp-key">Route</span><span class="sp-val" style="color:var(--sky-glow);"><%= source.length()>=3?source.substring(0,3).toUpperCase():source %> → <%= dest.length()>=3?dest.substring(0,3).toUpperCase():dest %></span></div>
                <div class="sp-row"><span class="sp-key">Flight</span><span class="sp-val">✈ <%= flightNo %></span></div>
                <div class="sp-row"><span class="sp-key">Passengers</span><span class="sp-val"><%= numSeats %></span></div>
                <div class="sp-row">
                    <span class="sp-key">Selected</span>
                    <span class="sp-val" id="selectedCount" style="color:var(--gold);">0 / <%= numSeats %></span>
                </div>
                <div class="selected-seats-list" id="selectedList"></div>
                <form action="bookFlight" method="post" id="proceedForm">
                    <input type="hidden" name="flightId" value="<%= flightId %>">
                    <input type="hidden" name="numSeats" value="<%= numSeats %>">
                    <input type="hidden" name="selectedSeats" id="selectedSeatsInput" value="">
                    <button type="submit" class="btn-proceed" id="proceedBtn">Proceed to Book →</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.2+Math.random()*.4};`;
    s.appendChild(el);
}

const ROWS = 20;
const COLS = ['A','B','C','D','E','F'];
const required = parseInt('<%= numSeats %>');
const flightId  = '<%= flightId %>';
let bookedSeats  = new Set();
let selectedSeats = new Set();

// Render seat grid
function renderSeats() {
    const map = document.getElementById('seatMap');
    map.innerHTML = '';
    for (let r = 1; r <= ROWS; r++) {
        const row = document.createElement('div');
        row.className = 'seat-row';
        ['A','B','C','aisle','D','E','F'].forEach(col => {
            if (col === 'aisle') {
                const aisle = document.createElement('div');
                aisle.className = 'seat-row-no';
                aisle.textContent = r;
                row.appendChild(aisle);
            } else {
                const id = col + r;
                const seat = document.createElement('div');
                seat.className = 'seat';
                seat.textContent = id;
                seat.dataset.id = id;
                if (bookedSeats.has(id)) seat.classList.add('booked');
                if (selectedSeats.has(id)) seat.classList.add('selected');
                seat.addEventListener('click', toggleSeat);
                row.appendChild(seat);
            }
        });
        map.appendChild(row);
    }
}

function toggleSeat(e) {
    const id = e.currentTarget.dataset.id;
    if (bookedSeats.has(id)) return;
    if (selectedSeats.has(id)) {
        selectedSeats.delete(id);
        e.currentTarget.classList.remove('selected');
    } else {
        if (selectedSeats.size >= required) {
            const first = [...selectedSeats][0];
            selectedSeats.delete(first);
            document.querySelector(`.seat[data-id="${first}"]`)?.classList.remove('selected');
        }
        selectedSeats.add(id);
        e.currentTarget.classList.add('selected');
    }
    updateSummary();
}

function updateSummary() {
    const count = selectedSeats.size;
    document.getElementById('selectedCount').textContent = `${count} / ${required}`;
    const list = document.getElementById('selectedList');
    list.innerHTML = [...selectedSeats].map(id => `<span class="seat-tag">${id}</span>`).join('');
    document.getElementById('selectedSeatsInput').value = [...selectedSeats].join(',');
    const btn = document.getElementById('proceedBtn');
    if (count === required) btn.classList.add('ready');
    else btn.classList.remove('ready');
}

// Fetch booked seats from server
fetch(`getBookedSeats?flightId=${flightId}`)
    .then(r => r.json())
    .then(data => { bookedSeats = new Set(data); renderSeats(); })
    .catch(() => renderSeats());
</script>
</body>
</html>
