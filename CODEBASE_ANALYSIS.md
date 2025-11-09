# POMI Codebase Analysis: Marketplace & Forum Implementation

## Executive Summary
The POMI application has a functional marketplace and forum system with basic CRUD operations. Both systems are currently basic implementations without direct messaging/communication features. The User model lacks phone numbers, and there are no built-in email/notification systems.

---

## 1. MARKETPLACE STRUCTURE

### Backend Files
**Models:**
- `/backend/src/models/Listing.ts` - MongoDB schema for marketplace listings

**Controllers:**
- `/backend/src/controllers/marketplace.controller.ts` - All marketplace logic

**Routes:**
- `/backend/src/routes/marketplace.routes.ts` - API endpoints

**Tests:**
- `/backend/src/__tests__/marketplace.test.ts`
- `/backend/src/controllers/__tests__/marketplace.upload.test.ts`

### Frontend Files
**Pages:**
- `/frontend/src/pages/MarketplacePage.tsx` - Main marketplace page

**Components:**
- `/frontend/src/components/Marketplace.tsx` - Main marketplace component with listings display
- `/frontend/src/components/MarketplaceUpload.tsx` - Upload new listing form

### Listing Data Structure (IListing)
```typescript
{
  _id: ObjectId,
  title: string,                      // 5-150 chars, required
  description: string,                // 10-5000 chars, required
  category: string,                   // electronics, furniture, clothing, books, sports, toys, home, services, other
  price: number,                      // required, min 0
  location: string,                   // required
  sellerId: ObjectId (ref: User),     // required
  sellerName: string,                 // required
  images: string[],                   // array of image URLs
  status: string,                     // 'active' | 'sold' | 'inactive'
  condition?: string,                 // 'new' | 'like-new' | 'good' | 'fair'
  favorites: ObjectId[],              // array of user IDs who favorited
  views: number,                      // default 0
  
  // Moderation fields
  moderationStatus: string,           // 'pending' | 'approved' | 'rejected'
  reviewedBy?: ObjectId (ref: User),
  reviewedAt?: Date,
  rejectionReason?: string (max 500),
  
  createdAt: Date,
  updatedAt: Date
}
```

### Listing Lifecycle
1. **Creation** (`POST /api/v1/marketplace/listings`)
   - Requires: title, price, category
   - Regular users: status='inactive', moderationStatus='pending'
   - Admin users: status='active', moderationStatus='approved', auto-reviewed

2. **Retrieval** 
   - List listings: `GET /api/v1/marketplace/listings?page=1&limit=20&category=electronics&search=keyword`
   - Only shows 'approved' or non-moderation status listings to public
   - Admin can see pending/rejected via moderationStatus filter
   - Paginated results with seller info populated
   - Get single: `GET /api/v1/marketplace/listings/:id` (increments views)

3. **Update** (`PUT /api/v1/marketplace/listings/:id`)
   - Owner/admin only
   - Allowed fields: title, description, price, location, category, condition, status, images
   - Admin can approve/reject with moderationStatus
   - User edits revert to pending status

4. **Delete** (`DELETE /api/v1/marketplace/listings/:id`)
   - Owner/admin only

5. **Favorites** (`POST /api/v1/marketplace/listings/:id/favorite`)
   - Toggle favorite status
   - Only for approved listings

6. **Images** (`POST /api/v1/marketplace/upload`)
   - Requires: file uploads
   - Uploads to S3/MinIO storage service

### Frontend Display
- Grid layout with category filtering (10 categories)
- Price filtering (budget, mid, premium ranges)
- Sort options: newest, price-low, price-high, popular
- Image carousel for each listing
- Condition badges with color coding
- View count and favorite buttons
- Real API calls to `http://localhost:3000/api/v1/marketplace/listings`

### Key Features Present
✓ Image upload with storage service
✓ Admin moderation workflow
✓ Favorite/wishlist system
✓ View tracking
✓ Search and filtering
✓ Price range filtering
✓ Condition tracking

