<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat, java.util.*" %>
<%
    String userName2 = (String) session.getAttribute("userName");
    if (userName2 == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    DecimalFormat df = new DecimalFormat("0.00");
    Integer bookingId   = (Integer) request.getAttribute("bookingId");
    String  uName       = (String)  request.getAttribute("userName");
    String  userEmail   = (String)  request.getAttribute("userEmail");
    String  flightNo    = (String)  request.getAttribute("flightNo");
    String  source      = (String)  request.getAttribute("source");
    String  destination = (String)  request.getAttribute("destination");
    String  departDate  = (String)  request.getAttribute("departDate");
    String  departTime  = (String)  request.getAttribute("departTime");
    String  arrivalTime = (String)  request.getAttribute("arrivalTime");
    Integer seats       = (Integer) request.getAttribute("seats");
    Double  amountObj   = (Double)  request.getAttribute("amount");
    String  status      = (String)  request.getAttribute("status");
    double amount    = (amountObj != null) ? amountObj : 0.0;
    double gst       = amount * 0.05;
    double totalAmt  = amount + gst;
    Double  paidAmount    = (Double) request.getAttribute("paidAmount");
    String  paymentMethod = (String) request.getAttribute("paymentMethod");
    String  paymentStatus = (String) request.getAttribute("paymentStatus");
    boolean isPaid        = paidAmount != null && "SUCCESS".equals(paymentStatus);
    List<com.skyconnect.servlet.InvoiceServlet.Passenger> passengers =
        (List<com.skyconnect.servlet.InvoiceServlet.Passenger>) request.getAttribute("passengers");
    boolean isCancelled = "CANCELLED".equals(status);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket / Invoice #<%= bookingId %> – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body>

<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar no-print">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userBookings" class="nav-link">← My Bookings</a>
        <button onclick="window.print()" class="btn btn-blue btn-sm no-print">🖨 Print</button>
        <a href="logout" class="nav-link btn-danger no-print">Logout</a>
    </div>
</nav>

<div class="page-wrapper medium" style="max-width:860px;">

    <!-- TICKET HEADER -->
    <div class="card card-top-line" style="margin-bottom:16px;">
        <div style="padding:24px 32px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--border-2);">
            <div>
                <div style="font-family:'Syne',sans-serif;font-size:1.2rem;font-weight:800;">Sky<span style="color:var(--gold)">Connect</span> Airlines</div>
                <div style="color:var(--muted);font-size:.82rem;margin-top:3px;">Booking #<%= bookingId %></div>
            </div>
            <div style="text-align:right;">
                <span class="badge badge-<%= status != null ? status.toLowerCase() : "booked" %>" style="font-size:.82rem;padding:6px 16px;">
                    <%= status %>
                </span>
                <% if (isPaid) { %>
                    <div style="margin-top:6px;"><span class="badge badge-paid" style="font-size:.75rem;">✓ PAID</span></div>
                <% } %>
            </div>
        </div>

        <!-- ROUTE -->
        <div class="route-strip">
            <div class="route-city">
                <div class="city"><%= source %></div>
                <div class="label">Origin</div>
            </div>
            <div style="text-align:center;">
                <div style="font-size:.7rem;color:var(--sky-glow);font-weight:700;text-transform:uppercase;letter-spacing:.8px;margin-bottom:6px;"><%= flightNo %></div>
                <div class="route-arrow">✈</div>
            </div>
            <div class="route-city">
                <div class="city"><%= destination %></div>
                <div class="label">Destination</div>
            </div>
        </div>

        <!-- FLIGHT INFO -->
        <div class="card-pad">
            <div class="section-label" style="margin-bottom:14px;">Flight Details</div>
            <div class="info-grid">
                <div class="info-item"><label>Departure Date</label><span><%= departDate %></span></div>
                <div class="info-item"><label>Departure Time</label><span><%= departTime %></span></div>
                <div class="info-item"><label>Arrival Time</label><span><%= (arrivalTime != null && !arrivalTime.isEmpty()) ? arrivalTime : "—" %></span></div>
                <div class="info-item"><label>Seats</label><span><%= seats %></span></div>
                <div class="info-item"><label>Passenger</label><span><%= uName %></span></div>
                <div class="info-item"><label>Email</label><span style="font-size:.82rem"><%= userEmail != null ? userEmail : "—" %></span></div>
            </div>
        </div>
    </div>

    <!-- PASSENGERS TABLE -->
    <% if (passengers != null && !passengers.isEmpty()) { %>
    <div class="card card-top-line" style="margin-bottom:16px;">
        <div class="card-header">
            <span class="card-header-title">👥 Passengers</span>
        </div>
        <div class="table-wrap">
            <table class="sky-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Gender</th>
                        <th>Seat</th>
                        <th>Phone</th>
                    </tr>
                </thead>
                <tbody>
                <% int p = 0;
                   for (com.skyconnect.servlet.InvoiceServlet.Passenger pass : passengers) { p++; %>
                    <tr>
                        <td style="color:var(--muted)"><%= p %></td>
                        <td><strong><%= pass.fullName %></strong></td>
                        <td><%= pass.age %></td>
                        <td><%= pass.gender %></td>
                        <td><% if (pass.seatNo != null && !pass.seatNo.isEmpty()) { %><span class="badge badge-paid"><%= pass.seatNo %></span><% } else { %>—<% } %></td>
                        <td style="color:var(--muted)"><%= pass.phone != null ? pass.phone : "—" %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <!-- FARE BREAKDOWN -->
    <div class="card card-top-line" style="margin-bottom:16px;">
        <div class="card-pad">
            <div class="section-label" style="margin-bottom:14px;">💰 Fare Breakdown</div>
            <div class="fare-box" style="margin:0;">
                <div class="fare-row"><span>Base Fare</span><span>₹ <%= df.format(amount) %></span></div>
                <div class="fare-row"><span>GST (5%)</span><span>₹ <%= df.format(gst) %></span></div>
                <div class="fare-row total">
                    <span>Grand Total</span>
                    <span style="color:var(--gold)">₹ <%= df.format(totalAmt) %></span>
                </div>
            </div>
            <% if (isPaid) { %>
            <div class="info-grid" style="margin-top:14px;">
                <div class="info-item"><label>Payment Method</label><span><%= paymentMethod %></span></div>
                <div class="info-item"><label>Amount Paid</label><span style="color:#6ee7b7">₹ <%= df.format(paidAmount) %></span></div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- ACTIONS -->
    <div style="display:flex;gap:12px;justify-content:flex-end;" class="no-print">
        <% if (!isCancelled) { %>
            <% if (!isPaid) { %>
                <a href="payment?bookingId=<%= bookingId %>" class="btn btn-blue">💳 Pay Now</a>
            <% } %>
            <form action="cancelBooking" method="post" onsubmit="return confirm('Cancel this booking?');" style="display:inline">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                <button type="submit" class="btn btn-red">✕ Cancel Booking</button>
            </form>
        <% } %>
        <button onclick="window.print()" class="btn btn-ghost">🖨 Print Ticket</button>
    </div>

</div>

<script>
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
