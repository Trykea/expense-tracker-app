const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const db = require("../database.js");
require("dotenv").config(); // Load .env file
const JWT_SECRET = process.env.JWT_SECRET;

// User Signup
router.post("/signup", async (req, res) => {
  const { username, email, password } = req.body;

  // Validate input
  if (!username || !email || !password) {
    return res
      .status(400)
      .json({ error: "Username, email, and password are required" });
  }

  // Check if username or email already exists
  db.get(
    "SELECT * FROM USERS WHERE USERNAME = ? OR EMAIL = ?",
    [username, email],
    async (err, user) => {
      if (err) {
        console.error("Database error:", err.message);
        return res.status(500).json({ error: "Internal server error" });
      }

      if (user) {
        return res
          .status(400)
          .json({ error: "Username or email already exists" });
      }

      try {
        // Hash the password
        const hashedPass = await bcrypt.hash(password, 10);

        // Insert the new user into the database
        db.run(
          "INSERT INTO USERS (USERNAME, EMAIL, HASHED_PASS) VALUES (?, ?, ?)",
          [username, email, hashedPass],
          function (err) {
            if (err) {
              console.error("Database error:", err.message);
              return res.status(500).json({ error: "Failed to create user" });
            }

            // Generate JWT token for the new user
            const token = jwt.sign(
              { id: this.lastID, username: username },
              JWT_SECRET,
              { expiresIn: "1h" }
            );

            // Return the token and user ID
            res.status(201).json({
              message: "User created successfully",
              token: token,
              userId: this.lastID,
            });
          }
        );
      } catch (err) {
        console.error("Error hashing password:", err);
        res.status(500).json({ error: "Internal server error" });
      }
    }
  );
});

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