### Key Features Missing
✗ Direct messaging between buyer/seller
✗ Seller contact information (no phone in User model)
✗ Comments/questions on listings
✗ Review/rating system for transactions
✗ Negotiation/offer system
✗ Email notifications

---

## 2. FORUM STRUCTURE

### Backend Files
**Models:**
- `/backend/src/models/ForumPost.ts` - Schema for forum threads
- `/backend/src/models/ForumReply.ts` - Schema for forum replies/comments

**Controllers:**
- `/backend/src/controllers/forum.controller.ts` - All forum logic

**Routes:**
- `/backend/src/routes/forum.routes.ts` - API endpoints

**Tests:**
- `/backend/src/__tests__/forum.test.ts`

### Frontend Files
**Pages:**
- `/frontend/src/pages/ForumPage.tsx` - Main forum page (currently static mockup)

### ForumPost Data Structure (IForumPost)
```typescript
{
  _id: ObjectId,
  title: string,                      // 3-200 chars, required, indexed
  content: string,                    // 10-5000 chars, required
  category: string,                   // general, culture, business, technology, education, health, events, other
  tags: string[],                     // array of tag strings
  authorId: ObjectId (ref: User),     // required, indexed
  authorName: string,                 // required
  
  // Engagement metrics
  repliesCount: number,               // default 0
  viewsCount: number,                 // default 0
  votes: number,                      // default 0
  
  status: string,                     // 'published' | 'archived' | 'deleted'
  createdAt: Date,
  updatedAt: Date
}
```

### ForumReply Data Structure (IForumReply)
```typescript
{
  _id: ObjectId,
  postId: ObjectId (ref: ForumPost),  // required, indexed
  content: string,                    // 3-3000 chars, required
  authorId: ObjectId (ref: User),     // required, indexed
  authorName: string,                 // required
  
  votes: number,                      // default 0
  status: string,                     // 'published' | 'deleted'
  
  createdAt: Date,
  updatedAt: Date
}
```

### Forum Lifecycle
1. **Create Post** (`POST /api/v1/forums/posts`)
   - Requires: title, content, category
   - Tags optional
   - Requires authentication
   - Auto-published as 'published'

2. **List Posts** (`GET /api/v1/forums/posts?page=1&limit=20&category=business&search=keyword`)
   - Only shows 'published' posts
   - Paginated with author info populated
   - Sort by newest first
   - Text search support

3. **Get Post** (`GET /api/v1/forums/posts/:id`)
   - Auto-increments viewsCount

4. **Update Post** (`PUT /api/v1/forums/posts/:id`)
   - Author only
   - Can update: title, content, category, tags, status

5. **Delete Post** (`DELETE /api/v1/forums/posts/:id`)
   - Author only

6. **Add Reply** (`POST /api/v1/forums/posts/:id/replies`)
   - Requires: content
   - Auto-publishes as 'published'
   - Increments post's repliesCount
   - Requires authentication

7. **List Replies** (`GET /api/v1/forums/posts/:id/replies?page=1&limit=20`)
   - Only shows 'published' replies
   - Sorted by creation time (oldest first)
   - Paginated with author info

### Frontend Display
- Currently static mockup with hardcoded posts
- Shows sample posts with:
  - Community/subreddit style display (r/OttawaHabesha, r/PomiMarketplace, etc.)
  - Author and timestamp
  - Vote counts and comment counts
  - Trending communities sidebar
  - Forum rules sidebar
  - "Create post" button (not functional yet)

### Key Features Present
✓ Create/read/update/delete posts
✓ Replies to posts (comments/threading)
✓ Vote tracking (data field, not UI functionality)
✓ View count tracking
✓ Reply count tracking
✓ Archive/delete status management
✓ Text search support
✓ Category filtering

