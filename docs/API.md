# Pomi API Documentation

Complete REST API documentation for the Pomi backend. All endpoints use the `/api/v1` base URL.

## Base URL

```
http://localhost:3000/api/v1
```

## Authentication

Most endpoints require JWT authentication. Include the access token in the `Authorization` header:

```
Authorization: Bearer <access_token>
```

## Response Format

All responses are JSON:

### Success Response
```json
{
  "data": { /* ... */ },
  "message": "Success message"
}
```

### Error Response
```json
{
  "error": "Error message",
  "errors": ["Error 1", "Error 2"]
}
```

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing or invalid token |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Resource already exists |
| 500 | Internal Server Error |

---

## Authentication Endpoints

### Register User

Create a new user account.

**Endpoint:** `POST /auth/register`

**Access:** Public

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "username",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response (201):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "user_123456789",
    "email": "user@example.com",
    "username": "username",
    "firstName": "John",
    "lastName": "Doe"
  },
  "tokens": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Errors:**
- `400` - Invalid input, duplicate email, weak password
- `409` - Email already registered

**Password Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character (!@#$%^&*)

**Username Requirements:**
- 3-30 characters
- Letters, numbers, underscores, hyphens only

---

### Login User

Authenticate user and get tokens.

**Endpoint:** `POST /auth/login`

**Access:** Public

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response (200):**
```json
{
  "message": "Login successful",
  "user": {
    "id": "user_123456789",
    "email": "user@example.com",
    "username": "username",
    "firstName": "John",
    "lastName": "Doe"
  },
  "tokens": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Errors:**
- `400` - Missing email or password
- `401` - Invalid email or password

---

### Refresh Access Token

Get a new access token using refresh token.

**Endpoint:** `POST /auth/refresh`

**Access:** Public

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Errors:**
- `400` - Missing refresh token
- `401` - Invalid or expired refresh token

**Token Expiry:**
- Access Token: 1 hour
- Refresh Token: 7 days

---

### Get Current User

Retrieve authenticated user's profile.

**Endpoint:** `GET /auth/me`

**Access:** Private (requires JWT)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response (200):**
```json
{
  "id": "user_123456789",
  "email": "user@example.com",
  "username": "username",
  "firstName": "John",
  "lastName": "Doe",
  "emailVerified": false,
  "createdAt": "2024-10-26T12:00:00Z"
}
```

**Errors:**
- `401` - Missing or invalid token
- `403` - Token expired

---

### Logout User

Invalidate user's tokens and logout.

**Endpoint:** `POST /auth/logout`

**Access:** Private (requires JWT)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200):**
```json
{
  "message": "Logout successful"
}
```

**Errors:**
- `401` - Missing or invalid token

---

## Common Response Codes

### 400 Bad Request
Missing or invalid request parameters.

```json
{
  "errors": [
    "Valid email is required",
    "Password must be at least 8 characters"
  ]
}
```

### 401 Unauthorized
Missing or invalid authentication token.

```json
{
  "error": "Access token required"
}
```

### 403 Forbidden
Token is invalid or expired.

```json
{
  "error": "Invalid or expired token"
}
```

### 409 Conflict
Resource already exists.

```json
{
  "error": "Email already registered"
}
```

---

## JWT Token Structure

Access tokens contain the following claims:

```json
{
  "sub": "user_123456789",
  "email": "user@example.com",
  "username": "username",
  "isAdmin": false,
  "type": "access",
  "iat": 1698316800,
  "exp": 1698320400
}
```

### Claims
- `sub` - User ID (subject)
- `email` - User email
- `username` - User username
- `isAdmin` - Is admin flag
- `type` - Token type (access or refresh)
- `iat` - Issued at timestamp
- `exp` - Expiration timestamp

---

## Rate Limiting

Currently no rate limiting. In production:

**Recommended Limits:**
- Login: 5 attempts per 15 minutes per IP
- Register: 3 attempts per hour per IP
- General API: 1000 requests per hour per user

---

## CORS Configuration

**Allowed Origins:**
```
http://localhost:5173    (Frontend dev)
http://localhost:3000    (Backend)
```

Update `CORS_ALLOWED_ORIGINS` environment variable for different domains.

---

## API Authentication Flow

### 1. User Registration
```
POST /auth/register
↓
User created
↓
Return: accessToken + refreshToken
```

### 2. User Login
```
POST /auth/login
↓
Credentials verified
↓
Return: accessToken + refreshToken
```

### 3. Authenticated Request
```
GET /auth/me
Headers: Authorization: Bearer <accessToken>
↓
Token verified
↓
Return: User profile
```

### 4. Token Refresh
```
POST /auth/refresh
Body: { refreshToken }
↓
Token verified
↓
Return: New accessToken
```

### 5. Logout
```
POST /auth/logout
Headers: Authorization: Bearer <accessToken>
Body: { refreshToken }
↓
Token invalidated
↓
Return: Success message
```

---

## Planned Endpoints

### Events Module
- `POST /events` - Create event
- `GET /events` - List events
- `GET /events/:id` - Get event details
- `PUT /events/:id` - Update event
- `DELETE /events/:id` - Delete event
- `POST /events/:id/rsvp` - RSVP to event
- `DELETE /events/:id/rsvp` - Cancel RSVP

### Marketplace Module
- `POST /marketplace/listings` - Create listing
- `GET /marketplace/listings` - List items
- `GET /marketplace/listings/:id` - Get listing details
- `PUT /marketplace/listings/:id` - Update listing
- `DELETE /marketplace/listings/:id` - Delete listing
- `POST /marketplace/listings/:id/favorite` - Favorite item

### Business Directory
- `POST /businesses` - Create business
- `GET /businesses` - List businesses
- `GET /businesses/:id` - Get business details
- `PUT /businesses/:id` - Update business
- `DELETE /businesses/:id` - Delete business
- `GET /businesses/:id/reviews` - Get business reviews

### Forums Module
- `POST /forums/posts` - Create post
- `GET /forums/posts` - List posts
- `GET /forums/posts/:id` - Get post details
- `PUT /forums/posts/:id` - Update post
- `DELETE /forums/posts/:id` - Delete post
- `POST /forums/posts/:id/replies` - Add reply
- `GET /forums/posts/:id/replies` - Get replies

### Mentorship Module
- `POST /mentorship/matches` - Create match
- `GET /mentorship/matches` - List matches
- `GET /mentorship/matches/:id` - Get match details
- `PUT /mentorship/matches/:id` - Update match
- `DELETE /mentorship/matches/:id` - Delete match

### Community Groups
- `POST /community/groups` - Create group
- `GET /community/groups` - List groups
- `GET /community/groups/:id` - Get group details
- `PUT /community/groups/:id` - Update group
- `DELETE /community/groups/:id` - Delete group
- `POST /community/groups/:id/members` - Join group
- `DELETE /community/groups/:id/members/:userId` - Leave group

### Admin Module
- `GET /admin/users` - List users
- `GET /admin/users/:id` - Get user details
- `PUT /admin/users/:id` - Update user
- `DELETE /admin/users/:id` - Delete user
- `GET /admin/stats` - Get system statistics
- `GET /admin/logs` - Get activity logs

---

## Error Handling

All errors include a descriptive message:

```json
{
  "error": "Invalid email or password",
  "status": 401,
  "timestamp": "2024-10-26T12:00:00Z"
}
```

### Common Validation Errors

**Invalid Email:**
```json
{
  "errors": ["Valid email is required"]
}
```

**Weak Password:**
```json
{
  "errors": [
    "Password must contain at least one uppercase letter",
    "Password must contain at least one special character (!@#$%^&*)"
  ]
}
```

**Invalid Username:**
```json
{
  "errors": ["Username must be at least 3 characters"]
}
```

---

## Testing with cURL

### Register User
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "username": "testuser",
    "password": "TestPass123!",
    "firstName": "John",
    "lastName": "Doe"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "TestPass123!"
  }'
```

### Get Current User
```bash
curl -X GET http://localhost:3000/api/v1/auth/me \
  -H "Authorization: Bearer <access_token>"
```

### Refresh Token
```bash
curl -X POST http://localhost:3000/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "<refresh_token>"
  }'
```

---

## Testing with Postman

1. Import the API collection
2. Set `{{base_url}}` variable to `http://localhost:3000/api/v1`
3. Set `{{access_token}}` from login response
4. Use `{{access_token}}` in Authorization header for protected endpoints

---

## API Versioning

Current version: **v1**

Access endpoints with `/api/v1/...` prefix.

Future versions will be available at `/api/v2/...`, etc.

---

## Changelog

### v1.0.0 (Current)
- Authentication endpoints (register, login, logout, refresh)
- User profile endpoints
- JWT-based authentication
- Password validation and hashing
- CORS support
- Error handling and validation

---

## Support

- **Issues**: GitHub Issues
- **Questions**: Slack #api-support
- **Documentation**: See docs/ folder
