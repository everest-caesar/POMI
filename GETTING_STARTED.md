# 🍎 Pomi - Getting Started Guide

Welcome to the Pomi development environment! This guide will help you set up and run the project locally.

**Project Status:** Week 1 Development ✅
**Repository:** https://github.com/everest-caesar/POMI.git
**Location:** `/Users/everestode/Desktop/POMI/pomi-app/`

---

## 📋 Prerequisites

Before starting, ensure you have:

- **Node.js 20+** - [Install here](https://nodejs.org/)
- **npm or yarn** - Comes with Node.js
- **Git** - [Install here](https://git-scm.com/)
- **Docker & Docker Compose** - [Install here](https://www.docker.com/products/docker-desktop)
- **VS Code** (recommended) - [Install here](https://code.visualstudio.com/)

### Verify Installation
```bash
node --version      # Should be v20+
npm --version       # Should be v10+
git --version       # Should be v2.40+
docker --version    # Should be Docker 20.10+
docker-compose --version  # Should be 1.29+
```

---

## 🚀 Quick Start (5 minutes)

### 1. Clone the Repository
```bash
cd /Users/everestode/Desktop/POMI
git clone https://github.com/everest-caesar/POMI.git pomi-app
cd pomi-app
```

### 2. Set Up Environment Variables
```bash
cp .env.example .env
# Edit .env with your configuration
```

### 3. Start Databases (Docker)
```bash
docker-compose up -d

# Verify databases are running
docker-compose ps
```

Expected output:
```
NAME                COMMAND             STATUS
pomi-postgres       postgres            Up (healthy)
pomi-mongodb        mongod              Up (healthy)
pomi-redis          redis-server        Up (healthy)
```

### 4. Install Dependencies
```bash
npm install
```

### 5. Start Development Servers
```bash
npm run dev

# In separate terminals:
# Terminal 1: Backend (runs on http://localhost:3000)
# Terminal 2: Frontend (runs on http://localhost:5173)
```

### 6. Verify Everything Works
- **Frontend:** http://localhost:5173 🎉
- **Backend Health:** http://localhost:3000/health ✅
- **Backend API:** http://localhost:3000/api/v1/status ✅

---

## 📁 Project Structure

```
pomi-app/
├── backend/                    # Node.js + Express API
│   ├── src/
│   │   ├── app.ts             # Main Express app
│   │   ├── config/            # Configuration
│   │   ├── controllers/       # Route handlers
│   │   ├── models/            # Database models
│   │   ├── routes/            # API routes
│   │   ├── services/          # Business logic
│   │   ├── middleware/        # Express middleware
│   │   ├── utils/             # Helpers
│   │   ├── validators/        # Input validation
│   │   └── tests/             # Tests
│   ├── migrations/            # Database migrations
│   ├── seeds/                 # Database seeds
│   ├── package.json
│   └── tsconfig.json
│
├── frontend/                   # React + Vite SPA
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── pages/             # Page components
│   │   ├── hooks/             # Custom hooks
│   │   ├── services/          # API client
│   │   ├── store/             # Redux store
│   │   ├── styles/            # CSS/Tailwind
│   │   ├── utils/             # Helpers
│   │   ├── types/             # TypeScript types
│   │   ├── locales/           # i18n translations
│   │   ├── tests/             # Tests
│   │   ├── App.tsx            # Root component
│   │   └── main.tsx           # Entry point
│   ├── public/                # Static files
│   ├── index.html             # HTML template
│   ├── package.json
│   └── tsconfig.json
│
├── docker-compose.yml         # Database setup
├── .env.example               # Environment template
├── .gitignore
├── package.json               # Root monorepo config
└── README.md
```

---

## 🛠️ Available Commands

### Root Commands (Run from project root)
```bash
# Development
npm run dev              # Start frontend + backend (concurrent)
npm run build            # Build both projects
npm test                 # Run all tests
npm run test:watch      # Run tests in watch mode

# Code Quality
npm run lint            # Check for linting errors
npm run format          # Format code with Prettier
npm run type-check      # TypeScript type checking

# Testing
npm run test:e2e        # Playwright E2E tests
```

### Backend Commands
```bash
cd backend

npm run dev              # Start backend server with hot reload
npm run build            # Build TypeScript to JavaScript
npm start                # Run production build
npm test                 # Run tests
npm run lint             # Check code style
npm run type-check       # TypeScript type checking
npm run db:migrate       # Run database migrations
npm run db:seed          # Seed database with sample data
```

### Frontend Commands
```bash
cd frontend

npm run dev              # Start Vite dev server
npm run build            # Build for production
npm run preview          # Preview production build
npm test                 # Run unit tests
npm run test:ui          # Playwright UI mode
npm run test:headed      # Run tests in visible browser
npm run test:e2e         # Run E2E tests
npm run test:multilingual # Test 4 languages
npm run test:visual      # Visual regression tests
npm run test:a11y        # Accessibility tests
npm run lint             # Check code style
npm run type-check       # TypeScript type checking
```

---

## 🗄️ Database Management

### PostgreSQL
```bash
# Connect to PostgreSQL
docker exec -it pomi-postgres psql -U pomi_user -d pomi_db

# Inside psql:
\dt                     # List all tables
\q                      # Exit
```

### MongoDB
```bash
# Connect to MongoDB
docker exec -it pomi-mongodb mongosh -u pomi_user -p pomi_password --authenticationDatabase admin

# Inside mongosh:
show dbs                # List databases
use pomi                # Switch to pomi database
show collections        # List collections
```

### Redis
```bash
# Connect to Redis
docker exec -it pomi-redis redis-cli

# Inside redis-cli:
PING                    # Test connection
KEYS *                  # List all keys
GET keyname             # Get value of a key
```

---

## 🧪 Testing

### Run All Tests
```bash
npm test                # Run all tests once
npm run test:watch      # Run tests in watch mode
```

### E2E Testing with Playwright
```bash
# Interactive UI mode (recommended for development)
npm run test:ui

# Run tests in visible browser
npm run test:headed

# Run tests headless
npm run test:e2e

# Run specific test file
npm run test:e2e -- tests/e2e/auth.spec.ts

# Multilingual testing (4 languages)
npm run test:multilingual

# Visual regression tests
npm run test:visual

# Accessibility tests
npm run test:a11y
```

### View Test Report
```bash
npm run test:report     # Opens HTML test report
```

---

## 🎨 Development Workflow

### The Pomi Development Cycle

```
1. CODE
   Write your feature in TypeScript

2. SCREENSHOT
   npm run test:ui
   See component live in Playwright UI

3. VERIFY
   Test all 4 languages:
   - English, Amharic, Tigrinya, Oromo

4. TEST
   Write E2E tests in Playwright
   Verify visual regression

5. DOCUMENT
   Update README/comments
   Add JSDoc comments

6. MERGE
   All tests pass ✅
   Code reviewed ✅
   Ready to push!
```

### Code Style

**ESLint & Prettier** are configured to enforce code style:

```bash
# Check for issues
npm run lint

# Auto-fix issues
npm run lint:fix

# Format code
npm run format
```

Files are automatically checked on commit via pre-commit hooks.

---

## 🌍 Multilingual Development

Pomi supports 4 languages from day 1:

1. **English** (en) - LTR
2. **Amharic** (am) - RTL - ሙሉ ቀይ ጽሕፈት
3. **Tigrinya** (ti) - RTL - ሙሉ ቀይ ጽሕፈት
4. **Afan Oromo** (om) - LTR

### Test in Different Languages
```bash
# Test in all 4 languages
npm run test:multilingual

# Or specific language in frontend:
# Edit .env: VITE_DEFAULT_LANGUAGE=am (Amharic)
npm run dev
```

### Add Translations
1. Edit `frontend/src/locales/en.json`
2. Add new keys
3. Translate to other languages
4. Use in components with `useTranslation()`

---

## 🚨 Troubleshooting

### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000
# Kill process
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev
```

### Database Connection Refused
```bash
# Check if Docker containers are running
docker-compose ps

# If not, start them
docker-compose up -d

# Check container logs
docker-compose logs postgres
docker-compose logs mongodb
docker-compose logs redis
```

### Module Not Found
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### TypeScript Errors
```bash
# Clear cache and rebuild
npm run type-check

# In VS Code: Cmd+Shift+P → TypeScript: Restart TS Server
```

---

## 📊 Development Checklist

Before pushing code, ensure:

- [ ] `npm test` passes all tests
- [ ] `npm run lint` has no errors
- [ ] `npm run type-check` has no TypeScript errors
- [ ] Code follows `DEVELOPMENT_STYLE_GUIDE.md`
- [ ] Tested in all 4 languages
- [ ] Tested on mobile/tablet/desktop
- [ ] Accessibility tests pass
- [ ] Screenshots captured for visual regression
- [ ] Updated relevant documentation
- [ ] Commit message is descriptive

---

## 📚 Documentation

Important files to read:

1. **DEVELOPMENT_SETUP.md** - Detailed setup guide
2. **DEVELOPMENT_STYLE_GUIDE.md** - How to code at Pomi
3. **PLAYWRIGHT_TESTING_STRATEGY.md** - Testing approach
4. **POMI_BRAND_GUIDE.md** - Design system & branding
5. **TECHNICAL_SPECIFICATIONS.md** - API & database design

---

## 🤝 Contributing

### Git Workflow
```bash
# Create feature branch
git checkout -b feature/auth-system

# Make changes, commit
git add .
git commit -m "feat: implement user authentication"

# Push and create pull request
git push origin feature/auth-system
```

### Commit Message Format
```
<type>: <subject>

<body>

<footer>

Types: feat, fix, refactor, test, docs, style, chore
```

---

## 📞 Getting Help

- **Setup Issues?** Check DEVELOPMENT_SETUP.md
- **Testing Questions?** Check PLAYWRIGHT_TESTING_STRATEGY.md
- **Code Style?** Check DEVELOPMENT_STYLE_GUIDE.md
- **API Design?** Check TECHNICAL_SPECIFICATIONS.md
- **Stuck?** Ask the team on Slack

---

## 🎯 Next Steps

1. ✅ Environment setup complete
2. ⏳ Start backend development (Week 2)
3. ⏳ Start frontend development (Week 3)
4. ⏳ Integrate frontend + backend (Week 4)
5. ⏳ Testing & launch (Week 6)

---

## 🍎 Pomi Vision

**Pomi: Where Community Blooms**

Through Pomi, we celebrate our heritage, support one another, create opportunities, and grow together.

**Pomi: Seed of Community, Fruit of Success** 🍎

---

**Last Updated:** October 26, 2025
**Status:** Ready for Development
**Contact:** @team on Slack

Happy coding! 🚀
