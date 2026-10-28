# 🚀 Simple 3-Step Deployment Guide for ZeroMile Go

Deploy your application in less than 60 seconds with 0 configuration.

---

## 📁 1. Your `.env` File (Keep Keys Separate & Secure)

All your API keys and URLs are stored in **[`.env`](file:///c:/Users/yashr/OneDrive/Desktop/Vikasit%20Nagpur/web_platform/.env)**:

```env
MAPBOX_ACCESS_TOKEN=your-mapbox-token
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-token-placeholder
PORT=8080
```

---

## ⚡ Option A: Deploy to Vercel (Recommended - Free & 1-Click)

1. Go to **[vercel.com](https://vercel.com)** and log in.
2. Click **"Add New" ➔ "Project"** and import your GitHub repository.
3. In **Environment Variables**, add the 3 keys from your `.env`:
   * `MAPBOX_ACCESS_TOKEN`
   * `SUPABASE_URL`
   * `SUPABASE_ANON_KEY`
4. Click **Deploy** ➔ Done! You get a live link like `https://zeromile-go.vercel.app`.

---

## 🌐 Option B: Deploy to Netlify (Free & Drag-and-Drop)

1. Go to **[app.netlify.com/drop](https://app.netlify.com/drop)**.
2. Drag and drop this `web_platform` folder directly into your browser.
3. In **Site Settings ➔ Environment Variables**, add your 3 `.env` keys.
4. Done! Your site is live immediately with HTTPS.

---

## 💻 Option C: Run Locally or on any Cloud VPS (Render / Railway / EC2)

1. In your terminal:
   ```bash
   npm start
   ```
2. Open **`http://localhost:8080`** in your browser.
3. The server automatically loads `.env` and serves the app.
