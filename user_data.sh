#!/bin/bash
yum update -y
yum install -y nodejs npm

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

cat << 'EOF' > index.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Hello DevOps!' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
EOF

cat << 'EOF' > package.json
{
  "name": "simple-app",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": { "start": "node index.js" },
  "dependencies": { "express": "4.18.2" }
}
EOF

npm install
node index.js &
