const requestRepository = require('../repository/request.repository');

async function createRequest(data) {
  return requestRepository.createRequest(data);
}

async function getRequestById(id) {
  return requestRepository.getRequestById(id);
}

async function getRequestsByUser(userId) {
  return requestRepository.getRequestsByUser(userId);
}

async function getAllRequests({ filter, skip, take, orderBy }) {
  return requestRepository.getAllRequests({ filter, skip, take, orderBy });
}

async function updateRequest(id, data) {
  return requestRepository.updateRequest(id, data);
}

module.exports = {
  createRequest,
  getRequestById,
  getRequestsByUser,
  getAllRequests,
  updateRequest,
};
