const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const vendorRoutes = require('./routes/vendorRoutes');
const contractRoutes = require('./routes/contractRoutes');
const purchaseOrderRoutes = require('./routes/purchaseOrderRoutes');
const performanceRoutes = require('./routes/performanceRoutes');
const path = require('path');

const app = express();
const port = 8080;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public'))); // Serve static files

// Serve the main page (index.html) at the root URL
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

// API routes
app.use('/api/vendors', vendorRoutes);
app.use('/api/contracts', contractRoutes);
app.use('/api/purchase-orders', purchaseOrderRoutes);
app.use('/api/performance', performanceRoutes);

// Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'kaddict.345',
    database: 'Vendor_Contract_Management_System'
});

db.connect((err) => {
    if (err) throw err;
    console.log("Connected to MySQL database!");
});

// Start the server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});