const express = require('express');
const { createClient } = require('redis');
const app = express();
const port = 3000;

// Connect to Redis
const redisClient = createClient({
  url: process.env.REDIS_URL || 'redis://localhost:6379'
});

redisClient.on('error', (err) => console.log('Redis Client Error', err));
redisClient.connect().catch(console.error);

app.get('/', (req, res) => {
  res.json({ status: "ok", message: "Hello from Node.js API!" });
});

app.get('/health', (req, res) => {
  res.json({ status: "healthy" });
});

// Mock user endpoint with caching
app.get('/users/:id', async (req, res) => {
  const userId = req.params.id;
  
  try {
    const cachedUser = await redisClient.get(`user:${userId}`);
    if (cachedUser) {
      return res.json({ source: 'cache', data: JSON.parse(cachedUser) });
    }
    
    // Mock user database fetch
    const user = { id: userId, name: `User ${userId}`, email: `user${userId}@example.com` };
    
    // Store in cache for 60 seconds
    await redisClient.setEx(`user:${userId}`, 60, JSON.stringify(user));
    
    return res.json({ source: 'database', data: user });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`API listening on port ${port}`);
});
