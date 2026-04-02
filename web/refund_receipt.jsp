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
            refundId       = String.valueOf(refund.getObject("refund_id")      != null ? refund.getObject("refund_id")      : "");
            bookingId      = String.valueOf(refund.getObject("booking_id")     != null ? refund.getObject("booking_id")     : "");
            flightNo       = String.valueOf(refund.getObject("flight_no")      != null ? refund.getObject("flight_no")      : "");
            source         = String.valueOf(refund.getObject("source")         != null ? refund.getObject("source")         : "");
            destination    = String.valueOf(refund.getObject("destination")    != null ? refund.getObject("destination")    : "");
            flightDate     = String.valueOf(refund.getObject("flight_date")    != null ? refund.getObject("flight_date")    : "");
            departTime     = String.valueOf(refund.getObject("depart_time")    != null ? refund.getObject("depart_time")    : "");
            refundAmount   = String.valueOf(refund.getObject("refund_amount")  != null ? refund.getObject("refund_amount")  : "0");
            status         = String.valueOf(refund.getObject("status")         != null ? refund.getObject("status")         : "PENDING");
            requestedAt    = String.valueOf(refund.getObject("requested_at")   != null ? refund.getObject("requested_at")   : "");
            processedAt    = String.valueOf(refund.getObject("processed_at")   != null ? refund.getObject("processed_at")   : "—");
            paymentMethod  = String.valueOf(refund.getObject("payment_method") != null ? refund.getObject("payment_method") : "");
            passengerCount = String.valueOf(refund.getObject("passenger_count")!= null ? refund.getObject("passenger_count"): "");
        }
    } catch (Exception e) { e.printStackTrace(); }

    double amount = 0;
    try { amount = Double.parseDouble(refundAmount); } catch (Exception e) {}

    String statusUpper = status.toUpperCase();
    String statusColor;
    String statusIcon;
    if      ("APPROVED".equals(statusUpper) || "REFUNDED".equals(statusUpper)) { statusColor = "#10B981"; statusIcon = "✔"; }
    else if ("REJECTED".equals(statusUpper))                                   { statusColor = "#EF4444"; statusIcon = "✕"; }
    else                                                                        { statusColor = "#F59E0B"; statusIcon = "⏳"; }

    String src3  = source.length()      >= 3 ? source.substring(0,3).toUpperCase()      : source.toUpperCase();
    String dst3  = destination.length() >= 3 ? destination.substring(0,3).toUpperCase() : destination.toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Receipt – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
    <style>
        .receipt-wrap { max-width: 680px; margin: 0 auto; }

        /* Status Banner */
        .status-banner {
            border-radius: var(--radius); padding: 28px;
            text-align: center; margin-bottom: 24px;
            animation: fadeUp .4s ease both;
        }
        .status-icon-circle {
            width: 72px; height: 72px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; margin: 0 auto 16px;
            border: 3px solid currentColor;
        }
        .status-title { font-family: 'Syne', sans-serif; font-size: 1.4rem; font-weight: 800; }
        .status-subtitle { color: var(--muted); font-size: .875rem; margin-top: 6px; }
        .refund-amount-big { font-family: 'Syne', sans-serif; font-size: 3rem; font-weight: 800; color: var(--gold); margin-top: 12px; }

        /* Receipt Card */
        .receipt-card {
            background: rgba(13,20,39,.8); border: 1px solid var(--border);
            border-radius: var(--radius); overflow: hidden;
            animation: fadeUp .4s .15s ease both; opacity: 0; animation-fill-mode: forwards;
        }

        /* Route strip */
        .route-strip {
            padding: 24px 28px;
            background: rgba(0,87,255,.08); border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center; gap: 20px;
        }
        .rc-city { text-align: center; }
        .rc-code { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; }
        .rc-name { font-size: .78rem; color: var(--muted); margin-top: 3px; }
        .rc-arrow { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .rc-line { width: 100%; height: 2px; background: linear-gradient(90deg, var(--sky), var(--sky-glow)); border-radius: 2px; }

        .info-body { padding: 28px; }
        .section-label {
            font-size: .72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .07em; color: var(--sky-glow);
            border-bottom: 1px solid var(--border); padding-bottom: 10px; margin-bottom: 18px;
        }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 28px; }
        @media(max-width:500px) { .info-grid { grid-template-columns: 1fr; } }
        .info-item-label { font-size: .72rem; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: .04em; }
        .info-item-value { font-size: .95rem; font-weight: 600; margin-top: 5px; }

        .refund-total-row {
            background: rgba(255,184,0,.07); border: 1px solid rgba(255,184,0,.2);
            border-radius: 12px; padding: 18px 24px;
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 24px;
        }
        .rt-label { font-size: .8rem; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: .05em; }
        .rt-value { font-family: 'Syne', sans-serif; font-size: 1.8rem; font-weight: 800; color: var(--gold); }

        .action-row { display: flex; gap: 12px; flex-wrap: wrap; }
        .print-divider { border: none; border-top: 1px dashed rgba(255,255,255,.12); margin: 24px 0; }
        .ref-no { font-size: .75rem; color: rgba(255,255,255,.2); text-align: center; margin-top: 16px; letter-spacing: .05em; }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar" id="navbar">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard"    class="nav-link">Dashboard</a>
        <a href="userBookings"     class="nav-link">My Bookings</a>
        <a href="userRefundHistory" class="nav-link">Refund History</a>
        <a href="logout"           class="nav-link btn-primary">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header" style="animation:fadeUp .4s ease both;">
        <div>
            <h1 class="page-title">💸 Refund Receipt</h1>
            <p class="page-subtitle">Refund #<%= refundId %> for Booking #<%= bookingId %></p>
        </div>
        <div class="action-row">
            <a href="userRefundHistory" class="btn btn-ghost">← Refund History</a>
            <button onclick="printReceipt()" class="btn btn-blue">🖨 Print</button>
        </div>
    </div>

    <div class="receipt-wrap">

        <!-- Status Banner -->
        <div class="status-banner" style="background:rgba(<%= "APPROVED".equals(statusUpper)||"REFUNDED".equals(statusUpper) ? "16,185,129" : "REJECTED".equals(statusUpper) ? "239,68,68" : "245,158,11" %>,.07);border:1px solid rgba(<%= "APPROVED".equals(statusUpper)||"REFUNDED".equals(statusUpper) ? "16,185,129" : "REJECTED".equals(statusUpper) ? "239,68,68" : "245,158,11" %>,.25);">
            <div class="status-icon-circle" style="color:<%= statusColor %>;">
                <%= statusIcon %>
            </div>
            <div class="status-title" style="color:<%= statusColor %>;"><%= statusUpper %></div>
            <div class="status-subtitle">
                <% if ("APPROVED".equals(statusUpper)||"REFUNDED".equals(statusUpper)) { %>Your refund has been approved and processed.<% }
                   else if ("REJECTED".equals(statusUpper)) { %>Your refund request was reviewed and rejected.<% }
                   else { %>Your refund request is pending review by our team.<% } %>
            </div>
            <div class="refund-amount-big">₹<%= String.format("%,.2f", amount) %></div>
        </div>

        <!-- Receipt Card -->
        <div class="receipt-card">

            <!-- Route Strip -->
            <div class="route-strip">
                <div class="rc-city">
                    <div class="rc-code" style="color:var(--gold);"><%= src3 %></div>
                    <div class="rc-name"><%= source %></div>
                </div>
                <div class="rc-arrow">
                    <div style="font-size:1.5rem;">✈</div>
                    <div class="rc-line"></div>
                    <div style="font-size:.75rem;color:var(--muted);">✈ <%= flightNo %></div>
                </div>
                <div class="rc-city">
                    <div class="rc-code" style="color:var(--sky-glow);"><%= dst3 %></div>
                    <div class="rc-name"><%= destination %></div>
                </div>
            </div>

            <div class="info-body">

                <!-- Refund Total -->
                <div class="refund-total-row">
                    <div>
                        <div class="rt-label">Refund Amount</div>
                        <div style="font-size:.78rem;color:var(--muted);margin-top:4px;">
                            <% if ("APPROVED".equals(statusUpper)||"REFUNDED".equals(statusUpper)) { %>
                            Processed via <%= paymentMethod.isEmpty() ? "original payment method" : paymentMethod %>
                            <% } else if ("PENDING".equals(statusUpper)) { %>
                            Awaiting admin approval
                            <% } else { %>
                            Request was not approved
                            <% } %>
                        </div>
                    </div>
                    <div class="rt-value">₹<%= String.format("%,.2f", amount) %></div>
                </div>

                <!-- Flight Details -->
                <div class="section-label">✈ Flight Details</div>
                <div class="info-grid" style="margin-bottom:0;">
                    <div>
                        <div class="info-item-label">Flight Number</div>
                        <div class="info-item-value" style="color:var(--sky-glow);">✈ <%= flightNo %></div>
                    </div>
                    <div>
                        <div class="info-item-label">Flight Date</div>
                        <div class="info-item-value"><%= flightDate %></div>
                    </div>
                    <div>
                        <div class="info-item-label">Departure</div>
                        <div class="info-item-value"><%= departTime %></div>
                    </div>
                    <div>
                        <div class="info-item-label">Passengers</div>
                        <div class="info-item-value"><%= passengerCount.isEmpty() ? "—" : passengerCount %></div>
                    </div>
                </div>

                <div class="print-divider"></div>

                <!-- Refund Details -->
                <div class="section-label">📋 Refund Details</div>
                <div class="info-grid">
                    <div>
                        <div class="info-item-label">Refund ID</div>
                        <div class="info-item-value" style="color:var(--sky-glow);">#<%= refundId %></div>
                    </div>
                    <div>
                        <div class="info-item-label">Booking ID</div>
                        <div class="info-item-value">#<%= bookingId %></div>
                    </div>
                    <div>
                        <div class="info-item-label">Status</div>
                        <div class="info-item-value" style="color:<%= statusColor %>;"><%= statusIcon %> <%= statusUpper %></div>
                    </div>
                    <div>
                        <div class="info-item-label">Requested On</div>
                        <div class="info-item-value" style="font-size:.85rem;"><%= requestedAt %></div>
                    </div>
                    <% if (!"PENDING".equals(statusUpper) && !processedAt.equals("—")) { %>
                    <div>
                        <div class="info-item-label">Processed On</div>
                        <div class="info-item-value" style="font-size:.85rem;"><%= processedAt %></div>
                    </div>
                    <% } %>
                    <% if (!paymentMethod.isEmpty()) { %>
                    <div>
                        <div class="info-item-label">Payment Method</div>
                        <div class="info-item-value"><%= paymentMethod %></div>
                    </div>
                    <% } %>
                </div>

                <div class="print-divider"></div>
                <div class="ref-no">SKYCONNECT REFUND RECEIPT · REF-<%= refundId %>-<%= bookingId %></div>
            </div>
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
function printReceipt() {
    document.getElementById('navbar').style.display = 'none';
    document.querySelector('.page-header').style.display = 'none';
    window.print();
    document.getElementById('navbar').style.display = '';
    document.querySelector('.page-header').style.display = '';
}
</script>
</body>
</html>
