# POMI App - Implementation Specification

## Overview

This document details the complete implementation plan for Phase 2 features:
1. Email notification system (SendGrid)
2. Buyer-seller role separation with dashboards
3. Real-time messaging system
4. Marketplace contact fields (phone, email)
5. Forum improvements (sorting, filtering, voting)

---

## 1. EMAIL NOTIFICATION SYSTEM

### Architecture

```
User Action (e.g., listing inquiry)
    ↓
Controller receives request
    ↓
Create Message in DB
    ↓
Email Service queues email
    ↓
SendGrid API sends async
    ↓
Email delivered to recipient
```

### Backend Implementation

#### 1.1 Create Email Service

**File**: `backend/src/services/emailService.ts`

```typescript
import sgMail from '@sendgrid/mail';

export class EmailService {
  constructor() {
    sgMail.setApiKey(process.env.SENDGRID_API_KEY);
  }

  // Template: New listing inquiry
  async sendListingInquiry(sellerEmail: string, buyerName: string, listingTitle: string) {}

  // Template: New message notification
  async sendNewMessage(recipientEmail: string, senderName: string, message: string) {}

  // Template: Forum reply notification
  async sendForumReplyNotification(userEmail: string, replierName: string, postTitle: string) {}

  // Template: Event update notification
  async sendEventNotification(organizerEmail: string, eventTitle: string, updateType: string) {}

  // Template: Order confirmation
  async sendOrderConfirmation(buyerEmail: string, listingTitle: string, totalPrice: number) {}

  // Generic email sender
  async sendEmail(to: string, subject: string, htmlContent: string) {}
}
```

#### 1.2 Install SendGrid

```bash
npm install @sendgrid/mail
```

#### 1.3 Email Templates

**Directory**: `backend/src/templates/emails/`

Templates needed:
- `listing-inquiry.html` - When buyer inquires about listing
- `new-message.html` - When seller receives message from buyer
- `forum-reply.html` - When user gets reply on forum post
- `order-confirmation.html` - When order is placed
- `event-created.html` - When event is created and approved
- `message-seller.html` - Buyer wants to contact seller

### Triggering Emails

Email events to implement:

| Event | Trigger | Recipients | Template |
|-------|---------|------------|----------|
| Listing Inquiry | Buyer clicks "Message Seller" | Seller | listing-inquiry.html |
| New Message | Buyer sends message | Seller | new-message.html |
| Forum Reply | User replies to thread | Original poster | forum-reply.html |
| Event Approved | Admin approves event | Event organizer | event-created.html |
| Event Updated | Organizer updates event | Event attendees | event-created.html |
| User Mentioned | Someone @mentions user | Mentioned user | forum-reply.html |

---

## 2. BUYER-SELLER ROLE SEPARATION

### Database Changes

#### 2.1 Update User Model

**File**: `backend/src/models/User.ts`

Add fields:
```typescript
interface IUser extends Document {
  // ... existing fields ...

  // New fields
  role: 'buyer' | 'seller' | 'both'; // Default: 'both'
  phoneNumber?: string;
  phoneVerified?: boolean;
  sellerRating?: number; // Average rating 1-5
  sellerReviewCount?: number;
  sellerJoinedDate?: Date;
  isSeller: boolean; // Quick lookup

  // Preferences
  preferredContactMethod?: 'phone' | 'email' | 'message'; // Default: 'message'
  allowPhonePublic?: boolean; // Default: false
  allowEmailPublic?: boolean; // Default: false
}
```

Schema validation:
```typescript
phoneNumber: {
  type: String,
  validate: {
    validator: (phone: string) => {
      // Canadian phone: XXX-XXX-XXXX or (XXX) XXX-XXXX
      const regex = /^(?:\+?1[-.]?)?(?:\([0-9]{3}\)[-.]?)?[0-9]{3}[-.]?[0-9]{4}$/;
      return !phone || regex.test(phone);
    },
    message: 'Invalid phone number format'
  }
}
```

#### 2.2 Update Listing Model

**File**: `backend/src/models/Listing.ts`

Add fields:
```typescript
sellerPhone?: string;      // From user
sellerEmail: string;       // From user
sellerName: string;        // Denormalized
sellerId: ObjectId;        // Already exists
sellerRating?: number;     // Denormalized for quick display
status: 'active' | 'sold' | 'pending' | 'delisted'; // Default: 'active'
```

#### 2.3 Create Message Model

**File**: `backend/src/models/Message.ts`

