# Sign-Up Process - Enhanced User Information Collection

**Date:** October 27, 2025
**Status:** ✅ Complete and Ready

---

## 📋 Overview

The Pomi sign-up process now collects comprehensive user information to better serve the community and personalize the user experience.

---

## 🎯 Sign-Up Fields

### Required Fields (All Sign-Ups)
1. **Full Name** (`username`)
   - Type: Text input
   - Min: 1 character
   - Max: 255 characters
   - Required: Yes ✓

2. **Email Address** (`email`)
   - Type: Email input
   - Format: Valid email required
   - Uniqueness: Must not exist in database
   - Required: Yes ✓

3. **Password** (`password`)
   - Type: Password input
   - Min: 6 characters
   - Requirements:
     - At least one uppercase letter
     - At least one lowercase letter
     - At least one number
     - At least one special character
   - Hashed: Yes (bcrypt, 10 rounds)
   - Required: Yes ✓

### Optional Fields (Sign-Up Only)
4. **Age** (`age`)
   - Type: Number input
   - Min: 13 years old
   - Max: 120 years old
   - Required: No (optional)
   - Stored: Yes, in user profile
   - Use: Community demographics, age-appropriate content

5. **Area in Ottawa** (`area`)
   - Type: Dropdown select
   - Options (15 neighborhoods):
     - Downtown Ottawa
     - Barrhaven
     - Kanata
     - Nepean
     - Gloucester
     - Orleans
     - Vanier
     - Westboro
     - Rockcliffe Park
     - Sandy Hill
     - The Glebe
     - Bytown
     - South Ottawa
     - North Ottawa
     - Outside Ottawa
   - Required: No (optional)
   - Stored: Yes, in user profile
   - Use: Local discovery, neighborhood-based events

6. **School or Workplace** (`workOrSchool`)
   - Type: Text input
   - Examples: "Carleton University", "Tech Startup Inc.", "High School Name"
   - Max: 255 characters
   - Required: No (optional)
   - Stored: Yes, in user profile
   - Use: Professional networking, mentorship matching

---

## 🔄 Sign-Up Flow

### Step 1: User Clicks "Sign Up"
- Button: "Sign Up" (top right navigation)
- Alternative: "Join Our Community" (hero section CTA)
- Alternative: "Create Your Account" (bottom CTA)

### Step 2: Sign-Up Modal Opens
- Beautiful gradient modal with animation
- "Join Us" header
- "Create your account to join our community" subtitle
- Close button (×) in top right

### Step 3: Fill Required Fields
```
Full Name:          [____________] *required
Email Address:      [____________] *required
Password:           [____________] *required
```

### Step 4: Fill Optional Fields
```
Age:                [  25  ] (optional)
Area in Ottawa:     [Select your area...▼] (optional)
School/Workplace:   [____________] (optional)
```

### Step 5: Validation
All fields are validated before submission:
- **Full Name:** At least 1 character
- **Email:** Valid email format
- **Password:** At least 6 characters, meets strength requirements
- **Age:** If provided, must be 13-120
- **Area:** Must be from dropdown list if provided
- **Work/School:** No specific validation (free text)

### Step 6: Submit
- Click "Create Account" button
- Loading state shows: "⚙️ Loading..."
- Button becomes disabled during submission

### Step 7: Success
- Account created successfully ✅
- Token generated and stored in localStorage
- User logged in automatically
- Modal closes
- User can now access all Pomi features
- Welcome message: "Welcome, [Name]! 👋"

---

## 📱 User Data Stored

After successful sign-up, the following data is stored:

### In Database (MongoDB)
```javascript
{
  _id: "507f1f77bcf86cd799439011",
  email: "user@example.com",
  username: "John Doe",
  age: 28,
  area: "Downtown Ottawa",
  workOrSchool: "Carleton University",
  password: "$2a$10$hashed_password_here",
  createdAt: "2025-10-27T15:30:00Z",
  updatedAt: "2025-10-27T15:30:00Z"
}
```

### In Browser LocalStorage
```javascript
// authToken - JWT token for API requests
localStorage.getItem('authToken')
// Returns: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

// userData - User profile information
localStorage.getItem('userData')
// Returns: {
//   "_id": "507f1f77bcf86cd799439011",
//   "email": "user@example.com",
//   "username": "John Doe",
//   "age": 28,
//   "area": "Downtown Ottawa",
//   "workOrSchool": "Carleton University",
//   "createdAt": "2025-10-27T15:30:00Z"
// }
```

---

## 🔐 Security Features

1. **Password Hashing**
   - Algorithm: bcryptjs
   - Rounds: 10
   - Never stored in plain text

2. **Email Validation**
   - Format validation on frontend
   - Uniqueness check on backend
   - Cannot register with same email twice

3. **Age Validation**
   - Minimum 13 years old (child protection)
   - Maximum 120 years old (data quality)
   - Server-side validation

