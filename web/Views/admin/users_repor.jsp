<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Users Report - SkyConnect</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
        }
        .report-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0,0,0,.1);
        }
        .report-header {
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .project-title {
            font-weight: 700;
            font-size: 22px;
        }
        .report-title {
            font-size: 18px;
            color: #0d6efd;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-primary">
    <div class="container-fluid">
        <span class="navbar-brand fw-bold">✈ Admin • SkyConnect</span>
        <a href="reports" class="btn btn-light btn-sm">⬅ Back</a>
    </div>
</nav>

<div class="container mt-4">
    <div class="report-card">

        <%
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            String reportDate = sdf.format(new Date());
            List users = (List) request.getAttribute("users");
        %>

        <!-- REPORT HEADER -->
        <div class="report-header">
            <div class="project-title">SkyConnect Airline Reservation System</div>
            <div class="report-title">All Users Report</div>
            <div class="text-muted">Report Generated On: <strong><%= reportDate %></strong></div>
        </div>

        <!-- EXPORT BUTTON -->
        <div class="mb-3 text-end">
            <button onclick="exportCSV()" class="btn btn-success">
                <i class="bi bi-file-earmark-arrow-down"></i> Export CSV
            </button>
        </div>

        <!-- USERS TABLE -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle" id="usersTable">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Phone</th>
                        <th>Created Date</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (users == null || users.isEmpty()) {
                %>
                    <tr>
                        <td colspan="6" class="text-center text-danger">No users found</td>
                    </tr>
                <%
                    } else {
                        for (Object obj : users) {
                            com.skyconnect.servlet.ReportUsersServlet.UserRow u =
                                (com.skyconnect.servlet.ReportUsersServlet.UserRow) obj;
                %>
                    <tr>
                        <td><%= u.id %></td>
                        <td><%= u.name %></td>
                        <td><%= u.email %></td>
                        <td>
                            <span class="badge bg-<%= "ADMIN".equals(u.role) ? "danger" : "secondary" %>">
                                <%= u.role %>
                            </span>
                        </td>
                        <td><%= u.phone != null ? u.phone : "-" %></td>
                        <td><%= u.createdAt %></td>
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

<!-- EXPORT CSV SCRIPT -->
<script>
function exportCSV() {
    let table = document.getElementById("usersTable");
    let rows = table.querySelectorAll("tr");
    let csv = [];

    rows.forEach(row => {
        let cols = row.querySelectorAll("th, td");
        let rowData = [];
        cols.forEach(col => rowData.push('"' + col.innerText + '"'));
        csv.push(rowData.join(","));
    });

    let csvFile = new Blob([csv.join("\n")], { type: "text/csv" });
    let link = document.createElement("a");
    link.href = URL.createObjectURL(csvFile);
    link.download = "All_Users_Report.csv";
    link.click();
}
</script>

</body>
</html>