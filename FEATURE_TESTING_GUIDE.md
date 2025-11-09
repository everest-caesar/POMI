# 🧪 Feature Testing Guide - Complete Instructions

**Date:** October 27, 2025
**Status:** Ready for Manual Testing
**All Code:** ✅ Written, integrated, and compiled

---

## 🚀 QUICK START - How to Test

### Prerequisites
```bash
# In your terminal, from the pomi-app directory
cd /Users/everestode/Desktop/POMI/pomi-app

# Install dependencies
npm install
npm install @aws-sdk/client-s3 @aws-sdk/s3-request-presigner

# Start MongoDB, PostgreSQL, Redis (via Docker)
docker-compose up -d

# Verify databases are running
docker-compose ps
```

### Start Servers (Two separate terminals)

**Terminal 1 - Backend:**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app/backend

# Option A: Development mode (auto-reload on changes)
npm run dev

# Option B: Compiled mode (if tsx has issues)
npm run build
node dist/index.js
```

**Terminal 2 - Frontend:**
```bash
cd /Users/everestode/Desktop/POMI/pomi-app/frontend
npm run dev
```

**Expected Output:**
- Backend: `Server running on port 3000` ✅
- Frontend: `VITE v5.x.x Local: http://localhost:5173/` ✅

---

## 📋 TEST 1: Enhanced Sign-Up Form

### What to Test
New sign-up fields should appear and be functional.

### Step-by-Step Instructions

#### 1. Open Sign-Up Modal
```
1. Go to: http://localhost:5173
2. Click "Sign Up" button (top right)
3. Wait for modal to appear
```

#### 2. Verify All Fields Present
In the sign-up form, you should see:
```
✅ Full Name (required) - Text input
✅ Email Address (required) - Email input
✅ Password (required) - Password input
✅ Age (optional) - Number input
✅ Area in Ottawa (optional) - Dropdown select
✅ School or Workplace (optional) - Text input
```

#### 3. Test Required Fields Only (Minimal Sign-Up)
```
Input:
  Full Name:  Jane Smith
  Email:      jane.smith@example.com
  Password:   TestPass123!

Expected Result:
  ✅ Button enabled (blue)
  ✅ Click "Create Account"
  ✅ Form submits successfully
  ✅ Modal closes
  ✅ See "Welcome, Jane Smith! 👋" in top right
  ✅ User is logged in
```

#### 4. Test Complete Sign-Up (All Fields)
```
Input:
  Full Name:          John Toronto
  Email:              john.toronto@example.com
  Password:           SecurePass123!
  Age:                32
  Area:               Downtown Ottawa
  Work/School:        Google Canada

Expected Result:
  ✅ All fields filled
  ✅ Form validates
  ✅ Submit button active
  ✅ Click "Create Account"
  ✅ Success message appears
  ✅ Modal closes
  ✅ Logged in as "John Toronto"
```

#### 5. Test Validation - Age Field
```
Input:
  Age: 10 (below minimum of 13)

Expected Result:
  ❌ Error message shows: "Age must be between 13 and 120"
  ❌ Form NOT submitted
  ❌ Button stays disabled
```

#### 6. Test Validation - Invalid Email
```
Input:
  Email: notanemail

Expected Result:
  ❌ Error message shown
  ❌ Form NOT submitted
```

#### 7. Test Validation - Weak Password
```
Input:
  Password: 123456 (no special chars, no mixed case)

Expected Result:
  ❌ Error message about password strength
  ❌ Form NOT submitted
```

#### 8. Test Validation - Duplicate Email
```
First Registration:
  Email: test@example.com (successfully register)

Second Registration Attempt:
  Email: test@example.com (same email)

Expected Result:
  ❌ Error: "Email already registered"
  ❌ Form NOT submitted
```

### Verification Checklist ✅

