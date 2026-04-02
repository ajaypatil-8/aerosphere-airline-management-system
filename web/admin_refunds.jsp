<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Refund Requests</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container py-4">

<h3 class="mb-3">💸 Refund Requests</h3>

<table class="table table-bordered table-hover">
<thead class="table-dark">
<tr>
<th>ID</th>
<th>User</th>
<th>Flight</th>
<th>Amount</th>
<th>Status</th>
<th>Reason</th>
<th>Action</th>
</tr>
</thead>

<tbody>
<%
List<Map<String,Object>> refunds =
    (List<Map<String,Object>>) request.getAttribute("refunds");

for (Map<String,Object> r : refunds) {
%>
<tr>
<td><%= r.get("id") %></td>
<td><%= r.get("user") %></td>
<td><%= r.get("flight") %></td>
<td>₹ <%= r.get("amount") %></td>

<td>
<% if ("PENDING".equals(r.get("status"))) { %>
<span class="badge bg-warning text-dark">PENDING</span>
<% } else if ("APPROVED".equals(r.get("status"))) { %>
<span class="badge bg-success">APPROVED</span>
<% } else { %>
<span class="badge bg-danger">REJECTED</span>
<% } %>
</td>

<td><%= r.get("reason") %></td>

<td>
<% if ("PENDING".equals(r.get("status"))) { %>
<form action="approveRefund" method="post" class="d-inline">
<input type="hidden" name="refundId" value="<%= r.get("id") %>">
<button name="action" value="APPROVE" class="btn btn-sm btn-success">Approve</button>
<button name="action" value="REJECT" class="btn btn-sm btn-danger">Reject</button>
</form>
<% } else { %>
—
<% } %>
</td>
</tr>
<% } %>
</tbody>
</table>

</div>
</body>
</html>