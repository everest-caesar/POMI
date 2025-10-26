# Pomi - Next Steps for Development

**Current Status:** Week 1 Complete ✅
**Next Phase:** Week 2 - Database Integration & Feature Implementation
**Date:** October 26, 2025

---

## 🎯 What's Next

Week 1 has provided a solid foundation. This document outlines the exact steps to continue development in Week 2.

---

## ⚡ Quick Action Items

### 1. Verify Your Setup (5 minutes)

```bash
# Navigate to project
cd /Users/everestode/Desktop/POMI/pomi-app

# Install dependencies (if not done)
npm install

# Start databases
docker-compose up -d

# Verify all services are healthy
docker-compose ps

# Check databases are accessible
docker-compose exec postgres psql -U pomi_user -d pomi_db -c "SELECT 1"
docker-compose exec mongodb mongosh -u pomi_user -p pomi_password --authenticationDatabase admin --eval "db.adminCommand('ping')"
docker-compose exec redis redis-cli ping
```

### 2. Start Development Servers

```bash
# Terminal 1: Start both servers concurrently
npm run dev

# Terminal 2 (if needed): Start backend only
cd backend && npm run dev

# Terminal 3 (if needed): Start frontend only
cd frontend && npm run dev
```

### 3. Verify Endpoints

```bash
# Test health check
curl http://localhost:3000/health

# Test API status
curl http://localhost:3000/api/v1/status

# Test authentication (registration)
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "TestPass123!",
    "firstName": "Test",
    "lastName": "User"
  }'
```

---

## 🗄️ Week 2 Priority Tasks

### Phase 1: Database Integration (Days 1-2)

**Objective:** Connect backend to actual databases

#### PostgreSQL Integration
```bash
cd backend

# Install Prisma
npm install @prisma/client
npm install -D prisma

# Initialize Prisma
npx prisma init

# Configure database URL in .env
DATABASE_URL="postgresql://pomi_user:pomi_password@localhost:5432/pomi_db"

# Create migrations
npx prisma migrate dev --name init

# Generate Prisma client
npx prisma generate
```

**Create Prisma Schema:** `backend/prisma/schema.prisma`
- User model (register in docs/DATABASE.md)
- AuthToken model
- Event model
- EventRSVP model
- MarketplaceListing model
- Business model

#### MongoDB Integration
```bash
# Install Mongoose
npm install mongoose

# Configure connection string in .env
MONGODB_URL="mongodb://pomi_user:pomi_password@localhost:27017/pomi?authSource=admin"
```

**Create Mongoose Models:** `backend/src/models/`
- ForumPost model
- ForumReply model
- MentorshipMatch model
- CommunityGroup model

### Phase 2: User Management (Days 3-4)

**Objective:** Implement user profile and registration workflow

#### Tasks
1. Update auth controller to use database
2. Create user service layer
3. Implement email verification (mock for now)
4. Add user profile endpoints:
   - `PUT /api/v1/auth/profile` - Update profile
   - `GET /api/v1/users/:id` - Get user profile
   - `PUT /api/v1/users/:id` - Update user info

#### File Structure
```
backend/src/
├── services/          # New folder
│   ├── auth.service.ts
│   └── user.service.ts
├── controllers/
│   └── auth.controller.ts (update)
└── routes/
    └── auth.routes.ts (update)
```

### Phase 3: Events Module (Days 5-6)

**Objective:** Fully implement events functionality

#### Database Tasks
1. Create Event, EventRSVP tables in PostgreSQL
2. Implement event service layer
3. Connect events controller to database

#### API Implementation
1. Update all events endpoints to use database
2. Add pagination to list endpoints
3. Add filtering (by date, category, status)
4. Add event validation

#### Testing
1. Write tests for all event endpoints
2. Test RSVP functionality
3. Test date filtering

### Phase 4: Basic Marketplace (Day 7)

