---
name: pr-change-implementer
description: Implements code changes requested by reviewers in a pull request — applying specific fixes, refactors, or additions based on the evaluated change list from requested-change-evaluator. Use when reviewer changes need to be applied to code.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# PR Change Implementer Skill

## Objective

Apply reviewer-requested changes to the codebase with precision — making exactly the changes requested, no more and no less, while preserving project conventions.

---

# Workflow

## Step 1 — Load Change Plan

Receive the ordered change list from requested-change-evaluator:
- Must-implement changes (ordered by priority)
- Files and line references
- Specific action per change

Do not implement changes not in the plan without flagging them first.

---

## Step 2 — Read Current File State

Before modifying any file:
- Read the current version of the file
- Understand the surrounding context of the change
- Verify the file hasn't already been modified by an earlier change in this session

---

## Step 3 — Implement Each Change

For each change:

### Linting fixes
- Apply formatter corrections (spacing, line length, import order)
- Fix specific rule violations (NIC002, SIM105, etc.)
- Run the relevant linter command to verify the fix resolves the error

### Code logic fixes
- Apply the exact change described (rename, refactor, add guard, restructure)
- Do not introduce unrelated changes in the same edit
- Preserve existing behavior unless the change explicitly alters it

### Test additions
- Add the missing test in the appropriate test file
- Follow the project's test naming and structure conventions
- Ensure the test fails without the fix and passes with it (where verifiable)

### Documentation fixes
- Update docstrings, comments, or CHANGELOG entries as requested
- Match the style and format of existing documentation

---

## Step 4 — Verify Each Change

After each edit:
- Re-read the changed section to confirm it matches the requested change
- Check that no adjacent code was accidentally modified
- Verify the change compiles / parses without syntax errors (where checkable)

---

## Step 5 — Run Linters After All Changes

After all changes are applied:
- Run the project's linting suite on changed files
- Fix any new linting errors introduced by the implementation
- Confirm linting passes before marking implementation complete

---

## Step 6 — Summarize Changes Made

Produce a change summary:
- One entry per change implemented
- File path and line number
- Brief description of what was changed and why
- Any decisions made during implementation that deviated from the exact request (with justification)

---

# Safety Rules

- Never implement declined changes
- Never add unrequested refactoring, cleanup, or improvements
- Never change a file that is not referenced in the change plan
- If a requested change is unclear, flag it rather than guessing

---

# Output Format

Implementation Summary:
- Changes implemented (file:line → description)
- Linting status after changes (pass/fail per tool)
- Deviations from requested changes (if any, with justification)
- Files modified (list)
- Remaining changes not implemented (with reason)
