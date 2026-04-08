const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({ status: "ok", message: "Hello from Node.js API!" });
});

app.get('/health', (req, res) => {
  res.json({ status: "healthy" });
});

app.listen(port, () => {
  console.log(`API listening on port ${port}`);
});
