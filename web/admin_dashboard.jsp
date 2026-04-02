<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.ResultSet" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    ResultSet refund = (ResultSet) request.getAttribute("refund");
    String refundId      = "";
    String bookingId     = "";
    String flightNo      = "";
    String source        = "";
    String destination   = "";
    String flightDate    = "";
    String departTime    = "";
    String refundAmount  = "";
    String status        = "";
    String requestedAt   = "";
    String processedAt   = "";
    String paymentMethod = "";
    String passengerCount = "";
    try {
        if (refund != null && refund.next()) {
            refundId       = String.valueOf(refund.getObject("refund_id")     != null ? refund.getObject("refund_id")     : "");
            bookingId      = String.valueOf(refund.getObject("booking_id")    != null ? refund.getObject("booking_id")    : "");
            flightNo       = String.valueOf(refund.getObject("flight_no")     != null ? refund.getObject("flight_no")     : "");
            source         = String.valueOf(refund.getObject("source")        != null ? refund.getObject("source")        : "");
            destination    = String.valueOf(refund.getObject("destination")   != null ? refund.getObject("destination")   : "");
            flightDate     = String.valueOf(refund.getObject("flight_date")   != null ? refund.getObject("flight_date")   : "");
            departTime     = String.valueOf(refund.getObject("depart_time")   != null ? refund.getObject("depart_time")   : "");
            refundAmount   = String.valueOf(refund.getObject("refund_amount") != null ? refund.getObject("refund_amount") : "0");
            status         = String.valueOf(refund.getObject("status")        != null ? refund.getObject("status")        : "pending");
            requestedAt    = String.valueOf(refund.getObject("requested_at")  != null ? refund.getObject("requested_at")  : "");
            processedAt    = String.valueOf(refund.getObject("processed_at")  != null ? refund.getObject("processed_at")  : "—");
            paymentMethod  = String.valueOf(refund.getObject("payment_method")!= null ? refund.getObject("payment_method"): "");
            passengerCount = String.valueOf(refund.getObject("passenger_count")!=null ? refund.getObject("passenger_count"): "");
        }
    } catch (Exception e) { e.printStackTrace(); }

    String badgeClass = "badge-pending";
    if (status.equalsIgnoreCase("approved"))  badgeClass = "badge-approved";
    else if (status.equalsIgnoreCase("refunded"))  badgeClass = "badge-refunded";
    else if (status.equalsIgnoreCase("rejected"))  badgeClass = "badge-rejected";

    double amount = 0;
    try { amount = Double.parseDouble(refundAmount); } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Refund Receipt – SkyConnect</title>
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

        .container { max-width: 680px; margin: 40px auto; padding: 0 16px; }

        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px;
        }
        .page-header h1 { font-size: 22px; font-weight: 700; color: #1a56db; }
        .page-header p  { font-size: 13px; color: #6b7280; margin-top: 2px; }

        .btn-back {
            padding: 9px 20px;
            background: #e5e7eb; color: #374151;
            border-radius: 10px; font-weight: 600; font-size: 13px;
            text-decoration: none; display: inline-block;
        }
        .btn-back:hover { background: #d1d5db; }

        .receipt-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        /* Header strip */
        .receipt-header {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 28px 32px;
            color: #fff;
            display: flex; align-items: center; justify-content: space-between;
        }
        .receipt-header .rh-left h2 { font-size: 20px; font-weight: 700; }
        .receipt-header .rh-left p  { font-size: 13px; opacity: 0.85; margin-top: 4px; }
        .receipt-header .rh-right { text-align: right; }
        .receipt-header .rh-right .amount { font-size: 32px; font-weight: 800; }
        .receipt-header .rh-right .amount-label { font-size: 12px; opacity: 0.8; margin-top: 2px; }

        .badge {
            display: inline-block; padding: 5px 16px;
            border-radius: 20px; font-size: 13px; font-weight: 700;
        }
        .badge-pending  { background: #fef9c3; color: #854d0e; }
        .badge-approved { background: #d1fae5; color: #065f46; }
        .badge-refunded { background: #dbeafe; color: #1e40af; }
        .badge-rejected { background: #fee2e2; color: #991b1b; }

        /* Route strip */
        .route-strip {
            display: flex; align-items: center; justify-content: center;
            gap: 12px; padding: 22px 32px;
            background: #f8faff; border-bottom: 1.5px solid #eef4ff;
        }
        .route-city { text-align: center; }
        .route-city .city-code { font-size: 28px; font-weight: 800; color: #1a56db; }
        .route-city .city-name { font-size: 12px; color: #6b7280; margin-top: 2px; }
        .route-line {
            flex: 1; display: flex; align-items: center; gap: 6px;
            flex-direction: column;
        }
        .route-line .plane { font-size: 22px; }
        .route-line .line {
            width: 100%; height: 2px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            border-radius: 2px;
        }
        .route-line .flight-no { font-size: 11px; color: #6b7280; font-weight: 600; }

        /* Info grid */
        .info-body { padding: 28px 32px; }

        .section-title {
            font-size: 13px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.7px; color: #1a56db;
            border-bottom: 2px solid #eef4ff; padding-bottom: 8px;
            margin-bottom: 18px;
        }

        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 16px; margin-bottom: 28px;
        }
        .info-item .item-label { font-size: 12px; color: #9ca3af; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .info-item .item-value { font-size: 15px; font-weight: 600; color: #111; margin-top: 4px; }

        .divider { border: none; border-top: 1.5px solid #eef4ff; margin: 4px 0 24px 0; }

        /* Amount breakdown */
        .amount-table { width: 100%; border-collapse: collapse; margin-bottom: 28px; }
        .amount-table td { padding: 11px 0; border-bottom: 1px solid #f0f4ff; font-size: 14px; }
        .amount-table td:last-child { text-align: right; font-weight: 600; }
        .amount-table .total-row td { font-size: 16px; font-weight: 800; color: #1a56db; border-bottom: none; padding-top: 14px; }

        /* Status timeline */
        .timeline { display: flex; flex-direction: column; gap: 14px; margin-bottom: 8px; }
        .timeline-item { display: flex; align-items: flex-start; gap: 14px; }
        .tl-dot {
            width: 14px; height: 14px; border-radius: 50%; margin-top: 3px; flex-shrink: 0;
            background: #d1fae5; border: 3px solid #065f46;
        }
        .tl-dot.inactive { background: #f3f4f6; border-color: #d1d5db; }
        .tl-content .tl-title { font-size: 14px; font-weight: 600; color: #111; }
        .tl-content .tl-time  { font-size: 12px; color: #9ca3af; margin-top: 2px; }

        /* Action buttons */
        .action-row {
            display: flex; gap: 12px; padding: 0 32px 28px 32px;
        }
        .btn-print {
            flex: 1; padding: 12px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border: none; border-radius: 10px;
            font-size: 14px; font-weight: 700; cursor: pointer;
        }
        .btn-print:hover { opacity: 0.9; }
        .btn-bookings {
            flex: 1; padding: 12px;
            background: #e5e7eb; color: #374151;
            border: none; border-radius: 10px;
            font-size: 14px; font-weight: 600; cursor: pointer;
            text-decoration: none; display: flex; align-items: center; justify-content: center;
        }
        .btn-bookings:hover { background: #d1d5db; }

        .not-found {
            text-align: center; padding: 64px 24px;
        }
        .not-found .icon { font-size: 52px; margin-bottom: 16px; }
        .not-found h3 { font-size: 18px; font-weight: 700; color: #374151; }
        .not-found p  { font-size: 14px; color: #9ca3af; margin-top: 8px; }

        @media print {
            .navbar, .page-header, .action-row { display: none !important; }
            body { background: #fff; }
            .container { margin: 0; max-width: 100%; }
            .receipt-card { box-shadow: none; border: 1px solid #ddd; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a class="brand" href="index.jsp">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="userDashboard">Dashboard</a>
        <a href="search_flights.jsp">Search</a>
        <a href="userBookings">My Bookings</a>
        <a href="userRefundHistory">My Refunds</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">

    <div class="page-header">
        <div>
            <h1>🧾 Refund Receipt</h1>
            <p>Official refund confirmation from SkyConnect</p>
        </div>
        <a href="<%= request.getContextPath() %>/userRefundHistory" class="btn-back">← My Refunds</a>
    </div>

    <% if (refundId.isEmpty()) { %>
        <div class="receipt-card">
            <div class="not-found">
                <div class="icon">❌</div>
                <h3>Refund Not Found</h3>
                <p>The requested refund receipt could not be located.</p>
            </div>
        </div>
    <% } else { %>

    <div class="receipt-card">

        <!-- Header -->
        <div class="receipt-header">
            <div class="rh-left">
                <h2>Refund Receipt</h2>
                <p>Refund ID: #<%= refundId %> &nbsp;|&nbsp; Booking ID: #<%= bookingId %></p>
                <br>
                <span class="badge <%= badgeClass %>">
                    <%= status.substring(0,1).toUpperCase() + status.substring(1).toLowerCase() %>
                </span>
            </div>
            <div class="rh-right">
                <div class="amount">₹<%= String.format("%,.2f", amount) %></div>
                <div class="amount-label">Refund Amount</div>
            </div>
        </div>

        <!-- Route Strip -->
        <div class="route-strip">
            <div class="route-city">
                <div class="city-code"><%= source.length() >= 3 ? source.substring(0,3).toUpperCase() : source.toUpperCase() %></div>
                <div class="city-name"><%= source %></div>
            </div>
            <div class="route-line">
                <div class="plane">✈</div>
                <div class="line"></div>
                <div class="flight-no"><%= flightNo %></div>
            </div>
            <div class="route-city">
                <div class="city-code"><%= destination.length() >= 3 ? destination.substring(0,3).toUpperCase() : destination.toUpperCase() %></div>
                <div class="city-name"><%= destination %></div>
            </div>
        </div>

        <div class="info-body">

            <!-- Flight Details -->
            <p class="section-title">Flight Details</p>
            <div class="info-grid">
                <div class="info-item">
                    <div class="item-label">Flight Number</div>
                    <div class="item-value"><%= flightNo %></div>
                </div>
                <div class="info-item">
                    <div class="item-label">Flight Date</div>
                    <div class="item-value"><%= flightDate %></div>
                </div>
                <div class="info-item">
                    <div class="item-label">Departure Time</div>
                    <div class="item-value"><%= departTime %></div>
                </div>
                <div class="info-item">
                    <div class="item-label">Passengers</div>
                    <div class="item-value"><%= passengerCount %> Pax</div>
                </div>
            </div>

            <hr class="divider">

            <!-- Refund Breakdown -->
            <p class="section-title">Refund Breakdown</p>
            <%
                double gst    = amount - (amount / 1.05);
                double base   = amount / 1.05;
            %>
            <table class="amount-table">
                <tr>
                    <td>Base Fare Refund</td>
                    <td>₹<%= String.format("%,.2f", base) %></td>
                </tr>
                <tr>
                    <td>GST (5%) Refund</td>
                    <td>₹<%= String.format("%,.2f", gst) %></td>
                </tr>
                <tr>
                    <td style="color:#6b7280; font-size:13px;">Payment Method</td>
                    <td style="color:#6b7280; font-size:13px;"><%= paymentMethod %></td>
                </tr>
                <tr class="total-row">
                    <td>Total Refund Amount</td>
                    <td>₹<%= String.format("%,.2f", amount) %></td>
                </tr>
            </table>

            <hr class="divider">

            <!-- Refund Timeline -->
            <p class="section-title">Refund Timeline</p>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="tl-dot"></div>
                    <div class="tl-content">
                        <div class="tl-title">Refund Requested</div>
                        <div class="tl-time"><%= requestedAt %></div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="tl-dot <%= (status.equalsIgnoreCase("approved") || status.equalsIgnoreCase("refunded")) ? "" : "inactive" %>"></div>
                    <div class="tl-content">
                        <div class="tl-title">Admin Review & Approval</div>
                        <div class="tl-time">
                            <% if (status.equalsIgnoreCase("rejected")) { %>
                                Rejected – <%= processedAt %>
                            <% } else if (status.equalsIgnoreCase("approved") || status.equalsIgnoreCase("refunded")) { %>
                                Approved – <%= processedAt %>
                            <% } else { %>
                                Awaiting review
                            <% } %>
                        </div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="tl-dot <%= status.equalsIgnoreCase("refunded") ? "" : "inactive" %>"></div>
                    <div class="tl-content">
                        <div class="tl-title">Amount Credited to Original Payment Method</div>
                        <div class="tl-time">
                            <% if (status.equalsIgnoreCase("refunded")) { %>
                                Credited – <%= processedAt %>
                            <% } else { %>
                                Pending
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Action Buttons -->
        <div class="action-row">
            <button class="btn-print" onclick="window.print()">🖨 Print Receipt</button>
            <a href="<%= request.getContextPath() %>/userRefundHistory" class="btn-bookings">← Back to Refunds</a>
        </div>

    </div>
    <% } %>

</div>
</body>
</html>