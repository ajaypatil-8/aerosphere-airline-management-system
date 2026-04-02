<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.servlet.ReportCancelledServlet.CancelledRow" %>

<%
    List<CancelledRow> cancelled =
        (List<CancelledRow>) request.getAttribute("cancelled");

    SimpleDateFormat sdf =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String generatedOn = sdf.format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cancelled Bookings Report - SkyConnect</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
        }
        .report-card {
            background: #fff;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,.08);
        }
        .badge-status {
            font-size: 13px;
            padding: 6px 14px;
            border-radius: 20px;
        }
        .report-header {
            border-bottom: 2px solid #dc3545;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
    </style>
</head>

<body>

<div class="container my-5">

    <div class="report-card">

        <!-- HEADER -->
        <div class="report-header d-flex justify-content-between align-items-center">
            <div>
                <h3 class="mb-0">SkyConnect Airline Reservation System</h3>
                <p class="text-danger fw-semibold mb-1">Cancelled Bookings Report</p>
                <small class="text-muted">
                    Generated On: <%= generatedOn %>
                </small>
            </div>
            <a href="reports.jsp" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-danger">
                <tr>
                    <th>Booking ID</th>
                    <th>User</th>
                    <th>Flight</th>
                    <th>Route</th>
                    <th>Booking Date</th>
                    <th>Seats</th>
                    <th>Amount (₹)</th>
                    <th>Payment Status</th>
                </tr>
                </thead>

                <tbody>
                <% if (cancelled == null || cancelled.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="text-center text-danger fw-semibold">
                            No cancelled bookings found
                        </td>
                    </tr>
                <% } else {
                    for (CancelledRow c : cancelled) { %>
                    <tr>
                        <td><%= c.bookingId %></td>
                        <td><%= c.userName %></td>
                        <td><%= c.flightNo %></td>
                        <td><%= c.route %></td>
                        <td><%= sdf.format(c.bookingDate) %></td>
                        <td><%= c.seats %></td>
                        <td>₹ <%= c.amount %></td>

                        <td>
                            <span class="badge badge-status
                            <%= "REFUNDED".equals(c.paymentStatus) ? "bg-success" : "bg-warning text-dark" %>">
                                <%= c.paymentStatus %>
                            </span>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>