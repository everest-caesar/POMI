# 🚀 DEPLOYMENT READY - Next Steps

## ✅ Repositories Pushed!

Both repositories are now on GitHub:

### Frontend Repository
```
URL: https://github.com/everest-caesar/POMI-FRONTEND
Branch: main
Status: Ready for Netlify
```

### Backend Repository
```
URL: https://github.com/everest-caesar/POMI-BACKEND
Branch: main
Status: Ready for Railway
```

---

## 📋 Next: Deploy to Netlify (Frontend)

### Step 1: Connect to Netlify

1. Go to https://app.netlify.com
2. Sign up/Login with GitHub
3. Click **"New site from Git"**
4. Select **GitHub** provider
5. Search for and select **`pomi-frontend`** repository
6. Click **Connect**

### Step 2: Configure Build Settings

**Build Command:**
```
npm install && npm run build
```

**Publish Directory:**
```
dist
```

### Step 3: Add Environment Variable

1. Click **"Environment"** tab (or go back after creating site)
2. Click **"Edit Variables"**
3. Add variable:
   ```
   Key: VITE_API_BASE_URL
   Value: https://xxx.railway.app/api/v1
   ```
   (Replace `xxx` with your Railway URL - you'll get this in the next section)

### Step 4: Deploy

Click **"Deploy site"**

Wait 2-5 minutes for deployment to complete.

Your frontend will be available at: `https://your-site.netlify.app`

---

## 🚂 Next: Deploy to Railway (Backend)

### Step 1: Connect to Railway

1. Go to https://railway.app
2. Sign up/Login with GitHub
3. Click **"New Project"**
4. Select **"GitHub Repo"**
5. Search for and select **`pomi-backend`** repository
6. Click **Deploy**

Railway auto-detects Node.js and starts building automatically.

### Step 2: Add Environment Variables

While the build is running:

1. Click on your service (backend-pomi)
2. Click **"Variables"** tab
3. Click **"Raw Editor"**
4. Paste all environment variables:

```
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://USERNAME:PASSWORD@cluster.mongodb.net/pomi?retryWrites=true&w=majority
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-min-32-chars
JWT_EXPIRE=7d
CORS_ALLOWED_ORIGINS=https://your-frontend.netlify.app
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
S3_BUCKET=pomi-marketplace-images-prod
S3_PUBLIC_URL=https://pomi-marketplace-images-prod.s3.amazonaws.com
SENDGRID_API_KEY=SG.xxx
SENDGRID_FROM_EMAIL=noreply@pomi.community
ADMIN_EMAIL=marakihay@gmail.com
ADMIN_INVITE_CODE=POMI_ADMIN_2024_SECRET_KEY
```

5. Click **"Save"**

### Step 3: Get Your Backend URL

1. Click on your service
2. Click **"Settings"** tab
3. Find **"Railway Domain"** - this is your backend URL
4. Format: `https://xxx.railway.app`

### Step 4: Update Netlify Environment

Now that you have your Railway URL:

1. Go to Netlify dashboard
2. Go to your site settings
3. Click **"Environment"**
4. Update `VITE_API_BASE_URL`:
   ```
   https://xxx.railway.app/api/v1
   ```
5. Trigger a **"Redeploy"** from Netlify dashboard

### Step 5: Update CORS in Railway

1. Go back to Railway
2. Update `CORS_ALLOWED_ORIGINS` to your Netlify URL:
   ```
   https://your-site.netlify.app
   ```
3. Railway auto-redeploys

---

## 🔑 Environment Variables Needed

Before deploying, gather these:

### From MongoDB Atlas
```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/pomi
```

### From AWS S3
```
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
```

### From SendGrid
```
SENDGRID_API_KEY=SG.your-api-key
```

### JWT Secret (Generate yourself)
```
JWT_SECRET=generate-random-string-min-32-characters
```

---

## ✅ Deployment Checklist

### Before Deploying
- [ ] MongoDB Atlas account created
- [ ] AWS S3 bucket created and credentials saved
- [ ] SendGrid account created and API key generated
- [ ] Frontend and Backend repos on GitHub
- [ ] All documentation read

### Netlify Deployment
- [ ] Connected GitHub repo (pomi-frontend)
- [ ] Build command set: `npm install && npm run build`
- [ ] Publish directory set: `dist`
- [ ] Environment variable added (initially can use localhost backend)
- [ ] Site deployed

### Railway Deployment
- [ ] Connected GitHub repo (pomi-backend)
- [ ] All environment variables added
- [ ] Deployment complete
- [ ] Backend URL obtained

### Post-Deployment
- [ ] Updated Netlify `VITE_API_BASE_URL` with Railway URL
- [ ] Updated Railway `CORS_ALLOWED_ORIGINS` with Netlify URL
- [ ] Tested frontend loads
- [ ] Tested API calls work
- [ ] Tested email notifications
- [ ] Tested file uploads

---

## 🧪 Testing After Deployment

### Test 1: Frontend Loads
```
1. Go to your Netlify URL
2. Should see POMI homepage
3. Should be able to sign up/login
```

### Test 2: API Calls Work
```
1. Go to frontend
2. Try to create marketplace listing
3. Should upload image to S3
4. Check S3 bucket for image
```

### Test 3: Email Works
```
1. Create a listing inquiry
2. Seller should get email
3. Check SendGrid dashboard for logs
```

### Test 4: Database Works
```
1. Check MongoDB Atlas
2. Should see database collections populated
```

---

## 🚨 Common Issues

### Frontend shows "Cannot reach API"
- Verify CORS_ALLOWED_ORIGINS in Railway matches Netlify URL exactly
- Verify VITE_API_BASE_URL in Netlify is correct
- Check Railway logs for CORS errors

### Images not uploading
- Verify AWS credentials in Railway
- Verify S3 bucket exists and is public
- Check AWS CloudWatch logs

### Emails not sending
- Verify SENDGRID_API_KEY is correct
- Verify sender email is verified in SendGrid
- Check SendGrid activity log

### Database connection fails
- Verify MONGODB_URI is correct
- Verify IP whitelist in MongoDB Atlas
- Check MongoDB Atlas connection logs

---

## 📊 Your Deployment URLs

After deployment, you'll have:

```
Frontend: https://xxx.netlify.app
Backend API: https://xxx.railway.app/api/v1
Database: MongoDB Atlas (cloud)
File Storage: AWS S3 (cloud)
Email Service: SendGrid (cloud)
```

---

## 🎉 You're Almost There!

Follow the steps above and your POMI app will be **LIVE** in ~30 minutes!

**Order:**
1. ✅ Push to GitHub (DONE!)
2. 📍 Deploy frontend to Netlify (15 min)
3. 📍 Deploy backend to Railway (15 min)
4. 📍 Update environment variables (5 min)
5. ✅ Go LIVE! (1 min)

---

## 📞 Quick Links

| What | Link |
|------|------|
| Frontend Repo | https://github.com/everest-caesar/POMI-FRONTEND |
| Backend Repo | https://github.com/everest-caesar/POMI-BACKEND |
| Netlify Dashboard | https://app.netlify.com |
| Railway Dashboard | https://railway.app |
| MongoDB Atlas | https://cloud.mongodb.com |
| AWS Console | https://console.aws.amazon.com |
| SendGrid Dashboard | https://app.sendgrid.com |

---

## 📚 Reference Guides

In the monorepo (`https://github.com/everest-caesar/POMI`):
- `RAILWAY_ENV_GUIDE.md` - How Railway handles environment variables
- `SEPARATE_REPOS_GUIDE.md` - How to manage separate repos
- `DEPLOYMENT_GUIDE.md` - Complete deployment architecture
- `PRODUCTION_CHECKLIST.md` - Full checklist for production

---

**Status**: 🟢 **READY TO DEPLOY**

**Next Action**: Go to https://app.netlify.com and create a new site from the pomi-frontend repo!
