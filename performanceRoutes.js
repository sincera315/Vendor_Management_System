const express = require('express');
const Performance = require('../models/performanceModel');
const router = express.Router();

router.post('/evaluate', (req, res) => {
  Performance.evaluatePerformance([
    req.body.VendorId,
    req.body.PerformanceRating,
    req.body.Comments
  ], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Performance evaluated successfully!', result });
  });
});

module.exports = router;