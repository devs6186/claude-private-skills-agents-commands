---
name: risk-planner
description: Identifies technical and project risks, assesses their probability and impact, and generates mitigation strategies and contingency buffers for the project plan.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Risk Planner

## Objective

Enumerate all risks that could delay or derail the project, assess each risk's probability and impact, and produce a risk register with concrete mitigation strategies and schedule contingency buffers.

## Workflow

**Step 1 — Ingest scope, complexity, and dependency data**
Load outputs from: `scope-analyzer`, `complexity-estimator`, `task-dependency-mapper`

**Step 2 — Apply universal software project risk categories**
Systematically check for risks in each category:

**Technical Risks**
- New or unfamiliar technology in the stack: probability of delays
- Complex third-party integrations (payment, auth, real-time): integration surprises
- Performance requirements requiring optimization: may need architectural rework
- Data migration: risk of data loss or integrity issues
- Security implementation: often more complex than expected

**External Dependency Risks**
- Third-party API access approval delays (Stripe, Twilio account verification)
- Design assets or mockups not yet complete
- Dependency on another team's API or service (internal)
- Open source library without active maintenance

**Scope Risks**
- Requirements that are ambiguous or likely to change
- Stakeholder availability for feedback and approval cycles
- Features with undefined acceptance criteria

**Resource Risks**
- Single developer responsible for critical path tasks
- Knowledge silos (only one person knows X)
- Vacation, illness, or turnover risk

**Quality Risks**
- Inadequate test coverage plans
- Missing staging environment
- No defined QA process

**Infrastructure Risks**
- Cloud account setup and approval delays
- Infrastructure provisioning time
- SSL certificate, DNS propagation delays

**Step 3 — Score each risk**
For each identified risk:
- Probability: LOW (10-30%), MEDIUM (30-60%), HIGH (60-90%)
- Impact: LOW (minor delay, <1 day), MEDIUM (1-5 day delay), HIGH (>1 week delay or scope change)
- Risk Score: Probability × Impact on a 1-9 matrix

**Step 4 — Generate mitigation strategies**
For each MEDIUM or HIGH risk score:
- Preventive action (reduce probability)
- Contingency action (reduce impact if it occurs)
- Early warning indicator (how you know the risk is materializing)

**Step 5 — Calculate contingency buffer**
Based on the risk register:
- Each HIGH risk: add 20% buffer to affected tasks
- Each MEDIUM risk: add 10% buffer to affected tasks
- Overall project buffer: 15% of total estimated hours (minimum)
- Round buffer up to the nearest half-day

## Output Format

```json
{
  "skill": "risk-planner",
  "risk_summary": {
    "total_risks": 0,
    "high_risks": 0,
    "medium_risks": 0,
    "low_risks": 0,
    "contingency_buffer_hours": 0,
    "contingency_buffer_percentage": 0
  },
  "risk_register": [
    {
      "id": "RISK-001",
      "category": "external_dependency",
      "title": "Stripe account verification delay",
      "description": "Stripe requires business verification before granting production API access, which can take 3-5 business days",
      "probability": "MEDIUM",
      "impact": "HIGH",
      "risk_score": 6,
      "affected_tasks": ["DEL-005", "DEL-008"],
      "mitigation": {
        "preventive": "Request Stripe API keys on Day 1, use sandbox environment for development",
        "contingency": "Implement payment UI with mock responses, integrate real Stripe after approval",
        "early_warning": "If Stripe approval not received by end of Week 1, trigger contingency plan"
      },
      "buffer_added_hours": 8
    }
  ],
  "critical_risks": [
    {
      "risk_id": "RISK-001",
      "reason": "Blocks DEL-005 which is on critical path"
    }
  ]
}
```
