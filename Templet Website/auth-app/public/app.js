/* ═══════════════════════════════════════════════════════════════
   AuthFlow — Multi-Role Frontend JavaScript
   Handles: role routing, sessions, login/register, dashboards,
            admin panel-switching, persistent no-logout sessions
═══════════════════════════════════════════════════════════════ */

'use strict';

// ─── State ───────────────────────────────────────────────────
let currentRole    = null;   // 'admin' | 'client' | 'student'
let currentSession = null;   // { username, email, role, loggedInAt }
let adminViewingAs = null;   // When admin views client/student panel
let currentTab     = 'login';
let allUsersCache  = [];     // Admin user table cache

// ─── Session Storage Keys ─────────────────────────────────────
const SESSION_KEY = 'authflow_session';

// ─── On Page Load ─────────────────────────────────────────────
window.addEventListener('DOMContentLoaded', () => {
  checkExistingSession();
});

async function checkExistingSession() {
  try {
    const res = await fetch('/api/me', { credentials: 'include' });
    if (res.ok) {
      const data = await res.json();
      if (data.success) {
        currentSession = data.user;
        currentRole    = data.user.role;
        showDashboard(data.user);
        return;
      }
    }
  } catch (_) { /* no session */ }
  // No active session — show landing
  showView('viewLanding');
}

// ═══════════════════════════════════════════════════════════════
// VIEW ROUTER
// ═══════════════════════════════════════════════════════════════
function showView(viewId) {
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  const target = document.getElementById(viewId);
  if (target) target.classList.add('active');
}

// ═══════════════════════════════════════════════════════════════
// ROLE SELECTION (Landing Page)
// ═══════════════════════════════════════════════════════════════
function selectRole(role) {
  currentRole    = role;
  adminViewingAs = null;

  // Theme the auth panel
  const authPanel = document.getElementById('authPanel');
  authPanel.className = 'auth-panel role-' + role;

  // Set role badge
  const badge     = document.getElementById('authRoleBadge');
  const roleEmoji = { admin: '👑', client: '👤', student: '🎓' };
  const roleLabel = { admin: 'Admin Panel', client: 'Client Panel', student: 'Student Panel' };
  badge.className = 'auth-role-badge ' + role + '-badge';
  badge.textContent = roleEmoji[role] + ' ' + roleLabel[role];

  // Logo theming
  const logoIcon = document.getElementById('authLogoIcon');
  logoIcon.className = 'logo-icon ' + role + '-logo';

  // Tab switcher: hide for admin (no registration)
  const tabSwitcher = document.getElementById('tabSwitcher');
  const loginDivider   = document.getElementById('loginDivider');
  const loginSwitchText = document.getElementById('loginSwitchText');

  if (role === 'admin') {
    tabSwitcher.style.display = 'none';
    if (loginDivider)    loginDivider.style.display    = 'none';
    if (loginSwitchText) loginSwitchText.style.display = 'none';
  } else {
    tabSwitcher.style.display = '';
    if (loginDivider)    loginDivider.style.display    = '';
    if (loginSwitchText) loginSwitchText.style.display = '';
  }

  // Set form titles
  const titles    = { admin: 'Admin Sign In', client: 'Client Sign In', student: 'Student Sign In' };
  const subtitles = { admin: 'Restricted access — Admin only', client: 'Sign in to your client account', student: 'Sign in to your student account' };
  document.getElementById('loginTitle').textContent    = titles[role];
  document.getElementById('loginSubtitle').textContent = subtitles[role];

  // Always start on login tab
  switchTab('login');

  showView('viewAuth');
}

function goBack() {
  clearAllErrors();
  document.getElementById('loginForm').reset();
  document.getElementById('registerForm').reset();
  updateStrength('');
  showView('viewLanding');
}

// ═══════════════════════════════════════════════════════════════
// TAB SWITCHING
// ═══════════════════════════════════════════════════════════════
function switchTab(tab) {
  currentTab = tab;
  const loginForm   = document.getElementById('loginForm');
  const registerForm = document.getElementById('registerForm');
  const loginTab    = document.getElementById('loginTab');
  const registerTab = document.getElementById('registerTab');
  const tabIndicator = document.getElementById('tabIndicator');

  if (tab === 'login') {
    loginForm.classList.add('active');
    registerForm.classList.remove('active');
    loginTab.classList.add('active');
    registerTab.classList.remove('active');
    tabIndicator.classList.remove('shifted');
  } else {
    registerForm.classList.add('active');
    loginForm.classList.remove('active');
    registerTab.classList.add('active');
    loginTab.classList.remove('active');
    tabIndicator.classList.add('shifted');
  }
  clearAllErrors();
}

