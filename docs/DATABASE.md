# Pomi Database Schema

Complete database design for Pomi application with PostgreSQL for relational data and MongoDB for flexible collections.

## Overview

### PostgreSQL (Relational Data)
Used for structured data with relationships: users, authentication, events, etc.

**Database:** `pomi_db`
**User:** `pomi_user`
**Password:** `pomi_password`

### MongoDB (Flexible Data)
Used for semi-structured data: forum posts, marketplace listings, etc.

**Database:** `pomi`
**User:** `pomi_user`
**Password:** `pomi_password`

## PostgreSQL Schema

### Users Table
Stores user account information and profile data.

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(20),
  avatar_url VARCHAR(500),
  bio TEXT,
  language VARCHAR(10) DEFAULT 'en', -- en, am, ti, om
  country VARCHAR(100),
  city VARCHAR(100),
  zip_code VARCHAR(20),
  email_verified BOOLEAN DEFAULT FALSE,
  email_verified_at TIMESTAMP,
  phone_verified BOOLEAN DEFAULT FALSE,
  phone_verified_at TIMESTAMP,
  status VARCHAR(50) DEFAULT 'active', -- active, suspended, deleted
  is_admin BOOLEAN DEFAULT FALSE,
  is_moderator BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  last_login_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_status ON users(status);
```

### Auth Tokens Table
Manages JWT and refresh tokens.

```sql
CREATE TABLE auth_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(500) NOT NULL UNIQUE,
  type VARCHAR(50) DEFAULT 'access', -- access, refresh
  expires_at TIMESTAMP NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  revoked_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_auth_tokens_user_id ON auth_tokens(user_id);
CREATE INDEX idx_auth_tokens_token ON auth_tokens(token);
CREATE INDEX idx_auth_tokens_expires_at ON auth_tokens(expires_at);
```

### Email Verification Table
Manages email verification codes.

```sql
CREATE TABLE email_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  code VARCHAR(10) NOT NULL UNIQUE,
  attempts INT DEFAULT 0,
  max_attempts INT DEFAULT 3,
  expires_at TIMESTAMP NOT NULL,
  verified_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_email_verifications_user_id ON email_verifications(user_id);
CREATE INDEX idx_email_verifications_code ON email_verifications(code);
```

### Events Table
Event management system.

```sql
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  location VARCHAR(500),
  address VARCHAR(500),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  category VARCHAR(100), -- cultural, social, business, educational
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  capacity INT,
  image_url VARCHAR(500),
  status VARCHAR(50) DEFAULT 'draft', -- draft, published, cancelled, completed
  language VARCHAR(10) DEFAULT 'en',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_events_user_id ON events(user_id);
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_events_start_date ON events(start_date);
CREATE INDEX idx_events_category ON events(category);
```

### Event RSVPs Table
Tracks who is attending events.

```sql
CREATE TABLE event_rsvps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(50) DEFAULT 'going', -- going, interested, maybe, no
  guests_count INT DEFAULT 1,
  rsvped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(event_id, user_id)
);

CREATE INDEX idx_event_rsvps_event_id ON event_rsvps(event_id);
CREATE INDEX idx_event_rsvps_user_id ON event_rsvps(user_id);
```

### Marketplace Listings Table
Buy/sell items within community.

```sql
CREATE TABLE marketplace_listings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100), -- furniture, electronics, services, etc
  price DECIMAL(10,2),
  currency VARCHAR(3) DEFAULT 'CAD',
  status VARCHAR(50) DEFAULT 'active', -- active, sold, pending, expired
  image_urls TEXT[],
  location VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_marketplace_listings_seller_id ON marketplace_listings(seller_id);
