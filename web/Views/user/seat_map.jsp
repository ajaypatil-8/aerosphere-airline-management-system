<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.flightapp.model.*, com.flightapp.dao.*, java.util.*" %>
<%
    HttpSession sess = request.getSession(false);
    String userEmail = (sess != null) ? (String) sess.getAttribute("userEmail") : null;
    if (userEmail == null) { response.sendRedirect("login.jsp"); return; }

    // ── Preserve all existing attribute/param reads ──
    String bookingId    = request.getParameter("bookingId");
    if (bookingId == null) bookingId = (String) request.getAttribute("bookingId");

    String flightNo     = (String) request.getAttribute("flightNo");
    String from         = (String) request.getAttribute("from");
    String to           = (String) request.getAttribute("to");
    String travelClass  = (String) request.getAttribute("travelClass");
    int    passCount    = 1;
    try {
        String pc = (String) request.getAttribute("passengers");
        if (pc != null) passCount = Integer.parseInt(pc.trim());
    } catch(Exception e) { /* default 1 */ }

    // Occupied seats — comma-separated string from servlet/DAO
    String occupiedSeatsStr = (String) request.getAttribute("occupiedSeats");
    if (occupiedSeatsStr == null) occupiedSeatsStr = "";

    // Pre-selected seats (if re-visiting) — comma-separated
    String selectedSeatsStr = (String) request.getAttribute("selectedSeats");
    if (selectedSeatsStr == null) selectedSeatsStr = "";
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia&&window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
    <title>Seat Selection — <%= flightNo != null ? flightNo : "Flight" %></title>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css"/>

    <style>
        .sm-page {
            min-height: 100vh;
            background: var(--bg-0);
            background-image:
                radial-gradient(ellipse 50% 40% at 80% 10%, var(--primary-glow) 0%, transparent 65%),
                radial-gradient(ellipse 40% 30% at 20% 80%, var(--secondary-glow) 0%, transparent 60%);
        }
        .sm-wrapper {
            max-width: 1050px;
            margin: 0 auto;
            padding: 2rem 1.5rem 4rem;
        }

        /* ── Header ── */
        .sm-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            animation: fadeDown .5s ease both;
        }
        .sm-back-btn {
            width: 40px; height: 40px;
            border-radius: 10px;
            border: 1.5px solid var(--border);
            background: var(--surface-1);
            color: var(--text-secondary);
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: all .2s;
            text-decoration: none;
            font-size: .9rem;
        }
        .sm-back-btn:hover { border-color: var(--accent-blue); color: var(--accent-blue); }
        .sm-title-block { flex: 1; }
        .sm-title {
            font-family: 'Fraunces', sans-serif;
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--text-primary);
        }
        .sm-subtitle {
            font-size: .85rem;
            color: var(--text-muted);
            font-family: 'Inter', sans-serif;
            margin-top: .2rem;
        }
        .sm-pass-pill {
            display: flex;
            align-items: center;
            gap: .4rem;
            padding: .5rem 1rem;
            border-radius: 20px;
            background: var(--primary-glow);
            border: 1px solid var(--primary-glow-lg);
            color: var(--accent-blue);
            font-family: 'Inter', sans-serif;
            font-size: .85rem;
            font-weight: 600;
        }

        /* ── Layout: cabin + sidebar ── */
        .sm-layout {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 2rem;
            align-items: start;
        }

        /* ── Cabin card ── */
        .cabin-card {
            background: var(--surface-1);
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow: hidden;
            animation: fadeUp .5s .1s ease both;
        }
        .cabin-card-header {
            padding: 1.2rem 2rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .cabin-card-header .cht {
            font-family: 'Fraunces', sans-serif;
            font-size: .95rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* Legend */
        .seat-legend {
            display: flex;
            gap: 1.2rem;
            flex-wrap: wrap;
        }
        .leg-item {
            display: flex;
            align-items: center;
            gap: .4rem;
            font-family: 'Inter', sans-serif;
            font-size: .75rem;
            color: var(--text-muted);
        }
        .leg-box {
            width: 18px; height: 18px;
            border-radius: 5px;
            flex-shrink: 0;
        }
        .leg-box.available { background: var(--surface-2); border: 1.5px solid var(--border); }
        .leg-box.occupied  { background: var(--danger-border); border: 1.5px solid var(--danger-border); }
        .leg-box.selected  { background: var(--grad-brand); }
        .leg-box.business  { background: var(--primary-glow-lg); border: 1.5px solid var(--primary-glow-lg); }

        /* ── Airplane body ── */
        .airplane-body {
            padding: 1.5rem 2rem 2rem;
        }

        /* Nose */
        .plane-nose {
            display: flex;
            justify-content: center;
            margin-bottom: 1rem;
        }
        .plane-nose-inner {
            width: 120px;
            height: 50px;
            background: linear-gradient(180deg, var(--surface-2), var(--surface-1));
            border: 1px solid var(--border);
            border-radius: 60px 60px 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            opacity: .5;
        }

        /* Class label */
        .class-label {
            text-align: center;
            font-family: 'Fraunces', sans-serif;
            font-size: .7rem;
            font-weight: 700;
            letter-spacing: .12em;
            text-transform: uppercase;
            margin: .8rem 0 .5rem;
            padding: .3rem 0;
            border-top: 1px dashed var(--border);
            border-bottom: 1px dashed var(--border);
        }
        .class-label.business { color: var(--accent-blue); }
        .class-label.economy  { color: var(--text-muted); }

        /* Seat row container */
        .seat-rows {
            display: flex;
            flex-direction: column;
            gap: .4rem;
        }
        .seat-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .25rem;
        }
        .row-num {
            width: 28px;
            text-align: center;
            font-family: 'DM Mono', monospace;
            font-size: .7rem;
            color: var(--text-muted);
            flex-shrink: 0;
        }
        .seat-aisle {
            width: 24px;
            flex-shrink: 0;
        }

        /* The seat itself */
        .seat {
            width: 36px;
            height: 36px;
            border-radius: 8px 8px 5px 5px;
            border: 1.5px solid var(--border);
            background: var(--surface-2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: .65rem;
            font-family: 'DM Mono', monospace;
            color: var(--text-muted);
            cursor: pointer;
            transition: all .2s;
            position: relative;
            user-select: none;
            flex-shrink: 0;
        }
        .seat::before {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 4px; right: 4px;
            height: 4px;
            background: inherit;
            border-radius: 0 0 4px 4px;
            opacity: .6;
        }
        .seat:hover:not(.occupied):not(.selected) {
            border-color: var(--accent-blue);
            background: var(--primary-glow);
            color: var(--accent-blue);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px var(--primary-glow-lg);
        }
        .seat.occupied {
            background: var(--danger-bg);
            border-color: var(--danger-border);
            cursor: not-allowed;
            color: var(--danger);
        }
        .seat.occupied::after {
            content: '✕';
            font-size: .6rem;
            position: absolute;
        }
        .seat.selected {
            background: var(--grad-brand);
            border-color: transparent;
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 16px var(--primary-glow-lg);
            animation: seatPop .25s ease;
        }
        .seat.business-class {
            background: var(--primary-glow);
            border-color: var(--primary-glow-lg);
            width: 42px; height: 42px;
            border-radius: 10px 10px 6px 6px;
        }
        .seat.business-class:hover:not(.occupied):not(.selected) {
            border-color: var(--accent-blue);
            background: var(--primary-glow-lg);
        }

        @keyframes seatPop {
            0%   { transform: translateY(-2px) scale(1.2); }
            100% { transform: translateY(-2px) scale(1); }
        }

        /* ── Sidebar ── */
        .sm-sidebar { display: flex; flex-direction: column; gap: 1.5rem; }

        .sm-sidebar-card {
            background: var(--surface-1);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            animation: fadeUp .5s .2s ease both;
            position: relative;
        }
        .sm-sidebar-card::before {
            content: '';
            display: block;
            height: 3px;
            background: var(--grad-brand);
        }
        .sm-sc-header {
            padding: 1rem 1.4rem;
            border-bottom: 1px solid var(--border);
            font-family: 'Fraunces', sans-serif;
            font-size: .85rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* Route mini-display */
        .sm-route {
            padding: 1rem 1.4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: .5rem;
            border-bottom: 1px solid var(--border);
        }
        .sm-route-city { text-align: center; }
        .sm-route-code {
            font-family: 'Fraunces', sans-serif;
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-primary);
        }
        .sm-route-name {
            font-size: .7rem;
            color: var(--text-muted);
            font-family: 'Inter', sans-serif;
        }
        .sm-route-arrow { color: var(--accent-blue); font-size: 1rem; }

        /* Selected seat display */
        .selected-seats-list {
            padding: 1rem 1.4rem;
            min-height: 80px;
        }
        .ssl-empty {
            text-align: center;
            color: var(--text-muted);
            font-family: 'Inter', sans-serif;
            font-size: .85rem;
            padding: 1rem 0;
        }
        .ssl-seat-chips {
            display: flex;
            flex-wrap: wrap;
            gap: .4rem;
        }
        .ssl-chip {
            display: flex;
            align-items: center;
            gap: .35rem;
            padding: .35rem .75rem;
            border-radius: 20px;
            background: var(--primary-glow);
            border: 1px solid var(--primary-glow-lg);
            font-family: 'DM Mono', monospace;
            font-size: .8rem;
            color: var(--accent-blue);
            font-weight: 500;
            animation: chipIn .2s ease both;
        }
        .ssl-chip button {
            background: none;
            border: none;
            color: var(--accent-blue);
            cursor: pointer;
            padding: 0;
            font-size: .7rem;
            opacity: .6;
            transition: opacity .2s;
            line-height: 1;
        }
        .ssl-chip button:hover { opacity: 1; }
        @keyframes chipIn {
            from { opacity:0; transform:scale(.8); }
            to   { opacity:1; transform:scale(1); }
        }

        /* Progress indicator */
        .sm-progress-bar {
            padding: .75rem 1.4rem;
            border-top: 1px solid var(--border);
        }
        .sm-progress-label {
            display: flex;
            justify-content: space-between;
            font-family: 'Inter', sans-serif;
            font-size: .75rem;
            color: var(--text-muted);
            margin-bottom: .4rem;
        }
        .sm-progress-track {
            height: 6px;
            border-radius: 3px;
            background: var(--surface-2);
            overflow: hidden;
        }
        .sm-progress-fill {
            height: 100%;
            border-radius: 3px;
            background: var(--grad-brand);
            transition: width .4s ease;
        }

        /* Confirm button */
        .btn-confirm-seats {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .6rem;
            width: 100%;
            padding: .9rem;
            background: var(--grad-brand);
            border: none;
            border-radius: 12px;
            color: #fff;
            font-family: 'Fraunces', sans-serif;
            font-size: .95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all .3s;
            margin: 1rem 1.4rem;
            width: calc(100% - 2.8rem);
        }
        .btn-confirm-seats:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px var(--primary-glow-lg);
        }
        .btn-confirm-seats:disabled {
            opacity: .45;
            cursor: not-allowed;
        }

        /* ── Seat info tip ── */
        .seat-tip {
            padding: .8rem 1.4rem;
            display: flex;
            align-items: center;
            gap: .5rem;
            font-family: 'Inter', sans-serif;
            font-size: .78rem;
            color: var(--text-muted);
            border-top: 1px solid var(--border);
        }
        .seat-tip i { color: var(--accent-blue); flex-shrink: 0; }

        @keyframes fadeUp {
            from { opacity:0; transform:translateY(18px); }
            to   { opacity:1; transform:translateY(0); }
        }
        @keyframes fadeDown {
            from { opacity:0; transform:translateY(-12px); }
            to   { opacity:1; transform:translateY(0); }
        }

        @media (max-width: 860px) {
            .sm-layout { grid-template-columns: 1fr; }
            .sm-sidebar { order: -1; }
            .seat { width: 30px; height: 30px; font-size: .6rem; }
            .seat.business-class { width: 34px; height: 34px; }
        }
        @media (max-width: 480px) {
            .airplane-body { padding: 1rem; }
            .seat { width: 26px; height: 26px; border-radius: 5px 5px 3px 3px; }
            .seat.business-class { width: 30px; height: 30px; }
            .row-num { width: 20px; font-size: .6rem; }
        }
    </style>
</head>
<body>
<div class="sm-page">
    <%@ include file="/Views/common/navbar.jsp" %>

    <div class="sm-wrapper">

        <!-- Header -->
        <div class="sm-header">
            <a href="javascript:history.back()" class="sm-back-btn"><i class="ph-bold ph-arrow-left"></i></a>
            <div class="sm-title-block">
                <div class="sm-title">Select Your Seat<%= passCount > 1 ? "s" : "" %></div>
                <div class="sm-subtitle">
                    Flight <%= flightNo != null ? flightNo : "—" %>
                    <% if (from != null && to != null) { %>
                        &nbsp;·&nbsp; <%= from %> → <%= to %>
                    <% } %>
                </div>
            </div>
            <div class="sm-pass-pill">
                <i class="ph-bold ph-users"></i>
                <%= passCount %> passenger<%= passCount > 1 ? "s" : "" %>
            </div>
        </div>

        <div class="sm-layout">
            <!-- ═══ CABIN ═══ -->
            <div class="cabin-card">
                <div class="cabin-card-header">
                    <span class="cht"><i class="ph-bold ph-airplane-tilt"></i> Cabin View</span>
                    <div class="seat-legend">
                        <div class="leg-item"><div class="leg-box available"></div> Available</div>
                        <div class="leg-item"><div class="leg-box occupied"></div> Taken</div>
                        <div class="leg-item"><div class="leg-box selected"></div> Selected</div>
                        <div class="leg-item"><div class="leg-box business"></div> Business</div>
                    </div>
                </div>

                <div class="airplane-body">
                    <div class="plane-nose">
                        <div class="plane-nose-inner"><i class="ph-bold ph-airplane-tilt"></i></div>
                    </div>

                    <!-- Business class: rows 1–4, seats A–D (4-wide) -->
                    <div class="class-label business">Business Class</div>
                    <div class="seat-rows" id="businessRows"></div>

                    <!-- Economy class: rows 5–30, seats A–F (6-wide) -->
                    <div class="class-label economy">— Economy Class —</div>
                    <div class="seat-rows" id="economyRows"></div>
                </div>
            </div>

            <!-- ═══ SIDEBAR ═══ -->
            <div class="sm-sidebar">
                <div class="sm-sidebar-card">
                    <div class="sm-sc-header"><i class="ph-bold ph-airplane-tilt" style="color:var(--accent-blue);margin-right:.4rem;"></i> Flight Details</div>
                    <div class="sm-route">
                        <div class="sm-route-city">
                            <div class="sm-route-code"><%= from != null ? from.substring(0, Math.min(3, from.length())).toUpperCase() : "DEP" %></div>
                            <div class="sm-route-name"><%= from != null ? from : "—" %></div>
                        </div>
                        <i class="ph-bold ph-arrow-right sm-route-arrow"></i>
                        <div class="sm-route-city">
                            <div class="sm-route-code"><%= to != null ? to.substring(0, Math.min(3, to.length())).toUpperCase() : "ARR" %></div>
                            <div class="sm-route-name"><%= to != null ? to : "—" %></div>
                        </div>
                    </div>

                    <div class="sm-sc-header" style="border-top:1px solid var(--border);">Selected Seats</div>
                    <div class="selected-seats-list" id="selectedSeatsList">
                        <div class="ssl-empty" id="sslEmpty">
                            <i class="ph-bold ph-armchair" style="display:block;font-size:1.5rem;margin-bottom:.5rem;opacity:.3;"></i>
                            Tap a seat to select
                        </div>
                        <div class="ssl-seat-chips" id="sslChips"></div>
                    </div>

                    <div class="sm-progress-bar">
                        <div class="sm-progress-label">
                            <span id="selCount">0</span> of <%= passCount %> selected
                            <span id="selStatus"></span>
                        </div>
                        <div class="sm-progress-track">
                            <div class="sm-progress-fill" id="selProgressFill" style="width:0%"></div>
                        </div>
                    </div>

                    <div class="seat-tip">
                        <i class="ph-bold ph-info"></i>
                        Select exactly <%= passCount %> seat<%= passCount > 1 ? "s" : "" %> to continue
                    </div>

                    <!-- FORM — business logic preserved -->
                    <form action="SeatSelectionServlet" method="POST">
                        <input type="hidden" name="bookingId" value="<%= bookingId %>"/>
                        <input type="hidden" name="selectedSeats" id="selectedSeatsInput"/>
                        <button type="submit" class="btn-confirm-seats" id="confirmBtn" disabled>
                            <i class="ph-bold ph-check-circle"></i> Confirm Seats
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </div>
    <%@ include file="/Views/common/Footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
    /* ── Config from JSP ── */
    const MAX_SEATS      = <%= passCount %>;
    const TRAVEL_CLASS   = '<%= travelClass != null ? travelClass.toLowerCase() : "economy" %>';
    const OCCUPIED_SEATS = '<%= occupiedSeatsStr %>'.split(',').filter(Boolean);
    const PRE_SELECTED   = '<%= selectedSeatsStr %>'.split(',').filter(Boolean);

    let selectedSeats = [...PRE_SELECTED];

    /* ── Build seat map ── */
    const BUSINESS_ROWS = [1,2,3,4];
    const ECONOMY_ROWS  = Array.from({length:26}, (_,i) => i + 5);
    const BUS_COLS      = ['A','B','C','D'];
    const ECO_COLS      = ['A','B','C','D','E','F'];

    function buildRows(rows, cols, containerId, isBusinessClass) {
        const container = document.getElementById(containerId);
        rows.forEach(rowNum => {
            const rowEl = document.createElement('div');
            rowEl.className = 'seat-row';

            // Row number
            const rn = document.createElement('div');
            rn.className = 'row-num';
            rn.textContent = rowNum;
            rowEl.appendChild(rn);

            cols.forEach((col, colIdx) => {
                // Aisle gap (middle)
                if (cols.length === 6 && colIdx === 3) {
                    const aisle = document.createElement('div');
                    aisle.className = 'seat-aisle';
                    rowEl.appendChild(aisle);
                }
                if (cols.length === 4 && colIdx === 2) {
                    const aisle = document.createElement('div');
                    aisle.className = 'seat-aisle';
                    rowEl.appendChild(aisle);
                }

                const seatId = rowNum + col;
                const btn = document.createElement('div');
                btn.className = 'seat' + (isBusinessClass ? ' business-class' : '');
                btn.dataset.seatId = seatId;
                btn.textContent = col;
                btn.title = 'Seat ' + seatId;

                if (OCCUPIED_SEATS.includes(seatId)) {
                    btn.classList.add('occupied');
                } else if (selectedSeats.includes(seatId)) {
                    btn.classList.add('selected');
                } else {
                    btn.addEventListener('click', () => toggleSeat(seatId, btn));
                }
                rowEl.appendChild(btn);
            });
            container.appendChild(rowEl);
        });
    }

    buildRows(BUSINESS_ROWS, BUS_COLS, 'businessRows', true);
    buildRows(ECONOMY_ROWS,  ECO_COLS, 'economyRows',  false);

    /* ── Toggle seat selection ── */
    function toggleSeat(seatId, btn) {
        const idx = selectedSeats.indexOf(seatId);
        if (idx > -1) {
            // Deselect
            selectedSeats.splice(idx, 1);
            btn.classList.remove('selected');
        } else {
            if (selectedSeats.length >= MAX_SEATS) {
                // Shake existing selection indicator
                document.getElementById('selectedSeatsList').style.animation = 'shake .3s ease';
                setTimeout(() => document.getElementById('selectedSeatsList').style.animation = '', 400);
                return;
            }
            selectedSeats.push(seatId);
            btn.classList.add('selected');
        }
        updateUI();
    }

    /* ── Update sidebar UI ── */
    function updateUI() {
        const count   = selectedSeats.length;
        const percent = (count / MAX_SEATS) * 100;

        document.getElementById('selCount').textContent = count;
        document.getElementById('selProgressFill').style.width = percent + '%';
        document.getElementById('selectedSeatsInput').value = selectedSeats.join(',');

        const confirmBtn = document.getElementById('confirmBtn');
        confirmBtn.disabled = count !== MAX_SEATS;

        const statusEl = document.getElementById('selStatus');
        if (count === MAX_SEATS) {
            statusEl.textContent = '✓ Ready';
            statusEl.style.color = 'var(--accent-green)';
        } else {
            statusEl.textContent = (MAX_SEATS - count) + ' more needed';
            statusEl.style.color = 'var(--text-muted)';
        }

        // Chips
        const chips = document.getElementById('sslChips');
        const empty = document.getElementById('sslEmpty');
        chips.innerHTML = '';
        if (count === 0) {
            empty.style.display = 'block';
        } else {
            empty.style.display = 'none';
            selectedSeats.forEach(sId => {
                const chip = document.createElement('div');
                chip.className = 'ssl-chip';
                chip.innerHTML = `<i class="ph-bold ph-armchair"></i> ${sId}
                    <button onclick="deselect('${sId}')" title="Remove">✕</button>`;
                chips.appendChild(chip);
            });
        }
    }

    /* ── Deselect from chip ── */
    function deselect(seatId) {
        const idx = selectedSeats.indexOf(seatId);
        if (idx > -1) selectedSeats.splice(idx, 1);
        const btn = document.querySelector('[data-seat-id="' + seatId + '"]');
        if (btn) btn.classList.remove('selected');
        updateUI();
    }

    // Initial render
    updateUI();

    /* ── Shake keyframe (inline) ── */
    const shakeStyle = document.createElement('style');
    shakeStyle.textContent = `
        @keyframes shake {
            0%,100% { transform: translateX(0); }
            25%      { transform: translateX(-5px); }
            75%      { transform: translateX(5px); }
        }
    `;
    document.head.appendChild(shakeStyle);
</script>
</body>
</html>
