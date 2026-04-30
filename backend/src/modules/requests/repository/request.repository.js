const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

module.exports = {
  async createRequest(data) {
    return prisma.request.create({ data });
  },
  async getRequestById(id) {
    return prisma.request.findUnique({ where: { id } });
  },
  async getRequestsByUser(userId) {
    return prisma.request.findMany({ where: { createdById: userId } });
  },
  async getAllRequests({ filter = {}, skip = 0, take = 10, orderBy = { createdAt: 'desc' } }) {
    return prisma.request.findMany({ where: filter, skip, take, orderBy });
  },
  async updateRequest(id, data) {
    return prisma.request.update({ where: { id }, data });
  },
};
