---
name: database-optimization
description: Database Optimization — query tuning, indexing strategies, schema design, connection pooling, caching patterns, migration strategies. Use when optimizing database performance, designing schemas, or troubleshooting slow queries.
---

# Database Optimization Skill

## PostgreSQL Optimization

### Indexing Strategy
```sql
-- B-tree (default): equality + range queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_created ON orders(created_at DESC);

-- Hash: equality only (faster for simple lookups)
CREATE INDEX idx_users_id_hash ON users USING hash(id);

-- GiST: full-text search, geometry, arrays
CREATE INDEX idx_docs_content ON documents USING gist(to_tsvector('english', content));

-- GIN: JSONB, full-text, arrays (better for composite)
CREATE INDEX idx_users_prefs ON users USING gin(preferences);
CREATE INDEX idx_tags ON posts USING gin(tags);

-- Partial: conditional indexing
CREATE INDEX idx_active_users ON users(email) WHERE status = 'active';

-- Covering (INCLUDE): index-only scans
CREATE INDEX idx_orders_user ON orders(user_id) INCLUDE (total, status, created_at);

-- Composite: order matters (most selective first)
CREATE INDEX idx_users_status_created ON users(status, created_at DESC);
```

### Query Optimization
```sql
-- Use EXPLAIN ANALYZE
EXPLAIN (ANALYZE, BUFFERS, TIMING) SELECT * FROM users WHERE email = 'test@test.com';

-- Common issues:
-- Seq Scan on large table → add index
-- Nested Loop with many rows → consider Hash Join
-- Sort (memory: external merge) → create index on sort column
-- Bitmap Heap Scan with recheck → increase work_mem

-- Optimize pagination (keyset vs offset)
-- ❌ Slow: SELECT * FROM users OFFSET 100000 LIMIT 20;
-- ✅ Fast: SELECT * FROM users WHERE id > 100000 ORDER BY id LIMIT 20;
```

### Connection Pooling
```typescript
// PgBouncer config
[databases]
mydb = host=localhost port=5432 dbname=mydb
[pgbouncer]
pool_mode = transaction          -- best for web apps
max_client_conn = 100
default_pool_size = 25           -- CPU cores * 2 + disk spindles
max_db_connections = 50
```

### Performance Tuning Parameters
```ini
# postgresql.conf (adjust per workload)
shared_buffers = 4GB             # 25% of RAM
effective_cache_size = 12GB      # 75% of RAM
work_mem = 64MB                  # per sort/hash operation
maintenance_work_mem = 1GB       # VACUUM, CREATE INDEX
random_page_cost = 1.1           # SSD: 1.1, HDD: 4.0
effective_io_concurrency = 200   # SSD: 200, HDD: 2
wal_buffers = 64MB
max_worker_processes = 8
max_parallel_workers_per_gather = 4
```

## MySQL Optimization

### Indexing
```sql
-- Composite index with column order
ALTER TABLE orders ADD INDEX idx_user_status (user_id, status, created_at DESC);

-- Use EXPLAIN to check
EXPLAIN SELECT * FROM orders WHERE user_id = 123 AND status = 'active';

-- Avoid full table scans
-- Check: type = ALL, rows very large
```

### Query Patterns to Avoid
```sql
-- ❌ No index: WHERE YEAR(created_at) = 2025
-- ✅ Index: WHERE created_at >= '2025-01-01' AND created_at < '2026-01-01'

-- ❌ No index: WHERE CONCAT(first_name, ' ', last_name) = 'John Doe'
-- ✅ Index: WHERE first_name = 'John' AND last_name = 'Doe'
-- ✅ Or use generated column: full_name VARCHAR(255) GENERATED ALWAYS AS (CONCAT(first_name, ' ', last_name)) STORED

-- ❌ No index: WHERE id IN (SELECT user_id FROM orders WHERE total > 100)
-- ✅ Better: WHERE EXISTS (SELECT 1 FROM orders WHERE orders.user_id = users.id AND total > 100)

-- ❌ Loose index: WHERE status = 'active' ORDER BY created_at
-- ✅ Need composite index: (status, created_at)
```

## MongoDB Optimization

### Indexing
```javascript
// Compound index
db.orders.createIndex({ userId: 1, createdAt: -1, status: 1 });

// Partial index (sparse)
db.users.createIndex({ email: 1 }, { partialFilterExpression: { verified: true } });

// Text index
db.articles.createIndex({ title: "text", body: "text" }, { weights: { title: 10, body: 5 } });
```

### Aggregation Pipeline Optimization
```javascript
// ❌ Slow: $lookup before $match
db.orders.aggregate([
  { $lookup: { from: "users", localField: "userId", foreignField: "_id", as: "user" }},
  { $match: { "user.status": "active" }}
]);

// ✅ Fast: $match before $lookup
db.users.aggregate([
  { $match: { status: "active" }},
  { $lookup: { from: "orders", localField: "_id", foreignField: "userId", as: "orders" }}
]);
```

## Caching Patterns

### Redis Cache Strategies
```typescript
// Cache-Aside (most common)
async function getUser(id: string) {
  let user = await redis.get(`user:${id}`);
  if (!user) {
    user = await db.users.findById(id);
    await redis.set(`user:${id}`, JSON.stringify(user), 'EX', 3600);
  }
  return JSON.parse(user);
}

// Write-Through
async function updateUser(id: string, data: any) {
  await db.users.update(id, data);
  await redis.set(`user:${id}`, JSON.stringify(data), 'EX', 3600);
}

// Write-Behind (async, high write throughput)
async function writeBehind(id: string, data: any) {
  await redis.set(`user:${id}:pending`, JSON.stringify(data));
  // Background worker syncs to DB periodically
}
```

### Cache Invalidation
```typescript
// Pattern: cache tags for group invalidation
await redis.set(`post:${id}`, data);
await redis.sadd(`user:${userId}:posts`, `post:${id}`);

// Invalidate all user's posts
const keys = await redis.smembers(`user:${userId}:posts`);
await redis.del(...keys);
```

## Migration Strategies
```typescript
// Zero-downtime migrations
// 1. Expand: Add new column, allow NULL
// 2. Migrate: Backfill data in batches (1000 rows/batch)
// 3. Constrain: Add NOT NULL, drop old column

// Batch backfill (PostgreSQL)
WITH batch AS (
  SELECT id FROM users WHERE new_column IS NULL LIMIT 1000 FOR UPDATE SKIP LOCKED
)
UPDATE users SET new_column = compute_value(old_column)
FROM batch WHERE users.id = batch.id;
```

## General Optimization Checklist
- [ ] Missing indexes identified (pg_stat_user_indexes, slow query log)
- [ ] N+1 queries eliminated (eager loading, batch loading)
- [ ] Connection pooling configured (PgBouncer, ProxySQL)
- [ ] Query optimization (EXPLAIN ANALYZE reviewed)
- [ ] Caching implemented (Redis for hot data)
- [ ] Data archival strategy (partitioning for time-series)
- [ ] Read replicas for read-heavy workloads
- [ ] Regular VACUUM (PostgreSQL) / OPTIMIZE (MySQL)
- [ ] Monitoring (pg_stat_statements, slow query log)
- [ ] Connection limits per service/app
