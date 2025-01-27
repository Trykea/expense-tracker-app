const express = require("express");
const router = express.Router();
const db = require("../database.js");

// Add a new expense
router.post("/", (req, res) => {
  const { userId, title, amount, category, date, notes } = req.body;

  if (!userId || !title || !amount || !category || !date) {
    return res.status(400).json({
      error: "userId, title, amount, category, and date are required",
    });
  }

  db.run(
    "INSERT INTO EXPENSE (USER_ID, TITLE, AMOUNT, CATEGORY, DATE, NOTES) VALUES (?, ?, ?, ?, ?, ?)",
    [userId, title, amount, category, date, notes],
    function (err) {
      if (err) {
        console.error("Database error:", err.message);
        return res.status(500).json({ error: "Failed to add expense" });
      }
      res
        .status(201)
        .json({ message: "Expense added successfully", id: this.lastID });
    }
  );
});

// Get all expenses for a user
router.get("/", (req, res) => {
  const userId = req.user.id;

  db.all(
    "SELECT ID, TITLE, AMOUNT, CATEGORY, DATE, NOTES FROM EXPENSE WHERE USER_ID = ?",
    [userId],
    (err, rows) => {
      if (err) {
        console.error("Database error:", err.message);
        return res.status(500).json({ error: "Failed to fetch expenses" });
      }
      res.json(rows);
    }
  );
});

// Delete an expense
router.delete("/:id", (req, res) => {
  const id = req.params.id;
  const userId = req.user.id;

  db.run(
    "DELETE FROM EXPENSE WHERE ID = ? AND USER_ID = ?",
    [id, userId],
    function (err) {
      if (err) {
        console.error("Database error:", err.message);
        return res.status(500).json({ error: "Failed to delete expense" });
      }
      if (this.changes === 0) {
        return res
          .status(404)
          .json({ error: "Expense not found or unauthorized" });
      }
      res.json({ message: "Expense deleted successfully" });
    }
  );
});

module.exports = router;
