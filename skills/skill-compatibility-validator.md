---
name: skill-compatibility-validator
description: Validates that an improved skill version maintains backward compatibility with all agents and skills that depend on it, preventing breaking changes from entering the Dev-OS skill library.
metadata:
  author: dev-os
  version: 1.0
  category: skill-evolution
---

# Skill Compatibility Validator

## Objective

Verify that an improved SKILL.md version does not introduce breaking changes that would disrupt any agent or skill in Dev-OS that currently depends on the skill being updated.

## Workflow

**Step 1 — Load compatibility check inputs**
Required inputs:
- Original skill content (the current version before improvement)
- Improved skill content (the proposed new version)
- Improvement changelog from `skill-improvement-generator`
- Full skill inventory and agent files from the Dev-OS directory

**Step 2 — Extract original output schema**
Parse the Output Format section of the original skill:
- Extract all top-level JSON field names
- Extract all nested object field names
- Extract all array element field names
- Record all enum values for each enum field
- Record all required vs. optional field designations

**Step 3 — Extract improved output schema**
Parse the Output Format section of the improved skill using the same extraction method.

**Step 4 — Detect breaking schema changes**
Compare original schema to improved schema. Flag as BREAKING any of:
- **Removed field**: a field present in original is absent in improved
- **Renamed field**: a field name changed (removed + added is a rename pattern)
- **Type change**: field type changed (string → array, object → string, etc.)
- **Enum contraction**: an enum value present in original is removed in improved
- **Required field added**: a new field is required (not optional) in improved that did not exist in original

Flag as NON-BREAKING (safe):
- **New optional field added**: consumers can ignore it
- **Enum expansion**: new enum values added (existing consumers unaffected)
- **Workflow step added/clarified**: does not affect output schema
- **Metadata changes**: version bump, description update

**Step 5 — Scan all agent files for dependency on this skill**
Search all agent markdown files in `agents/` directory:
- Find agents that reference the skill by name
- Extract which output fields they consume (look for field name references in agent workflow descriptions)
- Build dependency map: agent → [fields_consumed_from_this_skill]

**Step 6 — Scan all other skills for dependency**
Search all SKILL.md files:
- Find skills that declare this skill as an input source
- Extract which output fields they consume
- Add to dependency map: skill → [fields_consumed_from_this_skill]

**Step 7 — Assess impact of detected breaking changes**
For each BREAKING change:
- Find all dependents (from steps 5-6) that consume the changed field
- Assess whether the dependent would fail or produce wrong output
- Classify impact: CRITICAL (agent fails), HIGH (agent produces wrong output), MEDIUM (agent degrades gracefully)

**Step 8 — Generate compatibility verdict**
- COMPATIBLE: No breaking changes detected. Improvement is safe to apply.
- COMPATIBLE_WITH_WARNINGS: No breaking changes, but non-standard patterns detected that may confuse future developers.
- BREAKING: One or more breaking changes detected. List affected dependents. Block deployment until resolved.

**Step 9 — Generate resolution instructions for breaking changes**
For each breaking change:
- Option A (Preferred): Modify the improvement to preserve the original field name while adding the new field
- Option B: Add a compatibility adapter section to the skill documenting the migration path
- Option C: Schedule coordinated update of all dependents along with the skill update

## Output Format

```json
{
  "skill": "skill-compatibility-validator",
  "validation_result": {
    "target_skill": "skill-name",
    "original_version": "1.0",
    "improved_version": "1.1",
    "verdict": "COMPATIBLE|COMPATIBLE_WITH_WARNINGS|BREAKING",
    "safe_to_deploy": true,
    "breaking_changes_count": 0,
    "non_breaking_changes_count": 0
  },
  "schema_diff": {
    "removed_fields": [],
    "added_optional_fields": ["findings[].edge_case_notes"],
    "renamed_fields": [],
    "type_changes": [],
    "enum_changes": {
      "contractions": [],
      "expansions": ["severity: added INFORMATIONAL value"]
    }
  },
  "breaking_changes": [
    {
      "id": "BC-001",
      "type": "removed_field",
      "field": "findings[].code_snippet",
      "impact": "HIGH",
      "affected_dependents": [
        {
          "type": "agent",
          "name": "security-auditor-agent",
          "usage": "security-report-generator reads findings[].code_snippet to generate report",
          "failure_mode": "KeyError on code_snippet field — report generation fails"
        }
      ],
      "resolution": {
        "option_a": "Restore findings[].code_snippet field in improved version. Add findings[].code_context as additional field instead of replacing.",
        "option_b": "Add migration note: code_snippet renamed to code_context in v1.1. Update security-auditor-agent to use code_context.",
        "recommended": "option_a"
      }
    }
  ],
  "warnings": [
    {
      "type": "non_standard_pattern",
      "description": "Improved version uses snake_case in one field and camelCase in another — inconsistent naming",
      "recommendation": "Standardize to snake_case throughout"
    }
  ],
  "deployment_recommendation": "Deploy immediately — no breaking changes|Block deployment — resolve BC-001 first|Deploy with coordinated update plan"
}
```
