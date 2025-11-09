# POMI Codebase - Quick Reference Guide

## File Locations at a Glance

### Marketplace
**Backend:**
- Model: `/backend/src/models/Listing.ts`
- Controller: `/backend/src/controllers/marketplace.controller.ts`
- Routes: `/backend/src/routes/marketplace.routes.ts`

**Frontend:**
- Page: `/frontend/src/pages/MarketplacePage.tsx`
- Main Component: `/frontend/src/components/Marketplace.tsx`
- Upload Form: `/frontend/src/components/MarketplaceUpload.tsx`

### Forum
**Backend:**
- Models: `/backend/src/models/ForumPost.ts`, `/backend/src/models/ForumReply.ts`
- Controller: `/backend/src/controllers/forum.controller.ts`
- Routes: `/backend/src/routes/forum.routes.ts`

**Frontend:**
- Page: `/frontend/src/pages/ForumPage.tsx` (Currently static mockup)

### User & Auth
**Backend:**
- Model: `/backend/src/models/User.ts`
- Auth Controller: `/backend/src/controllers/auth.controller.ts`
- Routes: `/backend/src/routes/auth.routes.ts`

---

## API Endpoints Summary

### Marketplace
```
GET    /api/v1/marketplace/listings              - List all (paginated)
GET    /api/v1/marketplace/listings/:id          - Get single (increments views)
POST   /api/v1/marketplace/listings              - Create (requires auth)
PUT    /api/v1/marketplace/listings/:id          - Update (owner/admin only)
DELETE /api/v1/marketplace/listings/:id          - Delete (owner/admin only)
POST   /api/v1/marketplace/listings/:id/favorite - Toggle favorite (requires auth)
POST   /api/v1/marketplace/upload                - Upload images (requires auth)
```

### Forum
```
GET    /api/v1/forums/posts                      - List posts (paginated)
GET    /api/v1/forums/posts/:id                  - Get single (increments views)
POST   /api/v1/forums/posts                      - Create post (requires auth)
PUT    /api/v1/forums/posts/:id                  - Update post (author only)
DELETE /api/v1/forums/posts/:id                  - Delete post (author only)
GET    /api/v1/forums/posts/:id/replies          - List replies (paginated)
POST   /api/v1/forums/posts/:id/replies          - Add reply (requires auth)
```

---

## Data Models at a Glance

### Listing
```
title, description, category, price, location,
sellerId, sellerName, images[], status,
condition, favorites[], views,
moderationStatus, reviewedBy, reviewedAt, rejectionReason
```

### ForumPost
```
title, content, category, tags[],
authorId, authorName,
repliesCount, viewsCount, votes,
status
```

### ForumReply
```
postId, content,
authorId, authorName,
votes, status
```

### User
```
email, password (hashed), username,
age, area, workOrSchool,
isAdmin
```

---

## Key Implementation Notes

### What EXISTS
✓ Admin moderation workflow (listings & events)
✓ Image uploads to S3/MinIO
✓ Marketplace search & filtering
✓ Forum post & reply system (backend complete)
✓ Password hashing with bcryptjs
✓ User roles (admin/regular)

### What DOESN'T EXIST
✗ Phone number in User model (only in Business)
✗ Direct messaging between users
✗ Email/notification service
✗ Seller reviews/ratings
✗ Forum moderation tools
✗ Real-time updates

---

## Common Tasks

### Add a field to User model
1. Edit `/backend/src/models/User.ts`
2. Update `IUser` interface
3. Add schema field definition
4. No migration needed (MongoDB is schemaless)

### Add new marketplace category
1. Edit `/backend/src/models/Listing.ts` line 42
2. Add to enum array in controller if needed
3. Update frontend `/frontend/src/components/Marketplace.tsx` line 18-95

### Add new forum category
1. Edit `/backend/src/models/ForumPost.ts` line 38-47
2. Update controller if needed
3. Frontend updates in `/frontend/src/pages/ForumPage.tsx` if using static categories

### Create new API endpoint
1. Create/update controller method in `/backend/src/controllers/`
2. Add route to `/backend/src/routes/[feature].routes.ts`
3. Add to router in `/backend/src/routes/index.ts` if new feature
4. Frontend: Use `fetch('http://localhost:3000/api/v1/...')`

---

## Database Connection
- Type: MongoDB
- URI: `mongodb://pomi_user:pomi_password@localhost:27017/pomi?authSource=admin`
- Connected in: `/backend/src/app.ts` (line 21)

## Frontend API Base
- Base URL: `http://localhost:3000/api/v1`
- Auth Token: Stored locally (check `authService.ts`)

---

## Testing Files
- Backend tests: `/backend/src/__tests__/`
- Run: `npm test` in backend directory
- Tests exist for: marketplace, forum, auth, admin, business, events

---

## Configuration
- Backend port: 3000 (or process.env.PORT)
- Frontend port: 5173 (Vite default)
- CORS origins: Configured in `/backend/src/app.ts` line 16
