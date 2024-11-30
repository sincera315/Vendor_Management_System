const db = require('../config/db');

class Vendor {
  static registerVendor(vendorData, callback) {
    const query = `CALL RegisterVendor(?, ?, ?, ?, ?)`;
    db.query(query, vendorData, callback);
  }
}

module.exports = Vendor;