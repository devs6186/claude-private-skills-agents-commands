---
name: effort-estimator
description: Produces realistic engineering effort estimates in hours for each task, incorporating complexity scores, experience level assumptions, and industry calibration data.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Effort Estimator

## Objective

Generate calibrated, realistic effort estimates in hours for each deliverable and task, accounting for engineering complexity, testing, code review, documentation, and realistic inefficiency factors.

## Workflow

**Step 1 — Ingest complexity estimates**
Load complexity scores and T-shirt sizes from `complexity-estimator` output.

**Step 2 — Apply base hour ranges by size**
Map T-shirt size to base effort range:
- XS: 2-4 hours
- S: 8-16 hours
- M: 24-40 hours
- L: 48-80 hours
- XL: 80-160 hours

**Step 3 — Apply experience level multiplier**
Adjust base hours by assumed experience level:
- Senior engineer (5+ years in tech stack): 1.0× (baseline)
- Mid-level engineer (2-5 years): 1.3×
- Junior engineer (0-2 years): 1.8×
- First time with this tech stack (any level): add 25%

Default to mid-level (1.3×) unless specified in project context.

**Step 4 — Add standard overhead components**
For each task, add overhead proportional to base effort:

| Component | Percentage of base effort |
|-----------|--------------------------|
| Unit test writing | +15% |
| Code review cycles | +10% |
| Documentation (inline + README) | +5% |
| Local debugging and QA | +20% |
| Integration testing | +10% for API-touching tasks |
| Refactoring and cleanup | +10% |

Total overhead multiplier: approximately 1.7× for backend tasks, 1.6× for frontend tasks.

**Step 5 — Add coordination overhead by team size**
Adjust for communication and coordination costs:
- Solo developer: 1.0× (no coordination overhead)
- Team of 2-3: 1.1× (PR reviews, brief syncs)
- Team of 4-7: 1.2× (standups, planning, more PRs)
- Team of 8+: 1.35× (significant coordination overhead)

**Step 6 — Apply first-time-in-codebase setup cost**
Add one-time setup costs:
- Project scaffolding and tooling setup: +4-8 hours (flat)
- CI/CD pipeline setup: +4-16 hours depending on complexity
- Infrastructure setup (cloud, containers): +8-24 hours

**Step 7 — Identify high-uncertainty tasks**
Flag tasks where estimate confidence is low:
- Integration with undocumented or complex third-party systems: add 50% buffer
- Novel architectural patterns: add 30% buffer
- Tasks with unclear requirements: flag for clarification before scheduling

**Step 8 — Produce per-task estimates**
Output best-case, expected, and worst-case hours for each task.

## Output Format

```json
{
  "skill": "effort-estimator",
  "configuration": {
    "experience_level": "mid",
    "experience_multiplier": 1.3,
    "team_size": 2,
    "team_multiplier": 1.1
  },
  "summary": {
    "total_best_case_hours": 0,
    "total_expected_hours": 0,
    "total_worst_case_hours": 0,
    "total_expected_days": 0,
    "total_expected_weeks": 0
  },
  "task_estimates": [
    {
      "deliverable_id": "DEL-001",
      "deliverable_name": "User Authentication System",
      "size": "S",
      "base_hours": 12,
      "overhead_breakdown": {
        "unit_tests": 1.8,
        "code_review": 1.2,
        "documentation": 0.6,
        "debugging_qa": 2.4,
        "integration_testing": 1.2,
        "refactoring": 1.2
      },
      "total_overhead_hours": 8.4,
      "subtotal_hours": 20.4,
      "experience_multiplier": 1.3,
      "team_multiplier": 1.1,
      "setup_cost_hours": 0,
      "uncertainty_buffer_hours": 0,
      "best_case_hours": 16,
      "expected_hours": 29,
      "worst_case_hours": 40,
      "confidence": "HIGH|MEDIUM|LOW",
      "uncertainty_notes": null
    }
  ],
  "high_uncertainty_tasks": [
    {
      "deliverable_id": "DEL-005",
      "reason": "Stripe webhook integration behavior varies across environments",
      "additional_buffer_hours": 8,
      "recommendation": "Spike 2 hours on Stripe sandbox setup before estimating"
    }
  ]
}
```