### Key Features Missing
✗ Real-time comments (currently static frontend)
✗ Vote UI/functionality
✗ Direct messaging from forum threads
✗ Mention/tag system (@username)
✗ Email notifications for replies
✗ Moderation tools
✗ Post pinning or featured posts
✗ Threading depth visualization

---

## 3. USER MODEL STRUCTURE

### Backend File
- `/backend/src/models/User.ts`

### User Data Structure (IUser)
```typescript
{
  _id: ObjectId,
  email: string,                      // required, unique, lowercase, email regex validation
  password: string,                   // required, min 6 chars, hashed with bcryptjs
  username: string,                   // required, trimmed
  age?: number,                       // optional, min 13, max 120
  area?: string,                      // optional, enum of Ottawa neighborhoods:
                                      // - Downtown Ottawa
                                      // - Barrhaven
                                      // - Kanata
                                      // - Nepean
                                      // - Gloucester
                                      // - Orleans
                                      // - Vanier
                                      // - Westboro
                                      // - Rockcliffe Park
                                      // - Sandy Hill
                                      // - The Glebe
                                      // - Bytown
                                      // - South Ottawa
                                      // - North Ottawa
                                      // - Outside Ottawa
  workOrSchool?: string,              // optional, trimmed
  isAdmin: boolean,                   // default false
  createdAt: Date,
  updatedAt: Date
}
```

### Key Fields
| Field | Type | Notes |
|-------|------|-------|
| email | string | Unique, required, must be valid email format |
| username | string | Required, public identifier |
| password | string | Required, auto-hashed with bcryptjs before save |
| age | number | Optional, 13-120 range |
| area | string | Optional, limited to Ottawa neighborhoods |
| workOrSchool | string | Optional, free text |
| isAdmin | boolean | Controls moderation capabilities |

### Missing Fields
✗ **Phone number** - NOT stored in User model
✗ **Phone contact** - Stored on Business model, but not User
✗ **Role/seller distinction** - Not explicitly marked as buyer/seller/business owner (tracked via relationships)
✗ **Verification status** - No email verification field
✗ **Reputation/rating** - No user rating score
✗ **Avatar/profile picture** - No profile image
✗ **Bio/profile text** - No extended profile information

### Password Security
- Hashed using bcryptjs with salt 10
- Pre-save middleware auto-hashes new passwords
- comparePassword() method for authentication
- Password field not included in default queries (select: false)

---

## 4. EXISTING COMMUNICATION SYSTEMS

### Email/Notification Services
**Status: NOT IMPLEMENTED**
- No nodemailer, SendGrid, Twilio, or similar packages in use
- No email notification service configured
- Backend has NO email sending capability

### Messaging Systems
**Status: NOT IMPLEMENTED**
- No direct messaging model or controller
- No private message routes
- Marketplace has no inquiry/contact system
- Forum has no private message system

### What Communication Exists
1. **Forum Replies** - Public discussion only
   - Can reply to posts in forum
   - No private messaging between users
   - No notification system

2. **Marketplace Favorites** - One-way save only
   - Users can save listings they like
   - No contact/inquiry sent to seller
   - Seller has no notification

3. **Admin Reviews** - Internal only
   - Admins can approve/reject listings with rejection reason
   - No automated email notification to user

### Related Models
The **Business** model (`/backend/src/models/Business.ts`) has:
```typescript
{
  phone?: string,
  email?: string,
  address?: string,
  // ... other fields
}
```
This is business contact info, NOT user contact info.

---

## 5. BACKEND ARCHITECTURE

### Route Structure (`/api/v1/...`)
```
/auth          - Authentication (login, register, logout)
/events        - Events management (Create, browse events)
/marketplace   - Marketplace listings (CRUD, favorites, image upload)
/businesses    - Business directory (CRUD, listings)
/forums        - Forum posts and replies (CRUD)
/mentorship    - Mentorship programs (stub)
/community     - Community resources (stub)
/admin         - Admin management & moderation
```

