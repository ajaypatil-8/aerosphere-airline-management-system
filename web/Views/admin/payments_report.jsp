<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.servlet.ReportPaymentsServlet.PaymentRow" %>

<%
    List<PaymentRow> payments =
        (List<PaymentRow>) request.getAttribute("payments");

    SimpleDateFormat sdf =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String generatedOn = sdf.format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payments Report - SkyConnect</title>

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
            border-bottom: 2px solid #198754;
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
                <p class="text-success fw-semibold mb-1">Payments Report</p>
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
                <thead class="table-success">
                <tr>
                    <th>Payment ID</th>
                    <th>Booking ID</th>
                    <th>User</th>
                    <th>Flight</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Method</th>
                    <th>Amount (₹)</th>
                    <th>Payment Status</th>
                    <th>Booking Status</th>
                </tr>
                </thead>

                <tbody>
                <% if (payments == null || payments.isEmpty()) { %>
                    <tr>
                        <td colspan="10" class="text-center text-danger fw-semibold">
                            No payment records found
                        </td>
                    </tr>
                <% } else {
                    for (PaymentRow p : payments) { %>
                    <tr>
                        <td><%= p.paymentId %></td>
                        <td><%= p.bookingId %></td>
                        <td><%= p.userName %></td>
                        <td><%= p.flightNo %></td>
                        <td><%= p.route %></td>
                        <td><%= sdf.format(p.paymentDate) %></td>
                        <td><%= p.paymentMethod %></td>
                        <td>₹ <%= p.amount %></td>

                        <td>
                            <span class="badge badge-status
                            <%= "SUCCESS".equals(p.paymentStatus) ? "bg-success" : "bg-danger" %>">
                                <%= p.paymentStatus %>
                            </span>
                        </td>

                        <td>
                            <span class="badge badge-status
                            <%= "PAID".equals(p.bookingStatus) ? "bg-primary" : "bg-secondary" %>">
                                <%= p.bookingStatus %>
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