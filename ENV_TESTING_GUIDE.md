# 🧪 Environment Testing Guide - Development vs Production

## Overview

You now have **3 environment files**:

```
Backend:
├─ .env.development     ← Local testing with docker-compose
└─ .env.production      ← Production on Railway

Frontend:
├─ .env.development     ← Local testing (http://localhost:3000)
└─ .env.production      ← Production (Railway backend URL)
```

---

## 📋 **WHAT'S IN EACH FILE**

### **Backend: .env.development** (Local Testing)

```env
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/pomi
AWS_ACCESS_KEY_ID=minioadmin          # MinIO test
AWS_SECRET_ACCESS_KEY=minioadmin      # MinIO test
S3_BUCKET=marketplace                 # MinIO bucket
S3_ENDPOINT=http://minio:9000         # Local MinIO
S3_PUBLIC_URL=http://localhost:9000   # Local access
SENDGRID_API_KEY=test-key-development # Test key
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000
```

### **Backend: .env.production** (Railway)

```env
NODE_ENV=production
MONGODB_URI=mongodb+srv://POMI:aIud2WsrMW8qqlAw@cluster0.7fk4ela.mongodb.net/?appName=Cluster0
AWS_ACCESS_KEY_ID=AKIA2ZIOMUF3KKYODA5A        # YOUR AWS KEY
AWS_SECRET_ACCESS_KEY=jFOrJOkWNwDXh1X2a...    # YOUR AWS SECRET
S3_BUCKET=pomi-marketplace-images-prod        # YOUR BUCKET
S3_PUBLIC_URL=https://pomi-marketplace-images-prod.s3.amazonaws.com
SENDGRID_API_KEY=SG.Y3XSqYl0SVSOXLQJA6FJ...  # YOUR SENDGRID KEY
CORS_ALLOWED_ORIGINS=https://your-netlify-site.netlify.app
```

### **Frontend: .env.development**

```env
VITE_API_BASE_URL=http://localhost:3000/api/v1
VITE_DEBUG=true
```

### **Frontend: .env.production**

```env
VITE_API_BASE_URL=https://your-railway-url.railway.app/api/v1
VITE_DEBUG=false
```

---

## 🧪 **TEST 1: LOCAL DEVELOPMENT TESTING**

### Use: `.env.development` files with docker-compose

**Step 1: Start all services**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app

docker-compose up
```

This uses:
- ✅ `.env.development` (backend reads this)
- ✅ Local MongoDB (docker)
- ✅ Local MinIO (docker)
- ✅ Frontend on http://localhost:3001

**Step 2: Test locally**
```
Visit: http://localhost:3001
- Sign up
- Create marketplace listing
- Upload images (goes to MinIO, not AWS S3)
- Create forum post
- Create event
```

**Expected:**
- ✅ Everything works
- ✅ Images upload to MinIO (http://localhost:9000)
- ✅ No AWS/SendGrid needed

---

## 🚀 **TEST 2: PRODUCTION ENVIRONMENT TESTING**

### Use: `.env.production` files locally BEFORE deploying to Railway

This tests your **production credentials locally** before deploying.

**Step 1: Stop docker-compose**
```bash
docker-compose down
```

**Step 2: Copy production env to local .env**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app/backend

# Rename for local testing
cp .env.production .env
```

Your `.env` now has:
- ✅ Your real MongoDB Atlas credentials
- ✅ Your real AWS S3 credentials
- ✅ Your real SendGrid API key

**Step 3: Make sure MongoDB whitelist allows your IP**

1. Go to: https://cloud.mongodb.com
2. Click your cluster
3. Go to **"Network Access"** tab
4. Add your local IP: Click **"Add IP Address"** → **"Add Current IP Address"**
5. Or allow all: `0.0.0.0/0` (for testing only!)

**Step 4: Run backend locally**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app/backend

npm install
npm run dev
```

**Step 5: Run frontend locally**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app/frontend

npm install
npm run dev
```

**Step 6: Test with production credentials**
```
Visit: http://localhost:5173
- Sign up
- Create marketplace listing
- Upload images (goes to AWS S3!)
- Create forum post
- Check AWS S3 bucket for images
```

**Expected:**
- ✅ Everything works with real AWS/SendGrid
- ✅ Images appear in your S3 bucket
- ✅ MongoDB Atlas has data
- ✅ No errors with production credentials

---

## ✅ **TESTING CHECKLIST**