// ═══════════════════════════════════════════════════════════════
// PASSWORD VISIBILITY
// ═══════════════════════════════════════════════════════════════
function togglePassword(inputId, btn) {
  const input = document.getElementById(inputId);
  const isPassword = input.type === 'password';
  input.type = isPassword ? 'text' : 'password';
  btn.innerHTML = isPassword
    ? `<svg class="eye-icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
        <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
        <line x1="1" y1="1" x2="23" y2="23"/>
       </svg>`
    : `<svg class="eye-icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
        <circle cx="12" cy="12" r="3"/>
       </svg>`;
}

// ═══════════════════════════════════════════════════════════════
// PASSWORD STRENGTH
// ═══════════════════════════════════════════════════════════════
document.getElementById('regPassword').addEventListener('input', function () {
  updateStrength(this.value);
});

function updateStrength(password) {
  let score = 0;
  if (password.length >= 6)  score++;
  if (password.length >= 10) score++;
  if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score++;
  if (/[0-9]/.test(password)) score++;
  if (/[^A-Za-z0-9]/.test(password)) score++;

  const level       = score <= 1 ? 1 : score <= 2 ? 2 : score <= 3 ? 3 : 4;
  const labels      = ['', 'Weak', 'Fair', 'Good', 'Strong'];
  const colors      = ['', 'weak', 'fair', 'good', 'strong'];
  const labelColors = ['', '#e05252', '#f59e0b', '#f97316', '#22c55e'];

  for (let i = 1; i <= 4; i++) {
    const seg = document.getElementById(`seg${i}`);
    seg.className = 'seg' + (i <= level && password.length > 0 ? ` ${colors[level]}` : '');
  }

  const lbl = document.getElementById('strengthLabel');
  lbl.textContent  = password.length > 0 ? labels[level] : 'Strength';
  lbl.style.color  = password.length > 0 ? labelColors[level] : '';
}

// ═══════════════════════════════════════════════════════════════
// LOGIN
// ═══════════════════════════════════════════════════════════════
async function handleLogin(e) {
  e.preventDefault();
  clearAllErrors();

  const username   = document.getElementById('loginUsername').value.trim();
  const password   = document.getElementById('loginPassword').value;
  const rememberMe = document.getElementById('rememberMe').checked;

  let hasError = false;
  if (!username) { setError('loginUsernameError', 'Username is required.'); setInputError('loginUsername'); hasError = true; }
  if (!password) { setError('loginPasswordError', 'Password is required.'); setInputError('loginPassword'); hasError = true; }
  if (hasError) return;

  setLoading('loginBtn', true);
  try {
    const res  = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ username, password, rememberMe, role: currentRole }),
    });
    const data = await res.json();

    if (data.success) {
      currentSession = data.user;
      showToast(data.message, 'success');
      setTimeout(() => {
        document.getElementById('loginForm').reset();
        showDashboard(data.user);
      }, 600);
    } else {
      showToast(data.message, 'error');
      setInputError('loginUsername');
      setInputError('loginPassword');
    }
  } catch (_) {
    showToast('Network error. Is the server running?', 'error');
  } finally {
    setLoading('loginBtn', false);
  }
}

// ═══════════════════════════════════════════════════════════════
// REGISTER
// ═══════════════════════════════════════════════════════════════
async function handleRegister(e) {
  e.preventDefault();
  clearAllErrors();

  const username        = document.getElementById('regUsername').value.trim();
  const email           = document.getElementById('regEmail').value.trim();
  const password        = document.getElementById('regPassword').value;
  const confirmPassword = document.getElementById('regConfirmPassword').value;

  let hasError = false;
  if (!username || username.length < 3) { setError('regUsernameError', 'Username must be at least 3 characters.'); setInputError('regUsername'); hasError = true; }
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email || !emailRegex.test(email)) { setError('regEmailError', 'Enter a valid email address.'); setInputError('regEmail'); hasError = true; }
  if (!password || password.length < 6)  { setError('regPasswordError', 'Password must be at least 6 characters.'); setInputError('regPassword'); hasError = true; }
  if (password !== confirmPassword)       { setError('regConfirmPasswordError', 'Passwords do not match.'); setInputError('regConfirmPassword'); hasError = true; }
  if (hasError) return;

  setLoading('registerBtn', true);
  try {
    const res  = await fetch('/api/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ username, email, password, confirmPassword, role: currentRole }),
    });
    const data = await res.json();

    if (data.success) {
      showToast('✅ ' + data.message + ' Please sign in.', 'success');
      document.getElementById('registerForm').reset();
      updateStrength('');
      setTimeout(() => switchTab('login'), 1500);
    } else {
      showToast(data.message, 'error');
    }
  } catch (_) {
    showToast('Network error. Is the server running?', 'error');
  } finally {
    setLoading('registerBtn', false);
  }
}

