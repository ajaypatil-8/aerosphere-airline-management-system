<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect("login.jsp"); return; }
    String flightSuccess = (String) session.getAttribute("flightSuccess");
    String flightError   = (String) session.getAttribute("flightError");
    session.removeAttribute("flightSuccess");
    session.removeAttribute("flightError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Flight – SkyConnect Admin</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4ff; color: #222; }

        .navbar {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 14px 32px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .navbar .brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
        .nav-links a { color: #fff; text-decoration: none; margin-left: 22px; font-size: 14px; font-weight: 500; opacity: 0.9; }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }

        .container { max-width: 680px; margin: 40px auto; padding: 0 16px; }

        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px;
        }
        .page-header h1 { font-size: 22px; font-weight: 700; color: #1a56db; }
        .page-header p  { font-size: 13px; color: #6b7280; margin-top: 2px; }

        .btn-back {
            padding: 9px 20px; background: #e5e7eb; color: #374151;
            border-radius: 10px; font-weight: 600; font-size: 13px;
            text-decoration: none; display: inline-block;
        }
        .btn-back:hover { background: #d1d5db; }

        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; font-weight: 500; margin-bottom: 20px;
        }
        .alert-error   { background: #fee2e2; color: #991b1b; }
        .alert-success { background: #d1fae5; color: #065f46; }

        .card {
            background: #fff; border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
            padding: 36px 40px;
        }

        .section-title {
            font-size: 13px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.7px; color: #1a56db;
            border-bottom: 2px solid #eef4ff; padding-bottom: 8px;
            margin-bottom: 24px;
        }

        .form-row {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 18px; margin-bottom: 18px;
        }
        .form-group { margin-bottom: 18px; }
        .form-group.full { grid-column: 1 / -1; }

        label {
            display: block; font-size: 13px; font-weight: 600;
            color: #374151; margin-bottom: 6px;
        }
        .required { color: #ef4444; margin-left: 2px; }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        input[type="time"],
        select {
            width: 100%; padding: 10px 14px;
            border: 1.5px solid #d1d9f0; border-radius: 10px;
            font-size: 14px; color: #222; background: #f8faff;
            outline: none; transition: border-color 0.2s;
        }
        input:focus, select:focus { border-color: #1a56db; background: #fff; }
        .hint { font-size: 12px; color: #9ca3af; margin-top: 4px; }

        .divider { border: none; border-top: 1.5px solid #eef4ff; margin: 8px 0 24px 0; }

        /* Route preview */
        .route-preview {
            background: #f0f4ff; border-radius: 12px;
            padding: 18px 24px; margin-bottom: 24px;
            display: flex; align-items: center; justify-content: center;
            gap: 14px; min-height: 64px;
        }
        .route-preview .rp-city {
            text-align: center;
        }
        .route-preview .rp-code {
            font-size: 22px; font-weight: 800; color: #1a56db;
            text-transform: uppercase;
        }
        .route-preview .rp-label {
            font-size: 11px; color: #9ca3af; margin-top: 2px;
        }
        .route-preview .rp-arrow {
            font-size: 22px; color: #0ea5e9; flex: 1; text-align: center;
        }
        .route-preview .rp-placeholder {
            color: #c4c9d9; font-size: 14px; font-style: italic;
        }

        /* Fare preview */
        .fare-preview {
            background: #f0f4ff; border-radius: 12px;
            padding: 16px 20px; margin-bottom: 24px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .fare-preview .fp-label { font-size: 13px; color: #6b7280; }
        .fare-preview .fp-value { font-size: 20px; font-weight: 800; color: #1a56db; }
        .fare-preview .fp-gst   { font-size: 12px; color: #9ca3af; margin-top: 2px; }

        .btn-row { display: flex; gap: 12px; }
        .btn-primary {
            flex: 1; padding: 13px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border: none; border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-primary:hover { opacity: 0.9; }
        .btn-reset {
            padding: 13px 24px; background: #e5e7eb; color: #374151;
            border: none; border-radius: 10px;
            font-size: 14px; font-weight: 600; cursor: pointer;
        }
        .btn-reset:hover { background: #d1d5db; }
    </style>
</head>
<body>

<nav class="navbar">
    <a class="brand" href="index.jsp">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="adminDashboard">Dashboard</a>
        <a href="adminFlights">Flights</a>
        <a href="adminBookings">Bookings</a>
        <a href="admin_add_flight.jsp">Add Flight</a>
        <a href="reports.jsp">Reports</a>
        <a href="adminRefunds">Refunds</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">

    <div class="page-header">
        <div>
            <h1>➕ Add New Flight</h1>
            <p>Schedule a new flight route in the system</p>
        </div>
        <a href="adminFlights" class="btn-back">← Back to Flights</a>
    </div>

    <% if (flightError != null) { %>
        <div class="alert alert-error">⚠ <%= flightError %></div>
    <% } %>
    <% if (flightSuccess != null) { %>
        <div class="alert alert-success">✔ <%= flightSuccess %></div>
    <% } %>

    <div class="card">

        <!-- Route preview -->
        <div class="route-preview" id="routePreview">
            <span class="rp-placeholder">Enter source and destination to preview route</span>
        </div>

        <form action="<%= request.getContextPath() %>/addFlight" method="post" id="addFlightForm">

            <p class="section-title">Flight Information</p>

            <div class="form-row">
                <div class="form-group">
                    <label>Flight Number <span class="required">*</span></label>
                    <input type="text" name="flightNo" id="flightNo"
                           placeholder="e.g. SC-101" maxlength="20" required>
                    <p class="hint">Unique identifier for this flight</p>
                </div>
                <div class="form-group">
                    <label>Flight Date <span class="required">*</span></label>
                    <input type="date" name="date" id="flightDate" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Source (From) <span class="required">*</span></label>
                    <input type="text" name="source" id="source"
                           placeholder="e.g. Mumbai" maxlength="100" required
                           oninput="updateRoutePreview()">
                </div>
                <div class="form-group">
                    <label>Destination (To) <span class="required">*</span></label>
                    <input type="text" name="destination" id="destination"
                           placeholder="e.g. Delhi" maxlength="100" required
                           oninput="updateRoutePreview()">
                </div>
            </div>

            <hr class="divider">
            <p class="section-title">Schedule & Capacity</p>

            <div class="form-row">
                <div class="form-group">
                    <label>Departure Time <span class="required">*</span></label>
                    <input type="time" name="departTime" id="departTime" required
                           onchange="checkTimes()">
                </div>
                <div class="form-group">
                    <label>Arrival Time <span class="required">*</span></label>
                    <input type="time" name="arrivalTime" id="arrivalTime" required
                           onchange="checkTimes()">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Total Seats <span class="required">*</span></label>
                    <input type="number" name="totalSeats" id="totalSeats"
                           placeholder="e.g. 180" min="1" max="853" required>
                    <p class="hint">Maximum passenger capacity</p>
                </div>
                <div class="form-group">
                    <label>Available Seats <span class="required">*</span></label>
                    <input type="number" name="availableSeats" id="availableSeats"
                           placeholder="e.g. 180" min="0" max="853" required>
                    <p class="hint">Should be ≤ total seats</p>
                </div>
            </div>

            <hr class="divider">
            <p class="section-title">Pricing</p>

            <!-- Fare preview -->
            <div class="fare-preview">
                <div>
                    <div class="fp-label">Price per Seat (Base + GST)</div>
                    <div class="fp-gst">5% GST will be added at checkout</div>
                </div>
                <div style="text-align:right;">
                    <div class="fp-value" id="farePreview">₹ —</div>
                    <div class="fp-gst" id="fareGstPreview"></div>
                </div>
            </div>

            <div class="form-group">
                <label>Price per Seat (₹) <span class="required">*</span></label>
                <input type="number" name="price" id="price"
                       placeholder="e.g. 4500" min="1" step="0.01" required
                       oninput="updateFarePreview()">
                <p class="hint">Base fare before GST</p>
            </div>

            <div class="btn-row">
                <button type="reset" class="btn-reset" onclick="resetPreviews()">Reset</button>
                <button type="submit" class="btn-primary">✈ Add Flight</button>
            </div>

        </form>
    </div>
</div>

<script>
    // Set min date to today
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
                    <div class="rp-code">${srcCode}</div>
                    <div class="rp-label">${src || '—'}</div>
                </div>
                <div class="rp-arrow">✈ ────────── ✈</div>
                <div class="rp-city">
                    <div class="rp-code">${destCode}</div>
                    <div class="rp-label">${dest || '—'}</div>
                </div>`;
        } else {
            box.innerHTML = '<span class="rp-placeholder">Enter source and destination to preview route</span>';
        }
    }

    function updateFarePreview() {
        const price = parseFloat(document.getElementById('price').value);
        if (!isNaN(price) && price > 0) {
            const gst   = price * 0.05;
            const total = price + gst;
            document.getElementById('farePreview').textContent =
                '₹' + total.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('fareGstPreview').textContent =
                'Base ₹' + price.toLocaleString('en-IN', { minimumFractionDigits: 2 }) +
                ' + GST ₹' + gst.toLocaleString('en-IN', { minimumFractionDigits: 2 });
        } else {
            document.getElementById('farePreview').textContent = '₹ —';
            document.getElementById('fareGstPreview').textContent = '';
        }
    }

    function checkTimes() {
        const dep = document.getElementById('departTime').value;
        const arr = document.getElementById('arrivalTime').value;
        if (dep && arr && arr <= dep) {
            document.getElementById('arrivalTime').setCustomValidity(
                'Arrival time must be after departure time.');
        } else {
            document.getElementById('arrivalTime').setCustomValidity('');
        }
    }

    document.getElementById('addFlightForm').addEventListener('submit', function(e) {
        const total = parseInt(document.getElementById('totalSeats').value)     || 0;
        const avail = parseInt(document.getElementById('availableSeats').value) || 0;
        if (avail > total) {
            e.preventDefault();
            alert('Available seats cannot exceed total seats.');
        }
    });

    function resetPreviews() {
        setTimeout(() => {
            updateRoutePreview();
            updateFarePreview();
        }, 10);
    }
</script>

</body>
</html>