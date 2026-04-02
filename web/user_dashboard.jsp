<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.skyconnect.servlet.UserDashboardServlet.Booking" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<Booking> list = (List<Booking>) request.getAttribute("recentBookings");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - SkyConnect</title>
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
        .navbar .brand {
            color: #fff;
            font-size: 22px;
            font-weight: 700;
            text-decoration: none;
        }
        .navbar .brand span { font-size: 20px; margin-right: 6px; }
        .nav-links a {
            color: #fff;
            text-decoration: none;
            margin-left: 22px;
            font-size: 14px;
            font-weight: 500;
            opacity: 0.9;
            transition: opacity 0.2s;
        }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }

        /* CONTAINER */
        .container { max-width: 1100px; margin: 32px auto; padding: 0 20px; }

        /* WELCOME */
        .welcome-box {
            background: #fff;
            border-left: 5px solid #1a56db;
            border-radius: 12px;
            padding: 22px 28px;
            margin-bottom: 28px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.07);
        }
        .welcome-box h3 { font-size: 22px; color: #1a56db; }
        .welcome-box p { color: #666; margin-top: 4px; font-size: 14px; }

        /* QUICK ACTIONS */
        .section-title { font-size: 17px; font-weight: 600; margin-bottom: 14px; color: #333; }
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 32px;
        }
        .action-card {
            background: #fff;
            border-radius: 14px;
            padding: 24px 16px;
            text-align: center;
            text-decoration: none;
            color: #333;
            box-shadow: 0 4px 16px rgba(0,0,0,0.07);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 28px rgba(0,0,0,0.13);
            color: #1a56db;
        }
        .action-card .icon { font-size: 32px; margin-bottom: 10px; }
        .action-card span { font-size: 14px; font-weight: 600; }

        /* TABLE CARD */
        .table-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.07);
            overflow: hidden;
        }
        .table-card .card-header {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            padding: 14px 20px;
            font-weight: 600;
            font-size: 15px;
        }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #f8faff;
            color: #555;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 16px;
            text-align: left;
            border-bottom: 2px solid #e8edf5;
        }
        td {
            padding: 12px 16px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            color: #444;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f7f9ff; }

        /* BADGES */
        .badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-booked { background: #d1fae5; color: #065f46; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }
        .badge-paid { background: #dbeafe; color: #1e40af; }

        /* BTN */
        .btn-sm {
            padding: 5px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            border: 1.5px solid #1a56db;
            color: #1a56db;
            transition: all 0.2s;
        }
        .btn-sm:hover { background: #1a56db; color: #fff; }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 40px; color: #999; }
        .empty-state a { color: #1a56db; font-weight: 600; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="index.jsp" class="brand"><span>✈</span> SkyConnect</a>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="search_flights.jsp">Search Flights</a>
        <a href="userBookings">My Bookings</a>
        <a href="<%= request.getContextPath() %>/userRefundHistory">My Refunds</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">

    <!-- WELCOME -->
    <div class="welcome-box">
        <h3>Welcome back, <%= userName %> 👋</h3>
        <p>Your travel dashboard is ready. Manage your flights and bookings below.</p>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="section-title">Quick Actions</div>
    <div class="actions-grid">
        <a href="search_flights.jsp" class="action-card">
            <div class="icon">🔍</div>
            <span>Search Flights</span>
        </a>
        <a href="userBookings" class="action-card">
            <div class="icon">🎫</div>
            <span>My Bookings</span>
        </a>
        <a href="profile" class="action-card">
            <div class="icon">👤</div>
            <span>My Profile</span>
        </a>
        <a href="<%= request.getContextPath() %>/userRefundHistory" class="action-card">
            <div class="icon">💸</div>
            <span>My Refunds</span>
        </a>
    </div>

    <!-- RECENT BOOKINGS -->
    <div class="table-card">
        <div class="card-header">✈ Recent Bookings</div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Flight</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Seats</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Invoice</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (list == null || list.isEmpty()) {
            %>
                <tr>
                    <td colspan="8">
                        <div class="empty-state">
                            No bookings yet. <a href="search_flights.jsp">Book your first flight!</a>
                        </div>
                    </td>
                </tr>
            <%
                } else {
                    for (Booking b : list) {
            %>
                <tr>
                    <td><%= b.bookingId %></td>
                    <td><strong><%= b.flightNo %></strong></td>
                    <td><%= b.source %></td>
                    <td><%= b.destination %></td>
                    <td><%= b.numSeats %></td>
                    <td>₹ <%= String.format("%.2f", b.totalAmount) %></td>
                    <td>
                        <span class="badge <%= "BOOKED".equals(b.status) ? "badge-booked" : "PAID".equals(b.status) ? "badge-paid" : "badge-cancelled" %>">
                            <%= b.status %>
                        </span>
                    </td>
                    <td>
                        <a href="invoice?bookingId=<%= b.bookingId %>" class="btn-sm">View</a>
                    </td>
                </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>