// ═══════════════════════════════════════════════════════════════
// DASHBOARD — show correct panel based on role
// ═══════════════════════════════════════════════════════════════
function showDashboard(user) {
  const role = user.role;
  currentRole    = role;
  currentSession = user;

  if (role === 'admin') {
    populateAdminDashboard(user);
    showView('viewAdmin');
    loadAdminUsers();
  } else if (role === 'client') {
    populateClientDashboard(user);
    showView('viewClient');
  } else if (role === 'student') {
    populateStudentDashboard(user);
    showView('viewStudent');
  }
}

/* ── Admin Dashboard ────────────────────────────────── */
function populateAdminDashboard(user) {
  document.getElementById('adminAvatarChip').textContent  = user.username.charAt(0).toUpperCase();
  document.getElementById('adminUsernameChip').textContent = user.username;
  document.getElementById('adminWelcomeName').textContent  = user.username;
}

async function loadAdminUsers() {
  try {
    const res  = await fetch('/api/admin/users', { credentials: 'include' });
    const data = await res.json();
    if (!data.success) return;

    const clients  = data.users.client  || [];
    const students = data.users.student || [];
    allUsersCache  = [
      ...clients.map(u  => ({ ...u, role: 'client' })),
      ...students.map(u => ({ ...u, role: 'student' })),
    ];

    document.getElementById('statClients').textContent  = clients.length;
    document.getElementById('statStudents').textContent = students.length;
    document.getElementById('statTotal').textContent    = clients.length + students.length;

    renderUserTable('all');
  } catch (_) {
    document.getElementById('adminUserTable').innerHTML = '<div class="table-empty">Failed to load users.</div>';
  }
}

function filterUsers(type) {
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  const btn = document.getElementById('filter' + type.charAt(0).toUpperCase() + type.slice(1));
  if (btn) btn.classList.add('active');
  renderUserTable(type);
}

function renderUserTable(filter) {
  const list = filter === 'all' ? allUsersCache : allUsersCache.filter(u => u.role === filter);
  const wrap = document.getElementById('adminUserTable');

  if (!list.length) {
    wrap.innerHTML = `<div class="table-empty">No ${filter === 'all' ? '' : filter} users registered yet.</div>`;
    return;
  }

  wrap.innerHTML = list.map(u => `
    <div class="user-row">
      <div class="user-row-avatar av-${u.role}">${u.username.charAt(0).toUpperCase()}</div>
      <div>
        <div class="user-row-name">${escHtml(u.username)}</div>
        <div class="user-row-email">${escHtml(u.email)}</div>
      </div>
      <div class="user-row-date">${formatDate(u.createdAt)}</div>
      <span class="user-row-role ${u.role}-role">${u.role}</span>
    </div>
  `).join('');
}

/* ── Client Dashboard ───────────────────────────────── */
function populateClientDashboard(user, isAdminViewing = false) {
  document.getElementById('clientAvatarChip').textContent   = user.username.charAt(0).toUpperCase();
  document.getElementById('clientUsernameChip').textContent  = user.username;
  document.getElementById('clientWelcomeName').textContent   = user.username;

  // Show/hide admin back button
  const adminBack = document.getElementById('clientAdminBack');
  const logoutBtn = document.getElementById('clientLogoutBtn');
  if (isAdminViewing) {
    adminBack.style.display = '';
    logoutBtn.style.display = 'none';
  } else {
    adminBack.style.display = 'none';
    logoutBtn.style.display = '';
  }

  // Session rows
  const rows = document.getElementById('clientSessionRows');
  rows.innerHTML = buildSessionRow('Logged in as', user.username)
    + buildSessionRow('Email',       user.email)
    + buildSessionRow('Panel',       'Client Panel')
    + buildSessionRow('Login time',  formatDate(user.loggedInAt));
}

