/**
 * DevSecOps Demo Application
 * A sample Express.js REST API demonstrating automated security testing
 */

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const morgan = require('morgan');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const Joi = require('joi');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

// Serve static frontend files
app.use(express.static('public'));

// Security middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('combined'));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.'
});
app.use('/api/', limiter);

// In-memory user store (for demo purposes)
const users = [];

// Validation schemas
const registerSchema = Joi.object({
  username: Joi.string().alphanum().min(3).max(30).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required()
});

const loginSchema = Joi.object({
  username: Joi.string().required(),
  password: Joi.string().required()
});

// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token' });
    }
    req.user = user;
    next();
  });
};

// Routes
// Root route - commented out to serve static HTML frontend instead
// app.get('/', (req, res) => {
//   res.json({
//     message: 'DevSecOps Demo API',
//     description: 'Automated Security Testing Pipeline',
//     version: '1.0.0',
//     security_tools: [
//       'OWASP Dependency-Check (SCA)',
//       'SonarQube (SAST)',
//       'Trivy (Container Scanning)'
//     ]
//   });
// });

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// User registration endpoint
app.post('/api/auth/register', async (req, res) => {
  try {
    // Validate input
    const { error, value } = registerSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const { username, email, password } = value;

    // Check if user already exists
    const existingUser = users.find(u => u.username === username || u.email === email);
    if (existingUser) {
      return res.status(409).json({ error: 'User already exists' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const user = {
      id: users.length + 1,
      username,
      email,
      password: hashedPassword,
      createdAt: new Date().toISOString()
    };

    users.push(user);

    // Return success (don't return password)
    const { password: _, ...userWithoutPassword } = user;
    res.status(201).json({
      message: 'User registered successfully',
      user: userWithoutPassword
    });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// User login endpoint
app.post('/api/auth/login', async (req, res) => {
  try {
    // Validate input
    const { error, value } = loginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const { username, password } = value;

    // Find user
    const user = users.find(u => u.username === username);
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Verify password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id, username: user.username },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login successful',
      token,
      expiresIn: '24h'
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Protected route example
app.get('/api/profile', authenticateToken, (req, res) => {
  const user = users.find(u => u.id === req.user.id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  const { password: _, ...userWithoutPassword } = user;
  res.json({
    message: 'Profile retrieved successfully',
    user: userWithoutPassword
  });
});

// API documentation endpoint
app.get('/api/docs', (req, res) => {
  res.json({
    endpoints: [
      { method: 'GET', path: '/', description: 'API information' },
      { method: 'GET', path: '/api/health', description: 'Health check' },
      { method: 'POST', path: '/api/auth/register', description: 'Register new user' },
      { method: 'POST', path: '/api/auth/login', description: 'User login' },
      { method: 'GET', path: '/api/profile', description: 'Get user profile (protected)' },
      { method: 'GET', path: '/api/docs', description: 'API documentation' }
    ]
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Start server
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`🚀 DevSecOps Demo API running on port ${PORT}`);
    console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`🔒 Security features enabled`);
    console.log(`📝 API Documentation: http://localhost:${PORT}/api/docs`);
  });
}

module.exports = app;
