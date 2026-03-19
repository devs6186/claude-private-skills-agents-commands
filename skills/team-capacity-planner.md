---
name: team-capacity-planner
description: Adapts the project plan to the team size and composition, distributing tasks across team members based on specialization, managing parallel workstreams, and calculating realistic capacity-adjusted timelines.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Team Capacity Planner

## Objective

Model team capacity accurately by accounting for team size, specialization, communication overhead, and realistic availability, then distribute tasks across team members to maximize parallel progress while respecting skill requirements.

## Workflow

**Step 1 — Define team configuration**
Accept one of the following team configurations:

**Solo Developer**
- Available hours: 6/day (1 person)
- No communication overhead
- All tasks sequential unless context-switching is acceptable
- Context-switch penalty: working on >2 workstreams simultaneously reduces productivity by 20%

**Small Team (2-3 engineers)**
- Available hours: 6/person/day
- Communication overhead: 10% of time
- Net productive hours: 5.4/person/day
- Can maintain 2-3 parallel workstreams with clear ownership
- Code review can happen same-day (no waiting day)

**Medium Team (4-7 engineers)**
- Available hours: 6/person/day
- Communication overhead: 20% (standups, planning, reviews)
- Net productive hours: 4.8/person/day
- Can maintain 4+ parallel workstreams
- Code review turnaround: half-day average
- Requires sprint/iteration structure for coordination

**Step 2 — Map specialization requirements**
For each deliverable, identify specialization requirements:
- Frontend (React, Vue, mobile)
- Backend (API, business logic, databases)
- Infrastructure / DevOps (Docker, CI/CD, cloud)
- Data engineering (schemas, migrations, analytics)
- Full-stack (any)

For each team member (or role if team isn't named):
- Primary specialization
- Secondary skills
- Maximum concurrent workstreams

**Step 3 — Assign tasks to team members**
- Assign each task to the best-matched team member
- Respect the critical path: assign critical path tasks to most experienced member
- Balance workloads: no team member should be >120% loaded in any week
- Flag tasks requiring collaboration (pair programming or review dependencies)

**Step 4 — Calculate workstream parallelism**
Determine how many workstreams can run simultaneously:
- Solo: 1 primary workstream, 1 background workstream (e.g., infrastructure while waiting for API)
- Team of 2: 2 parallel workstreams
- Team of 3: 2-3 parallel workstreams depending on specialization overlap
- Team of 4-7: 3-4 parallel workstreams with clear track ownership

**Step 5 — Calculate capacity-adjusted timeline**
- Total hours remaining = sum of all task hours
- Effective daily team capacity = team_size × productive_hours_per_person
- Calendar days = total hours / daily team capacity
- Add review/coordination overhead: +10% for small teams, +20% for medium teams

**Step 6 — Identify bottlenecks by specialization**
Flag if one specialization is overloaded:
- If all critical path tasks require backend, and there's 1 backend engineer, the project is bottlenecked
- Recommend cross-training or redistribution for severe bottlenecks

## Output Format

```json
{
  "skill": "team-capacity-planner",
  "team_configuration": {
    "team_size": 2,
    "team_type": "solo|small|medium",
    "members": [
      {
        "id": "ENG-001",
        "role": "Full-stack Engineer",
        "primary_skills": ["backend", "database"],
        "secondary_skills": ["devops"],
        "productive_hours_per_day": 5.4,
        "max_concurrent_workstreams": 2
      }
    ],
    "total_daily_capacity_hours": 10.8,
    "communication_overhead_percentage": 10
  },
  "task_assignments": [
    {
      "task_id": "DEL-001",
      "assigned_to": "ENG-001",
      "required_skills": ["backend", "devops"],
      "parallel_with": ["DEL-002"]
    }
  ],
  "workstreams": [
    {
      "id": "WS-001",
      "name": "Backend API Track",
      "owner": "ENG-001",
      "tasks": ["DEL-001", "DEL-003", "DEL-005"]
    }
  ],
  "capacity_adjusted_timeline": {
    "total_task_hours": 0,
    "daily_team_capacity": 0,
    "raw_calendar_days": 0,
    "coordination_overhead_days": 0,
    "total_calendar_days": 0,
    "total_calendar_weeks": 0
  },
  "bottlenecks": [
    {
      "specialization": "backend",
      "overloaded_by_hours": 20,
      "weeks_affected": [3, 4],
      "recommendation": "Consider moving DEL-007 frontend tasks earlier to rebalance"
    }
  ]
}
```
