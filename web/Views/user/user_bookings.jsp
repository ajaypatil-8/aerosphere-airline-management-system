<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.UserBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    @SuppressWarnings("unchecked")
    List<BookingRow> bookings = (List<BookingRow>) request.getAttribute("bookings");
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess"); session.removeAttribute("cancelError");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Bookings – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.active{color:var(--primary);background:var(--primary-glow)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
/* PAGE */
.page-wrapper{max-width:1100px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* ALERTS */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.alert-success{background:var(--primary-glow);border:1px solid var(--primary);color:var(--primary)}
/* FILTER BAR */
.filter-bar{display:flex;gap:10px;align-items:center;margin-bottom:18px;animation:fadeUp .5s ease both .05s;flex-wrap:wrap}
.search-input-wrap{flex:2;min-width:180px;position:relative}
.search-icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-muted);font-size:14px;pointer-events:none}
.filter-input{width:100%;padding:10px 12px 10px 36px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;color:var(--text);font-family:'Inter',sans-serif;font-size:.87rem;outline:none;transition:border-color .2s}
.filter-input:focus{border-color:var(--primary)}
.filter-select{padding:10px 14px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;color:var(--text);font-family:'Inter',sans-serif;font-size:.87rem;outline:none;transition:border-color .2s;appearance:none;cursor:pointer;min-width:140px}
.filter-select:focus{border-color:var(--primary)}
/* TABLE */
.table-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);animation:fadeUp .5s ease both .1s}
.table-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse;min-width:760px}
thead th{padding:12px 16px;text-align:left;font-size:.73rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border);white-space:nowrap}
tbody td{padding:12px 16px;font-size:.87rem;border-bottom:1px solid var(--border);vertical-align:middle}
tbody tr:last-child td{border-bottom:none}
tbody tr:hover{background:var(--bg)}
/* BADGES */
.badge{display:inline-flex;align-items:center;padding:3px 10px;border-radius:99px;font-size:.74rem;font-weight:700}
.badge-paid{background:rgba(16,185,129,.12);color:var(--primary);border:1px solid var(--primary)}
.badge-booked{background:rgba(59,130,246,.1);color:#2563EB;border:1px solid rgba(59,130,246,.3)}
[data-theme="dark"] .badge-booked{color:#93C5FD}
.badge-cancelled{background:rgba(239,68,68,.1);color:#DC2626;border:1px solid rgba(239,68,68,.2)}
[data-theme="dark"] .badge-cancelled{color:#FCA5A5}
/* ROUTE */
.route-cell{display:flex;align-items:center;gap:5px}
.route-arrow{color:var(--primary)}
/* ACTIONS */
.action-group{display:flex;gap:6px;flex-wrap:wrap;align-items:center}
.btn{display:inline-flex;align-items:center;gap:4px;padding:6px 11px;border-radius:8px;font-size:.78rem;font-weight:600;text-decoration:none;border:1px solid var(--border);cursor:pointer;transition:all .2s;background:var(--card-bg);color:var(--text)}
.btn:hover{border-color:var(--primary);color:var(--primary)}
.btn-primary{background:var(--primary);color:#fff;border-color:var(--primary);box-shadow:0 2px 6px var(--primary-glow)}.btn-primary:hover{background:var(--primary-dark);color:#fff}
.btn-danger{background:rgba(220,38,38,.08);color:#DC2626;border-color:rgba(220,38,38,.2)}.btn-danger:hover{background:rgba(220,38,38,.15)}
.btn-lg{padding:9px 18px;font-size:.87rem}
.amount{color:var(--primary);font-weight:700}
/* EMPTY */
.empty-state{padding:60px 20px;text-align:center}
.empty-icon{font-size:3rem;margin-bottom:14px;opacity:.4}
.empty-state h3{font-size:1.1rem;font-weight:700;margin-bottom:8px}
.empty-state p{color:var(--text-muted);font-size:.88rem}
</style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link active">My Bookings</a>
        <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">Refunds</a>
        <a href="${pageContext.request.contextPath}/profile"           class="nav-link">Profile</a>
        <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <div class="page-title">🎫 My Bookings</div>
            <div class="page-subtitle"><%= bookings != null ? bookings.size() : 0 %> booking(s) found</div>
        </div>
        <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-lg">← Search Flights</a>
    </div>

    <% if (cancelError != null)   { %><div class="alert alert-error">⚠ <%= cancelError %></div><% } %>
    <% if (cancelSuccess != null) { %><div class="alert alert-success">✅ <%= cancelSuccess %></div><% } %>

    <!-- FILTER BAR -->
    <div class="filter-bar">
        <div class="search-input-wrap">
            <span class="search-icon">🔍</span>
            <input class="filter-input" id="searchBox" type="text" placeholder="Search flight, city...">
        </div>
        <select class="filter-select" id="statusFilter">
            <option value="">All Statuses</option>
            <option value="booked">Booked</option>
            <option value="paid">Paid</option>
            <option value="cancelled">Cancelled</option>
        </select>
    </div>

    <div class="table-card">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">✈</div>
                <h3>No bookings yet</h3>
                <p>Search for a flight to get started.</p>
                <a href="${pageContext.request.contextPath}/userDashboard" style="display:inline-flex;align-items:center;gap:6px;margin-top:16px;padding:10px 20px;background:var(--primary);color:#fff;border-radius:10px;font-weight:600;text-decoration:none;font-size:.88rem">Search Flights →</a>
            </div>
        <% } else { %>
        <div class="table-wrap">
        <table id="bookTable">
            <thead>
                <tr><th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Time</th><th>Seats</th><th>Amount</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
            <% int sno=1; for(BookingRow b : bookings) {
               String st = b.status != null ? b.status.toLowerCase() : "booked";
               String bc = st.equals("paid")?"badge-paid":st.equals("cancelled")?"badge-cancelled":"badge-booked";
               boolean canCancel = !st.equals("cancelled");
               boolean canPay    = "booked".equals(st) && "pending".equalsIgnoreCase(b.paymentStatus != null ? b.paymentStatus : "");
            %>
            <tr>
                <td style="color:var(--text-muted);font-size:.8rem"><%= sno++ %></td>
                <td><strong style="color:var(--primary)"><%= b.flightNo %></strong></td>
                <td><div class="route-cell"><span><%= b.source %></span><span class="route-arrow">→</span><span><%= b.destination %></span></div></td>
                <td style="font-size:.82rem"><%= b.departDate %></td>
                <td style="font-size:.82rem;color:var(--text-muted)"><%= b.departTime != null ? b.departTime.toString().substring(0,5) : "—" %></td>
                <td style="text-align:center"><%= b.numSeats %></td>
                <td class="amount">₹<%= String.format("%,.0f",b.totalAmount) %></td>
                <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
                <td>
                    <div class="action-group">
                        <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.id %>" class="btn">🎫</a>
                        <% if (canPay) { %>
                            <a href="${pageContext.request.contextPath}/processPayment?bookingId=<%= b.id %>" class="btn btn-primary">💳 Pay</a>
                        <% } %>
                        <% if (canCancel) { %>
                        <form action="${pageContext.request.contextPath}/cancelBooking" method="post" style="margin:0" onsubmit="return confirm('Cancel booking #<%= b.id %>?')">
                            <input type="hidden" name="bookingId" value="<%= b.id %>">
                            <button type="submit" class="btn btn-danger">✕</button>
                        </form>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>
        <% } %>
    </div>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
function filterTable(){
    const q=document.getElementById('searchBox').value.toLowerCase();
    const sv=document.getElementById('statusFilter').value.toLowerCase();
    document.querySelectorAll('#bookTable tbody tr').forEach(r=>{
        r.style.display=(r.textContent.toLowerCase().includes(q)&&(sv===''||r.textContent.toLowerCase().includes(sv)))?'':'none';
    });
}
document.getElementById('searchBox')?.addEventListener('input',filterTable);
document.getElementById('statusFilter')?.addEventListener('change',filterTable);
</script>
</body></html>
