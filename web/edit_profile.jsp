<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userId = String.valueOf(session.getAttribute("userId"));
    String editError = (String) session.getAttribute("editError");
    String editSuccess = (String) session.getAttribute("editSuccess");
    session.removeAttribute("editError");
    session.removeAttribute("editSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile – SkyConnect</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4ff; color: #222; }

        .navbar {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 14px 32px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .navbar .brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
        .nav-links a { color: #fff; text-decoration: none; margin-left: 22px; font-size: 14px; font-weight: 500; opacity: 0.9; }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }

        .container { max-width: 560px; margin: 48px auto; padding: 0 16px; }

        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
            padding: 36px 40px;
        }

        .section-title {
            font-size: 13px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.7px; color: #1a56db;
            border-bottom: 2px solid #eef4ff; padding-bottom: 8px;
            margin-bottom: 24px;
        }

        .avatar-row {
            display: flex; align-items: center; gap: 18px;
            margin-bottom: 28px;
        }
        .avatar {
            width: 64px; height: 64px; border-radius: 50%;
            background: linear-gradient(135deg, #1a56db, #0ea5e9);
            color: #fff; font-size: 26px; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .avatar-info p { font-size: 13px; color: #6b7280; margin-top: 2px; }
        .avatar-info strong { font-size: 16px; color: #111; }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
        input[type="text"], input[type="email"], input[type="tel"], input[type="password"] {
            width: 100%; padding: 10px 14px;
            border: 1.5px solid #d1d9f0; border-radius: 10px;
            font-size: 14px; color: #222; background: #f8faff;
            outline: none; transition: border-color 0.2s;
        }
        input:focus { border-color: #1a56db; background: #fff; }

        .hint { font-size: 12px; color: #9ca3af; margin-top: 4px; }

        .divider { border: none; border-top: 1.5px solid #eef4ff; margin: 24px 0; }

        .btn-row { display: flex; gap: 12px; margin-top: 8px; }
        .btn-primary {
            flex: 1; padding: 12px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border: none; border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-primary:hover { opacity: 0.9; }
        .btn-secondary {
            flex: 1; padding: 12px;
            background: #e5e7eb; color: #374151;
            border: none; border-radius: 10px;
            font-size: 15px; font-weight: 600; cursor: pointer;
            text-align: center; text-decoration: none;
            display: flex; align-items: center; justify-content: center;
        }
        .btn-secondary:hover { background: #d1d5db; }

        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; font-weight: 500; margin-bottom: 20px;
        }
        .alert-error { background: #fee2e2; color: #991b1b; }
        .alert-success { background: #d1fae5; color: #065f46; }
    </style>
</head>
<body>

<nav class="navbar">
    <a class="brand" href="index.jsp">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="userDashboard">Dashboard</a>
        <a href="search_flights.jsp">Search</a>
        <a href="userBookings">My Bookings</a>
        <a href="userRefundHistory">My Refunds</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="card">

        <div class="avatar-row">
            <div class="avatar"><%= userName.substring(0,1).toUpperCase() %></div>
            <div class="avatar-info">
                <strong><%= userName %></strong>
                <p>Update your personal information below</p>
            </div>
        </div>

        <% if (editError != null) { %>
            <div class="alert alert-error">⚠ <%= editError %></div>
        <% } %>
        <% if (editSuccess != null) { %>
            <div class="alert alert-success">✔ <%= editSuccess %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/editProfile" method="post">
            <input type="hidden" name="userId" value="<%= userId %>">

            <p class="section-title">Personal Information</p>

            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName"
                       value="<%= userName != null ? userName : "" %>"
                       placeholder="Enter your full name" required>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       value="<%= userEmail != null ? userEmail : "" %>"
                       placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone"
                       value="<%= userPhone != null ? userPhone : "" %>"
                       placeholder="Enter your phone number">
            </div>

            <hr class="divider">

            <p class="section-title">Change Password</p>

            <div class="form-group">
                <label for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword"
                       placeholder="Enter current password">
                <p class="hint">Leave password fields blank to keep your current password.</p>
            </div>

            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword"
                       placeholder="Enter new password">
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       placeholder="Re-enter new password">
            </div>

            <div class="btn-row">
                <a href="<%= request.getContextPath() %>/profile" class="btn-secondary">Cancel</a>
                <button type="submit" class="btn-primary">Save Changes</button>
            </div>

        </form>
    </div>
</div>

<script>
    document.querySelector("form").addEventListener("submit", function(e) {
        const np = document.getElementById("newPassword").value;
        const cp = document.getElementById("confirmPassword").value;
        if (np && np !== cp) {
            e.preventDefault();
            alert("New password and confirm password do not match.");
        }
    });
</script>

</body>
</html>