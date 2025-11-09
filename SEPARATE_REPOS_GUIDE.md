# 📦 Separate GitHub Repositories Guide

## Overview

You now have **3 repositories**:

1. **pomi-monorepo** (current, keep for reference)
   - Contains both frontend and backend
   - https://github.com/everest-caesar/POMI

2. **pomi-frontend** (NEW - push to Netlify)
   - Only React frontend code
   - Push to: `https://github.com/everest-caesar/pomi-frontend`

3. **pomi-backend** (NEW - push to Railway)
   - Only Express backend code
   - Push to: `https://github.com/everest-caesar/pomi-backend`

---

## Step 1: Create GitHub Repositories

### Create Frontend Repository

1. Go to https://github.com/new
2. Repository name: **pomi-frontend**
3. Description: "POMI Frontend - React + Vite + TypeScript"
4. Choose **Public** or **Private**
5. Do NOT initialize (no README, .gitignore, license)
6. Click **Create repository**
7. Copy the URL: `https://github.com/YOUR_USERNAME/pomi-frontend.git`

### Create Backend Repository

1. Go to https://github.com/new
2. Repository name: **pomi-backend**
3. Description: "POMI Backend - Express.js + Node.js + MongoDB"
4. Choose **Public** or **Private**
5. Do NOT initialize (no README, .gitignore, license)
6. Click **Create repository**
7. Copy the URL: `https://github.com/YOUR_USERNAME/pomi-backend.git`

---

## Step 2: Rename Branch to main

```bash
# Frontend
cd /tmp/pomi-frontend
git branch -m master main

# Backend
cd /tmp/pomi-backend
git branch -m master main
```

---

## Step 3: Add Remote and Push Frontend

```bash
cd /tmp/pomi-frontend

# Add GitHub as remote
git remote add origin https://github.com/YOUR_USERNAME/pomi-frontend.git

# Replace YOUR_USERNAME with your actual GitHub username!

# Verify remote
git remote -v

# Push to GitHub
git push -u origin main
```

### Expected Output
```
Enumerating objects: 102, done.
Counting objects: 100% (102/102), done.
Delta compression using up to 8 threads
Compressing objects: 100% (80/20), done.
Writing objects: 100% (102/102), 11.45 MiB | 2.50 MiB/s, done.
Total 102 (delta 11), reused 0 (delta 0)
remote: Resolving deltas: 100% (11/11), done.
To https://github.com/YOUR_USERNAME/pomi-frontend.git
 * [new branch]      main -> main
Branch 'main' set up to track 'origin/main'.
```

---

## Step 4: Add Remote and Push Backend

```bash
cd /tmp/pomi-backend

# Add GitHub as remote
git remote add origin https://github.com/YOUR_USERNAME/pomi-backend.git

# Replace YOUR_USERNAME with your actual GitHub username!

# Verify remote
git remote -v

# Push to GitHub
git push -u origin main
```

### Expected Output
```
Enumerating objects: 53, done.
Counting objects: 100% (53/53), done.
Delta compression using up to 100%
Compressing objects: 100% (48/48), done.
Writing objects: 100% (53/53), 8.87 MiB | 3.50 MiB/s, done.
Total 53 (delta 7), reused 0 (delta 0)
remote: Resolving deltas: 100% (7/7), done.
To https://github.com/YOUR_USERNAME/pomi-backend.git
 * [new branch]      main -> main
Branch 'main' set up to track 'origin/main'.
```

---

## Step 5: Verify Repositories

### Check Frontend on GitHub
```
https://github.com/YOUR_USERNAME/pomi-frontend
- Should show all React files
- README.md visible
- .env.example visible
- Dockerfile visible
```

### Check Backend on GitHub
```
https://github.com/YOUR_USERNAME/pomi-backend
- Should show all Express files
- README.md visible
- .env.example visible
- Dockerfile visible
```

---

## Deployment Configuration

### Netlify (Frontend)

1. Go to https://netlify.com
2. Click "New site from Git"
3. Select your **pomi-frontend** repo
4. Build settings:
   - Build command: `npm install && npm run build`
   - Publish directory: `dist`
5. Environment variables:
   - `VITE_API_BASE_URL` = `https://xxx.railway.app/api/v1`
6. Deploy!

### Railway (Backend)

1. Go to https://railway.app
2. Click "New Project"
3. Select your **pomi-backend** repo
4. Railway auto-detects Node.js
5. Add environment variables:
   ```
   MONGODB_URI=...
   JWT_SECRET=...
   SENDGRID_API_KEY=...
   AWS_ACCESS_KEY_ID=...
   AWS_SECRET_ACCESS_KEY=...
   S3_BUCKET=...
   S3_PUBLIC_URL=...
   CORS_ALLOWED_ORIGINS=https://xxx.netlify.app
   ADMIN_EMAIL=...
   ADMIN_INVITE_CODE=...
   ```
