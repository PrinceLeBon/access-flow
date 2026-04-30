const jwt = require('jsonwebtoken');
const { ROLE_PERMISSIONS } = require('../core/roles');

const JWT_SECRET = process.env.JWT_SECRET || 'changeme';

function checkPermission(permission) {
  return (req, res, next) => {
    const authHeader = req.headers['authorization'];
    if (!authHeader) {
      return res.status(401).json({ success: false, message: 'No token provided', code: 'NO_TOKEN' });
    }
    const token = authHeader.split(' ')[1];
    if (!token) {
      return res.status(401).json({ success: false, message: 'Malformed token', code: 'MALFORMED_TOKEN' });
    }
    let user;
    try {
      user = jwt.verify(token, JWT_SECRET);
    } catch (err) {
      return res.status(401).json({ success: false, message: 'Invalid token', code: 'INVALID_TOKEN' });
    }
    req.user = user;
    const permissions = ROLE_PERMISSIONS[user.role] || [];
    if (permissions.includes('*') || permissions.includes(permission)) {
      return next();
    }
    return res.status(403).json({ success: false, message: 'Forbidden', code: 'FORBIDDEN' });
  };
}

module.exports = { checkPermission };
