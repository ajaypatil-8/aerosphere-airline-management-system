<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports - SkyConnect Admin</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
        }

        .report-card {
            border-radius: 16px;
            padding: 25px;
            background: white;
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .report-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
        }

        .report-icon {
            font-size: 42px;
            margin-bottom: 15px;
        }

        .title {
            font-weight: 600;
        }

        .subtitle {
            font-size: 14px;
            color: #6c757d;
        }

        a {
            text-decoration: none;
            color: inherit;
        }
    </style>
</head>

<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="adminDashboard">
            ✈ Admin • SkyConnect
        </a>

        <div class="collapse navbar-collapse justify-content-end">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="adminDashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link active" href="reports">Reports</a></li>
                <li class="nav-item"><a class="nav-link" href="logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== CONTENT ===== -->
<div class="container mt-5">

    <h3 class="mb-4 fw-bold text-primary">
        📊 Reports Dashboard
    </h3>

    <div class="row g-4">

        <!-- ALL USERS -->
        <div class="col-md-4">
            <a href="reportUsers">
                <div class="report-card text-center">
                    <div class="report-icon text-primary">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <h5 class="title">All Users</h5>
                    <p class="subtitle">Registered users list</p>
                </div>
            </a>
        </div>

        <!-- ALL FLIGHTS -->
        <div class="col-md-4">
            <a href="reportFlights">
                <div class="report-card text-center">
                    <div class="report-icon text-success">
                        <i class="bi bi-airplane-engines"></i>
                    </div>
                    <h5 class="title">All Flights</h5>
                    <p class="subtitle">Flight master data</p>
                </div>
            </a>
        </div>

        <!-- ALL BOOKINGS -->
        <div class="col-md-4">
            <a href="reportBookings">
                <div class="report-card text-center">
                    <div class="report-icon text-warning">
                        <i class="bi bi-journal-text"></i>
                    </div>
                    <h5 class="title">All Bookings</h5>
                    <p class="subtitle">Booking history & status</p>
                </div>
            </a>
        </div>

        <!-- PASSENGERS BY FLIGHT -->
        <div class="col-md-4">
            <a href="reportPassengers">
                <div class="report-card text-center">
                    <div class="report-icon text-info">
                        <i class="bi bi-person-lines-fill"></i>
                    </div>
                    <h5 class="title">Passengers by Flight</h5>
                    <p class="subtitle">Seat-wise passenger list</p>
                </div>
            </a>
        </div>

        <!-- PAYMENTS -->
        <div class="col-md-4">
            <a href="reportPayments">
                <div class="report-card text-center">
                    <div class="report-icon text-success">
                        <i class="bi bi-cash-coin"></i>
                    </div>
                    <h5 class="title">Payments</h5>
                    <p class="subtitle">Paid / Pending / Refunded</p>
                </div>
            </a>
        </div>

        <!-- CANCELLED BOOKINGS -->
        <div class="col-md-4">
            <a href="reportCancelled">
                <div class="report-card text-center">
                    <div class="report-icon text-danger">
                        <i class="bi bi-x-circle-fill"></i>
                    </div>
                    <h5 class="title">Cancelled Bookings</h5>
                    <p class="subtitle">Refund & cancellation data</p>
                </div>
            </a>
        </div>

        <%-- <div class="col-md-4">
    <a href="adminRefunds">
        <div class="report-card text-center">
            <div class="report-icon text-warning">
                <i class="bi bi-arrow-repeat"></i>
            </div>
            <h5 class="title">Refund Requests</h5>
            <p class="subtitle">Approve / Reject refunds</p>
        </div>--%>
    </a>
</div>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>