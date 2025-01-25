const jwt = require("jsonwebtoken");
const JWT_SECRET = process.env.JWT_SECRET; // Ensure this matches your secret key

const authMiddleware = (req, res, next) => {
  const token = req.header("Authorization");
  console.log("Token:", token); // Log the token

  if (!token) {
    return res.status(401).json({ error: "Access denied. No token provided." });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    console.log("Decoded:", decoded); // Log the decoded payload
    req.user = decoded;
    next();
  } catch (err) {
    console.error("Token verification failed:", err); // Log the error
    res.status(400).json({ error: "Invalid token." });
  }
};

module.exports = authMiddleware;
