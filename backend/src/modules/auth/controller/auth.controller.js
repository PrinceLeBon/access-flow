const userRepository = require('../repository/user.repository');
const authService = require('../service/auth.service');
const { registerSchema, loginSchema } = require('../validation/auth.validation');

async function register(req, res, next) {
  try {
    const parsed = registerSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ success: false, message: 'Validation error', code: 'VALIDATION_ERROR', errors: parsed.error.errors });
    }
    const { email, password, name } = parsed.data;
    const existing = await userRepository.findByEmail(email);
    if (existing) {
      return res.status(409).json({ success: false, message: 'Email already registered', code: 'EMAIL_EXISTS' });
    }
    const hashed = await authService.hashPassword(password);
    const user = await userRepository.createUser({ email, password: hashed, name, role: 'USER' });
    return res.status(201).json({ success: true, message: 'User registered', user: { id: user.id, email: user.email, name: user.name } });
  } catch (err) {
    next(err);
  }
}

async function login(req, res, next) {
  try {
    const parsed = loginSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ success: false, message: 'Validation error', code: 'VALIDATION_ERROR', errors: parsed.error.errors });
    }
    const { email, password } = parsed.data;
    const user = await userRepository.findByEmail(email);
    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid credentials', code: 'INVALID_CREDENTIALS' });
    }
    const valid = await authService.comparePassword(password, user.password);
    if (!valid) {
      return res.status(401).json({ success: false, message: 'Invalid credentials', code: 'INVALID_CREDENTIALS' });
    }
    const accessToken = authService.generateAccessToken(user);
    const refreshToken = authService.generateRefreshToken(user);
    return res.json({ success: true, accessToken, refreshToken });
  } catch (err) {
    next(err);
  }
}

module.exports = { register, login };
