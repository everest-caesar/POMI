# POMI Application Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    FRONTEND (React + Vite)                       │
│                    Port: 5173                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Pages:                          Components:                     │
│  ┌──────────────────┐           ┌──────────────────────────┐    │
│  │ MarketplacePage  │──────────→│ Marketplace              │    │
│  └──────────────────┘           │ MarketplaceUpload        │    │
│                                 └──────────────────────────┘    │
│  ┌──────────────────┐           ┌──────────────────────────┐    │
│  │ ForumPage        │──────────→│ ForumPage (static)       │    │
│  └──────────────────┘           └──────────────────────────┘    │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Services: authService, auth.service                      │   │
│  │ Storage: localStorage (auth tokens)                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  API Calls: fetch() → http://localhost:3000/api/v1/...         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/REST
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND (Express + TypeScript)                │
│                    Port: 3000                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  API Routes (/api/v1/):                                         │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ /marketplace     → marketplace.routes.ts                 │   │
│  │   Controller: marketplace.controller.ts                  │   │
│  │   Model: Listing.ts                                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ /forums          → forum.routes.ts                       │   │
│  │   Controller: forum.controller.ts                        │   │
│  │   Models: ForumPost.ts, ForumReply.ts                    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ /auth            → auth.routes.ts                        │   │
│  │   Controller: auth.controller.ts                         │   │
│  │   Model: User.ts                                         │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Other Routes:                                                   │
│  ├─ /events       → Event model & controller                    │
│  ├─ /businesses   → Business model & controller                 │
│  ├─ /admin        → Admin management                            │
│  ├─ /mentorship   → Mentorship (stub)                           │
│  └─ /community    → Community (stub)                            │
│                                                                   │
│  Middleware:                                                     │
│  ├─ authenticate (JWT auth middleware)                          │
│  ├─ uploadMultipleImages (file upload handler)                  │
│  ├─ CORS & Helmet (security)                                    │
│  └─ Express json parser                                         │
│                                                                   │
├─────────────────────────────────────────────────────────────────┤
│  Services:                                                       │
│  ├─ storageService.ts     → S3/MinIO uploads                    │
│  └─ adminAccount.ts       → Admin setup                         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ MongoDB Driver
                              │
┌─────────────────────────────────────────────────────────────────┐
│                         DATABASE (MongoDB)                       │
│        mongodb://localhost:27017/pomi (Docker container)        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Collections:                                                    │
│  ┌──────────┐  ┌─────────┐  ┌──────────────┐  ┌──────────┐    │
│  │ users    │  │ listings│  │ forum_posts  │  │ replies  │    │
│  │          │  │         │  │              │  │          │    │
│  │ email    │  │ title   │  │ title        │  │ postId   │    │
│  │ username │  │ price   │  │ content      │  │ content  │    │
│  │ password │  │ category│  │ authorId     │  │ authorId │    │
│  │ isAdmin  │  │ sellerId│  │ category     │  │ votes    │    │
│  │ area     │  │ status  │  │ votes        │  │ status   │    │
│  │ age      │  │ images[]│  │ status       │  │          │    │
│  └──────────┘  └─────────┘  └──────────────┘  └──────────┘    │
│                                                                   │
│  Other Collections:                                              │
│  ├─ businesses     → Business directory                          │
│  └─ events         → Events with moderation                      │
│                                                                   │
│  Relationships:                                                  │
│  ├─ Listing.sellerId     → User._id                             │
│  ├─ Listing.favorites[]  → User._id[]                           │
│  ├─ ForumPost.authorId   → User._id                             │
│  ├─ ForumReply.postId    → ForumPost._id                        │
│  └─ ForumReply.authorId  → User._id                             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    FILE STORAGE (S3 / MinIO)                     │
│                                                                   │
│  Marketplace listing images stored in:                          │
│  s3://bucket/marketplace/listings/[filename]                    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagrams

### Marketplace Listing Creation Flow

