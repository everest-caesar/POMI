# POMI App - Production Deployment Architecture

## 📋 Overview

This guide covers deploying the POMI app (React frontend + Express backend) to production with Netlify, AWS, MongoDB Atlas, and SendGrid.

---

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         FRONTEND - NETLIFY                       │
│                      (React + Vite + TailwindCSS)               │
│                   Auto-deployed from /frontend                   │
│  Environment: VITE_API_BASE_URL=https://api.pomi.com/api/v1    │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTPS API Calls
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND - RAILWAY/RENDER                      │
│                   (Express + Node.js + TypeScript)               │
│               Auto-deployed from /backend branch                 │
│          Environment: DATABASE_URL, JWT_SECRET, etc              │
└────────────┬──────────────────────┬──────────────┬───────────────┘
             │                      │              │
             ▼                      ▼              ▼
    ┌──────────────────┐   ┌──────────────┐  ┌─────────────┐
    │  MongoDB Atlas   │   │   AWS S3     │  │  SendGrid   │
    │  (Cloud DB)      │   │  (File Store)│  │  (Email)    │
    │  connection:     │   │  credentials:│  │  API Key:   │
    │  MONGODB_URI env │   │  AWS_* envs  │  │  SG_API_KEY │
    └──────────────────┘   └──────────────┘  └─────────────┘
```

---

## 🔧 Production Services Setup

### 1. **MongoDB Atlas** (Database)
**What:** Cloud MongoDB hosting
**Cost:** Free tier available (512MB)
**Setup:**
- Go to https://www.mongodb.com/cloud/atlas
- Create account
- Create cluster (free tier)
- Create database user (username/password)
- Get connection string: `mongodb+srv://username:password@cluster.mongodb.net/pomi?retryWrites=true&w=majority`
- Whitelist IP addresses (or allow all in dev)
- **Use this for:** `MONGODB_URI` environment variable

---

### 2. **AWS S3** (File Storage)
**What:** Cloud file storage for images
**Cost:** Free tier (5GB/month for 12 months)
**Setup:**
- Go to https://console.aws.amazon.com
- Navigate to S3
- Create bucket: `pomi-marketplace-images` (must be globally unique)
- Enable public access (for images)
- Create IAM user for programmatic access
- Get credentials:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`: `us-east-1`
- **Use for:** Marketplace images, forum attachments

---

### 3. **SendGrid** (Email Service)
**What:** Transactional email service
**Cost:** Free tier (100 emails/day)
**Setup:**
- Go to https://sendgrid.com
- Sign up and create account
- Create API key: Settings → API Keys → Create
- Save `SENDGRID_API_KEY`
- Verify sender email or domain
- **Use for:** All notification emails

---

### 4. **Backend Hosting** (Choose one)

#### **Option A: Railway (Recommended - Easiest)**
- Go to https://railway.app
- Sign up with GitHub
- Create new project
- Connect GitHub repo
- Add environment variables
- Auto-deploys on push
- Cost: ~$5/month

#### **Option B: Render**
- Go to https://render.com
- Sign up with GitHub
- Create web service
- Connect to backend folder
- Add environment variables
- Cost: Free tier available

#### **Option C: Heroku (Legacy)**
- Requires credit card even for free tier
- No longer recommended

**My Recommendation: Use Railway**

---

## 📁 Production Folder Structure

```
pomi-app/
├── frontend/                          # React app
│   ├── src/
│   ├── dist/                          # Built files (for Netlify)
│   ├── .env.production               # Production env variables
│   ├── vite.config.ts
│   └── package.json
│
├── backend/                           # Express app
│   ├── src/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/                 # Email service, etc
│   │   └── index.ts
│   ├── .env.production               # Production env variables
│   ├── Dockerfile                    # For containerization
│   └── package.json
│
├── docker-compose.yml               # Local development
├── .github/
│   └── workflows/                   # CI/CD workflows (optional)
├── DEPLOYMENT_GUIDE.md             # This file
└── README.md                        # Project overview
```

---

## 🌍 Environment Variables

### **Frontend (.frontend/.env.production)**
```env
VITE_API_BASE_URL=https://api.pomi.com/api/v1
VITE_APP_NAME=POMI
VITE_APP_VERSION=1.0.0
```

### **Backend (.backend/.env.production)**
```env
# Server
NODE_ENV=production
PORT=3000

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/pomi?retryWrites=true&w=majority

# Authentication
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
JWT_EXPIRE=7d

# CORS
CORS_ALLOWED_ORIGINS=https://pomi.netlify.app,https://www.pomi.com

# File Storage (AWS S3)
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
S3_BUCKET=pomi-marketplace-images
S3_PUBLIC_URL=https://pomi-marketplace-images.s3.amazonaws.com

# Email (SendGrid)
SENDGRID_API_KEY=your_sendgrid_api_key
SENDGRID_FROM_EMAIL=noreply@pomi.com

# Admin
ADMIN_EMAIL=marakihay@gmail.com
ADMIN_INVITE_CODE=POMI_ADMIN_2024_SECRET_KEY

