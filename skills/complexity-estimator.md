---
name: complexity-estimator
description: Estimates engineering complexity for each project deliverable using industry-standard sizing techniques, producing complexity scores and T-shirt size estimates.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Complexity Estimator

## Objective

Assess the engineering complexity of each deliverable and task from the scope analysis, producing complexity scores that inform effort estimation and timeline planning.

## Workflow

**Step 1 — Ingest scope-analyzer output**
Load the deliverables list from `scope-analyzer` output.

**Step 2 — Apply complexity dimensions**
For each deliverable, assess across 6 dimensions:

**Technical Complexity (1-5)**
- 1: Standard CRUD, well-documented library
- 2: Business logic with moderate rules
- 3: Complex algorithms, custom protocols, performance requirements
- 4: Novel architecture patterns, distributed systems coordination
- 5: Research-level, unknown territory, complex math

**Integration Complexity (1-5)**
- 1: No external integrations
- 2: Single well-documented API (REST)
- 3: Multiple APIs or one complex API (OAuth, webhooks)
- 4: Legacy system integration, undocumented APIs, real-time sync
- 5: Multi-system orchestration, protocol translation, data migration

**Data Complexity (1-5)**
- 1: Simple flat data models
- 2: Relational schema with foreign keys
- 3: Complex relationships, search indexing, caching layer
- 4: Multi-tenant data isolation, complex migrations, CQRS
- 5: Event sourcing, distributed transactions, custom storage engines

**UI/UX Complexity (1-5)**
- 1: No UI, or simple static page
- 2: Basic CRUD forms and lists
- 3: Complex interactions, real-time updates, dashboards
- 4: Rich data visualization, drag-and-drop, complex state management
- 5: Custom rendering engines, video, AR/VR

**Testing Complexity (1-5)**
- 1: Simple unit tests sufficient
- 2: Unit + integration tests
- 3: E2E tests, mock services required
- 4: Distributed system testing, chaos testing
- 5: Security testing, compliance validation, performance benchmarking

**Deployment Complexity (1-5)**
- 1: Single service, simple deployment
- 2: Multi-service, Docker Compose
- 3: Kubernetes, multi-environment pipeline
- 4: Multi-region, blue-green deployment, custom operators
- 5: Complex infrastructure automation, regulatory compliance deployment

**Step 3 — Calculate composite complexity score**
Composite = (Technical × 0.30) + (Integration × 0.20) + (Data × 0.20) + (UI × 0.15) + (Testing × 0.10) + (Deployment × 0.05)

**Step 4 — Assign T-shirt size**
Map composite score to size:
- 1.0-1.5: XS (trivial, < 4 hours)
- 1.5-2.0: S (simple, 4-16 hours)
- 2.0-2.5: M (moderate, 16-40 hours)
- 2.5-3.5: L (complex, 40-80 hours)
- 3.5-4.0: XL (very complex, 80-160 hours)
- 4.0-5.0: XXL (extreme, 160+ hours, consider decomposing)

**Step 5 — Flag decomposition candidates**
Any deliverable scoring XL or XXL should be flagged for decomposition into smaller sub-deliverables before effort estimation.

**Step 6 — Identify complexity drivers**
For each deliverable, list the top 2-3 factors driving complexity — these become risk items and focus areas.

## Output Format

```json
{
  "skill": "complexity-estimator",
  "summary": {
    "total_deliverables": 0,
    "xs_count": 0,
    "s_count": 0,
    "m_count": 0,
    "l_count": 0,
    "xl_count": 0,
    "decomposition_candidates": 0
  },
  "estimates": [
    {
      "deliverable_id": "DEL-001",
      "deliverable_name": "User Authentication System",
      "dimensions": {
        "technical": 2,
        "integration": 1,
        "data": 2,
        "ui_ux": 1,
        "testing": 2,
        "deployment": 1
      },
      "composite_score": 1.8,
      "size": "S",
      "complexity_drivers": [
        "Password reset flow with email verification",
        "Session security and JWT configuration"
      ],
      "decompose": false
    }
  ]
}
```
