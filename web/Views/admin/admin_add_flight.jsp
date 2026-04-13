<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String csrfToken     = CsrfUtil.getToken(request);
    String flightError   = (String) session.getAttribute("flightError");
    String flightSuccess = (String) session.getAttribute("flightSuccess");
    session.removeAttribute("flightError");
    session.removeAttribute("flightSuccess");
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Add Flight – AeroSphere Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
/* ── Design Tokens ─────────────────────────────────────── */
:root{
  --sky:#0EA5E9;--sky-dark:#0284C7;--sky-glow:rgba(14,165,233,.18);
  --em:#10B981;--em-dark:#059669;--em-glow:rgba(16,185,129,.18);
  --grad:linear-gradient(135deg,var(--sky),var(--em));
  --bg:#F0F9FF;--s0:#FFFFFF;--s1:#F8FAFC;--s2:#F0F9FF;
  --text:#0F172A;--muted:#64748B;--border:#E2E8F0;
  --sh:0 1px 3px rgba(0,0,0,.06),0 4px 16px rgba(0,0,0,.04);
  --sh-lg:0 8px 32px rgba(0,0,0,.08);--r:14px;
  --sidebar-w:240px;
}
[data-theme="dark"]{
  --bg:#060A12;--s0:#0D1117;--s1:#111827;--s2:#1A2232;
  --text:#F1F5F9;--muted:#94A3B8;--border:#1E293B;
  --sh:0 1px 3px rgba(0,0,0,.4),0 4px 16px rgba(0,0,0,.3);
  --sh-lg:0 8px 32px rgba(0,0,0,.5);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;flex-direction:column}

/* ── Admin Layout ──────────────────────────────────────── */
.as-layout{display:flex;min-height:100vh}

/* ── Sidebar ───────────────────────────────────────────── */
.as-sidebar.collapsed{transform:translateX(-100%)}
.sb-brand{display:flex;align-items:center;gap:10px;padding:22px 20px 18px;border-bottom:1px solid var(--border);text-decoration:none;color:var(--text)}
.sb-brand-icon{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;box-shadow:0 3px 10px var(--sky-glow)}
.sb-brand-name{font-family:'Syne',sans-serif;font-weight:800;font-size:1.05rem;letter-spacing:-.4px;line-height:1.1}
.sb-brand-name span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.sb-admin-tag{font-size:.6rem;background:rgba(245,158,11,.15);color:#D97706;border:1px solid rgba(245,158,11,.3);padding:2px 6px;border-radius:4px;font-weight:700;letter-spacing:.05em;display:block;margin-top:2px}
.sb-section-label{font-size:.64rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--muted);padding:16px 20px 6px}
.sb-nav{display:flex;flex-direction:column;gap:2px;padding:0 12px}
.sb-link{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:9px;text-decoration:none;color:var(--muted);font-size:.86rem;font-weight:500;transition:all .18s;position:relative}
.sb-link .sb-icon{font-size:1rem;width:22px;text-align:center;flex-shrink:0}
.sb-link:hover{color:var(--text);background:var(--s2)}
.sb-link.active{color:var(--sky);background:var(--sky-glow);font-weight:600}
.sb-link.active::before{content:'';position:absolute;left:0;top:20%;bottom:20%;width:3px;background:var(--sky);border-radius:0 2px 2px 0}
.sb-link .badge-pill{margin-left:auto;background:rgba(239,68,68,.15);color:#EF4444;font-size:.64rem;font-weight:700;padding:2px 6px;border-radius:99px}
.sb-divider{border:none;border-top:1px solid var(--border);margin:10px 12px}
.sb-footer{padding:16px 20px;border-top:1px solid var(--border);margin-top:auto}
.sb-user{display:flex;align-items:center;gap:10px}
.sb-avatar{width:32px;height:32px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:.8rem;font-weight:700;color:#fff;flex-shrink:0}
.sb-user-name{font-size:.82rem;font-weight:600;line-height:1.2}
.sb-user-role{font-size:.7rem;color:var(--muted)}

/* ── Main ──────────────────────────────────────────────── */
/* ── Topbar ────────────────────────────────────────────── */
.as-topbar{position:sticky;top:0;z-index:100;background:rgba(var(--s0-rgb,255,255,255),.85);
  backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
  border-bottom:1px solid var(--border);padding:12px 28px;
  display:flex;align-items:center;gap:12px}
[data-theme="dark"] .as-topbar{background:rgba(13,17,23,.85)}
.sb-toggle{width:34px;height:34px;border:1px solid var(--border);border-radius:8px;background:var(--s0);
  cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1rem;
  transition:all .2s;color:var(--muted);flex-shrink:0}
.sb-toggle:hover{border-color:var(--sky);color:var(--sky)}
.topbar-title{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem;color:var(--text)}
.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.theme-toggle{width:34px;height:34px;border:1px solid var(--border);border-radius:8px;background:var(--s0);
  cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;transition:all .2s;color:var(--muted)}
.theme-toggle:hover{border-color:var(--sky);color:var(--sky)}
.topbar-logout{text-decoration:none;font-size:.82rem;font-weight:600;color:#EF4444;background:rgba(239,68,68,.08);
  padding:6px 14px;border-radius:8px;transition:all .2s}
.topbar-logout:hover{background:rgba(239,68,68,.15)}

/* ── Page content ──────────────────────────────────────── */
.page-content{max-width:760px;margin:0 auto;padding:32px 28px;width:100%}

/* ── Page header ───────────────────────────────────────── */
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;gap:12px;flex-wrap:wrap}
.page-title{font-family:'Syne',sans-serif;font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--muted);font-size:.9rem}

