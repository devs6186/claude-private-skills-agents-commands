---
name: security-report-generator
description: Compiles all security skill outputs into a comprehensive Security Audit Report with prioritized remediation instructions formatted for the implementation-agent.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Security Report Generator

## Objective

Aggregate findings from all security audit skills into a single, structured Security Audit Report with deduplicated findings, prioritized remediation steps, and implementation-ready fix instructions.

## Workflow

**Step 1 — Collect all skill outputs**
Ingest structured JSON output from:
- `secret-scanner`
- `dependency-audit`
- `injection-detector`
- `auth-audit`
- `access-control-auditor`
- `infrastructure-security-auditor`
- `api-security-auditor`
- `attack-surface-mapper`

**Step 2 — Deduplicate findings**
- Identify findings that refer to the same root cause in multiple skill outputs
- Merge duplicate findings, keeping the most complete record
- Cross-reference attack chains with individual findings to confirm accuracy

**Step 3 — Prioritize findings**
Assign final priority using the following matrix:
- P0 (Immediate): Exploitable with no authentication, leads to RCE or full data breach
- P1 (Critical): Exploitable by authenticated users, significant data access or account takeover
- P2 (High): Exploitable under specific conditions, partial data access or functionality abuse
- P3 (Medium): Defense-in-depth issues, misconfigurations requiring specific attack conditions
- P4 (Low): Informational, best practice violations, minor exposure

**Step 4 — Generate remediation instructions**
For each P0 and P1 finding, generate:
- Precise code change required (diff-style or before/after)
- Affected files and line numbers
- Test to verify fix is effective
- Estimated effort in hours

For P2/P3 findings:
- Specific configuration changes
- Package upgrade commands
- Implementation guidance

**Step 5 — Generate implementation-agent task list**
Format P0/P1 remediations as tasks compatible with the implementation-agent:
- Each task is atomic and independently implementable
- Each task includes acceptance criteria
- Dependencies between tasks are noted

**Step 6 — Calculate security score**
Compute an overall security posture score:
- Start at 100
- Deduct: P0 = 30pts each (cap at 0), P1 = 15pts, P2 = 5pts, P3 = 2pts, P4 = 0.5pts
- Categorize: 90-100 = Strong, 70-89 = Adequate, 50-69 = Weak, <50 = Critical Risk

**Step 7 — Compile final report**
Structure the complete report as specified below.

## Output Format

```markdown
# Security Audit Report

**Application:** [app name]
**Audit Date:** [date]
**Audited By:** Dev-OS Security Auditor Agent
**Security Score:** [score]/100 — [category]
**Report Version:** 1.0

---

## Executive Summary

[2-3 sentences describing overall security posture, most critical finding, and immediate action required]

---

## Findings Summary

| Priority | Count | Categories |
|----------|-------|-----------|
| P0 Immediate | N | [list] |
| P1 Critical | N | [list] |
| P2 High | N | [list] |
| P3 Medium | N | [list] |
| P4 Low | N | [list] |

---

## Attack Surface Overview

- Entry Points: N (X unauthenticated)
- Attack Chains Identified: N
- Critical Attack Chains: [list chain names]

---

## Detailed Findings

### [FINDING-ID] — [Title]
**Priority:** P0
**Severity:** CRITICAL
**Category:** [type]
**Affected Component:** [file:line]

**Description:**
[Clear description of the vulnerability]

**Attack Scenario:**
[Step-by-step how an attacker exploits this]

**Impact:**
[What happens if exploited]

**Remediation:**
[Precise fix instructions]

```[language]
// Before (vulnerable)
[vulnerable code]

// After (secure)
[fixed code]
```

**Verification:**
[How to test the fix is effective]

**Effort Estimate:** [X hours]

---

## Implementation-Agent Task List

```json
{
  "tasks": [
    {
      "id": "FIX-001",
      "priority": "P0",
      "title": "Fix SQL injection in login endpoint",
      "finding_ids": ["INJ-001"],
      "file": "src/routes/auth.js",
      "lines_affected": [24, 31],
      "instructions": "Replace string concatenation with parameterized query",
      "before": "db.query(\"SELECT * FROM users WHERE username = '\" + username + \"'\")",
      "after": "db.query('SELECT * FROM users WHERE username = ?', [username])",
      "acceptance_criteria": "No string concatenation in SQL queries. Parameterized queries used throughout.",
      "effort_hours": 1,
      "depends_on": []
    }
  ]
}
```

---

## Recommendations

### Immediate Actions (This Sprint)
1. [Action 1]
2. [Action 2]

### Short-Term (Next 2 Weeks)
1. [Action 1]

### Long-Term Security Posture
1. [Action 1]
```
