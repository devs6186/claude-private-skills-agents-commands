---
name: documentation-reviewer
description: Reviews documentation quality and completeness in a pull request — checking docstrings, inline comments, CHANGELOG updates, README changes, and whether public API changes are properly documented. Use during PR reviews or when docs-only changes are submitted.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Documentation Reviewer Skill

## Objective

Ensure that code changes in a PR are accompanied by appropriate documentation updates, and that existing documentation is not left in a stale or misleading state.

---

# Workflow

## Step 1 — Check CHANGELOG

Verify:
- CHANGELOG.md (or equivalent) has been updated if the project requires it
- The entry is under the correct version/release section
- The entry accurately describes the change from a user perspective
- The format matches existing entries in the file

---

## Step 2 — Check Public API Documentation

For every new or changed public function, class, or method:
- Is a docstring present?
- Does the docstring describe: purpose, parameters, return value, raised exceptions?
- Is the docstring format consistent with the project's convention (Google, NumPy, Sphinx, etc.)?
- Are type annotations present (for typed projects)?

---

## Step 3 — Check Inline Comments

Review:
- Are complex algorithms or non-obvious logic explained with comments?
- Are comments accurate — do they describe what the code does, not what it obviously does?
- Are outdated comments removed when the code they described was changed?
- Are there `# type: ignore` or `# noqa` suppressions without explanatory comments?

---

## Step 4 — Check README or User-Facing Docs

If the PR:
- Adds a new feature: is it documented in README or user docs?
- Changes CLI arguments or config options: are docs updated?
- Deprecates functionality: is there a migration note?
- Changes installation requirements: is the setup guide updated?

---

## Step 5 — Check Commit Message Quality

Review the commit messages in the PR:
- Do they follow the project's commit message convention?
- Do they accurately describe the change?
- Do they reference relevant issue numbers?
- Are they written in imperative mood (project standard)?

---

## Step 6 — Check PR Description Quality

Assess:
- Does the PR description explain the motivation for the change?
- Does it describe what changed and why (not just what files were edited)?
- Are test instructions or reproduction steps provided if relevant?
- Are screenshots included for UI changes?
- Are linked issues referenced?

---

## Step 7 — Flag Stale Documentation

Identify:
- Comments that reference function names, variable names, or behaviors that were changed in the diff
- Docstrings that describe old behavior no longer present
- README sections that reference removed or renamed functionality

---

# Severity Classification

- **Blocking**: New public API with no docstring; CHANGELOG not updated (if project requires it); removed feature with no migration note
- **Suggested**: Missing edge-case documentation; incomplete parameter descriptions
- **Nitpick**: Minor phrasing improvements; whitespace in docstrings

---

# Output Format

Documentation Review:
- CHANGELOG status (updated / missing / format error)
- Public API documentation coverage (complete / partial / missing)
- Inline comment quality
- README/user docs status
- Commit message quality
- PR description quality
- Stale documentation found
- Overall documentation verdict (Complete / Partial / Insufficient)
