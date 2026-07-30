---
name: auth-authorization
description: Authentication and Authorization — JWT, OAuth 2.0/OIDC, SAML, RBAC/ABAC, session management, password hashing, MFA, API keys, security best practices. Use when implementing authentication or authorization systems.
---

# Authentication & Authorization Skill

## Authentication Methods

| Method | Use Case | Security Level |
|--------|----------|---------------|
| **Session-based** | Server-rendered apps | High (HTTP-only cookies) |
| **JWT** | SPA, mobile, API auth | Medium (stateless) |
| **OAuth 2.0** | Third-party auth (Google, GitHub) | High |
| **API Keys** | Service-to-service | Medium |
| **WebAuthn/Passkeys** | Passwordless auth | Very High |
| **Magic Links** | Email-based login | Medium |

## JWT (JSON Web Tokens)

### Best Practices
```typescript
import jwt from 'jsonwebtoken';

// Signing (use RS256 or ES256, NOT HS256 for microservices)
const privateKey = fs.readFileSync('./private.pem');
const token = jwt.sign(
  {
    sub: user.id,
    role: user.role,
    permissions: user.permissions,
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 900, // 15 min
    jti: crypto.randomUUID(), // Unique token ID
    iss: 'https://auth.example.com',
    aud: 'https://api.example.com',
  },
  privateKey,
  { algorithm: 'RS256' }
);

// Verify
const publicKey = fs.readFileSync('./public.pem');
try {
  const decoded = jwt.verify(token, publicKey, {
    algorithms: ['RS256'],
    issuer: 'https://auth.example.com',
    audience: 'https://api.example.com',
  });
} catch (err) {
  // Token expired (TokenExpiredError), invalid signature (JsonWebTokenError)
}

// Refresh Token (long-lived, stored securely)
const refreshToken = crypto.randomUUID();
await redis.set(`refresh:${refreshToken}`, user.id, 'EX', 7 * 86400); // 7 days
```

### JWT Structure
```
Header:  { "alg": "RS256", "typ": "JWT", "kid": "key-v1" }
Payload: { "sub": "user_123", "role": "admin", "permissions": ["read:users", "write:users"] }
Signature: RS256(base64(header) + "." + base64(payload), privateKey)
```

## OAuth 2.0 & OpenID Connect

### Flows
| Flow | Use Case | Security |
|------|----------|----------|
| **Authorization Code + PKCE** | SPA, mobile apps | ✅ Best |
| **Authorization Code** | Server-side apps | ✅ Good |
| **Client Credentials** | Service-to-service | ✅ Good |
| **Device Code** | CLI, smart TVs, IoT | ⚠️ Medium |
| **Implicit (deprecated)** | ❌ Do not use | ❌ Insecure |

### PKCE Flow
```typescript
// 1. Generate code verifier + challenge
const codeVerifier = base64url(crypto.randomBytes(32));
const codeChallenge = base64url(sha256(codeVerifier));

// 2. Redirect to auth server
window.location.href = `https://auth.example.com/authorize?
  response_type=code&client_id=myapp&redirect_uri=${callbackUrl}
  &code_challenge=${codeChallenge}&code_challenge_method=S256
  &scope=openid%20profile%20email&state=${state}`;

// 3. Exchange code for tokens (server-side)
const response = await fetch('https://auth.example.com/token', {
  method: 'POST',
  body: JSON.stringify({
    grant_type: 'authorization_code',
    code: receivedCode,
    code_verifier: codeVerifier, // Original verifier
    redirect_uri: callbackUrl,
    client_id: 'myapp',
  }),
});
```

## Authorization (RBAC/ABAC)

### Role-Based Access Control (RBAC)
```typescript
// Simple RBAC
const roles = {
  admin:   { can: ['read:*', 'write:*', 'delete:*', 'admin:*'] },
  editor:  { can: ['read:*', 'write:*'] },
  viewer:  { can: ['read:*'] },
};

function authorize(user: User, action: string, resource: string): boolean {
  const role = roles[user.role];
  if (!role) return false;
  return role.can.some(pattern => matchPattern(pattern, `${action}:${resource}`));
}

// Match patterns like 'read:*', 'write:users', 'admin:*'
function matchPattern(pattern: string, target: string): boolean {
  const regex = new RegExp('^' + pattern.replace(/\*/g, '.*') + '$');
  return regex.test(target);
}
```

### Attribute-Based Access Control (ABAC)
```typescript
// Fine-grained: "Managers can edit documents they created in their department"
// Policy: subject.role == "manager" AND resource.owner == subject.id AND resource.department == subject.department

function checkAbac(subject: User, action: string, resource: any): boolean {
  // Policies defined in a policy engine (OPA/Casbin)
  return policyEngine.evaluate({
    subject: { id: subject.id, role: subject.role, department: subject.department },
    action,
    resource: { type: resource.type, owner: resource.ownerId, department: resource.department },
    context: { time: new Date(), ip: subject.ip },
  });
}
```

### Casbin (Policy Engine)
```yaml
# model.conf
[request_definition]
r = sub, obj, act
[policy_definition]
p = sub, obj, act
[matchers]
m = r.sub == p.sub && keyMatch(r.obj, p.obj) && regexMatch(r.act, p.act)

# policy.csv
p, alice, /api/users/*, GET
p, bob, /api/users/:id, (GET)|(POST)
p, admin, *, *
```

## Session Management

### Secure Session Storage
```typescript
// Express session with Redis
import session from 'express-session';
import RedisStore from 'connect-redis';

app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: process.env.SESSION_SECRET,
  name: '__Secure-sessionId', // __Secure- prefix for HTTPS-only cookies
  cookie: {
    httpOnly: true,
    secure: true,   // HTTPS only
    sameSite: 'strict',
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
  },
  resave: false,
  saveUninitialized: false,
}));
```

## Password Hashing
```typescript
// bcrypt (recommended)
import bcrypt from 'bcrypt';
const hash = await bcrypt.hash(password, 12); // 12 rounds (~250ms)
const match = await bcrypt.compare(password, hash);

// argon2 (winner of PHC, more resistant to GPU)
import * as argon2 from 'argon2';
const hash = await argon2.hash(password, { type: argon2.argon2id, timeCost: 3, memoryCost: 65536 });
const match = await argon2.verify(hash, password);
```

## Multi-Factor Authentication (MFA)

### TOTP (Authenticator App)
```typescript
import { authenticator } from 'otplib';

// Setup
const secret = authenticator.generateSecret();
const otpauth = authenticator.keyuri(user.email, 'MyApp', secret);
// Show QR code: https://api.qrserver.com/v1/create-qr-code/?data=${encodeURIComponent(otpauth)}

// Verify
const isValid = authenticator.check(token, secret);
```

## Security Checklist
- [ ] Passwords hashed with bcrypt/argon2 (not MD5, SHA1)
- [ ] JWT signed with RS256 (not HS256 for services), short expiry (15 min)
- [ ] Refresh tokens stored securely, rotation on use
- [ ] Rate limiting on login (5 attempts → 15 min lockout)
- [ ] MFA for admin accounts
- [ ] Session HTTP-only, Secure, SameSite cookies
- [ ] CORS whitelist (not `*`)
- [ ] CSRF protection (Double Submit Cookie, SameSite)
- [ ] Input validation at every boundary
- [ ] SQL injection prevention (parameterized queries)
- [ ] API keys rotation every 90 days
- [ ] Audit logging for auth events (login, logout, permission change)
