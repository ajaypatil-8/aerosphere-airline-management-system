<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect("login.jsp"); return; }
    List<Map<String,Object>> refunds = (List<Map<String,Object>>) request.getAttribute("refunds");
    String actionSuccess = (String) session.getAttribute("refundActionSuccess");
    String actionError   = (String) session.getAttribute("refundActionError");
    session.removeAttribute("refundActionSuccess");
    session.removeAttribute("refundActionError");

    int totalR = 0, pendingR = 0, approvedR = 0, rejectedR = 0;
    double totalAmt = 0;
    if (refunds != null) for (Map<String, Object> r : refunds){
        totalR++;
        String st = String.valueOf(r.get("status")).toUpperCase();
        if ("PENDING".equals(st))  pendingR++;
        else if ("APPROVED".equals(st)) { approvedR++; try { totalAmt += Double.parseDouble(String.valueOf(r.get("amount"))); } catch(Exception e2) {} }
        else if ("REJECTED".equals(st)) rejectedR++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Requests – SkyConnect Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .stats-row { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:14px; margin-bottom:24px; }
        .s-chip { background:rgba(13,20,39,.7); border:1px solid var(--border); border-radius:var(--radius); padding:18px 20px; animation:fadeUp .4s ease both; transition:border-color .2s; }
        .s-chip:hover { border-color:var(--border-glow); }
        .s-chip-label { font-size:.72rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); }
        .s-chip-value { font-family:'Syne',sans-serif; font-size:1.8rem; font-weight:800; margin-top:4px; }

        .filter-row { display:flex; gap:12px; flex-wrap:wrap; align-items:center; margin-bottom:20px; }
        .filter-row input, .filter-row select {
            background:rgba(13,20,39,.7); border:1px solid var(--border);
            border-radius:10px; color:var(--white); padding:10px 14px;
            font-family:'DM Sans',sans-serif; font-size:.875rem; outline:none; transition:border-color .2s;
        }
        .filter-row input { flex:1; min-width:220px; }
        .filter-row input:focus, .filter-row select:focus { border-color:var(--sky-glow); }
        .filter-row input::placeholder { color:rgba(255,255,255,.25); }
        .filter-row select option { background:var(--ink-3); }

        .refunds-table { width:100%; border-collapse:collapse; }
        .refunds-table thead th { font-size:.72rem; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); padding:12px 16px; border-bottom:1px solid var(--border); text-align:left; }
        .refunds-table tbody td { padding:14px 16px; border-bottom:1px solid var(--border); font-size:.875rem; }
        .refunds-table tbody tr:hover td { background:rgba(255,255,255,.025); }
        .refunds-table tbody tr:last-child td { border-bottom:none; }

        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.72rem; font-weight:700; }
        .badge-pending  { background:rgba(245,158,11,.15); color:#F59E0B; }
        .badge-approved { background:rgba(16,185,129,.15); color:#10B981; }
        .badge-rejected { background:rgba(239,68,68,.15);  color:#EF4444; }

        .reason-text { max-width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; color:var(--muted); font-size:.82rem; }

        .action-group { display:flex; gap:7px; align-items:center; }
        .btn-approve {
            padding:6px 14px; border-radius:8px; font-size:.78rem; font-weight:700;
            background:rgba(16,185,129,.2); color:#10B981; border:1px solid rgba(16,185,129,.3);
            cursor:pointer; transition:.2s;
        }
        .btn-approve:hover { background:rgba(16,185,129,.35); }
        .btn-reject {
            padding:6px 14px; border-radius:8px; font-size:.78rem; font-weight:700;
            background:rgba(239,68,68,.15); color:#EF4444; border:1px solid rgba(239,68,68,.25);
            cursor:pointer; transition:.2s;
        }
        .btn-reject:hover { background:rgba(239,68,68,.3); }

        /* Action Modal */
        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.6); backdrop-filter:blur(4px); z-index:1000; align-items:center; justify-content:center; }
        .modal-overlay.show { display:flex; }
        .modal-box { background:var(--ink-2); border:1px solid var(--border); border-radius:20px; padding:40px; max-width:460px; width:90%; text-align:center; animation:fadeUp .3s ease both; }
        .modal-icon { font-size:3rem; margin-bottom:16px; }
        .modal-title { font-family:'Syne',sans-serif; font-size:1.2rem; font-weight:700; margin-bottom:8px; }
        .modal-info { color:var(--muted); font-size:.875rem; margin-bottom:28px; line-height:1.6; }
        .modal-btns { display:flex; gap:12px; }
        .btn-modal-cancel { flex:1; padding:12px; background:rgba(255,255,255,.07); border:1px solid var(--border); border-radius:10px; color:var(--white); font-size:.875rem; font-weight:600; cursor:pointer; transition:.2s; }
        .btn-modal-cancel:hover { background:rgba(255,255,255,.12); }
        .btn-modal-approve { flex:1; padding:12px; background:#10B981; border:none; border-radius:10px; color:#fff; font-size:.875rem; font-weight:700; cursor:pointer; transition:.2s; }
        .btn-modal-approve:hover { background:#059669; }
        .btn-modal-reject  { flex:1; padding:12px; background:var(--danger); border:none; border-radius:10px; color:#fff; font-size:.875rem; font-weight:700; cursor:pointer; transition:.2s; }
        .btn-modal-reject:hover  { background:#dc2626; }
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
        <a href="adminFlights"   class="nav-link">Flights</a>
        <a href="adminBookings"  class="nav-link">Bookings</a>
        <a href="adminRefunds"   class="nav-link active">Refunds</a>
        <a href="reports.jsp"    class="nav-link">Reports</a>
        <a href="logout"         class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">💸 Refund Requests</h1>
            <p class="page-subtitle">Review and process passenger refund requests</p>
        </div>
        <% if (pendingR > 0) { %>
        <div style="background:rgba(245,158,11,.1);border:1px solid rgba(245,158,11,.3);border-radius:12px;padding:10px 18px;font-size:.9rem;font-weight:600;color:#F59E0B;">
            ⏳ <%= pendingR %> Pending
        </div>
        <% } %>
    </div>

    <% if (actionError   != null) { %><div class="alert alert-error">⚠ <%= actionError %></div><% } %>
    <% if (actionSuccess != null) { %><div class="alert alert-success">✔ <%= actionSuccess %></div><% } %>

    <!-- STATS -->
    <div class="stats-row">
        <div class="s-chip" style="animation-delay:.05s">
            <div class="s-chip-label">Total Requests</div>
            <div class="s-chip-value"><%= totalR %></div>
        </div>
        <div class="s-chip" style="animation-delay:.10s">
            <div class="s-chip-label">Pending</div>
            <div class="s-chip-value" style="color:#F59E0B;"><%= pendingR %></div>
        </div>
        <div class="s-chip" style="animation-delay:.15s">
            <div class="s-chip-label">Approved</div>
            <div class="s-chip-value" style="color:#10B981;"><%= approvedR %></div>
        </div>
        <div class="s-chip" style="animation-delay:.20s">
            <div class="s-chip-label">Rejected</div>
            <div class="s-chip-value" style="color:#EF4444;"><%= rejectedR %></div>
        </div>
        <div class="s-chip" style="animation-delay:.25s">
            <div class="s-chip-label">Total Refunded</div>
            <div class="s-chip-value" style="color:var(--gold);">₹<%= String.format("%,.0f", totalAmt) %></div>
        </div>
    </div>

    <!-- FILTER -->
    <div class="filter-row" style="animation:fadeUp .4s .25s ease both;opacity:0;animation-fill-mode:forwards;">
        <input type="text" id="searchInput" placeholder="🔍  Search by user, flight or reason…">
        <select id="statusFilter">
            <option value="">All Status</option>
            <option value="pending">Pending</option>
            <option value="approved">Approved</option>
            <option value="rejected">Rejected</option>
        </select>
    </div>

    <!-- TABLE -->
    <div class="card" style="animation:fadeUp .4s .3s ease both;opacity:0;animation-fill-mode:forwards;">
        <div class="card-header">
            <span class="card-title">Refund Requests</span>
            <span style="font-size:.8rem;color:var(--muted);"><%= totalR %> total</span>
        </div>
        <div style="overflow-x:auto;">
        <% if (refunds == null || refunds.isEmpty()) { %>
            <div style="text-align:center;padding:80px 24px;color:var(--muted);">
                <div style="font-size:4rem;margin-bottom:16px;">💸</div>
                <p style="font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:rgba(255,255,255,.5);">No refund requests</p>
            </div>
        <% } else { %>
        <table class="refunds-table" id="refundsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Refund ID</th>
                    <th>Passenger</th>
                    <th>Flight</th>
                    <th>Amount</th>
                    <th>Reason</th>
                    <th>Requested</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <% int ri = 0; for (Map<String,Object> r : refunds) { ri++;
               String st = String.valueOf(r.get("status")).toUpperCase();
               String reason = String.valueOf(r.get("reason") != null ? r.get("reason") : "—");
               String user   = String.valueOf(r.get("user")   != null ? r.get("user")   : "—");
               String flight = String.valueOf(r.get("flight") != null ? r.get("flight") : "—");
            %>
            <tr data-user="<%= user.toLowerCase() %>" data-flight="<%= flight.toLowerCase() %>"
                data-reason="<%= reason.toLowerCase() %>" data-status="<%= st.toLowerCase() %>"
                style="animation:fadeUp .4s <%= ri * 0.05 %>s ease both;opacity:0;animation-fill-mode:forwards;">
                <td style="color:var(--muted);font-size:.8rem;"><%= ri %></td>
                <td style="font-family:'Syne',sans-serif;font-size:.85rem;color:var(--sky-glow);">#<%= r.get("id") %></td>
                <td style="font-weight:500;"><%= user %></td>
                <td style="color:var(--sky-glow);font-weight:600;">✈ <%= flight %></td>
                <td style="font-weight:700;color:var(--gold);">₹<%= r.get("amount") %></td>
                <td><div class="reason-text" title="<%= reason %>"><%= reason %></div></td>
                <td style="color:var(--muted);font-size:.82rem;"><%= r.get("requestedAt") != null ? r.get("approvedAt") : "—" %></td>
                <td><span class="badge badge-<%= st.toLowerCase() %>"><%= st %></span></td>
                <td>
                    <% if ("PENDING".equals(st)) { %>
                    <div class="action-group">
                        <button class="btn-approve" onclick="openModal(<%= r.get("id") %>, '<%= user %>', '<%= r.get("amount") %>', 'APPROVE')">✔ Approve</button>
                        <button class="btn-reject"  onclick="openModal(<%= r.get("id") %>, '<%= user %>', '<%= r.get("amount") %>', 'REJECT')">✕ Reject</button>
                    </div>
                    <% } else { %>
                    <span style="color:var(--muted);font-size:.8rem;">—</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
        </div>
    </div>
</div>

<!-- Action Modal -->
<div class="modal-overlay" id="actionModal">
    <div class="modal-box">
        <div class="modal-icon" id="modalIcon">💸</div>
        <div class="modal-title" id="modalTitle">Approve Refund?</div>
        <div class="modal-info"  id="modalInfo">Processing refund…</div>
        <div class="modal-btns" id="modalBtns"></div>
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

function openModal(id, user, amount, action) {
    const isApprove = action === 'APPROVE';
    document.getElementById('modalIcon').textContent = isApprove ? '✔' : '✕';
    document.getElementById('modalTitle').textContent = isApprove ? 'Approve Refund?' : 'Reject Refund?';
    document.getElementById('modalInfo').innerHTML =
        `<strong>${user}</strong> has requested a refund of <strong style="color:var(--gold)">₹${amount}</strong>.<br>
        ${isApprove ? 'This will process the refund and mark the booking as refunded.' : 'This will reject the refund request.'}`;
    document.getElementById('modalBtns').innerHTML = `
        <button class="btn-modal-cancel" onclick="closeModal()">Cancel</button>
        <form action="approveRefund" method="post" style="flex:1;">
            <input type="hidden" name="refundId" value="${id}">
            <button type="submit" name="action" value="${action}"
                class="${isApprove ? 'btn-modal-approve' : 'btn-modal-reject'}" style="width:100%;">
                ${isApprove ? '✔ Approve Refund' : '✕ Reject Refund'}
            </button>
        </form>`;
    document.getElementById('actionModal').classList.add('show');
}
function closeModal() { document.getElementById('actionModal').classList.remove('show'); }
document.getElementById('actionModal').addEventListener('click', function(e) { if (e.target === this) closeModal(); });

const searchInput  = document.getElementById('searchInput');
const statusFilter = document.getElementById('statusFilter');
function filterTable() {
    const q  = searchInput.value.toLowerCase().trim();
    const st = statusFilter.value;
    document.querySelectorAll('#refundsTable tbody tr').forEach(row => {
        const matchQ  = !q  || row.dataset.user.includes(q) || row.dataset.flight.includes(q) || row.dataset.reason.includes(q);
        const matchSt = !st || row.dataset.status === st;
        row.style.display = matchQ && matchSt ? '' : 'none';
    });
}
searchInput.addEventListener('input', filterTable);
statusFilter.addEventListener('change', filterTable);
</script>
</body>
</html>
