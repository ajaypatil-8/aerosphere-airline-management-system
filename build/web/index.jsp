<%--<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // session attributes set by LoginServlet:
    // session.setAttribute("userId", ...);
    // session.setAttribute("userName", ...);
    // session.setAttribute("userRole", "ADMIN" or "USER");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html>
<head>
  <title>SkyConnect - Home</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    /* Minimal inline for the tiny login/register boxes on index page */
    .mini-card { background:#fff;padding:18px;border-radius:10px;box-shadow:0 6px 18px rgba(13,28,60,0.04); }
    .inline-form { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .inline-form .form-group { flex:1; min-width:160px; }
    .top-actions { display:flex; gap:10px; align-items:center; }
  </style>
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
  <div class="brand">✈ SkyConnect</div>

  <div>
    <a href="index.jsp">Home</a>
    <!-- If user is logged in show user links; if admin show admin links -->
    <% if (userName != null) { %>

        <!-- common -->
        <a href="index.jsp#search">Search Flights</a>
        <a href="userBookings">My Bookings</a>

        <% if ("ADMIN".equals(userRole)) { %>
            <!-- admin menu -->
            <a href="adminDashboard">Admin</a>
            <a href="admin_add_flight.jsp">Add Flight</a>
            <a href="admin_flights.jsp">Manage Flights</a>
        <% } %>

        <span style="color:#fff;margin-left:12px;">Welcome, <%= userName %></span>
        <a href="logout">Logout</a>

    <% } else { %>

        <!-- guest -->
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>

    <% } %>
  </div>
</div>

<!-- PAGE CONTENT -->
<div class="container">

  <!-- SEARCH BOX (for guests & users) -->
  <div class="card" id="search">
    <h2>Search Flights</h2>

    <!-- if user is logged in (user or admin) they can search too -->
    <form action="searchFlights" method="get" class="inline-form">
      <div class="form-group">
        <label>From</label>
        <input type="text" name="source" placeholder="e.g., Mumbai" required>
      </div>
      <div class="form-group">
        <label>To</label>
        <input type="text" name="destination" placeholder="e.g., Delhi" required>
      </div>
      <div class="form-group">
        <label>Departure Date</label>
        <input type="date" name="departDate" min="<%= java.time.LocalDate.now() %>" required>
      </div>
      <div class="form-group">
        <label>Seats</label>
        <input type="number" name="numSeats" min="1" value="1" required>
      </div>

      <div class="form-group" style="min-width:110px;">
        <button class="btn" type="submit">Search</button>
      </div>
    </form>

  </div>

  <!-- TOP ACTIONS: quick login/register for guests or quick admin/user actions -->
  <div style="margin-top:18px;" class="card mini-card">
    <div class="top-actions">
      <% if (userName == null) { %>
        <!-- Quick Login form (simple) -->
        <form action="login" method="post" style="display:flex;gap:12px;align-items:center;">
          <div class="form-group" style="min-width:180px;">
            <label>Email</label>
            <input type="email" name="email" placeholder="you@example.com" required>
          </div>
          <div class="form-group" style="min-width:160px;">
            <label>Password</label>
            <input type="password" name="password" placeholder="password" required>
          </div>
          <button class="btn" type="submit">Login</button>
          <a class="btn btn-link" href="register.jsp">Register</a>
        </form>

      <% } else { %>

        <!-- Quick links for logged in user/admin -->
        <div style="display:flex;gap:12px;align-items:center;">
          <a class="btn" href="userBookings">My Bookings</a>
          <a class="btn" href="profile">Profile</a>
          <% if ("ADMIN".equals(userRole)) { %>
            <a class="btn" href="adminDashboard">Admin Dashboard</a>
            <a class="btn" href="admin_add_flight.jsp">Add Flight</a>
          <% } %>
          <a class="btn btn-link" href="logout">Logout</a>
        </div>

      <% } %>
    </div>
  </div>

  <!-- ABOUT -->
  <div style="margin-top:18px;" class="card">
    <h3>About SkyConnect</h3>
    <p>
      SkyConnect is a demo airline reservation system built with Java (JSP/Servlets),
      MySQL and NetBeans (Ant). Use the menu to register, login, search flights,
      book tickets and view bookings. Admins can add/manage flights and view bookings.
    </p>
  </div>

</div> <!-- /container -->

</body>
</html>--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html>
<head>
    <title>SkyConnect – Airline Reservation System</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background:#f4f7fb; }

        .hero {
            background: linear-gradient(120deg,#0d6efd,#00c6ff);
            color:#fff;
            padding:80px 20px;
            text-align:center;
        }

        .hero h1 { font-weight:700; }

        .feature-card {
            border-radius:15px;
            box-shadow:0 10px 25px rgba(0,0,0,.08);
            transition:.2s;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }

        footer {
            background:#0d6efd;
            color:#fff;
        }
        
        .navbar .nav-link {
    position: relative;
    font-weight: 500;
    color: #fff !important;
}

.navbar .nav-link::after {
    content: "";
    position: absolute;
    left: 0;
    bottom: -6px;
    width: 0;
    height: 2px;
    background: #fff;
    transition: width .3s ease;
}

.navbar .nav-link:hover::after {
    width: 100%;
}

.navbar .nav-link:hover {
    text-shadow: 0 0 10px rgba(255,255,255,.6);
}

    </style>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<!-- ================= PREMIUM NAVBAR ================= -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top px-4"
     style="background: linear-gradient(90deg,#0d6efd,#00c6ff);
            box-shadow: 0 6px 20px rgba(0,0,0,.2);">

    <!-- LOGO -->
    <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="index.jsp">
        <i class="bi bi-airplane-engines-fill me-2"></i> SkyConnect
    </a>

    <!-- MOBILE TOGGLE -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#skyNavbar">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- MENU -->
    <div class="collapse navbar-collapse justify-content-end" id="skyNavbar">
        <ul class="navbar-nav align-items-center">

            <li class="nav-item">
                <a class="nav-link mx-2" href="index.jsp">
                    <i class="bi bi-house-door"></i> Home
                </a>
            </li>

            <% if (userName == null) { %>

            <li class="nav-item">
                <a class="nav-link mx-2" href="login.jsp">
                    <i class="bi bi-person-circle"></i> User Login
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link mx-2" href="admin_login.jsp">
                    <i class="bi bi-shield-lock"></i> Admin Login
                </a>
            </li>

            <li class="nav-item">
                <a class="btn btn-light text-primary fw-semibold ms-3"
                   href="register.jsp">
                    <i class="bi bi-person-plus"></i> Register
                </a>
            </li>

            <% } else { %>

                <% if ("ADMIN".equals(userRole)) { %>
                <li class="nav-item">
                    <a class="nav-link mx-2" href="adminDashboard">
                        <i class="bi bi-speedometer2"></i> Admin Dashboard
                    </a>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link mx-2" href="userDashboard">
                        <i class="bi bi-grid"></i> Dashboard
                    </a>
                </li>
                <% } %>

                <li class="nav-item">
                    <a class="nav-link mx-2" href="logout">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </a>
                </li>

            <% } %>

        </ul>
    </div>
</nav>


<!-- ================= HERO ================= -->
<section class="hero">
    <h1>Welcome to SkyConnect ✈️</h1>
    <p class="fs-5 mt-3">
        A smart, secure and simple Airline Reservation System  
        built using Java, JSP, Servlets & MySQL
    </p>
</section>

<!-- ================= FEATURES ================= -->
<div class="container my-5">
    <div class="row g-4">

        <div class="col-md-4">
            <div class="card feature-card p-4 text-center">
                <i class="bi bi-search fs-1 text-primary"></i>
                <h5 class="mt-3">Search Flights</h5>
                <p>Find flights easily with date and destination filters.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card feature-card p-4 text-center">
                <i class="bi bi-ticket-perforated fs-1 text-primary"></i>
                <h5 class="mt-3">Book Tickets</h5>
                <p>Quick seat booking with passenger & payment details.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card feature-card p-4 text-center">
                <i class="bi bi-shield-lock fs-1 text-primary"></i>
                <h5 class="mt-3">Admin Control</h5>
                <p>Admins can add flights, manage bookings and users.</p>
            </div>
        </div>

    </div>
</div>

<!-- ================= ABOUT ================= -->
<div class="container mb-5">
    <div class="card p-4 shadow-sm">
        <h4>About SkyConnect</h4>
        <p class="mb-0">
            SkyConnect is a demo Airline Reservation System developed for academic
            purposes using Java (JSP/Servlets), MySQL and Apache Tomcat.
            It supports role-based access for Users and Admins.
        </p>
    </div>
</div>

<!-- ================= FOOTER ================= -->
<footer class="py-3 text-center">
    <p class="mb-0">
        © 2026 SkyConnect Airline Reservation System  
        | Developed using Java & MySQL
    </p>
</footer>

</body>
</html>

