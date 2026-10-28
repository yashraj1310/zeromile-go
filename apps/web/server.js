/**
 * =========================================================================
 * ZEROMILE GO - SIMPLE PRODUCTION SERVER (server.js)
 * Reads .env file and serves the web platform + dynamic config securely
 * =========================================================================
 */

import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 1. Simple .env parser (Zero external dependencies)
function loadEnv() {
  const envPath = path.join(__dirname, '.env');
  if (fs.existsSync(envPath)) {
    const content = fs.readFileSync(envPath, 'utf8');
    content.split('\n').forEach(line => {
      const trimmed = line.trim();
      if (trimmed && !trimmed.startsWith('#') && trimmed.includes('=')) {
        const [key, ...vals] = trimmed.split('=');
        const val = vals.join('=').trim().replace(/^["']|["']$/g, '');
        if (key && !process.env[key.trim()]) {
          process.env[key.trim()] = val;
        }
      }
    });
  }
}

loadEnv();

const PORT = process.env.PORT || 8080;
const PUBLIC_DIR = fs.existsSync(path.join(__dirname, 'dist')) ? path.join(__dirname, 'dist') : __dirname;

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.ico': 'image/x-icon',
  '.webp': 'image/webp'
};

const server = http.createServer((req, res) => {
  // CORS & Security Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'SAMEORIGIN');

  const safeUrl = decodeURI(req.url.split('?')[0]);

  // 2. Dynamic runtime config endpoint (Injected directly from .env)
  if (safeUrl === '/config.js') {
    const configContent = `
(function(window) {
  'use strict';
  window.CONFIG = Object.freeze({
    MAPBOX_ACCESS_TOKEN: '${process.env.MAPBOX_ACCESS_TOKEN || ''}',
    SUPABASE_URL: '${process.env.SUPABASE_URL || ''}',
    SUPABASE_ANON_KEY: '${process.env.SUPABASE_ANON_KEY || ''}',
    DEFAULT_COORDS: {
      NAGPUR_ZERO_MILE: { lat: 21.1498, lng: 79.0806 },
      VNIT_CAMPUS: { lat: 21.1280, lng: 79.0520 }
    }
  });
})(typeof window !== 'undefined' ? window : this);
`;
    res.writeHead(200, { 'Content-Type': 'text/javascript; charset=utf-8' });
    res.end(configContent);
    return;
  }

  // 3. API Config JSON endpoint
  if (safeUrl === '/api/config') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      MAPBOX_ACCESS_TOKEN: process.env.MAPBOX_ACCESS_TOKEN,
      SUPABASE_URL: process.env.SUPABASE_URL,
      SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY
    }));
    return;
  }

  // 4. Static Files
  let targetFile = safeUrl === '/' ? '/index.html' : safeUrl;
  let filePath = path.join(PUBLIC_DIR, targetFile);

  if (!filePath.startsWith(PUBLIC_DIR)) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      filePath = path.join(PUBLIC_DIR, 'index.html');
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    res.writeHead(200, { 'Content-Type': contentType });
    fs.createReadStream(filePath).pipe(res);
  });
});

server.listen(PORT, () => {
  console.log(`\n========================================================`);
  console.log(`🚀 ZeroMile Go Server Running: http://localhost:${PORT}`);
  console.log(`🔐 Environment Variables Loaded from .env`);
  console.log(`========================================================\n`);
});
