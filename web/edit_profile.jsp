<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }
    String userEmail   = (String) session.getAttribute("userEmail");
    String userPhone   = (String) session.getAttribute("userPhone");
    String userId      = String.valueOf(session.getAttribute("userId"));
    String editError   = (String) session.getAttribute("editError");
    String editSuccess = (String) session.getAttribute("editSuccess");
    session.removeAttribute("editError");
    session.removeAttribute("editSuccess");
    String initials = userName.length() > 0 ? String.valueOf(userName.charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="index.jsp" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="profile" class="nav-link">Profile</a>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper narrow" style="max-width:580px;">

    <div class="page-header">
        <div>
            <h1 class="page-title">✏ Edit Profile</h1>
            <p class="page-subtitle">Update your account details</p>
        </div>
    </div>

    <% if (editError != null) { %>
        <div class="alert alert-error">⚠ <%= editError %></div>
    <% } %>
    <% if (editSuccess != null) { %>
        <div class="alert alert-success">✓ <%= editSuccess %></div>
    <% } %>

    <div class="card card-top-line">
        <div class="card-pad">

            <!-- AVATAR ROW -->
            <div style="display:flex;align-items:center;gap:16px;margin-bottom:28px;padding-bottom:24px;border-bottom:1px solid var(--border-2);">
                <div class="avatar-ring"><%= initials %></div>
                <div>
                    <div style="font-weight:600;"><%= userName %></div>
                    <div style="color:var(--muted);font-size:.85rem;margin-top:2px;"><%= userEmail != null ? userEmail : "" %></div>
                </div>
            </div>

            <form action="editProfile" method="post">
                <div class="section-label" style="margin-bottom:16px;">Account Details</div>

                <div class="form-grid">
                    <div class="field full">
                        <label>Full Name</label>
                        <div class="field-wrap">
                            <span class="field-icon">👤</span>
                            <input type="text" name="name" value="<%= userName %>" required placeholder="Your full name">
                        </div>
                    </div>

                    <div class="field full">
                        <label>Email Address</label>
                        <div class="field-wrap">
                            <span class="field-icon">✉</span>
                            <input type="email" name="email" value="<%= userEmail != null ? userEmail : "" %>" required placeholder="your@email.com">
                        </div>
                    </div>

                    <div class="field full">
                        <label>Phone Number</label>
                        <div class="field-wrap">
                            <span class="field-icon">📱</span>
                            <input type="text" name="phone" value="<%= userPhone != null ? userPhone : "" %>" placeholder="10-digit mobile number" maxlength="10">
                        </div>
                    </div>
                </div>

                <div class="divider-label" style="margin:24px 0;">
                    <span>Change Password (optional)</span>
                </div>

                <div class="form-grid">
                    <div class="field full">
                        <label>Current Password</label>
                        <div class="field-wrap">
                            <span class="field-icon">🔒</span>
                            <input type="password" name="currentPassword" id="curPw" placeholder="Enter current password">
                            <button type="button" onclick="togglePw('curPw')" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);cursor:pointer;font-size:15px;">👁</button>
                        </div>
                    </div>

                    <div class="field full">
                        <label>New Password</label>
                        <div class="field-wrap">
                            <span class="field-icon">🔑</span>
                            <input type="password" name="newPassword" id="newPw" placeholder="Enter new password">
                            <button type="button" onclick="togglePw('newPw')" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);cursor:pointer;font-size:15px;">👁</button>
                        </div>
                    </div>
                </div>

                <div style="display:flex;gap:12px;margin-top:24px;">
                    <button type="submit" class="btn btn-blue" style="flex:1;justify-content:center;padding:13px;">
                        💾 Save Changes
                    </button>
                    <a href="profile" class="btn btn-ghost" style="padding:13px 20px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</div>

<script>
function togglePw(id) {
    const inp = document.getElementById(id);
    inp.type = inp.type === 'password' ? 'text' : 'password';
}
document.querySelectorAll('.field-wrap input').forEach(el => {
    el.addEventListener('focus', function() {
        const ic = this.parentElement.querySelector('.field-icon');
        if (ic) ic.style.color = '#4D8AFF';
    });
    el.addEventListener('blur', function() {
        const ic = this.parentElement.querySelector('.field-icon');
        if (ic) ic.style.color = 'rgba(255,255,255,.2)';
    });
});
const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
</script>
</body>
</html>
