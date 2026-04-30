const express = require('express');
const { checkPermission } = require('../../../middleware/permission');
const controller = require('../controller/request.controller');
const router = express.Router();

// USER: create request
router.post('/', checkPermission('CREATE_REQUEST'), controller.createRequest);
// USER: get own requests
router.get('/my', checkPermission('READ_OWN_REQUEST'), controller.getMyRequests);
// MANAGER/ADMIN: get all requests
router.get('/', checkPermission('READ_ALL_REQUESTS'), controller.getAllRequests);
// MANAGER/ADMIN: update request (approve/reject)
router.patch('/:id', checkPermission('APPROVE_REQUEST'), controller.updateRequest);

module.exports = router;
