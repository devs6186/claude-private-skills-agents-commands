---
name: skill-gap-detector
description: Analyzes the full set of Dev-OS skills to detect coverage gaps, missing skill categories, under-served agent workflows, and skill boundary overlaps.
metadata:
  author: dev-os
  version: 1.0
  category: skill-evolution
---

# Skill Gap Detector

## Objective

Identify skills that are missing from Dev-OS by comparing the existing skill inventory against the complete set of tasks agents need to perform, and by detecting where existing skills overlap (duplication) or have blind spots (gaps).

## Workflow

**Step 1 — Build complete skill inventory**
Read all SKILL.md files in the `skills/` directory tree.
For each skill, extract:
- Skill name and version
- Category
- Description (what it does)
- Input type consumed
- Output type produced
- Which agents reference it

Build an inventory table.

**Step 2 — Build agent workflow map**
Read all agent files in the `agents/` directory tree.
For each agent, extract:
- Agent name
- Skills it invokes
- Phases and order of invocation
- Input/output contracts

Build a map: agent → [skill1, skill2, ...]

**Step 3 — Identify coverage gaps by agent workflow**
For each agent:
- List every transformation or analysis the agent claims to perform
- Verify a skill exists for each transformation
- Flag any agent step that is not backed by a specific skill (implicit or missing skill)

**Step 4 — Apply standard software engineering task taxonomy**
Compare the skill inventory against this standard taxonomy of software engineering operations:

*Research & Discovery*
- Web research (exists: web-researcher skill)
- Repository analysis (exists: repo-overview)
- Documentation analysis (exists: documentation-analyzer)
- Dependency analysis (exists: dependency-testing-analyzer)

*Design & Architecture*
- Problem classification (exists: problem-classifier)
- Requirement extraction (exists: problem-requirement-extractor)
- Architecture pattern selection (exists: architecture-pattern-selector)
- Component identification (exists: component-identifier)
- Interface design (exists: interface-contract-designer)
- Data flow design (exists: data-flow-designer)

*Planning*
- Scope analysis — CHECK
- Complexity estimation — CHECK
- Dependency mapping — CHECK
- Effort estimation — CHECK
- Risk planning — CHECK
- Milestone generation — CHECK
- Team capacity planning — CHECK
- Plan compilation — CHECK

*Implementation*
- Code generation (exists: code-implementation-generator)
- Integration assembly (exists: integration-assembler)
- Project structure generation (exists: project-structure-generator)
- Minimal reproduction (exists: minimal-reproduction-builder)

*Testing*
- Test scaffold generation (exists: test-scaffold-generator)
- Failing test analysis (exists: failing-test-analyzer)
- Implementation validation (exists: implementation-validator)

*Security*
- Secret scanning — CHECK
- Dependency audit — CHECK
- Injection detection — CHECK
- Auth auditing — CHECK
- Access control auditing — CHECK
- Infrastructure security — CHECK
- API security — CHECK
- Attack surface mapping — CHECK
- Security reporting — CHECK

*Debugging*
- Problem classification (exists: problem-classifier)
- Stack trace analysis (exists: stacktrace-analyzer)
- Error log analysis (exists: error-log-analyzer)
- Execution path analysis (exists: execution-path-analyzer)
- Dependency conflict detection (exists: dependency-conflict-detector)
- Fix strategy generation (exists: fix-strategy-generator)

*Observability & Performance*
- Performance debugging (exists: performance-debugger)
- MISSING: Log aggregation and analysis skill
- MISSING: Metric anomaly detection skill
- MISSING: Distributed trace analysis skill

*Documentation*
- Documentation generation (exists: documentation-generator)
- MISSING: API documentation generation from code (distinct from general documentation-generator)
- MISSING: Changelog generation skill

*Deployment & Operations*
- Environment debugging (exists: environment-debugger)
- MISSING: Deployment verification skill (check live deployment is healthy)
- MISSING: Rollback planning skill

*Skill Evolution*
- Skill evaluation — CHECK
- Skill gap detection — CHECK (this skill)
- Skill weakness analysis — CHECK
- Skill improvement generation — CHECK
- Skill version management — CHECK
- Skill compatibility validation — CHECK

**Step 5 — Detect skill overlaps**
Compare skill descriptions pairwise for conceptual overlap:
- If two skills claim to do similar things, flag as potential duplication
- Assess whether the overlap is intentional (different scope, same category) or unintentional (true duplication)

**Step 6 — Rank gaps by priority**
Rank missing skills by:
1. How many agents would benefit from the skill
2. How frequently the skill type is needed in software engineering workflows
3. Whether the gap is currently covered by a workaround in an existing skill (lower priority) or completely uncovered (higher priority)

## Output Format

```json
{
  "skill": "skill-gap-detector",
  "inventory_summary": {
    "total_skills": 0,
    "total_agents": 0,
    "categories": {
      "security": 0,
      "planning": 0,
      "research": 0,
      "debugging": 0,
      "implementation": 0,
      "skill-evolution": 0,
      "other": 0
    }
  },
  "coverage_gaps": [
    {
      "id": "GAP-001",
      "missing_skill": "deployment-verifier",
      "category": "deployment",
      "description": "No skill exists to verify that a deployed application is healthy after deployment",
      "affected_agents": ["implementation-agent"],
      "agent_workflow_step_lacking_skill": "implementation-agent Phase 4 — no skill verifies deployment health",
      "priority": "HIGH|MEDIUM|LOW",
      "suggested_skill_name": "deployment-health-checker",
      "suggested_objective": "Verify a newly deployed application is responding correctly by checking health endpoints, smoke tests, and error rates"
    }
  ],
  "overlapping_skills": [
    {
      "skill_a": "dependency-testing-analyzer",
      "skill_b": "dependency-audit",
      "overlap_description": "Both analyze dependencies, but dependency-testing-analyzer focuses on dev tooling and dependency-audit focuses on security CVEs — overlap is intentional with different scope",
      "verdict": "intentional_overlap|unintentional_duplication",
      "recommended_action": "no_change|merge|clarify_boundaries"
    }
  ],
  "priority_gap_list": [
    {
      "rank": 1,
      "missing_skill": "deployment-verifier",
      "priority": "HIGH",
      "reason": "Affects final phase of implementation-agent with no current coverage"
    }
  ]
}
```