### Middleware Stack
- Express.json() - JSON parsing
- CORS - Allow frontend at localhost:5173
- Helmet - Security headers
- MongoDB connection on startup
- Auth middleware on protected routes
- Upload middleware for image handling

### Database
- MongoDB (mongoose ODM)
- Collections: User, Listing, ForumPost, ForumReply, Business, Event
- URI: mongodb://pomi_user:pomi_password@localhost:27017/pomi?authSource=admin

### Services
- `/backend/src/services/storageService.ts` - S3/MinIO image uploads
- `/backend/src/services/adminAccount.ts` - Admin account setup

---

## 6. FRONTEND ARCHITECTURE

### Main App Routes
- `/` - Home page
- `/marketplace` - Marketplace listings
- `/forum` - Forum discussions
- `/admin` - Admin portal
- `/auth` - Authentication

### Components
**Marketplace:**
- `Marketplace.tsx` - Main listing display with filters, search, sorting
- `MarketplaceUpload.tsx` - Create new listing form
- `MarketplacePage.tsx` - Page wrapper

**Forum:**
- `ForumPage.tsx` - Static mockup (sample posts hardcoded)

**Other:**
- `AdminPortal.tsx` - Admin management interface
- `EnhancedAuthForm.tsx` - Login/register
- `Events.tsx` - Event management
- `BusinessUpload.tsx` - Business directory uploads

### API Integration
**Direct fetch() calls** (no API service layer)
- `http://localhost:3000/api/v1/marketplace/listings`
- `http://localhost:3000/api/v1/marketplace/listings/:id`
- `http://localhost:3000/api/v1/marketplace/upload`

---

## 7. IMPLEMENTATION SUMMARY

### What's Fully Implemented
✓ Marketplace CRUD with moderation workflow
✓ Forum posts with replies (backend complete)
✓ User authentication with roles
✓ Admin moderation panel
✓ Image upload to S3/MinIO
✓ Search and filtering
✓ Favorite/wishlist system
✓ View tracking
✓ Business directory (CRUD)
✓ Events (CRUD with moderation)

### What's Partially Implemented
⚠ Forum frontend - Backend complete, frontend is static mockup
⚠ Forum voting - Data stored, but no UI

### What's Missing
✗ User-to-user messaging
✗ Email notifications
✗ Phone contact information in User model
✗ Seller rating/review system
✗ Listing inquiry/offer system
✗ Transaction management
✗ Payment integration (Stripe mentioned in Event model but not implemented)
✗ Real-time updates/websockets
✗ Forum moderation tools
✗ User mention/tag system
✗ User profile pages
✗ Social features (follow, recommendations)

---

## 8. KEY INSIGHTS FOR DEVELOPMENT

### For Adding Messaging Features
1. **Contact Model Needed:**
   ```typescript
   - senderUserId (ref: User)
   - recipientUserId (ref: User)
   - listingId? (ref: Listing) - optional link to listing
   - subject: string
   - message: string
   - read: boolean
   - archived: boolean
   - createdAt, updatedAt
   ```

2. **Phone Number Implementation:**
   - Add `phone?: string` field to User model
   - Consider validation format
   - Make optional or required based on use case

3. **Notification System:**
   - Create Notification model
   - Implement email service (nodemailer/SendGrid)
   - Add notification triggers:
     - Listing inquiry received
     - Forum reply to user's post
     - Admin action notifications
     - New forum posts in subscribed categories

### For Completing Forum Frontend
1. Implement real API calls instead of static mockup
2. Add create post functionality
3. Add voting UI and functionality
4. Implement real-time reply loading
5. Add post editing/deletion UI

### For Marketplace Enhancement
1. Add inquiry/messaging on listing view
2. Integrate seller ratings/reviews
3. Add negotiation/offer workflow
4. Create transaction history

### Database Indexes Present
Good news: Proper indexes already exist for:
- Text search on listings and posts
- Category + status for filtering
- User ID for ownership queries
- Creation date for sorting