```
User fills form
    │
    ├─→ [MarketplaceUpload.tsx]
    │       │
    │       ├─→ POST /api/v1/marketplace/upload
    │       │   (images only)
    │       │
    │       └─→ [uploadListingImages handler]
    │           ├─→ storageService.uploadImages()
    │           │   └─→ S3/MinIO upload
    │           └─→ Returns imageUrls[]
    │
    ├─→ [Marketplace.tsx create form]
    │   ├─→ Collects: title, description, category, price, location, condition, images[]
    │   │
    │   └─→ POST /api/v1/marketplace/listings
    │       {title, description, category, price, location, condition, images}
    │
    └─→ [createListing handler]
        ├─→ Verify userId from token
        ├─→ Check required fields
        ├─→ Fetch user info
        ├─→ Create Listing document
        │   ├─→ If user is admin: status='active', moderationStatus='approved'
        │   └─→ If user is regular: status='inactive', moderationStatus='pending'
        ├─→ Save to MongoDB
        └─→ Return 201 with listing data
```

### Marketplace Listing Retrieval Flow

```
User navigates to marketplace
    │
    └─→ [Marketplace.tsx mounted]
        │
        ├─→ useEffect → fetchListings()
        │   │
        │   └─→ GET /api/v1/marketplace/listings?limit=60
        │
        └─→ [listListings handler]
            ├─→ Parse query: page, limit, category, search, status, moderationStatus
            ├─→ Build filter:
            │   ├─→ status = 'active'
            │   ├─→ IF NOT admin: moderationStatus = 'approved'
            │   ├─→ IF category: category filter
            │   └─→ IF search: $text search on title + description
            ├─→ Count total matching documents
            ├─→ Query with pagination & populate seller info
            ├─→ Sort by createdAt descending
            └─→ Return 200 with {data[], pagination}
                        │
                        └─→ [Marketplace.tsx renders]
                            ├─→ Filter by price range (frontend)
                            ├─→ Sort options (frontend)
                            └─→ Display as grid with images, price, condition
```

### Forum Post Creation & Reply Flow

```
User creates post
    │
    └─→ POST /api/v1/forums/posts
        {title, content, category, tags[]}
        │
        └─→ [createPost handler]
            ├─→ Verify userId
            ├─→ Fetch user for authorName
            ├─→ Create ForumPost:
            │   ├─→ status = 'published'
            │   ├─→ repliesCount = 0
            │   └─→ viewsCount = 0
            └─→ Save & return 201

User reads post
    │
    └─→ GET /api/v1/forums/posts/:id
        │
        └─→ [getPost handler]
            ├─→ Find post by ID
            ├─→ Increment viewsCount
            └─→ Return 200 with post

User adds reply
    │
    └─→ POST /api/v1/forums/posts/:id/replies
        {content}
        │
        └─→ [addReply handler]
            ├─→ Verify userId
            ├─→ Verify post exists
            ├─→ Fetch user for authorName
            ├─→ Create ForumReply:
            │   ├─→ status = 'published'
            │   └─→ votes = 0
            ├─→ Increment post.repliesCount
            └─→ Save both & return 201
```

---

## Authentication Flow

```
User submits login
    │
    └─→ POST /api/v1/auth/login
        {email, password}
        │
        └─→ [auth controller]
            ├─→ Find user by email
            ├─→ Compare password (bcryptjs)
            ├─→ Generate JWT token
            └─→ Return {token, user}
                    │
                    └─→ [authService.ts]
                        ├─→ Save token to localStorage
                        ├─→ Set Authorization header for future requests
                        └─→ Store user data locally

Protected API calls
    │
    ├─→ Include Authorization: Bearer [token]
    │
    └─→ [authenticate middleware]
        ├─→ Extract token from header
        ├─→ Verify JWT signature
        ├─→ Extract userId from token claims
        └─→ Attach userId to request object
```

---

## Model Relationships

