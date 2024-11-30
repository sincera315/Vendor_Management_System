const express = require('express');
const Contract = require('../models/contractModel');
const router = express.Router();

router.post('/create', (req, res) => {
  Contract.createContract([
    req.body.ContractName,
    req.body.StartDate,
    req.body.EndDate,
    req.body.VendorId
  ], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Contract created successfully!', result });
  });
});

module.exports = router;