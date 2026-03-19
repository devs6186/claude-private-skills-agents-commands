---
name: auth-audit
description: Audits authentication flows, session management, JWT configuration, password handling, and MFA implementation for security weaknesses.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Auth Audit

## Objective

Identify insecure authentication patterns, weak session management, misconfigured JWT, improper password storage, and missing authentication controls.

## Workflow

**Step 1 — Map authentication mechanisms**
Identify all authentication methods in use:
- Username/password login endpoints
- JWT-based authentication (identify token creation and verification code)
- OAuth 2.0 / OpenID Connect flows
- API key authentication
- Session cookie authentication
- Multi-factor authentication (MFA/2FA) implementation
- Social login integrations

**Step 2 — Audit password handling**
Check password storage and validation:
- Verify passwords are hashed with bcrypt, argon2, scrypt, or PBKDF2
- Flag MD5, SHA1, SHA256 plain hashing without salt (insecure)
- Flag plaintext password storage
- Check password comparison uses constant-time comparison (prevents timing attacks)
- Verify minimum password length enforcement (< 8 chars is insufficient)
- Check for password complexity requirements
- Verify password reset tokens are cryptographically random (not sequential IDs)
- Check password reset token expiry (should be ≤ 1 hour)
- Flag missing account lockout after failed attempts (brute force risk)

**Step 3 — Audit JWT configuration**
Check JWT implementation:
- Verify algorithm is specified and enforced (never `"alg": "none"`)
- Flag use of symmetric secrets shorter than 256 bits
- Check for hardcoded JWT secrets in code
- Verify token expiry (`exp` claim) is set and reasonable (≤ 24h for access tokens)
- Check refresh token rotation is implemented
- Verify audience (`aud`) and issuer (`iss`) claims are validated
- Flag JWTs stored in localStorage (XSS risk; prefer HttpOnly cookies)
- Check for JWT secret in environment variables vs. hardcoded

**Step 4 — Audit session management**
Check session cookie configuration:
- Verify `HttpOnly` flag is set on session cookies
- Verify `Secure` flag is set (HTTPS only)
- Verify `SameSite=Strict` or `SameSite=Lax` is set (CSRF protection)
- Check session ID length (should be ≥ 128 bits)
- Verify session invalidation on logout
- Check session fixation protection (new session ID after login)
- Verify session timeout is configured (idle timeout ≤ 30 min for sensitive apps)

**Step 5 — Audit OAuth/OpenID Connect flows**
- Verify `state` parameter is used and validated (CSRF in OAuth)
- Check `redirect_uri` is allowlisted (open redirect risk)
- Verify PKCE is used for public clients
- Check `nonce` is validated in ID tokens

**Step 6 — Check for missing authentication**
- Identify API endpoints that should require authentication but lack middleware
- Check for routes that bypass authentication middleware
- Identify admin routes without elevated authentication requirements
- Check for debug endpoints accessible without auth (`/debug`, `/admin`, `/console`)

**Step 7 — Assess MFA implementation**
- Check if MFA is available and enforced for admin accounts
- Verify TOTP implementation uses standard algorithms (HOTP/TOTP per RFC 6238)
- Check backup codes are hashed, not stored plaintext

## Output Format

```json
{
  "skill": "auth-audit",
  "summary": {
    "auth_mechanisms_found": ["jwt", "session_cookies"],
    "total_findings": 0,
    "critical": 0,
    "high": 0,
    "medium": 0,
    "low": 0
  },
  "findings": [
    {
      "id": "AUTH-001",
      "severity": "CRITICAL",
      "category": "jwt_misconfiguration",
      "file": "src/middleware/auth.js",
      "line": 18,
      "description": "JWT algorithm not enforced — accepts 'alg: none' allowing unsigned tokens",
      "code_snippet": "jwt.verify(token, secret) // missing algorithms option",
      "attack_scenario": "Attacker strips signature and sets alg:none to bypass verification entirely",
      "remediation": "jwt.verify(token, secret, { algorithms: ['HS256'] })"
    }
  ],
  "missing_controls": [
    {
      "id": "AUTH-MISS-001",
      "severity": "HIGH",
      "control": "account_lockout",
      "description": "No account lockout after repeated failed login attempts detected",
      "affected_endpoint": "POST /api/auth/login",
      "remediation": "Implement rate limiting and lockout after 5 failed attempts within 15 minutes"
    }
  ]
}
```
