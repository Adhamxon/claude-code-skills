---
name: api-design-best-practices
description: API Design Best Practices — RESTful APIs, GraphQL, gRPC, WebSocket, versioning, pagination, security, documentation, testing, performance. Use when designing new APIs or reviewing existing API designs.
---

# API Design Best Practices

## RESTful API Design

### Resource Naming & HTTP Methods
```
GET    /users          # List (200)
POST   /users          # Create (201 + Location header)
GET    /users/{id}     # Read   (200)
PUT    /users/{id}     # Full replace (200)
PATCH  /users/{id}     # Partial update (200)
DELETE /users/{id}     # Delete (204)
```

**Rules**: Plural nouns, kebab-case, max 2-3 nesting levels. Use query params for filtering: `/orders?status=active&created_at.gte=2025-01-01`

### Pagination (Cursor-based preferred)
```json
// Request:  GET /users?cursor=eyJpZCI6MTAwfQ&limit=20
// Response:
{"data": [...], "next_cursor": "eyJpZCI6MTIwfQ", "has_more": true}
```

### Error Response (RFC 7807)
```json
{"type": "https://api.example.com/errors/validation",
 "title": "Validation Error",
 "status": 422,
 "detail": "Email is required",
 "errors": {"email": ["is required", "must be valid format"]}}
```

### Versioning
```
URL:     /api/v1/users
Accept:  application/vnd.myapi.v1+json
Deprecation: true
Sunset: Sat, 31 Dec 2025 23:59:59 GMT
```

## GraphQL

### Schema First
```graphql
type Query { user(id: ID!): User @rateLimit(limit: 100, duration: 60) }
type Mutation { createUser(input: CreateUserInput!): User! }
type User @key(fields: "id") {
  id: ID!; name: String!; email: String! @deprecated(reason: "Use emailNew")
}
```

### N+1 Prevention (DataLoader)
```typescript
const userLoader = new DataLoader(async (ids) => {
  const users = await db.users.findByIds(ids);
  return ids.map(id => users.find(u => u.id === id));
});
// Resolver: orders: (parent) => orderLoader.load(parent.id)
```

### Security
```typescript
// Cost analysis
const cost = graphqlCostAnalysis(schema, query, { maxCost: 1000 });
// Depth limiting
validationRules: [depthLimit(5)]
// Query whitelisting (persisted queries)
```

## gRPC

```protobuf
service UserService {
  rpc GetUser (GetUserRequest) returns (User) {}
  rpc ListUsers (ListUsersRequest) returns (stream User) {}  // Server streaming
}

message GetUserRequest { string id = 1; }
message User { string id = 1; string name = 2; }
```

## API Security

| Security | Implementation |
|----------|---------------|
| Rate Limiting | Token bucket: 100 req/min per IP |
| Auth | OAuth 2.0 (Authorization Code + PKCE) |
| JWT | RS256 signed, 15min expiry, include jti, iss, aud |
| CORS | Whitelist specific origins, not `*` |
| Input Validation | Zod schemas at every boundary |
| Request Signing | HMAC-SHA256 for webhook payloads |

## API Gateway Patterns
```yaml
# Kong route example
routes:
  - paths: ["/api/v1/users"]
    methods: ["GET", "POST"]
    plugins:
      - name: rate-limiting
        config: { minute: 100, policy: local }
      - name: key-auth
```

## API Testing
```typescript
// Contract test (Pact)
await provider.addInteraction({
  state: 'user exists',
  uponReceiving: 'get user by id',
  withRequest: { method: 'GET', path: '/users/123' },
  willRespondWith: { status: 200, body: { id: '123' } }
});
```

## API Design Checklist
- [ ] Consistent naming (plural nouns, kebab-case)
- [ ] Proper status codes (201 for create, 204 for delete)
- [ ] Versioning strategy defined
- [ ] Pagination (cursor-based for real-time)
- [ ] Error format (RFC 7807)
- [ ] Rate limiting headers (X-RateLimit-Remaining)
- [ ] Auth (Bearer token / API key)
- [ ] CORS configured (not `*`)
- [ ] Request validation at boundary
- [ ] Response compression (gzip/brotli)
- [ ] Cache headers (ETag, Cache-Control)
- [ ] API documentation (OpenAPI 3.1)