/* ── Alerts ────────────────────────────────────────────── */
.alert{padding:12px 16px;border-radius:11px;margin-bottom:20px;font-size:.86rem;font-weight:500;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#DC2626}
[data-theme="dark"] .alert-error{color:#FCA5A5}
.alert-success{background:var(--em-glow);border:1px solid var(--em);color:var(--em-dark)}
[data-theme="dark"] .alert-success{color:#34D399}

/* ── Card ──────────────────────────────────────────────── */
.card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);box-shadow:var(--sh);overflow:hidden}
.card-header{padding:20px 28px;border-bottom:1px solid var(--border);background:var(--s1);
  display:flex;align-items:center;gap:12px}
.card-header-icon{width:38px;height:38px;border-radius:10px;background:var(--grad);display:flex;
  align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;box-shadow:0 3px 10px var(--sky-glow)}
.card-header-title{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem}
.card-header-sub{font-size:.8rem;color:var(--muted);margin-top:2px}
.card-body{padding:28px}

/* ── Form ──────────────────────────────────────────────── */
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}
.form-group{display:flex;flex-direction:column;gap:7px}
.form-label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted)}
.field-wrap{display:flex;align-items:center;gap:10px;background:var(--s1);border:1.5px solid var(--border);
  border-radius:10px;padding:0 14px;transition:border-color .2s,box-shadow .2s}
.field-wrap:focus-within{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.field-wrap .fi{font-size:.95rem;flex-shrink:0;opacity:.7}
.field-wrap input,.field-wrap select{flex:1;border:none;background:transparent;color:var(--text);
  font-family:'DM Sans',sans-serif;font-size:.88rem;padding:11px 0;outline:none}
.field-wrap input::placeholder{color:var(--muted);opacity:.65}
.form-hint{font-size:.74rem;color:var(--muted)}

/* ── Section divider ───────────────────────────────────── */
.section-sep{display:flex;align-items:center;gap:12px;margin:24px 0}
.section-sep-line{flex:1;height:1px;background:var(--border)}
.section-sep-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);white-space:nowrap}

