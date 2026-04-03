<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<com.skyconnect.servlet.AdminFlightsServlet.Flight> flights =
        (List<com.skyconnect.servlet.AdminFlightsServlet.Flight>) request.getAttribute("flights");
    String deleteError   = (String) session.getAttribute("deleteError");
    String deleteSuccess = (String) session.getAttribute("deleteSuccess");
    session.removeAttribute("deleteError");
    session.removeAttribute("deleteSuccess");
    int totalFlights   = flights != null ? flights.size() : 0;
    int activeFlights  = 0;
    double totalSeats  = 0;
    if (flights != null) for (var f : flights) { if (f.seatsAvailable > 0) activeFlights++; totalSeats += f.seatsAvailable; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Flights – SkyConnect Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .stats-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px,1fr)); gap:14px; margin-bottom:24px; }
        .s-chip {
            background: rgba(13,20,39,.7); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 18px 20px;
            animation: fadeUp .4s ease both;
            transition: border-color .2s;
        }
        .s-chip:hover { border-color: var(--border-glow); }
        .s-chip-label { font-size: .72rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); }
        .s-chip-value { font-family:'Syne',sans-serif; font-size:1.8rem; font-weight:800; margin-top:4px; }

        .filter-row {
            display: flex; gap: 12px; flex-wrap: wrap; align-items: center;
            margin-bottom: 20px;
        }
        .filter-row input, .filter-row select {
            background: rgba(13,20,39,.7); border: 1px solid var(--border);
            border-radius: 10px; color: var(--white);
            padding: 10px 14px; font-family: 'DM Sans',sans-serif;
            font-size: .875rem; outline: none; transition: border-color .2s;
        }
        .filter-row input { flex: 1; min-width: 200px; }
        .filter-row input:focus, .filter-row select:focus { border-color: var(--sky-glow); }
        .filter-row input::placeholder { color: rgba(255,255,255,.25); }
        .filter-row select option { background: var(--ink-3); }

        .flights-table { width: 100%; border-collapse: collapse; }
        .flights-table thead th {
            font-size: .72rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em;
            color: var(--muted); padding: 12px 16px;
            border-bottom: 1px solid var(--border); text-align:left;
        }
        .flights-table tbody td { padding: 14px 16px; border-bottom: 1px solid var(--border); font-size: .875rem; }
        .flights-table tbody tr:hover td { background: rgba(255,255,255,.025); }
        .flights-table tbody tr:last-child td { border-bottom: none; }

        .route-cell { display:flex; align-items:center; gap:8px; font-weight:600; }
        .city-code-sm { font-family:'Syne',sans-serif; font-size:.95rem; font-weight:800; }
        .route-arrow { color: var(--sky-glow); font-size:.85rem; }

        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.72rem; font-weight:700; }
        .badge-active   { background:rgba(16,185,129,.15); color:#10B981; }
        .badge-soldout  { background:rgba(239,68,68,.15);  color:#EF4444; }

        .seats-bar { width:80px; height:6px; background:rgba(255,255,255,.1); border-radius:3px; overflow:hidden; display:inline-block; vertical-align:middle; margin-left:8px; }
        .seats-fill { height:100%; border-radius:3px; background: linear-gradient(90deg,var(--sky),var(--sky-glow)); }

        .action-group { display:flex; gap:8px; }

        /* Delete Modal */
        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.6); backdrop-filter:blur(4px); z-index:1000; align-items:center; justify-content:center; }
        .modal-overlay.show { display:flex; }
        .modal-box { background:var(--ink-2); border:1px solid var(--border); border-radius:20px; padding:40px; max-width:420px; width:90%; text-align:center; animation:fadeUp .3s ease both; }
        .modal-icon { font-size:3rem; margin-bottom:16px; }
        .modal-title { font-family:'Syne',sans-serif; font-size:1.2rem; font-weight:700; margin-bottom:8px; }
        .modal-sub { color:var(--muted); font-size:.875rem; margin-bottom:28px; }
        .modal-btns { display:flex; gap:12px; }
        .btn-cancel-modal { flex:1; padding:12px; background:rgba(255,255,255,.07); border:1px solid var(--border); border-radius:10px; color:var(--white); font-size:.875rem; font-weight:600; cursor:pointer; transition:.2s; }
        .btn-cancel-modal:hover { background:rgba(255,255,255,.12); }
        .btn-confirm-delete { flex:1; padding:12px; background:var(--danger); border:none; border-radius:10px; color:#fff; font-size:.875rem; font-weight:700; cursor:pointer; transition:.2s; }
        .btn-confirm-delete:hover { background:#dc2626; }
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
        <a href="reports.jsp"    class="nav-link">Reports</a>
        <a href="logout"         class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">✈ Manage Flights</h1>
            <p class="page-subtitle">Schedule, edit and remove flights</p>
        </div>
        <a href="admin_add_flight.jsp" class="btn btn-blue">+ Add New Flight</a>
    </div>

    <% if (deleteError != null) { %><div class="alert alert-error">⚠ <%= deleteError %></div><% } %>
    <% if (deleteSuccess != null) { %><div class="alert alert-success">✔ <%= deleteSuccess %></div><% } %>

    <!-- STATS -->
    <div class="stats-row">
        <div class="s-chip" style="animation-delay:.05s">
            <div class="s-chip-label">Total Flights</div>
            <div class="s-chip-value"><%= totalFlights %></div>
        </div>
        <div class="s-chip" style="animation-delay:.10s">
            <div class="s-chip-label">With Open Seats</div>
            <div class="s-chip-value" style="color:var(--success);"><%= activeFlights %></div>
        </div>
        <div class="s-chip" style="animation-delay:.15s">
            <div class="s-chip-label">Available Seats</div>
            <div class="s-chip-value" style="color:var(--sky-glow);"><%= (int)totalSeats %></div>
        </div>
    </div>

    <!-- FILTER -->
    <div class="filter-row" style="animation:fadeUp .4s .2s ease both;opacity:0;animation-fill-mode:forwards;">
        <input type="text" id="searchInput" placeholder="🔍  Search by flight no, source or destination…">
        <select id="statusFilter">
            <option value="">All Status</option>
            <option value="available">With Seats</option>
            <option value="soldout">Sold Out</option>
        </select>
    </div>

    <!-- TABLE -->
    <div class="card" style="animation:fadeUp .4s .3s ease both;opacity:0;animation-fill-mode:forwards;">
        <div class="card-header">
            <span class="card-title">Flight Schedule</span>
            <span style="font-size:.8rem;color:var(--muted);"><%= totalFlights %> flights</span>
        </div>
        <div style="overflow-x:auto;">
        <% if (flights == null || flights.isEmpty()) { %>
            <div style="text-align:center;padding:80px 24px;color:var(--muted);">
                <div style="font-size:4rem;margin-bottom:16px;">✈</div>
                <p style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:rgba(255,255,255,.5);">No flights scheduled</p>
                <p style="margin-top:8px;font-size:.875rem;">Add your first flight to get started</p>
                <a href="admin_add_flight.jsp" class="btn btn-blue" style="margin-top:20px;display:inline-block;">+ Add Flight</a>
            </div>
        <% } else { %>
        <table class="flights-table" id="flightsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Flight No.</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Price</th>
                    <th>Seats</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% int fi = 0; for (com.skyconnect.servlet.AdminFlightsServlet.Flight f : flights) { fi++;
               String src3  = f.source.length()      >= 3 ? f.source.substring(0,3).toUpperCase()      : f.source.toUpperCase();
               String dst3  = f.destination.length() >= 3 ? f.destination.substring(0,3).toUpperCase() : f.destination.toUpperCase();
               int pct = f.seatsTotal > 0 ? (int)(((double)f.seatsAvailable / f.seatsTotal) * 100) : 0;
            %>
            <tr data-fn="<%= f.flightNo.toLowerCase() %>" data-src="<%= f.source.toLowerCase() %>" data-dst="<%= f.destination.toLowerCase() %>" data-avail="<%= f.seatsAvailable %>"
                style="animation:fadeUp .4s <%= fi * 0.05 %>s ease both;opacity:0;animation-fill-mode:forwards;">
                <td style="color:var(--muted);font-size:.8rem;"><%= fi %></td>
                <td><span style="font-family:'Syne',sans-serif;font-size:.95rem;font-weight:700;color:var(--sky-glow);">✈ <%= f.flightNo %></span></td>
                <td>
                    <div class="route-cell">
                        <span class="city-code-sm" style="color:var(--gold);"><%= src3 %></span>
                        <span class="route-arrow">→</span>
                        <span class="city-code-sm" style="color:var(--sky-glow);"><%= dst3 %></span>
                    </div>
                    <div style="font-size:.75rem;color:var(--muted);margin-top:2px;"><%= f.source %> → <%= f.destination %></div>
                </td>
                <td style="font-size:.85rem;"><%= f.departDate %></td>
                <td style="color:var(--sky-glow);font-weight:600;font-size:.875rem;"><%= f.departTime %></td>
                <td style="color:var(--muted);font-size:.875rem;"><%= f.arrivalTime != null ? f.arrivalTime : "—" %></td>
                <td style="font-weight:700;color:var(--gold);">₹<%= String.format("%,.0f", f.price) %></td>
                <td>
                    <span style="font-size:.85rem;font-weight:600;"><%= f.seatsAvailable %>/<%= f.seatsTotal %></span>
                    <div class="seats-bar"><div class="seats-fill" style="width:<%= pct %>%"></div></div>
                </td>
                <td>
                    <span class="badge <%= f.seatsAvailable > 0 ? "badge-active" : "badge-soldout" %>">
                        <%= f.seatsAvailable > 0 ? "OPEN" : "SOLD OUT" %>
                    </span>
                </td>
                <td>
                    <div class="action-group">
                        <a href="editFlight?flightId=<%= f.id %>" class="btn btn-ghost btn-sm">✏ Edit</a>
                        <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= f.id %>, '<%= f.flightNo %>', '<%= f.source %>', '<%= f.destination %>')">🗑 Delete</button>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box">
        <div class="modal-icon">🗑</div>
        <div class="modal-title">Delete Flight?</div>
        <div class="modal-sub" id="deleteModalSub">This will permanently remove this flight and all associated bookings.</div>
        <div class="modal-btns">
            <button class="btn-cancel-modal" onclick="closeModal()">Cancel</button>
            <form id="deleteForm" action="deleteFlight" method="post" style="flex:1">
                <input type="hidden" name="flightId" id="deleteFlightId">
                <button type="submit" class="btn-confirm-delete" style="width:100%">Delete Flight</button>
            </form>
        </div>
    </div>
</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.2+Math.random()*.45};`;
    s.appendChild(el);
}

function confirmDelete(id, fn, src, dst) {
    document.getElementById('deleteFlightId').value = id;
    document.getElementById('deleteModalSub').textContent =
        `Flight ${fn} (${src} → ${dst}) will be permanently deleted along with all bookings.`;
    document.getElementById('deleteModal').classList.add('show');
}
function closeModal() { document.getElementById('deleteModal').classList.remove('show'); }
document.getElementById('deleteModal').addEventListener('click', function(e) { if (e.target === this) closeModal(); });

// Filter
const searchInput = document.getElementById('searchInput');
const statusFilter = document.getElementById('statusFilter');
function filterTable() {
    const q = searchInput.value.toLowerCase().trim();
    const st = statusFilter.value;
    document.querySelectorAll('#flightsTable tbody tr').forEach(row => {
        const fn  = row.dataset.fn  || '';
        const src = row.dataset.src || '';
        const dst = row.dataset.dst || '';
        const avail = parseInt(row.dataset.avail) || 0;
        const matchQ  = !q || fn.includes(q) || src.includes(q) || dst.includes(q);
        const matchSt = !st || (st === 'available' && avail > 0) || (st === 'soldout' && avail === 0);
        row.style.display = matchQ && matchSt ? '' : 'none';
    });
}
searchInput.addEventListener('input', filterTable);
statusFilter.addEventListener('change', filterTable);
</script>
</body>
</html>
