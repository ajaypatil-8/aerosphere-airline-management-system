<%--<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account – SkyConnect</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .form-row { display: flex; gap: 15px; }
        .form-group { flex: 1; }
    </style>
</head>
<body>

<div class="navbar">
    <div class="brand">✈ SkyConnect</div>
    <div>
        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h2>Create Your SkyConnect Account</h2>

        <!-- SHOW ERROR / SUCCESS -->
        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");

            if (error != null) {
        %>
            <p style="color:red;"><%= error %></p>
        <% } %>

        <% if (success != null) { %>
            <p style="color:green;"><%= success %></p>
        <% } %>

        <form action="register" method="post">

            <div class="form-group">
                <label>Full Name</label>
                <input name="name" required placeholder="Enter your full name">
            </div>

            <div class="form-group">
                <label>Email</label>
                <input name="email" type="email" required placeholder="example@gmail.com">
            </div>

            <div class="form-group">
                <label>Password</label>
                <input name="password" type="password" required placeholder="Choose a password">
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input name="phone" type="text" maxlength="10" required placeholder="10-digit mobile number">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob" required>
                </div>

                <div class="form-group">
                    <label>Gender</label>
                    <select name="gender" required>
                        <option value="">Select</option>
                        <option value="MALE">Male</option>
                        <option value="FEMALE">Female</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Address</label>
                <textarea name="address" required placeholder="Full residential address"></textarea>
            </div>

            <input type="hidden" name="role" value="USER">

            <button type="submit" class="btn">Sign Up</button>
        </form>

        <p style="margin-top:10px;">
            Already have an account?
            <a href="login.jsp">Login here</a>.
        </p>

    </div>
</div>

</body>
</html>--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Account – SkyConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #eef4ff, #f9fbff);
            min-height: 100vh;
        }

        /* Navbar */
        .navbar {
            background: linear-gradient(90deg, #005bea, #00c6fb);
        }
        .navbar-brand, .nav-link {
            color: #fff !important;
            font-weight: 600;
        }

        /* Card */
        .card {
            border-radius: 18px;
            border: none;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            transition: 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 45px rgba(0,0,0,0.15);
        }

        /* Button */
        .btn-primary {
            background: linear-gradient(90deg, #005bea, #00c6fb);
            border: none;
            border-radius: 30px;
            padding: 12px;
            font-weight: 600;
        }
        .btn-primary:hover {
            opacity: 0.9;
        }

        /* Inputs */
        .form-control, .form-select {
            border-radius: 12px;
            padding: 12px;
        }

        h2 span {
            color: #005bea;
        }
        /* SkyConnect Navbar */
.sky-navbar {
    background: linear-gradient(90deg, #005bea, #00c6fb);
    padding: 12px 0;
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
}

.sky-navbar .navbar-brand {
    color: #fff !important;
    font-size: 1.4rem;
    font-weight: 700;
    letter-spacing: 0.5px;
}

.sky-navbar .navbar-brand i {
    font-size: 1.6rem;
}

.sky-navbar .nav-link {
    color: #ffffff !important;
    font-weight: 500;
    padding: 8px 18px;
    border-radius: 30px;
    transition: all 0.3s ease;
}

.sky-navbar .nav-link:hover {
    background: rgba(255,255,255,0.25);
    transform: translateY(-2px);
}

/* Highlight Login Button */
.sky-navbar .login-btn {
    background: #ffffff;
    color: #005bea !important;
    font-weight: 600;
}

.sky-navbar .login-btn:hover {
    background: #f1f6ff;
}

    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg sky-navbar">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand d-flex align-items-center" href="index.jsp">
            <i class="bi bi-airplane-engines-fill me-2"></i>
            <span>SkyConnect</span>
        </a>

        <!-- Toggle (mobile) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#skyNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menu -->
        <div class="collapse navbar-collapse justify-content-end" id="skyNav">
            <ul class="navbar-nav gap-2">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">
                        <i class="bi bi-house-door-fill me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link login-btn" href="login.jsp">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Login
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>


<!-- CONTENT -->
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9">

            <div class="card p-4">
                <h2 class="text-center mb-3">
                    Create Your <span>SkyConnect</span> Account
                </h2>

                <!-- ERROR / SUCCESS -->
                <%
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                %>
                <% if (error != null) { %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>
                <% if (success != null) { %>
                    <div class="alert alert-success"><%= success %></div>
                <% } %>

                <form action="register" method="post">

                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Choose a strong password" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" maxlength="10" class="form-control" placeholder="10-digit mobile number" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Date of Birth</label>
                            <input type="date" name="dob" class="form-control" required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Gender</label>
                            <select name="gender" class="form-select" required>
                                <option value="">Select</option>
                                <option value="MALE">Male</option>
                                <option value="FEMALE">Female</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <textarea name="address" class="form-control" rows="3" placeholder="Full residential address" required></textarea>
                    </div>

                    <input type="hidden" name="role" value="USER">

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary">
                            Create Account
                        </button>
                    </div>
                </form>

                <p class="text-center mt-3">
                    Already have an account?
                    <a href="login.jsp" class="fw-semibold text-decoration-none">Login here</a>
                </p>
            </div>

        </div>
    </div>
</div>

</body>
</html>


