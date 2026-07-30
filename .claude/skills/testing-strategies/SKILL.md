---
name: testing-strategies
description: Testing Strategies — unit tests, integration tests, E2E testing, contract testing, visual regression, property-based testing, mutation testing, test design patterns, CI/CD integration. Use when designing test strategies or writing comprehensive tests.
---

# Testing Strategies Skill

## Test Pyramid (Practical)
```
         ╱╲
        ╱ E2E ╲           ~5% — Critical user journeys
       ╱────────╲
      ╱ Integration ╲     ~15% — API, DB, external services
     ╱────────────────╲
    ╱    Unit Tests      ╲  ~80% — Isolated functions, components
   ╱────────────────────────╲
```

## Unit Testing

### AAA Pattern
```typescript
// Arrange-Act-Assert
describe('UserService.register', () => {
  it('should create user and send welcome email', async () => {
    // Arrange
    const emailService = { sendWelcome: vi.fn() };
    const repo = { findByEmail: vi.fn().mockResolvedValue(null), save: vi.fn() };
    const service = new UserService(repo, emailService);

    // Act
    const user = await service.register({ email: 'test@test.com', name: 'Test' });

    // Assert
    expect(user.email).toBe('test@test.com');
    expect(repo.save).toHaveBeenCalledWith(expect.objectContaining({ email: 'test@test.com' }));
    expect(emailService.sendWelcome).toHaveBeenCalledWith(user.id);
  });
});
```

### Test Doubles Guide
| Type | Description | When to Use |
|------|-------------|-------------|
| **Dummy** | Passed but not used | Filling parameter lists |
| **Fake** | Working implementation (in-memory DB) | Slower tests but more confidence |
| **Stub** | Returns canned answers | When you need a specific response |
| **Spy** | Records calls made | Verifying interactions |
| **Mock** | Pre-programmed with expectations | Behavior verification |

### F.I.R.S.T Principles
- **Fast**: Tests should run quickly (< 100ms per test)
- **Isolated**: No shared state, independent order
- **Repeatable**: Same result every time
- **Self-validating**: Pass/fail, no manual check
- **Timely**: Written before or alongside production code

## Integration Testing

### Database Integration (Testcontainers)
```typescript
import { PostgreSqlContainer } from '@testcontainers/postgresql';

describe('UserRepository', () => {
  let container: StartedPostgreSqlContainer;
  let pool: Pool;

  beforeAll(async () => {
    container = await new PostgreSqlContainer('postgres:16-alpine')
      .withDatabase('testdb')
      .start();
    pool = new Pool({ connectionString: container.getConnectionUri() });
    await runMigrations(pool);
  }, 30000);

  afterAll(async () => {
    await pool.end();
    await container.stop();
  });

  it('should persist and retrieve user', async () => {
    const repo = new UserRepository(pool);
    const user = await repo.create({ email: 'test@test.com' });
    expect(user.id).toBeDefined();

    const found = await repo.findById(user.id);
    expect(found.email).toBe('test@test.com');
  });
});
```

### API Integration (Supertest)
```typescript
import request from 'supertest';
import app from '../app';

describe('POST /api/auth/login', () => {
  it('should return 200 with token for valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'admin@test.com', password: 'password123' })
      .expect(200);

    expect(res.body).toHaveProperty('token');
    expect(res.body.user.email).toBe('admin@test.com');
  });

  it('should return 401 for invalid password', async () => {
    await request(app)
      .post('/api/auth/login')
      .send({ email: 'admin@test.com', password: 'wrong' })
      .expect(401);
  });
});
```

## E2E Testing (Playwright)

### Page Object Model
```typescript
class LoginPage {
  constructor(private page: Page) {}

  async goto() { await this.page.goto('/login'); }
  async fillEmail(email: string) { await this.page.fill('[data-testid="email"]', email); }
  async fillPassword(password: string) { await this.page.fill('[data-testid="password"]', password); }
  async submit() { await this.page.click('[data-testid="login-button"]'); }
  async getErrorMessage() { return this.page.textContent('[data-testid="error"]'); }
}

test('successful login', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.fillEmail('user@test.com');
  await loginPage.fillPassword('correct-password');
  await loginPage.submit();
  await expect(page).toHaveURL('/dashboard');
});
```

### API Mocking (MSW)
```typescript
import { http, HttpResponse } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  http.get('https://api.example.com/users/:id', ({ params }) => {
    return HttpResponse.json({ id: params.id, name: 'Test User' });
  }),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

## Contract Testing (Pact)
```typescript
// Provider
await provider.verify({
  state: 'user exists',
  uponReceiving: 'a request for user',
  withRequest: { method: 'GET', path: '/users/123' },
  willRespondWith: { status: 200, body: { id: '123', name: 'Test' } },
});

// Consumer
await pact.addInteraction({
  state: 'user exists',
  uponReceiving: 'get user by id',
  withRequest: { method: 'GET', path: '/users/123' },
  willRespondWith: { status: 200, headers: { 'Content-Type': 'application/json' } },
});
```

## Performance Testing (k6)
```javascript
import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const latency = new Trend('latency_ms');

export const options = {
  stages: [
    { duration: '2m', target: 50 },    // Ramp up
    { duration: '5m', target: 50 },    // Stay
    { duration: '2m', target: 100 },   // Spike
    { duration: '2m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    errors: ['rate<0.01'],
  },
};

export default function () {
  group('user API', () => {
    const res = http.get('https://api.example.com/users');
    latency.add(res.timings.duration);
    errorRate.add(res.status !== 200);
    check(res, { 'status 200': (r) => r.status === 200 });
  });
  sleep(1);
}
```

## Visual Regression Testing
```typescript
// Playwright visual comparison
test('homepage matches snapshot', async ({ page }) => {
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  await expect(page).toHaveScreenshot('homepage.png', {
    maxDiffPixelRatio: 0.01,
    threshold: 0.2,
  });
});
```

## Mutation Testing (Stryker)
```bash
npx stryker run
# Killed mutants: 385/420 = 91.7% mutation score
# Goal: > 80% mutation score
```

## Coverage Goals
| Type | Line Coverage | Branch Coverage | Mutation Score |
|------|-------------|----------------|----------------|
| Core domain | 100% | 100% | 95%+ |
| Services | 95%+ | 90%+ | 90%+ |
| Components | 90%+ | 85%+ | 85%+ |
| Controllers/API | 90%+ | 80%+ | 80%+ |
| Configuration | 60%+ | 50%+ | 50%+ |
