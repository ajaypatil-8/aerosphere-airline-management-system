<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil, com.skyconnect.util.HtmlUtils" %>
<%
    String userName  = (String) session.getAttribute("userName");
    String userRole  = (String) session.getAttribute("userRole");
    if (userName == null || !"ADMIN".equals(userRole)) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer id        = (Integer) request.getAttribute("id");
    String  flightNo  = (String)  request.getAttribute("flightNo");
    String  source    = (String)  request.getAttribute("source");
    String  dest      = (String)  request.getAttribute("destination");
    Object  date      = request.getAttribute("date");
    Object  depTime   = request.getAttribute("departTime");
    Object  arrTime   = request.getAttribute("arrivalTime");
    Double  price     = (Double)  request.getAttribute("price");
    Integer totalSeats= (Integer) request.getAttribute("totalSeats");
    Integer availSeats= (Integer) request.getAttribute("availableSeats");
    String depTimeStr = depTime != null ? depTime.toString().substring(0,5) : "";
    String arrTimeStr = arrTime != null ? arrTime.toString().substring(0,5) : "";
    String csrfToken  = CsrfUtil.getToken(request);
    // Seat occupancy % for the mini progress bar
    int occupiedPct   = (totalSeats != null && totalSeats > 0 && availSeats != null)
                        ? (int)(((double)(totalSeats - availSeats) / totalSeats) * 100) : 0;
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Edit Flight <%= HtmlUtils.e(flightNo != null ? flightNo : "") %> – AeroSphere Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<style>
/* ── Design Tokens ─────────────────────────────────────── */
:root{
  --sky:#2E4A3D;--sky-dark:#253D33;--sky-glow:rgba(46,74,61,.18);
  --em:#5B8A6E;--em-dark:#3E6350;--em-glow:rgba(91,138,110,.18);
  --warn:#B8863F;--danger:#B3554A;
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
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

/* ── Layout ────────────────────────────────────────────── */
.as-layout{display:flex;min-height:100vh}

/* ── Sidebar ───────────────────────────────────────────── */
.sb-brand{display:flex;align-items:center;gap:10px;padding:22px 20px 18px;border-bottom:1px solid var(--border);text-decoration:none;color:var(--text)}
.sb-brand-icon{width:36px;height:36px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;box-shadow:0 3px 10px var(--sky-glow)}
.sb-brand-name{font-family:'Fraunces',sans-serif;font-weight:800;font-size:1.05rem;letter-spacing:-.4px;line-height:1.1}
.sb-brand-name span{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.sb-admin-tag{font-size:.6rem;background:rgba(184,134,63,.15);color:#8A6530;border:1px solid var(--warning-border);padding:2px 6px;border-radius:4px;font-weight:700;letter-spacing:.05em;display:block;margin-top:2px}
.sb-section-label{font-size:.64rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--muted);padding:16px 20px 6px}
.sb-nav{display:flex;flex-direction:column;gap:2px;padding:0 12px}
.sb-link{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:9px;text-decoration:none;color:var(--muted);font-size:.86rem;font-weight:500;transition:all .18s;position:relative}
.sb-link .sb-icon{font-size:1rem;width:22px;text-align:center;flex-shrink:0}
.sb-link:hover{color:var(--text);background:var(--s2)}
.sb-link.active{color:var(--sky);background:var(--sky-glow);font-weight:600}
.sb-link.active::before{content:'';position:absolute;left:0;top:20%;bottom:20%;width:3px;background:var(--sky);border-radius:0 2px 2px 0}
.sb-divider{border:none;border-top:1px solid var(--border);margin:10px 12px}
.sb-footer{padding:16px 20px;border-top:1px solid var(--border);margin-top:auto}
.sb-user{display:flex;align-items:center;gap:10px}
.sb-avatar{width:32px;height:32px;border-radius:50%;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:.8rem;font-weight:700;color:#fff;flex-shrink:0}
.sb-user-name{font-size:.82rem;font-weight:600}
.sb-user-role{font-size:.7rem;color:var(--muted)}

/* ── Main ──────────────────────────────────────────────── */
/* ── Topbar ────────────────────────────────────────────── */
.as-topbar{position:sticky;top:0;z-index:100;background:rgba(255,255,255,.85);
  backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
  border-bottom:1px solid var(--border);padding:12px 28px;display:flex;align-items:center;gap:12px}
[data-theme="dark"] .as-topbar{background:rgba(13,17,23,.85)}
.sb-toggle{width:34px;height:34px;border:1px solid var(--border);border-radius:8px;background:var(--s0);
  cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1rem;transition:all .2s;color:var(--muted)}
.sb-toggle:hover{border-color:var(--sky);color:var(--sky)}
.topbar-title{font-family:'Fraunces',sans-serif;font-weight:700;font-size:1rem}
.topbar-crumb{font-size:.8rem;color:var(--muted);display:flex;align-items:center;gap:6px;margin-left:4px}
.topbar-crumb a{color:var(--muted);text-decoration:none}.topbar-crumb a:hover{color:var(--sky)}
.topbar-crumb span{color:var(--sky);font-weight:600}
.topbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
.theme-toggle{width:34px;height:34px;border:1px solid var(--border);border-radius:8px;background:var(--s0);
  cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.9rem;transition:all .2s;color:var(--muted)}
.theme-toggle:hover{border-color:var(--sky);color:var(--sky)}
.topbar-logout{text-decoration:none;font-size:.82rem;font-weight:600;color:#B3554A;background:rgba(179,85,74,.08);padding:6px 14px;border-radius:8px;transition:all .2s}
.topbar-logout:hover{background:var(--danger-bg)}

/* ── Page content ──────────────────────────────────────── */
.page-content{max-width:760px;margin:0 auto;padding:32px 28px;width:100%}

/* ── Page header ───────────────────────────────────────── */
.page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:28px;gap:12px;flex-wrap:wrap}
.page-title{font-family:'Fraunces',sans-serif;font-size:1.6rem;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
.page-subtitle{color:var(--muted);font-size:.9rem}
.flight-tag{display:inline-flex;align-items:center;gap:6px;background:var(--grad);color:#fff;
  padding:3px 12px;border-radius:99px;font-size:.8rem;font-weight:700;margin-left:6px;letter-spacing:.04em}

/* ── Flight info strip ─────────────────────────────────── */
.info-strip{display:grid;grid-template-columns:repeat(5,1fr);gap:14px;
  background:var(--s0);border:1px solid var(--border);border-radius:var(--r);
  padding:20px 24px;margin-bottom:22px;box-shadow:var(--sh)}
.info-strip-item{}
.info-label{font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);margin-bottom:5px}
.info-val{font-weight:700;font-size:.92rem}
.info-val.grad-text{background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.info-val.success{color:var(--em)}
.info-val.warn{color:var(--warn)}

/* ── Seat progress ─────────────────────────────────────── */
.seat-bar-wrap{margin-top:6px}
.seat-bar{height:6px;border-radius:3px;background:var(--border);overflow:hidden}
.seat-bar-fill{height:100%;border-radius:3px;transition:width .6s ease}
.fill-ok{background:var(--em)}
.fill-warn{background:var(--warn)}
.fill-full{background:var(--danger)}
.seat-bar-label{font-size:.68rem;color:var(--muted);margin-top:4px}

/* ── Warning banner ────────────────────────────────────── */
.edit-warn{display:flex;align-items:flex-start;gap:10px;padding:13px 16px;border-radius:11px;
  background:rgba(184,134,63,.08);border:1px solid rgba(184,134,63,.25);color:#8A6530;
  font-size:.83rem;margin-bottom:20px;line-height:1.45}
[data-theme="dark"] .edit-warn{color:#FCD34D}
.edit-warn strong{font-weight:700}

/* ── Card ──────────────────────────────────────────────── */
.card{background:var(--s0);border:1px solid var(--border);border-radius:var(--r);box-shadow:var(--sh);overflow:hidden}
.card-header{padding:20px 28px;border-bottom:1px solid var(--border);background:var(--s1);display:flex;align-items:center;gap:12px}
.card-header-icon{width:38px;height:38px;border-radius:10px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;box-shadow:0 3px 10px var(--sky-glow)}
.card-header-title{font-family:'Fraunces',sans-serif;font-weight:700;font-size:1rem}
.card-header-sub{font-size:.8rem;color:var(--muted);margin-top:2px}
.card-body{padding:28px}

/* ── Form ──────────────────────────────────────────────── */
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}
.form-group{display:flex;flex-direction:column;gap:7px}
.form-label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted)}
.field-wrap{display:flex;align-items:center;gap:10px;background:var(--s1);border:1.5px solid var(--border);border-radius:10px;padding:0 14px;transition:border-color .2s,box-shadow .2s}
.field-wrap:focus-within{border-color:var(--sky);box-shadow:0 0 0 3px var(--sky-glow)}
.field-wrap .fi{font-size:.95rem;flex-shrink:0;opacity:.7}
.field-wrap input{flex:1;border:none;background:transparent;color:var(--text);font-family:'Inter',sans-serif;font-size:.88rem;padding:11px 0;outline:none}

/* ── Section sep ───────────────────────────────────────── */
.section-sep{display:flex;align-items:center;gap:12px;margin:24px 0}
.section-sep-line{flex:1;height:1px;background:var(--border)}
.section-sep-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);white-space:nowrap}

