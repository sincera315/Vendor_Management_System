const db = require('../config/db');

class Performance {
  static evaluatePerformance(performanceData, callback) {
    const query = `CALL EvaluatePerformance(?, ?, ?)`;
    db.query(query, performanceData, callback);
  }
}

module.exports = Performance;