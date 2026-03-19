---
name: secret-scanner
description: Scans source code, config files, and environment definitions for exposed secrets, API keys, tokens, and hardcoded credentials.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Secret Scanner

## Objective

Detect hardcoded credentials, API keys, tokens, passwords, and sensitive configuration values that should never appear in source code or version-controlled files.

## Workflow

**Step 1 — Enumerate scan targets**
Identify all files to scan:
- Source code files (*.js, *.ts, *.py, *.go, *.java, *.rb, *.php, *.cs)
- Configuration files (*.env, *.yaml, *.yml, *.json, *.toml, *.ini, *.conf)
- Infrastructure files (Dockerfile, docker-compose.yml, *.tf, *.tfvars)
- CI/CD pipeline definitions (.github/workflows/*.yml, .gitlab-ci.yml, Jenkinsfile)
- Shell scripts (*.sh, *.bash)
- Documentation and notes (*.md, *.txt) if present in repo

**Step 2 — Apply detection patterns**
Scan each file for the following secret patterns:

*High-confidence patterns (direct matches):*
- Hardcoded passwords: `password\s*=\s*["'][^"']{6,}["']`
- API key assignments: `api_key\s*=\s*["'][A-Za-z0-9_\-]{16,}["']`
- Token assignments: `token\s*=\s*["'][A-Za-z0-9_\-\.]{20,}["']`
- AWS credentials: `AKIA[0-9A-Z]{16}`, `aws_secret_access_key\s*=\s*["'][^"']+["']`
- Private keys: `-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----`
- Database connection strings with credentials: `(mysql|postgres|mongodb|redis)://[^:]+:[^@]+@`
- JWT secrets: `jwt_secret\s*=\s*["'][^"']+["']`
- OAuth secrets: `client_secret\s*=\s*["'][^"']+["']`
- Generic secrets: `secret\s*=\s*["'][^"']{8,}["']`
- Bearer tokens in code: `Bearer\s+[A-Za-z0-9\-_\.]{20,}`

*Medium-confidence patterns (review required):*
- Base64-encoded strings in assignments (length > 32): may be encoded credentials
- Hexadecimal strings in credential fields (length > 24): may be hashed passwords or tokens
- Variables named `*_SECRET`, `*_PASSWORD`, `*_TOKEN`, `*_KEY` with non-empty values

**Step 3 — Check .gitignore and .env handling**
- Verify `.env` files are listed in `.gitignore`
- Detect `.env.example` vs `.env` pattern compliance
- Flag `.env` files committed to the repository
- Check for `secrets.*` files in version control

**Step 4 — Analyze Docker and CI/CD configurations**
- Check `docker-compose.yml` for plaintext secrets in `environment:` sections
- Check CI/CD pipeline files for hardcoded secrets in `env:` blocks
- Detect `--build-arg` usage with sensitive values
- Flag inline secrets in `RUN` commands within Dockerfiles

**Step 5 — Classify and deduplicate findings**
For each detected secret:
- Assign severity: CRITICAL (private keys, active credentials), HIGH (API keys, tokens), MEDIUM (potential secrets needing review)
- Record file path and line number
- Redact the actual value in output (show first 4 chars + `****`)
- Identify whether the secret appears in multiple files (duplication risk)

**Step 6 — Generate findings list**
Produce structured output for each finding.

## Output Format

```json
{
  "skill": "secret-scanner",
  "summary": {
    "total_files_scanned": 0,
    "total_findings": 0,
    "critical": 0,
    "high": 0,
    "medium": 0
  },
  "findings": [
    {
      "id": "SEC-001",
      "severity": "CRITICAL|HIGH|MEDIUM",
      "type": "hardcoded_password|api_key|private_key|token|connection_string|oauth_secret|jwt_secret|generic_secret",
      "file": "relative/path/to/file",
      "line": 42,
      "variable_name": "DATABASE_PASSWORD",
      "redacted_value": "mypa****",
      "pattern_matched": "password\\s*=\\s*[\"'][^\"']+[\"']",
      "context": "One line of surrounding code with the value redacted",
      "remediation": "Move to environment variable. Reference via process.env.DATABASE_PASSWORD. Add to .gitignore."
    }
  ],
  "gitignore_issues": [
    {
      "issue": ".env file committed to repository",
      "file": ".env",
      "remediation": "Add .env to .gitignore. Rotate all exposed credentials immediately."
    }
  ]
}
```
