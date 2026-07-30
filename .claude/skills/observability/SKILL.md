---
name: observability
description: Observability — metrics, logging, distributed tracing, monitoring, alerting, Grafana, Prometheus, OpenTelemetry, RUM, APM. Use when setting up monitoring, debugging production issues, or implementing observability.
---

# Observability Skill

## Three Pillars of Observability

| Pillar | What | Tool | Storage |
|--------|------|------|---------|
| **Metrics** | Numerical measurements over time | Prometheus | TSDB |
| **Logs** | Discrete event records | Loki/ELK | Object store |
| **Traces** | Request lifecycle across services | Jaeger/Tempo | Object store |

## Metrics (Prometheus)

### Metric Types
```yaml
# Counter: only increases (requests, errors)
http_requests_total{method="GET", endpoint="/users"} 1000

# Gauge: goes up and down (memory, connections)
memory_usage_bytes{service="api"} 524288000

# Histogram: distribution (latency)
http_request_duration_seconds_bucket{le="0.1"} 500
http_request_duration_seconds_bucket{le="0.5"} 800
http_request_duration_seconds_sum 250
http_request_duration_seconds_count 1000

# Summary: quantile approximation
rpc_duration_seconds{quantile="0.95"} 0.25
```

### RED Method (Services)
```yaml
Rate:   requests_per_second    # Throughput
Errors: error_rate             # Failed requests / total
Duration: latency_p95/p99      # Response time
```

### USE Method (Resources)
```
Utilization: % of time resource is busy
Saturation: queue length or backlog
Errors: failed operations count
```

### Instrumentation
```typescript
import { Counter, Histogram } from 'prom-client';

const httpRequests = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'endpoint', 'status'],
});

const httpDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'endpoint'],
  buckets: [0.01, 0.05, 0.1, 0.5, 1, 2, 5],
});

// Middleware
app.use((req, res, next) => {
  const end = httpDuration.startTimer({ method: req.method, endpoint: req.path });
  res.on('finish', () => {
    httpRequests.inc({ method: req.method, endpoint: req.path, status: res.statusCode });
    end();
  });
  next();
});
```

### PromQL Queries
```promql
# Error rate (last 5 minutes)
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])

# p95 latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# CPU utilization by service
avg(rate(container_cpu_usage_seconds_total[5m])) by (service)

# Memory (top 5)
topk(5, container_memory_usage_bytes)
```

### Alerting Rules
```yaml
# prometheus-rules.yaml
groups:
- name: critical
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
    for: 5m
    labels: { severity: critical, team: backend }
    annotations:
      summary: "Error rate > 5% on {{ $labels.service }}"
      runbook: "https://runbook.example.com/high-error-rate"

  - alert: LatencyHigh
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
    for: 10m
    labels: { severity: major }
```

## Logging (Structured)

### JSON Log Format
```json
{
  "level": "error",
  "message": "Database connection failed",
  "service": "user-service",
  "timestamp": "2025-07-30T10:30:00Z",
  "trace_id": "abc123def456",
  "user_id": "user_789",
  "error": { "message": "connection timeout", "stack": "..." },
  "duration_ms": 3000,
  "metadata": { "attempt": 3 }
}
```

### Log Levels
| Level | Use Case | Example |
|-------|----------|---------|
| DEBUG | Development only | Function entry/exit, variable values |
| INFO | Normal operations | Request started/completed, cron ran |
| WARN | Unexpected but handled | Rate limit approaching, retry attempt |
| ERROR | Failed operation | DB connection failed, API returned 500 |
| FATAL | Process will crash | Out of memory, config missing |

### Logging Best Practices
```typescript
// Structured logging (pino)
import pino from 'pino';
const logger = pino({ level: process.env.LOG_LEVEL || 'info' });
logger.info({ userId, action: 'login' }, 'User logged in');

// Context propagation
const childLogger = logger.child({ requestId: req.id, userId: req.user.id });
childLogger.error({ err, durationMs }, 'Payment failed');

// Never log sensitive data: passwords, tokens, PII
// Log in JSON format for machine parsing
// Use correlation IDs across services
```

## Distributed Tracing (OpenTelemetry)

```typescript
import { trace, context } from '@opentelemetry/api';
import { NodeTracerProvider } from '@opentelemetry/sdk-trace-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';

const provider = new NodeTracerProvider();
provider.addSpanProcessor(new BatchSpanProcessor(new OTLPTraceExporter()));
provider.register();

// Auto-instrument HTTP, gRPC, DB
import '@opentelemetry/instrumentation-http';
import '@opentelemetry/instrumentation-express';

// Manual instrumentation
const tracer = trace.getTracer('my-service');
async function handleRequest(req, res) {
  const span = tracer.startSpan('process-order', {
    attributes: { orderId: req.body.orderId }
  });
  return context.with(trace.setSpan(context.active(), span), async () => {
    try {
      await processOrder(req.body);
      span.setStatus({ code: SpanStatusCode.OK });
    } catch (err) {
      span.recordException(err);
      span.setStatus({ code: SpanStatusCode.ERROR, message: err.message });
    } finally {
      span.end();
    }
  });
}
```

## Real User Monitoring (RUM)

### Web Vitals
```typescript
import { onCLS, onFCP, onLCP, onTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  const body = {
    name: metric.name,
    value: metric.value,
    rating: metric.rating, // 'good' | 'needs-improvement' | 'poor'
    delta: metric.delta,
    id: metric.id,
  };
  navigator.sendBeacon('/analytics', JSON.stringify(body));
}

onCLS(sendToAnalytics);
onFCP(sendToAnalytics);
onLCP(sendToAnalytics);
onTTFB(sendToAnalytics);
```

## APM Comparison
| Tool | Metrics | Logs | Traces | RUM | Cost |
|------|---------|------|--------|-----|------|
| Datadog | ✅ | ✅ | ✅ | ✅ | $$$ |
| New Relic | ✅ | ✅ | ✅ | ✅ | $$$ |
| Grafana Stack | ✅ | ✅ (Loki) | ✅ (Tempo) | ✅ | $$ |
| Sentry | ✅ | ✅ | ✅ | ✅ | $ |
| Elastic | ✅ | ✅ | ✅ | ✅ | $$ |
| SigNoz (OSS) | ✅ | ✅ | ✅ | ❌ | Free |

## Observability Checklist
- [ ] Metrics: RED for services, USE for resources
- [ ] Logging: Structured JSON, log levels, correlation IDs
- [ ] Tracing: OpenTelemetry instrumentation, context propagation
- [ ] Alerting: SLO-based, runbooks for each alert
- [ ] Dashboards: Service overview, database, infrastructure
- [ ] RUM: Core Web Vitals tracking
- [ ] Synthetic: Playwright health checks
- [ ] On-call: Rotation, escalation policy, postmortem process
