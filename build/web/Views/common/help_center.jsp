<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Help Center – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.help-hero{background:var(--grad-brand);padding:64px 32px;text-align:center;color:#fff}
.help-hero h1{font-family:'Syne',sans-serif;font-size:2.4rem;font-weight:800;margin-bottom:12px}
.help-hero p{opacity:.85;font-size:1.05rem;max-width:540px;margin:0 auto 28px}
.help-search{display:flex;gap:10px;max-width:480px;margin:0 auto}
.help-search input{flex:1;padding:12px 18px;border-radius:var(--radius-sm);border:none;font-family:'DM Sans',sans-serif;font-size:.95rem;outline:none}
.help-search button{padding:12px 22px;background:#fff;color:var(--primary);border:none;border-radius:var(--radius-sm);font-weight:700;cursor:pointer;font-family:'DM Sans',sans-serif}
.help-wrap{max-width:1100px;margin:0 auto;padding:56px 32px}
.help-cats{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-bottom:56px}
.help-cat{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:28px 24px;text-align:center;transition:all .2s;cursor:pointer;text-decoration:none;color:var(--text)}
.help-cat:hover{border-color:var(--primary);box-shadow:var(--shadow-lg);transform:translateY(-3px)}
.help-cat-icon{font-size:2.2rem;margin-bottom:12px}
.help-cat-title{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem;margin-bottom:6px}
.help-cat-desc{font-size:.82rem;color:var(--text-muted)}
.faq-section{margin-bottom:48px}
.faq-section-title{font-family:'Syne',sans-serif;font-size:1.2rem;font-weight:800;margin-bottom:20px;padding-bottom:12px;border-bottom:2px solid var(--border)}
.faq-item{border:1px solid var(--border);border-radius:var(--radius);margin-bottom:10px;overflow:hidden}
.faq-q{padding:16px 20px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between;align-items:center;background:var(--surface-0);user-select:none;transition:background .2s}
.faq-q:hover{background:var(--surface-2)}
.faq-q .arrow{transition:transform .3s;font-size:.85rem}
.faq-item.open .faq-q .arrow{transform:rotate(180deg)}
.faq-a{max-height:0;overflow:hidden;transition:max-height .35s ease,padding .35s}
.faq-item.open .faq-a{max-height:400px;padding:16px 20px;color:var(--text-muted);line-height:1.7;font-size:.9rem}
.contact-cta{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:40px;text-align:center}
.contact-cta h3{font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;margin-bottom:8px}
.contact-cta p{color:var(--text-muted);margin-bottom:20px}
@media(max-width:768px){.help-cats{grid-template-columns:1fr 1fr}.help-wrap{padding:36px 16px}}
@media(max-width:500px){.help-cats{grid-template-columns:1fr}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>

<div class="help-hero fade-up">
  <h1>How can we help you?</h1>
  <p>Find answers to common questions or reach out to our support team.</p>
  <div class="help-search">
    <input type="text" id="faqSearch" placeholder="Search help articles..." oninput="searchFaq(this.value)">
    <button onclick="searchFaq(document.getElementById('faqSearch').value)">Search</button>
  </div>
</div>

<div class="help-wrap">

  <div class="help-cats fade-up">
    <a href="#booking" class="help-cat">
      <div class="help-cat-icon">🎫</div>
      <div class="help-cat-title">Booking & Tickets</div>
      <div class="help-cat-desc">How to book, modify, or view your tickets</div>
    </a>
    <a href="#payment" class="help-cat">
      <div class="help-cat-icon">💳</div>
      <div class="help-cat-title">Payments & Refunds</div>
      <div class="help-cat-desc">Payment methods, billing, and refund queries</div>
    </a>
    <a href="#baggage" class="help-cat">
      <div class="help-cat-icon">🧳</div>
      <div class="help-cat-title">Baggage</div>
      <div class="help-cat-desc">Allowed baggage, excess fees, and restrictions</div>
    </a>
    <a href="#checkin" class="help-cat">
      <div class="help-cat-icon">✅</div>
      <div class="help-cat-title">Check-in</div>
      <div class="help-cat-desc">Online and airport check-in procedures</div>
    </a>
    <a href="#account" class="help-cat">
      <div class="help-cat-icon">👤</div>
      <div class="help-cat-title">My Account</div>
      <div class="help-cat-desc">Profile settings, password, and preferences</div>
    </a>
    <a href="${pageContext.request.contextPath}/contact" class="help-cat">
      <div class="help-cat-icon">📧</div>
      <div class="help-cat-title">Contact Support</div>
      <div class="help-cat-desc">Reach our team directly for personalized help</div>
    </a>
  </div>

  <div id="faqContainer">

    <div class="faq-section fade-up" id="booking">
      <div class="faq-section-title">✈ Booking & Tickets</div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">How do I book a flight? <span class="arrow">▾</span></div><div class="faq-a">Use the Search Flights page to enter your origin, destination, travel date, and number of passengers. Select your preferred flight from the results and proceed to payment. You'll receive a booking confirmation email once payment is complete.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">Can I book for multiple passengers? <span class="arrow">▾</span></div><div class="faq-a">Yes! During the search, select the number of seats (up to 9). You'll be asked to enter passenger details for each traveller during the booking process.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">How do I view my booking? <span class="arrow">▾</span></div><div class="faq-a">Log in to your AeroSphere account and navigate to "My Bookings" from the navbar. All your past and upcoming bookings will be listed there with status and invoice options.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">Can I change my flight after booking? <span class="arrow">▾</span></div><div class="faq-a">Flight changes are not currently supported through the portal. Please contact our support team via the Contact Us page and we'll assist you with flight changes manually.</div></div>
    </div>

    <div class="faq-section fade-up" id="payment">
      <div class="faq-section-title">💳 Payments & Refunds</div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">What payment methods are accepted? <span class="arrow">▾</span></div><div class="faq-a">We accept all major credit/debit cards, UPI, net banking, and wallets through our secure Razorpay payment gateway. All transactions are encrypted and safe.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">How do I cancel and get a refund? <span class="arrow">▾</span></div><div class="faq-a">Go to "My Bookings", find the booking you want to cancel, and click the Cancel button. A refund request is automatically created. Refunds are processed within 3–5 business days after admin approval.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">What is the refund policy? <span class="arrow">▾</span></div><div class="faq-a">Cancellations more than 24 hours before departure receive a 100% refund. Cancellations between 2–24 hours before departure receive a 50% refund. Cancellations less than 2 hours before departure are non-refundable.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">How long does a refund take? <span class="arrow">▾</span></div><div class="faq-a">Once approved by our admin team, refunds take 3–5 business days to reflect in your original payment method. You'll receive an email notification when your refund is approved.</div></div>
    </div>

    <div class="faq-section fade-up" id="baggage">
      <div class="faq-section-title">🧳 Baggage</div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">What is the free baggage allowance? <span class="arrow">▾</span></div><div class="faq-a">Economy class passengers are allowed 15 kg of check-in baggage and 7 kg of cabin baggage per person. Business class passengers get 25 kg check-in and 10 kg cabin baggage.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">What are excess baggage charges? <span class="arrow">▾</span></div><div class="faq-a">Excess baggage is charged at ₹350 per kg beyond the free allowance. It's recommended to pre-book additional baggage through our support team to get a discounted rate.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">Are there items I cannot carry? <span class="arrow">▾</span></div><div class="faq-a">Yes. Prohibited items include: sharp objects in cabin baggage, flammable liquids, explosives, and certain electronics in check-in baggage. Liquids in cabin baggage must be under 100ml each and fit in a 1-litre clear bag.</div></div>
    </div>

    <div class="faq-section fade-up" id="checkin">
      <div class="faq-section-title">✅ Check-in</div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">When can I check in? <span class="arrow">▾</span></div><div class="faq-a">Online check-in opens 24 hours before departure and closes 2 hours before departure. Airport check-in counters open 3 hours before departure and close 45 minutes before departure.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">What documents do I need? <span class="arrow">▾</span></div><div class="faq-a">You'll need a valid government-issued photo ID (Aadhaar card, passport, driving license, or voter ID) and your booking confirmation. International travellers need a valid passport.</div></div>
    </div>

    <div class="faq-section fade-up" id="account">
      <div class="faq-section-title">👤 My Account</div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">How do I update my profile? <span class="arrow">▾</span></div><div class="faq-a">Click on your name in the top navigation bar and select "Profile". From there, click "Edit Profile" to update your name, phone number, and other details.</div></div>
      <div class="faq-item"><div class="faq-q" onclick="toggle(this)">I forgot my password. What do I do? <span class="arrow">▾</span></div><div class="faq-a">On the login page, click "Forgot Password" and enter your registered email address. You'll receive an OTP to reset your password. Contact support if you're still having trouble.</div></div>
    </div>

  </div>

  <div class="contact-cta fade-up">
    <h3>Still need help?</h3>
    <p>Our support team is available Monday–Friday, 9 AM to 6 PM IST.</p>
    <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">📧 Contact Support</a>
  </div>

</div>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
function toggle(el){
  var item=el.parentElement;
  var wasOpen=item.classList.contains('open');
  document.querySelectorAll('.faq-item.open').forEach(function(i){i.classList.remove('open');});
  if(!wasOpen) item.classList.add('open');
}
function searchFaq(q){
  q=q.toLowerCase().trim();
  document.querySelectorAll('.faq-item').forEach(function(item){
    var text=item.textContent.toLowerCase();
    item.style.display=(!q||text.includes(q))?'':'none';
  });
}
// Scroll to section
document.querySelectorAll('a[href^="#"]').forEach(function(a){
  a.addEventListener('click',function(e){
    var target=document.getElementById(this.getAttribute('href').slice(1));
    if(target){e.preventDefault();target.scrollIntoView({behavior:'smooth',block:'start'});}
  });
});
</script>
</body>
</html>
