<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.controller.UserBookingsServlet.BookingRow" %>
<%
  String userName=(String)session.getAttribute("userName");
  if(userName==null){response.sendRedirect(request.getContextPath()+"/login");return;}
  @SuppressWarnings("unchecked") List<BookingRow> bookings=(List<BookingRow>)request.getAttribute("bookings");
  String cancelSuccess=(String)session.getAttribute("cancelSuccess");
  String cancelError  =(String)session.getAttribute("cancelError");
  session.removeAttribute("cancelSuccess");session.removeAttribute("cancelError");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Bookings – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>

:root{
  --sky:#0EA5E9;--emerald:#10B981;--emerald-dark:#059669;
  --grad:linear-gradient(135deg,var(--sky),var(--emerald));
  --sky-glow:rgba(14,165,233,.18);--em-glow:rgba(16,185,129,.18);
  --bg:#F8FAFC;--card-bg:#FFFFFF;--text:#0F172A;--text-muted:#64748B;
  --border:#E2E8F0;--shadow:0 2px 12px rgba(0,0,0,.06);
  --shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px;
  --sidebar-w:248px;
}
[data-theme="dark"]{
  --bg:#0A0A0F;--card-bg:#111118;--text:#F1F5F9;--text-muted:#94A3B8;
  --border:#1E293B;--shadow:0 2px 12px rgba(0,0,0,.4);
  --shadow-lg:0 12px 40px rgba(0,0,0,.55);
}

*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
h1,h2,h3,.brand-name,.page-title,.card-title{font-family:'Syne',sans-serif}

