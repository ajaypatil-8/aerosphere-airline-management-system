<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.servlet.ReportBookingsServlet.BookingRow" %>

<%
    List<BookingRow> bookings =
        (List<BookingRow>) request.getAttribute("bookings");

    SimpleDateFormat sdf =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String generatedOn = sdf.format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Bookings Report - SkyConnect</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background:#f4f7fb; }
        .report-card {
            background:#fff;
            border-radius:18px;
            padding:30px;
            box-shadow:0 20px 40px rgba(0,0,0,.1);
        }
        .report-header {
            border-bottom:2px solid #0d6efd;
            padding-bottom:15px;
            margin-bottom:25px;
        }
    </style>
</head>

<body>

<div class="container my-5">
<div class="report-card">

<!-- HEADER -->
<div class="report-header d-flex justify-content-between align-items-center">
    <div>
        <h4 class="fw-bold mb-0">SkyConnect Airline Reservation System</h4>
        <p class="text-primary fw-semibold mb-1">Bookings Report</p>
        <small class="text-muted">Generated On: <%= generatedOn %></small>
    </div>
    <button onclick="exportCSV()" class="btn btn-success">
        <i class="bi bi-download"></i> Export CSV
    </button>
</div>

<!-- FILTER -->
<form method="get" action="reportBookings" class="row g-3 mb-4">
    <div class="col-md-3">
        <label>Status</label>
        <select name="status" class="form-select">
            <option value="">All</option>
            <option>BOOKED</option>
            <option>PAID</option>
            <option>CANCELLED</option>
        </select>
    </div>

    <div class="col-md-3">
        <label>Payment</label>
        <select name="payment" class="form-select">
            <option value="">All</option>
            <option>PAID</option>
            <option>PENDING</option>
            <option>REFUNDED</option>
        </select>
    </div>

    <div class="col-md-3">
        <label>Date</label>
        <input type="date" name="date" class="form-control">
    </div>

    <div class="col-md-3 d-flex align-items-end gap-2">
        <button class="btn btn-primary w-50">Filter</button>
        <a href="reportBookings" class="btn btn-secondary w-50">Reset</a>
    </div>
</form>

<!-- TABLE -->
<div class="table-responsive">
<table class="table table-bordered table-hover align-middle" id="bookingsTable">
<thead class="table-primary">
<tr>
    <th>ID</th>
    <th>User</th>
    <th>Flight</th>
    <th>Route</th>
    <th>Seats</th>
    <th>Amount (₹)</th>
    <th>Status</th>
    <th>Payment</th>
    <th>Booked On</th>
</tr>
</thead>

<tbody>
<% if (bookings == null || bookings.isEmpty()) { %>
<tr>
    <td colspan="9" class="text-center text-danger fw-semibold">
        No bookings found
    </td>
</tr>
<% } else {
   for (BookingRow b : bookings) { %>
<tr>
    <td><%= b.id %></td>
    <td><%= b.userName %></td>
    <td><%= b.flightNo %></td>
    <td><%= b.source %> → <%= b.destination %></td>
    <td><%= b.seats %></td>
    <td>₹ <%= b.amount %></td>
    <td>
        <span class="badge bg-<%= "CANCELLED".equals(b.status) ? "danger" :
                                "PAID".equals(b.status) ? "success" : "warning" %>">
            <%= b.status %>
        </span>
    </td>
    <td>
        <span class="badge bg-<%= "PAID".equals(b.paymentStatus) ? "success" :
                                "REFUNDED".equals(b.paymentStatus) ? "info" : "secondary" %>">
            <%= b.paymentStatus %>
        </span>
    </td>
    <td><%= b.bookingDate %></td>
</tr>
<% }} %>
</tbody>
</table>
</div>

</div>
</div>

<!-- CSV EXPORT -->
<script>
function exportCSV() {
    let rows = document.querySelectorAll("#bookingsTable tr");
    let csv = [];
    rows.forEach(row => {
        let cols = row.querySelectorAll("th,td");
        let rowData = [];
        cols.forEach(col => rowData.push('"' + col.innerText + '"'));
        csv.push(rowData.join(","));
    });

    let blob = new Blob([csv.join("\n")], { type: "text/csv" });
    let link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "Bookings_Report.csv";
    link.click();
}
</script>

</body>
</html>