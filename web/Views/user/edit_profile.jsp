<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String curName    = (String) request.getAttribute("curName");
    String curEmail   = (String) request.getAttribute("curEmail");
    String curPhone   = (String) request.getAttribute("curPhone");
    String curDob     = (String) request.getAttribute("curDob");
    String curGender  = (String) request.getAttribute("curGender");
    String curAddress = (String) request.getAttribute("curAddress");
    String error      = (String) request.getAttribute("error");
%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Edit Profile – SkyConnect</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/dashboard.css">
</head><body>
<div class="page-bg"></div><div class="stars-layer" id="stars"></div>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand"><div class="brand-icon">✈</div><span class="brand-name">Sky<span>Connect</span></span></a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/profile" class="nav-link">← Profile</a>
    <a href="${pageContext.request.contextPath}/logout"  class="nav-link btn-danger">Logout</a>
  </div>
</nav>
<div class="page-wrapper medium">
  <div class="page-header animate-fadeup">
    <div><h1 class="page-title">✏️ Edit Profile</h1><p class="page-subtitle">Update your account details</p></div>
    <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">← Cancel</a>
  </div>
  <% if (error != null) { %><div class="alert alert-error">⚠ <%= error %></div><% } %>
  <div class="card animate-fadeup">
    <form action="${pageContext.request.contextPath}/editProfile" method="post">
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
        <div class="form-group">
          <label>Full Name *</label>
          <div class="field-wrap"><span class="fi">👤</span><input type="text" name="name" value="<%= curName != null ? curName : "" %>" required></div>
        </div>
        <div class="form-group">
          <label>Email *</label>
          <div class="field-wrap"><span class="fi">✉️</span><input type="email" name="email" value="<%= curEmail != null ? curEmail : "" %>" required></div>
        </div>
        <div class="form-group">
          <label>Phone</label>
          <div class="field-wrap"><span class="fi">📱</span><input type="tel" name="phone" value="<%= curPhone != null ? curPhone : "" %>" placeholder="+91 XXXXXXXXXX"></div>
        </div>
        <div class="form-group">
          <label>Date of Birth</label>
          <div class="field-wrap"><span class="fi">🎂</span><input type="date" name="dob" value="<%= curDob != null ? curDob : "" %>"></div>
        </div>
        <div class="form-group">
          <label>Gender</label>
          <div class="field-wrap no-icon"><select name="gender">
            <option value="">Select</option>
            <option value="MALE"   <%= "MALE".equals(curGender)   ? "selected" : "" %>>Male</option>
            <option value="FEMALE" <%= "FEMALE".equals(curGender) ? "selected" : "" %>>Female</option>
            <option value="OTHER"  <%= "OTHER".equals(curGender)  ? "selected" : "" %>>Other</option>
          </select></div>
        </div>
        <div class="form-group">
          <label>New Password <span style="font-size:.72rem;color:var(--muted)">(leave blank to keep)</span></label>
          <div class="field-wrap"><span class="fi">🔑</span><input type="password" name="password" placeholder="Enter new password"></div>
        </div>
        <div class="form-group" style="grid-column:1/-1;">
          <label>Address</label>
          <div class="field-wrap"><span class="fi">📍</span><textarea name="address" placeholder="Your full address"><%= curAddress != null ? curAddress : "" %></textarea></div>
        </div>
      </div>
      <hr class="divider">
      <div style="display:flex;gap:12px;justify-content:flex-end;">
        <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary">✅ Save Changes</button>
      </div>
    </form>
  </div>
</div>
<script>
const s=document.getElementById('stars');
for(let i=0;i<60;i++){const e=document.createElement('div');e.className='star';const z=Math.random()*2+.5;e.style.cssText=`width:${z}px;height:${z}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;s.appendChild(e);}
</script>
</body></html>
