# Pomi Documentation

Welcome to the Pomi documentation hub! Here you'll find everything you need to understand, develop, and deploy the Pomi application.

## Quick Navigation

### Getting Started
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Quick setup guide (5 minutes)
- **[DEVELOPMENT_SETUP.md](../DEVELOPMENT_SETUP.md)** - Detailed environment setup
- **[DOCKER_SETUP.md](DOCKER_SETUP.md)** - Docker and database management

### Development
- **[DEVELOPMENT_STYLE_GUIDE.md](../DEVELOPMENT_STYLE_GUIDE.md)** - Code style and conventions
- **[API Documentation](./API.md)** - REST API endpoints
- **[Database Schema](./DATABASE.md)** - Data models and relationships

### Testing
- **[frontend/tests/README.md](../frontend/tests/README.md)** - Frontend testing guide
- **[backend/tests/README.md](../backend/tests/README.md)** - Backend testing guide
- **[PLAYWRIGHT_TESTING_STRATEGY.md](../PLAYWRIGHT_TESTING_STRATEGY.md)** - E2E testing approach

### Design & Branding
- **[POMI_BRAND_GUIDE.md](../POMI_BRAND_GUIDE.md)** - Brand identity and design system
- **[MVP_FEATURE_MATRIX.md](../MVP_FEATURE_MATRIX.md)** - Feature prioritization

### Project Planning
- **[PROJECT_KICKOFF.md](../PROJECT_KICKOFF.md)** - Complete project strategy
- **[TECHNICAL_SPECIFICATIONS.md](../TECHNICAL_SPECIFICATIONS.md)** - System architecture

## Technology Stack

### Backend
- **Framework**: Express.js 4.18+
- **Language**: TypeScript 5.3+
- **Databases**: PostgreSQL 16, MongoDB 7, Redis 7
- **Authentication**: JWT + bcryptjs
- **Testing**: Jest + Supertest
- **Quality**: ESLint, Prettier, TypeScript strict mode

### Frontend
- **Framework**: React 18
- **Build Tool**: Vite 5
- **Language**: TypeScript 5.3+
- **Styling**: Tailwind CSS 3.3+
- **State Management**: Redux Toolkit
- **Routing**: React Router v6
- **i18n**: i18next (4 languages)
- **Testing**: Playwright, Vitest, Testing Library
- **Accessibility**: Axe, WCAG 2.1 AA

### DevOps
- **Containerization**: Docker & Docker Compose
- **CI/CD**: GitHub Actions (planned)
- **Deployment**: AWS (planned)

## Project Structure

```
pomi-app/
├── backend/                 # Node.js + Express API
│   ├── src/
│   ├── tests/
│   ├── package.json
│   └── tsconfig.json
├── frontend/               # React + Vite SPA
│   ├── src/
│   ├── tests/
│   ├── package.json
│   └── tsconfig.json
├── docs/                   # Documentation
├── docker-compose.yml      # Database services
├── .env.example           # Environment template
├── GETTING_STARTED.md     # Quick start guide
└── README.md              # Project overview
```

## Key Features

### 7 Core Modules
1. **🎉 Events** - Event management and RSVP
2. **🛍️ Marketplace** - Buy/sell items within community
3. **🏢 Business Directory** - Business listings and services
4. **💬 Forums** - Community discussions
5. **👥 Mentorship** - Connect mentors with mentees
6. **📱 Community** - Social features and groups
7. **⚙️ Admin** - System administration

### Quality Standards
- **Testing**: 70%+ code coverage
- **Accessibility**: WCAG 2.1 AA compliant
- **Multilingual**: 4-language support (English, Amharic, Tigrinya, Oromo)
- **Performance**: Target <3s page load time
- **Type Safety**: TypeScript strict mode enforced

## Development Cycle

Follow the **5-Step Pomi Development Cycle**:

```
1. CODE      → Write feature in TypeScript
2. SCREENSHOT → npm run test:ui (visualize in Playwright)
3. VERIFY    → Test in 4 languages
4. TEST      → Write E2E and unit tests
5. DOCUMENT  → Update README/JSDoc
6. MERGE     → All tests pass, create PR
```

## Common Tasks

### Running the Application
```bash
# Install dependencies
npm install

# Start databases
docker-compose up -d

# Start development servers
npm run dev

# Access:
# - Frontend: http://localhost:5173
# - Backend: http://localhost:3000
```

### Running Tests
```bash
# All tests
npm test

# E2E tests
npm run test:e2e

# Visual regression
npm run test:visual

# Multilingual tests
npm run test:multilingual

# Accessibility tests
npm run test:a11y
```

### Code Quality
```bash
# Lint code
npm run lint
npm run lint:fix

# Format code
npm run format

# Type checking
npm run type-check

# Build
npm run build
```

### Database Management
```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U pomi_user -d pomi_db

# Connect to MongoDB
docker-compose exec mongodb mongosh -u pomi_user -p pomi_password --authenticationDatabase admin

# Connect to Redis
docker-compose exec redis redis-cli
```

## Contributing

### Workflow
1. Create feature branch: `git checkout -b feature/name`
2. Make changes following [code style guide](../DEVELOPMENT_STYLE_GUIDE.md)
3. Run tests: `npm test`
4. Commit changes: `git commit -m "type: message"`
5. Push and create pull request

### Code Standards
- **TypeScript**: Strict mode, explicit types
- **Formatting**: Prettier (auto-format on save)
- **Linting**: ESLint rules enforced
- **Testing**: 70%+ coverage required
- **Documentation**: JSDoc for public APIs

### Commit Message Format
```
<type>: <subject>

<body>

<footer>

Types: feat, fix, refactor, test, docs, style, chore
```

## Troubleshooting

### Common Issues

**Port already in use**
```bash
# Kill process on port 3000
lsof -i :3000
kill -9 <PID>
```

**Docker containers won't start**
```bash
docker-compose logs
docker-compose down -v
docker-compose up -d
```

**TypeScript errors**
```bash
npm run type-check
# Restart TS Server in VS Code (Cmd+Shift+P)
```

**Test failures**
```bash
npm test -- --verbose
npm run test:headed -- path/to/test.spec.ts
```

### Getting Help
- Check relevant documentation
- Search GitHub issues
- Ask on Slack #pomi-dev
- Review code examples in tests/

## Documentation Standards

### When Creating Documentation
- Use clear, concise language
- Include code examples
- Add troubleshooting section
- Link to related docs
- Keep updated with code changes

### Documentation Templates
- **Setup Guides**: Prerequisites, step-by-step, verification
- **API Docs**: Endpoint, method, auth, request/response examples
- **Testing Docs**: Setup, running tests, best practices, examples
- **Architecture**: Overview, components, data flow, decisions

## Resources

### Official Documentation
- [Express.js](https://expressjs.com/)
- [React](https://react.dev/)
- [TypeScript](https://www.typescriptlang.org/)
- [Playwright](https://playwright.dev/)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [MongoDB](https://docs.mongodb.com/)
- [Tailwind CSS](https://tailwindcss.com/)

### Learning Resources
- [JavaScript Testing Best Practices](https://github.com/goldbergyoni/javascript-testing-best-practices)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Web Accessibility](https://www.w3.org/WAI/)

## Team Contacts

- **Project Lead**: Pomi Team
- **Development**: @team on Slack
- **Issues**: GitHub Issues

## License

Pomi is an open-source project for the Ethiopian community in Ottawa.

## Last Updated

October 26, 2025

---

**Happy coding! 🍎**

For the latest project status and updates, check the main [README.md](../README.md) and project boards.