CREATE INDEX idx_marketplace_listings_status ON marketplace_listings(status);
CREATE INDEX idx_marketplace_listings_category ON marketplace_listings(category);
```

### Business Directory Table
Business listings and services.

```sql
CREATE TABLE businesses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  business_name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100), -- restaurant, services, retail, etc
  phone VARCHAR(20),
  email VARCHAR(255),
  website VARCHAR(500),
  address VARCHAR(500),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  image_url VARCHAR(500),
  hours_of_operation VARCHAR(255),
  rating DECIMAL(3,2) DEFAULT 0,
  verified BOOLEAN DEFAULT FALSE,
  status VARCHAR(50) DEFAULT 'draft', -- draft, published, verified, suspended
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_businesses_owner_id ON businesses(owner_id);
CREATE INDEX idx_businesses_category ON businesses(category);
CREATE INDEX idx_businesses_status ON businesses(status);
CREATE INDEX idx_businesses_verified ON businesses(verified);
```

## MongoDB Collections

### Forum Posts Collection
Community forum discussions.

```javascript
db.createCollection("forum_posts", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["user_id", "title", "content"],
      properties: {
        _id: { bsonType: "objectId" },
        user_id: { bsonType: "objectId" },
        title: { bsonType: "string" },
        content: { bsonType: "string" },
        category: { bsonType: "string" },
        tags: { bsonType: "array", items: { bsonType: "string" } },
        replies_count: { bsonType: "int" },
        views_count: { bsonType: "int" },
        votes: { bsonType: "int" },
        image_urls: { bsonType: "array", items: { bsonType: "string" } },
        status: { bsonType: "string" }, // published, draft, deleted
        language: { bsonType: "string" },
        created_at: { bsonType: "date" },
        updated_at: { bsonType: "date" },
        deleted_at: { bsonType: "date" }
      }
    }
  }
});

// Indexes
db.forum_posts.createIndex({ user_id: 1 });
db.forum_posts.createIndex({ status: 1 });
db.forum_posts.createIndex({ created_at: -1 });
db.forum_posts.createIndex({ tags: 1 });
```

### Forum Replies Collection
Replies to forum posts.

```javascript
db.createCollection("forum_replies", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["post_id", "user_id", "content"],
      properties: {
        _id: { bsonType: "objectId" },
        post_id: { bsonType: "objectId" },
        user_id: { bsonType: "objectId" },
        content: { bsonType: "string" },
        votes: { bsonType: "int" },
        image_urls: { bsonType: "array" },
        is_solution: { bsonType: "bool" },
        created_at: { bsonType: "date" },
        updated_at: { bsonType: "date" },
        deleted_at: { bsonType: "date" }
      }
    }
  }
});

db.forum_replies.createIndex({ post_id: 1 });
db.forum_replies.createIndex({ user_id: 1 });
db.forum_replies.createIndex({ created_at: -1 });
```

### Mentorship Matches Collection
Matches between mentors and mentees.

```javascript
db.createCollection("mentorship_matches", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["mentor_id", "mentee_id", "status"],
      properties: {
        _id: { bsonType: "objectId" },
        mentor_id: { bsonType: "objectId" },
        mentee_id: { bsonType: "objectId" },
        skill: { bsonType: "string" },
        goal: { bsonType: "string" },
        status: { bsonType: "string" }, // pending, active, completed, cancelled
        start_date: { bsonType: "date" },
        end_date: { bsonType: "date" },
        created_at: { bsonType: "date" },
        updated_at: { bsonType: "date" }
      }
    }
  }
});

db.mentorship_matches.createIndex({ mentor_id: 1 });
db.mentorship_matches.createIndex({ mentee_id: 1 });
db.mentorship_matches.createIndex({ status: 1 });
```

### Community Groups Collection
User groups and communities.

```javascript
db.createCollection("community_groups", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "creator_id"],
      properties: {
        _id: { bsonType: "objectId" },
        name: { bsonType: "string" },
        description: { bsonType: "string" },
        creator_id: { bsonType: "objectId" },
        members: { bsonType: "array", items: { bsonType: "objectId" } },
        category: { bsonType: "string" },
        image_url: { bsonType: "string" },
        privacy: { bsonType: "string" }, // public, private
        created_at: { bsonType: "date" },
        updated_at: { bsonType: "date" }
      }
    }
  }
});

