<%-- ═══════════════════════════════════════════════════════════════
     AeroSphere — footer.jsp
     Include with: <%@ include file="/Views/common/footer.jsp" %>
     ════════════════════════════════════════════════════════════════ --%>
<%@ page contentType="text/html;charset=UTF-8" %>

<footer class="as-footer" role="contentinfo">
  <div class="as-footer-inner">
    <div class="as-footer-grid">

      <%-- Brand Column --%>
      <div>
        <div class="as-footer-brand-name">Aero<span class="accent">Sphere</span></div>
        <p class="as-footer-tagline">
          Your premium airline booking experience. Search, book, and manage flights
          with confidence and comfort.
        </p>
        <div class="as-footer-social" aria-label="Social media links">
          <a href="#" title="Twitter / X" aria-label="Follow us on Twitter">
            <span aria-hidden="true">𝕏</span>
          </a>
          <a href="#" title="LinkedIn" aria-label="Connect on LinkedIn">
            <span aria-hidden="true">in</span>
          </a>
          <a href="#" title="Facebook" aria-label="Follow on Facebook">
            <span aria-hidden="true">f</span>
          </a>
          <a href="#" title="Instagram" aria-label="Follow on Instagram">
            <span aria-hidden="true">📷</span>
          </a>
        </div>
      </div>

      <%-- Quick Links --%>
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

      <%-- Support --%>
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

      <%-- Legal --%>
      <div>
        <p class="as-footer-col-title">Legal</p>
        <ul class="as-footer-col-links">
          <li><a href="#">Privacy Policy</a></li>
          <li><a href="#">Terms of Service</a></li>
          <li><a href="#">Cookie Policy</a></li>
          <li><a href="#">Disclaimer</a></li>
        </ul>
      </div>

    </div>

    <%-- Bottom bar --%>
    <div class="as-footer-bottom">
      <p class="as-footer-copy">
        &copy; <%= new java.util.Date().getYear() + 1900 %> AeroSphere. All rights reserved.
        Built with ☕ and passion.
      </p>
      <div class="as-footer-bottom-links">
        <a href="#">Privacy</a>
        <a href="#">Terms</a>
        <a href="#">Cookies</a>
      </div>
    </div>
  </div>
</footer>
