---
name: dependency-audit
description: Scans project dependencies for known CVEs, outdated packages, and insecure version ranges.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Dependency Audit

## Objective

Identify third-party dependencies with known security vulnerabilities (CVEs), outdated packages, and overly permissive version constraints that could introduce supply chain risk.

## Workflow

**Step 1 — Detect package managers and manifest files**
Identify all dependency manifests present:
- Node.js: `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
- Python: `requirements.txt`, `Pipfile`, `Pipfile.lock`, `pyproject.toml`, `setup.py`
- Go: `go.mod`, `go.sum`
- Java: `pom.xml`, `build.gradle`, `build.gradle.kts`
- Ruby: `Gemfile`, `Gemfile.lock`
- PHP: `composer.json`, `composer.lock`
- Rust: `Cargo.toml`, `Cargo.lock`
- .NET: `*.csproj`, `packages.config`, `nuget.config`

**Step 2 — Extract dependency list with versions**
For each manifest file:
- Parse all direct dependencies with declared version constraints
- Parse all transitive dependencies from lock files where available
- Separate production dependencies from development dependencies
- Flag packages with no version pin (e.g., `*`, `latest`, `>=0.0.0`)

**Step 3 — Check for known vulnerable versions**
Cross-reference each dependency against known vulnerability databases:
- Reference NIST NVD CVE data patterns for common packages
- Check GHSA (GitHub Security Advisory) known vulnerable version ranges
- Flag packages with documented CVEs in declared version ranges
- Prioritize: RCE > auth bypass > data exposure > DoS > info disclosure

Known high-priority vulnerability patterns to check:
- `log4j` versions < 2.17.1 → Log4Shell (CVE-2021-44228) CRITICAL
- `lodash` versions < 4.17.21 → Prototype Pollution HIGH
- `axios` versions < 1.6.0 → SSRF, ReDoS vulnerabilities HIGH
- `express` versions < 4.19.2 → Open Redirect HIGH
- `jsonwebtoken` versions < 9.0.0 → Algorithm Confusion HIGH
- `serialize-javascript` versions < 3.1.0 → XSS HIGH
- `minimist` versions < 1.2.6 → Prototype Pollution MEDIUM
- `node-fetch` versions < 2.6.7 → ReDoS MEDIUM
- `django` versions < 4.2.x → SQL injection in specific contexts HIGH
- `flask` versions < 2.2.5 → various fixes MEDIUM
- `requests` Python < 2.31.0 → credential exposure MEDIUM
- `pillow` < 10.0.1 → buffer overflow HIGH
- `pyyaml` < 6.0 → arbitrary code execution via YAML CRITICAL

**Step 4 — Detect outdated packages**
For each dependency:
- Identify if the package is more than 2 major versions behind the latest stable
- Flag packages with no updates in > 24 months (abandoned risk)
- Flag packages with < 100 weekly downloads (low maintenance signal)

**Step 5 — Detect insecure version constraints**
Flag version constraints that allow insecure ranges:
- Unpinned: `*`, `latest`, `x`
- Overly broad: `>=1.0.0`, `>0.0.0`
- Missing lock files (enables supply chain attacks)

**Step 6 — Detect suspicious packages**
Flag potential typosquatting and malicious packages:
- Packages with names very similar to popular packages (e.g., `lodahs`, `expres`)
- Packages with install scripts that execute shell commands
- Packages with abnormally high permissions requirements

**Step 7 — Compile findings**
Rank findings by CVSS score where available, then by severity category.

## Output Format

```json
{
  "skill": "dependency-audit",
  "summary": {
    "total_dependencies": 0,
    "direct": 0,
    "transitive": 0,
    "vulnerable": 0,
    "outdated": 0,
    "unpinned": 0,
    "critical_cves": 0,
    "high_cves": 0,
    "medium_cves": 0,
    "low_cves": 0
  },
  "vulnerabilities": [
    {
      "id": "DEP-001",
      "package": "lodash",
      "ecosystem": "npm",
      "installed_version": "4.17.15",
      "severity": "HIGH",
      "cve_ids": ["CVE-2021-23337", "CVE-2020-28500"],
      "vulnerability_type": "prototype_pollution",
      "cvss_score": 7.2,
      "affected_range": "<4.17.21",
      "safe_version": "4.17.21",
      "is_direct_dependency": true,
      "manifest_file": "package.json",
      "remediation": "Upgrade lodash to >=4.17.21 in package.json. Run: npm install lodash@4.17.21"
    }
  ],
  "outdated_packages": [
    {
      "id": "DEP-OUT-001",
      "package": "express",
      "installed_version": "3.21.0",
      "latest_version": "4.19.2",
      "major_versions_behind": 1,
      "last_updated": "2015-01-01",
      "risk": "MEDIUM",
      "remediation": "Upgrade to express@4.19.2. Review breaking changes in migration guide."
    }
  ],
  "insecure_constraints": [
    {
      "package": "some-package",
      "constraint": "*",
      "risk": "supply_chain_attack",
      "remediation": "Pin to specific version. Add package-lock.json to version control."
    }
  ]
}
```
