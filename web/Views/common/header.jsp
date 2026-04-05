<%@ page contentType="text/html;charset=UTF-8" %>

<div class="navbar">
    <div class="brand">✈ SkyConnect • Admin</div>

    <div>
        <span style="color:#fff; margin-right:15px;">
            Welcome, <%= session.getAttribute("userName") %>
        </span>
        <div><a href="${pageContext.request.contextPath}/adminDashboard">Back</a></div>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>
