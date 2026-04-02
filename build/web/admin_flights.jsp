<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect("login.jsp"); return; }
    List<com.skyconnect.servlet.AdminFlightsServlet.Flight> flights =
        (List<com.skyconnect.servlet.AdminFlightsServlet.Flight>) request.getAttribute("flights");
    String deleteError   = (String) session.getAttribute("deleteError");
    String deleteSuccess = (String) session.getAttribute("deleteSuccess");
    session.removeAttribute("deleteError");
    session.removeAttribute("deleteSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Flights – SkyConnect Admin</title>
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

        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }

        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px;
        }
        .page-header h1 { font-size: 22px; font-weight: 700; color: #1a56db; }
        .page-header p  { font-size: 13px; color: #6b7280; margin-top: 2px; }

        .btn-primary {
            display: inline-block; padding: 11px 24px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border-radius: 10px; font-weight: 700;
            font-size: 14px; text-decoration: none; border: none; cursor: pointer;
        }
        .btn-primary:hover { opacity: 0.9; }

        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; font-weight: 500; margin-bottom: 20px;
        }
        .alert-error   { background: #fee2e2; color: #991b1b; }
        .alert-success { background: #d1fae5; color: #065f46; }

        /* Search / filter bar */
        .filter-bar {
            display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap;
        }
        .filter-bar input {
            flex: 1; min-width: 200px;
            padding: 10px 14px; border: 1.5px solid #d1d9f0;
            border-radius: 10px; font-size: 14px; background: #fff;
            outline: none;
        }
        .filter-bar input:focus { border-color: #1a56db; }
        .filter-bar select {
            padding: 10px 14px; border: 1.5px solid #d1d9f0;
            border-radius: 10px; font-size: 14px; background: #fff;
            outline: none; cursor: pointer;
        }

        /* Stats strip */
        .stats-strip {
            display: flex; gap: 14px; margin-bottom: 24px; flex-wrap: wrap;
        }
        .stat-chip {
            background: #fff; border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 14px 22px; flex: 1; min-width: 140px;
        }
        .stat-chip .chip-label { font-size: 11px; color: #9ca3af; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .stat-chip .chip-value { font-size: 22px; font-weight: 800; color: #1a56db; margin-top: 3px; }

        .card {
            background: #fff; border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .section-title {
            font-size: 13px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.7px; color: #1a56db;
            border-bottom: 2px solid #eef4ff; padding-bottom: 8px;
            padding: 22px 28px 12px 28px;
        }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: linear-gradient(90deg, #1a56db, #0ea5e9); }
        thead th {
            color: #fff; text-align: left;
            padding: 14px 16px; font-size: 13px; font-weight: 600; letter-spacing: 0.4px;
            white-space: nowrap;
        }
        tbody tr:hover { background: #f8faff; }
        td { padding: 13px 16px; border-bottom: 1px solid #f0f4ff; font-size: 14px; vertical-align: middle; }

        .route-cell { font-weight: 600; }
        .route-arrow { color: #0ea5e9; margin: 0 5px; }

        .price-cell { font-weight: 700; color: #1a56db; }

        .time-cell { font-size: 13px; color: #374151; }

        .badge {
            display: inline-block; padding: 4px 12px;
            border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .badge-active   { background: #d1fae5; color: #065f46; }
        .badge-inactive { background: #fee2e2; color: #991b1b; }

        .action-btns { display: flex; gap: 8px; }

        .btn-edit {
            padding: 6px 14px; border-radius: 8px; font-size: 12px; font-weight: 700;
            background: #ede9fe; color: #5b21b6;
            text-decoration: none; display: inline-block; border: none; cursor: pointer;
        }
        .btn-edit:hover { background: #ddd6fe; }

        .btn-delete {
            padding: 6px 14px; border-radius: 8px; font-size: 12px; font-weight: 700;
            background: #fee2e2; color: #991b1b;
            border: none; cursor: pointer;
        }
        .btn-delete:hover { background: #fecaca; }

        .empty-state { text-align: center; padding: 64px 24px; }
        .empty-state .icon { font-size: 52px; margin-bottom: 16px; }
        .empty-state h3 { font-size: 18px; font-weight: 700; color: #374151; }
        .empty-state p  { font-size: 14px; color: #9ca3af; margin-top: 8px; margin-bottom: 24px; }

        .sno-cell { color: #9ca3af; font-size: 13px; }

        /* Confirm delete modal */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.45); z-index: 1000;
            align-items: center; justify-content: center;
        }
        .modal-overlay.active { display: flex; }
        .modal {
            background: #fff; border-radius: 16px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.18);
            padding: 36px 40px; max-width: 420px; width: 90%; text-align: center;
        }
        .modal .modal-icon { font-size: 44px; margin-bottom: 12px; }
        .modal h3 { font-size: 18px; font-weight: 700; color: #111; margin-bottom: 8px; }
        .modal p  { font-size: 14px; color: #6b7280; margin-bottom: 24px; }
        .modal-btns { display: flex; gap: 12px; }
        .modal-btns .btn-cancel-modal {
            flex: 1; padding: 11px; background: #e5e7eb; color: #374151;
            border: none; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer;
        }
        .modal-btns .btn-confirm-delete {
            flex: 1; padding: 11px; background: #ef4444; color: #fff;
            border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer;
        }
        .modal-btns .btn-confirm-delete:hover { background: #dc2626; }
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
            <h1>✈ Manage Flights</h1>
            <p>View, edit and remove scheduled flights</p>
        </div>
        <a href="admin_add_flight.jsp" class="btn-primary">+ Add New Flight</a>
    </div>

    <% if (deleteError != null) { %>
        <div class="alert alert-error">⚠ <%= deleteError %></div>
    <% } %>
    <% if (deleteSuccess != null) { %>
        <div class="alert alert-success">✔ <%= deleteSuccess %></div>
    <% } %>

    <%
        int totalF = flights != null ? flights.size() : 0;
        double minPrice = Double.MAX_VALUE, maxPrice = 0;
        if (flights != null) {
            for (com.skyconnect.servlet.AdminFlightsServlet.Flight f : flights) {
                if (f.price < minPrice) minPrice = f.price;
                if (f.price > maxPrice) maxPrice = f.price;
            }
        }
        if (totalF == 0) { minPrice = 0; }
    %>

    <div class="stats-strip">
        <div class="stat-chip">
            <div class="chip-label">Total Flights</div>
            <div class="chip-value"><%= totalF %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Lowest Fare</div>
            <div class="chip-value">₹<%= totalF > 0 ? String.format("%,.0f", minPrice) : "—" %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Highest Fare</div>
            <div class="chip-value">₹<%= totalF > 0 ? String.format("%,.0f", maxPrice) : "—" %></div>
        </div>
    </div>

    <!-- Filter bar -->
    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍  Search by flight no, source or destination..." onkeyup="filterTable()">
        <select id="sortSelect" onchange="sortTable()">
            <option value="">Sort by...</option>
            <option value="price-asc">Price: Low → High</option>
            <option value="price-desc">Price: High → Low</option>
            <option value="date-asc">Date: Earliest First</option>
            <option value="date-desc">Date: Latest First</option>
        </select>
    </div>

    <div class="card">
        <% if (flights == null || flights.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">✈</div>
                <h3>No Flights Found</h3>
                <p>Start by adding your first flight route.</p>
                <a href="admin_add_flight.jsp" class="btn-primary">+ Add Flight</a>
            </div>
        <% } else { %>
        <table id="flightsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Flight No</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Price / Seat</th>
                    <th>Seats</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="flightsBody">
                <% int sno = 1;
                   for (com.skyconnect.servlet.AdminFlightsServlet.Flight f : flights) { %>
                <tr>
                    <td class="sno-cell"><%= sno++ %></td>
                    <td><strong><%= f.flightNo %></strong></td>
                    <td class="route-cell">
                        <%= f.source %>
                        <span class="route-arrow">→</span>
                        <%= f.destination %>
                    </td>
                    <td style="color:#6b7280; font-size:13px;"><%= f.date %></td>
                    <td class="time-cell">🕐 <%= f.departTime %></td>
                    <td class="time-cell">🕓 <%= f.arrivalTime %></td>
                    <td class="price-cell">₹<%= String.format("%,.2f", f.price) %></td>
                    <td><%= f.availableSeats %></td>
                    <td>
                        <div class="action-btns">
                            <a href="admin_edit_flight.jsp?id=<%= f.id %>" class="btn-edit">✏ Edit</a>
                            <button class="btn-delete"
                                onclick="confirmDelete(<%= f.id %>, '<%= f.flightNo %>', '<%= f.source %> → <%= f.destination %>')">
                                🗑 Delete
                            </button>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>

<!-- Delete Confirm Modal -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-icon">🗑</div>
        <h3>Delete Flight?</h3>
        <p id="modalText">Are you sure you want to delete this flight?<br>This action cannot be undone.</p>
        <div class="modal-btns">
            <button class="btn-cancel-modal" onclick="closeModal()">Cancel</button>
            <form id="deleteForm" method="post" action="<%= request.getContextPath() %>/deleteFlight" style="flex:1;">
                <input type="hidden" name="flightId" id="deleteFlightId">
                <button type="submit" class="btn-confirm-delete" style="width:100%;">Yes, Delete</button>
            </form>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id, flightNo, route) {
        document.getElementById('deleteFlightId').value = id;
        document.getElementById('modalText').innerHTML =
            'Delete flight <strong>' + flightNo + '</strong> (' + route + ')?<br>This action cannot be undone.';
        document.getElementById('deleteModal').classList.add('active');
    }
    function closeModal() {
        document.getElementById('deleteModal').classList.remove('active');
    }
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    function filterTable() {
        const val = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#flightsBody tr');
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(val) ? '' : 'none';
        });
    }

    function sortTable() {
        const val = document.getElementById('sortSelect').value;
        const tbody = document.getElementById('flightsBody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        rows.sort((a, b) => {
            if (val === 'price-asc' || val === 'price-desc') {
                const pa = parseFloat(a.cells[6].textContent.replace(/[₹,]/g, '')) || 0;
                const pb = parseFloat(b.cells[6].textContent.replace(/[₹,]/g, '')) || 0;
                return val === 'price-asc' ? pa - pb : pb - pa;
            }
            if (val === 'date-asc' || val === 'date-desc') {
                const da = new Date(a.cells[3].textContent.trim());
                const db = new Date(b.cells[3].textContent.trim());
                return val === 'date-asc' ? da - db : db - da;
            }
            return 0;
        });
        rows.forEach(r => tbody.appendChild(r));
    }
</script>

</body>
</html>