6. Deploy!

---

## File Structure Reference

### Frontend Repository (`pomi-frontend`)
```
pomi-frontend/
├── README.md              ← Start here
├── .env.example           ← Environment template
├── .gitignore
├── Dockerfile
├── package.json
├── tsconfig.json
├── vite.config.ts
├── tailwind.config.js
├── src/
│   ├── components/
│   ├── pages/
│   ├── services/
│   ├── hooks/
│   ├── App.tsx
│   └── main.tsx
├── public/
└── index.html
```

### Backend Repository (`pomi-backend`)
```
pomi-backend/
├── README.md              ← Start here
├── .env.example           ← Environment template
├── .gitignore
├── Dockerfile
├── package.json
├── tsconfig.json
├── jest.config.js
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── services/
│   ├── middleware/
│   ├── utils/
│   ├── validators/
│   ├── app.ts
│   └── index.ts
└── migrations/
```

---

## Commands Cheat Sheet

### Frontend Push
```bash
cd /tmp/pomi-frontend
git remote add origin https://github.com/YOUR_USERNAME/pomi-frontend.git
git branch -m master main
git push -u origin main
```

### Backend Push
```bash
cd /tmp/pomi-backend
git remote add origin https://github.com/YOUR_USERNAME/pomi-backend.git
git branch -m master main
git push -u origin main
```

### Future Updates

Once repos are on GitHub, just push changes:

```bash
# Frontend updates
cd /path/to/pomi-frontend
git add .
git commit -m "feat: your feature"
git push origin main

# Backend updates
cd /path/to/pomi-backend
git add .
git commit -m "feat: your feature"
git push origin main

# Netlify auto-deploys frontend
# Railway auto-deploys backend
```

---

## Environment Variables Summary

### Frontend (.env.production in Netlify)
```env
VITE_API_BASE_URL=https://your-backend-url.railway.app/api/v1
```

### Backend (.env.production in Railway dashboard)
```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://...
JWT_SECRET=your-secret-key
JWT_EXPIRE=7d
CORS_ALLOWED_ORIGINS=https://your-frontend.netlify.app
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
S3_BUCKET=pomi-marketplace-images-prod
S3_PUBLIC_URL=https://your-bucket.s3.amazonaws.com
SENDGRID_API_KEY=your-api-key
SENDGRID_FROM_EMAIL=noreply@pomi.community
ADMIN_EMAIL=admin@example.com
ADMIN_INVITE_CODE=your-secret-code
```

---

## Workflow After Setup

```
You make changes locally
     ↓
git add . && git commit -m "..."
     ↓
git push origin main
     ↓
GitHub webhook triggered
     ↓
Netlify (frontend) auto-deploys
Railway (backend) auto-deploys
     ↓
Changes live in 2-5 minutes!
```

---

## Keeping Old Monorepo

Your original monorepo at `https://github.com/everest-caesar/POMI` is still there for reference, but you'll now work with:

- **Frontend**: `https://github.com/everest-caesar/pomi-frontend`
- **Backend**: `https://github.com/everest-caesar/pomi-backend`

You can delete the monorepo later if you want, or keep it as a backup.

---

## Troubleshooting

### Push Rejected: "remote origin already exists"
```bash
# View existing remotes
git remote -v

# Remove old remote
git remote remove origin

# Add new one
git remote add origin https://github.com/YOUR_USERNAME/pomi-frontend.git

# Push
git push -u origin main
```

### "fatal: not a git repository"
```bash
# Make sure you're in the right directory
cd /tmp/pomi-frontend
# or
cd /tmp/pomi-backend

# Verify it's a repo
git status
```

### "fatal: Authentication failed"
```bash
# Use personal access token instead of password
# Or set up SSH key
# See: https://docs.github.com/en/authentication
```

---

## Next Steps

1. **Create the two repositories on GitHub** (steps above)
2. **Push frontend code**: `git push -u origin main`
3. **Push backend code**: `git push -u origin main`
4. **Connect to Netlify**: Select pomi-frontend repo
5. **Connect to Railway**: Select pomi-backend repo
6. **Add environment variables** in each platform
7. **Done!** Auto-deployment enabled

---

## Quick Links

| What | URL |
|------|-----|
| Create Frontend Repo | https://github.com/new |
| Create Backend Repo | https://github.com/new |
| Netlify Dashboard | https://app.netlify.com |
| Railway Dashboard | https://railway.app |
| GitHub Account | https://github.com/everest-caesar |

