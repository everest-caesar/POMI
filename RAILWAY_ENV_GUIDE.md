# 🚂 Railway Environment Variables & Build Process Guide

## Quick Answer

**Railway automatically uses environment variables from the dashboard during BOTH build and runtime. You DO NOT need GitHub Actions or separate workflows.**

---

## How Railway Builds Your Backend

### Step 1: Clone Repository
```
Railway pulls your code from GitHub
↓
Checks for Dockerfile or package.json
↓
Auto-detects Node.js project
```

### Step 2: Build Phase (WITH Environment Variables)
```
Railway reads env vars from dashboard
↓
npm install (dependencies)
↓
Runs build script: npm run build
↓
TypeScript compiles → JavaScript (src/ → dist/)
```

### Step 3: Runtime Phase (WITH Environment Variables)
```
Railway reads env vars from dashboard again
↓
npm start (starts the application)
↓
Node.js server listening on PORT 3000
↓
Environment variables available to app
```

---

## Where Environment Variables Come From

### Railroad Dashboard
```
1. Go to https://railway.app
2. Select your project
3. Select your service (backend-pomi)
4. Click "Variables" tab
5. Add all your environment variables here
```

**Railway automatically provides these during build AND runtime:**
- All environment variables you add in the dashboard
- PORT (automatically set by Railway)
- NODE_ENV (automatically set to "production")

---

