/* ═══════════════════════════════════════════════════════════════
   AeroSphere — main.js  (UI interactions only, no business logic)
   ═══════════════════════════════════════════════════════════════ */
'use strict';

/* ─── 1. THEME ──────────────────────────────────────────────── */
const AS = {
  THEME_KEY: 'asTheme',

  initTheme() {
    const saved = localStorage.getItem(this.THEME_KEY);
    const pref  = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    const theme = saved || pref;
    document.documentElement.setAttribute('data-theme', theme);
    this._syncThemeIcons(theme);
  },

  toggleTheme() {
    const cur  = document.documentElement.getAttribute('data-theme') || 'light';
    const next = cur === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem(this.THEME_KEY, next);
    this._syncThemeIcons(next);
  },

  _syncThemeIcons(theme) {
    document.querySelectorAll('.theme-toggle').forEach(btn => {
      btn.textContent = theme === 'dark' ? '☀️' : '🌙';
      btn.setAttribute('aria-label', `Switch to ${theme === 'dark' ? 'light' : 'dark'} mode`);
    });
  }
};

/* ─── 2. NAVBAR SCROLL ──────────────────────────────────────── */
function initNavbarScroll() {
  const navbar = document.querySelector('.navbar');
  if (!navbar) return;
  const onScroll = () => {
    navbar.classList.toggle('scrolled', window.scrollY > 20);
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
}

/* ─── 3. HAMBURGER / MOBILE NAV ─────────────────────────────── */
function initMobileNav() {
  const hamburger = document.getElementById('as-hamburger');
  const mobileNav = document.getElementById('as-mobile-nav');
  if (!hamburger || !mobileNav) return;

  hamburger.addEventListener('click', () => {
    const open = mobileNav.classList.toggle('open');
    hamburger.classList.toggle('open', open);
    hamburger.setAttribute('aria-expanded', open);
  });

  // Close on link click
  mobileNav.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => {
      mobileNav.classList.remove('open');
      hamburger.classList.remove('open');
    });
  });

  // Close on outside click
  document.addEventListener('click', e => {
    if (!hamburger.contains(e.target) && !mobileNav.contains(e.target)) {
      mobileNav.classList.remove('open');
      hamburger.classList.remove('open');
    }
  });
}

/* ─── 4. SIDEBAR TOGGLE (Admin) ─────────────────────────────── */
function initSidebar() {
  const sidebar  = document.getElementById('as-sidebar');
  const overlay  = document.getElementById('as-sidebar-overlay');
  const toggle   = document.getElementById('as-sidebar-toggle');
  if (!sidebar) return;

  const open  = () => { sidebar.classList.add('open');    if (overlay) overlay.classList.add('active'); };
  const close = () => { sidebar.classList.remove('open'); if (overlay) overlay.classList.remove('active'); };

  if (toggle) toggle.addEventListener('click', () => sidebar.classList.contains('open') ? close() : open());
  if (overlay) overlay.addEventListener('click', close);

  // Keyboard Escape
  document.addEventListener('keydown', e => { if (e.key === 'Escape') close(); });
}

/* ─── 5. BUTTON RIPPLE ──────────────────────────────────────── */
function initRipple() {
  document.querySelectorAll('.btn-primary, .btn-lg, .btn-full').forEach(btn => {
    btn.addEventListener('click', function(e) {
      const r   = document.createElement('span');
      const rect= this.getBoundingClientRect();
      const size= Math.max(rect.width, rect.height);
      r.className = 'btn-ripple';
      r.style.cssText = `width:${size}px;height:${size}px;left:${e.clientX-rect.left-size/2}px;top:${e.clientY-rect.top-size/2}px`;
      this.appendChild(r);
      r.addEventListener('animationend', () => r.remove());
    });
  });
}

