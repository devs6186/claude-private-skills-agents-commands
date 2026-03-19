---
name: skill-weakness-analyzer
description: Performs deep analysis of a specific SKILL.md to identify concrete weaknesses — ambiguous steps, missing edge case handling, incomplete output specs, and logic gaps — and outputs a structured weakness report.
metadata:
  author: dev-os
  version: 1.0
  category: skill-evolution
---

# Skill Weakness Analyzer

## Objective

Identify every concrete weakness in a SKILL.md file that would cause an agent executing the skill to produce inconsistent, incomplete, or incorrect outputs — going deeper than quality scoring to pinpoint exact failure modes.

## Workflow

**Step 1 — Load skill and evaluation context**
Read the target SKILL.md file.
Load the corresponding `skill-evaluator` output if available (skip if not; run independently).

**Step 2 — Analyze for ambiguous instructions**
Scan every workflow step for language that would produce different results from different agents:

Flag these anti-patterns:
- **Vague verbs without criteria**: "review", "check", "analyze", "consider", "evaluate", "examine" without specifying what to look for
  - Bad: "Review the authentication code for issues"
  - Good: "Check for: (a) missing `HttpOnly` flag on cookies, (b) JWT algorithm not specified, (c) password hashed with MD5 or SHA1"
- **Undefined thresholds**: "if the complexity is high" without defining what "high" means
- **Subjective assessments**: "if the code looks suspicious" — no agent can consistently apply this
- **Missing branching logic**: "if X, then Y" without specifying what to do when X is false
- **Implicit assumptions**: steps that assume the previous step succeeded without specifying the error path

**Step 3 — Analyze for missing edge cases**
For each workflow step, consider what could go wrong and check if the skill handles it:
- What if the input file doesn't exist or is empty?
- What if the input is malformed or uses an unexpected format?
- What if a required field is missing from the input?
- What if a pattern scan finds zero matches?
- What if a list is empty?
- What if an external service or tool is unavailable?

Flag each edge case that has no handling instruction in the skill.

**Step 4 — Analyze output format completeness**
Check the Output Format section for:
- Fields referenced in workflow steps but not present in output format
- Fields in output format not populated by any workflow step
- Missing required metadata fields (skill name, version, timestamp)
- Enum values not exhaustively defined (e.g., `severity: "HIGH or MEDIUM"` but HIGH|MEDIUM|LOW|CRITICAL not enumerated)
- Nested objects without field definitions
- Arrays without element type specification

**Step 5 — Analyze for missing prerequisite declarations**
Check whether the skill:
- Lists all required inputs explicitly
- Declares what other skill outputs it depends on
- Specifies the expected format of each input

**Step 6 — Analyze for scope creep**
Check whether any workflow steps exceed the skill's stated objective:
- Steps that produce outputs beyond the declared scope
- Steps that modify state or call external services not mentioned in the objective
- Steps that perform operations belonging to a different skill (violates single responsibility)

**Step 7 — Analyze for determinism violations**
Identify steps where the result depends on:
- Execution environment (e.g., "run the tests" — which tests? In which environment?)
- Time-dependent data (e.g., "check the latest version" — at what point in time?)
- External state that may change (e.g., "verify the API is available" — what if it's not?)
- LLM judgment without criteria (any step that asks for open-ended assessment)

**Step 8 — Synthesize weakness list**
Compile all findings into a prioritized weakness list:
- BLOCKER: Will cause skill to fail or produce wrong outputs in normal use
- HIGH: Will cause inconsistent outputs across agents
- MEDIUM: Will cause suboptimal outputs in edge cases
- LOW: Minor clarity issue, unlikely to cause real problems

## Output Format

```json
{
  "skill": "skill-weakness-analyzer",
  "analysis": {
    "target_skill": "skill-name",
    "target_version": "1.0",
    "total_weaknesses": 0,
    "blockers": 0,
    "high": 0,
    "medium": 0,
    "low": 0,
    "recommended_action": "no_change|patch|moderate_rework|full_rewrite"
  },
  "weaknesses": [
    {
      "id": "WK-001",
      "severity": "BLOCKER|HIGH|MEDIUM|LOW",
      "category": "ambiguous_instruction|missing_edge_case|incomplete_output|missing_prerequisite|scope_creep|determinism_violation",
      "location": "Workflow Step 3",
      "current_text": "Review the configuration for security issues",
      "problem": "No criteria specified for what constitutes a 'security issue' in this context. Two agents executing this step would produce completely different outputs.",
      "impact": "Inconsistent audit results; critical misconfigurations may be missed or irrelevant items flagged",
      "fix_direction": "Replace with explicit checklist: (a) check X, (b) verify Y is not set to Z, (c) confirm W is present"
    }
  ],
  "missing_edge_cases": [
    {
      "step": "Step 2",
      "edge_case": "Input SKILL.md file is empty or missing the Workflow section",
      "current_handling": "none",
      "recommended_handling": "If Workflow section is missing, immediately return error: { 'error': 'missing_workflow_section', 'action': 'manual_review_required' }"
    }
  ],
  "output_format_issues": [
    {
      "issue_type": "undefined_field",
      "field": "findings[].context",
      "problem": "Field 'context' is referenced in Step 5 output but not defined in Output Format section",
      "fix": "Add 'context' field definition with type string, description, and example"
    }
  ]
}
```
