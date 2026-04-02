<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }

    List<Map<String,Object>> flights =
        (List<Map<String,Object>>) request.getAttribute("flights");

    String selectedSeats = request.getParameter("numSeats");
    if (selectedSeats == null) selectedSeats = "1";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Flights - SkyConnect</title>
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

        .container { max-width: 1100px; margin: 32px auto; padding: 0 20px; }

        /* SEARCH CARD */
        .search-card {
            background: #fff;
            border-radius: 16px;
            padding: 28px 32px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.09);
            margin-bottom: 32px;
        }
        .search-card h4 {
            font-size: 18px;
            color: #1a56db;
            margin-bottom: 20px;
            font-weight: 700;
        }
        .form-row {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            align-items: flex-end;
        }
        .form-group { display: flex; flex-direction: column; flex: 1; min-width: 140px; }
        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }
        .form-group input, .form-group select {
            padding: 10px 14px;
            border: 1.5px solid #d1d9f0;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #1a56db;
        }
        .btn-search {
            padding: 10px 28px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s;
            white-space: nowrap;
        }
        .btn-search:hover { opacity: 0.9; }

        /* RESULTS */
        .results-title {
            font-size: 17px;
            font-weight: 700;
            color: #333;
            margin-bottom: 16px;
        }
        .flights-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        @media(max-width: 900px) { .flights-grid { grid-template-columns: 1fr 1fr; } }
        @media(max-width: 580px) { .flights-grid { grid-template-columns: 1fr; } }

        .flight-card {
            background: #fff;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .flight-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 36px rgba(0,0,0,0.14);
        }
        .flight-no {
            font-size: 18px;
            font-weight: 700;
            color: #1a56db;
        }
        .route {
            font-size: 15px;
            font-weight: 600;
            color: #222;
        }
        .route span { color: #0ea5e9; margin: 0 6px; }
        .flight-meta {
            font-size: 13px;
            color: #666;
        }
        .price {
            font-size: 22px;
            font-weight: 700;
            color: #059669;
            margin-top: 4px;
        }
        .btn-book {
            margin-top: 8px;
            padding: 10px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: opacity 0.2s;
        }
        .btn-book:hover { opacity: 0.9; }

        /* EMPTY / HINT */
        .hint-box {
            text-align: center;
            padding: 60px 20px;
            color: #aaa;
        }
        .hint-box .icon { font-size: 48px; margin-bottom: 12px; }
        .hint-box p { font-size: 15px; }

        .alert-warning {
            background: #fff7e6;
            border: 1px solid #fbbf24;
            color: #92400e;
            border-radius: 10px;
            padding: 14px 20px;
            font-size: 14px;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #888;
            font-size: 13px;
            margin-top: 50px;
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
        <a href="<%= request.getContextPath() %>/userRefundHistory">My Refunds</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">

    <!-- SEARCH FORM -->
    <div class="search-card">
        <h4>🔍 Search Flights</h4>
        <form action="searchFlights" method="get">
            <div class="form-row">
                <div class="form-group">
                    <label>From</label>
                    <input type="text" name="source" placeholder="e.g. Mumbai"
                           value="<%= request.getParameter("source") != null ? request.getParameter("source") : "" %>" required>
                </div>
                <div class="form-group">
                    <label>To</label>
                    <input type="text" name="destination" placeholder="e.g. Delhi"
                           value="<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Departure Date</label>
                    <input type="date" name="departDate"
                           min="<%= java.time.LocalDate.now() %>"
                           value="<%= request.getParameter("departDate") != null ? request.getParameter("departDate") : "" %>" required>
                </div>
                <div class="form-group" style="max-width:100px;">
                    <label>Seats</label>
                    <input type="number" name="numSeats" min="1" value="<%= selectedSeats %>" required>
                </div>
                <button type="submit" class="btn-search">Search</button>
            </div>
        </form>
    </div>

    <!-- RESULTS -->
    <% if (flights == null) { %>
        <div class="hint-box">
            <div class="icon">✈️</div>
            <p>Search for flights by selecting your route and date above.</p>
        </div>

    <% } else if (flights.isEmpty()) { %>
        <div class="alert-warning">
            No flights found for the selected route and date. Try a different search.
        </div>

    <% } else { %>
        <div class="results-title">Available Flights (<%= flights.size() %> found)</div>
        <div class="flights-grid">
        <% for (Map<String,Object> f : flights) { %>
            <div class="flight-card">
                <div class="flight-no">✈ <%= f.get("flight_no") %></div>
                <div class="route">
                    <%= f.get("source") %> <span>→</span> <%= f.get("destination") %>
                </div>
                <div class="flight-meta">📅 <%= f.get("depart_date") %></div>
                <div class="flight-meta">🕐 Departs: <%= f.get("depart_time") %></div>
                <div class="flight-meta">💺 Seats Available: <%= f.get("seats_available") %></div>
                <div class="price">₹ <%= f.get("price") %></div>
                <form action="bookFlight" method="post">
                    <input type="hidden" name="flightId" value="<%= f.get("id") %>">
                    <input type="hidden" name="numSeats" value="<%= selectedSeats %>">
                    <button type="submit" class="btn-book">🎫 Book Now</button>
                </form>
            </div>
        <% } %>
        </div>
    <% } %>

</div>

<footer>© 2026 SkyConnect Airline Reservation System | JSP • Servlets • MySQL</footer>

</body>
</html>