---
name: milestone-generator
description: Generates a structured development timeline with hourly task breakdowns, daily goals, weekly milestones, and monthly roadmap phases based on effort and dependency data.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Milestone Generator

## Objective

Produce a concrete, time-bound development timeline by scheduling tasks according to their dependencies, effort estimates, and team capacity — yielding hourly, daily, weekly, and monthly views of the project plan.

## Workflow

**Step 1 — Ingest planning data**
Load outputs from:
- `scope-analyzer` (deliverables, constraints)
- `task-dependency-mapper` (dependency tiers, critical path)
- `effort-estimator` (hours per task)
- `risk-planner` (risk buffers, contingency hours)
- `team-capacity-planner` (available hours per day/week)

**Step 2 — Schedule tasks using dependency tiers**
Assign each task to a calendar position:
- Start with Tier 0 tasks (no dependencies) — begin on Day 1
- Schedule Tier 1 tasks to begin as soon as their Tier 0 prerequisites complete
- Schedule each subsequent tier similarly
- Respect team capacity limits — do not schedule more work per day than available hours
- For parallel tasks, distribute across team members by specialty when team size > 1

**Step 3 — Build daily schedule**
For each working day:
- List tasks being worked on
- Mark task starts and completions
- Note if the day is on the critical path
- Flag external deadlines or integration points

Assumptions:
- Working day = 6 productive hours (accounts for meetings, interruptions)
- Week = 5 working days = 30 productive hours
- Month = 4 weeks = 120 productive hours per engineer

**Step 4 — Define weekly milestones**
For each week:
- Name the milestone (e.g., "Week 1 — Foundation & Auth")
- List deliverables that must be complete by end of week
- Define a clear, testable milestone criterion ("Authentication API passes all integration tests")
- Identify the key risk for the week

**Step 5 — Define monthly phases**
Group weeks into monthly phases:
- Phase 1: Foundation and core architecture
- Phase 2: Feature development
- Phase 3: Integration and testing
- Phase 4: Deployment and hardening

Each phase has:
- Clear start/end deliverables
- Go/no-go decision criteria
- Team review checkpoint

**Step 6 — Add contingency buffers**
Insert risk buffers from `risk-planner`:
- Add buffer after each phase (not scattered throughout)
- Label buffer weeks explicitly as "Contingency / Catch-up"
- Total project duration = sum(task hours) + contingency + review overhead

**Step 7 — Generate final timeline**
Produce milestones at all time horizons.

## Output Format

```json
{
  "skill": "milestone-generator",
  "timeline_summary": {
    "start_date": "relative Day 1",
    "total_working_days": 0,
    "total_weeks": 0,
    "total_months": 0,
    "contingency_days": 0,
    "phases": 0
  },
  "daily_schedule": [
    {
      "day": 1,
      "date_label": "Day 1 (Week 1)",
      "on_critical_path": true,
      "tasks": [
        {
          "task_id": "DEL-001",
          "task_name": "Project scaffold + CI/CD setup",
          "hours_today": 6,
          "cumulative_hours": 6,
          "total_task_hours": 12,
          "status": "in_progress|complete|not_started"
        }
      ],
      "daily_goal": "Repository live, CI pipeline green, development environment documented"
    }
  ],
  "weekly_milestones": [
    {
      "week": 1,
      "label": "Foundation",
      "days": "1-5",
      "deliverables_completing": ["DEL-001", "DEL-002"],
      "milestone_criterion": "Project repository set up, CI/CD pipeline functional, database schema migrated, development environment reproducible",
      "on_critical_path": true,
      "key_risk": "RISK-003 — CI/CD configuration time may exceed estimate"
    }
  ],
  "monthly_roadmap": [
    {
      "month": 1,
      "phase": "Foundation & Core Services",
      "weeks": "1-4",
      "deliverables": ["DEL-001", "DEL-002", "DEL-003", "DEL-004"],
      "phase_completion_criteria": "Core API functional with authentication, database accessible, deployable to staging",
      "go_no_go_checkpoint": "Week 4 end — all critical path tasks on schedule?"
    }
  ]
}
```
