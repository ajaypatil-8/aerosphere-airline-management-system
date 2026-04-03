<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String flightSuccess = (String) session.getAttribute("flightSuccess");
    String flightError   = (String) session.getAttribute("flightError");
    session.removeAttribute("flightSuccess");
    session.removeAttribute("flightError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Flight – SkyConnect Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .form-wrap { max-width: 760px; margin: 0 auto; }

        .route-preview-card {
            background: rgba(0,87,255,.08); border: 1px solid var(--border-glow);
            border-radius: var(--radius); padding: 28px;
            display: flex; align-items: center; justify-content: center;
            gap: 20px; margin-bottom: 28px; min-height: 90px;
            animation: fadeUp .4s .1s ease both; opacity: 0; animation-fill-mode: forwards;
        }
        .rp-city { text-align: center; }
        .rp-code { font-family: 'Syne', sans-serif; font-size: 2.4rem; font-weight: 800; }
        .rp-label { font-size: .8rem; color: var(--muted); margin-top: 4px; }
        .rp-arrow { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .rp-plane { font-size: 1.8rem; animation: flyRight 3s infinite ease-in-out; }
        @keyframes flyRight { 0%,100%{transform:translateX(-8px)} 50%{transform:translateX(8px)} }
        .rp-line { width: 100%; height: 2px; background: linear-gradient(90deg, var(--sky), var(--sky-glow)); border-radius: 2px; }
        .rp-placeholder { color: rgba(255,255,255,.2); font-size: .9rem; font-style: italic; }

        .fare-preview-card {
            background: rgba(255,184,0,.06); border: 1px solid rgba(255,184,0,.2);
            border-radius: var(--radius); padding: 20px 24px;
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 24px;
        }
        .fp-title { font-size: .8rem; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: .05em; }
        .fp-value { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; color: var(--gold); }
        .fp-breakdown { font-size: .75rem; color: var(--muted); margin-top: 4px; }

        .form-section { margin-bottom: 28px; }
        .section-label {
            font-size: .72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .07em; color: var(--sky-glow);
            border-bottom: 1px solid var(--border); padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-grid.three { grid-template-columns: 1fr 1fr 1fr; }
        @media (max-width: 600px) { .form-grid, .form-grid.three { grid-template-columns: 1fr; } }

        .form-group { display: flex; flex-direction: column; gap: 7px; }
        .form-group label { font-size: .8rem; font-weight: 600; color: rgba(255,255,255,.7); }
        .required { color: var(--danger); margin-left: 2px; }
        .form-group input, .form-group select {
            background: rgba(255,255,255,.05); border: 1px solid var(--border);
            border-radius: 10px; color: var(--white);
            padding: 11px 14px; font-family: 'DM Sans', sans-serif;
            font-size: .875rem; outline: none; transition: border-color .2s, background .2s;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: var(--sky-glow); background: rgba(0,87,255,.07);
        }
        .form-group input::placeholder { color: rgba(255,255,255,.2); }
        .form-group select option { background: var(--ink-3); }
        .field-hint { font-size: .72rem; color: var(--muted); }

        .btn-row { display: flex; gap: 12px; margin-top: 28px; }
        .btn-reset-form {
            padding: 13px 24px; background: rgba(255,255,255,.06);
            border: 1px solid var(--border); border-radius: 10px;
            color: var(--white); font-size: .9rem; font-weight: 600;
            cursor: pointer; transition: .2s;
        }
        .btn-reset-form:hover { background: rgba(255,255,255,.1); }
        .btn-submit {
            flex: 1; padding: 13px; background: linear-gradient(90deg, var(--sky), var(--sky-glow));
            border: none; border-radius: 10px; color: var(--white);
            font-size: 1rem; font-weight: 700; cursor: pointer; transition: .2s;
        }
        .btn-submit:hover { opacity: .9; transform: translateY(-1px); }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="adminDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span> <span style="font-size:.7rem;color:var(--gold);font-weight:600;margin-left:6px;">ADMIN</span></span>
    </a>
    <div class="nav-links">
        <a href="adminDashboard"       class="nav-link">Dashboard</a>
        <a href="adminFlights"         class="nav-link">Flights</a>
        <a href="adminBookings"        class="nav-link">Bookings</a>
        <a href="adminRefunds"         class="nav-link">Refunds</a>
        <a href="admin_add_flight.jsp" class="nav-link active">+ Add Flight</a>
        <a href="logout"               class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">➕ Add New Flight</h1>
            <p class="page-subtitle">Schedule a new flight route in the system</p>
        </div>
        <a href="adminFlights" class="btn btn-ghost">← Back to Flights</a>
    </div>

    <% if (flightError   != null) { %><div class="alert alert-error">⚠ <%= flightError %></div><% } %>
    <% if (flightSuccess != null) { %><div class="alert alert-success">✔ <%= flightSuccess %></div><% } %>

    <div class="form-wrap">

        <!-- ROUTE PREVIEW -->
        <div class="route-preview-card" id="routePreview">
            <span class="rp-placeholder">Enter source and destination to preview route</span>
        </div>

        <div class="card" style="animation:fadeUp .4s .2s ease both;opacity:0;animation-fill-mode:forwards;">
            <div class="card-header">
                <span class="card-title">Flight Details</span>
            </div>
            <div style="padding:24px 28px;">

                <form action="<%= request.getContextPath() %>/addFlight" method="post" id="addFlightForm">

                    <!-- FLIGHT INFO -->
                    <div class="form-section">
                        <div class="section-label">✈ Flight Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Flight Number <span class="required">*</span></label>
                                <input type="text" name="flightNo" id="flightNo" placeholder="e.g. SC-101" maxlength="20" required>
                                <span class="field-hint">Unique identifier for this flight</span>
                            </div>
                            <div class="form-group">
                                <label>Flight Date <span class="required">*</span></label>
                                <input type="date" name="date" id="flightDate" required>
                            </div>
                            <div class="form-group">
                                <label>Source (From) <span class="required">*</span></label>
                                <input type="text" name="source" id="source" placeholder="e.g. Mumbai" maxlength="100" required oninput="updateRoutePreview()">
                            </div>
                            <div class="form-group">
                                <label>Destination (To) <span class="required">*</span></label>
                                <input type="text" name="destination" id="destination" placeholder="e.g. Delhi" maxlength="100" required oninput="updateRoutePreview()">
                            </div>
                        </div>
                    </div>

                    <!-- SCHEDULE -->
                    <div class="form-section">
                        <div class="section-label">🕐 Schedule & Capacity</div>
                        <div class="form-grid three">
                            <div class="form-group">
                                <label>Departure Time <span class="required">*</span></label>
                                <input type="time" name="departTime" id="departTime" required onchange="checkTimes()">
                            </div>
                            <div class="form-group">
                                <label>Arrival Time <span class="required">*</span></label>
                                <input type="time" name="arrivalTime" id="arrivalTime" required onchange="checkTimes()">
                            </div>
                            <div class="form-group">
                                <label>Total Seats <span class="required">*</span></label>
                                <input type="number" name="totalSeats" id="totalSeats" placeholder="e.g. 180" min="1" max="853" required oninput="syncAvailSeats()">
                                <span class="field-hint">Maximum passenger capacity</span>
                            </div>
                            <div class="form-group">
                                <label>Available Seats <span class="required">*</span></label>
                                <input type="number" name="availableSeats" id="availableSeats" placeholder="e.g. 180" min="0" max="853" required>
                                <span class="field-hint">Should be ≤ total seats</span>
                            </div>
                        </div>
                    </div>

                    <!-- PRICING -->
                    <div class="form-section">
                        <div class="section-label">💰 Pricing</div>
                        <div class="fare-preview-card">
                            <div>
                                <div class="fp-title">Price Per Seat (with 5% GST)</div>
                                <div class="fp-breakdown" id="fareBreakdown">Enter base price to preview</div>
                            </div>
                            <div class="fp-value" id="fareTotal">₹ —</div>
                        </div>
                        <div class="form-group">
                            <label>Base Price per Seat (₹) <span class="required">*</span></label>
                            <input type="number" name="price" id="price" placeholder="e.g. 4500" min="1" step="0.01" required oninput="updateFare()">
                            <span class="field-hint">Base fare before 5% GST</span>
                        </div>
                    </div>

                    <div class="btn-row">
                        <button type="reset" class="btn-reset-form" onclick="resetPreviews()">↺ Reset</button>
                        <button type="submit" class="btn-submit">✈ Add Flight</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
// Stars
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.2+Math.random()*.5};`;
    s.appendChild(el);
}

document.getElementById('flightDate').min = new Date().toISOString().split('T')[0];

function updateRoutePreview() {
    const src  = document.getElementById('source').value.trim();
    const dest = document.getElementById('destination').value.trim();
    const box  = document.getElementById('routePreview');
    if (src || dest) {
        const srcCode  = src.length  >= 3 ? src.substring(0,3).toUpperCase()  : src.toUpperCase();
        const destCode = dest.length >= 3 ? dest.substring(0,3).toUpperCase() : dest.toUpperCase();
        box.innerHTML = `
            <div class="rp-city">
                <div class="rp-code" style="color:var(--gold)">${srcCode}</div>
                <div class="rp-label">${src || '—'}</div>
            </div>
            <div class="rp-arrow">
                <div class="rp-plane">✈</div>
                <div class="rp-line"></div>
            </div>
            <div class="rp-city">
                <div class="rp-code" style="color:var(--sky-glow)">${destCode}</div>
                <div class="rp-label">${dest || '—'}</div>
            </div>`;
    } else {
        box.innerHTML = '<span class="rp-placeholder">Enter source and destination to preview route</span>';
    }
}

function updateFare() {
    const p = parseFloat(document.getElementById('price').value);
    if (!isNaN(p) && p > 0) {
        const gst = p * 0.05, total = p + gst;
        document.getElementById('fareTotal').textContent = '₹' + total.toLocaleString('en-IN', {minimumFractionDigits:2, maximumFractionDigits:2});
        document.getElementById('fareBreakdown').textContent = 'Base ₹' + p.toLocaleString('en-IN',{minimumFractionDigits:2}) + ' + GST ₹' + gst.toLocaleString('en-IN',{minimumFractionDigits:2});
    } else {
        document.getElementById('fareTotal').textContent = '₹ —';
        document.getElementById('fareBreakdown').textContent = 'Enter base price to preview';
    }
}

function syncAvailSeats() {
    const total = document.getElementById('totalSeats').value;
    document.getElementById('availableSeats').value = total;
    document.getElementById('availableSeats').max = total;
}

function checkTimes() {
    const dep = document.getElementById('departTime').value;
    const arr = document.getElementById('arrivalTime').value;
    if (dep && arr && arr <= dep)
        document.getElementById('arrivalTime').setCustomValidity('Arrival must be after departure.');
    else
        document.getElementById('arrivalTime').setCustomValidity('');
}

function resetPreviews() {
    setTimeout(() => { updateRoutePreview(); updateFare(); }, 10);
}

document.getElementById('addFlightForm').addEventListener('submit', function(e) {
    const total = parseInt(document.getElementById('totalSeats').value) || 0;
    const avail = parseInt(document.getElementById('availableSeats').value) || 0;
    if (avail > total) { e.preventDefault(); alert('Available seats cannot exceed total seats.'); }
});
</script>
</body>
</html>
