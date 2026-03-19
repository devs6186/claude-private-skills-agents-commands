---
name: access-control-auditor
description: Audits authorization logic, RBAC implementation, and access control patterns to detect broken access control, privilege escalation, and IDOR vulnerabilities.
metadata:
  author: dev-os
  version: 1.0
  category: security
---

# Access Control Auditor

## Objective

Identify broken access control patterns including IDOR (Insecure Direct Object References), missing authorization checks, privilege escalation paths, and insecure role-based access control.

## Workflow

**Step 1 — Map resource access patterns**
Identify all protected resources:
- API endpoints with resource identifiers (e.g., `/api/users/:id`, `/api/orders/:orderId`)
- File download/upload endpoints
- Admin-only routes and operations
- Inter-service API calls
- Database query patterns that filter by user identity

**Step 2 — Detect IDOR vulnerabilities**
For each endpoint with a resource identifier:
- Check if the handler verifies the requesting user owns or has permission for the resource
- Flag direct use of user-supplied IDs in database queries without ownership verification:
  - `db.findById(req.params.id)` without `WHERE user_id = currentUser.id`
  - `Order.findOne({ _id: req.params.orderId })` without user association check
- Check for sequential or predictable resource IDs that enable enumeration

**Step 3 — Audit authorization middleware**
- Identify authorization middleware and verify it's applied to all protected routes
- Check for routes that authenticate users but don't check authorization level
- Detect routes where role checks are performed but can be bypassed via parameter manipulation
- Verify admin routes require admin role (not just any authenticated user)
- Check for mass assignment vulnerabilities where users can set their own role

**Step 4 — Detect privilege escalation paths**
- Find endpoints where users can modify their own profile including role/permissions fields
- Check for unprotected admin functions accessible via direct URL
- Identify JWT claims that could be tampered to elevate privileges
- Check for multi-tenant data isolation (one tenant accessing another's data)
- Look for function-level access control gaps (API endpoint exists but not visible in UI)

**Step 5 — Review RBAC implementation**
- Verify role definitions are centralized, not scattered through route handlers
- Check that role checks happen server-side, not client-side only
- Verify roles are stored securely and cannot be self-assigned
- Check for wildcard permissions that grant excessive access
- Verify least-privilege principle is applied (no over-permissioned roles)

**Step 6 — Check for forced browsing vulnerabilities**
- Identify static files or admin pages accessible without authentication
- Check for directory listing enabled on web servers
- Flag backup files or config files accessible via direct URL

## Output Format

```json
{
  "skill": "access-control-auditor",
  "summary": {
    "endpoints_analyzed": 0,
    "total_findings": 0,
    "idor_vulnerabilities": 0,
    "missing_auth_checks": 0,
    "privilege_escalation_paths": 0,
    "rbac_issues": 0
  },
  "findings": [
    {
      "id": "AUTHZ-001",
      "severity": "HIGH",
      "type": "idor",
      "file": "src/routes/orders.js",
      "line": 45,
      "endpoint": "GET /api/orders/:orderId",
      "description": "Order retrieved by ID without verifying the requesting user owns the order",
      "vulnerable_code": "const order = await Order.findById(req.params.orderId);",
      "attack_scenario": "Authenticated user enumerates order IDs to access other users' order data",
      "remediation": "const order = await Order.findOne({ _id: req.params.orderId, userId: req.user.id });"
    }
  ]
}
```
