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
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Bookings – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="nav-link active">My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="nav-link">Refunds</a>
    <a href="${pageContext.request.contextPath}/profile"           class="nav-link">Profile</a>
    <a href="${pageContext.request.contextPath}/logout"            class="nav-link btn-danger">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <div class="page-header animate-fadeup">
    <div>
      <h1 class="page-title">🎫 My Bookings</h1>
      <p class="page-subtitle"><%= bookings != null ? bookings.size() : 0 %> booking(s) found</p>
    </div>
    <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-secondary">← Search Flights</a>
  </div>

  <% if (cancelError != null)   { %><div class="alert alert-error">⚠ <%= cancelError %></div><% } %>
  <% if (cancelSuccess != null) { %><div class="alert alert-success">✅ <%= cancelSuccess %></div><% } %>

  <div class="filter-bar animate-fadeup">
    <div class="filter-wrap" style="flex:2;"><span class="filter-icon">🔍</span><input class="filter-input" id="searchBox" type="text" placeholder="Search flight, city..."></div>
    <select class="filter-select" id="statusFilter">
      <option value="">All Statuses</option>
      <option value="booked">Booked</option>
      <option value="paid">Paid</option>
      <option value="cancelled">Cancelled</option>
    </select>
  </div>

  <div class="table-wrap animate-fadeup">
    <% if (bookings == null || bookings.isEmpty()) { %>
      <div class="empty-state"><div class="empty-icon">✈</div><h3>No bookings yet</h3><p>Search for a flight to get started.</p>
        <a href="${pageContext.request.contextPath}/userDashboard" class="btn btn-primary" style="margin-top:16px;">Search Flights</a>
      </div>
    <% } else { %>
    <table class="sc-table" id="bookTable">
      <thead><tr><th>#</th><th>Flight</th><th>Route</th><th>Date</th><th>Time</th><th>Seats</th><th>Amount</th><th>Status</th><th>Actions</th></tr></thead>
      <tbody>
      <% int sno=1; for(BookingRow b : bookings) {
         String st = b.status != null ? b.status.toLowerCase() : "booked";
         String bc = st.equals("paid")?"badge-paid":st.equals("cancelled")?"badge-cancelled":"badge-booked";
         boolean canCancel = !st.equals("cancelled");
         boolean canPay    = "booked".equals(st) && "pending".equalsIgnoreCase(b.paymentStatus != null ? b.paymentStatus : "");
      %>
      <tr>
        <td class="text-dim"><%= sno++ %></td>
        <td><strong style="color:var(--sky-glow)"><%= b.flightNo %></strong></td>
        <td><div class="route-display"><span class="route-city"><%= b.source %></span><span class="route-arrow">→</span><span class="route-city"><%= b.destination %></span></div></td>
        <td style="font-size:.82rem;"><%= b.departDate %></td>
        <td style="font-size:.82rem;color:var(--muted);"><%= b.departTime != null ? b.departTime.toString().substring(0,5) : "—" %></td>
        <td style="text-align:center"><%= b.numSeats %></td>
        <td style="color:var(--gold);font-weight:700;">₹<%= String.format("%,.0f",b.totalAmount) %></td>
        <td><span class="badge <%= bc %>"><%= st.substring(0,1).toUpperCase()+st.substring(1) %></span></td>
        <td>
          <div style="display:flex;gap:6px;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= b.id %>" class="btn btn-secondary btn-sm">🎫</a>
            <% if (canPay) { %>
              <a href="${pageContext.request.contextPath}/processPayment?bookingId=<%= b.id %>" class="btn btn-primary btn-sm">💳 Pay</a>
            <% } %>
            <% if (canCancel) { %>
            <form action="${pageContext.request.contextPath}/cancelBooking" method="post" style="margin:0;" onsubmit="return confirm('Cancel booking #<%= b.id %>?');">
              <input type="hidden" name="bookingId" value="<%= b.id %>">
              <button type="submit" class="btn btn-danger btn-sm">✕</button>
            </form>
            <% } %>
          </div>
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
  const sv=document.getElementById('statusFilter').value.toLowerCase();
  document.querySelectorAll('#bookTable tbody tr').forEach(r=>{
    r.style.display=(r.textContent.toLowerCase().includes(q)&&(sv===''||r.textContent.toLowerCase().includes(sv)))?'':'none';
  });
}
document.getElementById('searchBox')?.addEventListener('input',filterTable);
document.getElementById('statusFilter')?.addEventListener('change',filterTable);
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