- [ ] All 6 fields visible in sign-up form
- [ ] Required fields work (name, email, password)
- [ ] Optional fields work (age, area, work/school)
- [ ] Age validation works (13-120)
- [ ] Email validation works
- [ ] Password strength validation works
- [ ] Duplicate email detection works
- [ ] Successful registration logs user in
- [ ] User data displayed in top right ("Welcome, [Name]!")

---

## 📋 TEST 2: Feature Carousel

### What to Test
The 7 features should display in a rotating carousel instead of static cards.

### Step-by-Step Instructions

#### 1. Locate the Carousel
```
1. Go to: http://localhost:5173
2. Scroll down to section: "Our 7 Pillars of Community"
3. You should see a carousel (NOT a grid of cards)
```

#### 2. Verify Carousel Visual
```
Expected appearance:
┌────────────────────────────────────────┐
│  🎉 Events                              │
│  Discover and join amazing community..  │
│                                         │
│  ‹   [●●●●○○○]   ›                     │
│  [Explore Events]                       │
└────────────────────────────────────────┘

Features:
✅ Large emoji icon
✅ Feature title
✅ Feature description
✅ Gradient background (colorful)
✅ Navigation arrows (< and >)
✅ Dot indicators (showing current slide)
✅ Explore button
```

#### 3. Test Auto-Rotation
```
Action: Just watch the carousel

Expected Result:
  ✅ After ~6 seconds, slide changes automatically
  ✅ Next feature appears (Marketplace)
  ✅ Dot indicator updates (●○○○○○○ → ○●○○○○○)
  ✅ Continues rotating through all 7 features
```

#### 4. Test Navigation Arrows
```
Action 1: Click LEFT arrow (‹)
Expected:
  ✅ Goes to previous feature
  ✅ If on first feature, wraps to last

Action 2: Click RIGHT arrow (›)
Expected:
  ✅ Goes to next feature
  ✅ If on last feature, wraps to first
```

#### 5. Test Dot Indicators
```
Current: Showing "Events" (1st feature)
Dots show: ●○○○○○○

Action 1: Click 3rd dot
Expected:
  ✅ Carousel jumps to "Business Directory" (3rd feature)
  ✅ Dots update: ○○●○○○○

Action 2: Click 7th dot
Expected:
  ✅ Carousel jumps to "Admin Tools" (7th feature)
  ✅ Dots update: ○○○○○○●
```

#### 6. Test Feature Count
```
Verify all 7 features appear when rotating through:
1. ✅ Events (red/pink gradient)
2. ✅ Marketplace (orange gradient)
3. ✅ Business Directory (yellow gradient)
4. ✅ Forums (green gradient)
5. ✅ Mentorship (blue gradient)
6. ✅ Community Groups (purple gradient)
7. ✅ Admin Tools (pink/red gradient)
```

#### 7. Test Hover Effects
```
Action: Hover mouse over carousel

Expected:
  ✅ Navigation arrows become more visible
  ✅ Buttons appear more interactive
  ✅ Auto-rotation PAUSES

Action: Move mouse away

Expected:
  ✅ Auto-rotation RESUMES after ~6 seconds
```

#### 8. Test Explore Button
```
Action: Click "Explore [Feature]" button while logged in

Expected:
  ✅ Modal opens with that feature's details
  ✅ Can see full feature information
  ✅ Can close modal with X button

Action: Click "Explore" while NOT logged in

Expected:
  ✅ Sign-up modal opens instead
  ✅ Can register then access feature
```

### Verification Checklist ✅

- [ ] Carousel displays (NOT static grid)
- [ ] All 7 features visible
- [ ] Auto-rotation works every ~6 seconds
- [ ] Left/Right arrows work
- [ ] Dot indicators work and update
- [ ] Can click dots to jump to feature
- [ ] Smooth transitions between slides
- [ ] Different gradients for each feature
- [ ] Hover pauses auto-rotation
- [ ] Explore button opens feature or sign-up modal
- [ ] Responsive on mobile (test in DevTools)

---

## 📋 TEST 3: Image Upload Functionality

### What to Test
Users should be able to upload images for marketplace listings.

### Step-by-Step Instructions