4. **Token Management**
   - JWT tokens expire after configured time
   - Refresh tokens available
   - Token stored securely in localStorage
   - Can be cleared on logout

---

## 🎨 UI Components

### EnhancedAuthForm.tsx
- Location: `frontend/src/components/EnhancedAuthForm.tsx`
- Props:
  - `authMode: 'login' | 'register'`
  - `onSuccess: (user) => void`
  - `onClose: () => void`
  - `onModeChange: (mode) => void`
- Features:
  - Smooth field animations
  - Real-time validation
  - Error messages
  - Mode switching (sign up ↔ sign in)

### Usage in App.tsx
```typescript
<EnhancedAuthForm
  authMode={authMode}
  onSuccess={handleAuthSuccess}
  onClose={() => setShowAuthModal(false)}
  onModeChange={(mode) => setAuthMode(mode)}
/>
```

---

## 🔌 API Endpoints

### Register User
**Endpoint:** `POST /api/v1/auth/register`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "username": "John Doe",
  "age": 28,
  "area": "Downtown Ottawa",
  "workOrSchool": "Carleton University"
}
```

**Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "email": "user@example.com",
    "username": "John Doe",
    "age": 28,
    "area": "Downtown Ottawa",
    "workOrSchool": "Carleton University"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Responses:**
- `400 Bad Request` - Missing required fields or validation failed
- `409 Conflict` - Email already registered
- `500 Server Error` - Registration failed

---

## 📊 Database Schema

### User Model (MongoDB)
```typescript
interface IUser {
  _id: string;
  email: string;              // Unique, lowercase
  password: string;           // Hashed with bcrypt
  username: string;           // User's full name
  age?: number;               // NEW: 13-120
  area?: string;              // NEW: Ottawa neighborhood
  workOrSchool?: string;      // NEW: School/workplace name
  createdAt: Date;
  updatedAt: Date;
  comparePassword(password: string): Promise<boolean>;
}
```

---

## ✨ Enhanced Features

### For Users
- ✅ Personalized experience based on age group
- ✅ Local community discovery through area
- ✅ Better mentorship matching with professional info
- ✅ Neighborhood-specific events and marketplace listings
- ✅ Professional networking through work/school info

### For Community
- ✅ Better demographics understanding
- ✅ Ability to organize area-specific events
- ✅ Improved content recommendations
- ✅ Neighborhood support groups
- ✅ Professional development circles

---

## 🧪 Testing Sign-Up

### Test Case 1: Complete Registration
```
Full Name: John Doe
Email: john@example.com
Password: SecurePass123!
Age: 28
Area: Downtown Ottawa
Work/School: Carleton University

Expected Result: ✅ Account created, logged in, modal closes
```

### Test Case 2: Minimal Registration
```
Full Name: Jane Smith
Email: jane@example.com
Password: SecurePass123!
Age: (blank)
Area: (blank)
Work/School: (blank)

Expected Result: ✅ Account created with only required fields
```

### Test Case 3: Age Validation
```
Full Name: Test User
Email: test@example.com
Password: SecurePass123!
Age: 10 (less than 13)

Expected Result: ❌ Error: "Age must be between 13 and 120"
```

### Test Case 4: Email Already Exists
```
Full Name: Another User
Email: john@example.com (already registered)
Password: SecurePass123!

Expected Result: ❌ Error: "Email already registered"
```

---

## 🚀 Frontend Service Integration

### AuthService Methods

```typescript
// Register with new fields
await authService.register({
  email: 'user@example.com',
  password: 'SecurePass123!',
  username: 'John Doe',
  age: 28,
  area: 'Downtown Ottawa',
  workOrSchool: 'Carleton University'
})

// Get current user (includes new fields)
const { user } = await authService.getCurrentUser()
// user.age, user.area, user.workOrSchool available

// Get stored user data from localStorage
const userData = authService.getUserData()
// Returns user object with all fields

// Clear user data on logout
authService.clearUserData()
```

---

## 📝 Next Steps

1. **Test the sign-up flow** with different input combinations
2. **Verify data is saved** in MongoDB
3. **Test API endpoints** with tools like Postman
4. **Check localStorage** in browser DevTools
5. **Test on mobile** for responsive design
6. **Verify validation messages** are user-friendly

---

## 💡 Tips for Users

- **Age:** Leave blank if you prefer privacy
- **Area:** Choose "Outside Ottawa" if not in the city
- **Work/School:** Include company/university for better mentorship matches
- **Password:** Use a mix of uppercase, lowercase, numbers, and symbols for security

---

## 📞 Support

If users encounter issues during sign-up:

1. **Check browser console** for error messages (F12)
2. **Verify API is running** (backend on port 3000)
3. **Clear localStorage** and try again
4. **Check email uniqueness** - can't register twice with same email
5. **Validate password strength** - must include mixed case, numbers, symbols

---

**Status:** ✅ Complete
**Last Updated:** October 27, 2025
**Version:** 1.0
