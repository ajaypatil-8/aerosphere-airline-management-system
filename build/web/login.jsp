<%--<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login - SkyConnect</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <div class="navbar">
    <div class="brand">✈ SkyConnect</div>
    <div>
      <a href="index.jsp">Home</a>
      <a href="register.jsp">Register</a>
    </div>
  </div>

  <div class="container">
    <div class="card">
      <h2>Login</h2>
      <form action="login" method="post">
        <div class="form-group">
          <label>Email</label>
          <input type="email" name="email" required>
        </div>
        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" required>
        </div>
        <button class="btn" type="submit">Login</button>
      </form>

      <p style="color:red;">
        <%
          String err = (String) request.getAttribute("error");
          if (err != null) out.print(err);
        %>
      </p>
    </div>
  </div>
</body>
</html>--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login – SkyConnect</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(120deg, #eaf2ff, #f7fbff);
            min-height: 100vh;
        }

        /* Navbar */
        .sky-navbar {
            background: linear-gradient(90deg, #005bea, #00c6fb);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .sky-navbar .navbar-brand {
            color: #fff !important;
            font-size: 1.4rem;
            font-weight: 700;
        }

        .sky-navbar .nav-link {
            color: #fff !important;
            padding: 8px 18px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .sky-navbar .nav-link:hover {
            background: rgba(255,255,255,0.25);
            transform: translateY(-2px);
        }

        /* Login Card */
        .login-card {
            max-width: 420px;
            margin: 80px auto;
            border-radius: 18px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
            padding: 30px;
            background: #fff;
        }

        .login-card h2 {
            font-weight: 700;
            text-align: center;
            margin-bottom: 25px;
        }

        .form-control {
            border-radius: 30px;
            padding-left: 45px;
        }

        .input-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .btn-login {
            border-radius: 30px;
            background: linear-gradient(90deg, #005bea, #00c6fb);
            border: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,91,234,0.4);
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg sky-navbar">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="bi bi-airplane-engines-fill me-2"></i>SkyConnect
        </a>
        <div class="ms-auto">
            <a class="nav-link d-inline-block" href="index.jsp">
                <i class="bi bi-house-door-fill me-1"></i>Home
            </a>
            <a class="nav-link d-inline-block" href="register.jsp">
                <i class="bi bi-person-plus-fill me-1"></i>Register
            </a>
        </div>
    </div>
</nav>

<!-- LOGIN CARD -->
<div class="login-card">
    <h2>Login</h2>

    <form action="login" method="post">

        <!-- Email -->
        <div class="mb-3 position-relative">
            <i class="bi bi-envelope-fill input-icon"></i>
            <input type="email" class="form-control" name="email" placeholder="Email address" required>
        </div>

        <!-- Password -->
        <div class="mb-3 position-relative">
            <i class="bi bi-lock-fill input-icon"></i>
            <input type="password" class="form-control" name="password" placeholder="Password" required>
        </div>
        <input type="hidden" name="loginType" value="USER">

        <button type="submit" class="btn btn-login w-100 text-white">
            <i class="bi bi-box-arrow-in-right me-1"></i> Login
        </button>
    </form>

    <!-- Error Message -->
    <%
        String err = (String) request.getAttribute("error");
        if (err != null) {
    %>
        <p class="text-danger text-center mt-3"><%= err %></p>
    <% } %>

    <p class="text-center mt-3">
        New user? <a href="register.jsp">Create an account</a>
    </p>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

