<%-- AeroSphere Footer.jsp (Premium UI v4) --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
.as-footer{background:var(--surface-0);border-top:1px solid var(--border);margin-top:auto}
.as-footer-inner{max-width:1200px;margin:0 auto;padding:40px 32px 24px}
.as-footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:32px;margin-bottom:32px}
.as-footer-brand{font-family:'Fraunces',serif;font-weight:500;font-size:1.2rem;color:var(--text);margin-bottom:10px}
.as-footer-tagline{color:var(--text-muted);font-size:.83rem;line-height:1.6;max-width:260px}
.as-footer-social{display:flex;gap:8px;margin-top:14px}
.as-footer-social a{width:34px;height:34px;border-radius:9px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:14px;text-decoration:none;color:var(--text-muted);transition:all .2s}
.as-footer-social a:hover{border-color:var(--primary);color:var(--primary)}
.as-footer-col-title{font-family:'Fraunces',serif;font-size:.8rem;font-weight:500;text-transform:uppercase;letter-spacing:.07em;color:var(--text);margin-bottom:12px}
.as-footer-col-links{list-style:none;display:flex;flex-direction:column;gap:7px}
.as-footer-col-links a{text-decoration:none;color:var(--text-muted);font-size:.83rem;transition:color .2s}
.as-footer-col-links a:hover{color:var(--primary)}
.as-footer-bottom{display:flex;align-items:center;justify-content:space-between;padding-top:20px;border-top:1px solid var(--border);flex-wrap:wrap;gap:8px}
.as-footer-copy{font-size:.78rem;color:var(--text-muted)}
.as-footer-bottom-links{display:flex;gap:16px}
.as-footer-bottom-links a{font-size:.78rem;color:var(--text-muted);text-decoration:none}
.as-footer-bottom-links a:hover{color:var(--primary)}
@media(max-width:700px){.as-footer-grid{grid-template-columns:1fr 1fr}.as-footer-inner{padding:28px 16px 16px}}
</style>
<footer class="as-footer" role="contentinfo">
  <div class="as-footer-inner">
    <div class="as-footer-grid">
      <div>
        <div class="as-footer-brand">AeroSphere</div>
        <p class="as-footer-tagline">Your premium airline booking experience. Search, book, and manage flights with confidence.</p>
        <div class="as-footer-social">
          <a href="#" title="Twitter"><i class="ph-bold ph-x-logo"></i></a>
          <a href="#" title="LinkedIn"><i class="ph-bold ph-linkedin-logo"></i></a>
          <a href="#" title="Facebook"><i class="ph-bold ph-facebook-logo"></i></a>
          <a href="#" title="Instagram"><i class="ph-bold ph-instagram-logo"></i></a>
        </div>
      </div>
      <div>
        <p class="as-footer-col-title">Quick Links</p>
        <ul class="as-footer-col-links">
          <li><a href="${pageContext.request.contextPath}/">Home</a></li>
          <li><a href="${pageContext.request.contextPath}/searchFlights">Search Flights</a></li>
          <li><a href="${pageContext.request.contextPath}/allFlights">All Flights</a></li>
          <li><a href="${pageContext.request.contextPath}/userBookings">My Bookings</a></li>
          <li><a href="${pageContext.request.contextPath}/userRefundHistory">Refund History</a></li>
        </ul>
      </div>
      <div>
        <p class="as-footer-col-title">Support</p>
        <ul class="as-footer-col-links">
          <li><a href="${pageContext.request.contextPath}/help">Help Center</a></li>
          <li><a href="${pageContext.request.contextPath}/faqs">FAQs</a></li>
          <li><a href="${pageContext.request.contextPath}/cancellationPolicy">Cancellation Policy</a></li>
          <li><a href="${pageContext.request.contextPath}/baggagePolicy">Baggage Policy</a></li>
          <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
        </ul>
      </div>
      <div>
        <p class="as-footer-col-title">Legal</p>
        <ul class="as-footer-col-links">
          <li><a href="${pageContext.request.contextPath}/privacyPolicy">Privacy Policy</a></li>
          <li><a href="${pageContext.request.contextPath}/termsOfService">Terms of Service</a></li>
          <li><a href="${pageContext.request.contextPath}/cookiePolicy">Cookie Policy</a></li>
        </ul>
      </div>
    </div>
    <div class="as-footer-bottom">
      <p class="as-footer-copy">&copy; <%= new java.util.Date().getYear()+1900 %> AeroSphere. All rights reserved.</p>
      <div class="as-footer-bottom-links">
        <a href="${pageContext.request.contextPath}/privacyPolicy">Privacy</a>
        <a href="${pageContext.request.contextPath}/termsOfService">Terms</a>
        <a href="${pageContext.request.contextPath}/cookiePolicy">Cookies</a>
      </div>
    </div>
  </div>
</footer>
