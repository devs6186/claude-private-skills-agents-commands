---
name: infrastructure-security-auditor
description: Audits Docker configurations, docker-compose files, environment variable handling, cloud infrastructure configs, and deployment settings for security misconfigurations.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Infrastructure Security Auditor

## Objective

Detect security misconfigurations in Docker, cloud infrastructure, CI/CD pipelines, and environment management that could expose the application to attack or data breach.

## Workflow

**Step 1 — Audit Dockerfile configurations**
Examine each Dockerfile:
- Check base image is not `latest` tag (use pinned digest for reproducibility)
- Flag use of `root` user — verify `USER` instruction sets non-root user
- Check for secrets in `ENV` or `ARG` instructions
- Flag `--no-check-certificate` or `--insecure` flags in package installs
- Verify multi-stage builds are used to minimize attack surface
- Check for unnecessary packages installed (curl, wget, git in production images)
- Verify image comes from trusted registry source
- Flag `COPY . .` patterns that may include sensitive files without `.dockerignore`
- Check `.dockerignore` exists and excludes `.env`, secrets, and unnecessary files

**Step 2 — Audit docker-compose configurations**
Examine `docker-compose.yml` and variants:
- Flag plaintext secrets in `environment:` sections
- Check for secrets management via Docker secrets or env_file
- Verify networks are not set to `host` mode without justification
- Check privileged mode: `privileged: true` is a critical risk
- Flag volume mounts that expose host filesystem (e.g., `/:/host`, `/var/run/docker.sock`)
- Check for exposed ports that should not be publicly accessible
- Verify health checks are configured for all services
- Check restart policies are set

**Step 3 — Audit environment variable handling**
- Verify sensitive values are never hardcoded in source files
- Check `.env.example` exists with placeholder values (not real values)
- Verify `.env` is in `.gitignore`
- Check environment variable validation at startup (fail fast if missing)
- Flag direct logging of environment variables (secrets in logs risk)

**Step 4 — Audit cloud infrastructure configurations (IaC)**
For Terraform, CloudFormation, or Pulumi files:
- Check S3 buckets are not publicly accessible without explicit intent
- Flag security groups with `0.0.0.0/0` on sensitive ports (22, 3306, 5432, 27017, 6379)
- Verify encryption at rest is enabled for databases and storage
- Check SSL/TLS is enforced for all external-facing services
- Flag IAM policies with `*` actions or `*` resources (over-permissioned)
- Verify CloudTrail or equivalent audit logging is enabled
- Check database instances are not publicly accessible

**Step 5 — Audit CI/CD pipeline security**
For GitHub Actions, GitLab CI, Jenkins, CircleCI:
- Check secrets are stored in pipeline secret stores, not hardcoded
- Verify third-party actions are pinned to specific commit SHA (not branch)
- Flag `pull_request_target` triggers with unsafe use of `GITHUB_TOKEN`
- Check for least-privilege IAM roles in deployment pipelines
- Verify artifacts are signed and checksummed

**Step 6 — Network and TLS configuration**
- Check HTTPS enforcement (HTTP → HTTPS redirect)
- Verify TLS version ≥ 1.2 (reject TLS 1.0, 1.1)
- Check HSTS headers are configured
- Verify certificate management (auto-renewal with Let's Encrypt or equivalent)

## Output Format

```json
{
  "skill": "infrastructure-security-auditor",
  "summary": {
    "dockerfiles_scanned": 0,
    "compose_files_scanned": 0,
    "iac_files_scanned": 0,
    "total_findings": 0,
    "critical": 0,
    "high": 0,
    "medium": 0
  },
  "findings": [
    {
      "id": "INFRA-001",
      "severity": "CRITICAL",
      "category": "docker_privileged_mode",
      "file": "docker-compose.yml",
      "line": 12,
      "description": "Service running in privileged mode grants full host kernel capabilities",
      "config_snippet": "privileged: true",
      "attack_scenario": "Container escape: attacker with container access gains root on host system",
      "remediation": "Remove 'privileged: true'. Use specific capabilities: cap_add: [NET_ADMIN] if needed"
    }
  ]
}
```
