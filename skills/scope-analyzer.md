---
name: scope-analyzer
description: Analyzes a project idea or architecture document to extract scope boundaries, deliverables, technical components, integrations, and constraints for planning purposes.
metadata:
  author: dev-os
  version: 1.0
  category: planning
---

# Scope Analyzer

## Objective

Convert a project idea, requirements document, or architecture description into a structured scope definition that lists all deliverables, components, integrations, non-goals, and constraints required for downstream planning skills.

## Workflow

**Step 1 — Extract project type and domain**
Classify the project:
- Project type: web app, API service, mobile app, data pipeline, CLI tool, microservices system, ML pipeline, infrastructure automation
- Domain: e-commerce, SaaS, fintech, healthcare, internal tooling, developer tool, content platform, etc.
- Deployment target: cloud (AWS/GCP/Azure), on-premise, edge, serverless, containerized

**Step 2 — Enumerate deliverables**
List all concrete things that must be built:
- Frontend interfaces (pages, components, flows)
- Backend services and APIs (endpoints, business logic modules)
- Database schemas and migrations
- Infrastructure components (servers, queues, caches, CDN)
- Authentication and authorization system
- Integration connectors (third-party APIs, payment gateways, etc.)
- DevOps artifacts (CI/CD pipelines, Docker configs, IaC)
- Testing suites (unit, integration, e2e)
- Documentation (API docs, user guides, runbooks)

**Step 3 — Map technical components**
For each deliverable, identify:
- Technology choices (if specified or inferable)
- Key libraries and frameworks
- Data models required
- External APIs to integrate
- Infrastructure dependencies

**Step 4 — Identify integration points**
List all external integrations:
- Third-party services (Stripe, Twilio, SendGrid, Auth0, etc.)
- Internal systems being connected
- Data sources (databases, files, streams)
- Authentication providers (Google OAuth, SAML, LDAP)

**Step 5 — Extract non-goals and constraints**
Identify what is explicitly out of scope:
- Features deferred to future phases
- Platforms not supported in this phase
- Scale targets (e.g., "not required to support >10k concurrent users in v1")
- Budget or time constraints

**Step 6 — Assess scope size**
Classify total scope:
- XS: single feature or utility, <1 week solo
- S: simple CRUD app or single service, 1-2 weeks solo
- M: multi-service application or complex feature set, 1-2 months solo
- L: full-stack platform with integrations, 3-6 months small team
- XL: enterprise system or multi-phase platform, 6+ months medium team

## Output Format

```json
{
  "skill": "scope-analyzer",
  "project": {
    "name": "project-name",
    "type": "web_app|api_service|mobile_app|data_pipeline|cli|microservices|ml_pipeline|infra_automation",
    "domain": "e-commerce|saas|fintech|healthcare|internal|developer_tool|content",
    "deployment_target": "aws|gcp|azure|on-premise|serverless|containerized",
    "scope_size": "XS|S|M|L|XL"
  },
  "deliverables": [
    {
      "id": "DEL-001",
      "name": "User Authentication System",
      "type": "backend_service",
      "description": "JWT-based auth with registration, login, password reset, email verification",
      "tech_stack": ["Node.js", "Express", "PostgreSQL", "bcrypt", "jsonwebtoken"],
      "complexity": "MEDIUM",
      "has_external_dependencies": false
    }
  ],
  "integrations": [
    {
      "service": "Stripe",
      "purpose": "Payment processing",
      "integration_type": "REST API",
      "complexity": "MEDIUM",
      "requires_webhook": true
    }
  ],
  "non_goals": [
    "Mobile app (web-responsive only in v1)",
    "Multi-language support"
  ],
  "constraints": [
    "Must deploy on AWS",
    "Must complete in 8 weeks",
    "Team of 2 engineers"
  ],
  "technical_risks": [
    "Stripe webhook reliability in development environment",
    "PostgreSQL schema design for flexible product attributes"
  ]
}
```
