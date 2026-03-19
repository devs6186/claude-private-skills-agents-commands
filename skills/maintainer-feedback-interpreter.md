---
name: maintainer-feedback-interpreter
description: Interprets review comments from human maintainers — extracting required changes, understanding intent behind feedback, classifying blocking vs. non-blocking items, and prioritizing what must be addressed before merge. Use when a maintainer has left review comments on a PR.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Maintainer Feedback Interpreter Skill

## Objective

Transform raw maintainer review comments into a structured, prioritized action plan that distinguishes what must be changed, what is suggested, and what is just a question or discussion point.

---

# Workflow

## Step 1 — Collect All Review Comments

Gather:
- All inline review comments (file + line references)
- Top-level PR review comments (general feedback)
- Review verdict: `APPROVED`, `CHANGES_REQUESTED`, or `COMMENTED`
- Names of reviewers to understand their role (maintainer, contributor, bot)

---

## Step 2 — Classify Each Comment

Tag every comment with one of:

- **Required change**: Maintainer explicitly requests a specific code change; blocking merge
- **Blocking question**: Maintainer asks a question that implies a problem; must be answered before merge
- **Non-blocking suggestion**: Maintainer suggests an improvement but doesn't require it ("nit:", "optional:", "you could also...")
- **Question or discussion**: Maintainer asks for clarification or context; may not require a code change
- **Praise**: Positive feedback; no action needed
- **Typo/style nit**: Very minor cosmetic change; low priority

---

## Step 3 — Extract the Specific Action

For each Required change, extract:
- The file and line reference
- What exactly needs to change (rename, refactor, delete, add, restructure)
- The reason the maintainer gave (if any)
- Whether the maintainer suggested a specific implementation

---

## Step 4 — Detect Implicit Requirements

Some feedback implies changes without stating them explicitly:
- "This will break if..." → add a guard or test
- "Have you considered..." → evaluate the alternative and respond or implement
- "What about the case where..." → handle the missing case
- "This is O(n²)..." → optimize the implementation

Tag these as implied required changes and extract the implicit action.

---

## Step 5 — Prioritize Changes

Rank changes by:
1. **Critical**: Changes that are required by maintainer for merge (explicit `CHANGES_REQUESTED`)
2. **High**: Implied problems that would likely block merge on next review
3. **Medium**: Non-blocking suggestions from a maintainer (high signal, but optional)
4. **Low**: Nits, style comments, optional improvements

---

## Step 6 — Group by Theme

Cluster related feedback:
- All feedback about the same function/class
- Feedback with the same root cause (e.g., "missing tests" appears in 3 comments → one task)
- Feedback that can be resolved with a single change

---

# Output Format

Maintainer Feedback Summary:
- Review verdict and reviewer list
- Required changes (prioritized list with file:line references and action descriptions)
- Blocking questions (with required response content)
- Non-blocking suggestions (with rationale for accepting or declining)
- Discussion points (with suggested response angle)
- Total action items: N required, M suggested, P questions
