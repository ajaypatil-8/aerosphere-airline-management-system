/**
 * AeroSphere — darkmode.js
 * Theme engine: instant apply, localStorage persistence,
 * system preference detection, mobile nav toggle, active link marking.
 *
 * Usage: <script src="${pageContext.request.contextPath}/assests/js/darkmode.js"></script>
 * Place just before </body> on any page that uses a #themeToggle button.
 *
 * Or call AeroTheme.init() manually if you need finer control.
 */

(function (global) {
  'use strict';

  /* ─── Constants ─────────────────────────────────────────────── */
  var STORAGE_KEY = 'asTheme';
  var DARK_CLASS  = 'dark-mode';           // optional body class (for legacy pages)
  var ATTR        = 'data-theme';           // html attribute approach (preferred)
  var ICON_DARK   = '🌙';
  var ICON_LIGHT  = '☀️';

  /* ─── Core: get / apply / toggle ─────────────────────────────── */
  function getSavedTheme() {
    try { return localStorage.getItem(STORAGE_KEY); } catch (e) { return null; }
  }

  function getSystemTheme() {
    return (global.matchMedia && global.matchMedia('(prefers-color-scheme: dark)').matches)
      ? 'dark' : 'light';
  }

  function applyTheme(theme) {
    // 1. Set data-theme attribute on <html> (all new pages use this)
    document.documentElement.setAttribute(ATTR, theme);

    // 2. Toggle body class for any legacy or print styles
    document.body.classList.toggle(DARK_CLASS, theme === 'dark');

    // 3. Persist
    try { localStorage.setItem(STORAGE_KEY, theme); } catch (e) {}

    // 4. Update ALL toggle buttons on the page
    document.querySelectorAll('[data-theme-toggle], #themeToggle, .theme-toggle, .as-dark-toggle')
      .forEach(function (btn) {
        btn.textContent = theme === 'dark' ? ICON_LIGHT : ICON_DARK;
        btn.setAttribute('aria-label', theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode');
        btn.setAttribute('title',      theme === 'dark' ? 'Light mode'           : 'Dark mode');
      });

    // 5. Fire a custom event so individual pages can react
    try {
      document.dispatchEvent(new CustomEvent('aerosphere:themechange', { detail: { theme: theme } }));
    } catch (e) {}
  }

  function toggleTheme() {
    var current = document.documentElement.getAttribute(ATTR) || 'light';
    applyTheme(current === 'dark' ? 'light' : 'dark');
  }

  /* ─── Instant pre-paint apply (call ASAP) ────────────────────── */
  function applyBeforePaint() {
    var saved = getSavedTheme();
    var theme = saved || getSystemTheme();
    // Set attribute directly (no body class yet — body may not exist)
    try { document.documentElement.setAttribute(ATTR, theme); } catch (e) {}
  }

  /* ─── Mobile nav hamburger ────────────────────────────────────── */
  function initMobileNav() {
    var hamburger = document.getElementById('as-hamburger') ||
                    document.querySelector('.hamburger, .as-hamburger, [data-hamburger]');
    var mobileNav = document.getElementById('as-mobile-nav') ||
                    document.querySelector('.mobile-nav, .as-mobile-nav, [data-mobile-nav]');

    if (!hamburger || !mobileNav) return;

    hamburger.addEventListener('click', function () {
      var open = mobileNav.classList.toggle('open');
      hamburger.setAttribute('aria-expanded', open ? 'true' : 'false');
      // Animate hamburger icon → X
      hamburger.classList.toggle('open', open);
    });

    // Close mobile nav on outside click
    document.addEventListener('click', function (e) {
      if (!hamburger.contains(e.target) && !mobileNav.contains(e.target)) {
        mobileNav.classList.remove('open');
        hamburger.setAttribute('aria-expanded', 'false');
        hamburger.classList.remove('open');
      }
    });
  }

  /* ─── Admin sidebar toggle (mobile) ──────────────────────────── */
  function initSidebar() {
    var sidebar  = document.getElementById('as-sidebar');
    var overlay  = document.getElementById('as-sidebar-overlay') ||
                   document.querySelector('.sidebar-overlay');
    var toggle   = document.getElementById('as-sidebar-toggle') ||
                   document.querySelector('.sidebar-toggle, [data-sidebar-toggle]');

    if (!sidebar) return;

    function openSidebar() {
      sidebar.classList.add('open');
      if (overlay) { overlay.classList.add('active'); overlay.style.display = 'block'; }
      if (toggle)  { toggle.classList.add('open'); }
    }
    function closeSidebar() {
      sidebar.classList.remove('open');
      if (overlay) { overlay.classList.remove('active'); overlay.style.display = 'none'; }
      if (toggle)  { toggle.classList.remove('open'); }
    }

    if (toggle) {
      toggle.addEventListener('click', function () {
        sidebar.classList.contains('open') ? closeSidebar() : openSidebar();
      });
    }
    if (overlay) {
      overlay.addEventListener('click', closeSidebar);
    }

    // Close sidebar on ESC
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closeSidebar();
    });
  }

  /* ─── Auto-mark active nav link ──────────────────────────────── */
  function markActiveLinks() {
    var path = global.location.pathname;
    document.querySelectorAll('a.nav-link, a.as-nav-link, a.as-sidebar-link').forEach(function (a) {
      var href = a.getAttribute('href') || '';
      // Strip context path prefix (heuristic: last segment)
      if (href.length > 1 && path.indexOf(href.split('/').pop()) !== -1) {
        a.classList.add('active');
      }
    });
  }

  /* ─── Alert auto-dismiss ──────────────────────────────────────── */
  function initAlertDismiss(ms) {
    ms = ms || 5000;
    document.querySelectorAll('.alert[data-auto-dismiss], .alert-success').forEach(function (el) {
      setTimeout(function () {
        el.style.transition = 'opacity .4s ease';
        el.style.opacity    = '0';
        setTimeout(function () { el.style.display = 'none'; }, 420);
      }, ms);
    });
  }

  /* ─── Button loading state ────────────────────────────────────── */
  function initButtonLoading() {
    document.querySelectorAll('form').forEach(function (form) {
      form.addEventListener('submit', function () {
        var btn = form.querySelector('[type="submit"], .btn-primary');
        if (btn && !btn.dataset.noLoading) {
          btn.disabled = true;
          var orig = btn.textContent;
          btn.textContent = '⏳ Processing…';
          // Re-enable after 8s fallback (in case of validation failure)
          setTimeout(function () {
            btn.disabled    = false;
            btn.textContent = orig;
          }, 8000);
        }
      });
    });
  }

  /* ─── Table sort (click header to sort) ──────────────────────── */
  function initTableSort() {
    document.querySelectorAll('.sc-table, table[data-sortable]').forEach(function (table) {
      var headers = table.querySelectorAll('thead th');
      var dir = {};
      headers.forEach(function (th, col) {
        th.style.cursor = 'pointer';
        th.title = 'Click to sort';
        th.addEventListener('click', function () {
          var tbody  = table.querySelector('tbody');
          if (!tbody) return;
          var rows   = Array.prototype.slice.call(tbody.querySelectorAll('tr'));
          dir[col]   = dir[col] === 'asc' ? 'desc' : 'asc';
          rows.sort(function (a, b) {
            var at = (a.cells[col] || {}).textContent || '';
            var bt = (b.cells[col] || {}).textContent || '';
            var an = parseFloat(at.replace(/[^0-9.-]/g, ''));
            var bn = parseFloat(bt.replace(/[^0-9.-]/g, ''));
            var cmp = (!isNaN(an) && !isNaN(bn)) ? (an - bn) : at.localeCompare(bt);
            return dir[col] === 'asc' ? cmp : -cmp;
          });
          rows.forEach(function (r) { tbody.appendChild(r); });
          // Visual indicator
          headers.forEach(function (h) { h.textContent = h.textContent.replace(/ [▲▼]$/, ''); });
          th.textContent += (dir[col] === 'asc' ? ' ▲' : ' ▼');
        });
      });
    });
  }

  /* ─── System theme change listener ───────────────────────────── */
  function watchSystemTheme() {
    if (!global.matchMedia) return;
    global.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
      // Only auto-switch if user hasn't explicitly chosen a theme
      if (!getSavedTheme()) {
        applyTheme(e.matches ? 'dark' : 'light');
      }
    });
  }

  /* ─── Public API ──────────────────────────────────────────────── */
  var AeroTheme = {

    /**
     * Call once after DOM ready. Wires all toggle buttons,
     * mobile nav, sidebar, active links, alerts, table sort.
     */
    init: function () {
      // 1. Resolve + apply stored / system theme
      var saved  = getSavedTheme();
      var theme  = saved || getSystemTheme();
      applyTheme(theme);

      // 2. Wire every toggle button
      document.querySelectorAll('[data-theme-toggle], #themeToggle, .theme-toggle, .as-dark-toggle')
        .forEach(function (btn) {
          btn.addEventListener('click', toggleTheme);
        });

      // 3. Other init helpers
      initMobileNav();
      initSidebar();
      markActiveLinks();
      initAlertDismiss();
      initButtonLoading();
      initTableSort();
      watchSystemTheme();
    },

    /** Programmatically set theme */
    setTheme: function (t) { applyTheme(t); },

    /** Get current theme */
    getTheme: function () { return document.documentElement.getAttribute(ATTR) || 'light'; },

    /** Toggle theme */
    toggle: toggleTheme
  };

  /* ─── Expose globally ─────────────────────────────────────────── */
  global.AeroTheme   = AeroTheme;
  global.toggleTheme = toggleTheme; // legacy compat — some pages call toggleTheme() directly

  /* ─── Auto-init on DOMContentLoaded ──────────────────────────── */
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', AeroTheme.init.bind(AeroTheme));
  } else {
    AeroTheme.init();
  }

}(window));
