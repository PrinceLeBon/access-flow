// Role and permission mapping for RBAC
const ROLE_PERMISSIONS = {
  USER: ['CREATE_REQUEST', 'READ_OWN_REQUEST'],
  MANAGER: ['APPROVE_REQUEST', 'READ_ALL_REQUESTS'],
  ADMIN: ['*'],
};

module.exports = { ROLE_PERMISSIONS };
