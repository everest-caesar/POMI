# Docker Setup Guide for Pomi

This guide explains how to use Docker Compose to run Pomi's development environment with PostgreSQL, MongoDB, and Redis.

## Prerequisites

- **Docker**: [Install Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Docker Compose**: Included with Docker Desktop
- **Git**: For cloning the repository

### Verify Installation

```bash
docker --version      # Should be 20.10+
docker-compose --version  # Should be 1.29+
```

## Quick Start (3 steps)

### 1. Set Up Environment Variables
```bash
cp .env.example .env
# Review .env and update with your values if needed
```

### 2. Start Database Services
```bash
docker-compose up -d
```

### 3. Verify Services Are Running
```bash
docker-compose ps
```

Expected output:
```
NAME           COMMAND             STATUS
pomi-postgres  postgres            Up (healthy)
pomi-mongodb   mongod              Up (healthy)
pomi-redis     redis-server        Up (healthy)
```

## Services

### PostgreSQL (Port 5432)
Structured relational database for core application data.

**Credentials:**
- Username: `pomi_user`
- Password: `pomi_password`
- Database: `pomi_db`

**Connection String:**
```
postgresql://pomi_user:pomi_password@localhost:5432/pomi_db
```

**Connect to PostgreSQL:**
```bash
docker-compose exec postgres psql -U pomi_user -d pomi_db
```

**Common Commands:**
```sql
\dt                  -- List all tables
\d table_name        -- Describe table
SELECT * FROM users; -- Query data
\q                   -- Exit
```

### MongoDB (Port 27017)
NoSQL document database for flexible data structures.

**Credentials:**
- Username: `pomi_user`
- Password: `pomi_password`
- Database: `pomi`
- Auth Database: `admin`

**Connection String:**
```
mongodb://pomi_user:pomi_password@localhost:27017/pomi?authSource=admin
```

**Connect to MongoDB:**
```bash
docker-compose exec mongodb mongosh -u pomi_user -p pomi_password --authenticationDatabase admin
```

**Common Commands:**
```javascript
show dbs                    // List databases
use pomi                    // Switch to pomi database
show collections            // List collections
db.users.find({})          // Query documents
db.users.findOne()         // Find one document
db.createCollection("name") // Create collection
db.collection.drop()       // Delete collection
exit                       // Exit
```

### Redis (Port 6379)
In-memory data store for caching and sessions.

**Connection String:**
```
redis://localhost:6379
```

**Connect to Redis:**
```bash
docker-compose exec redis redis-cli
```

**Common Commands:**
```
PING              -- Test connection (should return PONG)
SET key value     -- Set a key-value pair
GET key           -- Get value by key
DEL key           -- Delete a key
KEYS *            -- List all keys
FLUSHDB           -- Clear current database
FLUSHALL          -- Clear all databases
DBSIZE            -- Show database size
exit              -- Exit
```

## Docker Compose Commands

### Start Services
```bash
# Start services in the background
docker-compose up -d

# Start services in the foreground (view logs)
docker-compose up

# Start specific service
docker-compose up -d postgres
```

### Stop Services
```bash
# Stop all services (keep data)
docker-compose stop

# Stop and remove containers (keep data)
docker-compose down

# Stop, remove containers and volumes (DELETE DATA)
docker-compose down -v
```

### View Logs
```bash
# View logs from all services
docker-compose logs

# View logs from specific service
docker-compose logs postgres
docker-compose logs mongodb
docker-compose logs redis

# View real-time logs
docker-compose logs -f

# View last 100 lines
docker-compose logs --tail=100
```

### Database Management

#### Backup Database
```bash
# PostgreSQL backup
docker-compose exec postgres pg_dump -U pomi_user pomi_db > backup.sql

# MongoDB backup
docker-compose exec mongodb mongodump --username pomi_user --password pomi_password --authenticationDatabase admin
```

#### Restore Database
```bash
# PostgreSQL restore
docker-compose exec -T postgres psql -U pomi_user pomi_db < backup.sql

# MongoDB restore
docker-compose exec mongodb mongorestore --username pomi_user --password pomi_password --authenticationDatabase admin dump/
```

#### Clear Database
```bash
# Clear PostgreSQL database
docker-compose exec postgres psql -U pomi_user -d pomi_db -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

# Clear MongoDB database
docker-compose exec mongodb mongosh -u pomi_user -p pomi_password --authenticationDatabase admin --eval "db.dropDatabase()"

# Clear Redis
docker-compose exec redis redis-cli FLUSHDB
```

## Troubleshooting

### Services Won't Start
```bash
# Check service status
docker-compose ps

# View error logs
docker-compose logs

# Rebuild containers
docker-compose down
docker-compose up --build
```

### Port Already in Use
```bash
# Find process using port 5432 (PostgreSQL)
lsof -i :5432

# Find process using port 27017 (MongoDB)
lsof -i :27017

# Find process using port 6379 (Redis)
lsof -i :6379

# Kill process
kill -9 <PID>

# Or use different ports in docker-compose.yml
```

### Can't Connect to Database
```bash
# Check if containers are running
docker-compose ps

# Check container network
docker network ls
docker network inspect pomi-network

# Check container IP
docker inspect pomi-postgres | grep IPAddress

# Test connection
docker-compose exec postgres pg_isready -U pomi_user
docker-compose exec mongodb mongosh --eval "db.adminCommand('ping')"
docker-compose exec redis redis-cli ping
```

### Database Password Issues
Password is `pomi_password`. If you changed it:
1. Update `.env` file
2. Clear volumes: `docker-compose down -v`
3. Update `docker-compose.yml` if needed
4. Restart: `docker-compose up -d`

### Performance Issues
```bash
# Check disk space
docker system df

# Clean up unused images/containers
docker system prune

# Check resource usage
docker stats

# Increase Docker memory limit in Docker Desktop settings
```

## Development Workflow

### 1. Start Development Environment
```bash
# Terminal 1: Start databases
docker-compose up -d

# Terminal 2: Start backend
cd backend
npm run dev

# Terminal 3: Start frontend
cd frontend
npm run dev
```

### 2. Monitor Services
```bash
# View real-time logs
docker-compose logs -f

# Check service health
docker-compose ps
```

### 3. Access Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Frontend | http://localhost:5173 | N/A |
| Backend API | http://localhost:3000 | N/A |
| PostgreSQL | localhost:5432 | user: `pomi_user` / pass: `pomi_password` |
| MongoDB | localhost:27017 | user: `pomi_user` / pass: `pomi_password` |
| Redis | localhost:6379 | No auth (local) |

### 4. Develop and Test
```bash
# Make code changes
# Tests run automatically with npm run dev:watch

# Run tests
npm test

# Check code quality
npm run lint
npm run type-check
```

### 5. Stop Development
```bash
# Keep containers (fast restart)
docker-compose stop

# Remove containers but keep data (clean slate)
docker-compose down

# Full cleanup (removes data too)
docker-compose down -v
```

## Production Considerations

### Security
- Change default passwords in production
- Use secrets management (AWS Secrets Manager, Vault, etc.)
- Enable authentication on Redis
- Use environment-specific credentials
- Enable SSL/TLS for database connections

### Performance
- Use persistent volumes for data
- Configure appropriate resource limits
- Set up monitoring and alerts
- Use connection pooling
- Enable caching strategies

### Backup Strategy
- Automated daily backups
- Test restore procedures
- Store backups in separate location
- Implement backup retention policy

### Scaling
- Use Docker Swarm or Kubernetes for multiple nodes
- Implement load balancing
- Use managed database services (AWS RDS, MongoDB Atlas)
- Consider microservices architecture

## Advanced Docker Commands

### Build Custom Images
```bash
docker build -t pomi-backend:1.0 backend/
docker build -t pomi-frontend:1.0 frontend/
```

### Run Single Container
```bash
docker run -p 5432:5432 postgres:16-alpine
```

### Execute Commands in Container
```bash
docker-compose exec postgres bash
docker-compose exec mongodb bash
docker-compose exec redis bash
```

### View Container Details
```bash
docker inspect pomi-postgres
docker ps -a
docker images
```

### Network Communication
```bash
# Services communicate by container name
# Example: PostgreSQL from backend
# Host: postgres (not localhost)
# Port: 5432

# From outside Docker
# Host: localhost
# Port: 5432 (mapped port)
```

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Docker Image](https://hub.docker.com/_/postgres)
- [MongoDB Docker Image](https://hub.docker.com/_/mongo)
- [Redis Docker Image](https://hub.docker.com/_/redis)

## Getting Help

If you encounter issues:

1. Check logs: `docker-compose logs -f`
2. Verify configuration: Check `.env` and `docker-compose.yml`
3. Test connections: Use CLI tools to connect to databases
4. Restart services: `docker-compose restart`
5. Full reset: `docker-compose down -v && docker-compose up -d`
6. Ask the team on Slack or GitHub Issues
