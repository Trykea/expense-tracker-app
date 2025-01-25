const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const db = require("../database.js");
require("dotenv").config(); // Load .env file
const JWT_SECRET = process.env.JWT_SECRET;

// User Login
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  // Find the user in the database
  db.get(
    "SELECT * FROM USERS WHERE USERNAME = ?",
    [username],
    async (err, user) => {
      if (err || !user) {
        return res.status(400).json({ error: "Invalid username or password" });
      }

      // Compare the password
      const isMatch = await bcrypt.compare(password, user.HASHED_PASS);
      if (!isMatch) {
        return res.status(400).json({ error: "Invalid username or password" });
      }

      // Generate JWT token
      const token = jwt.sign(
        { id: user.ID, username: user.USERNAME },
        JWT_SECRET,
        { expiresIn: "1h" }
      );
      res.json({ token });
    }
  );
});

module.exports = router;
