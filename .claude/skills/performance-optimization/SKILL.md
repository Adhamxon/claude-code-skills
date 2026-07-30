---
name: performance-optimization
description: Performance Optimization — frontend (Core Web Vitals, bundle optimization, lazy loading), backend (caching, connection pooling, async), database (query tuning, indexing), network (CDN, HTTP/2, compression). Use when improving application speed and efficiency.
---

# Performance Optimization Skill

## Frontend Performance

### Core Web Vitals Targets
| Metric | Good | Needs Improvement | Poor |
|--------|------|------------------|------|
| **LCP** (Loading) | ≤ 2.5s | 2.5s - 4.0s | > 4.0s |
| **FID / INP** (Interactivity) | ≤ 100ms | 100ms - 300ms | > 300ms |
| **CLS** (Visual Stability) | ≤ 0.1 | 0.1 - 0.25 | > 0.25 |

### Bundle Optimization
```typescript
// Code splitting (Next.js)
const Dashboard = dynamic(() => import('@/components/Dashboard'), {
  loading: () => <Skeleton />,
  ssr: false, // Client-only
});

// Tree shaking - import only what you need
import { format } from 'date-fns';  // ✅ Good: 2kB
import { format } from 'date-fns/esm/format';  // ✅ Better: 1kB

// Bundle analysis
// next.config.js
const withBundleAnalyzer = require('@next/bundle-analyzer')({ enabled: process.env.ANALYZE === 'true' });
```

### Image Optimization
```tsx
// Next.js Image
import Image from 'next/image';
<Image
  src="/hero.webp"
  width={1200} height={600}
  priority // Above the fold
  loading="lazy" // Below the fold
  placeholder="blur"
  blurDataURL="data:image/webp;base64,..."
/>

// Always use modern formats: WebP, AVIF
// Responsive images with srcSet
// Lazy load below-fold images
// Preload critical images: <link rel="preload" as="image" href="/hero.webp">
```

### Rendering Strategies
```typescript
// SSR (Server-Side Rendering) - Dynamic, SEO
export const dynamic = 'force-dynamic';

// SSG (Static Site Generation) - Static content
export const dynamic = 'force-static';

// ISR (Incremental Static Regeneration)
export const revalidate = 3600; // Revalidate every hour

// Streaming SSR - Progressive rendering
export default function Page() {
  return (
    <Suspense fallback={<Skeleton />}>
      <SlowComponent />
    </Suspense>
  );
}

// Partial Prerendering (PPR) - Static + Dynamic hybrid
```

### React Performance
```tsx
// useMemo for expensive calculations
const sortedItems = useMemo(() => 
  items.sort((a, b) => a.date - b.date), 
  [items]
);

// useCallback for stable function references
const handleClick = useCallback(() => {
  setCount(c => c + 1);
}, []);

// React.memo for pure components
const ExpensiveList = React.memo(({ items }: { items: Item[] }) => (
  <ul>{items.map(item => <li key={item.id}>{item.name}</li>)}</ul>
));

// Virtualization for long lists
import { Virtualizer } from '@tanstack/react-virtual';
```

## Backend Performance

### Node.js Optimization
```typescript
// Cluster mode (multi-core)
import cluster from 'cluster';
if (cluster.isPrimary) {
  for (let i = 0; i < os.cpus().length; i++) cluster.fork();
} else {
  app.listen(3000);
}

// Compression
import compression from 'compression';
app.use(compression({ level: 6, threshold: 1024 })); // gzip/brotli

// Response caching
app.get('/api/users', cacheMiddleware(60), async (req, res) => {
  // Response cached for 60s in Redis
});

// Connection pooling (pg-pool)
const pool = new Pool({ max: 20, idleTimeoutMillis: 30000 });
```

### Python/FastAPI Optimization
```python
from fastapi import FastAPI
from asyncio import to_thread

app = FastAPI()

# Async endpoints for I/O
@app.get("/users")
async def get_users():
    return await db.fetch_all("SELECT * FROM users")

# CPU-bound tasks run in thread pool
@app.get("/report")
async def generate_report():
    result = await to_thread(generate_pdf, data)
    return StreamingResponse(result)

# Response caching
from fastapi_cache import FastAPICache
from fastapi_cache.decorator import cache
@cache(expire=60)
@app.get("/static-data")
async def get_static():
    return {"version": "1.0", "features": [...]}
```

### Go/Gin Optimization
```go
// Use sync.Pool for temporary objects
var bufPool = sync.Pool{
  New: func() interface{} { return new(bytes.Buffer) },
}

// Pre-allocate slices
data := make([]Item, 0, expectedSize)

// Use streaming for large responses
func(c *gin.Context) {
  c.Stream(func(w io.Writer) bool {
    for item := range items {
      w.Write(item.JSON())
    }
    return false
  })
}
```

## Database Performance

### Connection Pool Sizing
```
Formula: connections = (cores * 2) + effective_spindle_count
Web app: 20-30 connections per instance
Background jobs: 5-10 connections per worker
Queue worker: 2-5 connections per worker
```

### Query Optimization
```sql
-- Use index-only scans (covering indexes)
CREATE INDEX idx_users_email_include ON users(email) INCLUDE (name, avatar_url);

-- Avoid SELECT *
SELECT id, name, email FROM users WHERE id = 123;

-- Use EXISTS instead of COUNT for existence checks
-- ❌ Slow: IF (SELECT COUNT(*) FROM orders WHERE user_id = 123) > 0
-- ✅ Fast: IF EXISTS (SELECT 1 FROM orders WHERE user_id = 123)

-- Batch operations
-- ❌ Slow: for user in users: INSERT INTO logs VALUES (user.id)
-- ✅ Fast: INSERT INTO logs VALUES (1), (2), (3), (4)
```

## Network Performance

### HTTP/2 & HTTP/3
```
HTTP/2: Multiplexing, server push, header compression
HTTP/3: QUIC (UDP), faster handshake, better mobile performance
```

### CDN Strategy
```yaml
Static assets (images, JS, CSS): CDN with long TTL (1 year, immutable)
API responses: CDN with short TTL (60s) or no cache for dynamic
HTML pages: CDN with revalidation (ETag)
```

### Performance Headers
```nginx
# Compression
gzip on; gzip_types text/css application/javascript image/svg+xml;
# Brotli (better than gzip)
brotli on; brotli_types text/css application/javascript;

# Caching
location /static/ {
  expires 1y;
  add_header Cache-Control "public, immutable";
}

# Preload critical resources
add_header Link "</styles/main.css>; rel=preload; as=style";
```

## Performance Monitoring

### APM Setup
```typescript
// OpenTelemetry
import { NodeSDK } from '@opentelemetry/sdk-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';

const sdk = new NodeSDK({
  traceExporter: new OTLPTraceExporter({ url: 'http://localhost:4318/v1/traces' }),
  serviceName: 'my-service',
});
sdk.start();
```

### Profiling Tools
| Tool | Use Case |
|------|----------|
| Chrome DevTools | Frontend performance |
| Lighthouse | Web vitals audit |
| Sentry | Error tracking + performance |
| Datadog | Full APM + traces |
| clinic.js | Node.js profiling |
| py-spy | Python profiling |
| pprof | Go profiling |
| perf | Linux profiling |
