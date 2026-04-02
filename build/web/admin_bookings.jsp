<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect("login.jsp"); return; }
    List<com.skyconnect.servlet.AdminBookingsServlet.BookingRow> bookings =
        (List<com.skyconnect.servlet.AdminBookingsServlet.BookingRow>) request.getAttribute("bookings");
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess");
    session.removeAttribute("cancelError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings – SkyConnect Admin</title>
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

        .container { max-width: 1300px; margin: 40px auto; padding: 0 20px; }

        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px;
        }
        .page-header h1 { font-size: 22px; font-weight: 700; color: #1a56db; }
        .page-header p  { font-size: 13px; color: #6b7280; margin-top: 2px; }

        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; font-weight: 500; margin-bottom: 20px;
        }
        .alert-error   { background: #fee2e2; color: #991b1b; }
        .alert-success { background: #d1fae5; color: #065f46; }

        /* Stats strip */
        .stats-strip {
            display: flex; gap: 14px; margin-bottom: 24px; flex-wrap: wrap;
        }
        .stat-chip {
            background: #fff; border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 14px 22px; flex: 1; min-width: 130px;
        }
        .stat-chip .chip-label { font-size: 11px; color: #9ca3af; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .stat-chip .chip-value { font-size: 22px; font-weight: 800; color: #1a56db; margin-top: 3px; }

        /* Filter bar */
        .filter-bar {
            display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; align-items: center;
        }
        .filter-bar input {
            flex: 2; min-width: 220px; padding: 10px 14px;
            border: 1.5px solid #d1d9f0; border-radius: 10px;
            font-size: 14px; background: #fff; outline: none;
        }
        .filter-bar input:focus { border-color: #1a56db; }
        .filter-bar select {
            flex: 1; min-width: 150px; padding: 10px 14px;
            border: 1.5px solid #d1d9f0; border-radius: 10px;
            font-size: 14px; background: #fff; outline: none; cursor: pointer;
        }
        .btn-export {
            padding: 10px 20px;
            background: #d1fae5; color: #065f46;
            border: none; border-radius: 10px;
            font-size: 13px; font-weight: 700; cursor: pointer;
            white-space: nowrap;
        }
        .btn-export:hover { background: #a7f3d0; }

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
            padding: 14px 16px; font-size: 13px; font-weight: 600;
            letter-spacing: 0.4px; white-space: nowrap;
        }
        tbody tr:hover { background: #f8faff; }
        td { padding: 13px 16px; border-bottom: 1px solid #f0f4ff; font-size: 14px; vertical-align: middle; }

        .badge {
            display: inline-block; padding: 4px 12px;
            border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .badge-paid      { background: #d1fae5; color: #065f46; }
        .badge-pending   { background: #fef9c3; color: #854d0e; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }
        .badge-booked    { background: #ede9fe; color: #5b21b6; }
        .badge-refunded  { background: #dbeafe; color: #1e40af; }

        .route-arrow { color: #0ea5e9; margin: 0 5px; }
        .amount-col  { font-weight: 700; color: #1a56db; }
        .sno-cell    { color: #9ca3af; font-size: 13px; }

        .action-btns { display: flex; gap: 7px; flex-wrap: wrap; }

        .btn-view {
            padding: 6px 13px; border-radius: 8px; font-size: 12px; font-weight: 700;
            background: linear-gradient(90deg, #1a56db, #0ea5e9); color: #fff;
            text-decoration: none; display: inline-block; border: none; cursor: pointer;
        }
        .btn-view:hover { opacity: 0.88; }

        .btn-cancel {
            padding: 6px 13px; border-radius: 8px; font-size: 12px; font-weight: 700;
            background: #fee2e2; color: #991b1b;
            border: none; cursor: pointer;
        }
        .btn-cancel:hover { background: #fecaca; }

        .btn-invoice {
            padding: 6px 13px; border-radius: 8px; font-size: 12px; font-weight: 700;
            background: #ede9fe; color: #5b21b6;
            text-decoration: none; display: inline-block; border: none; cursor: pointer;
        }
        .btn-invoice:hover { background: #ddd6fe; }

        .empty-state { text-align: center; padding: 64px 24px; }
        .empty-state .icon { font-size: 52px; margin-bottom: 16px; }
        .empty-state h3 { font-size: 18px; font-weight: 700; color: #374151; }
        .empty-state p  { font-size: 14px; color: #9ca3af; margin-top: 8px; }

        /* Pagination */
        .pagination {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px 20px; border-top: 1.5px solid #f0f4ff;
            font-size: 13px; color: #6b7280;
        }
        .pagination-btns { display: flex; gap: 6px; }
        .page-btn {
            width: 32px; height: 32px; border-radius: 8px;
            border: 1.5px solid #d1d9f0; background: #fff;
            font-size: 13px; font-weight: 600; cursor: pointer; color: #374151;
        }
        .page-btn.active { background: #1a56db; color: #fff; border-color: #1a56db; }
        .page-btn:hover:not(.active) { background: #f0f4ff; }

        /* Cancel modal */
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
        .btn-cancel-modal {
            flex: 1; padding: 11px; background: #e5e7eb; color: #374151;
            border: none; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer;
        }
        .btn-confirm-cancel {
            flex: 1; padding: 11px; background: #ef4444; color: #fff;
            border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer;
        }
        .btn-confirm-cancel:hover { background: #dc2626; }
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
            <h1>🎫 Manage Bookings</h1>
            <p>View and manage all passenger bookings</p>
        </div>
    </div>

    <% if (cancelError != null) { %>
        <div class="alert alert-error">⚠ <%= cancelError %></div>
    <% } %>
    <% if (cancelSuccess != null) { %>
        <div class="alert alert-success">✔ <%= cancelSuccess %></div>
    <% } %>

    <%
        int total = 0, paid = 0, pending = 0, cancelled = 0, refunded = 0;
        double revenue = 0;
        if (bookings != null) {
            total = bookings.size();
            for (com.skyconnect.servlet.AdminBookingsServlet.BookingRow b : bookings) {
                String s = b.status != null ? b.status.toLowerCase() : "";
                if (s.equals("paid"))      { paid++;      revenue += b.totalAmount; }
                if (s.equals("pending"))   pending++;
                if (s.equals("cancelled")) cancelled++;
                if (s.equals("refunded"))  refunded++;
            }
        }
    %>

    <div class="stats-strip">
        <div class="stat-chip">
            <div class="chip-label">Total</div>
            <div class="chip-value"><%= total %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Paid</div>
            <div class="chip-value" style="color:#065f46;"><%= paid %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Pending</div>
            <div class="chip-value" style="color:#854d0e;"><%= pending %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Cancelled</div>
            <div class="chip-value" style="color:#991b1b;"><%= cancelled %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Refunded</div>
            <div class="chip-value" style="color:#1e40af;"><%= refunded %></div>
        </div>
        <div class="stat-chip">
            <div class="chip-label">Revenue</div>
            <div class="chip-value">₹<%= String.format("%,.0f", revenue) %></div>
        </div>
    </div>

    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍  Search by booking ID, passenger, flight, route..." onkeyup="filterTable()">
        <select id="statusFilter" onchange="filterTable()">
            <option value="">All Statuses</option>
            <option value="paid">Paid</option>
            <option value="pending">Pending</option>
            <option value="booked">Booked</option>
            <option value="cancelled">Cancelled</option>
            <option value="refunded">Refunded</option>
        </select>
        <button class="btn-export" onclick="exportCSV()">⬇ Export CSV</button>
    </div>

    <div class="card">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">🎫</div>
                <h3>No Bookings Found</h3>
                <p>No bookings have been made yet.</p>
            </div>
        <% } else { %>
        <table id="bookingsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Booking ID</th>
                    <th>Passenger</th>
                    <th>Flight No</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Seats</th>
                    <th>Amount</th>
                    <th>Payment</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="bookingsBody">
                <% int sno = 1;
                   for (com.skyconnect.servlet.AdminBookingsServlet.BookingRow b : bookings) {
                       String st = b.status != null ? b.status : "booked";
                       String bc = "badge-booked";
                       if (st.equalsIgnoreCase("paid"))       bc = "badge-paid";
                       else if (st.equalsIgnoreCase("pending"))   bc = "badge-pending";
                       else if (st.equalsIgnoreCase("cancelled")) bc = "badge-cancelled";
                       else if (st.equalsIgnoreCase("refunded"))  bc = "badge-refunded";
                       boolean canCancel = !st.equalsIgnoreCase("cancelled") && !st.equalsIgnoreCase("refunded");
                %>
                <tr>
                    <td class="sno-cell"><%= sno++ %></td>
                    <td><strong>#<%= b.bookingId %></strong></td>
                    <td>
                        <div style="font-weight:600;"><%= b.userName %></div>
                        <div style="font-size:12px;color:#9ca3af;"><%= b.userEmail %></div>
                    </td>
                    <td><strong><%= b.flightNo %></strong></td>
                    <td>
                        <strong><%= b.source %></strong>
                        <span class="route-arrow">→</span>
                        <strong><%= b.destination %></strong>
                    </td>
                    <td style="color:#6b7280;font-size:13px;"><%= b.flightDate %></td>
                    <td style="text-align:center;"><%= b.seatCount %></td>
                    <td class="amount-col">₹<%= String.format("%,.2f", b.totalAmount) %></td>
                    <td style="font-size:13px;color:#374151;"><%= b.paymentMethod != null ? b.paymentMethod : "—" %></td>
                    <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase() + st.substring(1) %></span></td>
                    <td>
                        <div class="action-btns">
                            <a href="<%= request.getContextPath() %>/invoice?bookingId=<%= b.bookingId %>"
                               class="btn-invoice">🎫 Invoice</a>
                            <% if (canCancel) { %>
                            <button class="btn-cancel"
                                onclick="confirmCancel(<%= b.bookingId %>, '<%= b.userName %>')">
                                ✖ Cancel
                            </button>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="pagination">
            <span id="paginationInfo">Showing all <%= total %> bookings</span>
            <div class="pagination-btns" id="paginationBtns"></div>
        </div>
        <% } %>
    </div>

</div>

<!-- Cancel Modal -->
<div class="modal-overlay" id="cancelModal">
    <div class="modal">
        <div class="modal-icon">⚠</div>
        <h3>Cancel Booking?</h3>
        <p id="cancelModalText">Are you sure you want to cancel this booking?</p>
        <div class="modal-btns">
            <button class="btn-cancel-modal" onclick="closeModal()">Keep Booking</button>
            <form id="cancelForm" method="post" action="<%= request.getContextPath() %>/cancelBooking" style="flex:1;">
                <input type="hidden" name="bookingId" id="cancelBookingId">
                <input type="hidden" name="redirect" value="adminBookings">
                <button type="submit" class="btn-confirm-cancel" style="width:100%;">Yes, Cancel</button>
            </form>
        </div>
    </div>
</div>

<script>
    // --- Modal ---
    function confirmCancel(id, name) {
        document.getElementById('cancelBookingId').value = id;
        document.getElementById('cancelModalText').innerHTML =
            'Cancel booking <strong>#' + id + '</strong> for <strong>' + name + '</strong>?<br>This cannot be undone.';
        document.getElementById('cancelModal').classList.add('active');
    }
    function closeModal() {
        document.getElementById('cancelModal').classList.remove('active');
    }
    document.getElementById('cancelModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    // --- Filter ---
    function filterTable() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const status = document.getElementById('statusFilter').value.toLowerCase();
        const rows   = document.querySelectorAll('#bookingsBody tr');
        let visible  = 0;
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const statusCell = row.querySelector('.badge');
            const rowStatus  = statusCell ? statusCell.textContent.trim().toLowerCase() : '';
            const matchSearch = text.includes(search);
            const matchStatus = status === '' || rowStatus === status;
            if (matchSearch && matchStatus) { row.style.display = ''; visible++; }
            else row.style.display = 'none';
        });
        document.getElementById('paginationInfo').textContent = 'Showing ' + visible + ' booking(s)';
    }

    // --- CSV Export ---
    function exportCSV() {
        const headers = ['#','Booking ID','Passenger','Email','Flight No','Source','Destination',
                         'Date','Seats','Amount','Payment','Status'];
        const rows = document.querySelectorAll('#bookingsBody tr');
        const data = [headers];
        let sno = 1;
        rows.forEach(row => {
            if (row.style.display === 'none') return;
            const cells = row.querySelectorAll('td');
            if (cells.length < 10) return;
            const passenger = cells[2].querySelectorAll('div');
            const name  = passenger[0] ? passenger[0].textContent.trim() : '';
            const email = passenger[1] ? passenger[1].textContent.trim() : '';
            const routeCells = cells[4].textContent.replace('→', '→').split('→');
            data.push([
                sno++,
                cells[1].textContent.trim().replace('#',''),
                name, email,
                cells[3].textContent.trim(),
                routeCells[0] ? routeCells[0].trim() : '',
                routeCells[1] ? routeCells[1].trim() : '',
                cells[5].textContent.trim(),
                cells[6].textContent.trim(),
                cells[7].textContent.trim().replace('₹','').replace(/,/g,''),
                cells[8].textContent.trim(),
                cells[9].textContent.trim()
            ]);
        });
        const csv  = data.map(r => r.map(v => '"' + String(v).replace(/"/g,'""') + '"').join(',')).join('\n');
        const blob = new Blob([csv], { type: 'text/csv' });
        const a    = document.createElement('a');
        a.href     = URL.createObjectURL(blob);
        a.download = 'bookings_report.csv';
        a.click();
    }
</script>

</body>
</html>