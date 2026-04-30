require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimiter = require('./middleware/rateLimiter');
const jwtAuth = require('./middleware/jwtAuth');
const globalErrorHandler = require('./errors/globalErrorHandler');
const logger = require('./utils/logger');
const setupSwagger = require('./config/swagger');


const app = express();
setupSwagger(app);
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(rateLimiter);

// Log incoming requests
app.use((req, res, next) => {
  logger.info({ method: req.method, url: req.url, user: req.user?.id }, 'Incoming request');
  next();
});

// Auth routes (public)
app.use('/api/auth', require('./modules/auth/routes/auth.routes'));
// Requests routes (protected)
app.use('/api/requests', jwtAuth, require('./modules/requests/routes/request.routes'));
// RBAC test (protected)
app.use('/api/rbac-test', jwtAuth, require('./modules/auth/routes/rbac.test.routes'));

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Error handling
app.use((err, req, res, next) => {
  logger.error({ err }, 'Unhandled error');
  globalErrorHandler(err, req, res, next);
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});
