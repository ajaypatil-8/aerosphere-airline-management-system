<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    List<Map<String, Object>> refunds = (List<Map<String, Object>>) request.getAttribute("refunds");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Refunds – SkyConnect</title>
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

        .container { max-width: 1000px; margin: 40px auto; padding: 0 16px; }

        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px;
        }
        .page-header h1 { font-size: 22px; font-weight: 700; color: #1a56db; }
        .page-header p { font-size: 13px; color: #6b7280; margin-top: 2px; }

        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .section-title {
            font-size: 13px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.7px; color: #1a56db;
            border-bottom: 2px solid #eef4ff; padding-bottom: 8px;
            padding: 24px 28px 12px 28px;
        }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: linear-gradient(90deg, #1a56db, #0ea5e9); }
        thead th {
            color: #fff; text-align: left;
            padding: 14px 16px; font-size: 13px; font-weight: 600;
            letter-spacing: 0.4px;
        }
        tbody tr:hover { background: #f8faff; }
        td { padding: 14px 16px; border-bottom: 1px solid #f0f4ff; font-size: 14px; vertical-align: middle; }

        .badge {
            display: inline-block; padding: 4px 12px;
            border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .badge-pending   { background: #fef9c3; color: #854d0e; }
        .badge-approved  { background: #d1fae5; color: #065f46; }
        .badge-refunded  { background: #dbeafe; color: #1e40af; }
        .badge-rejected  { background: #fee2e2; color: #991b1b; }

        .amount-col { font-weight: 700; color: #1a56db; }

        .btn-view {
            padding: 7px 16px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border: none; border-radius: 8px;
            font-size: 12px; font-weight: 700; cursor: pointer;
            text-decoration: none; display: inline-block;
        }
        .btn-view:hover { opacity: 0.88; }

        .empty-state {
            text-align: center; padding: 64px 24px;
        }
        .empty-state .icon { font-size: 52px; margin-bottom: 16px; }
        .empty-state h3 { font-size: 18px; font-weight: 700; color: #374151; margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: #9ca3af; margin-bottom: 24px; }
        .btn-primary {
            display: inline-block; padding: 11px 28px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff; border-radius: 10px; font-weight: 700;
            font-size: 14px; text-decoration: none;
        }
        .btn-primary:hover { opacity: 0.9; }

        .summary-bar {
            display: flex; gap: 16px; margin-bottom: 24px; flex-wrap: wrap;
        }
        .summary-chip {
            background: #fff; border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 14px 22px; flex: 1; min-width: 160px;
        }
        .summary-chip .chip-label { font-size: 12px; color: #6b7280; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .summary-chip .chip-value { font-size: 22px; font-weight: 700; color: #1a56db; margin-top: 4px; }

        .route-cell { font-weight: 600; color: #374151; }
        .route-arrow { color: #0ea5e9; margin: 0 6px; }
        .date-cell { color: #6b7280; font-size: 13px; }
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

    <div class="page-header">
        <div>
            <h1>💸 My Refund History</h1>
            <p>Track the status of all your refund requests</p>
        </div>
        <a href="userBookings" class="btn-primary">← Back to Bookings</a>
    </div>

    <%
        int totalRefunds = 0;
        int pendingCount = 0;
        int approvedCount = 0;
        double totalAmount = 0.0;
        if (refunds != null) {
            totalRefunds = refunds.size();
            for (Map<String, Object> r : refunds) {
                String st = r.get("status") != null ? r.get("status").toString().toLowerCase() : "";
                if (st.equals("pending")) pendingCount++;
                if (st.equals("approved") || st.equals("refunded")) approvedCount++;
                Object amt = r.get("refund_amount");
                if (amt != null) {
                    try { totalAmount += Double.parseDouble(amt.toString()); } catch (Exception ex) {}
                }
            }
        }
    %>

    <div class="summary-bar">
        <div class="summary-chip">
            <div class="chip-label">Total Requests</div>
            <div class="chip-value"><%= totalRefunds %></div>
        </div>
        <div class="summary-chip">
            <div class="chip-label">Pending</div>
            <div class="chip-value" style="color:#854d0e;"><%= pendingCount %></div>
        </div>
        <div class="summary-chip">
            <div class="chip-label">Approved</div>
            <div class="chip-value" style="color:#065f46;"><%= approvedCount %></div>
        </div>
        <div class="summary-chip">
            <div class="chip-label">Total Refunded</div>
            <div class="chip-value">₹<%= String.format("%,.2f", totalAmount) %></div>
        </div>
    </div>

    <div class="card">
        <% if (refunds == null || refunds.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">🔍</div>
                <h3>No Refund Requests Found</h3>
                <p>You haven't made any refund requests yet.<br>Cancelled bookings may be eligible for a refund.</p>
                <a href="userBookings" class="btn-primary">View My Bookings</a>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Refund ID</th>
                        <th>Booking ID</th>
                        <th>Route</th>
                        <th>Flight Date</th>
                        <th>Refund Amount</th>
                        <th>Requested On</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% int sno = 1; for (Map<String, Object> r : refunds) {
                        String status = r.get("status") != null ? r.get("status").toString() : "pending";
                        String badgeClass = "badge-pending";
                        if (status.equalsIgnoreCase("approved")) badgeClass = "badge-approved";
                        else if (status.equalsIgnoreCase("refunded")) badgeClass = "badge-refunded";
                        else if (status.equalsIgnoreCase("rejected")) badgeClass = "badge-rejected";
                    %>
                    <tr>
                        <td><%= sno++ %></td>
                        <td><strong>#<%= r.get("refund_id") %></strong></td>
                        <td>#<%= r.get("booking_id") %></td>
                        <td class="route-cell">
                            <%= r.get("source") %>
                            <span class="route-arrow">→</span>
                            <%= r.get("destination") %>
                        </td>
                        <td class="date-cell"><%= r.get("flight_date") %></td>
                        <td class="amount-col">₹<%= String.format("%,.2f", Double.parseDouble(r.get("refund_amount") != null ? r.get("refund_amount").toString() : "0")) %></td>
                        <td class="date-cell"><%= r.get("requested_at") %></td>
                        <td><span class="badge <%= badgeClass %>"><%= status.substring(0,1).toUpperCase() + status.substring(1) %></span></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/refundReceipt?refundId=<%= r.get("refund_id") %>" class="btn-view">View Receipt</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

</div>
</body>
</html>