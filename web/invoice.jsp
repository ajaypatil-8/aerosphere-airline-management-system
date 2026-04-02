<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat, java.util.*" %>
<%
    String userName2 = (String) session.getAttribute("userName");
    if (userName2 == null) { response.sendRedirect("login.jsp"); return; }

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

    double amount     = (amountObj != null) ? amountObj : 0.0;
    double gst        = amount * 0.05;
    double totalAmt   = amount + gst;

    Double  paidAmount     = (Double) request.getAttribute("paidAmount");
    String  paymentMethod  = (String) request.getAttribute("paymentMethod");
    String  paymentStatus  = (String) request.getAttribute("paymentStatus");
    boolean isPaid         = paidAmount != null && "SUCCESS".equals(paymentStatus);

    List<com.skyconnect.servlet.InvoiceServlet.Passenger> passengers =
        (List<com.skyconnect.servlet.InvoiceServlet.Passenger>) request.getAttribute("passengers");

    boolean isCancelled = "CANCELLED".equals(status);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ticket / Invoice - SkyConnect</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4ff; color: #222; }

        /* NAVBAR */
        .navbar {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 14px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .navbar .brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
        .nav-links a {
            color: #fff; text-decoration: none; margin-left: 22px;
            font-size: 14px; font-weight: 500; opacity: 0.9;
        }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }

        .container { max-width: 860px; margin: 36px auto; padding: 0 20px; }

        /* TICKET CARD */
        .ticket-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.11);
            overflow: hidden;
        }

        /* TICKET HEADER */
        .ticket-header {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 28px 36px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .ticket-header .brand { font-size: 24px; font-weight: 800; }
        .ticket-header .booking-id { font-size: 14px; opacity: 0.85; margin-top: 4px; }
        .ticket-header .status-badge {
            padding: 8px 20px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-booked   { background: #d1fae5; color: #065f46; }
        .badge-paid     { background: #dbeafe; color: #1e3a8a; }
        .badge-cancelled{ background: #fee2e2; color: #991b1b; }

        /* ROUTE STRIP */
        .route-strip {
            background: #f8faff;
            padding: 24px 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            border-bottom: 1.5px dashed #dde3f5;
        }
        .route-city { text-align: center; }
        .route-city .city { font-size: 28px; font-weight: 800; color: #1a56db; }
        .route-city .label { font-size: 12px; color: #888; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 2px; }
        .route-arrow { font-size: 28px; color: #0ea5e9; }

        /* BODY */
        .ticket-body { padding: 30px 36px; }

        /* INFO GRID */
        .info-section { margin-bottom: 28px; }
        .section-title {
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: #1a56db;
            border-bottom: 2px solid #eef4ff;
            padding-bottom: 8px;
            margin-bottom: 16px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        .info-item label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #888;
            margin-bottom: 4px;
        }
        .info-item span {
            font-size: 15px;
            font-weight: 600;
            color: #333;
        }

        /* FARE TABLE */
        .fare-table { width: 100%; border-collapse: collapse; margin-bottom: 6px; }
        .fare-table td {
            padding: 10px 14px;
            font-size: 14px;
            border-bottom: 1px solid #f0f4ff;
            color: #555;
        }
        .fare-table td:last-child { text-align: right; font-weight: 600; }
        .fare-table tr.total td {
            font-size: 18px;
            font-weight: 700;
            color: #059669;
            border-top: 2px dashed #d1d9f0;
            border-bottom: none;
        }

        /* PASSENGER TABLE */
        .pass-table { width: 100%; border-collapse: collapse; }
        .pass-table th {
            background: #f0f4ff;
            color: #555;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 10px 14px;
            text-align: left;
            border-bottom: 2px solid #dde3f5;
        }
        .pass-table td {
            padding: 11px 14px;
            font-size: 14px;
            border-bottom: 1px solid #f0f4ff;
            color: #444;
        }
        .pass-table tr:last-child td { border-bottom: none; }
        .pass-table tr:hover td { background: #f7f9ff; }
        .seat-tag {
            background: #dbeafe;
            color: #1e40af;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }

        /* PAYMENT BOX */
        .payment-box {
            background: #f8faff;
            border-radius: 12px;
            padding: 18px 22px;
        }
        .payment-box .pay-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #555;
            margin-bottom: 8px;
        }
        .payment-box .pay-row span:last-child { font-weight: 600; }
        .alert-pending {
            background: #fffbeb;
            border: 1.5px solid #fbbf24;
            color: #92400e;
            border-radius: 10px;
            padding: 14px 18px;
            font-size: 14px;
            font-weight: 600;
        }
        .alert-cancelled {
            background: #fef2f2;
            border: 1.5px solid #fca5a5;
            color: #991b1b;
            border-radius: 10px;
            padding: 14px 18px;
            font-size: 14px;
            font-weight: 600;
        }
        .alert-refunded {
            background: #f0fdf4;
            border: 1.5px solid #6ee7b7;
            color: #065f46;
            border-radius: 10px;
            padding: 14px 18px;
            font-size: 14px;
            font-weight: 700;
            margin-top: 10px;
        }

        /* ACTION BUTTONS */
        .action-row {
            display: flex;
            gap: 12px;
            padding: 24px 36px;
            background: #f8faff;
            border-top: 1.5px solid #eef0f8;
            flex-wrap: wrap;
        }
        .btn {
            padding: 11px 26px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: opacity 0.2s, transform 0.1s;
            display: inline-block;
        }
        .btn:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-primary { background: linear-gradient(90deg,#1a56db,#0ea5e9); color: #fff; }
        .btn-secondary { background: #e5e7eb; color: #374151; }
        .btn-warning  { background: linear-gradient(90deg,#f59e0b,#fbbf24); color: #fff; }

        /* PRINT */
        @media print {
            .navbar, .action-row { display: none; }
            body { background: #fff; }
            .container { margin: 0; }
            .ticket-card { box-shadow: none; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="userDashboard" class="brand">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="userDashboard">Dashboard</a>
        <a href="userBookings">My Bookings</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
<div class="ticket-card">

    <!-- HEADER -->
    <div class="ticket-header">
        <div>
            <div class="brand">✈ SkyConnect</div>
            <div class="booking-id">Booking ID: #<%= bookingId %></div>
        </div>
        <div class="status-badge <%=
            isCancelled         ? "badge-cancelled" :
            isPaid              ? "badge-paid"      : "badge-booked" %>">
            <%= isCancelled ? "❌ Cancelled" : isPaid ? "✅ Paid" : "⏳ Booked" %>
        </div>
    </div>

    <!-- ROUTE STRIP -->
    <div class="route-strip">
        <div class="route-city">
            <div class="city"><%= source %></div>
            <div class="label">Origin</div>
        </div>
        <div class="route-arrow">✈ ──────────</div>
        <div class="route-city">
            <div class="city"><%= destination %></div>
            <div class="label">Destination</div>
        </div>
    </div>

    <!-- BODY -->
    <div class="ticket-body">

        <!-- FLIGHT INFO -->
        <div class="info-section">
            <div class="section-title">✈ Flight Information</div>
            <div class="info-grid">
                <div class="info-item">
                    <label>Flight No</label>
                    <span><%= flightNo %></span>
                </div>
                <div class="info-item">
                    <label>Departure Date</label>
                    <span><%= departDate %></span>
                </div>
                <div class="info-item">
                    <label>Departure Time</label>
                    <span><%= departTime %></span>
                </div>
                <div class="info-item">
                    <label>Arrival Time</label>
                    <span><%= arrivalTime != null ? arrivalTime : "-" %></span>
                </div>
                <div class="info-item">
                    <label>Total Seats</label>
                    <span><%= seats %></span>
                </div>
                <div class="info-item">
                    <label>Booked By</label>
                    <span><%= uName %> (<%= userEmail %>)</span>
                </div>
            </div>
        </div>

        <!-- FARE SUMMARY -->
        <div class="info-section">
            <div class="section-title">💰 Fare Summary</div>
            <table class="fare-table">
                <tr>
                    <td>Base Fare</td>
                    <td>₹ <%= df.format(amount) %></td>
                </tr>
                <tr>
                    <td>GST (5%)</td>
                    <td>₹ <%= df.format(gst) %></td>
                </tr>
                <tr class="total">
                    <td>Total Amount</td>
                    <td>₹ <%= df.format(totalAmt) %></td>
                </tr>
            </table>
        </div>

        <!-- PASSENGERS -->
        <div class="info-section">
            <div class="section-title">👥 Passenger Details</div>
            <% if (passengers == null || passengers.isEmpty()) { %>
                <p style="color:#888;font-size:14px;">No passenger details found.</p>
            <% } else { %>
            <table class="pass-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Gender</th>
                        <th>Seat No</th>
                    </tr>
                </thead>
                <tbody>
                <% int i = 1;
                   for (com.skyconnect.servlet.InvoiceServlet.Passenger p : passengers) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong><%= p.name %></strong></td>
                        <td><%= p.age %></td>
                        <td><%= p.gender %></td>
                        <td><span class="seat-tag"><%= p.seatNo != null ? p.seatNo : "AUTO" %></span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>

        <!-- PAYMENT -->
        <div class="info-section">
            <div class="section-title">💳 Payment Details</div>
            <% if (isCancelled) { %>
                <div class="alert-cancelled">❌ Booking Cancelled — Payment Disabled</div>
            <% } else if (!isPaid) { %>
                <div class="alert-pending">
                    ⏳ Payment Pending
                    <a href="payment.jsp?bookingId=<%= bookingId %>"
                       style="margin-left:16px;background:#f59e0b;color:#fff;
                              padding:6px 18px;border-radius:8px;
                              text-decoration:none;font-size:13px;">
                        Pay Now
                    </a>
                </div>
            <% } else { %>
                <div class="payment-box">
                    <div class="pay-row"><span>Paid Amount</span><span>₹ <%= df.format(paidAmount) %></span></div>
                    <div class="pay-row"><span>Payment Method</span><span><%= paymentMethod %></span></div>
                    <div class="pay-row"><span>Payment Status</span><span><%= paymentStatus %></span></div>
                </div>
            <% } %>
            <% if ("REFUNDED".equals(paymentStatus)) { %>
                <div class="alert-refunded">✅ Refund Completed Successfully</div>
            <% } %>
        </div>

    </div><!-- /ticket-body -->

    <!-- ACTIONS -->
    <div class="action-row">
        <button onclick="window.print()" class="btn btn-primary">🖨️ Print Ticket</button>
        <a href="userBookings" class="btn btn-secondary">← My Bookings</a>
        <a href="userDashboard" class="btn btn-secondary">🏠 Dashboard</a>
    </div>

</div><!-- /ticket-card -->
</div><!-- /container -->

</body>
</html>