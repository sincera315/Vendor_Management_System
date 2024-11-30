const db = require('../config/db');

class PurchaseOrder {
  static createPurchaseOrder(orderData, callback) {
    const query = `CALL CreatePurchaseOrder(?, ?, ?)`;
    db.query(query, orderData, callback);
  }
}

module.exports = PurchaseOrder;