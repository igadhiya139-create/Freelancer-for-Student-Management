const express = require('express');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const bcrypt = require('bcryptjs');
const path = require('path');

const app = express();
const PORT = 3000;

// ─── In-Memory User Stores (keyed by role) ────────────────────────────────────
const users = {
  admin:   {},
  client:  {},
  student: {},
};

// ─── Seed default Admin user ──────────────────────────────────────────────────
(async () => {
  const hashedPw = await bcrypt.hash('Admin@123', 10);
  users.admin['admin'] = {
    username:  'admin',
    email:     'admin@authflow.com',
    password:  hashedPw,
    role:      'admin',
    createdAt: new Date().toISOString(),
  };
  console.log('\n✅ Default admin seeded → username: admin  |  password: Admin@123');
})();

// ─── Middleware ────────────────────────────────────────────────────────────────
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser('cookie-secret-key-2024'));

app.use(
  session({
    secret: 'session-super-secret-key-2024',
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: false,
      httpOnly: true,
      maxAge: 1000 * 60 * 60 * 24 * 7,  // 7 days default
      sameSite: 'lax',
    },
    name: 'auth.session',
  })
);

app.use(express.static(path.join(__dirname, 'public')));

// ─── Auth Guard Middleware ─────────────────────────────────────────────────────
function requireAuth(req, res, next) {
  if (req.session && req.session.user) return next();
  return res.status(401).json({ success: false, message: 'Unauthorized. Please log in.' });
}

function requireAdmin(req, res, next) {
  if (req.session && req.session.user && req.session.user.role === 'admin') return next();
  return res.status(403).json({ success: false, message: 'Admin access required.' });
}

// ─── ROUTES ───────────────────────────────────────────────────────────────────

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ─── POST /api/register ───────────────────────────────────────────────────────
app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password, confirmPassword, role } = req.body;

    // Admin cannot be registered via form
    if (!role || !['client', 'student'].includes(role)) {
      return res.status(400).json({ success: false, message: 'Invalid role. Must be client or student.' });
    }

    if (!username || !email || !password || !confirmPassword) {
      return res.status(400).json({ success: false, message: 'All fields are required.' });
    }

    if (username.trim().length < 3) {
      return res.status(400).json({ success: false, message: 'Username must be at least 3 characters.' });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ success: false, message: 'Invalid email address.' });
    }

    if (password.length < 6) {
      return res.status(400).json({ success: false, message: 'Password must be at least 6 characters.' });
    }

    if (password !== confirmPassword) {
      return res.status(400).json({ success: false, message: 'Passwords do not match.' });
    }

    const key = username.toLowerCase();

    if (users[role][key]) {
      return res.status(409).json({ success: false, message: 'Username already taken in this panel.' });
    }

    const emailExists = Object.values(users[role]).some(u => u.email === email.toLowerCase());
    if (emailExists) {
      return res.status(409).json({ success: false, message: 'Email already registered in this panel.' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    users[role][key] = {
      username:  username.trim(),
      email:     email.toLowerCase(),
      password:  hashedPassword,
      role,
      createdAt: new Date().toISOString(),
    };

    console.log(`[REGISTER] ${role.toUpperCase()}: ${username} <${email}>`);

    res.cookie(`registered_${role}`, username, {
      signed:  true,
      maxAge:  1000 * 60 * 15,
      httpOnly: false,
    });

    return res.status(201).json({
      success: true,
      message: `Registration successful! Welcome to the ${role} panel.`,
      role,
    });
  } catch (err) {
    console.error('[REGISTER ERROR]', err);
    return res.status(500).json({ success: false, message: 'Internal server error.' });
  }
});

