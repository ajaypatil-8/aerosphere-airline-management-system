<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.AdminBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<BookingRow> bookings = (List<BookingRow>) request.getAttribute("bookings");
    String cancelSuccess = (String) session.getAttribute("cancelSuccess");
    String cancelError   = (String) session.getAttribute("cancelError");
    session.removeAttribute("cancelSuccess"); session.removeAttribute("cancelError");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>All Bookings – SkyConnect Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span> <small style="font-size:.6rem;color:var(--gold);font-weight:700;">ADMIN</small></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/adminFlights"   class="nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/adminBookings"  class="nav-link active">Bookings</a>
    <a href="${pageContext.request.contextPath}/adminRefunds"   class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/reports"        class="nav-link">Reports</a>
    <a href="${pageContext.request.contextPath}/logout"         class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">📋 All Bookings</h1>
      <p class="page-subtitle"><%= bookings != null ? bookings.size() : 0 %> total reservations</p>
    </div>
  </div>

  <% if (cancelError != null)   { %><div class="alert alert-error">⚠ <%= cancelError %></div><% } %>
  <% if (cancelSuccess != null) { %><div class="alert alert-success">✅ <%= cancelSuccess %></div><% } %>

  <div class="filter-bar animate-fadeup">
    <div class="filter-wrap" style="flex:2;"><span class="filter-icon">🔍</span><input class="filter-input" id="searchBox" type="text" placeholder="Search passenger, flight..."></div>
    <select class="filter-select" id="statusFilter">
      <option value="">All Statuses</option>
      <option value="booked">Booked</option>
      <option value="paid">Paid</option>
      <option value="cancelled">Cancelled</option>
    </select>
  </div>

  <div class="table-wrap animate-fadeup">
    <% if (bookings == null || bookings.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">📋</div><h3>No bookings yet</h3></div>
    <% } else { %>
    <table class="sc-table" id="bookTable">
      <thead><tr><th>#</th><th>ID</th><th>Passenger</th><th>Flight</th><th>Seats</th><th>Amount</th><th>Status</th><th>Booked On</th><th>Action</th></tr></thead>
      <tbody>
      <% int bi = 0; for (BookingRow b : bookings) { bi++;
         String st = b.status != null ? b.status.toLowerCase() : "booked";
         String bc = st.equals("paid") ? "badge-paid" : st.equals("cancelled") ? "badge-cancelled" : "badge-booked";
      %>
      <tr>
        <td class="text-dim"><%= bi %></td>
        <td style="color:var(--sky-glow);font-weight:700;">#<%= b.id %></td>
        <td style="font-weight:500;"><%= b.userName %></td>
        <td><strong><%= b.flightNo %></strong></td>
        <td style="text-align:center"><%= b.seats %></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f", b.amount) %></td>
        <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
        <td style="font-size:.8rem;color:var(--muted);"><%= b.bookedOn != null ? b.bookedOn.toString().substring(0,10) : "—" %></td>
        <td>
          <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.id %>" class="btn btn-secondary btn-sm">🎫 Invoice</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

<script>
function filterTable(){
  const q=document.getElementById('searchBox').value.toLowerCase();
  const s=document.getElementById('statusFilter').value.toLowerCase();
  document.querySelectorAll('#bookTable tbody tr').forEach(r=>{
    const txt=r.textContent.toLowerCase();
    r.style.display=(txt.includes(q)&&(s===''||txt.includes(s)))?'':'none';
  });
}
document.getElementById('searchBox')?.addEventListener('input',filterTable);
document.getElementById('statusFilter')?.addEventListener('change',filterTable);
const s2=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s2.appendChild(e);}
</script>
</body></html>
