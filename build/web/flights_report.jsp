<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.skyconnect.servlet.ReportFlightsServlet.FlightRow" %>

<%
    List<FlightRow> flights =
            (List<FlightRow>) request.getAttribute("flights");

    SimpleDateFormat sdf =
            new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String generatedOn = sdf.format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Flights Report - SkyConnect</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
        }
        .report-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,.08);
        }
        .badge-seat {
            font-size: 14px;
            padding: 6px 14px;
            border-radius: 20px;
        }
        .report-header {
            border-bottom: 2px solid #0d6efd;
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
                <p class="text-primary fw-semibold mb-1">All Flights Report</p>
                <small class="text-muted">
                    Generated On: <%= generatedOn %>
                </small>
            </div>

                <button onclick="exportFlightsCSV()" class="btn btn-success">
                <i class="bi bi-download"></i> Export CSV
                </button>
        </div>

        <!-- FILTER FORM -->
        <form method="get" action="reportFlights" class="row g-3 mb-4">

            <div class="col-md-4">
                <label class="form-label">Route</label>
                <select name="route" class="form-select">
                    <option value="">All Routes</option>
                    <option value="Mumbai-Delhi">Mumbai → Delhi</option>
                    <option value="Delhi-Mumbai">Delhi → Mumbai</option>
                    <option value="Ahmedabad-Jaipur">Ahmedabad → Jaipur</option>
                    <option value="Jaipur-Ahmedabad">Jaipur → Ahmedabad</option>
                    <option value="Nagpur-Delhi">Nagpur → Delhi</option>
                    <option value="Delhi-Nagpur">Delhi → Nagpur</option>
                </select>
            </div>

            <div class="col-md-4">
                <label class="form-label">Departure Date</label>
                <input type="date" name="date" class="form-control">
            </div>

            <div class="col-md-4 d-flex align-items-end gap-2">
                <button class="btn btn-primary w-50">
                    <i class="bi bi-search"></i> Filter
                </button>
                <a href="reportFlights" class="btn btn-secondary w-50">
                    Reset
                </a>
            </div>

        </form>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Flight No</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Price (₹)</th>
                    <th>Total Seats</th>
                    <th>Available</th>
                </tr>
                </thead>

                <tbody>
                <% if (flights == null || flights.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="text-center text-danger fw-semibold">
                            No flights found
                        </td>
                    </tr>
                <% } else {
                    for (FlightRow f : flights) { %>
                    <tr>
                        <td><%= f.id %></td>
                        <td><%= f.flightNo %></td>
                        <td>
                            <%= f.source %> → <%= f.destination %>
                        </td>
                        <td>
                            <%= f.departDate %><br>
                            <small class="text-muted">
                                <%= f.departTime %>
                            </small>
                        </td>
                        <td><%= f.arrivalTime %></td>
                        <td>₹ <%= f.price %></td>
                        <td><%= f.totalSeats %></td>
                        <td>
                            <span class="badge bg-success badge-seat">
                                <%= f.availableSeats %>
                            </span>
                        </td>
                        <td>
   
                            <%--<a href="getSeatMap?flightId=<%= f.id %>"
       class="btn btn-sm btn-outline-primary">
        <i class="bi bi-grid-3x3-gap"></i> Seat Map
    </a>--%>
</td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>

    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function exportFlightsCSV() {
    let table = document.querySelector("table");
    let rows = table.querySelectorAll("tr");
    let csv = [];

    rows.forEach(row => {
        let cols = row.querySelectorAll("th, td");
        let rowData = [];
        cols.forEach(col => rowData.push('"' + col.innerText + '"'));
        csv.push(rowData.join(","));
    });

    let blob = new Blob([csv.join("\n")], { type: "text/csv" });
    let link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "All_Flights_Report.csv";
    link.click();
}
</script>
</body>
</html>