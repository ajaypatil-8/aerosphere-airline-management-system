<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.flightapp.model.*, java.util.*" %>
<%
    HttpSession sess = request.getSession(false);
    String userEmail = (sess != null) ? (String) sess.getAttribute("userEmail") : null;
    if (userEmail == null) { response.sendRedirect("login.jsp"); return; }

    // ── Preserve all existing attribute reads ──
    String bookingId     = (String) request.getAttribute("bookingId");
    String flightNo      = (String) request.getAttribute("flightNo");
    String from          = (String) request.getAttribute("from");
    String to            = (String) request.getAttribute("to");
    String depTime       = (String) request.getAttribute("depTime");
    String arrTime       = (String) request.getAttribute("arrTime");
    String depDate       = (String) request.getAttribute("depDate");
    String travelClass   = (String) request.getAttribute("travelClass");
    String seatNumbers   = (String) request.getAttribute("seatNumbers");
    String passengers    = (String) request.getAttribute("passengers");
    String totalFare     = (String) request.getAttribute("totalFare");
    String paymentId     = (String) request.getAttribute("paymentId");
    String passengerName = (String) request.getAttribute("passengerName");
    String bookingDate   = (String) request.getAttribute("bookingDate");
    String airline       = (String) request.getAttribute("airline");
    String duration      = (String) request.getAttribute("duration");
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>E-Ticket — Booking <%= bookingId %></title>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="assests/css/style.css"/>
    <link rel="stylesheet" href="assests/css/animations.css"/>

    <style>
        .inv-page {
            min-height: 100vh;
            background: var(--bg-0);
            background-image:
                radial-gradient(ellipse 60% 40% at 30% 5%, rgba(14,165,233,.1) 0%, transparent 65%),
                radial-gradient(ellipse 40% 30% at 80% 90%, rgba(16,185,129,.08) 0%, transparent 60%);
        }

        .inv-wrapper {
            max-width: 860px;
            margin: 0 auto;
            padding: 2rem 1.5rem 4rem;
        }

        /* ── Page header ── */
        .inv-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            animation: fadeDown .5s ease both;
        }
        .inv-page-title {
            font-family: 'Syne', sans-serif;
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-primary);
        }
        .inv-page-title span {
            background: var(--grad-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .inv-actions { display: flex; gap: .75rem; }
        .btn-inv {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            padding: .6rem 1.2rem;
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: .85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all .25s;
            border: 1.5px solid var(--border);
            background: var(--surface-1);
            color: var(--text-secondary);
            text-decoration: none;
        }
        .btn-inv:hover { border-color: var(--accent-blue); color: var(--accent-blue); transform: translateY(-1px); }
        .btn-inv.primary {
            background: var(--grad-brand);
            border-color: transparent;
            color: #fff;
        }
        .btn-inv.primary:hover { box-shadow: 0 6px 20px rgba(14,165,233,.35); }

        /* ── BOARDING PASS CARD ── */
        .boarding-pass {
            background: var(--surface-1);
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow: hidden;
            animation: fadeUp .6s .1s ease both;
            position: relative;
            margin-bottom: 1.5rem;
        }

        /* Top gradient band */
        .bp-header {
            background: linear-gradient(135deg, #0a1628 0%, #0c1f3a 50%, #0d2040 100%);
            padding: 2rem 2.5rem;
            position: relative;
            overflow: hidden;
        }
        .bp-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(ellipse 60% 80% at 80% 50%, rgba(14,165,233,.15) 0%, transparent 70%),
                radial-gradient(ellipse 40% 60% at 20% 50%, rgba(16,185,129,.08) 0%, transparent 60%);
        }
        .bp-watermark {
            position: absolute;
            right: 2rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 7rem;
            opacity: .04;
            color: #fff;
            animation: floatAnim 4s ease-in-out infinite;
        }

        .bp-airline-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            z-index: 1;
            margin-bottom: 2rem;
        }
        .bp-airline-name {
            font-family: 'Syne', sans-serif;
            font-size: 1.1rem;
            font-weight: 800;
            color: #fff;
            letter-spacing: .05em;
        }
        .bp-flight-no {
            font-family: 'DM Mono', monospace;
            font-size: .85rem;
            color: rgba(255,255,255,.5);
        }
        .bp-status {
            display: flex;
            align-items: center;
            gap: .4rem;
            padding: .35rem .9rem;
            background: rgba(16,185,129,.15);
            border: 1px solid rgba(16,185,129,.3);
            border-radius: 20px;
            color: #10B981;
            font-size: .8rem;
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
        }
        .bp-status-dot {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: #10B981;
            animation: pulse 1.5s ease infinite;
        }

        /* Route row */
        .bp-route {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            z-index: 1;
        }
        .bp-city {
            flex: 1;
        }
        .bp-city.right { text-align: right; }
        .bp-city-code {
            font-family: 'Syne', sans-serif;
            font-size: 3.5rem;
            font-weight: 800;
            color: #fff;
            line-height: 1;
        }
        .bp-city-name {
            font-size: .85rem;
            color: rgba(255,255,255,.5);
            font-family: 'DM Sans', sans-serif;
            margin-top: .3rem;
        }
        .bp-city-time {
            font-size: 1.1rem;
            color: rgba(255,255,255,.85);
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
            margin-top: .5rem;
        }
        .bp-route-mid {
            flex: 0 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: .5rem;
            padding: 0 2rem;
        }
        .bp-duration {
            font-size: .75rem;
            color: rgba(255,255,255,.4);
            font-family: 'DM Sans', sans-serif;
        }
        .bp-route-line {
            display: flex;
            align-items: center;
            gap: .3rem;
        }
        .bp-dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: rgba(255,255,255,.3);
        }
        .bp-line {
            width: 80px;
            height: 1px;
            background: linear-gradient(90deg, rgba(255,255,255,.2), rgba(14,165,233,.6), rgba(255,255,255,.2));
        }
        .bp-plane-icon { color: var(--accent-blue); font-size: 1.2rem; }

        /* ── Tear perforation ── */
        .bp-perforation {
            display: flex;
            align-items: center;
            position: relative;
            margin: 0;
        }
        .bp-perf-circle {
            width: 28px; height: 28px;
            border-radius: 50%;
            background: var(--bg-0);
            border: 1px solid var(--border);
            flex-shrink: 0;
        }
        .bp-perf-line {
            flex: 1;
            border-top: 2px dashed var(--border);
            margin: 0 .5rem;
        }
        .bp-perf-label {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            background: var(--surface-1);
            padding: .2rem .8rem;
            font-size: .7rem;
            color: var(--text-muted);
            font-family: 'DM Sans', sans-serif;
            letter-spacing: .08em;
            text-transform: uppercase;
            border-radius: 10px;
        }

        /* ── Info grid ── */
        .bp-info-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0;
            padding: 1.5rem 2.5rem;
        }
        .bp-info-cell {
            padding: .75rem 1rem .75rem 0;
            border-right: 1px solid var(--border);
        }
        .bp-info-cell:last-child { border-right: none; padding-right: 0; }
        .bp-info-cell:not(:first-child) { padding-left: 1rem; }
        .bp-info-label {
            font-size: .7rem;
            font-family: 'DM Sans', sans-serif;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: .08em;
            margin-bottom: .3rem;
        }
        .bp-info-val {
            font-family: 'Syne', sans-serif;
            font-size: .95rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        .bp-info-val.mono {
            font-family: 'DM Mono', monospace;
            font-size: .85rem;
            color: var(--accent-blue);
        }

        /* ── Barcode section ── */
        .bp-barcode-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem 2.5rem;
            border-top: 1px solid var(--border);
            background: var(--surface-2);
        }
        .bp-booking-id {
            font-family: 'DM Mono', monospace;
            font-size: 1.4rem;
            font-weight: 500;
            color: var(--text-primary);
            letter-spacing: .15em;
        }
        .bp-booking-id span {
            background: var(--grad-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .bp-barcode {
            display: flex;
            gap: 2px;
            align-items: center;
            height: 50px;
        }
        .bp-bar {
            background: var(--text-primary);
            border-radius: 1px;
        }

        /* ── Payment details card ── */
        .inv-detail-card {
            background: var(--surface-1);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            animation: fadeUp .6s .2s ease both;
        }
        .inv-detail-card::before {
            content: '';
            display: block;
            height: 3px;
            background: var(--grad-brand);
        }
        .inv-detail-header {
            padding: 1.2rem 2rem;
            border-bottom: 1px solid var(--border);
            font-family: 'Syne', sans-serif;
            font-size: .9rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: .5rem;
        }
        .inv-detail-header i { color: var(--accent-blue); }

        .inv-table {
            width: 100%;
            border-collapse: collapse;
        }
        .inv-table tr {
            border-bottom: 1px solid var(--border);
            transition: background .2s;
        }
        .inv-table tr:last-child { border-bottom: none; }
        .inv-table tr:hover { background: var(--surface-2); }
        .inv-table td {
            padding: .9rem 2rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .875rem;
        }
        .inv-table td:first-child { color: var(--text-muted); }
        .inv-table td:last-child {
            color: var(--text-primary);
            font-weight: 500;
            text-align: right;
        }
        .inv-table tr.total-row td {
            padding: 1.1rem 2rem;
            font-weight: 700;
            font-size: 1rem;
        }
        .inv-table tr.total-row td:last-child {
            background: var(--grad-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-family: 'Syne', sans-serif;
            font-size: 1.15rem;
        }

        /* ── Payment verified banner ── */
        .inv-verified-banner {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 2rem;
            background: rgba(16,185,129,.07);
            border-top: 1px solid rgba(16,185,129,.15);
        }
        .ivb-icon {
            width: 40px; height: 40px;
            border-radius: 50%;
            background: rgba(16,185,129,.15);
            display: flex; align-items: center; justify-content: center;
            color: var(--accent-green);
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .ivb-text { font-family: 'DM Sans', sans-serif; }
        .ivb-title { font-size: .9rem; font-weight: 600; color: var(--accent-green); }
        .ivb-sub { font-size: .78rem; color: var(--text-muted); margin-top: .1rem; }
        .ivb-pid {
            margin-left: auto;
            font-family: 'DM Mono', monospace;
            font-size: .8rem;
            color: var(--text-muted);
        }

        /* ── Bottom CTA strip ── */
        .inv-cta-strip {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            animation: fadeUp .6s .35s ease both;
            flex-wrap: wrap;
        }

        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }
        @keyframes fadeDown {
            from { opacity:0; transform:translateY(-15px); }
            to   { opacity:1; transform:translateY(0); }
        }
        @keyframes floatAnim {
            0%,100% { transform: translateY(-50%) rotate(-10deg); }
            50%      { transform: translateY(calc(-50% - 8px)) rotate(-10deg); }
        }
        @keyframes pulse {
            0%,100% { opacity:1; }
            50%      { opacity:.4; }
        }

        @media print {
            .inv-page-header .inv-actions,
            .inv-cta-strip,
            nav, footer { display: none !important; }
            .boarding-pass, .inv-detail-card { box-shadow: none; border-color: #ddd; }
            body { background: #fff; }
            .bp-city-code, .bp-airline-name, .bp-info-val { color: #000 !important; }
        }

        @media (max-width: 600px) {
            .bp-info-grid { grid-template-columns: repeat(2,1fr); }
            .bp-city-code { font-size: 2.5rem; }
            .bp-route-mid { padding: 0 1rem; }
            .bp-line { width: 40px; }
            .inv-table td { padding: .75rem 1.2rem; }
            .bp-barcode-row { flex-direction: column; gap: 1rem; }
        }
    </style>
</head>
<body>
<div class="inv-page">
    <%@ include file="common/navbar.jsp" %>

    <div class="inv-wrapper">

        <!-- Page header -->
        <div class="inv-page-header">
            <div>
                <div class="inv-page-title">E-Ticket &amp; <span>Invoice</span></div>
                <div style="font-family:'DM Sans',sans-serif; font-size:.85rem; color:var(--text-muted); margin-top:.3rem;">
                    Booking confirmed • <%= bookingDate != null ? bookingDate : "—" %>
                </div>
            </div>
            <div class="inv-actions">
                <button class="btn-inv" onclick="window.print()">
                    <i class="fa fa-print"></i> Print
                </button>
                <a href="DownloadInvoiceServlet?bookingId=<%= bookingId %>" class="btn-inv primary">
                    <i class="fa fa-download"></i> Download PDF
                </a>
            </div>
        </div>

        <!-- ══ BOARDING PASS ══ -->
        <div class="boarding-pass">
            <!-- Header: airline + status -->
            <div class="bp-header">
                <div class="bp-watermark">✈</div>
                <div class="bp-airline-row">
                    <div>
                        <div class="bp-airline-name">✈ <%= airline != null ? airline : "SkyBook Airlines" %></div>
                        <div class="bp-flight-no">Flight <%= flightNo != null ? flightNo : "—" %></div>
                    </div>
                    <div class="bp-status">
                        <div class="bp-status-dot"></div>
                        Confirmed
                    </div>
                </div>
                <!-- Route -->
                <div class="bp-route">
                    <div class="bp-city">
                        <div class="bp-city-code"><%= from != null ? from.substring(0, Math.min(3, from.length())).toUpperCase() : "DEP" %></div>
                        <div class="bp-city-name"><%= from != null ? from : "Departure" %></div>
                        <div class="bp-city-time"><%= depTime != null ? depTime : "--:--" %></div>
                    </div>
                    <div class="bp-route-mid">
                        <div class="bp-duration"><%= duration != null ? duration : "Direct" %></div>
                        <div class="bp-route-line">
                            <div class="bp-dot"></div>
                            <div class="bp-line"></div>
                            <i class="fa fa-plane bp-plane-icon"></i>
                            <div class="bp-line"></div>
                            <div class="bp-dot"></div>
                        </div>
                        <div class="bp-duration" style="color:rgba(255,255,255,.25); font-size:.7rem;">Direct Flight</div>
                    </div>
                    <div class="bp-city right">
                        <div class="bp-city-code"><%= to != null ? to.substring(0, Math.min(3, to.length())).toUpperCase() : "ARR" %></div>
                        <div class="bp-city-name"><%= to != null ? to : "Arrival" %></div>
                        <div class="bp-city-time"><%= arrTime != null ? arrTime : "--:--" %></div>
                    </div>
                </div>
            </div>

            <!-- Perforation -->
            <div class="bp-perforation">
                <div class="bp-perf-circle" style="margin-left:-14px;"></div>
                <div class="bp-perf-line"></div>
                <div class="bp-perf-label">✂ TEAR HERE</div>
                <div class="bp-perf-line"></div>
                <div class="bp-perf-circle" style="margin-right:-14px;"></div>
            </div>

            <!-- Info grid -->
            <div class="bp-info-grid">
                <div class="bp-info-cell">
                    <div class="bp-info-label">Passenger</div>
                    <div class="bp-info-val"><%= passengerName != null ? passengerName : "—" %></div>
                </div>
                <div class="bp-info-cell">
                    <div class="bp-info-label">Date</div>
                    <div class="bp-info-val"><%= depDate != null ? depDate : "—" %></div>
                </div>
                <div class="bp-info-cell">
                    <div class="bp-info-label">Class</div>
                    <div class="bp-info-val"><%= travelClass != null ? travelClass : "Economy" %></div>
                </div>
                <div class="bp-info-cell">
                    <div class="bp-info-label">Seat(s)</div>
                    <div class="bp-info-val mono"><%= seatNumbers != null ? seatNumbers : "—" %></div>
                </div>
            </div>

            <!-- Barcode row -->
            <div class="bp-barcode-row">
                <div>
                    <div style="font-size:.7rem; color:var(--text-muted); font-family:'DM Sans',sans-serif; text-transform:uppercase; letter-spacing:.08em; margin-bottom:.4rem;">Booking Reference</div>
                    <div class="bp-booking-id">
                        <span>#<%= bookingId != null ? bookingId : "——" %></span>
                    </div>
                </div>
                <!-- Decorative barcode (visual only) -->
                <div class="bp-barcode" id="barcodeEl"></div>
            </div>
        </div>

        <!-- ══ PAYMENT DETAILS ══ -->
        <div class="inv-detail-card">
            <div class="inv-detail-header">
                <i class="fa fa-receipt"></i> Fare Breakdown &amp; Payment
            </div>
            <table class="inv-table">
                <tr>
                    <td>Base Fare (<%= passengers != null ? passengers : "1" %> passenger(s))</td>
                    <td>₹<%= totalFare != null ? totalFare : "0" %></td>
                </tr>
                <tr>
                    <td>Taxes &amp; Airport Charges</td>
                    <td style="color:var(--text-muted);">Included</td>
                </tr>
                <tr>
                    <td>Seat Selection</td>
                    <td style="color:var(--accent-green);">Complimentary</td>
                </tr>
                <tr>
                    <td>Convenience Fee</td>
                    <td style="color:var(--text-muted);">₹0</td>
                </tr>
                <tr class="total-row">
                    <td>Total Paid</td>
                    <td>₹<%= totalFare != null ? totalFare : "0" %></td>
                </tr>
            </table>
            <div class="inv-verified-banner">
                <div class="ivb-icon"><i class="fa fa-circle-check"></i></div>
                <div class="ivb-text">
                    <div class="ivb-title">Payment Verified</div>
                    <div class="ivb-sub">Processed securely via Razorpay</div>
                </div>
                <div class="ivb-pid">TXN: <%= paymentId != null ? paymentId : "—" %></div>
            </div>
        </div>

        <!-- CTA strip -->
        <div class="inv-cta-strip">
            <a href="user_dashboard.jsp" class="btn-inv">
                <i class="fa fa-arrow-left"></i> Back to Dashboard
            </a>
            <a href="seat_map.jsp?bookingId=<%= bookingId %>" class="btn-inv">
                <i class="fa fa-chair"></i> View Seat Map
            </a>
            <a href="DownloadInvoiceServlet?bookingId=<%= bookingId %>" class="btn-inv primary">
                <i class="fa fa-download"></i> Download E-Ticket
            </a>
        </div>

    </div>
    <%@ include file="common/footer.jsp" %>
</div>

<script src="assests/js/main.js"></script>
<script>
    /* ── Decorative barcode generator ── */
    (function() {
        const el = document.getElementById('barcodeEl');
        if (!el) return;
        const counts = [1,3,1,2,3,1,2,1,3,2,1,2,3,1,2,1,3,1,2,3,1,1,3,2];
        counts.forEach((w, i) => {
            const bar = document.createElement('div');
            bar.className = 'bp-bar';
            bar.style.width = (w * 3) + 'px';
            bar.style.height = (i % 3 === 0) ? '50px' : (i % 2 === 0 ? '40px' : '35px');
            bar.style.opacity = i % 4 === 3 ? '.3' : '1';
            el.appendChild(bar);
        });
    })();
</script>
</body>
</html>
