<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.skyconnect.util.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String bookingIdStr = request.getParameter("bookingId");
    if (bookingIdStr == null) { response.sendRedirect("userDashboard"); return; }
    int bookingId = Integer.parseInt(bookingIdStr);
    double totalAmount = 0;
    String flightNo="", source="", destination="", departDate="", departTime="";
    int numSeats = 0;
    try (Connection con = DBConnection.getConnection()) {
        String sql = "SELECT b.total_amount, b.num_seats, f.flight_no, f.source, f.destination, f.depart_date, f.depart_time FROM bookings b JOIN flights f ON b.flight_id = f.id WHERE b.id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            totalAmount = rs.getDouble("total_amount");
            numSeats    = rs.getInt("num_seats");
            flightNo    = rs.getString("flight_no");
            source      = rs.getString("source");
            destination = rs.getString("destination");
            departDate  = rs.getString("depart_date");
            departTime  = rs.getString("depart_time");
        }
    } catch (Exception e) { e.printStackTrace(); }
    double gst = totalAmount * 0.05;
    double grandTotal = totalAmount + gst;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="userBookings" class="nav-link">My Bookings</a>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper narrow">

    <!-- STEPS -->
    <div class="steps">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
        <div class="step-line done"></div>
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Book</div></div>
        <div class="step-line done"></div>
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Passengers</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
    </div>

    <div class="card card-top-line">
        <div class="card-pad">
            <h2 style="font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;margin-bottom:22px;">💳 Complete Payment</h2>

            <!-- ROUTE STRIP -->
            <div class="route-strip" style="border-radius:12px;margin-bottom:18px;">
                <div class="route-city">
                    <div class="city"><%= source %></div>
                    <div class="label">Origin</div>
                </div>
                <div class="route-arrow">✈</div>
                <div class="route-city">
                    <div class="city"><%= destination %></div>
                    <div class="label">Destination</div>
                </div>
            </div>

            <!-- INFO GRID -->
            <div class="info-grid" style="margin-bottom:18px;">
                <div class="info-item">
                    <label>Flight</label>
                    <span style="color:var(--sky-glow)"><%= flightNo %></span>
                </div>
                <div class="info-item">
                    <label>Booking ID</label>
                    <span>#<%= bookingId %></span>
                </div>
                <div class="info-item">
                    <label>Date</label>
                    <span><%= departDate %></span>
                </div>
                <div class="info-item">
                    <label>Departure</label>
                    <span><%= departTime %></span>
                </div>
                <div class="info-item">
                    <label>Seats</label>
                    <span><%= numSeats %></span>
                </div>
                <div class="info-item">
                    <label>Passenger</label>
                    <span><%= userName %></span>
                </div>
            </div>

            <!-- FARE -->
            <div class="fare-box">
                <div class="section-label" style="margin-bottom:12px;">💰 Fare Breakdown</div>
                <div class="fare-row">
                    <span>Base Fare</span>
                    <span>₹ <%= String.format("%.2f", totalAmount) %></span>
                </div>
                <div class="fare-row">
                    <span>GST (5%)</span>
                    <span>₹ <%= String.format("%.2f", gst) %></span>
                </div>
                <div class="fare-row total">
                    <span>Grand Total</span>
                    <span style="color:var(--gold)">₹ <%= String.format("%.2f", grandTotal) %></span>
                </div>
            </div>

            <hr class="divider">

            <!-- PAYMENT FORM -->
            <form action="processPayment" method="post">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">

                <div class="section-label" style="margin-bottom:12px;">Select Payment Method</div>
                <div class="method-grid">
                    <div class="method-option">
                        <input type="radio" name="paymentMethod" id="upi" value="UPI" required>
                        <label for="upi"><span style="font-size:18px">📱</span> UPI</label>
                    </div>
                    <div class="method-option">
                        <input type="radio" name="paymentMethod" id="card" value="CARD">
                        <label for="card"><span style="font-size:18px">💳</span> Card</label>
                    </div>
                    <div class="method-option">
                        <input type="radio" name="paymentMethod" id="netbanking" value="NETBANKING">
                        <label for="netbanking"><span style="font-size:18px">🏦</span> Net Banking</label>
                    </div>
                    <div class="method-option">
                        <input type="radio" name="paymentMethod" id="cash" value="CASH">
                        <label for="cash"><span style="font-size:18px">💵</span> Cash</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-lg" style="background:linear-gradient(90deg,#059669,#10b981);color:white;box-shadow:0 8px 28px rgba(16,185,129,.3);">
                    🔒 Pay ₹ <%= String.format("%.2f", grandTotal) %> Now
                </button>
            </form>

            <div style="text-align:center;margin-top:12px;font-size:.78rem;color:var(--muted);">
                🔐 <span style="color:#6ee7b7;font-weight:600;">Secure Payment</span> — Your transaction is 100% encrypted
            </div>
        </div>
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
