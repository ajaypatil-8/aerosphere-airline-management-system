<%
    String userName  = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String curName    = (String) request.getAttribute("curName");
    String curEmail   = (String) request.getAttribute("curEmail");
    String curPhone   = (String) request.getAttribute("curPhone");
    String curDob     = (String) request.getAttribute("curDob");
    String curGender  = (String) request.getAttribute("curGender");
    String curAddress = (String) request.getAttribute("curAddress");
    String error      = (String) request.getAttribute("error");
    String userRole   = (String) session.getAttribute("userRole");
    boolean isAdmin   = "ADMIN".equals(userRole);
    if (curName == null) curName = "";
    if (curEmail == null) curEmail = "";
    if (curPhone == null) curPhone = "";
    if (curDob == null) curDob = "";
    if (curGender == null) curGender = "";
    if (curAddress == null) curAddress = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile ? SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .save-bar {
            position: sticky; bottom: 0;
            background: rgba(8,12,26,.9);
            backdrop-filter: blur(16px);
            border-top: 1px solid var(--border);
            padding: 14px 0; margin-top: 28px;
            display: flex; gap: 12px; justify-content: flex-end;
        }
        .pwd-toggle { position: absolute; right: 14px; cursor: pointer; color: var(--muted); user-select: none; }
    </style>
</head>
<body>
<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="<%= isAdmin ? "adminDashboard" : "userDashboard" %>" class="nav-brand">
        <div class="brand-icon">?</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <% if (!isAdmin) { %>
            <a href="userDashboard" class="nav-link">Dashboard</a>
            <a href="userBookings" class="nav-link">My Bookings</a>
        <% } %>
        <a href="profile" class="nav-link active">Profile</a>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper narrow">

    <div class="page-header">
        <div>
            <h1 class="page-title">? Edit Profile</h1>
            <p class="page-subtitle">Update your personal information</p>
        </div>
        <a href="profile" class="btn btn-ghost">? Back to Profile</a>
    </div>

    <% if (error != null) { %>
        <div class="alert alert-error">? <%= error %></div>
    <% } %>

    <form action="editProfile" method="post">
        <div class="card-glow" style="padding:28px;">

            <div class="section-label">Personal Details</div>

            <div class="form-grid">
                <div class="field">
                    <label>Full Name *</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <input type="text" name="name" value="<%= curName %>" placeholder="Your full name" required>
                    </div>
                </div>
                <div class="field">
                    <label>Email Address *</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <input type="email" name="email" value="<%= curEmail %>" placeholder="you@email.com" required>
                    </div>
                </div>
                <div class="field">
                    <label>Phone Number</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <input type="text" name="phone" value="<%= curPhone %>" placeholder="+91 99999 99999" maxlength="15">
                    </div>
                </div>
                <div class="field">
                    <label>Date of Birth</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <input type="date" name="dob" value="<%= curDob %>">
                    </div>
                </div>
                <div class="field">
                    <label>Gender</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <select name="gender">
                            <option value="">? Select ?</option>
                            <option value="MALE"   <%= "MALE".equals(curGender)   ? "selected" : "" %>>Male</option>
                            <option value="FEMALE" <%= "FEMALE".equals(curGender) ? "selected" : "" %>>Female</option>
                            <option value="OTHER"  <%= "OTHER".equals(curGender)  ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>
                <div class="field full">
                    <label>Address</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <textarea name="address" placeholder="Your full address"><%= curAddress %></textarea>
                    </div>
                </div>
            </div>

            <hr class="divider">
            <div class="section-label">Change Password <span style="font-weight:400;text-transform:none;letter-spacing:0;color:var(--muted)">(optional ? leave blank to keep current)</span></div>

            <div class="form-grid">
                <div class="field full">
                    <label>New Password</label>
                    <div class="field-wrap">
                        <span class="field-icon">?</span>
                        <input type="password" name="password" id="pwdInput" placeholder="Leave blank to keep current password">
                        <span class="pwd-toggle" onclick="togglePwd()">?</span>
                    </div>
                </div>
            </div>

        </div>

        <div class="save-bar">
            <a href="profile" class="btn btn-ghost">? Cancel</a>
            <button type="submit" class="btn btn-blue" style="min-width:160px;">? Save Changes</button>
        </div>
    </form>

</div>

<script>
function togglePwd() {
    const inp = document.getElementById('pwdInput');
    inp.type = inp.type === 'password' ? 'text' : 'password';
}
const s = document.getElementById('stars');
for (let i = 0; i < 60; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
document.querySelectorAll('.field-wrap input, .field-wrap select, .field-wrap textarea').forEach(el => {
    el.addEventListener('focus', () => { const ic = el.parentElement.querySelector('.field-icon'); if (ic) ic.style.color = '#4D8AFF'; });
    el.addEventListener('blur',  () => { const ic = el.parentElement.querySelector('.field-icon'); if (ic) ic.style.color = 'rgba(255,255,255,.2)'; });
});
</script>
</body>
</html>
