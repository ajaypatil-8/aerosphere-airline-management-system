<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.servlet.ReportPassengersServlet.PassengerRow" %>

<%
    List<PassengerRow> passengers =
        (List<PassengerRow>) request.getAttribute("passengers");

    SimpleDateFormat sdf =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String generatedOn = sdf.format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Passenger Report - SkyConnect</title>

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
        .seat-badge {
            font-size:14px;
            padding:6px 14px;
            border-radius:20px;
        }
    </style>
</head>

<body>

<div class="container my-5">
<div class="report-card">

<!-- HEADER -->
<div class="report-header">
    <h4 class="fw-bold mb-0">SkyConnect Airline Reservation System</h4>
    <p class="text-primary fw-semibold mb-1">
        Passenger Report (Seat-wise per Flight)
    </p>
    <small class="text-muted">
        Generated On: <%= generatedOn %>
    </small>
</div>

<!-- TABLE -->
<div class="table-responsive">
<table class="table table-bordered table-hover align-middle" id="passengerTable">
<thead class="table-primary">
<tr>
    <th>#</th>
    <th>Flight</th>
    <th>Route</th>
    <th>Passenger Name</th>
    <th>Age</th>
    <th>Gender</th>
    <th>Seat No</th>
    <th>Booking ID</th>
    <th>Status</th>
</tr>
</thead>

<tbody>
<%
int i = 1;
if (passengers == null || passengers.isEmpty()) {
%>
<tr>
    <td colspan="9" class="text-center text-danger fw-semibold">
        No passenger records found
    </td>
</tr>
<%
} else {
for (PassengerRow p : passengers) {
%>
<tr>
    <td><%= i++ %></td>
    <td><%= p.flightNo %></td>
    <td><%= p.source %> → <%= p.destination %></td>
    <td><%= p.passengerName %></td>
    <td><%= p.age %></td>
    <td><%= p.gender %></td>
    <td>
        <span class="badge bg-success seat-badge">
            <%= p.seatNo != null ? p.seatNo : "AUTO" %>
        </span>
    </td>
    <td><%= p.bookingId %></td>
    <td>
        <span class="badge bg-<%= "CANCELLED".equals(p.bookingStatus)
                ? "danger" : "success" %>">
            <%= p.bookingStatus %>
        </span>
    </td>
</tr>
<%
}}
%>
</tbody>
</table>
</div>

<!-- EXPORT -->
<div class="text-end mt-3">
    <button onclick="exportCSV()" class="btn btn-success">
        <i class="bi bi-download"></i> Export CSV
    </button>
</div>

</div>
</div>

<script>
function exportCSV() {
    let rows = document.querySelectorAll("#passengerTable tr");
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
    link.download = "Passenger_Seatwise_Report.csv";
    link.click();
}
</script>

</body>
</html>