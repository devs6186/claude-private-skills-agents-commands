---
name: skill-improvement-generator
description: Generates an improved version of a SKILL.md file by resolving all identified weaknesses while preserving the skill's purpose, structure, and compatibility with Dev-OS.
metadata:
  author: dev-os
  version: 1.0
  category: skill-evolution
---

# Skill Improvement Generator

## Objective

Produce a complete, improved SKILL.md file that resolves all weaknesses identified by the `skill-evaluator` and `skill-weakness-analyzer` while preserving the skill's original purpose and maintaining full compatibility with Dev-OS skill architecture.

## Workflow

**Step 1 — Load improvement inputs**
Required inputs:
- Original SKILL.md content
- `skill-evaluator` output (quality scores and weaknesses)
- `skill-weakness-analyzer` output (detailed weakness report)

**Step 2 — Triage improvements by severity**
Process improvements in this order:
1. BLOCKER weaknesses first — these cause skill failure
2. HIGH severity weaknesses — these cause inconsistent outputs
3. Dimension scores below 6 — these fail quality bar
4. MEDIUM weaknesses — improve reliability
5. LOW weaknesses — polish and clarity

Do NOT change:
- The skill's core objective (what it does)
- The output schema field names already consumed by other agents
- The YAML frontmatter `name` field
- The overall skill structure (Objective / Workflow / Output Format)

**Step 3 — Resolve ambiguous instructions**
For each workflow step flagged as ambiguous:
- Replace vague verbs with specific action verbs (detect, extract, verify, count, compare, flag)
- Replace subjective criteria with explicit, enumerable criteria
- Add decision trees for branching logic: "If [condition], then [action]. If not, then [alternative action]."
- Convert open-ended assessments into checklists with defined outcomes

Transformation pattern:
```
BEFORE: "Review the code for security issues"
AFTER:
"Check each source file for the following patterns:
  (a) String concatenation in SQL queries → flag as SQL_INJECTION
  (b) eval() with user-controlled input → flag as CODE_INJECTION
  (c) innerHTML = variable → flag as XSS
  (d) fs.readFile with user-controlled path → flag as PATH_TRAVERSAL
  If no matches found: record zero findings for this category."
```

**Step 4 — Add edge case handling**
For each identified missing edge case:
- Add explicit handling instruction at the relevant workflow step
- Use the pattern: "If [edge condition], [specific action]."
- For missing input handling: add a Step 0 "Validate inputs" that checks all required inputs exist
- For empty result sets: always specify the output for the zero-result case

**Step 5 — Complete the output format**
For each output format issue:
- Add missing field definitions with: field name, type, description, example value
- Enumerate all enum values exhaustively
- Add required metadata fields if missing:
  - `"skill"`: skill name (string)
  - `"version"`: version string
- Ensure every field populated in workflow steps is defined in output format
- Remove fields defined in output format but never populated

**Step 6 — Strengthen single responsibility**
If the skill has scope creep (steps beyond the declared objective):
- Extract out-of-scope steps into a new skill (describe the new skill needed, do not create it)
- Note in the improvement that a companion skill should be created
- Adjust the objective to precisely match the remaining workflow

**Step 7 — Increment version number**
Apply semantic versioning:
- PATCH version bump (1.0 → 1.1): for clarifications and minor improvements that don't change outputs
- MINOR version bump (1.0 → 1.1 → 2.0): for changes that add new output fields or workflow steps
- MAJOR version bump (1.0 → 2.0): for breaking changes to output schema (renamed/removed fields)

Update the version in YAML frontmatter.

**Step 8 — Write the improved SKILL.md**
Produce the complete, corrected SKILL.md file content. The output must be a complete file — not a diff or patch.

**Step 9 — Generate improvement changelog**
Document every change made, categorized by weakness resolved.

## Output Format

```json
{
  "skill": "skill-improvement-generator",
  "improvement_result": {
    "target_skill": "skill-name",
    "original_version": "1.0",
    "improved_version": "1.1",
    "version_bump_type": "patch|minor|major",
    "weaknesses_resolved": 0,
    "weaknesses_remaining": 0,
    "remaining_weakness_ids": [],
    "new_skills_needed": [
      {
        "suggested_name": "new-skill-name",
        "reason": "Steps X-Y extracted from target skill exceeded its scope",
        "suggested_objective": "..."
      }
    ],
    "compatibility_preserved": true,
    "breaking_changes": []
  },
  "changelog": [
    {
      "weakness_id": "WK-001",
      "severity": "BLOCKER",
      "change_type": "clarified_instruction|added_edge_case|completed_output_format|removed_scope_creep|added_prerequisite_check",
      "description": "Replaced vague 'review configuration' in Step 3 with explicit 8-item security checklist",
      "location": "Workflow Step 3"
    }
  ],
  "improved_skill_content": "## FULL CONTENT OF THE IMPROVED SKILL.md FILE AS A STRING ##"
}
```

The `improved_skill_content` field must contain the complete, ready-to-write SKILL.md file content as a string, with all YAML frontmatter, Objective, Workflow, and Output Format sections properly structured.