/* ── Buttons ───────────────────────────────────────────── */
.form-actions{display:flex;gap:10px;justify-content:flex-end}
.btn{display:inline-flex;align-items:center;gap:7px;padding:9px 20px;border-radius:9px;font-weight:600;font-size:.85rem;text-decoration:none;cursor:pointer;transition:all .2s;border:none;font-family:'Inter',sans-serif}
.btn-grad{background:var(--grad);color:#fff;box-shadow:0 4px 14px var(--sky-glow)}
.btn-grad:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 6px 20px var(--sky-glow)}
.btn-outline{background:var(--s0);border:1.5px solid var(--border);color:var(--muted)}
.btn-outline:hover{border-color:var(--sky);color:var(--sky)}

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
  .info-strip{grid-template-columns:repeat(3,1fr)}
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
    <header class="as-topbar">
      <button class="sb-toggle" id="sbToggle"><i class="ph-bold ph-list"></i></button>
      <span class="topbar-title">Edit Flight</span>
      <div class="topbar-crumb">
        <a href="${pageContext.request.contextPath}/adminFlights">Flights</a>
        › <span><%= HtmlUtils.e(flightNo != null ? flightNo : "") %></span>
      </div>
      <div class="topbar-right">
        <button class="theme-toggle" id="themeToggle"><i class="ph-bold ph-moon"></i></button>
        <a href="${pageContext.request.contextPath}/logout" class="topbar-logout">Logout</a>
      </div>
    </header>

    <div class="page-content">
      <!-- Header -->
      <div class="page-header fu">
        <div>
          <h1 class="page-title">
            Edit Flight
            <span class="flight-tag"><i class="ph-bold ph-airplane-tilt"></i> <%= HtmlUtils.e(flightNo != null ? flightNo : "") %></span>
          </h1>
          <p class="page-subtitle">
            <%= HtmlUtils.e(source != null ? source : "") %> → <%= HtmlUtils.e(dest != null ? dest : "") %>
          </p>
        </div>
        <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-outline">← All Flights</a>
      </div>

      <!-- Flight info strip -->
      <div class="info-strip fu-1">
        <div class="info-strip-item">
          <div class="info-label">Flight No</div>
          <div class="info-val grad-text"><%= HtmlUtils.e(flightNo != null ? flightNo : "—") %></div>
        </div>
        <div class="info-strip-item">
          <div class="info-label">From</div>
          <div class="info-val"><%= HtmlUtils.e(source != null ? source : "—") %></div>
        </div>
        <div class="info-strip-item">
          <div class="info-label">To</div>
          <div class="info-val"><%= HtmlUtils.e(dest != null ? dest : "—") %></div>
        </div>
        <div class="info-strip-item">
          <div class="info-label">Total Seats</div>
          <div class="info-val"><%= totalSeats != null ? totalSeats : "—" %></div>
        </div>
        <div class="info-strip-item">
          <div class="info-label">Available</div>
          <div class="info-val <%= occupiedPct >= 90 ? "warn" : "success" %>">
            <%= availSeats != null ? availSeats : "—" %>
          </div>
          <% if (totalSeats != null && totalSeats > 0) { %>
          <div class="seat-bar-wrap">
            <div class="seat-bar">
              <div class="seat-bar-fill <%= occupiedPct >= 90 ? "fill-full" : occupiedPct >= 60 ? "fill-warn" : "fill-ok" %>"
                   style="width:<%= occupiedPct %>%"></div>
            </div>
            <div class="seat-bar-label"><%= occupiedPct %>% occupied</div>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Warning -->
      <div class="edit-warn fu-2">
        <i class="ph-bold ph-warning"></i> <div><strong>Editable fields only:</strong> You can update date, times, and price.
        Route and total seat count are locked once a flight is created.</div>
      </div>

      <!-- Form card -->
      <div class="card fu-3">
        <div class="card-header">
          <div class="card-header-icon"><i class="ph-bold ph-pencil-simple"></i></div>
          <div>
            <div class="card-header-title">Update Flight Details</div>
            <div class="card-header-sub">Changes apply immediately to new bookings</div>
          </div>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/editFlight" method="post">
            <input type="hidden" name="_csrf"  value="<%= HtmlUtils.e(csrfToken) %>">
            <input type="hidden" name="id"     value="<%= id %>">

            <div class="form-grid">
              <div class="form-group">
                <label class="form-label">Departure Date *</label>
                <div class="field-wrap">
                  <span class="fi"><i class="ph-bold ph-calendar-blank"></i></span>
                  <input type="date" name="depart_date" value="<%= date != null ? date : "" %>" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Price per Seat (₹) *</label>
                <div class="field-wrap">
                  <span class="fi"><i class="ph-bold ph-coins"></i></span>
                  <input type="number" name="price" value="<%= price != null ? price : "" %>" min="1" step="0.01" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Departure Time *</label>
                <div class="field-wrap">
                  <span class="fi"><i class="ph-bold ph-clock"></i></span>
                  <input type="time" name="depart_time" value="<%= depTimeStr %>" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Arrival Time</label>
                <div class="field-wrap">
                  <span class="fi"><i class="ph-bold ph-clock"></i></span>
                  <input type="time" name="arrival_time" value="<%= arrTimeStr %>">
                </div>
              </div>
            </div>

            <div class="section-sep"><div class="section-sep-line"></div></div>
            <div class="form-actions">
              <a href="${pageContext.request.contextPath}/adminFlights" class="btn btn-outline">Cancel</a>
              <button type="submit" class="btn btn-grad"><i class="ph-bold ph-check-circle"></i> Save Changes</button>
            </div>
          </form>
        </div>
      </div>

    </div><!-- /page-content -->
  </main>
</div>

<script>
// Theme
(function(){
  const root = document.documentElement;
  const saved = localStorage.getItem('asTheme') || 'light';
  root.setAttribute('data-theme', saved);
  document.getElementById('themeToggle').textContent = saved === 'dark' ? '<i class="ph-bold ph-sun"></i>' : '<i class="ph-bold ph-moon"></i>';
})();
document.getElementById('themeToggle').addEventListener('click', function(){
  const cur  = document.documentElement.getAttribute('data-theme');
  const next = cur === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem('asTheme', next);
  this.textContent = next === 'dark' ? '<i class="ph-bold ph-sun"></i>' : '<i class="ph-bold ph-moon"></i>';
});

// Sidebar
const sidebar  = document.getElementById('sidebar');
const overlay  = document.getElementById('sbOverlay');
document.getElementById('sbToggle').addEventListener('click', () => {
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

// Animate seat bar on load
document.addEventListener('DOMContentLoaded', () => {
  const fill = document.querySelector('.seat-bar-fill');
  if (fill) {
    const target = fill.style.width;
    fill.style.width = '0';
    requestAnimationFrame(() => { fill.style.width = target; });
  }
});
</script>
</body>
</html>