**Objective:** Implement basic marketplace functionality

#### Tasks
1. Create MarketplaceListing table
2. Implement marketplace service
3. Connect marketplace controller to database
4. Add basic search functionality

---

## 📋 Database Schema Implementation Order

1. **Users & Auth** (Foundation)
   - Users table
   - AuthTokens table
   - EmailVerifications table

2. **Events** (Straightforward)
   - Events table
   - EventRSVPs table

3. **Marketplace** (Simple)
   - MarketplaceListings table

4. **Business Directory** (Medium)
   - Businesses table
   - Reviews collection (MongoDB)

5. **Forums** (MongoDB)
   - ForumPosts collection
   - ForumReplies collection

6. **Mentorship** (MongoDB)
   - MentorshipMatches collection

7. **Community** (MongoDB)
   - CommunityGroups collection

---

## 🔧 Configuration Checklist

Before starting Week 2, ensure:

- [ ] `.env` file created from `.env.example`
- [ ] All database credentials verified
- [ ] Docker containers running and healthy
- [ ] Backend server starts without errors
- [ ] Frontend server starts without errors
- [ ] Git repository up to date
- [ ] All tests passing locally

---

## 📚 Key Resources

### Database Documentation
- `docs/DATABASE.md` - Full schema with SQL/MongoDB queries
- `docs/DOCKER_SETUP.md` - Database connection instructions

### API Documentation
- `docs/API.md` - All endpoint specifications
- `backend/tests/auth.spec.ts` - Example API tests

### Development Guides
- `DEVELOPMENT_STYLE_GUIDE.md` - Code conventions
- `GETTING_STARTED.md` - Project commands
- `WEEK1_SUMMARY.md` - Week 1 completion report

---

## 🏗️ Architecture for Database Layer

### Backend Structure (Week 2+)

```
backend/src/
├── app.ts                    # Main app (updated)
├── middleware/               # Middleware (updated)
│   └── auth.ts              # Auth middleware
├── models/                   # Data models (NEW)
│   ├── User.ts
│   ├── Event.ts
│   └── ...
├── services/                 # Business logic (NEW)
│   ├── auth.service.ts
│   ├── event.service.ts
│   └── ...
├── controllers/              # Route handlers (updated)
│   ├── auth.controller.ts   # Update with DB
│   ├── events.controller.ts  # Update with DB
│   └── ...
├── routes/                   # API routes (updated)
│   └── ...
├── validators/              # Input validation (updated)
│   └── ...
├── utils/                   # Helpers (updated)
│   └── ...
├── config/                  # Configuration (NEW)
│   ├── database.ts
│   └── env.ts
└── tests/                   # Tests (updated)
    └── ...

prisma/
├── schema.prisma           # Prisma schema (NEW)
└── migrations/             # Database migrations (NEW)
```

### Service Layer Pattern

```typescript
// Example: UserService
export class UserService {
  async createUser(data: CreateUserInput): Promise<User> {
    // Validate
    // Hash password
    // Save to database
    // Return user
  }

  async getUserById(id: string): Promise<User | null> {
    // Query database
    // Return user
  }

  async updateUser(id: string, data: UpdateUserInput): Promise<User> {
    // Validate
    // Update database
    // Return updated user
  }
}
```

---

## 🧪 Testing Strategy for Week 2

### Test Coverage Goals
- Backend: 70%+ coverage
- Frontend: 70%+ coverage
- All new endpoints tested

### Test Structure
```bash
# Backend tests
backend/tests/
├── auth.spec.ts           # ✅ Complete
├── events.spec.ts         # TODO Week 2
├── marketplace.spec.ts    # TODO Week 2
└── ...

# Frontend tests
frontend/tests/
├── e2e/
├── unit/
├── visual/
└── ...
```

### Running Tests
```bash
# Run all tests
npm test

# Watch mode
npm run test:watch

# Coverage report
npm run test:coverage

# Specific test
npm test -- auth.spec.ts
```