#### 1. Navigate to Marketplace
```
1. Go to: http://localhost:5173
2. Scroll to "Our 7 Pillars" carousel
3. Click "Explore Marketplace" or click Marketplace feature
4. Look for "Create Listing" section
```

#### 2. Find Upload Area
```
You should see a section with:
┌──────────────────────────────────┐
│  📸 Drag images here or click     │
│    Upload up to 5 images (10MB)   │
│                                  │
│  [Supported formats: JPG, PNG...] │
└──────────────────────────────────┘
```

#### 3. Test Click-to-Upload
```
Action 1: Click the upload area
Expected:
  ✅ File browser dialog opens
  ✅ Can select image file(s)

Action 2: Select a JPG/PNG image file
Expected:
  ✅ File is added to form
  ✅ Preview appears below
```

#### 4. Test Drag-and-Drop
```
Action 1: Drag image file onto upload area
Expected:
  ✅ Upload area highlights (visual feedback)
  ✅ Drop the file
  ✅ Preview appears

Action 2: Drag multiple images
Expected:
  ✅ All selected images show as previews
  ✅ Count shows (e.g., "Selected Images: 3/5")
```

#### 5. Test Image Previews
```
Expected preview display:
├── Thumbnail grid (2-4 per row)
├── Each preview shows:
│   ├── Image thumbnail
│   ├── File name (truncated)
│   ├── File size (e.g., "245KB")
│   └── Remove button (×)
└── Hover shows remove button more clearly
```

#### 6. Test File Validation
```
Action 1: Try uploading non-image file (.txt, .pdf)
Expected:
  ❌ Error message: "File is not an image"
  ❌ File NOT added to preview

Action 2: Try uploading image > 10MB
Expected:
  ❌ Error message: "File exceeds 10MB limit"
  ❌ File NOT added to preview

Action 3: Try uploading 6+ images
Expected:
  ❌ Error message: "Maximum 5 files allowed"
  ❌ 6th file NOT added
```

#### 7. Test Remove Button
```
Action: Click × button on a preview

Expected:
  ✅ Image removed from previews
  ✅ Count updates (e.g., "3/5" → "2/5")
  ✅ Upload form updates
```

#### 8. Test Upload Process
```
Action: After selecting valid images, click "Upload [N] Image(s)" button

Expected During Upload:
  ✅ Button disabled
  ✅ Progress indicator appears (percentage)
  ✅ Shows: "⚙️ Uploading... 45%"

Expected After Upload:
  ✅ Success message appears
  ✅ Shows: "✅ Upload Successful! (3 images)"
  ✅ Image URLs displayed in green box
  ✅ URLs are clickable/copyable
  ✅ Previews cleared or "Upload More" button shown
```

#### 9. Test URL Validity
```
After successful upload:

Action 1: Copy one of the returned URLs
Expected:
  ✅ URL is valid (starts with http)
  ✅ URL format: http://localhost:9000/pomi/[filename]
  ✅ Can paste into browser address bar

Action 2: Paste URL in browser
Expected:
  ✅ Image loads and displays
  ✅ Verifies upload was successful
```

#### 10. Test Integration with Listing
```
Action 1: Upload images
Action 2: Fill other listing fields (title, price, description, etc.)
Action 3: Submit the listing

Expected:
  ✅ Listing created with all image URLs
  ✅ Can view listing with images displayed
```

### Verification Checklist ✅

- [ ] Upload area visible in marketplace form
- [ ] Click-to-upload works
- [ ] Drag-and-drop works
- [ ] Previews appear for selected images
- [ ] File validation works (non-images rejected)
- [ ] Size validation works (>10MB rejected)
- [ ] Count validation works (>5 files rejected)
- [ ] Remove button works
- [ ] Upload button submits files
- [ ] Progress indicator shows during upload
- [ ] Success message displays
- [ ] URLs are returned and valid
- [ ] URLs are publicly accessible
- [ ] Images display when URLs visited

---

## 🔍 Additional Verification (Browser DevTools)

