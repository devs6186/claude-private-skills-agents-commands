---
name: attack-surface-mapper
description: Maps the application's complete attack surface, identifies entry points, trust boundaries, and simulates attack scenarios based on discovered vulnerabilities.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Attack Surface Mapper

## Objective

Produce a complete map of the application's attack surface, including all external-facing entry points, trust boundaries, data flows, and compound attack chains derived from combining individual vulnerabilities.

## Workflow

**Step 1 — Map all external entry points**
Enumerate every point where external data enters the system:
- HTTP endpoints (REST, GraphQL, WebSocket, gRPC)
- File upload handlers
- Email/webhook receivers
- CLI arguments and environment variables
- Third-party OAuth callbacks
- Scheduled job inputs
- Message queue consumers (Kafka, RabbitMQ, SQS)
- Database stored procedure inputs

For each entry point record:
- Input type (user-controlled, authenticated, unauthenticated)
- Authentication requirement
- Data type accepted
- Known downstream consumers

**Step 2 — Identify trust boundaries**
Map transitions between trust zones:
- Public internet → application layer
- Application layer → database layer
- Application layer → third-party services
- User roles: anonymous → authenticated → admin → superadmin
- Inter-service communications in microservices

Flag locations where trust escalation occurs without verification.

**Step 3 — Map data flows for sensitive data**
Trace how sensitive data moves through the system:
- User credentials (registration → login → session)
- Payment data flows
- PII data collection to storage to retrieval
- Token generation and validation paths
- Admin operation flows

**Step 4 — Construct attack chains**
Using findings from all other security skills (injections, auth issues, access control), combine individual vulnerabilities into multi-step attack scenarios:

For each combination:
- Attack chain name
- Starting precondition (unauthenticated, low-privilege user, etc.)
- Step-by-step exploitation path
- End state (data accessed, account compromised, RCE achieved, etc.)
- Combined CVSS score (higher than individual vulnerabilities)

Example chains to evaluate:
- SSRF → Internal service access → Credential theft → Full compromise
- IDOR → PII access → Account takeover via password reset
- SQLi → Auth bypass → Admin access → Data exfiltration
- Secrets leak → Database credentials → Direct DB access

**Step 5 — Assess overall risk exposure**
- Calculate total attack surface score based on entry points and vulnerabilities
- Identify the most critical attack paths (highest impact, lowest friction)
- Assess data breach risk: what data could be exfiltrated?
- Assess service disruption risk: what could be taken offline?
- Assess account takeover risk: which accounts could be compromised?

**Step 6 — Prioritize remediation by attack chain severity**
Order remediation recommendations by attack chain impact, not individual vulnerability severity, since chain exploitability may differ from isolated vulnerability severity.

## Output Format

```json
{
  "skill": "attack-surface-mapper",
  "attack_surface_summary": {
    "total_entry_points": 0,
    "unauthenticated_entry_points": 0,
    "authenticated_entry_points": 0,
    "trust_boundaries": 0,
    "sensitive_data_flows": 0,
    "attack_chains_identified": 0,
    "overall_risk_score": "CRITICAL|HIGH|MEDIUM|LOW"
  },
  "entry_points": [
    {
      "id": "EP-001",
      "path": "POST /api/auth/login",
      "type": "http_rest",
      "authentication_required": false,
      "input_types": ["json_body"],
      "sensitive_operations": ["credential_verification"],
      "known_vulnerabilities": ["AUTH-MISS-001"]
    }
  ],
  "attack_chains": [
    {
      "id": "CHAIN-001",
      "name": "Unauthenticated SQL Injection to Admin Account Takeover",
      "severity": "CRITICAL",
      "precondition": "unauthenticated attacker with HTTP access",
      "steps": [
        "1. Submit SQL injection payload to POST /api/auth/login username field",
        "2. Bypass authentication via ' OR '1'='1' -- payload",
        "3. Gain admin session token from response",
        "4. Access /api/admin/users to enumerate all accounts",
        "5. Export full user database including hashed passwords"
      ],
      "end_state": "Full database read, all user accounts compromised",
      "combined_severity": "CRITICAL",
      "contributing_vulnerabilities": ["INJ-001", "AUTH-MISS-001"],
      "remediation_priority": 1
    }
  ],
  "sensitive_data_at_risk": [
    {
      "data_type": "user_credentials",
      "storage_location": "users table",
      "accessible_via_chains": ["CHAIN-001"],
      "estimated_records_at_risk": "all users"
    }
  ]
}
```