/* ─── 6. SCROLL REVEAL ──────────────────────────────────────── */
function initScrollReveal() {
  if (!window.IntersectionObserver) return;
  const items = document.querySelectorAll('.reveal, .reveal-left, .reveal-right');
  if (!items.length) return;

  const obs = new IntersectionObserver((entries) => {
    entries.forEach(en => {
      if (en.isIntersecting) {
        en.target.classList.add('revealed');
        obs.unobserve(en.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });

  items.forEach(el => obs.observe(el));
}

/* ─── 7. COUNT-UP NUMBERS ───────────────────────────────────── */
function initCountUp() {
  if (!window.IntersectionObserver) return;
  const nums = document.querySelectorAll('.count-up');
  if (!nums.length) return;

  const easeOut = t => 1 - Math.pow(1 - t, 3);

  const animate = (el) => {
    const target = parseFloat(el.dataset.target || el.textContent.replace(/[^0-9.]/g,''));
    const prefix = el.dataset.prefix || '';
    const suffix = el.dataset.suffix || '';
    const dec    = el.dataset.decimals ? parseInt(el.dataset.decimals) : 0;
    const dur    = 1200;
    let   start  = null;

    const step = (ts) => {
      if (!start) start = ts;
      const p = Math.min((ts - start) / dur, 1);
      const v = easeOut(p) * target;
      el.textContent = prefix + v.toFixed(dec).replace(/\B(?=(\d{3})+(?!\d))/g, ',') + suffix;
      if (p < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  };

  const obs = new IntersectionObserver(entries => {
    entries.forEach(en => {
      if (en.isIntersecting) {
        animate(en.target);
        obs.unobserve(en.target);
      }
    });
  }, { threshold: 0.3 });

  nums.forEach(el => obs.observe(el));
}

/* ─── 8. TOAST NOTIFICATIONS ────────────────────────────────── */
window.AS_Toast = {
  container: null,

  _getContainer() {
    if (!this.container) {
      this.container = document.createElement('div');
      this.container.className = 'toast-container';
      document.body.appendChild(this.container);
    }
    return this.container;
  },

  show(message, type = 'info', duration = 4000) {
    const c    = this._getContainer();
    const icon = { success:'✅', error:'❌', info:'ℹ️', warning:'⚠️' }[type] || 'ℹ️';
    const t    = document.createElement('div');
    t.className = `toast toast-${type}`;
    t.innerHTML = `<span>${icon}</span><span>${message}</span>`;
    c.appendChild(t);
    setTimeout(() => {
      t.classList.add('removing');
      t.addEventListener('animationend', () => t.remove());
    }, duration);
  }
};

/* ─── 9. MODAL HELPERS ──────────────────────────────────────── */
window.AS_Modal = {
  open(id) {
    const m = document.getElementById(id);
    if (m) m.classList.add('open');
  },
  close(id) {
    const m = document.getElementById(id);
    if (m) m.classList.remove('open');
  }
};
// Close modal on overlay click
document.addEventListener('click', e => {
  if (e.target.classList.contains('modal-overlay')) {
    e.target.classList.remove('open');
  }
});
// Close on Escape
document.addEventListener('keydown', e => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-overlay.open').forEach(m => m.classList.remove('open'));
  }
});

/* ─── 10. ACTIVE NAV LINK ───────────────────────────────────── */
function initActiveNav() {
  const path = window.location.pathname;
  document.querySelectorAll('.nav-link, .as-sidebar-link').forEach(link => {
    if (link.href && link.href.includes(path) && path !== '/') {
      link.classList.add('active');
    }
  });
}

/* ─── 11. PAGE TRANSITION ───────────────────────────────────── */
function initPageTransition() {
  const main = document.querySelector('main, .page-wrapper, .as-main');
  if (main) main.classList.add('page-enter');
}

/* ─── 12. INPUT ANIMATION ───────────────────────────────────── */
function initInputAnimations() {
  // Animate input icons on focus
  document.querySelectorAll('.input-wrap input, .field-float input').forEach(inp => {
    inp.addEventListener('focus', function() {
      const icon = this.parentElement.querySelector('.input-icon, .field-icon');
      if (icon) icon.style.transform = 'translateY(-50%) scale(1.15)';
    });
    inp.addEventListener('blur', function() {
      const icon = this.parentElement.querySelector('.input-icon, .field-icon');
      if (icon) icon.style.transform = 'translateY(-50%) scale(1)';
    });
  });
}

/* ─── 13. TABLE SEARCH FILTER ───────────────────────────────── */
window.AS_FilterTable = function(inputId, tableId) {
  const inp   = document.getElementById(inputId);
  const table = document.getElementById(tableId);
  if (!inp || !table) return;
  inp.addEventListener('input', function() {
    const q = this.value.toLowerCase();
    table.querySelectorAll('tbody tr').forEach(row => {
      row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  });
};

/* ─── 14. STICKY TABLE HEADER ───────────────────────────────── */
function initStickyHeaders() {
  document.querySelectorAll('.table-wrap').forEach(wrap => {
    wrap.style.maxHeight = '';
  });
}

/* ─── INIT ──────────────────────────────────────────────────── */
(function init() {
  AS.initTheme();

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', run);
  } else {
    run();
  }

  function run() {
    initNavbarScroll();
    initMobileNav();
    initSidebar();
    initRipple();
    initScrollReveal();
    initCountUp();
    initPageTransition();
    initInputAnimations();
    initActiveNav();
    initStickyHeaders();
  }
})();