db.community_groups.createIndex({ creator_id: 1 });
db.community_groups.createIndex({ members: 1 });
db.community_groups.createIndex({ privacy: 1 });
```

## Redis Cache Keys

Cache keys for frequently accessed data.

```
# User Cache
user:{user_id}              # User profile
user:email:{email}          # User by email
user:username:{username}    # User by username

# Event Cache
event:{event_id}            # Event details
events:upcoming              # Upcoming events list
events:trending             # Trending events
event:rsvps:{event_id}      # Event RSVPs

# Session Cache
session:{session_id}        # User session
auth:tokens:{user_id}       # User tokens

# Marketplace
marketplace:listings        # Recent listings
marketplace:search:{query}  # Search results

# Forum
forum:posts:{category}      # Posts by category
forum:trending              # Trending posts

# General
app:config                  # App configuration
stats:daily                 # Daily statistics
```

## Relationships Map

```
users (PostgreSQL)
  ├── auth_tokens (one-to-many)
  ├── email_verifications (one-to-many)
  ├── events (one-to-many) ────→ event_rsvps
  ├── marketplace_listings (one-to-many)
  ├── businesses (one-to-many)
  ├── forum_posts (MongoDB) (one-to-many)
  ├── forum_replies (MongoDB) (one-to-many)
  ├── mentorship_matches (MongoDB) (many-to-many)
  └── community_groups (MongoDB) (many-to-many)
```

## Backup and Recovery

### PostgreSQL Backup
```bash
# Full backup
docker-compose exec postgres pg_dump -U pomi_user pomi_db > backup.sql

# Restore
docker-compose exec -T postgres psql -U pomi_user pomi_db < backup.sql
```

### MongoDB Backup
```bash
# Full backup
docker-compose exec mongodb mongodump \
  --username pomi_user \
  --password pomi_password \
  --authenticationDatabase admin

# Restore
docker-compose exec mongodb mongorestore \
  --username pomi_user \
  --password pomi_password \
  --authenticationDatabase admin
```

## Performance Optimization

### Indexing Strategy
- Index foreign keys
- Index frequently sorted fields
- Index search filters
- Index range queries

### Query Optimization
- Use pagination for large datasets
- Denormalize when necessary
- Cache frequently accessed data in Redis
- Use connection pooling

### Monitoring
```bash
# PostgreSQL table sizes
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
WHERE schemaname != 'pg_catalog'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

# MongoDB collection stats
db.stats()
db.collection.stats()
```

## Migration Strategy

### Adding New Fields
1. Add column with default value
2. Update application code
3. Backfill existing data
4. Remove default value (optional)

### Deprecating Fields
1. Mark as deprecated in code
2. Create new field
3. Migrate data
4. Update all references
5. Remove old field

### Backup Before Migrations
Always create backups before running migrations:
```bash
docker-compose exec postgres pg_dump -U pomi_user pomi_db > pre-migration-backup.sql
```

## Best Practices

1. **Use UUIDs** for primary keys (better for distributed systems)
2. **Soft deletes** with `deleted_at` timestamp
3. **Timestamps** for auditing (created_at, updated_at, deleted_at)
4. **Proper indexes** for frequently queried fields
5. **Regular backups** before major changes
6. **Data validation** at application level
7. **Connection pooling** for database efficiency
8. **Monitor** database performance regularly

## Related Documentation

- [DOCKER_SETUP.md](./DOCKER_SETUP.md) - Database connection details
- [API.md](./API.md) - API endpoints that interact with database
- [TECHNICAL_SPECIFICATIONS.md](../TECHNICAL_SPECIFICATIONS.md) - System architecture
