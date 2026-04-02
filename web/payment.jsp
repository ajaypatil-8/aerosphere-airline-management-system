<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.skyconnect.util.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }

    String bookingIdStr = request.getParameter("bookingId");
    if (bookingIdStr == null) { response.sendRedirect("userDashboard"); return; }

    int bookingId = Integer.parseInt(bookingIdStr);

    double totalAmount = 0;
    String flightNo = "", source = "", destination = "", departDate = "", departTime = "";
    int numSeats = 0;

    try (Connection con = DBConnection.getConnection()) {
        String sql =
            "SELECT b.total_amount, b.num_seats, f.flight_no, f.source, " +
            "f.destination, f.depart_date, f.depart_time " +
            "FROM bookings b JOIN flights f ON b.flight_id = f.id " +
            "WHERE b.id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            totalAmount  = rs.getDouble("total_amount");
            numSeats     = rs.getInt("num_seats");
            flightNo     = rs.getString("flight_no");
            source       = rs.getString("source");
            destination  = rs.getString("destination");
            departDate   = rs.getString("depart_date");
            departTime   = rs.getString("depart_time");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    double gst         = totalAmount * 0.05;
    double grandTotal  = totalAmount + gst;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment - SkyConnect</title>
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

        .container { max-width: 600px; margin: 40px auto; padding: 0 20px; }

        /* STEPS */
        .steps {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0;
            margin-bottom: 32px;
        }
        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }
        .step-circle {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
            background: #d1d9f0;
            color: #666;
        }
        .step.done .step-circle  { background: #059669; color: #fff; }
        .step.active .step-circle { background: #1a56db; color: #fff; }
        .step-label { font-size: 11px; color: #888; font-weight: 600; }
        .step.active .step-label { color: #1a56db; }
        .step.done .step-label   { color: #059669; }
        .step-line {
            flex: 1;
            height: 2px;
            background: #d1d9f0;
            margin-bottom: 18px;
            min-width: 40px;
        }
        .step-line.done { background: #059669; }

        /* CARD */
        .card {
            background: #fff;
            border-radius: 18px;
            padding: 36px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.10);
        }
        .card h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1a56db;
            margin-bottom: 24px;
        }

        /* BOOKING SUMMARY */
        .summary-box {
            background: linear-gradient(120deg, #eef4ff, #f0faff);
            border: 1.5px solid #c7d9ff;
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 24px;
        }
        .summary-box .route {
            font-size: 20px;
            font-weight: 700;
            color: #1a56db;
            margin-bottom: 12px;
        }
        .summary-box .route span { color: #0ea5e9; margin: 0 8px; }
        .summary-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        .summary-item label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #888;
            margin-bottom: 3px;
        }
        .summary-item span {
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        /* FARE BOX */
        .fare-box {
            background: #f8faff;
            border-radius: 12px;
            padding: 18px 22px;
            margin-bottom: 24px;
        }
        .fare-box h4 {
            font-size: 14px;
            font-weight: 700;
            color: #444;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .fare-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #555;
            margin-bottom: 8px;
        }
        .fare-row.total {
            font-size: 20px;
            font-weight: 700;
            color: #059669;
            border-top: 1.5px dashed #d1d9f0;
            padding-top: 10px;
            margin-top: 6px;
        }

        /* PAYMENT METHOD */
        .method-label {
            font-size: 13px;
            font-weight: 700;
            color: #444;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
        }
        .method-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 24px;
        }
        .method-option {
            position: relative;
        }
        .method-option input[type="radio"] {
            display: none;
        }
        .method-option label {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 16px;
            border: 1.5px solid #d1d9f0;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #444;
            transition: all 0.18s;
            background: #fafbff;
        }
        .method-option label .icon { font-size: 20px; }
        .method-option input[type="radio"]:checked + label {
            border-color: #1a56db;
            background: #eef4ff;
            color: #1a56db;
        }
        .method-option label:hover {
            border-color: #1a56db;
            background: #f5f8ff;
        }

        /* BUTTON */
        .btn-pay {
            width: 100%;
            padding: 15px;
            background: linear-gradient(90deg, #059669, #10b981);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
        }
        .btn-pay:hover { opacity: 0.92; transform: translateY(-1px); }

        .secure-note {
            text-align: center;
            margin-top: 12px;
            font-size: 12px;
            color: #888;
        }
        .secure-note span { color: #059669; font-weight: 600; }
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

    <!-- STEPS -->
    <div class="steps">
        <div class="step done">
            <div class="step-circle">✓</div>
            <div class="step-label">Search</div>
        </div>
        <div class="step-line done"></div>
        <div class="step done">
            <div class="step-circle">✓</div>
            <div class="step-label">Book</div>
        </div>
        <div class="step-line done"></div>
        <div class="step done">
            <div class="step-circle">✓</div>
            <div class="step-label">Passengers</div>
        </div>
        <div class="step-line"></div>
        <div class="step active">
            <div class="step-circle">4</div>
            <div class="step-label">Payment</div>
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-circle">5</div>
            <div class="step-label">Ticket</div>
        </div>
    </div>

    <div class="card">
        <h2>💳 Complete Payment</h2>

        <!-- BOOKING SUMMARY -->
        <div class="summary-box">
            <div class="route">
                <%= source %> <span>→</span> <%= destination %>
            </div>
            <div class="summary-grid">
                <div class="summary-item">
                    <label>Flight</label>
                    <span><%= flightNo %></span>
                </div>
                <div class="summary-item">
                    <label>Booking ID</label>
                    <span>#<%= bookingId %></span>
                </div>
                <div class="summary-item">
                    <label>Date</label>
                    <span><%= departDate %></span>
                </div>
                <div class="summary-item">
                    <label>Departure</label>
                    <span><%= departTime %></span>
                </div>
                <div class="summary-item">
                    <label>Seats</label>
                    <span><%= numSeats %></span>
                </div>
                <div class="summary-item">
                    <label>Passenger</label>
                    <span><%= userName %></span>
                </div>
            </div>
        </div>

        <!-- FARE -->
        <div class="fare-box">
            <h4>💰 Fare Breakdown</h4>
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
                <span>₹ <%= String.format("%.2f", grandTotal) %></span>
            </div>
        </div>

        <!-- PAYMENT FORM -->
        <form action="processPayment" method="post">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">

            <div class="method-label">Select Payment Method</div>
            <div class="method-grid">
                <div class="method-option">
                    <input type="radio" name="paymentMethod" id="upi" value="UPI" required>
                    <label for="upi">
                        <span class="icon">📱</span> UPI
                    </label>
                </div>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" id="card" value="CARD">
                    <label for="card">
                        <span class="icon">💳</span> Card
                    </label>
                </div>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" id="netbanking" value="NETBANKING">
                    <label for="netbanking">
                        <span class="icon">🏦</span> Net Banking
                    </label>
                </div>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" id="cash" value="CASH">
                    <label for="cash">
                        <span class="icon">💵</span> Cash
                    </label>
                </div>
            </div>

            <button type="submit" class="btn-pay">
                🔒 Pay ₹ <%= String.format("%.2f", grandTotal) %> Now
            </button>
        </form>

        <div class="secure-note">
            <span>🔐 Secure Payment</span> — Your transaction is 100% encrypted
        </div>
    </div>
</div>

</body>
</html>