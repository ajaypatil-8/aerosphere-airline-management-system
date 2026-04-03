<%@ page contentType="text/html;charset=UTF-8" %> 
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - SkyConnect</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #0d6efd, #00c6ff);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            border-radius: 18px;
            box-shadow: 0 15px 40px rgba(0,0,0,.25);
            background: #fff;
            padding: 30px;
        }

        .login-icon {
            font-size: 55px;
            color: #0d6efd;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px;
        }

        .btn-admin {
            background: linear-gradient(90deg,#0d6efd,#00c6ff);
            border: none;
            color: #fff;
            font-weight: 600;
            border-radius: 12px;
            padding: 12px;
        }

        .btn-admin:hover {
            opacity: .9;
        }

        .brand {
            font-weight: 700;
            font-size: 20px;
        }
    </style>
</head>

<body>

<div class="login-card text-center">

    <!-- ICON -->
    <div class="mb-3">
        <i class="bi bi-shield-lock-fill login-icon"></i>
    </div>

    <!-- TITLE -->
    <h3 class="mb-1 brand">SkyConnect Admin</h3>
    <p class="text-muted mb-4">Secure administrator access</p>

    <!-- ERROR MESSAGE -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="alert alert-danger py-2">
            <i class="bi bi-exclamation-triangle"></i> <%= error %>
        </div>
    <% } %>

    <!-- LOGIN FORM -->
    <form action="login" method="post">

        <div class="mb-3 text-start">
            <label class="form-label">
                <i class="bi bi-envelope"></i> Admin Email
            </label>
            <input type="email" name="email"
                   class="form-control"
                   placeholder="admin@airline.com" required>
        </div>

        <div class="mb-4 text-start">
            <label class="form-label">
                <i class="bi bi-lock"></i> Password
            </label>
            <input type="password" name="password"
                   class="form-control"
                   placeholder="Enter password" required>
        </div>
       <input type="hidden" name="loginType" value="ADMIN">

        <button type="submit" class="btn btn-admin w-100">
            <i class="bi bi-box-arrow-in-right"></i> Login as Admin
        </button>
    </form>

    <!-- BACK LINK -->
    <div class="mt-4">
        <a href="/Views/auth/index.jsp" class="text-decoration-none">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
    </div>

</div>

</body>
</html>
