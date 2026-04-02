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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Flight – SkyConnect Admin</title>
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

        /* Flight ID badge */
        .flight-id-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: #ede9fe; color: #5b21b6;
            border-radius: 10px; padding: 8px 16px;
            font-size: 13px; font-weight: 700;
            margin-bottom: 24px;
        }

        /* Route preview */
        .route-preview {
            background: #f0f4ff; border-radius: 12px;
            padding: 18px 24px; margin-bottom: 24px;
            display: flex; align-items: center; justify-content: center;
            gap: 14px; min-height: 64px;
        }
        .rp-city { text-align: center; }
        .rp-code  { font-size: 22px; font-weight: 800; color: #1a56db; text-transform: uppercase; }
        .rp-label { font-size: 11px; color: #9ca3af; margin-top: 2px; }
        .rp-arrow { font-size: 20px; color: #0ea5e9; flex: 1; text-align: center; }
        .rp-placeholder { color: #c4c9d9; font-size: 14px; font-style: italic; }

        .form-row {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 18px; margin-bottom: 4px;
        }
        .form-group { margin-bottom: 18px; }

        label {
            display: block; font-size: 13px; font-weight: 600;
            color: #374151; margin-bottom: 6px;
        }
        .required { color: #ef4444; margin-left: 2px; }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        input[type="time"] {
            width: 100%; padding: 10px 14px;
            border: 1.5px solid #d1d9f0; border-radius: 10px;
            font-size: 14px; color: #222; background: #f8faff;
            outline: none; transition: border-color 0.2s;
        }
        input:focus { border-color: #1a56db; background: #fff; }
        .hint { font-size: 12px; color: #9ca3af; margin-top: 4px; }

        /* Changed field highlight */
        input.changed { border-color: #f59e0b; background: #fffbeb; }

        .divider { border: none; border-top: 1.5px solid #eef4ff; margin: 8px 0 24px 0; }

        /* Fare preview */
        .fare-preview {
            background: #f0f4ff; border-radius: 12px;
            padding: 16px 20px; margin-bottom: 24px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .fp-label { font-size: 13px; color: #6b7280; }
        .fp-value { font-size: 20px; font-weight: 800; color: #1a56db; }
        .fp-gst   { font-size: 12px; color: #9ca3af; margin-top: 2px; }

        /* Changes summary */
        .changes-box {
            background: #fffbeb; border: 1.5px solid #fcd34d;
            border-radius: 10px; padding: 14px 18px;
            margin-bottom: 20px; display: none;
        }
        .changes-box .cb-title { font-size: 12px; font-weight: 700; color: #92400e; margin-bottom: 6px; text-transform: uppercase; }
        .changes-box ul { list-style: none; padding: 0; }
        .changes-box ul li { font-size: 13px; color: #78350f; padding: 2px 0; }
        .changes-box ul li::before { content: "• "; color: #f59e0b; }

        .btn-row { display: flex; gap: 12px; }
        .btn-primary {
            flex: 1; padding: 13px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border: none; border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-primary:hover { opacity: 0.9; }
        .btn-secondary {
            padding: 13px 24px; background: #e5e7eb; color: #374151;
            border: none; border-radius: 10px;
            font-size: 14px; font-weight: 600; cursor: pointer;
            text-decoration: none; display: flex; align-items: center; justify-content: center;
        }
        .btn-secondary:hover { background: #d1d5db; }

        .not-found {
            text-align: center; padding: 64px 24px;
        }
        .not-found .icon { font-size: 52px; margin-bottom: 16px; }
        .not-found h3 { font-size: 18px; font-weight: 700; color: #374151; }
        .not-found p  { font-size: 14px; color: #9ca3af; margin-top: 8px; }
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
            <h1>✏ Edit Flight</h1>
            <p>Modify the details of an existing flight</p>
        </div>
        <a href="adminFlights" class="btn-back">← Back to Flights</a>
    </div>

    <% if (editError != null) { %>
        <div class="alert alert-error">⚠ <%= editError %></div>
    <% } %>
    <% if (editSuccess != null) { %>
        <div class="alert alert-success">✔ <%= editSuccess %></div>
    <% } %>

    <% if (id.isEmpty()) { %>
        <div class="card">
            <div class="not-found">
                <div class="icon">❌</div>
                <h3>Flight Not Found</h3>
                <p>The requested flight could not be loaded for editing.</p>
            </div>
        </div>
    <% } else { %>

    <div class="card">

        <div class="flight-id-badge">
            ✈ Flight ID: #<%= id %> &nbsp;|&nbsp; <%= flightNo %>
        </div>

        <!-- Route preview -->
        <div class="route-preview" id="routePreview">
            <div class="rp-city">
                <div class="rp-code" id="srcCode"><%= source.length() >= 3 ? source.substring(0,3).toUpperCase() : source.toUpperCase() %></div>
                <div class="rp-label" id="srcLabel"><%= source %></div>
            </div>
            <div class="rp-arrow">✈ ────────── ✈</div>
            <div class="rp-city">
                <div class="rp-code" id="destCode"><%= destination.length() >= 3 ? destination.substring(0,3).toUpperCase() : destination.toUpperCase() %></div>
                <div class="rp-label" id="destLabel"><%= destination %></div>
            </div>
        </div>

        <!-- Changes summary -->
        <div class="changes-box" id="changesBox">
            <div class="cb-title">⚠ Unsaved Changes</div>
            <ul id="changesList"></ul>
        </div>

        <form action="<%= request.getContextPath() %>/editFlight" method="post" id="editFlightForm">
            <input type="hidden" name="flightId" value="<%= id %>">

            <p class="section-title">Flight Information</p>

            <div class="form-row">
                <div class="form-group">
                    <label>Flight Number <span class="required">*</span></label>
                    <input type="text" name="flightNo" id="flightNo"
                           value="<%= flightNo %>"
                           data-original="<%= flightNo %>"
                           maxlength="20" required oninput="trackChange(this, 'Flight Number')">
                </div>
                <div class="form-group">
                    <label>Flight Date <span class="required">*</span></label>
                    <input type="date" name="date" id="flightDate"
                           value="<%= date %>"
                           data-original="<%= date %>"
                           required onchange="trackChange(this, 'Flight Date')">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Source (From) <span class="required">*</span></label>
                    <input type="text" name="source" id="source"
                           value="<%= source %>"
                           data-original="<%= source %>"
                           maxlength="100" required
                           oninput="trackChange(this, 'Source'); updateRoutePreview()">
                </div>
                <div class="form-group">
                    <label>Destination (To) <span class="required">*</span></label>
                    <input type="text" name="destination" id="destination"
                           value="<%= destination %>"
                           data-original="<%= destination %>"
                           maxlength="100" required
                           oninput="trackChange(this, 'Destination'); updateRoutePreview()">
                </div>
            </div>

            <hr class="divider">
            <p class="section-title">Schedule & Capacity</p>

            <div class="form-row">
                <div class="form-group">
                    <label>Departure Time <span class="required">*</span></label>
                    <input type="time" name="departTime" id="departTime"
                           value="<%= departTime %>"
                           data-original="<%= departTime %>"
                           required
                           onchange="trackChange(this, 'Departure Time'); checkTimes()">
                </div>
                <div class="form-group">
                    <label>Arrival Time <span class="required">*</span></label>
                    <input type="time" name="arrivalTime" id="arrivalTime"
                           value="<%= arrivalTime %>"
                           data-original="<%= arrivalTime %>"
                           required
                           onchange="trackChange(this, 'Arrival Time'); checkTimes()">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Total Seats <span class="required">*</span></label>
                    <input type="number" name="totalSeats" id="totalSeats"
                           value="<%= totalSeats %>"
                           data-original="<%= totalSeats %>"
                           min="1" max="853" required
                           oninput="trackChange(this, 'Total Seats')">
                </div>
                <div class="form-group">
                    <label>Available Seats <span class="required">*</span></label>
                    <input type="number" name="availableSeats" id="availableSeats"
                           value="<%= availSeats %>"
                           data-original="<%= availSeats %>"
                           min="0" max="853" required
                           oninput="trackChange(this, 'Available Seats')">
                    <p class="hint">Should be ≤ total seats</p>
                </div>
            </div>

            <hr class="divider">
            <p class="section-title">Pricing</p>

            <div class="fare-preview">
                <div>
                    <div class="fp-label">Price per Seat (with GST)</div>
                    <div class="fp-gst">5% GST included at checkout</div>
                </div>
                <div style="text-align:right;">
                    <div class="fp-value" id="farePreview">
                        <%
                            try {
                                double p = Double.parseDouble(price);
                                double total = p * 1.05;
                        %>
                        ₹<%= String.format("%,.2f", total) %>
                        <% } catch(Exception ex) { %>₹ —<% } %>
                    </div>
                    <div class="fp-gst" id="fareGstPreview">
                        <%
                            try {
                                double p2 = Double.parseDouble(price);
                        %>
                        Base ₹<%= String.format("%,.2f", p2) %> + GST ₹<%= String.format("%,.2f", p2 * 0.05) %>
                        <% } catch(Exception ex) { } %>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Price per Seat (₹) <span class="required">*</span></label>
                <input type="number" name="price" id="price"
                       value="<%= price %>"
                       data-original="<%= price %>"
                       min="1" step="0.01" required
                       oninput="trackChange(this, 'Price'); updateFarePreview()">
                <p class="hint">Base fare before GST</p>
            </div>

            <div class="btn-row">
                <a href="adminFlights" class="btn-secondary">Cancel</a>
                <button type="submit" class="btn-primary">💾 Save Changes</button>
            </div>

        </form>
    </div>
    <% } %>

</div>

<script>
    const changedFields = {};

    function trackChange(input, label) {
        const original = input.getAttribute('data-original');
        const current  = input.value;
        if (current !== original) {
            input.classList.add('changed');
            changedFields[label] = { from: original, to: current };
        } else {
            input.classList.remove('changed');
            delete changedFields[label];
        }
        renderChanges();
    }

    function renderChanges() {
        const box  = document.getElementById('changesBox');
        const list = document.getElementById('changesList');
        const keys = Object.keys(changedFields);
        if (keys.length === 0) {
            box.style.display = 'none';
        } else {
            box.style.display = 'block';
            list.innerHTML = keys.map(k =>
                `<li><strong>${k}:</strong> "${changedFields[k].from}" → "${changedFields[k].to}"</li>`
            ).join('');
        }
    }

    function updateRoutePreview() {
        const src  = document.getElementById('source').value.trim();
        const dest = document.getElementById('destination').value.trim();
        document.getElementById('srcCode').textContent  = src.length  >= 3 ? src.substring(0,3).toUpperCase()  : src.toUpperCase();
        document.getElementById('srcLabel').textContent = src  || '—';
        document.getElementById('destCode').textContent  = dest.length >= 3 ? dest.substring(0,3).toUpperCase() : dest.toUpperCase();
        document.getElementById('destLabel').textContent = dest || '—';
    }

    function updateFarePreview() {
        const p = parseFloat(document.getElementById('price').value);
        if (!isNaN(p) && p > 0) {
            const gst   = p * 0.05;
            const total = p + gst;
            document.getElementById('farePreview').textContent =
                '₹' + total.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('fareGstPreview').textContent =
                'Base ₹' + p.toLocaleString('en-IN', { minimumFractionDigits: 2 }) +
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
            document.getElementById('arrivalTime').setCustomValidity('Arrival time must be after departure time.');
        } else {
            document.getElementById('arrivalTime').setCustomValidity('');
        }
    }

    document.getElementById('editFlightForm').addEventListener('submit', function(e) {
        const total = parseInt(document.getElementById('totalSeats').value)     || 0;
        const avail = parseInt(document.getElementById('availableSeats').value) || 0;
        if (avail > total) {
            e.preventDefault();
            alert('Available seats cannot exceed total seats.');
        }
    });
</script>

</body>
</html>