---
name: security-impact-reviewer
description: Reviews security implications of pull request changes — checking for vulnerabilities introduced by the diff, insecure patterns, input handling issues, and auth/access regressions. Use when a PR touches security-sensitive code paths.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Security Impact Reviewer Skill

## Objective

Identify security vulnerabilities or regressions introduced specifically by the PR diff, not the entire codebase.

This is a diff-scoped security review, not a full security audit (use security-auditor-agent for that).

---

# Workflow

## Step 1 — Identify Security-Sensitive Files

Flag changed files that touch:
- Authentication and authorization code
- Session management
- Input parsing or validation
- Database queries or ORM usage
- File system operations
- Network requests (HTTP clients, socket operations)
- Cryptographic operations
- Environment variable or secret handling
- Template rendering

---

## Step 2 — Check for Injection Vulnerabilities

In the diff, look for:
- SQL string concatenation or f-string queries (should use parameterized queries)
- Shell command construction from user input (`subprocess`, `os.system`)
- Template injection in render calls
- Unsafe deserialization (`pickle`, `yaml.load` without `Loader`)
- Path traversal via user-controlled filenames

---

## Step 3 — Check Input Validation

Verify:
- All user-supplied or external data is validated before use
- Type assertions are present for data from external sources
- Integer bounds are checked where memory or resource limits matter
- Filename and path inputs are sanitized

---

## Step 4 — Check Auth and Access Control

Review:
- No authentication checks removed or bypassed in the diff
- No new endpoints or routes added without authorization checks
- No permission checks weakened by refactoring
- Session tokens are not logged or exposed

---

## Step 5 — Check Secrets and Credentials

Scan the diff for:
- Hardcoded API keys, passwords, tokens
- Credentials passed as function arguments (should be env vars)
- Secrets logged to stdout or written to files
- New `.env` or config files containing real credentials

---

## Step 6 — Check Cryptographic Patterns

If diff touches crypto:
- No MD5 or SHA1 for security purposes
- No hardcoded IVs or salts
- Random number generation uses cryptographically secure sources

---

## Step 7 — Assess Regression Risk

Compare the diff against the previous behavior:
- Were any security checks deleted without replacement?
- Did a refactor accidentally remove a guard?
- Did parameter reordering break a security invariant?

---

# Severity Classification

- **P0 (Critical)**: Active credential exposure, auth bypass, injection vulnerability
- **P1 (High)**: Input validation missing on external data, insecure crypto
- **P2 (Medium)**: Logging of sensitive data, weak default configurations
- **P3 (Low)**: Theoretical edge cases, defense-in-depth gaps

---

# Output Format

Security Impact Review:
- Security-sensitive files changed (list)
- Vulnerabilities found (per P0–P3 priority)
- Auth and access control check result
- Input validation assessment
- Secrets scan result
- Overall security verdict (Clean / Needs Attention / Blocking Issue)