/* ── Buttons ───────────────────────────────────────────── */
.form-actions{display:flex;gap:10px;justify-content:flex-end;padding-top:4px}
.btn{display:inline-flex;align-items:center;gap:7px;padding:9px 20px;border-radius:9px;font-weight:600;
  font-size:.85rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none;font-family:'DM Sans',sans-serif}
.btn-grad{background:var(--grad);color:#fff;box-shadow:0 4px 14px var(--sky-glow)}
.btn-grad:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 6px 20px var(--sky-glow)}
.btn-outline{background:var(--s0);border:1.5px solid var(--border);color:var(--muted)}
.btn-outline:hover{border-color:var(--sky);color:var(--sky)}
.btn-lg{padding:11px 26px;font-size:.92rem}

/* ── Animations ────────────────────────────────────────── */
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.fu{animation:fadeUp .45s ease both}
.fu-1{animation-delay:.05s}.fu-2{animation-delay:.1s}.fu-3{animation-delay:.15s}

/* ── Mobile ────────────────────────────────────────────── */
.sb-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:199;backdrop-filter:blur(3px)}
@media(max-width:768px){
  .as-sidebar.open{transform:translateX(0);box-shadow:var(--sh-lg)}
  .sb-overlay.visible{display:block}
  .form-grid{grid-template-columns:1fr}
  .page-content{padding:20px 16px}
}
</style>
</head>
<body>
<div class="as-layout">

  <!-- Sidebar -->
  <%@ include file="/Views/common/sidebar.jsp" %>
  <div class="sb-overlay" id="sbOverlay"></div>

  <!-- Main -->
  <main class="as-main">
    <!-- Topbar -->
    <header class="as-topbar">
      <button class="sb-toggle" id="sbToggle" title="Toggle sidebar">☰</button>
      <span class="topbar-title">✈ Schedule Flight</span>
      <div class="topbar-right">
        <button class="theme-toggle" id="themeToggle" title="Toggle theme">🌙</button>
        <a href="${pageContext.request.contextPath}/logout" class="topbar-logout">Logout</a>
      </div>
    </header>

    <!-- Content -->
    <div class="page-content">
      <div class="page-header fu">
        <div>
          <h1 class="page-title">Schedule a Flight</h1>
          <p class="page-subtitle">Add a new flight to the AeroSphere network</p>
        </div>
        <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-outline">← All Flights</a>
      </div>

      <% if (flightError   != null) { %><div class="alert alert-error fu">⚠ <%= flightError %></div><% } %>
      <% if (flightSuccess != null) { %><div class="alert alert-success fu">✅ <%= flightSuccess %></div><% } %>

      <div class="card fu-1">
        <div class="card-header">
          <div class="card-header-icon">✈</div>
          <div>
            <div class="card-header-title">Flight Details</div>
            <div class="card-header-sub">Fill in all required fields to schedule a new flight</div>
          </div>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/addFlight" method="post">
            <input type="hidden" name="_csrf" value="<%= HtmlUtils.e(csrfToken) %>">

            <!-- Route & Schedule -->
            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Flight Number *</label>
                <div class="field-wrap">
                  <span class="fi">🛩</span>
                  <input type="text" name="flight_no" placeholder="e.g. SK101" required maxlength="20" autocomplete="off">
                </div>
                <span class="form-hint">Unique identifier for this flight</span>
              </div>
              <div class="form-group">
                <label class="form-label">Departure Date *</label>
                <div class="field-wrap">
                  <span class="fi">📅</span>
                  <input type="date" name="depart_date" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">From (Source) *</label>
                <div class="field-wrap">
                  <span class="fi">🛫</span>
                  <input type="text" name="source" placeholder="e.g. Mumbai" required maxlength="100">
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">To (Destination) *</label>
                <div class="field-wrap">
                  <span class="fi">🛬</span>
                  <input type="text" name="destination" placeholder="e.g. Delhi" required maxlength="100">
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Departure Time *</label>
                <div class="field-wrap">
                  <span class="fi">🕐</span>
                  <input type="time" name="depart_time" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Arrival Time</label>
                <div class="field-wrap">
                  <span class="fi">🕑</span>
                  <input type="time" name="arrival_time">
                </div>
              </div>
            </div>

            <div class="section-sep">
              <div class="section-sep-line"></div>
              <span class="section-sep-label">Capacity & Pricing</span>
              <div class="section-sep-line"></div>
            </div>

            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Price per Seat (₹) *</label>
                <div class="field-wrap">
                  <span class="fi">💰</span>
                  <input type="number" name="price" placeholder="e.g. 4500" min="1" step="0.01" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Total Seats *</label>
                <div class="field-wrap">
                  <span class="fi">💺</span>
                  <input type="number" name="seats_total" placeholder="e.g. 180" min="1" max="999" required>
                </div>
                <span class="form-hint">Available seats = total seats on creation</span>
              </div>
            </div>

            <div class="section-sep"><div class="section-sep-line"></div></div>
            <div class="form-actions">
              <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-outline">Cancel</a>
              <button type="reset" class="btn btn-outline">Reset</button>
              <button type="submit" class="btn btn-grad btn-lg">✈ Schedule Flight</button>
            </div>
          </form>
        </div>
      </div>

    </div><!-- /page-content -->
  </main>
