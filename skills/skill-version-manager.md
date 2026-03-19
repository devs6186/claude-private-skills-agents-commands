---
name: skill-version-manager
description: Manages the version lifecycle of Dev-OS skills — writing improved versions to disk, maintaining a version history file, and ensuring old versions are archived rather than deleted.
metadata:
  author: dev-os
  version: 1.0
  category: skill-evolution
---

# Skill Version Manager

## Objective

Persist improved skill versions to disk in a safe, traceable manner by writing the new SKILL.md content, archiving the previous version, updating the global version registry, and generating a version history entry.

## Workflow

**Step 1 — Validate improvement input**
Receive input from `skill-improvement-generator`.
Verify all required fields are present:
- `target_skill`: skill directory name (must match an existing skills/ subdirectory)
- `improved_version`: version string in semver format (X.Y)
- `improved_skill_content`: non-empty string containing complete SKILL.md content
- `changelog`: non-empty array of change records

If any field is missing or malformed:
- Return error: `{ "error": "invalid_input", "missing_fields": [...] }`
- Do NOT proceed to write files.

**Step 2 — Read current skill state**
Read the current `skills/{target_skill}/SKILL.md` file.
Extract current version from YAML frontmatter.
Verify the improved version is strictly greater than the current version.

If improved version is not greater than current:
- Return error: `{ "error": "version_regression", "current": "X.Y", "attempted": "X.Y" }`
- Do NOT overwrite.

**Step 3 — Archive the current version**
Create a versioned archive directory: `skills/{target_skill}/versions/`
Write the current SKILL.md content to: `skills/{target_skill}/versions/SKILL_v{current_version}.md`

If the versions/ directory does not exist, create it.
If the archive file already exists, skip archiving (already archived) and log a warning.

**Step 4 — Write the improved version**
Write the improved skill content to: `skills/{target_skill}/SKILL.md`
Overwrite the existing file.

Verify the write succeeded by reading back the file and confirming the version number in the frontmatter matches the expected improved version.

**Step 5 — Update the version registry**
Read the global version registry at: `dev-os/SKILL_REGISTRY.md`
If the file does not exist, create it with the standard header (see Output Format below).

Find the entry for `{target_skill}` in the registry table.
If the entry exists: update the version, date, grade, and changelog summary.
If the entry does not exist: append a new row.

**Step 6 — Write the version history entry**
Append a new entry to: `skills/{target_skill}/CHANGELOG.md`
If the file does not exist, create it.

The entry format:
```markdown
## v{improved_version} — {date}

**Weaknesses Resolved:** {count}
**Version Bump Type:** {patch|minor|major}

### Changes
{changelog items formatted as bullet list}

### Evaluation Scores (if available)
- Before: {original composite score} ({grade})
- After: {improved composite score} ({grade})  [if re-evaluated]
```

**Step 7 — Return operation summary**
Produce structured result confirming all write operations completed successfully.

## Output Format

```json
{
  "skill": "skill-version-manager",
  "operation": {
    "status": "success|error",
    "target_skill": "skill-name",
    "previous_version": "1.0",
    "new_version": "1.1",
    "files_written": [
      "skills/skill-name/SKILL.md",
      "skills/skill-name/versions/SKILL_v1.0.md",
      "skills/skill-name/CHANGELOG.md",
      "dev-os/SKILL_REGISTRY.md"
    ],
    "archive_created": true,
    "registry_updated": true,
    "changelog_updated": true
  },
  "errors": []
}
```

### SKILL_REGISTRY.md format (when creating new file)

```markdown
# Dev-OS Skill Registry

Maintained automatically by skill-version-manager.
Last updated: {date}

| Skill Name | Current Version | Last Updated | Grade | Category | Summary |
|-----------|----------------|-------------|-------|----------|---------|
| secret-scanner | 1.0 | 2025-01-01 | B | security | Scans for exposed credentials |
```
