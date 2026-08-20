<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.skyconnect.controller.InvoiceServlet.Passenger" %>
<%
    HttpSession sess = request.getSession(false);
    String userName = (sess != null) ? (String) sess.getAttribute("userName") : null;
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    // Attributes set by InvoiceServlet.doGet
    Integer bookingId     = (Integer) request.getAttribute("bookingId");
    if (bookingId == null) { response.sendRedirect(request.getContextPath() + "/userBookings"); return; }

    String  userEmail     = (String)  request.getAttribute("userEmail");
    String  flightNo      = (String)  request.getAttribute("flightNo");
    String  source        = (String)  request.getAttribute("source");
    String  destination   = (String)  request.getAttribute("destination");
    String  departDate    = (String)  request.getAttribute("departDate");
    String  departTime    = (String)  request.getAttribute("departTime");
    String  arrivalTime   = (String)  request.getAttribute("arrivalTime");
    Integer seats         = (Integer) request.getAttribute("seats");
    Double  amount        = (Double)  request.getAttribute("amount");
    Double  gst           = (Double)  request.getAttribute("gst");
    Double  totalAmount   = (Double)  request.getAttribute("totalAmount");
    Double  paidAmount    = (Double)  request.getAttribute("paidAmount");
    String  paymentMethod = (String)  request.getAttribute("paymentMethod");
    String  paymentStatus = (String)  request.getAttribute("paymentStatus");
    String  status        = (String)  request.getAttribute("status");
    @SuppressWarnings("unchecked")
    List<Passenger> passengers = (List<Passenger>) request.getAttribute("passengers");

    if (seats    == null) seats    = 1;
    if (amount   == null) amount   = 0.0;
    if (gst      == null) gst      = 0.0;
    if (paidAmount == null) paidAmount = (totalAmount != null ? totalAmount : 0.0);
    if (userEmail == null) userEmail = "";

    String srcCode = (source != null && source.length() >= 3) ? source.substring(0,3).toUpperCase() : (source != null ? source.toUpperCase() : "DEP");
    String dstCode = (destination != null && destination.length() >= 3) ? destination.substring(0,3).toUpperCase() : (destination != null ? destination.toUpperCase() : "ARR");
    boolean isPaid = "PAID".equals(paymentStatus);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>E-Ticket — Booking #<%= bookingId %> – AeroSphere</title>
    <script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css"/>

    <style>
        .inv-page {
            min-height: 100vh;
            background: var(--bg-0);
            background-image:
                radial-gradient(ellipse 60% 40% at 30% 5%, rgba(46,74,61,.1) 0%, transparent 65%),
                radial-gradient(ellipse 40% 30% at 80% 90%, rgba(91,138,110,.08) 0%, transparent 60%);
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
            font-family: 'Fraunces', sans-serif;
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
            font-family: 'Inter', sans-serif;
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
        .btn-inv.primary:hover { box-shadow: 0 6px 20px rgba(46,74,61,.35); }

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
            background: linear-gradient(135deg, #12201A 0%, #17281F 50%, #0E1712 100%);
            padding: 2rem 2.5rem;
            position: relative;
            overflow: hidden;
        }
        .bp-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(ellipse 60% 80% at 80% 50%, rgba(46,74,61,.15) 0%, transparent 70%),
                radial-gradient(ellipse 40% 60% at 20% 50%, rgba(91,138,110,.08) 0%, transparent 60%);
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
            font-family: 'Fraunces', sans-serif;
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
            background: rgba(91,138,110,.15);
            border: 1px solid rgba(91,138,110,.3);
            border-radius: 20px;
            color: #5B8A6E;
            font-size: .8rem;
            font-family: 'Inter', sans-serif;
            font-weight: 600;
        }
        .bp-status-dot {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: #5B8A6E;
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
            font-family: 'Fraunces', sans-serif;
            font-size: 3.5rem;
            font-weight: 800;
            color: #fff;
            line-height: 1;
        }
        .bp-city-name {
            font-size: .85rem;
            color: rgba(255,255,255,.5);
            font-family: 'Inter', sans-serif;
            margin-top: .3rem;
        }
        .bp-city-time {
            font-size: 1.1rem;
            color: rgba(255,255,255,.85);
            font-family: 'Inter', sans-serif;
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
            font-family: 'Inter', sans-serif;
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
            background: linear-gradient(90deg, rgba(255,255,255,.2), rgba(46,74,61,.6), rgba(255,255,255,.2));
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
            font-family: 'Inter', sans-serif;
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
            font-family: 'Inter', sans-serif;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: .08em;
            margin-bottom: .3rem;
        }
        .bp-info-val {
            font-family: 'Fraunces', sans-serif;
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
            font-family: 'Fraunces', sans-serif;
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
            font-family: 'Inter', sans-serif;
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
            font-family: 'Fraunces', sans-serif;
            font-size: 1.15rem;
        }

        /* ── Payment verified banner ── */
        .inv-verified-banner {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 2rem;
            background: rgba(91,138,110,.07);
            border-top: 1px solid rgba(91,138,110,.15);
        }
        .ivb-icon {
            width: 40px; height: 40px;
            border-radius: 50%;
            background: rgba(91,138,110,.15);
            display: flex; align-items: center; justify-content: center;
            color: var(--accent-green);
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .ivb-text { font-family: 'Inter', sans-serif; }
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
    <%@ include file="/Views/common/navbar.jsp" %>

    <div class="inv-wrapper">

        <!-- Page header -->
        <div class="inv-page-header">
            <div>
                <div class="inv-page-title">E-Ticket &amp; <span>Invoice</span></div>
                <div style="font-family:'Inter',sans-serif; font-size:.85rem; color:var(--text-muted); margin-top:.3rem;">
                    Booking #<%= bookingId %> &nbsp;·&nbsp; <%= departDate != null ? departDate : "—" %>
                </div>
            </div>
            <div class="inv-actions">
                <button class="btn-inv" onclick="window.print()">
                    <i class="ph-bold ph-printer"></i> Print
                </button>
                <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= bookingId %>&download=true" class="btn-inv primary">
                    <i class="ph-bold ph-download-simple"></i> Download PDF
                </a>
            </div>
        </div>

        <!-- ══ BOARDING PASS ══ -->
        <div class="boarding-pass">
            <!-- Header: airline + status -->
            <div class="bp-header">
                <div class="bp-watermark"><i class="ph-bold ph-airplane-tilt"></i></div>
                <div class="bp-airline-row">
                    <div>
                        <div class="bp-airline-name"><i class="ph-bold ph-airplane-tilt"></i> AeroSphere Airlines</div>
                        <div class="bp-flight-no">Flight <%= flightNo != null ? flightNo : "—" %></div>
                    </div>
                    <div class="bp-status">
                        <div class="bp-status-dot"></div>
                        <%= isPaid ? "Confirmed" : status != null ? status : "Booked" %>
                    </div>
                </div>
                <!-- Route -->
                <div class="bp-route">
                    <div class="bp-city">
                        <div class="bp-city-code"><%= srcCode %></div>
                        <div class="bp-city-name"><%= source != null ? source : "Departure" %></div>
                        <div class="bp-city-time"><%= departTime != null ? departTime : "--:--" %></div>
                    </div>
                    <div class="bp-route-mid">
                        <div class="bp-duration">Direct</div>
                        <div class="bp-route-line">
                            <div class="bp-dot"></div>
                            <div class="bp-line"></div>
                            <i class="ph-bold ph-airplane-tilt bp-plane-icon"></i>
                            <div class="bp-line"></div>
                            <div class="bp-dot"></div>
                        </div>
                        <div class="bp-duration" style="color:rgba(255,255,255,.25); font-size:.7rem;">Direct Flight</div>
                    </div>
                    <div class="bp-city right">
                        <div class="bp-city-code"><%= dstCode %></div>
                        <div class="bp-city-name"><%= destination != null ? destination : "Arrival" %></div>
                        <div class="bp-city-time"><%= arrivalTime != null ? arrivalTime : "--:--" %></div>
                    </div>
                </div>
            </div>

            <!-- Perforation -->
            <div class="bp-perforation">
                <div class="bp-perf-circle" style="margin-left:-14px;"></div>
                <div class="bp-perf-line"></div>
                <div class="bp-perf-label"><i class="ph-bold ph-scissors"></i> TEAR HERE</div>
                <div class="bp-perf-line"></div>
                <div class="bp-perf-circle" style="margin-right:-14px;"></div>
            </div>

            <!-- Info grid -->
            <div class="bp-info-grid">
                <div class="bp-info-cell">
                    <div class="bp-info-label">Passenger</div>
                    <div class="bp-info-val"><%= userName %></div>
                </div>
                <div class="bp-info-cell">
                    <div class="bp-info-label">Date</div>
                    <div class="bp-info-val"><%= departDate != null ? departDate : "—" %></div>
                </div>
                <div class="bp-info-cell">
                    <div class="bp-info-label">Class</div>
                    <div class="bp-info-val">Economy</div>
                </div>
                <div class="bp-info-cell">
                    <div class="bp-info-label">Seat(s)</div>
                    <div class="bp-info-val mono">
                        <%
                          if (passengers != null && !passengers.isEmpty()) {
                              StringBuilder seatList = new StringBuilder();
                              for (Passenger p : passengers) {
                                  if (p.seatNo != null) { if (seatList.length()>0) seatList.append(", "); seatList.append(p.seatNo); }
                              }
                              out.print(seatList.length() > 0 ? seatList.toString() : seats + " seat(s)");
                          } else { out.print(seats + " seat(s)"); }
                        %>
                    </div>
                </div>
            </div>

            <!-- Barcode row -->
            <div class="bp-barcode-row">
                <div>
                    <div style="font-size:.7rem; color:var(--text-muted); font-family:'Inter',sans-serif; text-transform:uppercase; letter-spacing:.08em; margin-bottom:.4rem;">Booking Reference</div>
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
                <i class="ph-bold ph-receipt"></i> Fare Breakdown &amp; Payment
            </div>
            <table class="inv-table">
                <tr>
                    <td>Base Fare (<%= seats %> passenger<%= seats > 1 ? "s" : "" %>)</td>
                    <td>₹<%= String.format("%,.2f", amount) %></td>
                </tr>
                <tr>
                    <td>GST (5%)</td>
                    <td>₹<%= String.format("%,.2f", gst) %></td>
                </tr>
                <tr>
                    <td>Payment Method</td>
                    <td><%= paymentMethod != null ? paymentMethod : "—" %></td>
                </tr>
                <tr class="total-row">
                    <td>Total Paid</td>
                    <td>₹<%= String.format("%,.2f", paidAmount) %></td>
                </tr>
            </table>
            <div class="inv-verified-banner">
                <div class="ivb-icon"><i class="ph-bold ph-check-circle"></i></div>
                <div class="ivb-text">
                    <div class="ivb-title"><%= isPaid ? "Payment Verified" : "Booking Confirmed" %></div>
                    <div class="ivb-sub">Processed securely via Razorpay</div>
                </div>
                <div class="ivb-pid">Booking #<%= String.format("%06d", bookingId) %></div>
            </div>
        </div>
        <!-- CTA strip -->
        <div class="inv-cta-strip">
            <a href="${pageContext.request.contextPath}/userDashboard" class="btn-inv">
                <i class="ph-bold ph-arrow-left"></i> Back to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/userBookings" class="btn-inv">
                <i class="ph-bold ph-list-bullets"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/invoice?bookingId=<%= bookingId %>&download=true" class="btn-inv primary">
                <i class="ph-bold ph-download-simple"></i> Download E-Ticket PDF
            </a>
        </div>

    </div>
    <%@ include file="/Views/common/Footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
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