```typescript
interface IMessage extends Document {
  conversationId: ObjectId; // Composite of buyerId + sellerId + listingId
  senderId: ObjectId;
  recipientId: ObjectId;
  listingId: ObjectId;

  messageText: string;
  attachments?: string[]; // URLs

  isRead: boolean;
  readAt?: Date;

  createdAt: Date;
  updatedAt: Date;
}

interface IConversation extends Document {
  participantIds: [buyerId: ObjectId, sellerId: ObjectId];
  listingId: ObjectId;

  lastMessage: string;
  lastMessageTime: Date;
  lastMessageSenderId: ObjectId;

  unreadCounts: {
    buyerId: number;
    sellerId: number;
  };

  isBlocked: boolean;
  blockedBy?: ObjectId;

  createdAt: Date;
  updatedAt: Date;
}
```

### API Endpoints

#### 2.4 Seller-specific Endpoints

```
GET /api/v1/seller/dashboard
  - Total listings
  - Total sales
  - Earnings
  - Pending messages count
  - Rating/reviews

GET /api/v1/seller/listings
  - User's listings with status

GET /api/v1/seller/analytics
  - Views per listing
  - Inquiry count
  - Conversion rate

PUT /api/v1/seller/profile
  - Update phone, email, preferences
  - Verify phone/email

GET /api/v1/seller/reviews
  - All reviews/ratings from buyers
```

#### 2.5 Buyer-specific Endpoints

```
GET /api/v1/buyer/dashboard
  - Active chats with sellers
  - Saved listings
  - Purchase history

GET /api/v1/buyer/purchases
  - Orders/purchases made
  - Review sellers

GET /api/v1/buyer/conversations
  - All message threads with sellers
```

#### 2.6 Messaging Endpoints

```
POST /api/v1/messages
  - Send message to seller
  - Input: listingId, messageText
  - Returns: message + conversation

GET /api/v1/conversations
  - List all conversations for user

GET /api/v1/conversations/:conversationId/messages
  - Paginated messages in thread

PUT /api/v1/messages/:messageId/read
  - Mark message as read

DELETE /api/v1/conversations/:conversationId
  - Delete conversation thread

POST /api/v1/conversations/:conversationId/block
  - Block user in conversation
```

### Frontend Implementation

#### 2.7 Seller Dashboard

**File**: `frontend/src/pages/SellerDashboard.tsx`

Components:
- Overview card (total listings, sales, earnings)
- Listings table (list, edit, delete, view inquiries)
- Messages panel (unread count, threads)
- Analytics chart (views, inquiries, conversions)
- Profile settings (phone, email, contact preferences)

#### 2.8 Buyer Dashboard

**File**: `frontend/src/pages/BuyerDashboard.tsx`

Components:
- Active conversations
- Saved listings (wishlist)
- Purchase history
- Seller reviews

#### 2.9 Messaging Component

**File**: `frontend/src/components/MessagingThread.tsx`

Features:
- Message thread with pagination
- Real-time message display
- Mark as read
- File upload/attachment support
- Typing indicator (future: WebSocket)
- Block user option

#### 2.10 Role-based UI

Update components to show different UI based on role:
- Seller sees: Edit/Delete buttons, View inquiries, Analytics
- Buyer sees: Message seller, Add to wishlist, Purchase history

---

## 3. MARKETPLACE CONTACT FIELDS

### Database Changes

Listing model already updated in section 2.2

### Form Changes

#### 3.1 Create/Update Listing Form

Add fields to marketplace upload form:

```typescript
interface ListingFormData {
  // ... existing fields ...

  sellerPhone: string;           // Required
  sellerEmail: string;           // Optional (auto-filled from user)
  preferredContactMethod: 'phone' | 'email' | 'message'; // Required
  showPhonePublicly: boolean;    // Default: false
  showEmailPublicly: boolean;    // Default: false
}
```

Form UI:
```jsx
<div>
  <label>Phone Number *</label>
  <PhoneInput
    value={formData.sellerPhone}
    placeholder="(613) 555-1234"
    onChange={setSellerPhone}
  />
</div>

<div>
  <label>Email Address</label>
  <input
    type="email"
    value={formData.sellerEmail || userEmail}
    placeholder="example@email.com"
  />
</div>

<div>
  <label>Preferred Contact Method *</label>
  <select value={preferredContactMethod}>
    <option value="message">Message in App</option>
    <option value="phone">Phone Call</option>
    <option value="email">Email</option>
  </select>
</div>

<div>
  <label>
    <input
      type="checkbox"
      checked={showPhonePublicly}
    />
    Show phone number publicly
  </label>
</div>

<div>
  <label>
    <input
      type="checkbox"
      checked={showEmailPublicly}
    />
    Show email publicly
  </label>
</div>
```

#### 3.2 Listing Display

When viewing listing, show seller contact:
```jsx
<div className="seller-info">
  <h3>{sellerName}</h3>
  <p className="rating">⭐ {sellerRating} ({reviewCount} reviews)</p>

  {showPhonePublicly && (
    <button onClick={() => handleContactSeller('phone')}>
      📞 Call Seller
    </button>
  )}

  {showEmailPublicly && (
    <button onClick={() => handleContactSeller('email')}>
      ✉️ Email Seller
    </button>
  )}

  <button onClick={() => handleContactSeller('message')}>
    💬 Message Seller
  </button>
</div>
```