```
┌─────────────────────────────────────────┐
│            USER                         │
├─────────────────────────────────────────┤
│ _id (ObjectId)                          │
│ email (unique)                          │
│ username                                │
│ password (hashed)                       │
│ isAdmin                                 │
│ age, area, workOrSchool                 │
└─────────────────────────────────────────┘
    ▲                   ▲               ▲
    │                   │               │
    │1:N               │1:N             │M:N
    │                   │               │
    │                   │               └──────────────────┐
    │                   │                                  │
┌───┴───────────────────┴──────────────────┐    ┌────────┴─────────┐
│        LISTING                           │    │   LISTING        │
├──────────────────────────────────────────┤    │  (favorites)     │
│ _id (ObjectId)                           │    └──────────────────┘
│ title, description                       │
│ category, price, location                │
│ sellerId (FK: User)                      │
│ sellerName                               │
│ images[], condition, status              │
│ moderationStatus, reviewedBy             │
│ favorites[] (FK: User[])                 │
│ views, createdAt, updatedAt              │
└──────────────────────────────────────────┘

        ▲
        │ 1:N
        │
┌───────┴──────────────────────────────────┐
│        FORUM POST                        │
├────────────────────────────────────────────┤
│ _id (ObjectId)                            │
│ title, content                            │
│ category, tags[]                          │
│ authorId (FK: User)                       │
│ authorName                                │
│ repliesCount, viewsCount, votes           │
│ status, createdAt, updatedAt              │
└────────────────────────────────────────────┘
        ▲
        │ 1:N
        │
┌───────┴──────────────────────────────────┐
│        FORUM REPLY                       │
├────────────────────────────────────────────┤
│ _id (ObjectId)                            │
│ postId (FK: ForumPost)                    │
│ content                                   │
│ authorId (FK: User)                       │
│ authorName                                │
│ votes, status                             │
│ createdAt, updatedAt                      │
└────────────────────────────────────────────┘
```

---

## Deployment Architecture (Current Setup)

```
┌─────────────────────────────────────────┐
│     Development Machine                 │
├─────────────────────────────────────────┤
│                                         │
│  Frontend (Vite):                       │
│  npm run dev                            │
│  http://localhost:5173                  │
│                                         │
│  Backend (Node.js):                     │
│  npm run dev (in backend)               │
│  http://localhost:3000                  │
│                                         │
└──────────────────────────────────────────┘
              │
              │ Docker Compose
              │
┌──────────────────────────────────────────┐
│     Docker Containers                    │
├──────────────────────────────────────────┤
│                                          │
│  MongoDB Container:                      │
│  mongodb://pomi_user:pomi_password@     │
│  localhost:27017/pomi                    │
│                                          │
│  (Optional) S3/MinIO Container:          │
│  Handles file uploads                    │
│                                          │
└──────────────────────────────────────────┘
```

---

## File Structure Summary

```
pomi-app/
├── backend/
│   ├── src/
│   │   ├── models/
│   │   │   ├── User.ts
│   │   │   ├── Listing.ts
│   │   │   ├── ForumPost.ts
│   │   │   ├── ForumReply.ts
│   │   │   ├── Business.ts
│   │   │   └── Event.ts
│   │   ├── controllers/
│   │   │   ├── auth.controller.ts
│   │   │   ├── marketplace.controller.ts
│   │   │   ├── forum.controller.ts
│   │   │   ├── admin.controller.ts
│   │   │   └── ... (other controllers)
│   │   ├── routes/
│   │   │   ├── auth.routes.ts
│   │   │   ├── marketplace.routes.ts
│   │   │   ├── forum.routes.ts
│   │   │   ├── index.ts
│   │   │   └── ... (other routes)
│   │   ├── middleware/
│   │   │   ├── authMiddleware.ts
│   │   │   └── uploadMiddleware.ts
│   │   ├── services/
│   │   │   ├── storageService.ts
│   │   │   └── adminAccount.ts
│   │   ├── app.ts (Express app setup)
│   │   └── index.ts (Server startup)
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── pages/
│   │   │   ├── MarketplacePage.tsx
│   │   │   ├── ForumPage.tsx
│   │   │   └── ... (other pages)
│   │   ├── components/
│   │   │   ├── Marketplace.tsx
│   │   │   ├── MarketplaceUpload.tsx
│   │   │   └── ... (other components)
│   │   ├── services/
│   │   │   ├── authService.ts
│   │   │   └── auth.service.ts
│   │   ├── App.tsx (Main app)
│   │   └── main.tsx (Entry point)
│   └── package.json
│
├── docker-compose.yml
└── CODEBASE_ANALYSIS.md (this guide)
```
