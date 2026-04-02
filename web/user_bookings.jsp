
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.skyconnect.servlet.UserBookingsServlet.BookingRow" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }

    List<BookingRow> list = (List<BookingRow>) request.getAttribute("bookings");

    String cancelError = (String) session.getAttribute("cancelError");
    if (cancelError != null) session.removeAttribute("cancelError");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings - SkyConnect</title>
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

        .container { max-width: 1150px; margin: 36px auto; padding: 0 20px; }

        /* PAGE HEADER */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-header h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1a56db;
        }
        .btn-search {
            padding: 10px 22px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: opacity 0.2s;
        }
        .btn-search:hover { opacity: 0.9; }

        /* ALERT */
        .alert-error {
            background: #fef2f2;
            border: 1.5px solid #fca5a5;
            color: #991b1b;
            border-radius: 10px;
            padding: 13px 18px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        /* TABLE CARD */
        .table-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        /* TABLE */
        table { width: 100%; border-collapse: collapse; }
        thead tr {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
        }
        thead th {
            color: #fff;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
        }
        tbody td {
            padding: 14px 16px;
            font-size: 14px;
            color: #444;
            border-bottom: 1px solid #f0f4ff;
        }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #f7f9ff; }

        /* BADGES */
        .badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-block;
        }
        .badge-paid     { background: #d1fae5; color: #065f46; }
        .badge-pending  { background: #fef9c3; color: #854d0e; }
        .badge-refunded { background: #dbeafe; color: #1e40af; }
        .badge-cancelled{ background: #fee2e2; color: #991b1b; }
        .badge-booked   { background: #ede9fe; color: #5b21b6; }

        /* ACTION BUTTONS */
        .actions { display: flex; gap: 8px; flex-wrap: wrap; }
        .btn-action {
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: opacity 0.2s, transform 0.1s;
            display: inline-block;
            white-space: nowrap;
        }
        .btn-action:hover { opacity: 0.88; transform: translateY(-1px); }
        .btn-view   { background: #eef4ff; color: #1a56db; border: 1.5px solid #c7d9ff; }
        .btn-pay    { background: #d1fae5; color: #065f46; border: 1.5px solid #6ee7b7; }
        .btn-cancel { background: #fee2e2; color: #991b1b; border: 1.5px solid #fca5a5; }

        /* EMPTY STATE */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #aaa;
        }
        .empty-state .icon { font-size: 52px; margin-bottom: 14px; }
        .empty-state p { font-size: 15px; margin-bottom: 16px; }
        .empty-state a {
            padding: 10px 26px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }

        /* ROUTE */
        .route { font-weight: 600; color: #333; }
        .route span { color: #0ea5e9; margin: 0 4px; }

        footer {
            text-align: center;
            padding: 20px;
            color: #888;
            font-size: 13px;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="userDashboard" class="brand">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="userDashboard">Dashboard</a>
        <a href="search_flights.jsp">Search Flights</a>
        <a href="<%= request.getContextPath() %>/userRefundHistory">My Refunds</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <h2>🎫 My Bookings</h2>
        <a href="search_flights.jsp" class="btn-search">+ Book New Flight</a>
    </div>

    <!-- ERROR -->
    <% if (cancelError != null) { %>
        <div class="alert-error">⚠️ <%= cancelError %></div>
    <% } %>

    <!-- TABLE -->
    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>#ID</th>
                    <th>Flight</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Seats</th>
                    <th>Amount</th>
                    <th>Payment</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (list == null || list.isEmpty()) {
            %>
                <tr>
                    <td colspan="10">
                        <div class="empty-state">
                            <div class="icon">🎫</div>
                            <p>You have no bookings yet.</p>
                            <a href="search_flights.jsp">Search & Book a Flight</a>
                        </div>
                    </td>
                </tr>
            <%
                } else {
                    for (BookingRow b : list) {
            %>
                <tr>
                    <td><strong>#<%= b.id %></strong></td>
                    <td><strong><%= b.flightNo %></strong></td>
                    <td>
                        <span class="route">
                            <%= b.source %> <span>→</span> <%= b.destination %>
                        </span>
                    </td>
                    <td><%= b.departDate %></td>
                    <td><%= b.departTime %></td>
                    <td><%= b.numSeats %></td>
                    <td><strong>₹ <%= String.format("%.2f", b.totalAmount) %></strong></td>

                    <!-- PAYMENT STATUS -->
                    <td>
                        <% if ("PAID".equals(b.paymentStatus)) { %>
                            <span class="badge badge-paid">✅ PAID</span>
                        <% } else if ("REFUNDED".equals(b.paymentStatus)) { %>
                            <span class="badge badge-refunded">↩ REFUNDED</span>
                        <% } else { %>
                            <span class="badge badge-pending">⏳ PENDING</span>
                        <% } %>
                    </td>

                    <!-- BOOKING STATUS -->
                    <td>
                        <% if ("CANCELLED".equals(b.status)) { %>
                            <span class="badge badge-cancelled">❌ CANCELLED</span>
                        <% } else if ("PAID".equals(b.status)) { %>
                            <span class="badge badge-paid">✅ PAID</span>
                        <% } else { %>
                            <span class="badge badge-booked">📋 BOOKED</span>
                        <% } %>
                    </td>

                    <!-- ACTIONS -->
                    <td>
                        <div class="actions">
                            <!-- VIEW TICKET -->
                            <a href="invoice?bookingId=<%= b.id %>"
                               class="btn-action btn-view">🎫 Ticket</a>

                            <!-- PAY -->
                            <% if ("PENDING".equals(b.paymentStatus)
                                   && !"CANCELLED".equals(b.status)) { %>
                                <a href="payment.jsp?bookingId=<%= b.id %>"
                                   class="btn-action btn-pay">💳 Pay</a>
                            <% } %>

                            <!-- CANCEL -->
                            <% if (!"CANCELLED".equals(b.status)) { %>
                                <form action="cancelBooking" method="post"
                                      style="display:inline;">
                                    <input type="hidden" name="bookingId"
                                           value="<%= b.id %>">
                                    <button class="btn-action btn-cancel"
                                            onclick="return confirm('Cancel this booking?');">
                                        ✕ Cancel
                                    </button>
                                </form>
                            <% } %>
                        </div>
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

<footer>© 2026 SkyConnect Airline Reservation System | JSP • Servlets • MySQL</footer>

</body>
</html>