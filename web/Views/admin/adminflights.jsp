<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.skyconnect.servlet.AdminFlightsServlet.Flight" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Flights - SkyConnect</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
        }
        .glass-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 15px 35px rgba(0,0,0,.08);
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-primary shadow">
    <div class="container-fluid">
        <span class="navbar-brand fw-bold">
            <i class="bi bi-airplane"></i> Admin • SkyConnect
        </span>
        <div>
            <a href="adminDashboard" class="btn btn-outline-light btn-sm me-2">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="admin_add_flight.jsp" class="btn btn-light btn-sm">
                <i class="bi bi-plus-circle"></i> Add Flight
            </a>
        </div>
    </div>
</nav>

<div class="container my-5">

    <!-- ERROR MESSAGE -->
    <%
        if ("booked".equals(request.getParameter("error"))) {
    %>
        <div class="alert alert-warning">
            <i class="bi bi-exclamation-triangle"></i>
            Cannot delete flight — bookings already exist.
        </div>
    <%
        }
    %>

    <div class="glass-card">

        <h4 class="fw-bold mb-3">
            <i class="bi bi-airplane-engines"></i> Manage Flights
        </h4>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Flight</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Price (₹)</th>
                    <th>Seats</th>
                    <th>Available</th>
                    <th>Action</th>
                </tr>
                </thead>

                <tbody>
                <%
                    List<Flight> flights =
                        (List<Flight>) request.getAttribute("flights");

                    if (flights == null || flights.isEmpty()) {
                %>
                    <tr>
                        <td colspan="9" class="text-center text-muted">
                            No flights available
                        </td>
                    </tr>
                <%
                    } else {
                        for (Flight f : flights) {
                %>
                    <tr>
                        <td><%= f.id %></td>
                        <td><%= f.flightNo %></td>
                        <td><%= f.source %> → <%= f.destination %></td>
                        <td><%= f.date %></td>
                        <td><%= f.departTime %> - <%= f.arrivalTime %></td>
                        <td>₹ <%= f.price %></td>
                        <td><%= f.totalSeats %></td>
                        <td>
                            <span class="badge bg-success">
                                <%= f.availableSeats %>
                            </span>
                        </td>

                        <!-- ACTION COLUMN -->
                       <td>
                      

                    <%
                        if (f.availableSeats == f.totalSeats) {
                    %>
                          <a href="editFlight?id=<%= f.id %>" class="btn btn-sm btn-warning me-1">
                            <i class="bi bi-pencil-square"></i>
                        </a>
                        <a href="deleteFlight?id=<%= f.id %>"
                           onclick="return confirm('Delete this flight?')"
                           class="btn btn-sm btn-danger">
                            <i class="bi bi-trash"></i>
                        </a>
                           
                    <%
                        } else {
                    %>
                        <span class="badge bg-secondary">Booked</span>
                    <%
                        }
                    %>
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
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>