---
name: requested-change-evaluator
description: Evaluates the validity, scope, and priority of changes requested by reviewers — distinguishing must-fix from should-fix from won't-fix, and determining implementation order. Use before implementing any reviewer-requested changes.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Requested Change Evaluator Skill

## Objective

Before implementing reviewer feedback, evaluate each requested change to understand:
- Whether it is valid and necessary
- Whether the suggested implementation is correct
- What order to implement changes in
- Whether any requests should be declined (with a clear explanation)

---

# Workflow

## Step 1 — Load All Requested Changes

Collect all action items from:
- maintainer-feedback-interpreter output (Required changes, implied requirements)
- bot-feedback-analyzer output (ordered fix task list)

---

## Step 2 — Validate Each Change

For each requested change, evaluate:

### Is the request technically valid?
- Does the reviewer correctly understand the code?
- Is the suggested fix correct, or does it introduce a different problem?
- Is the concern real, or is it based on a misreading of the code?

### Is the change in scope?
- Does the change belong in this PR, or in a separate follow-up?
- Will implementing it significantly expand the PR's scope?

### Is the change consistent with project conventions?
- Does the suggested approach match how similar problems are handled in the codebase?
- Does it contradict any explicit project guidelines (CLAUDE.md, CONTRIBUTING.md)?

---

## Step 3 — Classify Each Change

Tag each change as:

- **Must implement**: Valid, blocking, maintainer-required. Implement before requesting re-review.
- **Should implement**: Valid, non-blocking, high-signal suggestion. Implement if effort is low.
- **Consider implementing**: Reasonable suggestion but low priority. Implement if it doesn't complicate the PR.
- **Decline with explanation**: Invalid, out of scope, or contradicts project conventions. Draft a polite explanation.
- **Deferred to follow-up**: Valid but too large for this PR. Create a follow-up issue.

---

## Step 4 — Resolve Conflicts

If two requested changes conflict with each other:
- Identify the conflict
- Determine which takes priority (maintainer over bot, explicit over implicit)
- Draft a note explaining the conflict for the reply

---

## Step 5 — Determine Implementation Order

Order changes by:
1. CI-blocking fixes first (linting, test failures)
2. Maintainer-required code changes
3. High-signal suggestions
4. Low-priority nits and style improvements

Within each group, order by dependency (implement prerequisite changes before dependent changes).

---

## Step 6 — Estimate Total Effort

For the full set of must-implement changes:
- Estimate total lines to change
- Identify any changes that require understanding additional context before implementing
- Flag changes that may require new tests

---

# Output Format

Change Evaluation Report:
- Must implement (ordered list with file:line and action)
- Should implement (with rationale)
- Declined changes (with polite explanation for reply)
- Deferred changes (with suggested follow-up issue title)
- Conflict resolutions
- Implementation order
- Estimated effort