### Check LocalStorage
```
1. Press F12 to open DevTools
2. Go to: Application → LocalStorage
3. Expand: http://localhost:5173
4. Verify two keys exist:
   ✅ authToken - contains JWT token (long string)
   ✅ userData - contains user data (JSON object)
5. Click on userData to view:
   {
     "_id": "...",
     "email": "john@example.com",
     "username": "John Doe",
     "age": 28,
     "area": "Downtown Ottawa",
     "workOrSchool": "Carleton University"
   }
```

### Check Network Requests
```
1. Press F12 → Network tab
2. Clear network log
3. Click "Sign Up" and register

Watch for POST request:
  URL: http://localhost:3000/api/v1/auth/register

Request Body should include:
  {
    "email": "...",
    "password": "...",
    "username": "...",
    "age": 28,
    "area": "Downtown Ottawa",
    "workOrSchool": "..."
  }

Response should include:
  {
    "token": "eyJhbGc...",
    "user": {
      "id": "...",
      "email": "...",
      "username": "...",
      "age": 28,
      "area": "Downtown Ottawa",
      "workOrSchool": "..."
    }
  }
```

### Check Console for Errors
```
1. Press F12 → Console tab
2. Perform all test actions
3. Verify NO red error messages
4. You may see warnings (harmless)
```

---

## 🗄️ Database Verification (MongoDB)

### Connect to MongoDB
```bash
# Open MongoDB shell
mongosh mongodb://pomi_user:pomi_password@localhost:27017/pomi

# Run this command
db.users.find()
```

### Expected Output
```json
[
  {
    "_id": ObjectId("507f1f77bcf86cd799439012"),
    "email": "jane.smith@example.com",
    "username": "Jane Smith",
    "password": "$2a$10$hashedpassword...",
    "createdAt": ISODate("2025-10-27T19:30:00.000Z"),
    "updatedAt": ISODate("2025-10-27T19:30:00.000Z")
  },
  {
    "_id": ObjectId("507f1f77bcf86cd799439013"),
    "email": "john.toronto@example.com",
    "username": "John Toronto",
    "password": "$2a$10$hashedpassword...",
    "age": 32,
    "area": "Downtown Ottawa",
    "workOrSchool": "Google Canada",
    "createdAt": ISODate("2025-10-27T19:35:00.000Z"),
    "updatedAt": ISODate("2025-10-27T19:35:00.000Z")
  }
]
```

Verify:
```
✅ Users have correct email
✅ age field present (for users who provided it)
✅ area field present (for users who provided it)
✅ workOrSchool field present (for users who provided it)
✅ password is hashed ($ 2a$ prefix)
✅ timestamps are correct
```

---

## 📊 Test Summary Template

After testing, fill this out:

