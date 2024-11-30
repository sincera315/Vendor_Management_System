// const express = require('express');
// const Vendor = require('../models/vendorModel');
// const router = express.Router();

// router.post('/register', (req, res) => {
//   Vendor.registerVendor([
//     req.body.VendorName,
//     req.body.ContactInfo,
//     req.body.EmailAddress,
//     req.body.ComplianceCertifications,
//     req.body.PerformanceRating
//   ], (err, result) => {
//     if (err) return res.status(500).json({ error: err.message });
//     res.status(201).json({ message: 'Vendor registered successfully!', result });
//   });
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const Vendor = require('../models/vendorModel'); // Adjust the path as needed

// Route to handle vendor registration
router.post('/register', (req, res) => {
    const { VendorName, ContactInfo, EmailAddress, ComplianceCertifications, PerformanceRating } = req.body;

    const vendorData = [
        VendorName,
        ContactInfo,
        EmailAddress,
        ComplianceCertifications,
        PerformanceRating
    ];

    Vendor.RegisterVendor(vendorData, (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ message: 'Failed to add data to the database.' });
        }
        res.status(200).json({ message: 'Data has been added to the database successfully!' });
    });
});

module.exports = router;