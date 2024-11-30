const mysql = require('mysql2');

// Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'kaddict.345',
    database: 'Vendor_Contract_Management_System'
});

db.connect((err) => {
    if (err) throw err;
    console.log("Database connected successfully.");
});

module.exports = db;
