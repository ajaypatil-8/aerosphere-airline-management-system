<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }

    Integer id          = (Integer)             request.getAttribute("id");
    String  name        = (String)              request.getAttribute("name");
    String  email       = (String)              request.getAttribute("email");
    String  phone       = (String)              request.getAttribute("phone");
    String  dob         = (String)              request.getAttribute("dob");
    String  gender      = (String)              request.getAttribute("gender");
    String  address     = (String)              request.getAttribute("address");
    String  role        = (String)              request.getAttribute("role");
    java.sql.Timestamp createdAt =
        (java.sql.Timestamp) request.getAttribute("createdAt");

    if (id == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - SkyConnect</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4ff; color: #222; }

        /* NAVBAR */
        .navbar {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 14px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .navbar .brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
        .nav-links a {
            color: #fff; text-decoration: none; margin-left: 22px;
            font-size: 14px; font-weight: 500; opacity: 0.9;
        }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }

        .container { max-width: 760px; margin: 40px auto; padding: 0 20px; }

        /* PROFILE CARD */
        .profile-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.10);
            overflow: hidden;
        }

        /* PROFILE HEADER */
        .profile-header {
            background: linear-gradient(120deg, #1a56db, #0ea5e9);
            padding: 36px;
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(255,255,255,0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            color: #fff;
            font-weight: 700;
            flex-shrink: 0;
            border: 3px solid rgba(255,255,255,0.5);
        }
        .profile-header-info h2 {
            color: #fff;
            font-size: 22px;
            font-weight: 700;
        }
        .profile-header-info p {
            color: rgba(255,255,255,0.85);
            font-size: 14px;
            margin-top: 4px;
        }
        .role-badge {
            display: inline-block;
            margin-top: 8px;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: rgba(255,255,255,0.2);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.4);
        }

        /* PROFILE BODY */
        .profile-body { padding: 32px 36px; }

        .section-title {
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: #1a56db;
            border-bottom: 2px solid #eef4ff;
            padding-bottom: 8px;
            margin-bottom: 20px;
        }

        /* INFO GRID */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 32px;
        }
        .info-item label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #888;
            margin-bottom: 5px;
        }
        .info-item span {
            font-size: 15px;
            font-weight: 600;
            color: #333;
        }
        .info-item.full { grid-column: 1 / -1; }

        /* ADDRESS BOX */
        .address-box {
            background: #f8faff;
            border-radius: 10px;
            padding: 14px 18px;
            font-size: 14px;
            color: #444;
            line-height: 1.6;
        }

        /* DIVIDER */
        .divider {
            border: none;
            border-top: 1.5px solid #eef0f8;
            margin: 28px 0;
        }

        /* ACCOUNT INFO */
        .account-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 32px;
        }

        /* QUICK ACTIONS */
        .quick-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 11px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: opacity 0.2s, transform 0.1s;
            display: inline-block;
        }
        .btn:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-primary   { background: linear-gradient(90deg,#1a56db,#0ea5e9); color: #fff; }
        .btn-secondary { background: #e5e7eb; color: #374151; }
        .btn-outline {
            background: #fff;
            color: #1a56db;
            border: 1.5px solid #1a56db;
        }
        .btn-outline:hover { background: #eef4ff; }

        footer {
            text-align: center;
            padding: 20px;
            color: #888;
            font-size: 13px;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="userDashboard" class="brand">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="userDashboard">Dashboard</a>
        <a href="userBookings">My Bookings</a>
        <a href="<%= request.getContextPath() %>/userRefundHistory">My Refunds</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
<div class="profile-card">

    <!-- HEADER -->
    <div class="profile-header">
        <div class="avatar">
            <%= name != null ? String.valueOf(name.charAt(0)).toUpperCase() : "U" %>
        </div>
        <div class="profile-header-info">
            <h2><%= name %></h2>
            <p><%= email %></p>
            <span class="role-badge">
                <%= "ADMIN".equals(role) ? "🛡 Admin" : "✈ Traveler" %>
            </span>
        </div>
    </div>

    <!-- BODY -->
    <div class="profile-body">

        <!-- PERSONAL INFO -->
        <div class="section-title">👤 Personal Information</div>
        <div class="info-grid">
            <div class="info-item">
                <label>Full Name</label>
                <span><%= name != null ? name : "—" %></span>
            </div>
            <div class="info-item">
                <label>Email Address</label>
                <span><%= email != null ? email : "—" %></span>
            </div>
            <div class="info-item">
                <label>Phone Number</label>
                <span><%= phone != null ? phone : "—" %></span>
            </div>
            <div class="info-item">
                <label>Date of Birth</label>
                <span><%= dob != null ? dob : "—" %></span>
            </div>
            <div class="info-item">
                <label>Gender</label>
                <span><%= gender != null ? gender : "—" %></span>
            </div>
            <div class="info-item">
                <label>Role</label>
                <span><%= role != null ? role : "—" %></span>
            </div>
            <div class="info-item full">
                <label>Address</label>
                <div class="address-box">
                    <%= address != null ? address : "No address provided." %>
                </div>
            </div>
        </div>

        <hr class="divider">

        <!-- ACCOUNT INFO -->
        <div class="section-title">🔐 Account Information</div>
        <div class="account-grid">
            <div class="info-item">
                <label>User ID</label>
                <span>#<%= id %></span>
            </div>
            <div class="info-item">
                <label>Member Since</label>
                <span><%= createdAt != null ? createdAt.toString().substring(0,10) : "—" %></span>
            </div>
        </div>

        <hr class="divider">

        <!-- QUICK ACTIONS -->
        <div class="section-title">⚡ Quick Actions</div>
        <div class="quick-actions">
            <a href="editProfile" class="btn btn-primary">✏️ Edit Profile</a>
            <a href="userBookings" class="btn btn-outline">🎫 My Bookings</a>
            <a href="search_flights.jsp" class="btn btn-outline">🔍 Search Flights</a>
            <a href="logout" class="btn btn-secondary">🚪 Logout</a>
        </div>

    </div>
</div>
</div>

<footer>© 2026 SkyConnect Airline Reservation System | JSP • Servlets • MySQL</footer>

</body>
</html>