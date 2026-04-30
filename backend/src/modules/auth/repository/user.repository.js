const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

module.exports = {
  async findByEmail(email) {
    return prisma.user.findUnique({ where: { email } });
  },
  async createUser(data) {
    return prisma.user.create({ data });
  },
  async findById(id) {
    return prisma.user.findUnique({ where: { id } });
  },
};