---

## 4. REAL-TIME MESSAGING

### Architecture

**Initial Phase (REST API)**:
- No real-time requirement
- Polling or refresh on focus
- Simple, reliable

**Future Phase (WebSocket)**:
- Socket.io for real-time
- Typing indicators
- Delivery status
- Read receipts

### Implementation

#### 4.1 Message Controller

**File**: `backend/src/controllers/messageController.ts`

```typescript
export const sendMessage = async (req: Request, res: Response) => {
  // 1. Validate user is authenticated
  // 2. Fetch listing and seller
  // 3. Create conversation if new
  // 4. Save message to DB
  // 5. Mark read = false initially
  // 6. Queue email notification
  // 7. Return message + conversation
}

export const getConversations = async (req: Request, res: Response) => {
  // 1. Get all conversations for user
  // 2. Sort by lastMessageTime DESC
  // 3. Include unread count
  // 4. Paginate results
}

export const getMessages = async (req: Request, res: Response) => {
  // 1. Get all messages in conversation
  // 2. Paginate (20 per page)
  // 3. Sort by createdAt DESC
  // 4. Auto mark as read (return same timestamp)
}

export const markAsRead = async (req: Request, res: Response) => {
  // 1. Update message.isRead = true
  // 2. Update message.readAt = now
  // 3. Decrement conversation.unreadCounts
}

export const deleteConversation = async (req: Request, res: Response) => {
  // 1. Soft delete conversation
  // 2. Delete all messages in thread
  // 3. Return success
}

export const blockUser = async (req: Request, res: Response) => {
  // 1. Update conversation.isBlocked = true
  // 2. Update conversation.blockedBy = userId
  // 3. Prevent further messages
}
```

#### 4.2 Message Routes

**File**: `backend/src/routes/messageRoutes.ts`

```typescript
router.post('/messages', authMiddleware, sendMessage);
router.get('/conversations', authMiddleware, getConversations);
router.get('/conversations/:conversationId/messages', authMiddleware, getMessages);
router.put('/messages/:messageId/read', authMiddleware, markAsRead);
router.delete('/conversations/:conversationId', authMiddleware, deleteConversation);
router.post('/conversations/:conversationId/block', authMiddleware, blockUser);
```

---

## 5. FORUM IMPROVEMENTS

### 5.1 Sorting & Filtering

#### Backend Changes

Add sorting to forum posts endpoint:

```typescript
GET /api/v1/forum/posts?sort=relevant&category=business&search=...

Sort options:
- relevant: (score based on votes + replies + recency) DESC
- popular: upvotes DESC
- newest: createdAt DESC
- oldest: createdAt ASC
- most-replies: replyCount DESC
```

#### 5.2 Forum Post Model Updates

**File**: `backend/src/models/ForumPost.ts`

Add fields:
```typescript
interface IForumPost extends Document {
  // ... existing ...

  upvotes: number;
  downvotes: number;
  score: number; // Computed: upvotes - downvotes
  replyCount: number;

  userVotes: {
    userId: ObjectId;
    voteType: 'up' | 'down';
  }[];

  isMarkedSolution?: boolean;
  solutionMarkerId?: ObjectId;

  isPinned?: boolean;
  pinOrder?: number;
}
```

#### 5.3 Voting System

```typescript
POST /api/v1/forum/posts/:postId/upvote
POST /api/v1/forum/posts/:postId/downvote
DELETE /api/v1/forum/posts/:postId/vote

PUT /api/v1/forum/posts/:postId/mark-solution
PUT /api/v1/forum/posts/:postId/pin (admin only)
```

#### 5.4 Mentions System

Support @mentions in forum:

```typescript
// In post/reply text, find @username
// Extract mentioned usernames
// Send email notifications to mentioned users
// In UI, highlight @username mentions
```

### 5.5 Frontend Components

#### Sorting UI

```jsx
<div className="forum-controls">
  <div className="sort-buttons">
    <button className={sort === 'relevant' ? 'active' : ''}>
      Most Relevant
    </button>
    <button className={sort === 'popular' ? 'active' : ''}>
      Most Popular
    </button>
    <button className={sort === 'newest' ? 'active' : ''}>
      Newest
    </button>
    <button className={sort === 'oldest' ? 'active' : ''}>
      Oldest
    </button>
    <button className={sort === 'most-replies' ? 'active' : ''}>
      Most Replies
    </button>
  </div>

  <div className="category-filter">
    <select onChange={(e) => setCategory(e.target.value)}>
      <option value="">All Categories</option>
      <option value="business">Business</option>
      <option value="general">General</option>
      <option value="help">Help & Support</option>
    </select>
  </div>

  <div className="search">
    <input
      placeholder="Search posts..."
      onChange={(e) => setSearch(e.target.value)}
    />
  </div>
</div>
```

