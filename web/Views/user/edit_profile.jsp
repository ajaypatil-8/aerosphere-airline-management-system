<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
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
    String csrfToken  = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Edit Profile – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px;--input-bg:#F9FAFB}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5);--input-bg:#1A1A1A}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s;min-height:100vh}
.navbar{position:sticky;top:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:12px 32px;background:var(--card-bg);border-bottom:1px solid var(--border);box-shadow:var(--shadow)}
.nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
.brand-icon{width:34px;height:34px;background:var(--primary);border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:0 3px 10px var(--primary-glow)}
.brand-name{font-weight:800;font-size:1.1rem;letter-spacing:-.5px}.brand-name span{color:var(--primary)}
.nav-links{display:flex;align-items:center;gap:4px}
.nav-link{text-decoration:none;color:var(--text-muted);padding:7px 13px;border-radius:8px;font-size:.86rem;font-weight:500;transition:all .2s}
.nav-link:hover{color:var(--text);background:var(--border)}.nav-link.btn-danger{color:#DC2626;background:rgba(220,38,38,.08)}.nav-link.btn-danger:hover{background:rgba(220,38,38,.15)}
.theme-toggle{width:32px;height:32px;border:1px solid var(--border);border-radius:8px;background:var(--card-bg);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:14px;transition:all .2s;margin-left:4px}
/* PAGE */
.page-wrapper{max-width:700px;margin:0 auto;padding:32px 24px}
.page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* ALERT */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert{color:#FCA5A5}
/* CARD */
.card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);animation:fadeUp .5s ease both .05s;position:relative}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--primary),#34D399,var(--primary))}
.card-inner{padding:28px}
/* FORM GRID */
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.full{grid-column:1/-1}
/* FORM GROUP */
.form-group{display:flex;flex-direction:column;gap:7px}
.form-group label{font-size:.75rem;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted)}
.form-group label .hint{font-size:.7rem;color:var(--text-muted);text-transform:none;letter-spacing:0;font-weight:400;opacity:.7}
.field-wrap{position:relative}
.fi{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:13px;pointer-events:none}
.fi.top{top:18px;transform:none}
.field-wrap input,.field-wrap select,.field-wrap textarea{width:100%;background:var(--input-bg);border:1.5px solid var(--border);border-radius:10px;padding:11px 13px 11px 38px;color:var(--text);font-family:'Inter',sans-serif;font-size:.9rem;outline:none;transition:all .2s;appearance:none}
.field-wrap textarea{height:80px;resize:none;padding:12px 13px 12px 38px}
.field-wrap input:focus,.field-wrap select:focus,.field-wrap textarea:focus{border-color:var(--primary);background:var(--card-bg);box-shadow:0 0 0 3px var(--primary-glow)}
.field-wrap input::placeholder,.field-wrap textarea::placeholder{color:var(--text-muted);opacity:.6}
input[type="date"]::-webkit-calendar-picker-indicator{cursor:pointer;opacity:.6}
[data-theme="dark"] input[type="date"]::-webkit-calendar-picker-indicator{filter:invert(1)}
hr.divider{border:none;border-top:1px solid var(--border);margin:22px 0}
/* FOOTER */
.form-actions{display:flex;gap:12px;justify-content:flex-end;animation:fadeUp .5s ease both .1s}
.btn{display:inline-flex;align-items:center;gap:6px;padding:10px 20px;border-radius:10px;font-size:.88rem;font-weight:600;text-decoration:none;border:1px solid var(--border);cursor:pointer;transition:all .2s;background:var(--card-bg);color:var(--text)}
.btn:hover{border-color:var(--primary);color:var(--primary)}
.btn-primary{background:var(--primary);color:#fff;border-color:var(--primary);box-shadow:0 3px 10px var(--primary-glow)}.btn-primary:hover{background:var(--primary-dark);color:#fff}
@media(max-width:580px){.form-grid{grid-template-columns:1fr}.full{grid-column:1}}
</style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/profile" class="nav-link">← Profile</a>
        <a href="${pageContext.request.contextPath}/logout"  class="nav-link btn-danger">Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div><div class="page-title">✏️ Edit Profile</div><div class="page-subtitle">Update your account details</div></div>
        <a href="${pageContext.request.contextPath}/profile" class="btn">← Cancel</a>
    </div>

    <% if (error != null) { %><div class="alert">⚠ <%= error %></div><% } %>

    <div class="card">
        <div class="card-inner">
            <form action="${pageContext.request.contextPath}/editProfile" method="post">
                <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name *</label>
                        <div class="field-wrap"><span class="fi">👤</span><input type="text" name="name" value="<%= HtmlUtils.e(curName != null ? curName : "") %>" required></div>
                    </div>
                    <div class="form-group">
                        <label>Email *</label>
                        <div class="field-wrap"><span class="fi">✉</span><input type="email" name="email" value="<%= HtmlUtils.e(curEmail != null ? curEmail : "") %>" required></div>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <div class="field-wrap"><span class="fi">📱</span><input type="tel" name="phone" value="<%= HtmlUtils.e(curPhone != null ? curPhone : "") %>" placeholder="+91 XXXXXXXXXX"></div>
                    </div>
                    <div class="form-group">
                        <label>Date of Birth</label>
                        <div class="field-wrap"><span class="fi">🎂</span><input type="date" name="dob" value="<%= HtmlUtils.e(curDob != null ? curDob : "") %>"></div>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <div class="field-wrap">
                            <span class="fi">⚧</span>
                            <select name="gender">
                                <option value="">Select</option>
                                <option value="MALE"   <%= "MALE".equals(curGender)   ? "selected" : "" %>>Male</option>
                                <option value="FEMALE" <%= "FEMALE".equals(curGender) ? "selected" : "" %>>Female</option>
                                <option value="OTHER"  <%= "OTHER".equals(curGender)  ? "selected" : "" %>>Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>New Password <span class="hint">(leave blank to keep)</span></label>
                        <div class="field-wrap"><span class="fi">🔑</span><input type="password" name="password" placeholder="Enter new password"></div>
                    </div>
                    <div class="form-group full">
                        <label>Address</label>
                        <div class="field-wrap"><span class="fi top">📍</span><textarea name="address" placeholder="Your full address"><%= HtmlUtils.e(curAddress != null ? curAddress : "") %></textarea></div>
                    </div>
                </div>
                <hr class="divider">
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/profile" class="btn">Cancel</a>
                    <button type="submit" class="btn btn-primary">✅ Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
</script>
</body></html>
