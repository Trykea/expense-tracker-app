const express = require("express");
const app = express();
const port = 3000;
const db = require("./database.js");
const authRoutes = require("./routes/auth");
const expenseRoutes = require("./routes/expense");
const authMiddleware = require("./middleware/authMiddleware");

// Middleware to parse JSON requests
app.use(express.json());

// Routes
app.use("/auth", authRoutes);
app.use("/expenses", authMiddleware, expenseRoutes);

// Basic route for testing
app.get("/", (req, res) => {
  res.send("Expense Tracker Backend is running!");
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