</div><!-- /as-layout -->

<script>
// Theme
(function(){
  const root = document.documentElement;
  const saved = localStorage.getItem('asTheme') || 'light';
  root.setAttribute('data-theme', saved);
  document.getElementById('themeToggle').textContent = saved === 'dark' ? '☀️' : '🌙';
})();
document.getElementById('themeToggle').addEventListener('click', function(){
  const cur  = document.documentElement.getAttribute('data-theme');
  const next = cur === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem('asTheme', next);
  this.textContent = next === 'dark' ? '☀️' : '🌙';
});

// Sidebar toggle
const sidebar  = document.getElementById('sidebar');
const overlay  = document.getElementById('sbOverlay');
const sbToggle = document.getElementById('sbToggle');
sbToggle.addEventListener('click', () => {
  const isMobile = window.innerWidth <= 768;
  if (isMobile) {
    sidebar.classList.toggle('open');
    overlay.classList.toggle('visible');
  } else {
    sidebar.classList.toggle('collapsed');
    document.querySelector('.as-main').style.marginLeft =
      sidebar.classList.contains('collapsed') ? '0' : 'var(--sidebar-w)';
  }
});
overlay.addEventListener('click', () => {
  sidebar.classList.remove('open');
  overlay.classList.remove('visible');
});

// Date min = today
document.querySelector('input[name="depart_date"]').min = new Date().toISOString().split('T')[0];

// Live seat/price preview
const priceInput = document.querySelector('input[name="price"]');
const seatsInput = document.querySelector('input[name="seats_total"]');
function updatePreview(){
  const p = parseFloat(priceInput.value) || 0;
  const s = parseInt(seatsInput.value) || 0;
  if(p > 0 && s > 0) {
    const hint = seatsInput.closest('.form-group').querySelector('.form-hint');
    if(hint) hint.textContent = `${s} seats · Max revenue ₹${(p*s).toLocaleString('en-IN')}`;
  }
}
priceInput.addEventListener('input', updatePreview);
seatsInput.addEventListener('input', updatePreview);

// Ripple on grad button
document.querySelector('.btn-grad').addEventListener('click', function(e){
  const r = document.createElement('span');
  r.style.cssText = `position:absolute;border-radius:50%;background:rgba(255,255,255,.35);
    width:60px;height:60px;margin-left:-30px;margin-top:-30px;
    animation:ripple .5s linear;pointer-events:none;
    left:${e.offsetX}px;top:${e.offsetY}px`;
  this.style.position='relative';this.style.overflow='hidden';
  this.appendChild(r);
  setTimeout(()=>r.remove(), 550);
});
</script>
<style>@keyframes ripple{to{transform:scale(4);opacity:0}}</style>
</body>
</html>
