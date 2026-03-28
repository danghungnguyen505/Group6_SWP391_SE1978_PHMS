(function () {
  function ready(fn) {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', fn);
    } else {
      fn();
    }
  }

  function ensureStyles() {
    if (document.getElementById('phms-account-menu-style')) return;
    var css = '' +
      '.phms-account-wrap{position:relative;display:inline-block;z-index:9999;}' +
      '.phms-account-trigger{display:inline-flex;align-items:center;gap:8px;padding:9px 14px;border-radius:10px;border:1px solid #dbe4ee;background:#ffffff;color:#0f172a;font-weight:700;font-size:13px;line-height:1;cursor:pointer;white-space:nowrap;}' +
      '.phms-account-trigger:hover{border-color:#10b981;color:#065f46;}' +
      '.phms-account-trigger i{color:#10b981;}' +
      '.phms-account-menu{position:absolute;right:0;top:calc(100% + 8px);min-width:220px;background:#fff;border:1px solid #e2e8f0;border-radius:10px;box-shadow:0 10px 30px rgba(2,6,23,.12);padding:6px;display:none;}' +
      '.phms-account-menu.open{display:block;}' +
      '.phms-account-item{display:flex;align-items:center;gap:8px;padding:9px 10px;border-radius:8px;color:#1e293b;text-decoration:none;font-size:13px;font-weight:600;}' +
      '.phms-account-item:hover{background:#f8fafc;color:#0f766e;}' +
      '.phms-account-item.logout{color:#b91c1c;}' +
      '.phms-account-item.logout:hover{background:#fef2f2;color:#991b1b;}';

    var style = document.createElement('style');
    style.id = 'phms-account-menu-style';
    style.textContent = css;
    document.head.appendChild(style);
  }

  function buildMenu(contextPath, lang) {
    var vi = lang && lang.toLowerCase().indexOf('vi') === 0;
    var menu = document.createElement('div');
    menu.className = 'phms-account-menu';
    menu.innerHTML = '' +
      '<a class="phms-account-item" href="' + contextPath + '/profile"><i class="fa-solid fa-user"></i>' + (vi ? 'Xem hồ sơ' : 'View Profile') + '</a>' +
      '<a class="phms-account-item" href="' + contextPath + '/change-password"><i class="fa-solid fa-key"></i>' + (vi ? 'Đổi mật khẩu' : 'Change Password') + '</a>' +
      '<a class="phms-account-item logout" href="' + contextPath + '/logout"><i class="fa-solid fa-right-from-bracket"></i>' + (vi ? 'Đăng xuất' : 'Logout') + '</a>';
    return menu;
  }

  function detectContextPath(logoutHref) {
    var idx = logoutHref.lastIndexOf('/logout');
    if (idx <= 0) return '';
    return logoutHref.substring(0, idx);
  }

  function transformLogoutAnchor(anchor, fullName) {
    if (!anchor || !fullName || anchor.dataset.accountMenuEnhanced === '1') return;
    anchor.dataset.accountMenuEnhanced = '1';

    var href = anchor.getAttribute('href') || '';
    var contextPath = detectContextPath(href);
    var lang = document.documentElement.getAttribute('lang') || 'en';

    var wrap = document.createElement('div');
    wrap.className = 'phms-account-wrap';

    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'phms-account-trigger';
    btn.innerHTML = '<i class="fa-solid fa-user-circle"></i><span>' + fullName + '</span><i class="fa-solid fa-chevron-down"></i>';

    var menu = buildMenu(contextPath, lang);

    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      menu.classList.toggle('open');
    });

    wrap.appendChild(btn);
    wrap.appendChild(menu);

    anchor.parentNode.insertBefore(wrap, anchor);
    anchor.parentNode.removeChild(anchor);

    document.addEventListener('click', function () {
      menu.classList.remove('open');
    });

    menu.addEventListener('click', function (e) {
      e.stopPropagation();
    });
  }

  ready(function () {
    var account = window.__PHMS_ACCOUNT || {};
    var fullName = (account.fullName || '').trim();
    if (!fullName) return;

    ensureStyles();

    var anchors = Array.prototype.slice.call(document.querySelectorAll('a[href*="/logout"]'));
    anchors.forEach(function (a) {
      transformLogoutAnchor(a, fullName);
    });
  });
})();
