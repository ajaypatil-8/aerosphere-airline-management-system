<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.skyconnect.util.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }

    String flightIdStr = request.getParameter("flightId");
    String numSeatsStr = request.getParameter("numSeats");
    if (flightIdStr == null) { response.sendRedirect("search_flights.jsp"); return; }

    int flightId = Integer.parseInt(flightIdStr);
    int numSeats = (numSeatsStr != null) ? Integer.parseInt(numSeatsStr) : 1;

    String flightNo = "", source = "", destination = "", departDate = "", departTime = "", arrivalTime = "";
    double price = 0;
    int seatsAvailable = 0;

    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM flights WHERE id = ?");
        ps.setInt(1, flightId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            flightNo      = rs.getString("flight_no");
            source        = rs.getString("source");
            destination   = rs.getString("destination");
            departDate    = rs.getString("depart_date");
            departTime    = rs.getString("depart_time");
            arrivalTime   = rs.getString("arrival_time");
            price         = rs.getDouble("price");
            seatsAvailable = rs.getInt("seats_available");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    double totalAmount = price * numSeats;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Flight - SkyConnect</title>
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

        .container { max-width: 700px; margin: 40px auto; padding: 0 20px; }

        /* CARD */
        .card {
            background: #fff;
            border-radius: 18px;
            padding: 36px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.10);
        }
        .card h2 {
            font-size: 22px;
            color: #1a56db;
            font-weight: 700;
            margin-bottom: 24px;
        }

        /* FLIGHT SUMMARY BOX */
        .flight-summary {
            background: linear-gradient(120deg, #eef4ff, #f0faff);
            border: 1.5px solid #c7d9ff;
            border-radius: 14px;
            padding: 22px 26px;
            margin-bottom: 28px;
        }
        .flight-summary .route {
            font-size: 22px;
            font-weight: 700;
            color: #1a56db;
            margin-bottom: 14px;
        }
        .flight-summary .route span { color: #0ea5e9; margin: 0 10px; }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        .info-item label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #888;
            margin-bottom: 3px;
        }
        .info-item span {
            font-size: 15px;
            font-weight: 600;
            color: #333;
        }

        /* DIVIDER */
        .divider {
            border: none;
            border-top: 1.5px solid #eef0f8;
            margin: 24px 0;
        }

        /* FARE SUMMARY */
        .fare-box {
            background: #f8faff;
            border-radius: 12px;
            padding: 18px 22px;
            margin-bottom: 28px;
        }
        .fare-box h4 {
            font-size: 15px;
            font-weight: 700;
            color: #444;
            margin-bottom: 12px;
        }
        .fare-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #555;
            margin-bottom: 8px;
        }
        .fare-row.total {
            font-size: 18px;
            font-weight: 700;
            color: #059669;
            border-top: 1.5px dashed #d1d9f0;
            padding-top: 10px;
            margin-top: 6px;
        }

        /* FORM */
        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 18px;
        }
        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }
        .form-group input, .form-group select {
            padding: 11px 14px;
            border: 1.5px solid #d1d9f0;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
            background: #fafbff;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #1a56db;
            background: #fff;
        }

        /* SEATS WARNING */
        .seats-info {
            font-size: 13px;
            color: #d97706;
            background: #fffbeb;
            border: 1px solid #fcd34d;
            border-radius: 8px;
            padding: 8px 14px;
            margin-bottom: 18px;
        }

        /* BUTTON */
        .btn-confirm {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
        }
        .btn-confirm:hover { opacity: 0.92; transform: translateY(-1px); }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 16px;
            font-size: 13px;
            color: #1a56db;
            text-decoration: none;
        }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="userDashboard" class="brand">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="userDashboard">Dashboard</a>
        <a href="search_flights.jsp">Search</a>
        <a href="userBookings">My Bookings</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h2>✈ Confirm Your Booking</h2>

        <!-- FLIGHT SUMMARY -->
        <div class="flight-summary">
            <div class="route">
                <%= source %> <span>→</span> <%= destination %>
            </div>
            <div class="info-grid">
                <div class="info-item">
                    <label>Flight No</label>
                    <span><%= flightNo %></span>
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
                    <label>Arrival</label>
                    <span><%= arrivalTime != null && !arrivalTime.isEmpty() ? arrivalTime : "-" %></span>
                </div>
                <div class="info-item">
                    <label>Seats Available</label>
                    <span><%= seatsAvailable %></span>
                </div>
                <div class="info-item">
                    <label>Price per Seat</label>
                    <span>₹ <%= String.format("%.2f", price) %></span>
                </div>
            </div>
        </div>

        <% if (seatsAvailable < numSeats) { %>
        <div class="seats-info">
            ⚠️ Only <%= seatsAvailable %> seat(s) available. Please reduce your seat count.
        </div>
        <% } %>

        <!-- FARE SUMMARY -->
        <div class="fare-box">
            <h4>💰 Fare Summary</h4>
            <div class="fare-row">
                <span>Price per Seat</span>
                <span>₹ <%= String.format("%.2f", price) %></span>
            </div>
            <div class="fare-row">
                <span>Number of Seats</span>
                <span><%= numSeats %></span>
            </div>
            <div class="fare-row total">
                <span>Total Amount</span>
                <span>₹ <%= String.format("%.2f", totalAmount) %></span>
            </div>
        </div>

        <hr class="divider">

        <!-- BOOKING FORM -->
        <form action="bookFlight" method="post">
            <input type="hidden" name="flightId" value="<%= flightId %>">

            <div class="form-group">
                <label>Number of Seats</label>
                <input type="number" name="numSeats"
                       min="1" max="<%= seatsAvailable %>"
                       value="<%= numSeats %>" required
                       oninput="updateTotal(this.value)">
            </div>

            <button type="submit" class="btn-confirm"
                    <%= seatsAvailable == 0 ? "disabled" : "" %>>
                ✅ Confirm Booking
            </button>
        </form>

        <a href="search_flights.jsp" class="back-link">← Back to Search</a>
    </div>
</div>

<script>
function updateTotal(seats) {
    const price = <%= price %>;
    const total = (price * seats).toFixed(2);
    // optionally update a live total display if added
}
</script>

</body>
</html>