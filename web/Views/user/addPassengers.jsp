<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    Integer seats     = (Integer) request.getAttribute("seats");
    if (seats == null) seats = 1;
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Passenger Details – AeroSphere</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--primary:#10B981;--primary-dark:#059669;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#FFFFFF;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;--shadow:0 2px 12px rgba(0,0,0,.06);--shadow-lg:0 12px 40px rgba(0,0,0,.1);--radius:14px}
[data-theme="dark"]{--primary:#10B981;--primary-dark:#34D399;--primary-glow:rgba(16,185,129,.22);--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;--shadow:0 2px 12px rgba(0,0,0,.4);--shadow-lg:0 12px 40px rgba(0,0,0,.5)}
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
.page-wrapper{max-width:820px;margin:0 auto;padding:32px 24px}
/* STEPS */
.steps{display:flex;align-items:center;margin-bottom:28px;animation:fadeUp .5s ease both}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
.step{display:flex;flex-direction:column;align-items:center;gap:5px}
.step-circle{width:34px;height:34px;border-radius:50%;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:.78rem;font-weight:700;color:var(--text-muted);background:var(--card-bg);transition:all .3s}
.step.done .step-circle{background:var(--primary);border-color:var(--primary);color:#fff}
.step.active .step-circle{border-color:var(--primary);color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.step-label{font-size:.7rem;font-weight:600;color:var(--text-muted);white-space:nowrap}
.step.done .step-label,.step.active .step-label{color:var(--primary)}
.step-line{flex:1;height:2px;background:var(--border);margin:0 6px;margin-bottom:18px;transition:background .3s}
.step-line.done{background:var(--primary)}
/* PAGE HEADER */
.page-header{margin-bottom:24px;animation:fadeUp .5s ease both .05s}
.page-title{font-size:1.5rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--text-muted);font-size:.9rem}
/* PASSENGER CARD */
.pax-card{background:var(--card-bg);border:1px solid var(--border);border-radius:var(--radius);padding:24px;margin-bottom:20px;position:relative;box-shadow:var(--shadow);transition:border-color .2s;animation:fadeUp .5s ease both}
.pax-card:hover{border-color:var(--primary)}
.pax-badge{position:absolute;top:-12px;left:20px;background:var(--primary);color:#fff;font-size:.76rem;font-weight:700;padding:4px 14px;border-radius:99px;letter-spacing:.3px}
.pax-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;margin-top:10px}
.pax-grid .full{grid-column:1/-1}
/* FORM GROUP */
.form-group{display:flex;flex-direction:column;gap:6px}
.form-group label{font-size:.74rem;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted)}
.field-wrap{position:relative}
.fi{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:13px;pointer-events:none}
.field-wrap input,.field-wrap select{width:100%;background:var(--bg);border:1.5px solid var(--border);border-radius:9px;padding:10px 12px 10px 36px;color:var(--text);font-family:'Inter',sans-serif;font-size:.87rem;outline:none;transition:all .2s;appearance:none}
.field-wrap input:focus,.field-wrap select:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.field-wrap input::placeholder{color:var(--text-muted);opacity:.6}
.field-wrap.no-icon input,.field-wrap.no-icon select{padding-left:12px}
input[type="date"]::-webkit-calendar-picker-indicator{cursor:pointer;opacity:.6}
[data-theme="dark"] input[type="date"]::-webkit-calendar-picker-indicator{filter:invert(1)}
/* FOOTER */
.form-footer{display:flex;align-items:center;justify-content:flex-end;gap:12px;margin-top:8px;animation:fadeUp .5s ease both .1s}
.btn{display:inline-flex;align-items:center;gap:6px;padding:11px 20px;border-radius:10px;font-size:.88rem;font-weight:600;text-decoration:none;border:none;cursor:pointer;transition:all .2s}
.btn-primary{background:var(--primary);color:#fff;box-shadow:0 3px 12px var(--primary-glow)}.btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn-secondary{background:var(--card-bg);color:var(--text);border:1px solid var(--border)}.btn-secondary:hover{border-color:var(--primary);color:var(--primary)}
.btn-lg{padding:13px 26px;font-size:.92rem}
</style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div><span class="brand-name">Aero<span>Sphere</span></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard" class="nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/userBookings"  class="nav-link">My Bookings</a>
        <a href="${pageContext.request.contextPath}/logout"        class="nav-link btn-danger">Logout</a>
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggle">🌙</button>
    </div>
</nav>

<div class="page-wrapper">
    <!-- STEPS -->
    <div class="steps">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
        <div class="step-line done"></div>
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Confirm</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">3</div><div class="step-label">Passengers</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
    </div>

    <div class="page-header">
        <div class="page-title">👥 Passenger Details</div>
        <div class="page-subtitle">Fill details for all <%= seats %> passenger(s) — Booking #<%= bookingId %></div>
    </div>

    <form action="${pageContext.request.contextPath}/savePassengers" method="post">
        <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <% for (int i = 1; i <= seats; i++) { %>
        <div class="pax-card" style="animation-delay:<%= i*0.07 %>s">
            <div class="pax-badge">Passenger <%= i %></div>
            <div class="pax-grid">
                <div class="form-group full">
                    <label>Full Name *</label>
                    <div class="field-wrap"><span class="fi">👤</span><input type="text" name="full_name[]" placeholder="As on ID/Passport" required></div>
                </div>
                <div class="form-group">
                    <label>Age *</label>
                    <div class="field-wrap"><span class="fi">🔢</span><input type="number" name="age[]" placeholder="e.g. 25" min="1" max="120" required></div>
                </div>
                <div class="form-group">
                    <label>Gender *</label>
                    <div class="field-wrap no-icon">
                        <select name="gender[]" required>
                            <option value="">Select</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Date of Birth</label>
                    <div class="field-wrap"><span class="fi">📅</span><input type="date" name="dob[]"></div>
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <div class="field-wrap"><span class="fi">📱</span><input type="tel" name="phone[]" placeholder="+91 XXXXXXXXXX"></div>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <div class="field-wrap"><span class="fi">✉</span><input type="email" name="email[]" placeholder="passenger@email.com"></div>
                </div>
            </div>
        </div>
        <% } %>

        <div class="form-footer">
            <a href="${pageContext.request.contextPath}/userBookings" class="btn btn-secondary">← Cancel</a>
            <button type="submit" class="btn btn-primary btn-lg">Continue to Payment →</button>
        </div>
    </form>
</div>

<script>
const t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');
document.documentElement.setAttribute('data-theme',t);
document.getElementById('themeToggle').textContent=t==='dark'?'☀️':'🌙';
function toggleTheme(){const n=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',n);localStorage.setItem('aerosphere-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀️':'🌙';}
</script>
</body></html>
