const { checkPermission } = require('../../../middleware/permission');
const express = require('express');
const router = express.Router();

// Example protected route for testing RBAC
router.get('/protected', checkPermission('APPROVE_REQUEST'), (req, res) => {
  res.json({ success: true, message: 'You have APPROVE_REQUEST permission', user: req.user });
});

module.exports = router;