/* ── Student Dashboard ──────────────────────────────── */
function populateStudentDashboard(user, isAdminViewing = false) {
  document.getElementById('studentAvatarChip').textContent   = user.username.charAt(0).toUpperCase();
  document.getElementById('studentUsernameChip').textContent  = user.username;
  document.getElementById('studentWelcomeName').textContent   = user.username;

  const adminBack = document.getElementById('studentAdminBack');
  const logoutBtn = document.getElementById('studentLogoutBtn');
  if (isAdminViewing) {
    adminBack.style.display = '';
    logoutBtn.style.display = 'none';
  } else {
    adminBack.style.display = 'none';
    logoutBtn.style.display = '';
  }

  const rows = document.getElementById('studentSessionRows');
  rows.innerHTML = buildSessionRow('Logged in as', user.username)
    + buildSessionRow('Email',       user.email)
    + buildSessionRow('Panel',       'Student Panel')
    + buildSessionRow('Login time',  formatDate(user.loggedInAt));
}

function buildSessionRow(key, val, highlight = false) {
  return `<div class="session-row">
    <span class="session-row-key">${key}</span>
    <span class="session-row-val${highlight ? ' highlight' : ''}">${val}</span>
  </div>`;
}

// ═══════════════════════════════════════════════════════════════
// ADMIN PANEL SWITCHING (no logout needed)
// ═══════════════════════════════════════════════════════════════
function adminViewPanel(targetRole) {
  if (!currentSession || currentSession.role !== 'admin') return;

  adminViewingAs = targetRole;

  // Create a "view as" user object to populate the target dashboard
  const viewUser = {
    username:   currentSession.username,
    email:      currentSession.email,
    role:       targetRole,
    loggedInAt: currentSession.loggedInAt,
  };

  if (targetRole === 'client') {
    populateClientDashboard(viewUser, true);
    showView('viewClient');
    showToast(`👀 Viewing Client Panel as Admin`, 'info');
  } else if (targetRole === 'student') {
    populateStudentDashboard(viewUser, true);
    showView('viewStudent');
    showToast(`👀 Viewing Student Panel as Admin`, 'info');
  }
}

function returnToAdmin() {
  adminViewingAs = null;
  showView('viewAdmin');
  loadAdminUsers();
  showToast('↩ Returned to Admin Panel', 'info');
}

// ═══════════════════════════════════════════════════════════════
// LOGOUT
// ═══════════════════════════════════════════════════════════════
async function handleLogout() {
  try {
    const res  = await fetch('/api/logout', { method: 'POST', credentials: 'include' });
    const data = await res.json();

    if (data.success) {
      currentSession = null;
      currentRole    = null;
      adminViewingAs = null;
      showToast('Logged out successfully.', 'info');
      setTimeout(() => {
        showView('viewLanding');
      }, 600);
    }
  } catch (_) {
    showToast('Logout failed. Try again.', 'error');
  }
}

// ═══════════════════════════════════════════════════════════════
// TOAST NOTIFICATIONS
// ═══════════════════════════════════════════════════════════════
let toastTimer = null;

function showToast(message, type = 'info') {
  const toast    = document.getElementById('toast');
  const toastMsg = document.getElementById('toastMsg');
  toast.className = `toast ${type}`;
  toastMsg.textContent = message;
  toast.classList.add('show');
  if (toastTimer) clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.remove('show'), 3500);
}

// ═══════════════════════════════════════════════════════════════
// FORM HELPERS
// ═══════════════════════════════════════════════════════════════
function setError(id, msg) {
  const el = document.getElementById(id);
  if (el) el.textContent = '⚠ ' + msg;
}

function setInputError(id) {
  const input = document.getElementById(id);
  if (input) input.classList.add('error');
}

function clearAllErrors() {
  document.querySelectorAll('.field-error').forEach(el => el.textContent = '');
  document.querySelectorAll('input.error').forEach(el => el.classList.remove('error'));
}

function setLoading(btnId, loading) {
  const btn    = document.getElementById(btnId);
  if (!btn) return;
  const text   = btn.querySelector('.btn-text');
  const loader = btn.querySelector('.btn-loader');
  btn.disabled = loading;
  if (text)   text.hidden   = loading;
  if (loader) loader.hidden = !loading;
}

// Clear errors on input
document.querySelectorAll('input').forEach(input => {
  input.addEventListener('input', () => {
    input.classList.remove('error');
    const group = input.closest('.form-group');
    if (group) {
      const err = group.querySelector('.field-error');
      if (err) err.textContent = '';
    }
  });
});

// ─── Utilities ───────────────────────────────────────────────
function formatDate(iso) {
  if (!iso || iso === 'N/A') return 'N/A';
  try {
    return new Date(iso).toLocaleString('en-IN', { dateStyle: 'medium', timeStyle: 'short' });
  } catch (_) { return iso; }
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
