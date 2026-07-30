---
name: system-design
description: System Design — scalability patterns, availability, caching, database design, microservices, message queues, real-world architectures. Use when designing large-scale systems or preparing for system design interviews.
---

# System Design Skill

## Design Process
1. **Requirements**: Functional (features) + Non-functional (scale, latency, availability, durability)
2. **Estimation**: Traffic (DAU, QPS), Storage (daily growth, retention), Bandwidth (ingress/egress)
3. **Data Model**: Entities, relationships, storage choice (SQL/NoSQL)
4. **API Design**: Endpoints, request/response format
5. **High-level Design**: Components, data flow
6. **Deep Dive**: Scaling, caching, consistency, bottlenecks

### Estimation Formulas
```
QPS = DAU × avg_requests_per_user / 86400
Storage per day = records_per_day × avg_record_size
Peak QPS = avg_QPS × 5 (approximately)
Bandwidth = avg_response_size × peak_QPS
```

## Scalability Patterns

| Pattern | Description | When to Use |
|---------|-------------|-------------|
| **Horizontal Scaling** | Add more servers | Stateless apps, consistent hashing |
| **Vertical Scaling** | Bigger server | Stateful, single-threaded |
| **Sharding** | Split data across DBs | High write throughput |
| **Partitioning** | Split table by key | Large tables (> 1TB) |
| **CQRS** | Separate read/write models | Complex queries, high read load |
| **Event Sourcing** | Store events, not state | Audit trail, temporal queries |
| **Database per Service** | Microservices | Service isolation |

### Consistent Hashing
```
Hash ring: servers and keys hash to same ring space
Key → nearest server clockwise
Virtual nodes for better distribution
```
```python
import hashlib
class ConsistentHashRing:
    def __init__(self, nodes, virtual_nodes=100):
        self.ring = {}
        for node in nodes:
            for i in range(virtual_nodes):
                key = hashlib.md5(f"{node}:{i}".encode()).hexdigest()
                self.ring[key] = node
        self.sorted_keys = sorted(self.ring.keys())
    
    def get(self, key):
        hash_key = hashlib.md5(key.encode()).hexdigest()
        # Binary search for nearest node clockwise
        ...
```

## Caching Strategies

| Strategy | Read | Write | Best For |
|----------|------|-------|----------|
| **Cache-Aside** | Cache miss → DB → set cache | Write to DB, invalidate cache | General purpose |
| **Read-Through** | Cache loads from DB on miss | DB only | Consistent reads |
| **Write-Through** | Cache hit | Write to both cache and DB | Data consistency |
| **Write-Behind** | Cache hit | Write to cache, async to DB | High write throughput |
| **Refresh-Ahead** | Cache proactively refreshes | DB only | Predictable access |

### Cache Sizing
```
Cache hit rate = 95% → cache all hot data
Cache size = daily_active_data × 1.5 (safety margin)
TTL = 3600s (general), 60s (hot data), 86400s (reference data)
```

## Microservices Architecture

### Service Communication
| Pattern | Protocol | Use Case |
|---------|----------|----------|
| **REST** | HTTP/1.1 | Simple CRUD, public APIs |
| **gRPC** | HTTP/2 | Internal, high performance |
| **Message Queue** | Async | Decoupled, event-driven |
| **Event Bus** | Pub/Sub | Event-driven, broadcasting |

### Service Discovery
```yaml
# Kubernetes DNS
service-name.namespace.svc.cluster.local

# Consul
service_name.service.consul

# Client-side: Eureka (Java), Zookeeper
```

### Circuit Breaker
```typescript
// Opossum (Node.js)
const circuit = new CircuitBreaker(callExternalService, {
  timeout: 3000,
  errorThresholdPercentage: 50,  // Open after 50% failures
  resetTimeout: 30000,           // Try after 30s
  volumeThreshold: 10            // Minimum requests before evaluating
});
circuit.fallback(() => cachedData);
```

## Real-World System Designs

### URL Shortener (bit.ly)
```
Core: POST /shorten {url} → {shortCode}
      GET /{shortCode} → 301 redirect
DB:  MySQL (id, shortCode, originalUrl, createdAt, clicks)
Cache: Redis {shortCode → originalUrl} TTL=3600
Redirect: 301 (permanent) vs 302 (temporary)
Encoding: Base62 (a-zA-Z0-9) for short codes
```

### Chat System (WhatsApp)
```
Components: WebSocket Server, Message Queue, DB, Presence Service
Messages: Send → Queue → Store → Push Notification
Architecture: WebSocket for real-time, HTTP for history
DB: Message table partitioned by user_id hash
Cache: Recent messages in Redis (last 100)
```

### Video Streaming (YouTube)
```
Upload: Chunked upload → Transcoding queue → CDN storage
Stream: CDN → HLS/DASH adaptive bitrate
Storage: Object storage (S3/GCS) for raw + CDN for delivery
Processing: FFmpeg transcoding, thumbnails generation
Recommender: Spark/MapReduce for offline, Redis for online
```

### E-commerce (Amazon)
```
Product Service: Catalog, search, recommendations
Order Service: Cart, checkout, payment
Inventory Service: Stock management, reservations
Saga pattern for checkout: Reserve → Payment → Shipment
CQRS: Write to order DB, read from Elasticsearch
Cache: Product detail in Redis, inventory in Redis
```

## Data Consistency

| Model | Description | Use Case |
|-------|-------------|----------|
| **Strong** | All reads see latest write | Financial transactions |
| **Eventual** | Eventually consistent | Social media, analytics |
| **Causal** | Related events in order | Comments, chat |
| **Read-Your-Writes** | User sees own writes | User profiles |

### Distributed Transactions
```
2PC (Two-Phase Commit): Prepare → Commit/Rollback (blocking)
SAGA: Chained local transactions with compensating actions
TCC: Try → Confirm → Cancel (3-phase reservation)
```

## Load Balancing Algorithms
| Algorithm | How It Works | Best For |
|-----------|-------------|----------|
| Round Robin | Sequential distribution | Equal capacity servers |
| Least Connections | Fewest active connections | Variable request times |
| IP Hash | Client IP → server | Session persistence |
| Weighted | Capacity-based distribution | Heterogeneous servers |
| Geographic | Closest server | Global deployments |
