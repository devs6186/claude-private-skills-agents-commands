---
name: task-dependency-mapper
description: Maps dependencies between tasks and deliverables, identifies the critical path, and detects dependency cycles or blockers that could delay the project.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Task Dependency Mapper

## Objective

Build a complete dependency graph of all tasks and deliverables, identify the critical path (longest dependency chain), and surface blockers that must be resolved before other work can begin.

## Workflow

**Step 1 — Ingest deliverables from scope-analyzer**
Load the full deliverables list including tech stack and integration information.

**Step 2 — Apply universal dependency rules**
Apply these standard software engineering dependency patterns:

*Foundation dependencies (must always come first):*
- Repository and project scaffolding → everything else
- Database schema and migrations → all data access layers
- Authentication system → all authenticated endpoints
- Core data models → all services that use those models
- Environment configuration → all services

*Service dependency patterns:*
- Backend API → Frontend that consumes it
- Message queue setup → producers and consumers
- CDN/storage setup → file upload features
- Email service setup → password reset, notifications
- Payment gateway integration → checkout/billing features

*Testing dependencies:*
- Unit tests can be written alongside code (no hard dependency)
- Integration tests → services they test must be functional
- E2E tests → full application stack must be functional

*Deployment dependencies:*
- CI/CD pipeline → deployment scripts must exist
- Staging environment → integration testing
- Production deployment → staging validation complete

**Step 3 — Build dependency graph**
For each task/deliverable:
- List all direct prerequisite tasks (`depends_on`)
- List all tasks that are blocked until this completes (`blocks`)
- Identify tasks with no dependencies (can start immediately — parallel work)
- Identify tasks that block many others (high-value items to prioritize)

**Step 4 — Calculate critical path**
Using the dependency graph:
- Perform topological sort of the task graph
- Calculate early start and late start times for each task
- Identify the critical path: the sequence of dependent tasks with no slack
- Calculate total project duration along the critical path

**Step 5 — Identify parallelization opportunities**
List groups of tasks that can be worked on simultaneously:
- Group tasks by dependency tier (tier 0 = no deps, tier 1 = depends on tier 0 only, etc.)
- Each tier can be worked on in parallel once all previous tier tasks complete

**Step 6 — Detect risk points**
- Flag tasks on the critical path (any delay delays the project)
- Flag tasks with many downstream dependencies (high-impact blockers)
- Flag external dependencies (third-party API access, design assets, legal approval) as risk items

## Output Format

```json
{
  "skill": "task-dependency-mapper",
  "critical_path": {
    "tasks_in_order": ["DEL-001", "DEL-003", "DEL-007", "DEL-010"],
    "total_duration_hours": 120,
    "bottleneck_task": "DEL-003"
  },
  "dependency_tiers": [
    {
      "tier": 0,
      "label": "Foundation — no prerequisites",
      "tasks": ["DEL-001", "DEL-002"],
      "can_parallelize": true
    },
    {
      "tier": 1,
      "label": "Core services — depends on Tier 0",
      "tasks": ["DEL-003", "DEL-004", "DEL-005"],
      "can_parallelize": true
    }
  ],
  "task_dependencies": [
    {
      "task_id": "DEL-003",
      "task_name": "User API endpoints",
      "depends_on": ["DEL-001", "DEL-002"],
      "blocks": ["DEL-006", "DEL-007"],
      "on_critical_path": true,
      "external_dependency": null
    }
  ],
  "risk_points": [
    {
      "task_id": "DEL-005",
      "risk": "Stripe API access requires account approval (3-5 day delay possible)",
      "mitigation": "Request Stripe API keys on day 1 of project"
    }
  ]
}
```
