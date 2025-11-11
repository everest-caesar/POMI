# POMI Application Testing Guide

## 🧪 Comprehensive Testing Plan

### Phase 1: Backend API Testing

#### 1.1 Message API Endpoints

**Test Setup:**
- Two registered test users needed
- Valid JWT tokens for both users

**Tests:**

1. **POST /api/v1/messages** - Send a message
   ```bash
   curl -X POST http://localhost:3000/api/v1/messages \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{
       "recipientId": "USER2_ID",
       "content": "Hello, this is a test message!"
     }'
   ```
   Expected: 201 status, message object returned with timestamps

2. **GET /api/v1/messages** - Get conversations list
   ```bash
   curl -X GET http://localhost:3000/api/v1/messages \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```
   Expected: 200 status, array of conversations with unread counts

3. **GET /api/v1/messages/:recipientId** - Get conversation history
   ```bash
   curl -X GET http://localhost:3000/api/v1/messages/RECIPIENT_ID \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```
   Expected: 200 status, messages array in chronological order

4. **GET /api/v1/messages/unread/count** - Get unread count
   ```bash
   curl -X GET http://localhost:3000/api/v1/messages/unread/count \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```
   Expected: 200 status, unreadCount number

5. **PATCH /api/v1/messages/:messageId/read** - Mark as read
   ```bash
   curl -X PATCH http://localhost:3000/api/v1/messages/MESSAGE_ID/read \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```
   Expected: 200 status, message marked as read

#### 1.2 Event Notifications
- Test: Create event as non-admin → Check admin email receives notification
- Test: Create event as admin → No email should be sent
- Verify email contains event details (title, date, organizer)

#### 1.3 Marketplace Notifications
- Test: Create listing as non-admin → Check admin email
- Test: Create listing as admin → No email sent
- Verify email contains listing details (title, price, seller)

#### 1.4 Community Members API
- Test: GET /api/v1/admin/users → Returns all users with pagination
- Verify: Fields include id, username, email, area, workOrSchool, isAdmin, joinedAt

#### 1.5 Social Media Links
- Test: Create event with socialMediaLink
- Test: Invalid URL in socialMediaLink → Should be rejected
- Verify: Valid links are stored and retrieved

---

### Phase 2: Socket.io Real-Time Testing

#### 2.1 Connection & Authentication
- Test: Connect socket without userId → Should disconnect
- Test: Connect socket with userId → Should connect successfully
- Verify: User shows as online

#### 2.2 Message Delivery
- Test: Send message from User A to User B
- Test: User B receives message in real-time
- Test: Message is stored in database
- Test: Message can be retrieved via REST API

#### 2.3 Typing Indicators
- Test: User A starts typing → User B sees "is typing..."
- Test: User A stops typing → Indicator disappears
- Test: Typing indicator disappears after 3 seconds of inactivity

#### 2.4 Online Status
- Test: User A goes online → Others see online status
- Test: User A disconnects → Status changes to offline
- Test: Multiple connections per user → Shows as online if any connection active

---

### Phase 3: Frontend Component Testing

#### 3.1 Messaging Component
- [ ] Conversation list displays correctly
- [ ] Unread badges show correct count
- [ ] Selecting conversation loads messages
- [ ] Messages display in correct order (oldest to newest)
- [ ] Typing indicator animates smoothly
- [ ] Online/offline status shows correctly
- [ ] Message input handles long text
- [ ] Send button disables when input is empty

#### 3.2 Marketplace Messaging
- [ ] Message modal appears when clicking "Message seller"
- [ ] Seller name and product show in modal
- [ ] Message is sent and appears in Messaging page
- [ ] Success message displays after sending

#### 3.3 Messages Page
- [ ] Page requires authentication
- [ ] Redirects to home if not logged in
- [ ] Navbar shows "Messages" button
- [ ] Sign out button works correctly

---

### Phase 4: Email Notifications

#### 4.1 SendGrid Integration
- [ ] Welcome email sent on user registration
  - Contains: Username, greeting message

- [ ] Event creation notification (non-admin)
  - Contains: Event title, date, organizer name, organizer email

- [ ] Business listing notification (non-admin)
  - Contains: Business name, category, description

- [ ] Marketplace listing notification (non-admin)
  - Contains: Listing title, price, seller name, seller email

#### 4.2 Email Formatting
- [ ] Professional HTML template
- [ ] Consistent branding (logo, colors)
- [ ] Call-to-action links work
- [ ] Mobile responsive

---

### Phase 5: Admin Features

#### 5.1 Event Creation in Admin Portal
- [ ] Admin can create events without approval
- [ ] Event appears immediately in marketplace
- [ ] Non-admin events require approval
- [ ] Approval changes status from pending to approved

#### 5.2 Community Members View
- [ ] Admin can see all registered users
- [ ] List shows: username, email, area, work/school, join date
- [ ] Admin badge (👑) shows for admin users
- [ ] Pagination works correctly
- [ ] Search functionality works

#### 5.3 Event Performance
- [ ] Events load quickly (< 500ms)
- [ ] Database indexes are working
- [ ] Filtering by category is fast
- [ ] Text search returns relevant results

---

### Phase 6: Marketplace Features

#### 6.1 Location Field
- [ ] Location is optional in marketplace form
- [ ] Can create listing without location
- [ ] Listings without location display correctly

#### 6.2 Email Notifications
- [ ] Non-admin gets notification on new listing
- [ ] Admin gets notified of pending listings
- [ ] Email contains all listing details

#### 6.3 In-App Messaging
- [ ] "Message seller" opens messaging modal
- [ ] Can send message about specific listing
- [ ] Message appears in conversation history
- [ ] Message links to specific listing (if applicable)

---

## 🚀 Manual Testing Checklist

### Before Going Live:
- [ ] Backend builds without errors
- [ ] Frontend builds without errors
- [ ] Database has test data (2+ users, some messages)
- [ ] SendGrid credentials configured
- [ ] Socket.io server running
- [ ] All endpoints return correct status codes
- [ ] Error messages are user-friendly
- [ ] No console errors in browser
- [ ] No server logs show errors
- [ ] All features work on mobile view

### Regression Testing:
- [ ] Existing login flow still works
- [ ] Existing marketplace browsing works
- [ ] Existing event browsing works
- [ ] Business directory still works
- [ ] Forums still work
- [ ] Admin portal still works
- [ ] Can still create listings
- [ ] Can still RSVP to events
- [ ] Can still create events

---

## 🔍 Testing Results Template

```
Date: [TODAY]
Tester: [NAME]
Version: [GIT COMMIT]

### Critical Issues Found:
[ List any blocking bugs ]

### Minor Issues Found:
[ List non-blocking issues ]

### Features Verified:
[ ] Messages API working
[ ] Socket.io real-time working
[ ] Email notifications sending
[ ] Admin features functional
[ ] Marketplace integration complete
[ ] Frontend renders correctly
[ ] Performance acceptable
[ ] No console errors

### Sign-Off:
Testing completed: [YES/NO]
Ready for deployment: [YES/NO]
```

---

## 📊 Performance Benchmarks

Expected response times:
- Message send: < 200ms
- Get conversations: < 300ms
- Get conversation history: < 500ms
- Get unread count: < 100ms
- Event creation: < 300ms
- Listing creation: < 300ms

Expected load times:
- Messages page: < 1s
- Conversation load: < 500ms
- Message history pagination: < 300ms

---

## 🐛 Known Issues & Workarounds

(To be updated during testing)

---

## ✅ Sign-Off

All tests completed by: _______________
Date: _______________
Status: [ ] PASS [ ] FAIL