#### Voting UI

```jsx
<div className="post-voting">
  <button onClick={() => handleVote('up')} className={userVote === 'up' ? 'active' : ''}>
    👍 {upvotes}
  </button>
  <button onClick={() => handleVote('down')} className={userVote === 'down' ? 'active' : ''}>
    👎 {downvotes}
  </button>
</div>
```

---

## 6. DATABASE INDEXES

Add these indexes for performance:

```typescript
// User indexes
userSchema.index({ phoneNumber: 1 });
userSchema.index({ isSeller: 1 });
userSchema.index({ sellerRating: -1 });

// Listing indexes
listingSchema.index({ sellerId: 1 });
listingSchema.index({ status: 1 });
listingSchema.index({ sellerRating: -1 });

// Message indexes
messageSchema.index({ conversationId: 1 });
messageSchema.index({ senderId: 1 });
messageSchema.index({ recipientId: 1 });
messageSchema.index({ isRead: 1 });
messageSchema.index({ createdAt: -1 });

conversationSchema.index({ participantIds: 1 });
conversationSchema.index({ listingId: 1 });
conversationSchema.index({ lastMessageTime: -1 });

// Forum indexes
forumPostSchema.index({ score: -1, createdAt: -1 });
forumPostSchema.index({ upvotes: -1 });
forumPostSchema.index({ replyCount: -1 });
forumPostSchema.index({ createdAt: -1 });
forumPostSchema.index({ category: 1 });
forumPostSchema.index({ authorId: 1 });
```

---

## 7. IMPLEMENTATION TIMELINE

### Week 1: Foundation
- [ ] Install SendGrid
- [ ] Create email service with templates
- [ ] Update User model (phone, roles)
- [ ] Create Message and Conversation models
- [ ] Create message controller and routes
- [ ] Test locally

### Week 2: Messaging Features
- [ ] Build messaging APIs
- [ ] Build seller dashboard backend
- [ ] Build buyer dashboard backend
- [ ] Add phone validation
- [ ] Implement email triggers

### Week 3: Frontend - Dashboards
- [ ] Create Seller Dashboard component
- [ ] Create Buyer Dashboard component
- [ ] Create Messaging UI
- [ ] Add contact preferences form
- [ ] Update listing display with seller info

### Week 4: Forum & Polish
- [ ] Add forum sorting APIs
- [ ] Add forum voting system
- [ ] Build forum UI updates
- [ ] Add @mention system
- [ ] Test all features

### Week 5: Deployment
- [ ] Deploy to production
- [ ] Full testing
- [ ] Bug fixes

---

## 8. BEST PRACTICES

### Security
- ✅ Phone numbers encrypted in DB
- ✅ Never expose user phone publicly unless opted-in
- ✅ Validate all email addresses
- ✅ Rate limit messaging to prevent spam
- ✅ Validate message length (max 1000 chars)
- ✅ Sanitize HTML in messages (prevent XSS)

### Performance
- ✅ Index all query fields
- ✅ Paginate message threads
- ✅ Cache conversation list
- ✅ Lazy load messages
- ✅ Archive old conversations (90 days)

### User Experience
- ✅ Real-time message badge on conversation button
- ✅ Typing indicator (future)
- ✅ Delivery status indicator
- ✅ Read receipts
- ✅ Easy blocking/reporting
- ✅ Clear notification emails

---

## 9. SUCCESS CRITERIA

### Messaging
- [ ] Users can send messages between buyer/seller
- [ ] Seller receives email notification
- [ ] Messages persist and display correctly
- [ ] Conversation thread groups messages
- [ ] Mark as read functionality works
- [ ] Block user prevents messages

### Email Notifications
- [ ] SendGrid API key configured
- [ ] Email templates render correctly
- [ ] Emails deliver to inbox (not spam)
- [ ] Unsubscribe link in emails
- [ ] Email logs available in SendGrid dashboard

### Dashboards
- [ ] Seller sees all their listings
- [ ] Seller sees message count
- [ ] Seller sees earnings/analytics
- [ ] Buyer sees purchase history
- [ ] Both can update profile/contact preferences

### Forum
- [ ] Sorting changes order of posts
- [ ] Voting increases/decreases score
- [ ] @mentions send notifications
- [ ] Category filter works

---

**Next Step**: Execute implementation according to timeline
**Estimated Duration**: 5 weeks full-time, 10-12 weeks part-time
**Resources Needed**: SendGrid API key, MongoDB instance, AWS S3 account