## Visual Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   YOU PUSH TO GITHUB                        │
│                  git push origin main                       │
└────────────────────────┬────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│              RAILWAY WEBHOOK TRIGGERED                       │
│         (Automatic via GitHub integration)                  │
└────────────────────────┬────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│           RAILWAY FETCHES FROM GITHUB                        │
│          (Latest code from main branch)                     │
└────────────────────────┬────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│        RAILWAY LOADS ENV VARS FROM DASHBOARD                │
│  (DATABASE_URL, JWT_SECRET, SENDGRID_API_KEY, etc)         │
└────────────────────────┬────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│    BUILD PHASE: npm install && npm run build                │
│   (TypeScript compilation WITH environment vars)            │
│                                                              │
│  Environment variables are in: process.env.DATABASE_URL    │
│  (Used if you need them during build)                       │
└────────────────────────┬────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│    RUNTIME PHASE: npm start                                 │
│    (Express server starts WITH environment vars)            │
│                                                              │
│  Server uses: process.env.DATABASE_URL                      │
│  Server uses: process.env.JWT_SECRET                        │
│  Server uses: process.env.SENDGRID_API_KEY                  │
│  etc.                                                        │
└────────────────────────┬────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│           PRODUCTION SERVER RUNNING ✓                        │
│       Listening on https://xxx.railway.app                  │
│       All environment variables available                   │
└─────────────────────────────────────────────────────────────┘
```

---

## What You Do NOT Need

❌ **GitHub Actions workflows** (`.github/workflows/*.yml`)
  - Railway handles everything automatically

❌ **Separate build scripts**
  - Railway uses your `package.json` scripts

❌ **Docker builds locally**
  - Railway builds in the cloud

❌ **Manual environment variable passing**
  - Railway dashboard handles it

❌ **Build-time configuration files**
  - Environment variables work at runtime

---

## What You DO Need

✅ **Code pushed to GitHub**
  ```bash
  git push origin main
  ```

✅ **Environment variables in Railway dashboard**
  ```
  MONGODB_URI=mongodb+srv://...
  JWT_SECRET=random-32-chars
  SENDGRID_API_KEY=SG.xxx
  AWS_ACCESS_KEY_ID=xxx
  AWS_SECRET_ACCESS_KEY=xxx
  ```

✅ **Valid package.json with build script**
  ```json
  {
    "scripts": {
      "build": "tsc",
      "start": "node dist/index.js"
    }
  }
  ```

---

## Step-by-Step Setup in Railway

### 1. Create Railway Project
```
1. Go to https://railway.app
2. Click "New Project"
3. Select "GitHub Repo"
4. Select your backend repository
5. Railway auto-detects Node.js
```

### 2. Add Environment Variables
```
1. Click "Variables" tab
2. Click "Raw Editor"
3. Paste all your environment variables:

NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/pomi
JWT_SECRET=your-random-32-character-string-here
JWT_EXPIRE=7d
CORS_ALLOWED_ORIGINS=https://your-frontend.netlify.app
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
S3_BUCKET=pomi-marketplace-images-prod
S3_PUBLIC_URL=https://pomi-marketplace-images-prod.s3.amazonaws.com
SENDGRID_API_KEY=SG.xxxxxxxxxxxxx
SENDGRID_FROM_EMAIL=noreply@pomi.community
ADMIN_EMAIL=admin@example.com
ADMIN_INVITE_CODE=POMI_ADMIN_SECRET_CODE
```

3. Click "Save"

### 3. Deploy
```
1. Click "Deployments" tab
2. Should auto-start building
3. Watch build progress in real-time
4. Deploy complete when you see ✓
```

### 4. Get Your URL
```
1. Click "Settings" tab
2. Find "Railway Domain"
3. Your backend is at: https://xxx.railway.app
4. API base: https://xxx.railway.app/api/v1
```

---

## Environment Variables in Your Code

### How to Access in Express
```typescript
// In your Express app
const mongodbUri = process.env.MONGODB_URI;
const jwtSecret = process.env.JWT_SECRET;
const sendgridKey = process.env.SENDGRID_API_KEY;
const port = process.env.PORT || 3000;
```

### Example from Your App
```typescript
// backend/src/index.ts
const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI;

if (!MONGODB_URI) {
  throw new Error('MONGODB_URI not set in environment');
}

mongoose.connect(MONGODB_URI);
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

## Build vs Runtime Environment Variables

### Build Time (During npm run build)
Environment variables are available, but rarely needed:
```typescript
// This would use build-time env var
const apiUrl = process.env.VITE_API_BASE_URL; // Frontend only

// For backend, build time doesn't need env vars
```

### Runtime (When app is running)
Environment variables are always available:
```typescript
// This uses runtime env var
const database = await mongoose.connect(process.env.MONGODB_URI);
const email = await sgMail.send({
  from: process.env.SENDGRID_FROM_EMAIL,
  to: userEmail,
  subject: 'Hello',
  html: '<p>Test</p>'
});
```

---

## Troubleshooting

### Build Fails: "Cannot find module"
**Solution**: Environment variables are NOT used for imports. Add missing npm packages:
```bash
npm install missing-package
git push origin main
```

### App Crashes: "MONGODB_URI not set"
**Solution**: Add MONGODB_URI to Railway Variables:
1. Click Variables tab in Railway
2. Add: `MONGODB_URI=mongodb+srv://...`
3. Re-deploy

### App Crashes: "JWT_SECRET not set"
**Solution**: Add JWT_SECRET to Railway Variables:
1. Go to Variables tab
2. Add: `JWT_SECRET=your-random-32-chars`
3. Re-deploy

### Environment Variables Not Updating
**Solution**: After updating variables in Railway:
1. Wait 30 seconds
2. Click "Redeploy" (if needed)
3. Wait for deploy to complete

---

## Comparison: Different Deployment Platforms

| Platform | Env Vars | Build | Runtime | Automatic |
|----------|----------|-------|---------|-----------|
| Railway | Dashboard | ✓ | ✓ | ✓ Auto-rebuild |
| Heroku | Config Vars | ✓ | ✓ | ✓ Auto-rebuild |
| AWS Lambda | Environment | ✗ | ✓ | ✗ Manual deploy |
| Docker | Build args | ✓ | Limited | ✗ Manual |
| GitHub Actions | Secrets | ✓ | ✓ | ✗ Manual |

**Railway is the simplest** - no configuration needed!

---

## Best Practices

### 1. Never Commit Secrets
```bash
# ✓ GOOD: .env in .gitignore
.env
.env.production

# ✗ BAD: .env in git
git add .env  # DON'T DO THIS
```

### 2. Use .env.example
```bash
# Always provide template
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/db
JWT_SECRET=your-secret-key-here
SENDGRID_API_KEY=your-api-key-here
```

### 3. Validate on Startup
```typescript
const required = ['MONGODB_URI', 'JWT_SECRET', 'SENDGRID_API_KEY'];
required.forEach(key => {
  if (!process.env[key]) {
    throw new Error(`Missing required env var: ${key}`);
  }
});
```

### 4. Different Vars for Dev vs Prod
```
Development (.env):
  MONGODB_URI=mongodb://localhost:27017/pomi-dev
  JWT_SECRET=dev-secret-key

Production (Railway dashboard):
  MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/pomi
  JWT_SECRET=long-random-production-key
```

---

## Quick Checklist

- [ ] Code pushed to GitHub (main branch)
- [ ] Railway project created
- [ ] GitHub repo connected to Railway
- [ ] Environment variables added to Railway dashboard
- [ ] Build completes without errors
- [ ] App starts successfully
- [ ] Backend URL working
- [ ] CORS configured for frontend
- [ ] Emails sending (check SendGrid dashboard)
- [ ] Database connected (check MongoDB Atlas)

---

## Summary

**Railway automatically:**
1. ✓ Pulls code from GitHub
2. ✓ Reads environment variables from dashboard
3. ✓ Runs npm install
4. ✓ Runs npm run build (with env vars available)
5. ✓ Runs npm start (with env vars available)
6. ✓ Hosts your app with SSL/HTTPS
7. ✓ Auto-redeploys on GitHub push

**You only need to:**
1. ✓ Push code to GitHub
2. ✓ Add environment variables to Railway dashboard
3. ✓ Wait for auto-deploy to complete

**No GitHub Actions. No manual builds. No Docker commands. Just push and it works!** 🚀

---

## Further Reading

- Railway Docs: https://docs.railway.app
- Environment Variables: https://docs.railway.app/guides/variables
- Build & Deploy: https://docs.railway.app/guides/build-deploy

