const requestService = require('../service/request.service');
const { createRequestSchema, updateRequestSchema } = require('../validation/request.validation');

// Helper to extract user from req (set by permission middleware)
function getUser(req) {
  return req.user;
}

async function createRequest(req, res, next) {
  try {
    const parsed = createRequestSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ success: false, message: 'Validation error', code: 'VALIDATION_ERROR', errors: parsed.error.errors });
    }
    const user = getUser(req);
    const data = { ...parsed.data, createdById: user.id };
    const request = await requestService.createRequest(data);
    return res.status(201).json({ success: true, request });
  } catch (err) {
    next(err);
  }
}

async function getMyRequests(req, res, next) {
  try {
    const user = getUser(req);
    const requests = await requestService.getRequestsByUser(user.id);
    return res.json({ success: true, requests });
  } catch (err) {
    next(err);
  }
}

const { getPagination } = require('../../../utils/pagination');

async function getAllRequests(req, res, next) {
  try {
    const { status, type, from, to } = req.query;
    const filter = {};
    if (status) filter.status = status;
    if (type) filter.type = type;
    if (from || to) {
      filter.createdAt = {};
      if (from) filter.createdAt.gte = new Date(from);
      if (to) filter.createdAt.lte = new Date(to);
    }
    const { skip, take } = getPagination(req.query);
    const requests = await requestService.getAllRequests({ filter, skip, take, orderBy: { createdAt: 'desc' } });
    return res.json({ success: true, requests });
  } catch (err) {
    next(err);
  }
}

async function updateRequest(req, res, next) {
  try {
    const parsed = updateRequestSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ success: false, message: 'Validation error', code: 'VALIDATION_ERROR', errors: parsed.error.errors });
    }
    const { id } = req.params;
    const updated = await requestService.updateRequest(id, parsed.data);
    return res.json({ success: true, request: updated });
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createRequest,
  getMyRequests,
  getAllRequests,
  updateRequest,
};
