---
name: skill-evaluator
description: Scores an existing SKILL.md file across six quality dimensions to produce a detailed evaluation report identifying strengths and weaknesses.
metadata:
  author: dev-os
  version: 1.0
  category: skill-evolution
---

# Skill Evaluator

## Objective

Produce a structured quality score for any Dev-OS SKILL.md file by evaluating it across six dimensions: objective clarity, workflow determinism, output completeness, single responsibility adherence, reusability, and compatibility.

## Workflow

**Step 1 — Load the target skill**
Read the SKILL.md file at the specified path. Extract:
- YAML frontmatter (name, description, metadata)
- Objective section
- Workflow section (all steps)
- Output Format section

**Step 2 — Score Dimension 1: Objective Clarity (0-10)**
Evaluate the Objective section:
- 9-10: Single, unambiguous goal stated in one sentence. Outcome is measurable.
- 7-8: Clear goal with minor ambiguity in scope boundaries.
- 5-6: Goal is stated but could apply to multiple responsibilities.
- 3-4: Goal is vague, uses words like "handle", "manage", "process" without specifics.
- 1-2: No objective or objective is circular ("this skill does X by doing X").
- 0: Missing Objective section.

**Step 3 — Score Dimension 2: Workflow Determinism (0-10)**
Evaluate each workflow step:
- 9-10: Every step has a specific action verb and unambiguous instruction. Given the same input, any agent would produce the same output. No "decide", "consider", "evaluate" without defined criteria.
- 7-8: Most steps are deterministic; 1-2 steps have minor ambiguity.
- 5-6: Several steps are judgment calls without decision criteria.
- 3-4: Many steps are vague. Steps like "analyze the code" without specifying what to look for.
- 1-2: Workflow is a list of vague intentions, not executable steps.
- 0: No Workflow section.

**Step 4 — Score Dimension 3: Output Completeness (0-10)**
Evaluate the Output Format section:
- 9-10: Fully specified structured format (JSON schema or complete Markdown template). Every field defined with type and purpose. Example values provided.
- 7-8: Output format specified but some fields are undefined or optional without explanation.
- 5-6: Output format described in prose but not structured/schematized.
- 3-4: Output format is vague ("produces a report").
- 1-2: Output format mentioned but not specified.
- 0: No Output Format section.

**Step 5 — Score Dimension 4: Single Responsibility (0-10)**
Evaluate whether the skill does exactly one thing:
- 9-10: Skill has one clear input type, one transformation, one output type. Could not be split further without losing cohesion.
- 7-8: Skill is focused but includes one minor secondary concern.
- 5-6: Skill performs 2 distinct operations that could reasonably be separate skills.
- 3-4: Skill performs 3+ operations; should be decomposed.
- 1-2: Skill is a catch-all for multiple unrelated operations.
- 0: Skill explicitly states it does multiple unrelated things.

**Step 6 — Score Dimension 5: Reusability (0-10)**
Evaluate whether the skill can be used by multiple agents:
- 9-10: Skill accepts generic inputs (not agent-specific), produces portable outputs, has no hardcoded assumptions about calling agent.
- 7-8: Reusable with minor adjustments; input format is slightly specific.
- 5-6: Skill is designed for one agent context but could theoretically be reused.
- 3-4: Skill contains hardcoded references to specific agents or workflows.
- 1-2: Skill is entirely tied to one specific workflow and cannot be reused.
- 0: Skill references its caller explicitly.

**Step 7 — Score Dimension 6: Compatibility (0-10)**
Evaluate compatibility with Dev-OS architecture:
- 9-10: Uses standard YAML frontmatter format. Output is structured JSON or Markdown. No external tool dependencies that aren't universally available. Can be chained with other skills via standard output format.
- 7-8: Minor compatibility issues (e.g., output format needs slight normalization).
- 5-6: Non-standard output format requiring adapter.
- 3-4: Requires specific external tools or services not available in all Dev-OS environments.
- 1-2: Incompatible with standard Dev-OS skill chaining patterns.
- 0: Cannot be integrated into Dev-OS without rewrite.

**Step 8 — Calculate composite score**
Composite = (Objective × 0.20) + (Determinism × 0.25) + (Output × 0.20) + (SRP × 0.15) + (Reusability × 0.10) + (Compatibility × 0.10)

**Step 9 — Assign quality grade**
- A (9.0-10.0): Production-ready, no improvements needed
- B (7.5-8.9): Good quality, minor improvements recommended
- C (6.0-7.4): Acceptable, notable improvements needed
- D (4.0-5.9): Below standard, significant rework required
- F (<4.0): Fails quality bar, full rewrite needed

**Step 10 — Identify specific failure points**
For each dimension scoring below 7, list the exact issue and the specific text from the SKILL.md that caused the deduction.

## Output Format

```json
{
  "skill": "skill-evaluator",
  "evaluation": {
    "target_skill": "skill-name",
    "target_file": "skills/skill-name/SKILL.md",
    "target_version": "1.0",
    "evaluation_date": "ISO date",
    "composite_score": 0.0,
    "grade": "A|B|C|D|F",
    "dimensions": {
      "objective_clarity": {
        "score": 0,
        "weight": 0.20,
        "weighted_score": 0.0,
        "rationale": "Specific explanation of score",
        "failing_text": "Exact text from SKILL.md that caused deduction (if any)"
      },
      "workflow_determinism": {
        "score": 0,
        "weight": 0.25,
        "weighted_score": 0.0,
        "rationale": "...",
        "vague_steps": ["Step N: 'analyze the code' — no criteria specified"]
      },
      "output_completeness": {
        "score": 0,
        "weight": 0.20,
        "weighted_score": 0.0,
        "rationale": "..."
      },
      "single_responsibility": {
        "score": 0,
        "weight": 0.15,
        "weighted_score": 0.0,
        "rationale": "...",
        "secondary_responsibilities": []
      },
      "reusability": {
        "score": 0,
        "weight": 0.10,
        "weighted_score": 0.0,
        "rationale": "..."
      },
      "compatibility": {
        "score": 0,
        "weight": 0.10,
        "weighted_score": 0.0,
        "rationale": "..."
      }
    },
    "strengths": [
      "Specific thing the skill does well"
    ],
    "weaknesses": [
      {
        "dimension": "workflow_determinism",
        "issue": "Step 3 says 'review the configuration' without specifying what to look for",
        "severity": "HIGH|MEDIUM|LOW",
        "improvement_direction": "Add specific checklist items to Step 3"
      }
    ],
    "recommended_action": "no_change|minor_improvement|moderate_rework|major_rewrite"
  }
}
```
