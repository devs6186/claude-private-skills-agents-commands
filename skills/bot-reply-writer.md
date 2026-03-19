---
name: bot-reply-writer
description: Writes acknowledgment replies to CI bot and automated check feedback — confirming that bot-detected issues have been addressed and explaining how. Use after pr-change-implementer has resolved bot-flagged issues.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Bot Reply Writer Skill

## Objective

Produce clear, concise replies to automated bot comments that confirm the issues have been addressed — written for human maintainers who will read them, not the bots themselves.

---

# Workflow

## Step 1 — Load Bot Feedback Summary

Receive from bot-feedback-analyzer:
- Each bot finding that was addressed
- Each finding that was not addressed (with reason)

Receive from pr-change-implementer:
- What was actually changed to resolve each finding

---

## Step 2 — Write Reply for Linting Bot Comments

When a linting bot flagged errors:

Format:
```
Fixed — [brief description of what was changed].
[Optional: explain if multiple rules were involved.]
```

Example:
> "Fixed — reorganized the imports to comply with isort's length-sort ordering and removed the implicit string concatenation in the exception message (NIC002)."

---

## Step 3 — Write Reply for Test Failure Comments

When CI reported test failures:

Format:
```
[Test name(s)] were failing because [root cause].
[What was changed to fix it.]
```

Example:
> "`test_filter_rules_by_meta_features_keeps_any_os` was failing because `OS_LINUX` wasn't imported in the test file. Added the import — all tests pass now."

---

## Step 4 — Write Reply for Coverage Drop Comments

When a coverage bot reported a drop:

Format:
```
Coverage dropped because [reason].
[What tests were added to restore it.]
```

Or if coverage drop is intentional/acceptable:
```
The coverage drop is from [untested path] — [brief reason why it's acceptable or tracked].
```

---

## Step 5 — Write Reply for Security Scanner Comments

When a security bot flagged a finding:

Format:
```
[Addressed / False positive] — [brief explanation].
```

For addressed:
> "Switched to parameterized query format — the string concatenation that triggered bandit B608 is gone."

For false positive:
> "This is a false positive from bandit — the variable isn't user-controlled, it's drawn from a validated internal constant. The scan rule doesn't have enough context to see that."

---

## Step 6 — Bundle Into a Single CI Status Comment

If multiple bot findings were addressed:
- Write one consolidated comment rather than per-finding replies
- List what was fixed in a short bullet list
- Keep it under 10 lines

Example:
```
All CI issues addressed in the latest push:

- Linting: fixed isort ordering and NIC002 in features/common.py
- Tests: all 4 failing tests now pass — root cause was missing OS_LINUX import
- Coverage: added 2 tests for the new fast-path branch, coverage back to 94%
```

---

# Output Format

Bot Reply Comment:
- Single consolidated comment text (or per-bot if appropriate)
- Flags for any findings that were NOT addressed (with reason)
