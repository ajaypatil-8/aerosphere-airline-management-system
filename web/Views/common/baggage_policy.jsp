<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Baggage Policy – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Syne',sans-serif;font-size:2.2rem;font-weight:800;margin-bottom:10px}
.page-hero p{opacity:.85;font-size:1rem;max-width:520px;margin:0 auto}
.policy-wrap{max-width:900px;margin:0 auto;padding:56px 32px}
.allowance-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:36px}
.class-card{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden}
.class-header{padding:18px 24px;display:flex;align-items:center;gap:10px}
.class-header.economy{background:rgba(14,165,233,.08);border-bottom:2px solid var(--primary)}
.class-header.business{background:rgba(245,158,11,.08);border-bottom:2px solid #F59E0B}
.class-title{font-family:'Syne',sans-serif;font-weight:800;font-size:1.05rem}
.class-body{padding:20px 24px}
.baggage-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border)}
.baggage-row:last-child{border:none}
.baggage-label{font-size:.85rem;color:var(--text-muted);font-weight:500}
.baggage-val{font-weight:700;font-size:.95rem;font-family:'Syne',sans-serif}
.section-title{font-family:'Syne',sans-serif;font-size:1.15rem;font-weight:800;margin-bottom:18px;display:flex;align-items:center;gap:8px}
.policy-section{margin-bottom:40px}
.rule-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.rule-card{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius);padding:18px}
.rule-card-title{font-weight:700;font-size:.88rem;margin-bottom:8px;display:flex;align-items:center;gap:7px}
.rule-card-desc{font-size:.82rem;color:var(--text-muted);line-height:1.65}
.prohibited-list{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.prohibited-item{display:flex;gap:9px;align-items:flex-start;padding:12px;background:rgba(239,68,68,.04);border:1px solid rgba(239,68,68,.15);border-radius:var(--radius-sm);font-size:.82rem;color:var(--text)}
.prohibited-item .ic{font-size:1rem;flex-shrink:0}
.excess-table{width:100%;border-collapse:collapse;font-size:.88rem}
.excess-table th{background:var(--surface-2);padding:10px 16px;text-align:left;font-weight:700;font-size:.78rem;text-transform:uppercase;letter-spacing:.04em;color:var(--text-muted);border-bottom:2px solid var(--border)}
.excess-table td{padding:12px 16px;border-bottom:1px solid var(--border);color:var(--text)}
.excess-table tr:last-child td{border:none}
.excess-table tr:hover td{background:var(--surface-2)}
@media(max-width:640px){.allowance-grid,.rule-grid,.prohibited-list{grid-template-columns:1fr}.policy-wrap{padding:32px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>

<div class="page-hero fade-up">
  <h1>🧳 Baggage Policy</h1>
  <p>Know exactly what you can carry — check-in, cabin baggage rules, excess fees and prohibited items.</p>
</div>

<div class="policy-wrap">

  <div class="policy-section fade-up">
    <div class="section-title">🎒 Free Baggage Allowance</div>
    <div class="allowance-grid">
      <div class="class-card">
        <div class="class-header economy">
          <span style="font-size:1.3rem">💺</span>
          <div>
            <div class="class-title">Economy Class</div>
            <div style="font-size:.75rem;color:var(--text-muted)">Standard fare</div>
          </div>
        </div>
        <div class="class-body">
          <div class="baggage-row"><span class="baggage-label">✈ Check-in Baggage</span><span class="baggage-val">15 kg</span></div>
          <div class="baggage-row"><span class="baggage-label">💼 Cabin Baggage</span><span class="baggage-val">7 kg</span></div>
          <div class="baggage-row"><span class="baggage-label">👶 Infant (under 2)</span><span class="baggage-val">10 kg check-in</span></div>
          <div class="baggage-row"><span class="baggage-label">📏 Max Cabin Dimensions</span><span class="baggage-val">55×40×20 cm</span></div>
        </div>
      </div>
      <div class="class-card">
        <div class="class-header business">
          <span style="font-size:1.3rem">🌟</span>
          <div>
            <div class="class-title">Business Class</div>
            <div style="font-size:.75rem;color:var(--text-muted)">Premium fare</div>
          </div>
        </div>
        <div class="class-body">
          <div class="baggage-row"><span class="baggage-label">✈ Check-in Baggage</span><span class="baggage-val">25 kg</span></div>
          <div class="baggage-row"><span class="baggage-label">💼 Cabin Baggage</span><span class="baggage-val">10 kg</span></div>
          <div class="baggage-row"><span class="baggage-label">👶 Infant (under 2)</span><span class="baggage-val">10 kg check-in</span></div>
          <div class="baggage-row"><span class="baggage-label">📏 Max Cabin Dimensions</span><span class="baggage-val">55×40×20 cm</span></div>
        </div>
      </div>
    </div>
  </div>

  <div class="policy-section fade-up">
    <div class="section-title">💰 Excess Baggage Charges</div>
    <div style="background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden">
      <table class="excess-table">
        <thead><tr><th>Weight Slab</th><th>Economy Rate</th><th>Business Rate</th><th>Notes</th></tr></thead>
        <tbody>
          <tr><td>Up to free allowance</td><td style="color:#10B981;font-weight:700">Free</td><td style="color:#10B981;font-weight:700">Free</td><td>No charges</td></tr>
          <tr><td>1 – 5 kg over limit</td><td>₹350 / kg</td><td>₹300 / kg</td><td>Per kg excess</td></tr>
          <tr><td>5 – 15 kg over limit</td><td>₹400 / kg</td><td>₹350 / kg</td><td>Per kg excess</td></tr>
          <tr><td>15+ kg over limit</td><td>₹500 / kg</td><td>₹450 / kg</td><td>Pre-booking recommended</td></tr>
          <tr><td>Oversized item (any side &gt;158cm)</td><td>₹1,500 flat</td><td>₹1,200 flat</td><td>Sports equipment, bikes, etc.</td></tr>
        </tbody>
      </table>
    </div>
    <p style="color:var(--text-muted);font-size:.82rem;margin-top:12px">💡 Pre-book additional baggage by contacting support to receive a 10% discount on excess charges.</p>
  </div>

  <div class="policy-section fade-up">
    <div class="section-title">📋 Cabin Baggage Rules</div>
    <div class="rule-grid">
      <div class="rule-card">
        <div class="rule-card-title">💼 One Bag Per Person</div>
        <div class="rule-card-desc">Each passenger is permitted one main cabin bag plus one personal item (handbag, laptop bag, or small backpack). Personal items must fit under the seat in front of you.</div>
      </div>
      <div class="rule-card">
        <div class="rule-card-title">💧 Liquids Rule (100ml)</div>
        <div class="rule-card-desc">All liquids, gels, and aerosols in cabin baggage must be in containers of 100ml or less, placed in a single transparent 1-litre resealable plastic bag. One bag per passenger.</div>
      </div>
      <div class="rule-card">
        <div class="rule-card-title">💻 Electronics</div>
        <div class="rule-card-desc">Laptops, tablets, and cameras must be removed from bags at security. Lithium batteries up to 100Wh are allowed in cabin. Spare batteries must be in cabin baggage, not check-in.</div>
      </div>
      <div class="rule-card">
        <div class="rule-card-title">🔒 Cabin Security</div>
        <div class="rule-card-desc">All cabin bags are screened at the security checkpoint. You may be asked to open and demonstrate electronic devices. Items that fail screening will not be permitted on board.</div>
      </div>
    </div>
  </div>

  <div class="policy-section fade-up">
    <div class="section-title">🚫 Prohibited Items</div>
    <p style="color:var(--text-muted);font-size:.88rem;margin-bottom:16px">The following items are not permitted in cabin or check-in baggage:</p>
    <div class="prohibited-list">
      <div class="prohibited-item"><span class="ic">🔫</span><span>Firearms, guns, and replica weapons (all baggage)</span></div>
      <div class="prohibited-item"><span class="ic">🔪</span><span>Knives, scissors over 6cm, sharp objects (cabin only)</span></div>
      <div class="prohibited-item"><span class="ic">💣</span><span>Explosives, grenades, fireworks (all baggage)</span></div>
      <div class="prohibited-item"><span class="ic">🔥</span><span>Flammable liquids — petrol, lighter fluid, paint (all)</span></div>
      <div class="prohibited-item"><span class="ic">⚗️</span><span>Corrosive substances — acids, bleach, mercury</span></div>
      <div class="prohibited-item"><span class="ic">🧪</span><span>Radioactive, infectious, or toxic materials</span></div>
      <div class="prohibited-item"><span class="ic">🔋</span><span>Lithium batteries &gt;160Wh (all), spare batteries in check-in</span></div>
      <div class="prohibited-item"><span class="ic">🌿</span><span>Narcotics, controlled substances (all baggage)</span></div>
    </div>
    <p style="color:var(--text-muted);font-size:.82rem;margin-top:14px">⚠️ Carrying prohibited items is a criminal offence. Violators will be handed over to the relevant authorities. AeroSphere assumes no liability for confiscated items.</p>
  </div>

  <div style="text-align:center;margin-top:32px" class="fade-up">
    <p style="color:var(--text-muted);font-size:.9rem;margin-bottom:16px">Questions about specific items? Our support team can help.</p>
    <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">📧 Contact Support</a>
  </div>

</div>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
</body>
</html>