### **Local Development Testing (docker-compose)**
- [ ] `docker-compose up` runs without errors
- [ ] Frontend loads: http://localhost:3001
- [ ] Backend health: http://localhost:3000/api/v1/health
- [ ] Can sign up/login
- [ ] Can create marketplace listing
- [ ] Images upload to MinIO
- [ ] Can create forum post
- [ ] Can create event
- [ ] No AWS/SendGrid errors

### **Production Testing (local with real credentials)**
- [ ] MongoDB IP whitelist includes your IP
- [ ] `.env` has production credentials
- [ ] `npm run dev` works
- [ ] Frontend loads: http://localhost:5173
- [ ] Can sign up/login
- [ ] Can create marketplace listing
- [ ] Images upload to AWS S3 (check bucket)
- [ ] Can create forum post
- [ ] SendGrid key doesn't error
- [ ] No permission errors from AWS

---

## 🔍 **TROUBLESHOOTING**

### **Error: MongoDB connection refused**
**Cause:** MongoDB IP not whitelisted
**Fix:** Add your IP to MongoDB Atlas Network Access

### **Error: AWS Forbidden (403)**
**Cause:** Invalid AWS credentials or wrong bucket
**Fix:**
1. Verify credentials in `.env`
2. Verify S3 bucket exists
3. Verify IAM user has S3 permissions

### **Error: SendGrid authentication failed**
**Cause:** Invalid API key
**Fix:** Verify API key in `.env`

### **Error: MinIO not found (local testing)**
**Cause:** docker-compose not running
**Fix:** Run `docker-compose up` first

---

## 📝 **HOW TO USE THESE FILES**

### **For Local Development:**
```bash
# Use .env.development
docker-compose up

# Frontend auto-uses .env.development
# Backend auto-uses .env.development
```

### **For Production Testing (before Railway):**
```bash
# Copy production to .env
cp .env.production .env

# Run locally with production credentials
npm run dev  # backend
npm run dev  # frontend
```

### **For Production Deployment (Railway):**
```bash
# Add environment variables to Railway dashboard
# Copy values from .env.production

# Don't commit .env files to GitHub!
# .gitignore already ignores them
```

---

## 🔐 **SECURITY NOTES**

### **Never commit .env files:**
```bash
# Already in .gitignore:
.env
.env.local
.env.production.local
```

### **Keep credentials safe:**
- ✅ Don't share .env files
- ✅ Don't commit to GitHub
- ✅ Regenerate keys if exposed
- ✅ Use Railway/Netlify dashboards for production

### **Production credentials:**
Your `.env.production` contains:
- AWS Access Key ID
- AWS Secret Access Key
- MongoDB password
- SendGrid API key

**KEEP THESE PRIVATE!**

---

## 📊 **TESTING FLOW**

```
1. Local Development Testing
   ├─ docker-compose up
   ├─ Uses .env.development
   ├─ Uses MinIO (local)
   └─ All tests pass ✅

2. Production Testing (local)
   ├─ Copy .env.production → .env
   ├─ npm run dev (backend)
   ├─ npm run dev (frontend)
   ├─ Uses real AWS S3
   ├─ Uses real MongoDB Atlas
   ├─ Uses real SendGrid
   └─ All tests pass ✅

3. Production Deployment (Railway)
   ├─ Push to GitHub
   ├─ Railway picks up code
   ├─ Add environment variables to Railway
   ├─ Railway auto-deploys
   └─ Live in production ✅
```

---

## 🎯 **DO THIS NOW**

### **Test 1: Local Development**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app
docker-compose up
# Wait for everything to start
# Visit http://localhost:3001
# Test signup, listings, forum
```

### **Test 2: Production Credentials**
```bash
# Stop docker-compose (Ctrl+C)

cd backend
cp .env.production .env
npm install
npm run dev

# In another terminal
cd frontend
npm install
npm run dev

# Visit http://localhost:5173
# Test with real AWS/SendGrid/MongoDB
```

---

## ✨ **SUMMARY**

| Step | Command | Uses | File |
|------|---------|------|------|
| Local Dev | `docker-compose up` | MinIO, local DB | `.env.development` |
| Prod Test | `npm run dev` | AWS S3, MongoDB Atlas | `.env.production` |
| Deploy | Push to GitHub | Railway | Railway dashboard |

---

Ready to test? Start with **Test 1: Local Development Testing** above!
