---
name: project-plan-compiler
description: Compiles all planning skill outputs into a final, human-readable project development plan with executive summary, full timeline, task list, risk register, and team assignments.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Project Plan Compiler

## Objective

Aggregate and format all outputs from the planning skills into a single, industry-standard project development plan document that a solo developer, team lead, or engineering manager can act on immediately.

## Workflow

**Step 1 — Collect all planning skill outputs**
Ingest structured outputs from:
- `scope-analyzer` — deliverables, constraints, integrations
- `complexity-estimator` — complexity scores and T-shirt sizes
- `task-dependency-mapper` — dependencies, critical path, tiers
- `effort-estimator` — hours per task (best/expected/worst)
- `risk-planner` — risk register, contingency buffers
- `milestone-generator` — daily/weekly/monthly schedule
- `team-capacity-planner` — assignments, workstreams, bottlenecks

**Step 2 — Validate internal consistency**
Check that:
- Total hours in timeline matches effort estimates + risk buffers
- All deliverables from scope appear in the schedule
- No tasks are scheduled before their dependencies complete
- No team member is allocated more than 120% in any week

**Step 3 — Generate executive summary**
Produce a 5-line summary covering:
- Project name and type
- Total scope (number of deliverables)
- Estimated duration and team size
- Top 3 risks
- Confidence level in the estimate

**Step 4 — Format full plan document**
Structure the complete plan as a readable Markdown document with all sections below.

**Step 5 — Generate task tracking table**
Create a flat table of all tasks with: ID, name, owner, estimated hours, start day, end day, dependencies, status (Not Started).

**Step 6 — Output machine-readable summary**
Also output a JSON summary for tooling integration.

## Output Format

```markdown
# Project Development Plan

**Project:** [Name]
**Plan Date:** [Date]
**Estimated Duration:** X weeks
**Team Size:** N engineers
**Confidence Level:** HIGH|MEDIUM|LOW
**Plan Version:** 1.0

---

## Executive Summary

[Project name] is a [type] application comprising [N] deliverables across [categories].

**Estimated effort:** X hours (expected) / Y hours (worst case)
**Timeline:** X weeks with a team of N engineers
**Top risks:** [Risk 1], [Risk 2], [Risk 3]
**Confidence:** MEDIUM — estimate assumes [key assumption]

---

## Scope Overview

### Deliverables (N total)

| ID | Deliverable | Size | Hours (Expected) | Owner |
|----|-------------|------|-----------------|-------|
| DEL-001 | User Auth System | S | 29h | ENG-001 |

### Out of Scope
- [Item 1]
- [Item 2]

### Key Integrations
- [Integration 1] — [complexity]

---

## Timeline

### Month 1 — [Phase Name]

#### Week 1 — [Milestone Name]
**Milestone:** [Clear testable criterion]
**Critical Path:** YES/NO

| Day | Tasks | Hours | Owner |
|-----|-------|-------|-------|
| 1 | [task name] | 6h | ENG-001 |
| 2 | [task name] | 6h | ENG-001 |

**Week End State:** [What is true when this week is complete]

#### Week 2 — [Milestone Name]
...

### Month 2 — [Phase Name]
...

---

## Task List

| ID | Task | Owner | Est Hours | Start | End | Depends On | Status |
|----|------|-------|-----------|-------|-----|-----------|--------|
| DEL-001 | User Auth | ENG-001 | 29h | Day 1 | Day 5 | — | Not Started |

---

## Risk Register

| ID | Risk | Probability | Impact | Mitigation | Buffer |
|----|------|------------|--------|-----------|--------|
| RISK-001 | Stripe approval delay | MEDIUM | HIGH | Request keys Day 1 | +8h |

---

## Team & Workstreams

### Workstream 1: [Name]
Owner: [ENG-001]
Tasks: [list]

---

## Effort Summary

| Category | Best Case | Expected | Worst Case |
|----------|-----------|---------|-----------|
| Development | Xh | Xh | Xh |
| Testing | Xh | Xh | Xh |
| DevOps | Xh | Xh | Xh |
| Contingency | — | Xh | Xh |
| **Total** | **Xh** | **Xh** | **Xh** |

---

## Definition of Done

The project is complete when:
1. All deliverables pass their integration tests
2. Application is deployed to production environment
3. All P0 and P1 security findings are resolved
4. Documentation is complete and reviewed
5. Monitoring and alerting are operational
```

Also produce this JSON summary:

```json
{
  "skill": "project-plan-compiler",
  "plan_summary": {
    "project_name": "",
    "total_deliverables": 0,
    "total_expected_hours": 0,
    "total_worst_case_hours": 0,
    "total_calendar_weeks": 0,
    "team_size": 0,
    "confidence": "HIGH|MEDIUM|LOW",
    "top_risks": [],
    "critical_path_length_weeks": 0
  }
}
```
