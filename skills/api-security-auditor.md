---
name: api-security-auditor
description: Audits API security including CORS configuration, rate limiting, input validation, API key exposure, GraphQL security, and HTTP security headers.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# API Security Auditor

## Objective

Identify API-level security weaknesses including missing rate limiting, insecure CORS policies, absent input validation, insecure API key handling, and missing HTTP security headers.

## Workflow

**Step 1 — Audit CORS configuration**
Check CORS policy for all API endpoints:
- Flag `Access-Control-Allow-Origin: *` on APIs that handle sensitive data
- Check for dynamic reflection of `Origin` header without allowlist validation
- Verify `Access-Control-Allow-Credentials: true` is not combined with `Origin: *`
- Check that CORS preflight (OPTIONS) is properly handled
- Verify CORS allowlist contains only trusted domains

**Step 2 — Audit rate limiting**
Check for rate limiting on all public-facing endpoints:
- Verify login, registration, and password-reset endpoints have rate limits
- Check API endpoints have per-user and per-IP rate limits
- Verify file upload endpoints have rate limits and file size limits
- Flag absence of rate limiting on resource-intensive endpoints
- Check if rate limiting is bypassable via IP rotation or header manipulation (X-Forwarded-For spoofing)

**Step 3 — Audit input validation**
For each API endpoint:
- Verify request body schemas are validated before processing
- Check for missing type validation (string treated as number, etc.)
- Flag missing length limits on string inputs
- Verify array/object size limits are enforced (ReDoS and DoS risk)
- Check file upload validation: type, size, content-type verification
- Verify enum fields are validated against allowed values
- Check for prototype pollution via JSON parsing

**Step 4 — Audit HTTP security headers**
Verify the following headers are present on all responses:
- `Content-Security-Policy` — appropriate directives set
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY` or `SAMEORIGIN`
- `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy` — appropriate restrictions
- `Cache-Control: no-store` on endpoints returning sensitive data
- Flag `X-Powered-By` or `Server` headers revealing framework/version info

**Step 5 — Audit API key handling**
- Check API keys are passed via headers, not URL query parameters (logs risk)
- Verify API keys have appropriate scoping (not omnipotent keys)
- Check for API key rotation mechanism
- Verify API keys are not logged in application logs
- Flag hardcoded API keys in client-side code

**Step 6 — Audit GraphQL security**
If GraphQL is present:
- Check introspection is disabled in production
- Verify query depth limiting is configured
- Check query complexity limiting is configured
- Verify field-level authorization (not just resolver-level)
- Flag batching attacks: unlimited query batching

**Step 7 — Audit error handling**
- Verify error responses do not expose stack traces in production
- Check that 500 errors return generic messages, not internal details
- Verify database errors are not propagated to API responses
- Flag verbose error messages that reveal system architecture

## Output Format

```json
{
  "skill": "api-security-auditor",
  "summary": {
    "endpoints_analyzed": 0,
    "total_findings": 0,
    "cors_issues": 0,
    "rate_limiting_missing": 0,
    "validation_missing": 0,
    "headers_missing": 0
  },
  "findings": [
    {
      "id": "API-001",
      "severity": "HIGH",
      "category": "cors_misconfiguration",
      "file": "src/app.js",
      "line": 8,
      "description": "CORS allows all origins with credentials enabled",
      "config_snippet": "cors({ origin: '*', credentials: true })",
      "attack_scenario": "CSRF attack from any website can make authenticated API requests on behalf of logged-in user",
      "remediation": "Set specific allowed origins: cors({ origin: ['https://yourdomain.com'], credentials: true })"
    }
  ],
  "missing_headers": [
    {
      "header": "Content-Security-Policy",
      "severity": "HIGH",
      "remediation": "Add CSP header: Content-Security-Policy: default-src 'self'"
    }
  ]
}
```
