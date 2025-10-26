# 🗄️ Pomi Database Setup Guide

## Overview

Pomi uses three databases for different purposes:

1. **MongoDB** - User authentication, profiles, flexible documents
2. **PostgreSQL** - Events, marketplace, forums, business listings (relational data)
3. **Redis** - Caching, sessions, real-time features

---

## 🚀 Quick Start with Docker Compose

### Prerequisites
- Docker installed ([Download Docker](https://www.docker.com/products/docker-desktop))
- Docker Compose installed (comes with Docker Desktop)

### Start All Databases

```bash
# Navigate to project root
cd /Users/everestode/Desktop/POMI/pomi-app

# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### Stop All Databases

```bash
docker-compose down

# Also remove volumes (warning: deletes data)
docker-compose down -v
```

---

## 🔧 Individual Database Setup

### MongoDB (Currently Using for Auth)

**Option 1: Docker**
```bash
docker run -d \
  --name pomi-mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=pomi_user \
  -e MONGO_INITDB_ROOT_PASSWORD=pomi_password \
  -e MONGO_INITDB_DATABASE=pomi \
  mongo:7
```

**Option 2: Local Installation**
```bash
# macOS with Homebrew
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community

# Stop MongoDB
brew services stop mongodb-community
```

**Option 3: MongoDB Atlas (Cloud)**
1. Go to https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create a cluster
4. Get connection string
5. Update `.env` file with connection string

**Connection Details:**
- Host: `localhost:27017`
- Username: `pomi_user`
- Password: `pomi_password`
- Database: `pomi`
- Connection URI: `mongodb://pomi_user:pomi_password@localhost:27017/pomi`

---

### PostgreSQL (For Future Features)

**Option 1: Docker**
```bash
docker run -d \
  --name pomi-postgres \
  -p 5432:5432 \
  -e POSTGRES_USER=pomi_user \
  -e POSTGRES_PASSWORD=pomi_password \
  -e POSTGRES_DB=pomi_db \
  postgres:16-alpine
```

**Option 2: Local Installation**
```bash
# macOS with Homebrew
brew install postgresql

# Start PostgreSQL
brew services start postgresql

# Stop PostgreSQL
brew services stop postgresql

# Access psql
psql -U postgres
```

**Option 3: Remote (AWS RDS, Heroku, etc.)**
- Create database instance
- Update connection string in `.env`

**Connection Details:**
- Host: `localhost:5432`
- Username: `pomi_user`
- Password: `pomi_password`
- Database: `pomi_db`
- Connection URI: `postgresql://pomi_user:pomi_password@localhost:5432/pomi_db`

---

### Redis (For Caching & Sessions)

**Option 1: Docker**
```bash
docker run -d \
  --name pomi-redis \
  -p 6379:6379 \
  redis:7-alpine
```

**Option 2: Local Installation**
```bash
# macOS with Homebrew
brew install redis

# Start Redis
brew services start redis

# Stop Redis
brew services stop redis

# Test connection
redis-cli ping
# Should return: PONG
```

**Connection Details:**
- Host: `localhost:6379`
- Connection URI: `redis://localhost:6379`

---

## 📋 Checking Database Connections

### MongoDB
```bash
# Using mongosh
mongosh "mongodb://pomi_user:pomi_password@localhost:27017/pomi"

# List databases
show databases

# List collections
use pomi
show collections

# Check users collection
db.users.find()
```

### PostgreSQL
```bash
# Connect to database
psql -h localhost -U pomi_user -d pomi_db

# List tables
\dt

# List databases
\l

# Exit
\q
```

### Redis
```bash
# Connect
redis-cli

# Ping test
ping

# List keys
keys *

# Get value
get key_name

# Exit
exit
```

---

## 🔌 Backend Configuration

### MongoDB Connection in Node.js

**.env file:**
```
MONGODB_URI=mongodb://pomi_user:pomi_password@localhost:27017/pomi
JWT_SECRET=your-secret-key
JWT_EXPIRE=7d
```

**Backend app.ts** already includes:
```typescript
import mongoose from 'mongoose';

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ MongoDB connected');
  } catch (error) {
    console.error('❌ MongoDB failed:', error);
    process.exit(1);
  }
};
```

### PostgreSQL Connection (For Future Use)

**When ready to use PostgreSQL:**
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://pomi_user:pomi_password@localhost:5432/pomi_db'
});
```

### Redis Connection (For Future Use)

**When ready to use Redis:**
```typescript
import redis from 'redis';

