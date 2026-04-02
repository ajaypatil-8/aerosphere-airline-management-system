<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect("login.jsp"); return; }

    String id          = request.getAttribute("id")          != null ? String.valueOf(request.getAttribute("id"))          : "";
    String flightNo    = request.getAttribute("flightNo")    != null ? String.valueOf(request.getAttribute("flightNo"))    : "";
    String source      = request.getAttribute("source")      != null ? String.valueOf(request.getAttribute("source"))      : "";
    String destination = request.getAttribute("destination") != null ? String.valueOf(request.getAttribute("destination")) : "";
    String date        = request.getAttribute("date")        != null ? String.valueOf(request.getAttribute("date"))        : "";
    String departTime  = request.getAttribute("departTime")  != null ? String.valueOf(request.getAttribute("departTime"))  : "";
    String arrivalTime = request.getAttribute("arrivalTime") != null ? String.valueOf(request.getAttribute("arrivalTime")) : "";
    String price       = request.getAttribute("price")       != null ? String.valueOf(request.getAttribute("price"))       : "";
    String totalSeats  = request.getAttribute("totalSeats")  != null ? String.valueOf(request.getAttribute("totalSeats"))  : "";
    String availSeats  = request.getAttribute("availableSeats") != null ? String.valueOf(request.getAttribute("availableSeats")) : "";

    String editError   = (String) session.getAttribute("editFlightError");
    String editSuccess = (String) session.getAttribute("editFlightSuccess");
    session.removeAttribute("editFlightError");
    session.removeAttribute("editFlightSuccess");

    String src3  = source.length()      >= 3 ? source.substring(0,3).toUpperCase()      : source.toUpperCase();
    String dst3  = destination.length() >= 3 ? destination.substring(0,3).toUpperCase() : destination.toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Flight – SkyConnect Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
    <style>
        .form-wrap { max-width: 760px; margin: 0 auto; }

        .flight-id-strip {
            display: flex; align-items: center; gap: 12px;
            background: rgba(139,92,246,.1); border: 1px solid rgba(139,92,246,.25);
            border-radius: 10px; padding: 12px 18px; margin-bottom: 20px;
            animation: fadeUp .4s ease both;
        }
        .flight-id-strip .fid { font-family:'Syne',sans-serif; font-size:1rem; font-weight:700; color:#a78bfa; }
        .flight-id-strip .fn  { font-size:.85rem; color:var(--muted); }

        .route-preview-card {
            background: rgba(0,87,255,.08); border: 1px solid var(--border-glow);
            border-radius: var(--radius); padding: 28px;
            display: flex; align-items: center; justify-content: center;
            gap: 20px; margin-bottom: 24px; min-height: 90px;
            animation: fadeUp .4s .1s ease both; opacity: 0; animation-fill-mode: forwards;
        }
        .rp-city { text-align: center; }
        .rp-code { font-family: 'Syne', sans-serif; font-size: 2.4rem; font-weight: 800; }
        .rp-label { font-size: .8rem; color: var(--muted); margin-top: 4px; }
        .rp-arrow { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .rp-plane { font-size: 1.8rem; animation: flyRight 3s infinite ease-in-out; }
        @keyframes flyRight { 0%,100%{transform:translateX(-8px)} 50%{transform:translateX(8px)} }
        .rp-line { width:100%; height:2px; background:linear-gradient(90deg,var(--sky),var(--sky-glow)); border-radius:2px; }

        .changes-alert {
            display: none; background: rgba(245,158,11,.08);
            border: 1px solid rgba(245,158,11,.25); border-radius:10px;
            padding: 14px 18px; margin-bottom: 20px;
        }
        .changes-alert .ca-title { font-size:.75rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:#f59e0b; margin-bottom:8px; }
        .changes-alert ul { list-style:none; padding:0; }
        .changes-alert ul li { font-size:.82rem; color:rgba(245,158,11,.8); padding:2px 0; }
        .changes-alert ul li::before { content:"• "; }

        .form-section { margin-bottom: 28px; }
        .section-label {
            font-size: .72rem; font-weight:700; text-transform:uppercase; letter-spacing:.07em;
            color:var(--sky-glow); border-bottom:1px solid var(--border);
            padding-bottom:10px; margin-bottom:20px;
        }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:18px; }
        .form-grid.three { grid-template-columns:1fr 1fr 1fr; }
        @media(max-width:600px) { .form-grid,.form-grid.three { grid-template-columns:1fr; } }

        .form-group { display:flex; flex-direction:column; gap:7px; }
        .form-group label { font-size:.8rem; font-weight:600; color:rgba(255,255,255,.7); }
        .required { color:var(--danger); margin-left:2px; }
        .form-group input {
            background:rgba(255,255,255,.05); border:1px solid var(--border);
            border-radius:10px; color:var(--white);
            padding:11px 14px; font-family:'DM Sans',sans-serif;
            font-size:.875rem; outline:none; transition:border-color .2s, background .2s;
        }
        .form-group input:focus { border-color:var(--sky-glow); background:rgba(0,87,255,.07); }
        .form-group input.changed { border-color:var(--warning); background:rgba(245,158,11,.06); }
        .field-hint { font-size:.72rem; color:var(--muted); }

        .fare-preview-card {
            background:rgba(255,184,0,.06); border:1px solid rgba(255,184,0,.2);
            border-radius:var(--radius); padding:20px 24px;
            display:flex; justify-content:space-between; align-items:center;
            margin-bottom:24px;
        }
        .fp-title { font-size:.8rem; color:var(--muted); font-weight:600; text-transform:uppercase; letter-spacing:.05em; }
        .fp-value { font-family:'Syne',sans-serif; font-size:2rem; font-weight:800; color:var(--gold); }
        .fp-breakdown { font-size:.75rem; color:var(--muted); margin-top:4px; }

        .btn-row { display:flex; gap:12px; margin-top:28px; }
        .btn-cancel-link {
            padding:13px 24px; background:rgba(255,255,255,.06);
            border:1px solid var(--border); border-radius:10px;
            color:var(--white); font-size:.9rem; font-weight:600;
            text-decoration:none; display:flex; align-items:center;
            transition:.2s;
        }
        .btn-cancel-link:hover { background:rgba(255,255,255,.1); }
        .btn-submit {
            flex:1; padding:13px; background:linear-gradient(90deg,var(--sky),var(--sky-glow));
            border:none; border-radius:10px; color:var(--white);
            font-size:1rem; font-weight:700; cursor:pointer; transition:.2s;
        }
        .btn-submit:hover { opacity:.9; transform:translateY(-1px); }
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
        <a href="adminDashboard" class="nav-link">Dashboard</a>
        <a href="adminFlights"   class="nav-link active">Flights</a>
        <a href="adminBookings"  class="nav-link">Bookings</a>
        <a href="adminRefunds"   class="nav-link">Refunds</a>
        <a href="logout"         class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">✏ Edit Flight</h1>
            <p class="page-subtitle">Modify details of an existing flight</p>
        </div>
        <a href="adminFlights" class="btn btn-ghost">← Back to Flights</a>
    </div>

    <% if (editError   != null) { %><div class="alert alert-error">⚠ <%= editError %></div><% } %>
    <% if (editSuccess != null) { %><div class="alert alert-success">✔ <%= editSuccess %></div><% } %>

    <div class="form-wrap">

        <% if (id.isEmpty()) { %>
        <div class="card" style="text-align:center;padding:80px 24px;">
            <div style="font-size:4rem;margin-bottom:16px;">❌</div>
            <p style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:rgba(255,255,255,.5);">Flight Not Found</p>
            <p style="margin-top:8px;color:var(--muted);">The requested flight could not be loaded.</p>
            <a href="adminFlights" class="btn btn-blue" style="margin-top:20px;display:inline-block;">← Back to Flights</a>
        </div>
        <% } else { %>

        <!-- Flight ID -->
        <div class="flight-id-strip">
            <span class="fid">✈ Flight #<%= id %></span>
            <span class="fn"><%= flightNo %></span>
        </div>

        <!-- Route Preview -->
        <div class="route-preview-card" id="routePreview">
            <div class="rp-city">
                <div class="rp-code" style="color:var(--gold);" id="srcCode"><%= src3 %></div>
                <div class="rp-label" id="srcLabel"><%= source %></div>
            </div>
            <div class="rp-arrow">
                <div class="rp-plane">✈</div>
                <div class="rp-line"></div>
            </div>
            <div class="rp-city">
                <div class="rp-code" style="color:var(--sky-glow);" id="destCode"><%= dst3 %></div>
                <div class="rp-label" id="destLabel"><%= destination %></div>
            </div>
        </div>

        <!-- Changes Box -->
        <div class="changes-alert" id="changesAlert">
            <div class="ca-title">⚠ Unsaved Changes</div>
            <ul id="changesList"></ul>
        </div>

        <div class="card" style="animation:fadeUp .4s .2s ease both;opacity:0;animation-fill-mode:forwards;">
            <div class="card-header">
                <span class="card-title">Flight Details</span>
            </div>
            <div style="padding:24px 28px;">

                <form action="<%= request.getContextPath() %>/editFlight" method="post" id="editFlightForm">
                    <input type="hidden" name="flightId" value="<%= id %>">

                    <!-- FLIGHT INFO -->
                    <div class="form-section">
                        <div class="section-label">✈ Flight Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Flight Number <span class="required">*</span></label>
                                <input type="text" name="flightNo" id="flightNo" value="<%= flightNo %>" data-original="<%= flightNo %>" maxlength="20" required oninput="trackChange(this,'Flight Number')">
                            </div>
                            <div class="form-group">
                                <label>Flight Date <span class="required">*</span></label>
                                <input type="date" name="date" id="flightDate" value="<%= date %>" data-original="<%= date %>" required onchange="trackChange(this,'Flight Date')">
                            </div>
                            <div class="form-group">
                                <label>Source (From) <span class="required">*</span></label>
                                <input type="text" name="source" id="source" value="<%= source %>" data-original="<%= source %>" maxlength="100" required oninput="trackChange(this,'Source');updateRoutePreview()">
                            </div>
                            <div class="form-group">
                                <label>Destination (To) <span class="required">*</span></label>
                                <input type="text" name="destination" id="destination" value="<%= destination %>" data-original="<%= destination %>" maxlength="100" required oninput="trackChange(this,'Destination');updateRoutePreview()">
                            </div>
                        </div>
                    </div>

                    <!-- SCHEDULE -->
                    <div class="form-section">
                        <div class="section-label">🕐 Schedule & Capacity</div>
                        <div class="form-grid three">
                            <div class="form-group">
                                <label>Departure Time <span class="required">*</span></label>
                                <input type="time" name="departTime" id="departTime" value="<%= departTime %>" data-original="<%= departTime %>" required onchange="trackChange(this,'Departure Time');checkTimes()">
                            </div>
                            <div class="form-group">
                                <label>Arrival Time <span class="required">*</span></label>
                                <input type="time" name="arrivalTime" id="arrivalTime" value="<%= arrivalTime %>" data-original="<%= arrivalTime %>" required onchange="trackChange(this,'Arrival Time');checkTimes()">
                            </div>
                            <div class="form-group">
                                <label>Total Seats <span class="required">*</span></label>
                                <input type="number" name="totalSeats" id="totalSeats" value="<%= totalSeats %>" data-original="<%= totalSeats %>" min="1" max="853" required oninput="trackChange(this,'Total Seats')">
                            </div>
                            <div class="form-group">
                                <label>Available Seats <span class="required">*</span></label>
                                <input type="number" name="availableSeats" id="availableSeats" value="<%= availSeats %>" data-original="<%= availSeats %>" min="0" max="853" required oninput="trackChange(this,'Available Seats')">
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
                                <div class="fp-breakdown" id="fareBreakdown">
                                    <% try { double p = Double.parseDouble(price); %>
                                    Base ₹<%= String.format("%,.2f", p) %> + GST ₹<%= String.format("%,.2f", p * 0.05) %>
                                    <% } catch(Exception e) { %>Enter price to preview<% } %>
                                </div>
                            </div>
                            <div class="fp-value" id="fareTotal">
                                <% try { double p = Double.parseDouble(price); %>
                                ₹<%= String.format("%,.2f", p * 1.05) %>
                                <% } catch(Exception e) { %>₹ —<% } %>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Base Price per Seat (₹) <span class="required">*</span></label>
                            <input type="number" name="price" id="price" value="<%= price %>" data-original="<%= price %>" min="1" step="0.01" required oninput="trackChange(this,'Price');updateFare()">
                            <span class="field-hint">Base fare before 5% GST</span>
                        </div>
                    </div>

                    <div class="btn-row">
                        <a href="adminFlights" class="btn-cancel-link">Cancel</a>
                        <button type="submit" class="btn-submit">💾 Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.2+Math.random()*.5};`;
    s.appendChild(el);
}

const changedFields = {};
function trackChange(input, label) {
    const orig = input.getAttribute('data-original');
    const cur  = input.value;
    if (cur !== orig) { input.classList.add('changed'); changedFields[label] = { from: orig, to: cur }; }
    else              { input.classList.remove('changed'); delete changedFields[label]; }
    renderChanges();
}
function renderChanges() {
    const box = document.getElementById('changesAlert');
    const list = document.getElementById('changesList');
    const keys = Object.keys(changedFields);
    if (!keys.length) { box.style.display = 'none'; return; }
    box.style.display = 'block';
    list.innerHTML = keys.map(k => `<li><strong>${k}:</strong> "${changedFields[k].from}" → "${changedFields[k].to}"</li>`).join('');
}
function updateRoutePreview() {
    const src  = document.getElementById('source').value.trim();
    const dest = document.getElementById('destination').value.trim();
    document.getElementById('srcCode').textContent  = src.length  >= 3 ? src.substring(0,3).toUpperCase()  : src.toUpperCase();
    document.getElementById('srcLabel').textContent = src  || '—';
    document.getElementById('destCode').textContent  = dest.length >= 3 ? dest.substring(0,3).toUpperCase() : dest.toUpperCase();
    document.getElementById('destLabel').textContent = dest || '—';
}
function updateFare() {
    const p = parseFloat(document.getElementById('price').value);
    if (!isNaN(p) && p > 0) {
        const gst = p * 0.05, total = p + gst;
        document.getElementById('fareTotal').textContent = '₹' + total.toLocaleString('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2});
        document.getElementById('fareBreakdown').textContent = 'Base ₹' + p.toLocaleString('en-IN',{minimumFractionDigits:2}) + ' + GST ₹' + gst.toLocaleString('en-IN',{minimumFractionDigits:2});
    } else {
        document.getElementById('fareTotal').textContent = '₹ —';
        document.getElementById('fareBreakdown').textContent = 'Enter price to preview';
    }
}
function checkTimes() {
    const dep = document.getElementById('departTime').value;
    const arr = document.getElementById('arrivalTime').value;
    if (dep && arr && arr <= dep)
        document.getElementById('arrivalTime').setCustomValidity('Arrival must be after departure.');
    else
        document.getElementById('arrivalTime').setCustomValidity('');
}
document.getElementById('editFlightForm') && document.getElementById('editFlightForm').addEventListener('submit', function(e) {
    const total = parseInt(document.getElementById('totalSeats').value) || 0;
    const avail = parseInt(document.getElementById('availableSeats').value) || 0;
    if (avail > total) { e.preventDefault(); alert('Available seats cannot exceed total seats.'); }
});
</script>
</body>
</html>
