<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.skyconnect.util.CsrfUtil" %>
<%@ page import="com.skyconnect.model.User" %>
<%
    String userName  = (String) session.getAttribute("userName");
    // Try to get email from user object stored in session (set by LoginServlet)
    String userEmail = "";
    Object userObj = session.getAttribute("user");
    if (userObj instanceof User) {
        String ue = ((User) userObj).getEmail();
        if (ue != null) userEmail = ue;
    }
    String success   = (String) request.getAttribute("success");
    String error     = (String) request.getAttribute("error");
    String csrfToken = CsrfUtil.getToken(request);
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Contact Us – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.1.1/src/bold/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Fraunces',serif;font-weight:400;font-size:2.2rem;margin-bottom:10px;letter-spacing:-.01em}
.page-hero p{opacity:.85;font-size:1rem;max-width:500px;margin:0 auto}
.contact-wrap{max-width:1060px;margin:0 auto;padding:56px 32px}
.contact-grid{display:grid;grid-template-columns:1fr 1.5fr;gap:36px;align-items:start}
.info-card{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:32px}
.info-card-title{font-family:'Fraunces',serif;font-weight:500;font-size:1.15rem;margin-bottom:24px}
.info-item{display:flex;gap:14px;align-items:flex-start;margin-bottom:24px}
.info-icon{width:42px;height:42px;border-radius:var(--radius-sm);background:var(--primary-glow);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0}
.info-label{font-size:.75rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:3px}
.info-val{font-size:.9rem;font-weight:600;color:var(--text)}
.info-sub{font-size:.78rem;color:var(--text-muted);margin-top:2px}
.divider{border:none;border-top:1px solid var(--border);margin:20px 0}
.quick-links-title{font-size:.78rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:12px}
.quick-link{display:flex;align-items:center;gap:8px;padding:9px 12px;border-radius:var(--radius-sm);text-decoration:none;color:var(--text-muted);font-size:.85rem;font-weight:500;transition:all .2s;margin-bottom:4px}
.quick-link:hover{background:var(--primary-glow);color:var(--primary)}
.form-card{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:32px}
.form-card-title{font-family:'Fraunces',serif;font-weight:500;font-size:1.15rem;margin-bottom:24px}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.form-group{margin-bottom:18px}
.form-group label{display:block;font-size:.75rem;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:7px}
.form-group input,.form-group select,.form-group textarea{width:100%;padding:11px 14px;background:var(--bg);border:1.5px solid var(--border-2);border-radius:var(--radius-sm);color:var(--text);font-family:'Inter',sans-serif;font-size:.88rem;outline:none;transition:border-color .2s,box-shadow .2s;resize:vertical}
.form-group input:focus,.form-group select:focus,.form-group textarea:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-glow)}
.form-group textarea{min-height:130px}
.char-count{font-size:.72rem;color:var(--text-muted);text-align:right;margin-top:4px}
.submit-btn{width:100%;padding:13px;background:var(--grad-brand);color:#fff;border:none;border-radius:var(--radius-full);font-family:'Inter',sans-serif;font-weight:500;font-size:.95rem;cursor:pointer;transition:opacity .2s,transform .2s;display:flex;align-items:center;justify-content:center;gap:8px}
.submit-btn:hover{opacity:.9;transform:translateY(-1px)}
.submit-btn:disabled{opacity:.6;cursor:not-allowed;transform:none}
.alert-success{background:var(--success-bg);border:1px solid var(--success-border);border-radius:var(--radius);padding:14px 18px;color:var(--secondary-dark);font-size:.9rem;margin-bottom:20px;display:flex;gap:10px;align-items:flex-start}
.alert-error{background:var(--danger-bg);border:1px solid var(--danger-border);border-radius:var(--radius);padding:14px 18px;color:var(--danger-dark);font-size:.9rem;margin-bottom:20px;display:flex;gap:10px;align-items:flex-start}
@media(max-width:768px){.contact-grid{grid-template-columns:1fr}.form-row{grid-template-columns:1fr}.contact-wrap{padding:32px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>

<div class="page-hero fade-up">
  <h1><i class="ph-bold ph-envelope-simple"></i> Contact Us</h1>
  <p>Have a question, issue, or feedback? Send us a message and we'll get back to you within 24–48 hours.</p>
</div>

<div class="contact-wrap">
  <div class="contact-grid">

    <%-- Left: Contact Info --%>
    <div class="info-card fade-up">
      <div class="info-card-title">Get in Touch</div>

      <div class="info-item">
        <div class="info-icon"><i class="ph-bold ph-envelope-simple"></i></div>
        <div>
          <div class="info-label">Email Support</div>
          <div class="info-val">support@aerosphere.in</div>
          <div class="info-sub">We respond within 24–48 hours</div>
        </div>
      </div>

      <div class="info-item">
        <div class="info-icon"><i class="ph-bold ph-clock"></i></div>
        <div>
          <div class="info-label">Support Hours</div>
          <div class="info-val">Mon – Fri, 9:00 AM – 6:00 PM IST</div>
          <div class="info-sub">Closed on public holidays</div>
        </div>
      </div>

      <div class="info-item">
        <div class="info-icon"><i class="ph-bold ph-lightning"></i></div>
        <div>
          <div class="info-label">Urgent Queries</div>
          <div class="info-val">For flight-day issues</div>
          <div class="info-sub">Mark your message as "Urgent" in the subject</div>
        </div>
      </div>

      <hr class="divider">
      <div class="quick-links-title">Quick Links</div>
      <a href="${pageContext.request.contextPath}/help" class="quick-link"><i class="ph-bold ph-book-open"></i> Help Center</a>
      <a href="${pageContext.request.contextPath}/faqs" class="quick-link"><i class="ph-bold ph-question"></i> FAQs</a>
      <a href="${pageContext.request.contextPath}/cancellationPolicy" class="quick-link"><i class="ph-bold ph-hand-coins"></i> Cancellation Policy</a>
      <a href="${pageContext.request.contextPath}/baggagePolicy" class="quick-link"><i class="ph-bold ph-suitcase"></i> Baggage Policy</a>
    </div>

    <%-- Right: Contact Form --%>
    <div class="form-card fade-up">
      <div class="form-card-title">Send a Message</div>

      <% if (success != null) { %>
        <div class="alert-success"><i class="ph-bold ph-check-circle"></i> <span><%= success %></span></div>
      <% } %>
      <% if (error != null) { %>
        <div class="alert-error"><i class="ph-bold ph-warning"></i> <span><%= error %></span></div>
      <% } %>

      <form action="${pageContext.request.contextPath}/contact" method="post" id="contactForm">
        <input type="hidden" name="_csrf" value="<%= csrfToken %>">

        <div class="form-row">
          <div class="form-group">
            <label>Your Name *</label>
            <input type="text" name="senderName" placeholder="Full name" required maxlength="100"
                   value="<%= userName != null ? userName : "" %>">
          </div>
          <div class="form-group">
            <label>Email Address *</label>
            <input type="email" name="senderEmail" placeholder="your@email.com" required maxlength="150"
                   value="<%= userEmail != null ? userEmail : "" %>">
          </div>
        </div>

        <div class="form-group">
          <label>Subject *</label>
          <select name="subject" required>
            <option value="">— Select a topic —</option>
            <option value="Booking Issue">Booking Issue</option>
            <option value="Payment / Refund Query">Payment / Refund Query</option>
            <option value="Flight Information">Flight Information</option>
            <option value="Cancellation Request">Cancellation Request</option>
            <option value="Account Problem">Account Problem</option>
            <option value="Baggage Query">Baggage Query</option>
            <option value="Technical Issue">Technical Issue</option>
            <option value="General Inquiry">General Inquiry</option>
            <option value="Feedback / Suggestion">Feedback / Suggestion</option>
            <option value="Urgent - Flight Day Issue">Urgent – Flight Day Issue</option>
          </select>
        </div>

        <div class="form-group">
          <label>Booking ID (optional)</label>
          <input type="text" name="bookingId" placeholder="e.g. #1234 — leave blank if not applicable" maxlength="20">
        </div>

        <div class="form-group">
          <label>Message *</label>
          <textarea name="message" placeholder="Please describe your issue or question in detail..." required
                    maxlength="2000" id="msgArea" oninput="updateCount(this)"></textarea>
          <div class="char-count"><span id="charCount">0</span> / 2000 characters</div>
        </div>

        <button type="submit" class="submit-btn" id="submitBtn">
          <span id="btnText"><i class="ph-bold ph-paper-plane-tilt"></i> Send Message</span>
        </button>
      </form>
    </div>

  </div>
</div>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
function updateCount(el){document.getElementById('charCount').textContent=el.value.length;}
document.getElementById('contactForm').addEventListener('submit',function(){
  var btn=document.getElementById('submitBtn');
  btn.disabled=true;
  document.getElementById('btnText').textContent='Sending…';
});
</script>
</body>
</html>
