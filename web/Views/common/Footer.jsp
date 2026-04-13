<%-- AeroSphere Footer.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
.as-footer{background:var(--card-bg);border-top:1px solid var(--border);margin-top:auto}
.as-footer-inner{max-width:1200px;margin:0 auto;padding:40px 32px 24px}
.as-footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:32px;margin-bottom:32px}
.as-footer-brand{font-family:'Syne',sans-serif;font-weight:800;font-size:1.2rem;background:var(--grad);-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:10px}
.as-footer-tagline{color:var(--text-muted);font-size:.83rem;line-height:1.6;max-width:260px}
.as-footer-social{display:flex;gap:8px;margin-top:14px}
.as-footer-social a{width:34px;height:34px;border-radius:9px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:14px;text-decoration:none;color:var(--text-muted);transition:all .2s}
.as-footer-social a:hover{border-color:var(--sky);color:var(--sky)}
.as-footer-col-title{font-family:'Syne',sans-serif;font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--text);margin-bottom:12px}
.as-footer-col-links{list-style:none;display:flex;flex-direction:column;gap:7px}
.as-footer-col-links a{text-decoration:none;color:var(--text-muted);font-size:.83rem;transition:color .2s}
.as-footer-col-links a:hover{color:var(--sky)}
.as-footer-bottom{display:flex;align-items:center;justify-content:space-between;padding-top:20px;border-top:1px solid var(--border);flex-wrap:wrap;gap:8px}
.as-footer-copy{font-size:.78rem;color:var(--text-muted)}
.as-footer-bottom-links{display:flex;gap:16px}
.as-footer-bottom-links a{font-size:.78rem;color:var(--text-muted);text-decoration:none}
.as-footer-bottom-links a:hover{color:var(--sky)}
@media(max-width:700px){.as-footer-grid{grid-template-columns:1fr 1fr}.as-footer-inner{padding:28px 16px 16px}}
</style>
<footer class="as-footer" role="contentinfo">
  <div class="as-footer-inner">
    <div class="as-footer-grid">
      <div>
        <div class="as-footer-brand">AeroSphere</div>
        <p class="as-footer-tagline">Your premium airline booking experience. Search, book, and manage flights with confidence.</p>
        <div class="as-footer-social">
          <a href="#" title="Twitter">𝕏</a>
          <a href="#" title="LinkedIn">in</a>
          <a href="#" title="Facebook">f</a>
          <a href="#" title="Instagram">📷</a>
        </div>
      </div>
      <div>
        <p class="as-footer-col-title">Quick Links</p>
        <ul class="as-footer-col-links">
          <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
          <li><a href="${pageContext.request.contextPath}/searchFlights">Search Flights</a></li>
          <li><a href="${pageContext.request.contextPath}/userBookings">My Bookings</a></li>
          <li><a href="${pageContext.request.contextPath}/userRefundHistory">Refund History</a></li>
          <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li>
        </ul>
      </div>
      <div>
        <p class="as-footer-col-title">Support</p>
        <ul class="as-footer-col-links">
          <li><a href="#">Help Center</a></li>
          <li><a href="#">FAQs</a></li>
          <li><a href="#">Cancellation Policy</a></li>
          <li><a href="#">Baggage Policy</a></li>
          <li><a href="#">Contact Us</a></li>
        </ul>
      </div>
      <div>
        <p class="as-footer-col-title">Legal</p>
        <ul class="as-footer-col-links">
          <li><a href="#">Privacy Policy</a></li>
          <li><a href="#">Terms of Service</a></li>
          <li><a href="#">Cookie Policy</a></li>
        </ul>
      </div>
    </div>
    <div class="as-footer-bottom">
      <p class="as-footer-copy">&copy; <%= new java.util.Date().getYear()+1900 %> AeroSphere. All rights reserved.</p>
      <div class="as-footer-bottom-links">
        <a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a>
      </div>
    </div>
  </div>
</footer>