---

## 🚨 Common Pitfalls to Avoid

1. **Database Connection Issues**
   - ❌ Forgetting to start Docker containers
   - ❌ Wrong credentials in .env
   - ✅ Always verify with `docker-compose ps`

2. **TypeScript Errors**
   - ❌ Missing type definitions
   - ❌ Not running `npm run type-check`
   - ✅ Keep strict mode enabled

3. **Testing**
   - ❌ Skipping tests on new features
   - ❌ Not updating tests with API changes
   - ✅ Write tests first, then implement

4. **Git Workflow**
   - ❌ Not committing frequently
   - ❌ Large commits with multiple features
   - ✅ Small, focused commits per feature

---

## 📝 Commit Message Examples

```
# Feature commits
feat: add user profile endpoints
feat: implement event filtering by date

# Fix commits
fix: resolve database connection timeout
fix: correct auth token expiry validation

# Documentation commits
docs: update API documentation for events

# Test commits
test: add comprehensive event tests
```

---

## 🔐 Security Checklist for Week 2

As you implement new features:

- [ ] Validate all user inputs
- [ ] Use parameterized queries (Prisma/Mongoose)
- [ ] Hash passwords with bcrypt
- [ ] Validate JWT tokens on protected routes
- [ ] Implement rate limiting (for later)
- [ ] Add HTTPS in production (for later)
- [ ] Sanitize error messages (don't expose DB errors)

---

## 📞 Getting Help

### If You Get Stuck

1. **Check Documentation**
   - `GETTING_STARTED.md` - Setup and commands
   - `DEVELOPMENT_STYLE_GUIDE.md` - Code patterns
   - `docs/DATABASE.md` - Schema details

2. **Look at Examples**
   - `backend/tests/auth.spec.ts` - Test pattern
   - `frontend/src/services/auth.service.ts` - Service pattern
   - `backend/src/controllers/auth.controller.ts` - Controller pattern

3. **Debug Steps**
   ```bash
   # Check database connectivity
   docker-compose ps

   # View database logs
   docker-compose logs postgres

   # Check TypeScript errors
   npm run type-check

   # Run linter
   npm run lint
   ```

4. **Ask on Slack**
   - Channel: #pomi-dev
   - Tag: @team

---

## 🎓 Learning Resources

### Prisma ORM
- [Prisma Documentation](https://www.prisma.io/docs/)
- [Prisma Best Practices](https://www.prisma.io/docs/concepts/more/comparisons/prisma-and-traditional-orms)

### Mongoose
- [Mongoose Documentation](https://mongoosejs.com/)
- [Schema Design Patterns](https://docs.mongodb.com/manual/core/schema-validation/)

### Express.js
- [Express Middleware Guide](https://expressjs.com/en/guide/using-middleware.html)
- [Best Practices](https://expressjs.com/en/advanced/best-practice-security.html)

### Testing
- [Jest Documentation](https://jestjs.io/)
- [Playwright Documentation](https://playwright.dev/)
- [Testing Best Practices](https://github.com/goldbergyoni/javascript-testing-best-practices)

---

## ✅ Week 2 Success Criteria

By end of Week 2, you should have:

- [ ] PostgreSQL models created and migrated
- [ ] MongoDB collections created
- [ ] User registration using real database
- [ ] User authentication with database verification
- [ ] Events endpoints connected to database
- [ ] Marketplace basic functionality
- [ ] Database tests passing
- [ ] API tests updated for real data
- [ ] All code following style guide
- [ ] Documentation updated for new features
- [ ] Zero TypeScript errors

---

## 🚀 Ready to Go!

Everything is set up and ready for Week 2 development. The foundation is solid, and the path forward is clear.

**Let's build something amazing!** 🍎

---

**Last Updated:** October 26, 2025
**Next Review:** End of Week 2
**Contact:** @team on Slack