# Redis (Optional for production, skip for now)
REDIS_URL=redis://localhost:6379
```

---

## 🚀 Step-by-Step Deployment

### **Step 1: Push Code to GitHub**

```bash
cd /Users/everestode/Desktop/POMI/pomi-app

# Initialize git (if not already)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: POMI app with marketplace, forum, and events"

# Create GitHub repo at https://github.com/new
# Then:
git remote add origin https://github.com/YOUR_USERNAME/pomi-app.git
git branch -M main
git push -u origin main
```

---

### **Step 2: Set Up MongoDB Atlas**

1. Create account at https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Create database user (e.g., `pomi_user` / strong password)
4. Get connection string from "Connect" → "Connect your application"
5. Update `.env.production`: `MONGODB_URI=...`

---

### **Step 3: Set Up AWS S3**

1. Sign up at https://aws.amazon.com
2. Navigate to S3 → Create bucket
3. Bucket name: `pomi-marketplace-images-prod` (globally unique)
4. Enable public read access
5. Create IAM user: IAM → Users → Add user
6. Give S3 permissions: `AmazonS3FullAccess`
7. Get credentials and add to `.env.production`

---

### **Step 4: Set Up SendGrid**

1. Sign up at https://sendgrid.com
2. Create API key: Settings → API Keys → Create
3. Verify sender email (yours)
4. Add to `.env.production`: `SENDGRID_API_KEY=...`

---

### **Step 5: Deploy Backend to Railway**

1. Go to https://railway.app
2. Click "New Project" → "GitHub Repo"
3. Select your `pomi-app` repo
4. Railway will detect it's a Node.js project
5. Add environment variables (from `.env.production`)
6. Railway auto-builds and deploys
7. Get your backend URL: `https://xxx.railway.app`

---

### **Step 6: Deploy Frontend to Netlify**

1. Go to https://netlify.com
2. Click "New site from Git"
3. Select your GitHub repo
4. Build settings:
   - Build command: `cd frontend && npm run build`
   - Publish directory: `frontend/dist`
5. Add environment variables:
   - `VITE_API_BASE_URL=https://xxx.railway.app/api/v1`
6. Netlify auto-builds and deploys on push
7. Get your frontend URL: `https://xxx.netlify.app`

---

### **Step 7: Update CORS in Backend**

1. Update `.env.production` CORS:
   ```env
   CORS_ALLOWED_ORIGINS=https://xxx.netlify.app
   ```
2. Push to GitHub
3. Backend auto-redeploys

---

## 📊 Service Costs (Monthly Estimate)

| Service | Free Tier | Paid Tier | Recommendation |
|---------|-----------|-----------|-----------------|
| MongoDB Atlas | 512MB | $0.57-57 | Start free |
| AWS S3 | 5GB | $0.025 per GB | Cheap, use free tier first |
| SendGrid | 100 emails/day | $29.95 | Use free tier first |
| Railway | - | $5+ | Pay-as-you-go |
| Netlify | Unlimited builds | - | Free tier is great |
| **Total** | **FREE** | **~$35+** | Start free, scale up |

---

## 🔒 Security Checklist

- [ ] Change `JWT_SECRET` to random 32+ character string
- [ ] Change `ADMIN_INVITE_CODE` to random code
- [ ] Never commit `.env` files (use `.env.example`)
- [ ] Enable MongoDB IP whitelist (only allow Railway IP)
- [ ] Enable S3 bucket encryption
- [ ] Enable SendGrid API key rotation
- [ ] Set up HTTPS for custom domain
- [ ] Enable database backups

---

## 🐛 Troubleshooting

### **CORS Errors**
- Update `CORS_ALLOWED_ORIGINS` to include frontend URL
- Must match exact domain (including protocol and port)

### **S3 Upload Fails**
- Verify bucket exists and is public
- Check AWS credentials are correct
- Verify S3 region matches

### **Email Not Sending**
- Verify SendGrid API key is correct
- Check sender email is verified
- Verify recipient email is valid
- Check SendGrid logs for bounce reasons

### **Database Connection Fails**
- Verify MongoDB URI is correct
- Check IP is whitelisted in MongoDB Atlas
- Verify database user exists

---

## 📝 Next Steps

1. **Create `.env.production` files** (don't commit to GitHub)
2. **Set up all services** (MongoDB, S3, SendGrid)
3. **Push code to GitHub**
4. **Deploy backend to Railway**
5. **Deploy frontend to Netlify**
6. **Test all features** in production
7. **Set up monitoring** (optional)

---

## 🎯 Quick Reference

```bash
# Local development (with docker-compose)
docker-compose up

# Frontend only (dev)
cd frontend && npm run dev

# Backend only (dev)
cd backend && npm run dev

# Build frontend
cd frontend && npm run build

# Build backend
cd backend && npm run build
```

---

## 📞 Support

For deployment issues, check:
- Railway docs: https://docs.railway.app
- Netlify docs: https://docs.netlify.com
- MongoDB Atlas: https://docs.atlas.mongodb.com
- AWS S3: https://docs.aws.amazon.com/s3
- SendGrid: https://sendgrid.com/docs