// ─── POST /api/login ──────────────────────────────────────────────────────────
app.post('/api/login', async (req, res) => {
  try {
    const { username, password, role, rememberMe } = req.body;

    if (!role || !['admin', 'client', 'student'].includes(role)) {
      return res.status(400).json({ success: false, message: 'Invalid role.' });
    }

    if (!username || !password) {
      return res.status(400).json({ success: false, message: 'Username and password are required.' });
    }

    const key = username.toLowerCase();
    const user = users[role][key];

    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid username or password.' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid username or password.' });
    }

    req.session.user = {
      username:   user.username,
      email:      user.email,
      role:       user.role,
      loggedInAt: new Date().toISOString(),
    };

    // Admin viewing another panel (admin stays admin, but views as that panel)
    req.session.viewingAs = role;

    if (rememberMe) {
      req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 30; // 30 days
    }

    res.cookie('last_login', new Date().toISOString(), {
      maxAge:   1000 * 60 * 60 * 24 * 30,
      httpOnly: false,
    });

    res.cookie(`${role}_last_login`, new Date().toISOString(), {
      maxAge:   1000 * 60 * 60 * 24 * 30,
      httpOnly: false,
    });

    console.log(`[LOGIN] ${role.toUpperCase()}: ${user.username} | Session: ${req.sessionID}`);

    return res.json({
      success: true,
      message: `Welcome${role === 'admin' ? ', Admin' : ' back'}, ${user.username}!`,
      user: { username: user.username, email: user.email, role: user.role, loggedInAt: req.session.user.loggedInAt },
    });
  } catch (err) {
    console.error('[LOGIN ERROR]', err);
    return res.status(500).json({ success: false, message: 'Internal server error.' });
  }
});

// ─── POST /api/logout ─────────────────────────────────────────────────────────
app.post('/api/logout', (req, res) => {
  const username = req.session?.user?.username || 'Unknown';
  const role     = req.session?.user?.role     || 'unknown';

  req.session.destroy(err => {
    if (err) return res.status(500).json({ success: false, message: 'Logout failed.' });
    res.clearCookie('auth.session');
    console.log(`[LOGOUT] ${role.toUpperCase()}: ${username}`);
    return res.json({ success: true, message: 'Logged out successfully.' });
  });
});

// ─── GET /api/me ──────────────────────────────────────────────────────────────
app.get('/api/me', requireAuth, (req, res) => {
  const { username, email, role, loggedInAt } = req.session.user;
  const lastLogin = req.cookies['last_login'] || 'N/A';

  return res.json({
    success: true,
    user: { username, email, role, loggedInAt },
    cookies: { sessionId: req.sessionID, lastLogin },
  });
});

// ─── GET /api/admin/users ─────────────────────────────────────────────────────
// Admin sees all users across all panels
app.get('/api/admin/users', requireAuth, requireAdmin, (req, res) => {
  const result = {};
  for (const role of ['client', 'student']) {
    result[role] = Object.values(users[role]).map(({ username, email, createdAt }) => ({
      username, email, createdAt,
    }));
  }
  return res.json({ success: true, users: result });
});

// ─── GET /api/users (panel-specific) ─────────────────────────────────────────
app.get('/api/users', requireAuth, (req, res) => {
  const role = req.session.user.role;
  if (role === 'admin') {
    // Return all
    const all = {};
    for (const r of ['client', 'student']) {
      all[r] = Object.values(users[r]).map(({ username, email, createdAt }) => ({ username, email, createdAt }));
    }
    return res.json({ success: true, users: all });
  }
  const safeUsers = Object.values(users[role]).map(({ username, email, createdAt }) => ({
    username, email, createdAt,
  }));
  return res.json({ success: true, totalUsers: safeUsers.length, users: safeUsers });
});

// ─── GET /api/session-info ────────────────────────────────────────────────────
app.get('/api/session-info', requireAuth, (req, res) => {
  return res.json({
    success:      true,
    sessionData:  req.session,
    sessionId:    req.sessionID,
    allCookies:   req.cookies,
    signedCookies: req.signedCookies,
  });
});

// ─── Start Server ─────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🚀 Multi-Role Auth Server running at http://localhost:${PORT}`);
  console.log(`   Roles: Admin 👑 | Client 👤 | Student 🎓`);
  console.log(`   Default admin → username: admin | password: Admin@123\n`);
});
