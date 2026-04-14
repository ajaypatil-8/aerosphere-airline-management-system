<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>FAQs – AeroSphere</title>
<script>(function(){var t=localStorage.getItem('asTheme')||(window.matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})()</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/animations.css">
<style>
.page-hero{background:var(--grad-brand);padding:56px 32px;text-align:center;color:#fff}
.page-hero h1{font-family:'Syne',sans-serif;font-size:2.2rem;font-weight:800;margin-bottom:10px}
.page-hero p{opacity:.85;font-size:1rem;max-width:500px;margin:0 auto}
.faq-wrap{max-width:820px;margin:0 auto;padding:56px 32px}
.faq-tabs{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:32px}
.faq-tab{padding:8px 18px;border-radius:var(--radius-sm);border:1.5px solid var(--border);font-size:.85rem;font-weight:600;cursor:pointer;background:var(--surface-0);color:var(--text-muted);transition:all .2s;font-family:'DM Sans',sans-serif}
.faq-tab.active,.faq-tab:hover{border-color:var(--primary);color:var(--primary);background:var(--primary-glow)}
.faq-group{display:none}.faq-group.active{display:block}
.faq-item{border:1px solid var(--border);border-radius:var(--radius);margin-bottom:10px;overflow:hidden;transition:border-color .2s}
.faq-item:hover{border-color:var(--primary)}
.faq-q{padding:18px 20px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between;align-items:center;background:var(--surface-0);user-select:none;font-size:.93rem}
.faq-q .arrow{transition:transform .3s;color:var(--text-muted);font-size:.8rem;flex-shrink:0;margin-left:12px}
.faq-item.open .faq-q .arrow{transform:rotate(180deg)}
.faq-item.open{border-color:var(--primary)}
.faq-a{max-height:0;overflow:hidden;transition:max-height .35s ease}
.faq-item.open .faq-a{max-height:400px}
.faq-a-inner{padding:0 20px 18px;color:var(--text-muted);line-height:1.75;font-size:.88rem}
.still-need{background:var(--surface-0);border:1px solid var(--border);border-radius:var(--radius-lg);padding:36px;text-align:center;margin-top:48px}
.still-need h3{font-family:'Syne',sans-serif;font-size:1.2rem;font-weight:800;margin-bottom:8px}
.still-need p{color:var(--text-muted);margin-bottom:20px;font-size:.9rem}
@media(max-width:600px){.faq-wrap{padding:32px 16px}.page-hero{padding:40px 16px}}
</style>
</head>
<body>
<%@ include file="/Views/common/navbar.jsp" %>

<div class="page-hero fade-up">
  <h1>Frequently Asked Questions</h1>
  <p>Everything you need to know about AeroSphere — quick answers to common questions.</p>
</div>

<div class="faq-wrap">
  <div class="faq-tabs">
    <button class="faq-tab active" onclick="showTab('general',this)">General</button>
    <button class="faq-tab" onclick="showTab('booking',this)">Booking</button>
    <button class="faq-tab" onclick="showTab('payment',this)">Payment & Refunds</button>
    <button class="faq-tab" onclick="showTab('baggage',this)">Baggage</button>
    <button class="faq-tab" onclick="showTab('account',this)">Account</button>
    <button class="faq-tab" onclick="showTab('safety',this)">Safety & Policies</button>
  </div>

  <div class="faq-group active" id="tab-general">
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What is AeroSphere? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">AeroSphere is a premium online airline booking platform that lets you search, book, and manage domestic flights with ease. Our platform offers real-time seat selection, secure payments, and digital invoicing.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Is AeroSphere available on mobile? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Yes! Our website is fully responsive and works seamlessly on all devices — smartphones, tablets, and desktops. Simply open your browser and visit our site.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Which routes does AeroSphere cover? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">AeroSphere currently covers major domestic routes across India including Delhi, Mumbai, Bangalore, Hyderabad, Chennai, Kolkata, Pune, Ahmedabad, Jaipur, and many more. New routes are added regularly.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Do I need to create an account to book? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Yes, a registered account is required to complete a booking. Registration is free, quick, and only requires your name, email, and phone number with OTP verification.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">How do I contact AeroSphere? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">You can reach us through our Contact Us page. Fill out the form with your query and our team will respond to your email within 24–48 hours.</div></div></div>
  </div>

  <div class="faq-group" id="tab-booking">
    <div class="faq-item"><div class="faq-q" onclick="t(this)">How far in advance can I book a flight? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">You can book flights up to 90 days in advance. We recommend booking early to get the best seat availability, especially during peak travel seasons.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Can I select my seat during booking? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Yes! After selecting your flight, you'll be directed to our interactive seat map where you can pick your preferred seat. Available seats are shown in green, occupied ones in red.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Can I book a return flight? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Currently, each booking is one-way. To book a return trip, simply make two separate bookings — one for the outward journey and one for the return.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What happens after I book? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Once your payment is confirmed, you'll receive a booking confirmation email with your flight details. You can also view and download your invoice from the "My Bookings" section.</div></div></div>
  </div>

  <div class="faq-group" id="tab-payment">
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What payment options are available? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">We accept all major credit cards (Visa, Mastercard, Amex), debit cards, UPI (Google Pay, PhonePe, Paytm), net banking, and popular digital wallets — all processed securely through Razorpay.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Is my payment information secure? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Absolutely. We do not store any card or payment details on our servers. All payments are processed through Razorpay which is PCI-DSS compliant and uses 256-bit encryption.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">My payment failed but money was deducted. What do I do? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">This is rare and usually auto-reverses within 5–7 business days. If the amount isn't refunded, please contact us via the Contact Us page with your transaction ID and we'll resolve it promptly.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Can I get an invoice for my booking? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Yes! A PDF invoice is available for every confirmed booking. Go to "My Bookings" and click the Invoice button next to your booking. You can download or print it directly.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">When will I receive my refund? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Refunds are processed within 3–5 business days after admin approval. The amount is credited back to your original payment method. You'll receive an email notification once approved.</div></div></div>
  </div>

  <div class="faq-group" id="tab-baggage">
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What is the standard baggage allowance? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Economy: 15 kg check-in + 7 kg cabin baggage per person. Business: 25 kg check-in + 10 kg cabin baggage per person. Infants (under 2 years) get 10 kg check-in baggage.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What are the cabin baggage size limits? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Cabin bags must not exceed 55 cm × 40 cm × 20 cm and must fit in the overhead bin. Personal items (laptop bag, handbag) are allowed in addition to the standard cabin allowance.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What items are not allowed on board? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">The following are strictly prohibited: guns and ammunition, sharp objects in cabin baggage, flammable materials, compressed gases, lithium batteries above 100Wh in check-in, and liquids over 100ml in cabin baggage.</div></div></div>
  </div>

  <div class="faq-group" id="tab-account">
    <div class="faq-item"><div class="faq-q" onclick="t(this)">How do I change my password? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Go to your Profile page and click "Edit Profile". You can update your password from there. Make sure to choose a strong password with at least 8 characters.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Can I delete my account? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Account deletion requests can be submitted via the Contact Us page. Note that deleting your account will also remove all booking history and you will not be able to access past invoices.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">I'm not receiving OTP emails. What should I do? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Check your spam/junk folder first. OTPs are valid for 10 minutes. If you still don't receive it, try again after 2 minutes or contact our support team.</div></div></div>
  </div>

  <div class="faq-group" id="tab-safety">
    <div class="faq-item"><div class="faq-q" onclick="t(this)">Is AeroSphere a safe platform? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">Yes. We use HTTPS encryption for all communications, CSRF protection on all forms, secure session management, and bcrypt password hashing. Your data is never shared with third parties without consent.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What is your privacy policy? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">We collect only the minimum data necessary to process bookings. Your personal information is used solely for flight booking, confirmation emails, and customer support. See our full Privacy Policy for details.</div></div></div>
    <div class="faq-item"><div class="faq-q" onclick="t(this)">What is your cancellation policy? <span class="arrow">▾</span></div><div class="faq-a"><div class="faq-a-inner">&gt;24h before departure: 100% refund. 2–24h before departure: 50% refund. &lt;2h before departure: No refund. All cancellations are processed through your account under "My Bookings".</div></div></div>
  </div>

  <div class="still-need fade-up">
    <h3>Didn't find your answer?</h3>
    <p>Our support team is happy to help. Send us a message and we'll get back to you within 24–48 hours.</p>
    <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap">
      <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">📧 Contact Us</a>
      <a href="${pageContext.request.contextPath}/help" class="btn btn-ghost">📖 Help Center</a>
    </div>
  </div>
</div>

<%@ include file="/Views/common/Footer.jsp" %>
<script src="${pageContext.request.contextPath}/assests/js/main.js"></script>
<script>
function t(el){
  var item=el.parentElement;
  var was=item.classList.contains('open');
  el.closest('.faq-group').querySelectorAll('.faq-item.open').forEach(function(i){i.classList.remove('open');});
  if(!was) item.classList.add('open');
}
function showTab(id,btn){
  document.querySelectorAll('.faq-group').forEach(function(g){g.classList.remove('active');});
  document.querySelectorAll('.faq-tab').forEach(function(b){b.classList.remove('active');});
  document.getElementById('tab-'+id).classList.add('active');
  btn.classList.add('active');
}
</script>
</body>
</html>
