# Production Deployment Checklist

## Phase 1: Services Setup (Before Deployment)

### MongoDB Atlas Setup
- [ ] Create account at https://www.mongodb.com/cloud/atlas
- [ ] Create free cluster (512MB)
- [ ] Create database user with strong password
- [ ] Get connection string: `mongodb+srv://username:password@cluster.mongodb.net/pomi?retryWrites=true&w=majority`
- [ ] Test connection locally with connection string
- [ ] Add connection string to backend `.env.production`

### AWS S3 Setup
- [ ] Create AWS account at https://aws.amazon.com
- [ ] Create S3 bucket: `pomi-marketplace-images-prod` (must be globally unique)
- [ ] Enable public read access for images
- [ ] Create IAM user with S3 permissions
- [ ] Get credentials:
  - [ ] AWS_ACCESS_KEY_ID
  - [ ] AWS_SECRET_ACCESS_KEY
- [ ] Set AWS region: `us-east-1`
- [ ] Add to backend `.env.production`

### SendGrid Email Setup
- [ ] Create account at https://sendgrid.com
- [ ] Create API key
- [ ] Verify sender email: add admin email for transactional emails
- [ ] Add `SENDGRID_API_KEY` to backend `.env.production`
- [ ] Test email sending locally

## Phase 2: Environment Configuration

### Frontend (.env.production)
```env
VITE_API_BASE_URL=https://api.pomi.com/api/v1  # Update with your backend URL
VITE_APP_NAME=POMI
VITE_APP_VERSION=1.0.0
```

### Backend (.env.production)
```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://...
JWT_SECRET=<random-32-char-string>
JWT_EXPIRE=7d
CORS_ALLOWED_ORIGINS=https://pomi.netlify.app
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=<your-key>
AWS_SECRET_ACCESS_KEY=<your-secret>
S3_BUCKET=pomi-marketplace-images-prod
S3_PUBLIC_URL=https://pomi-marketplace-images-prod.s3.amazonaws.com
SENDGRID_API_KEY=<your-api-key>
SENDGRID_FROM_EMAIL=noreply@pomi.com
ADMIN_EMAIL=marakihay@gmail.com
ADMIN_INVITE_CODE=<random-code>
```

## Phase 3: Backend Deployment (Railway)

- [ ] Go to https://railway.app
- [ ] Sign up with GitHub
- [ ] Click "New Project"
- [ ] Select your GitHub repo: `everest-caesar/POMI`
- [ ] Railway auto-detects Node.js project
- [ ] Add environment variables from `.env.production`
- [ ] Railway builds and deploys automatically
- [ ] **Save your backend URL**: e.g., `https://xxx.railway.app`
- [ ] Test backend health: `https://xxx.railway.app/api/v1/health`

## Phase 4: Frontend Deployment (Netlify)

- [ ] Go to https://netlify.com
- [ ] Sign up with GitHub
- [ ] Click "New site from Git"
- [ ] Select your GitHub repo: `everest-caesar/POMI`
- [ ] Netlify auto-detects it's a monorepo
- [ ] Build settings:
  - [ ] Build command: `cd frontend && npm run build`
  - [ ] Publish directory: `frontend/dist`
- [ ] Add environment variable:
  - [ ] `VITE_API_BASE_URL=<your-backend-url>/api/v1`
- [ ] Netlify builds and deploys automatically
- [ ] **Save your frontend URL**: e.g., `https://xxx.netlify.app`
- [ ] Test website loads: `https://xxx.netlify.app`

## Phase 5: Update CORS & Re-deploy

- [ ] Update backend `.env.production` CORS:
  ```env
  CORS_ALLOWED_ORIGINS=https://xxx.netlify.app
  ```
- [ ] Push to GitHub
- [ ] Railway auto-redeploys
- [ ] Test API calls work from frontend

## Phase 6: Testing in Production

- [ ] [ ] Sign up as new user
- [ ] [ ] Create marketplace listing
- [ ] [ ] Upload images to S3 (verify in S3 bucket)
- [ ] [ ] Create forum post
- [ ] [ ] Create event
- [ ] [ ] Test email notifications (check spam folder)
- [ ] [ ] Test marketplace search and filtering
- [ ] [ ] Test forum posts and replies
- [ ] [ ] Verify images load correctly

## Phase 7: Security Hardening

- [ ] [ ] Change JWT_SECRET to random 32+ character string
- [ ] [ ] Change ADMIN_INVITE_CODE to random code
- [ ] [ ] Enable MongoDB IP whitelist (only Railway IP)
- [ ] [ ] Enable S3 bucket encryption
- [ ] [ ] Set up HTTPS for custom domain
- [ ] [ ] Enable database backups (MongoDB Atlas)
- [ ] [ ] Rotate SendGrid API key regularly

## Phase 8: Monitoring (Optional)

- [ ] Set up error tracking (Sentry)
- [ ] Set up performance monitoring (New Relic)
- [ ] Set up log aggregation (LogRocket)
- [ ] Set up uptime monitoring (UptimeRobot)

## Service Cost Overview

| Service | Free Tier | Paid Tier | Monthly Cost |
|---------|-----------|-----------|--------------|
| MongoDB Atlas | 512MB | - | $0 |
| AWS S3 | 5GB | Per GB | $0 |
| SendGrid | 100 emails/day | - | $0 |
| Railway | - | Pay-as-you-go | $5-50 |
| Netlify | Unlimited | - | $0 |
| **TOTAL** | | | **$5-50/month** |

## Quick Links

- GitHub Repo: https://github.com/everest-caesar/POMI
- Railway Dashboard: https://railway.app
- Netlify Dashboard: https://app.netlify.com
- MongoDB Atlas: https://cloud.mongodb.com
- AWS S3: https://s3.console.aws.amazon.com
- SendGrid: https://app.sendgrid.com

## Troubleshooting

### CORS Errors
- Verify CORS_ALLOWED_ORIGINS includes exact frontend URL
- Must match protocol, domain, and port

### S3 Upload Fails
- Verify bucket exists and is public
- Check AWS credentials are correct
- Verify bucket region matches AWS_REGION

### Email Not Sending
- Verify SendGrid API key is correct
- Check sender email is verified in SendGrid
- Verify recipient email is valid
- Check SendGrid activity logs

### Database Connection Fails
- Verify MongoDB URI is correct
- Check IP is whitelisted in MongoDB Atlas
- Verify database user exists and password is correct

---

**Status**: Ready for production deployment
**Last Updated**: 2025-11-08
**Next Phase**: Implement messaging and buyer-seller features
