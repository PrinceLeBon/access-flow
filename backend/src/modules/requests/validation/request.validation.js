const { z } = require('zod');

const createRequestSchema = z.object({
  type: z.enum(['WITHDRAW', 'DEPOSIT', 'ACCESS']),
  amount: z.number().optional(),
  resource: z.string().optional(),
  reason: z.string().min(5),
});

const updateRequestSchema = z.object({
  status: z.enum(['PENDING', 'APPROVED', 'REJECTED']).optional(),
  rejectionReason: z.string().optional(),
});

module.exports = {
  createRequestSchema,
  updateRequestSchema,
};
