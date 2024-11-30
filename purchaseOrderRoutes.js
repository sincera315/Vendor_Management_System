const express = require('express');
const PurchaseOrder = require('../models/purchaseOrderModel');
const router = express.Router();

router.post('/create', (req, res) => {
  PurchaseOrder.createPurchaseOrder([
    req.body.OrderNumber,
    req.body.VendorId,
    req.body.OrderDetails
  ], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Purchase order created successfully!', result });
  });
});

module.exports = router;