```
TEST 1: ENHANCED SIGN-UP FORM
  Full Name field:                [ ]Pass [ ]Fail [ ]N/A
  Email field:                    [ ]Pass [ ]Fail [ ]N/A
  Password field:                 [ ]Pass [ ]Fail [ ]N/A
  Age field:                      [ ]Pass [ ]Fail [ ]N/A
  Area dropdown:                  [ ]Pass [ ]Fail [ ]N/A
  Work/School field:              [ ]Pass [ ]Fail [ ]N/A
  Age validation (13-120):        [ ]Pass [ ]Fail [ ]N/A
  Email validation:               [ ]Pass [ ]Fail [ ]N/A
  Duplicate email check:          [ ]Pass [ ]Fail [ ]N/A
  Password validation:            [ ]Pass [ ]Fail [ ]N/A
  Success login after signup:     [ ]Pass [ ]Fail [ ]N/A

TEST 2: FEATURE CAROUSEL
  Carousel displays (not grid):   [ ]Pass [ ]Fail [ ]N/A
  All 7 features visible:         [ ]Pass [ ]Fail [ ]N/A
  Auto-rotation works:            [ ]Pass [ ]Fail [ ]N/A
  Left arrow navigation:          [ ]Pass [ ]Fail [ ]N/A
  Right arrow navigation:         [ ]Pass [ ]Fail [ ]N/A
  Dot indicators work:            [ ]Pass [ ]Fail [ ]N/A
  Click dots to jump:             [ ]Pass [ ]Fail [ ]N/A
  Smooth animations:              [ ]Pass [ ]Fail [ ]N/A
  Gradient backgrounds (7):       [ ]Pass [ ]Fail [ ]N/A
  Explore button works:           [ ]Pass [ ]Fail [ ]N/A
  Responsive on mobile:           [ ]Pass [ ]Fail [ ]N/A

TEST 3: IMAGE UPLOAD
  Upload area visible:            [ ]Pass [ ]Fail [ ]N/A
  Click-to-upload works:          [ ]Pass [ ]Fail [ ]N/A
  Drag-and-drop works:            [ ]Pass [ ]Fail [ ]N/A
  Previews display:               [ ]Pass [ ]Fail [ ]N/A
  File type validation:           [ ]Pass [ ]Fail [ ]N/A
  File size validation:           [ ]Pass [ ]Fail [ ]N/A
  File count validation:          [ ]Pass [ ]Fail [ ]N/A
  Remove button works:            [ ]Pass [ ]Fail [ ]N/A
  Upload progress shows:          [ ]Pass [ ]Fail [ ]N/A
  Success message displays:       [ ]Pass [ ]Fail [ ]N/A
  URLs returned:                  [ ]Pass [ ]Fail [ ]N/A
  URLs accessible:                [ ]Pass [ ]Fail [ ]N/A

OVERALL: [ ]All Pass [ ]Some Issues [ ]Major Issues
```

---

## 🐛 Troubleshooting

### Backend Won't Start
```
Issue: "Cannot find module '@aws-sdk/client-s3'"
Solution:
  npm install @aws-sdk/client-s3 @aws-sdk/s3-request-presigner

Issue: "tsx watch" fails with esbuild error
Solution:
  npm install @esbuild/darwin-arm64 --save-optional
  OR use: npm run build && node dist/index.js
```

### Frontend Won't Load
```
Issue: "Cannot find ../EnhancedAuthForm"
Solution:
  npm install
  Clear browser cache (Ctrl+Shift+Delete)
  Hard refresh (Ctrl+Shift+R)

Issue: Components not updating
Solution:
  Restart frontend dev server
  Clear node_modules and reinstall: rm -rf node_modules && npm install
```

### MongoDB Connection Error
```
Issue: "Cannot connect to MongoDB"
Solution:
  docker-compose up -d
  docker-compose ps
  Verify pomi-mongodb is running
```

---

## 📞 Quick Reference

**URLs:**
- Frontend: `http://localhost:5173`
- Backend: `http://localhost:3000`
- Backend Health: `http://localhost:3000/health`
- MongoDB: `localhost:27017` (user: pomi_user, pass: pomi_password)

**Key Files:**
- Sign-Up Form: `frontend/src/components/EnhancedAuthForm.tsx`
- Carousel: `frontend/src/components/FeatureCarousel.tsx`
- Upload UI: `frontend/src/components/MarketplaceUpload.tsx`
- Auth Service: `frontend/src/services/authService.ts`
- User Model: `backend/src/models/User.ts`

**Test Accounts Created:**
- Email: `jane.smith@example.com` / Pass: `TestPass123!`
- Email: `john.toronto@example.com` / Pass: `SecurePass123!`

---

## ✨ Success Criteria

All tests pass when:
```
✅ Sign-up captures age, area, work/school
✅ All fields validate correctly
✅ Data saves to MongoDB
✅ Data persists in localStorage
✅ Carousel auto-rotates all 7 features
✅ Carousel navigation works (arrows, dots)
✅ Image upload validates and uploads
✅ Image URLs are returned and accessible
✅ No console errors
✅ Responsive on all screen sizes
```

---

**STATUS:** Ready for Testing ✅
**DATE:** October 27, 2025
**VERSION:** 1.0