.as-navbar{position:sticky;top:0;z-index:200;display:flex;align-items:center;justify-content:space-between;padding:0 32px;height:62px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.as-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.as-brand-logo{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:17px;color:#fff;box-shadow:0 3px 12px var(--sky-glow)}
.as-brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem;letter-spacing:-.4px;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.as-nav-links{display:flex;align-items:center;gap:2px}
.as-nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:9px;font-size:.85rem;font-weight:500;transition:all .2s}
.as-nav-link:hover,.as-nav-link.active{color:var(--sky);background:var(--sky-glow)}
.as-nav-link.danger{color:#EF4444}
.as-theme-toggle{width:33px;height:33px;border:1px solid var(--border);border-radius:9px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px}
.as-user-pill{display:flex;align-items:center;gap:7px;padding:5px 12px 5px 5px;border:1px solid var(--border);border-radius:99px;text-decoration:none;color:var(--text);font-size:.82rem;font-weight:600;transition:all .2s}
.as-user-pill:hover{border-color:var(--sky)}
.as-user-avatar-sm{width:26px;height:26px;border-radius:50%;background:var(--grad);color:#fff;display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:800}
.as-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:9px;font-size:.83rem;font-weight:600;text-decoration:none;border:1.5px solid var(--border);cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif;color:var(--text-muted);background:transparent}
.as-btn:hover{border-color:var(--sky);color:var(--sky)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .45s ease forwards}

.page-wrap{max-width:1100px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:20px;flex-wrap:wrap;gap:12px}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.88rem}
.alert{padding:12px 16px;border-radius:11px;margin-bottom:16px;font-size:.85rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-success{background:var(--em-glow);border:1px solid var(--emerald);color:var(--emerald)}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
.filter-bar{display:flex;gap:10px;margin-bottom:16px;flex-wrap:wrap}
.search-wrap{flex:2;min-width:180px;position:relative}
.search-icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text-muted);font-size:13px;pointer-events:none}
.filter-input{width:100%;padding:10px 12px 10px 36px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.87rem;outline:none;transition:border-color .2s}
.filter-input:focus{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.filter-select{padding:10px 14px;background:var(--card-bg);border:1.5px solid var(--border);border-radius:10px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.87rem;outline:none;appearance:none;cursor:pointer;min-width:140px}
.table-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow)}
.table-wrap{overflow-x:auto}
table{width:100%;border-collapse:collapse}
th{padding:11px 16px;text-align:left;font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted);background:var(--bg);border-bottom:1px solid var(--border)}
td{padding:12px 16px;font-size:.85rem;border-bottom:1px solid var(--border)}
tr:last-child td{border-bottom:none}
tbody tr{transition:background .15s}
tbody tr:hover{background:var(--sky-glow)}
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.7rem;font-weight:700;text-transform:uppercase}
.b-paid{background:rgba(16,185,129,.12);color:#059669}[data-theme="dark"] .b-paid{color:#34D399}
.b-cancelled{background:rgba(239,68,68,.1);color:#DC2626}[data-theme="dark"] .b-cancelled{color:#FCA5A5}
.b-booked{background:rgba(14,165,233,.1);color:#0284C7}[data-theme="dark"] .b-booked{color:#7DD3FC}
.btn-cancel{padding:5px 12px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626;border-radius:8px;font-size:.77rem;font-weight:600;cursor:pointer;font-family:'DM Sans',sans-serif;transition:all .2s}
.btn-cancel:hover{background:rgba(239,68,68,.15)}
.btn-receipt{padding:5px 12px;border:1px solid var(--border);border-radius:8px;font-size:.77rem;font-weight:600;color:var(--sky);text-decoration:none;transition:all .2s}
.btn-receipt:hover{border-color:var(--sky);background:var(--sky-glow)}
.empty-state{text-align:center;padding:56px 24px;color:var(--text-muted)}
.empty-icon{font-size:2.5rem;margin-bottom:12px}
.empty-state h3{font-family:'Syne',sans-serif;color:var(--text)}
.no-results{display:none;text-align:center;padding:40px;color:var(--text-muted)}
</style>
</head>
<body>
<%
  String _nUser=(String)session.getAttribute("userName");
  String _nInit=(_nUser!=null&&!_nUser.isEmpty())?String.valueOf(_nUser.charAt(0)).toUpperCase():"U";
  String _nFirst=(_nUser!=null&&_nUser.contains(" "))?_nUser.split(" ")[0]:_nUser;
%>
<nav class="as-navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="as-brand">
    <div class="as-brand-logo">✈</div>
    <span class="as-brand-name">AeroSphere</span>
  </a>
  <div class="as-nav-links">
    <a href="${pageContext.request.contextPath}/userDashboard"     class="as-nav-link ">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/searchFlights"     class="as-nav-link ">🔍 Search</a>
    <a href="${pageContext.request.contextPath}/allFlights"        class="as-nav-link ">✈️ Flights</a>
    <a href="${pageContext.request.contextPath}/userBookings"      class="as-nav-link active">🎫 My Bookings</a>
    <a href="${pageContext.request.contextPath}/userRefundHistory" class="as-nav-link ">💸 Refunds</a>
  </div>
  <div style="display:flex;align-items:center;gap:8px">
    <button class="as-theme-toggle" id="asThemeToggle">🌙</button>
    <a href="${pageContext.request.contextPath}/profile" class="as-user-pill">
      <div class="as-user-avatar-sm"><%=_nInit%></div>
      <span><%=_nFirst%></span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="as-btn">↩ Logout</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header fu">
    <div>
      <h1 class="page-title">🎫 My Bookings</h1>
      <p class="page-subtitle">View, track and manage your flight reservations</p>
    </div>
  </div>
  <% if(cancelSuccess!=null){%><div class="alert alert-success fu">✅ <%=cancelSuccess%></div><%}%>
  <% if(cancelError!=null){  %><div class="alert alert-error  fu">⚠️ <%=cancelError%></div><%}%>
  <% if(bookings==null||bookings.isEmpty()){%>
    <div class="empty-state fu"><div class="empty-icon">🎫</div><h3>No bookings yet</h3><p style="margin-top:8px;font-size:.87rem">Book your first flight to get started.</p><a href="${pageContext.request.contextPath}/searchFlights" style="display:inline-block;margin-top:16px;padding:10px 22px;background:var(--grad);color:#fff;border-radius:10px;text-decoration:none;font-weight:700;font-family:'Syne',sans-serif">Search Flights</a></div>
  <%}else{%>
  <div class="filter-bar fu">
    <div class="search-wrap"><span class="search-icon">🔍</span><input type="text" class="filter-input" id="bSearch" placeholder="Search passenger, flight, route…"></div>
    <select class="filter-select" id="bStatus" onchange="filterBookings()">
      <option value="">All Statuses</option>
      <option value="PAID">Paid</option>
      <option value="BOOKED">Booked</option>
      <option value="CANCELLED">Cancelled</option>
    </select>
  </div>
  <div class="table-card fu">
    <div class="table-wrap">
      <table id="bTable">
        <thead><tr><th>#</th><th>Booking ID</th><th>Flight</th><th>Route</th><th>Date</th><th>Seats</th><th>Amount</th><th>Status</th><th>Actions</th></tr></thead>
        <tbody>
          <% int i=0; for(BookingRow b:bookings){i++;
            String st=b.status!=null?b.status:"BOOKED";
            String bc=st.equals("PAID")?"b-paid":st.equals("CANCELLED")?"b-cancelled":"b-booked"; %>
          <tr data-status="<%=st%>">
            <td style="color:var(--text-muted)"><%=i%></td>
            <td style="color:var(--sky);font-weight:700">#<%=b.id%></td>
            <td><strong style="color:var(--emerald)"><%=b.flightNo%></strong></td>
            <td style="font-size:.83rem"><%=b.source%> <span style="color:var(--sky)">→</span> <%=b.destination%></td>
            <td style="font-size:.82rem;color:var(--text-muted)"><%=b.bookingDate!=null?b.bookingDate.toString().substring(0,10):"—"%></td>
            <td><%=b.seats%></td>
            <td style="color:var(--emerald);font-weight:700">₹<%=String.format("%,.0f",b.amount)%></td>
            <td><span class="badge <%=bc%>"><%=st%></span></td>
            <td style="white-space:nowrap">
              <% if("PAID".equals(st)||"BOOKED".equals(st)){%>
                <form method="post" action="${pageContext.request.contextPath}/cancelBooking" style="display:inline" onsubmit="return confirm('Cancel this booking?')">
                  <input type="hidden" name="bookingId" value="<%=b.id%>">
                  <button type="submit" class="btn-cancel">Cancel</button>
                </form>
              <%}%>
              <% if("CANCELLED".equals(st)){%>
                <a href="${pageContext.request.contextPath}/refundReceipt?bookingId=<%=b.id%>" class="btn-receipt">Receipt</a>
              <%}%>
            </td>
          </tr>
          <%}%>
        </tbody>
      </table>
      <div class="no-results" id="bEmpty">No bookings match your filter.</div>
    </div>
  </div>
  <%}%>
</div>
<script>

(function(){
  var btn=document.getElementById('asThemeToggle');
  if(!btn)return;
  function apply(t){document.documentElement.setAttribute('data-theme',t);localStorage.setItem('asTheme',t);btn.textContent=t==='dark'?'☀️':'🌙';}
  apply(document.documentElement.getAttribute('data-theme')||'light');
  btn.addEventListener('click',function(){apply(document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark');});
})();

document.getElementById('bSearch')&&document.getElementById('bSearch').addEventListener('input',filterBookings);
function filterBookings(){
  var q=(document.getElementById('bSearch')||{value:''}).value.toLowerCase();
  var s=(document.getElementById('bStatus')||{value:''}).value;
  var rows=document.querySelectorAll('#bTable tbody tr');
  var vis=0;
  rows.forEach(function(r){
    var txt=r.textContent.toLowerCase();
    var st=r.getAttribute('data-status')||'';
    var ok=(!q||txt.includes(q))&&(!s||st===s);
    r.style.display=ok?'':'none';
    if(ok)vis++;
  });
  var empty=document.getElementById('bEmpty');
  if(empty)empty.style.display=vis===0?'block':'none';
}
</script>
</body>
</html>