const client = redis.createClient({
  host: 'localhost',
  port: 6379
});

client.connect();
```

---

## 🗑️ Database Cleanup

### Clear All Data

**MongoDB:**
```javascript
// Connect and run
db.dropDatabase()
```

**PostgreSQL:**
```sql
-- Connect and run
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
```

**Redis:**
```
redis-cli
FLUSHDB  -- Clear current database
FLUSHALL -- Clear all databases
```

---

## 📊 Database Persistence

### Docker Volumes

Data is stored in Docker volumes:
- `mongodb_data` - MongoDB data
- `postgres_data` - PostgreSQL data
- `redis_data` - Redis data

View volumes:
```bash
docker volume ls
```

Inspect volume:
```bash
docker volume inspect pomi-app_mongodb_data
```

Remove volume (warning: deletes data):
```bash
docker volume rm pomi-app_mongodb_data
```

---

## 🚨 Troubleshooting

### MongoDB won't connect
```bash
# Check if running
docker ps | grep mongo

# View logs
docker logs pomi-mongodb

# Check connection
mongosh "mongodb://pomi_user:pomi_password@localhost:27017/pomi"
```

### PostgreSQL port already in use
```bash
# Find what's using port 5432
lsof -i :5432

# Kill the process
kill -9 <PID>

# Or use different port in docker-compose.yml
```

### Redis connection refused
```bash
# Check if running
docker ps | grep redis

# Test connection
redis-cli ping
```

### Docker Compose failing
```bash
# Remove old containers
docker-compose down -v

# Try again
docker-compose up -d

# Check logs
docker-compose logs
```

---

## 💡 Recommended Setup for Development

### Local Development (No Docker)
```bash
# Install locally
brew install mongodb-community postgresql redis

# Start services
brew services start mongodb-community
brew services start postgresql
brew services start redis

# Verify
mongosh --version
psql --version
redis-cli --version
```

### Docker Development (Recommended)
```bash
# Single command
docker-compose up -d

# Clean shutdown
docker-compose down
```

### Cloud Development (Production)
```
MongoDB Atlas: https://www.mongodb.com/cloud/atlas (Free tier available)
PostgreSQL: AWS RDS, Heroku, Railway.app, etc.
Redis: Redis Cloud, AWS ElastiCache, etc.
```

---

## 📚 Environment Variables

### Backend (.env)

```env
# Server
PORT=3000
NODE_ENV=development

# MongoDB
MONGODB_URI=mongodb://pomi_user:pomi_password@localhost:27017/pomi

# PostgreSQL (for future use)
DATABASE_URL=postgresql://pomi_user:pomi_password@localhost:5432/pomi_db

# Redis (for future use)
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-super-secret-key-change-in-production
JWT_EXPIRE=7d

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000
```

### Frontend (.env)

```env
VITE_API_URL=http://localhost:3000/api/v1
VITE_APP_NAME=Pomi
VITE_ENABLE_ANALYTICS=true
```

---

## ✅ Health Checks

### Check Backend Health
```bash
curl http://localhost:3000/health
```

Response:
```json
{
  "status": "ok",
  "timestamp": "2025-10-26T20:00:00.000Z",
  "uptime": 123.456,
  "mongodb": "connected"
}
```

### Check Frontend
```bash
curl http://localhost:5173
```

---

## 🔐 Security Notes

- Change default passwords in production!
- Use environment variables for credentials
- Don't commit `.env` files to Git
- Use `.env.example` for template
- Enable MongoDB authentication in production
- Use SSL/TLS for database connections in production
- Use strong JWT_SECRET (min 32 characters)

---

## 📞 Need Help?

- Docker: https://docs.docker.com/
- MongoDB: https://docs.mongodb.com/
- PostgreSQL: https://www.postgresql.org/docs/
- Redis: https://redis.io/documentation
- Node.js: https://nodejs.org/en/docs/

---

**Last Updated:** 2025-10-26
