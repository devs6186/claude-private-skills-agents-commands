---
name: review-report-generator
description: Compiles a complete, structured review report from all review phase outputs — summarizing findings by category, listing required and suggested changes, providing an approval recommendation, and generating an action plan. Use as the final step in any review workflow.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Review Report Generator Skill

## Objective

Produce a comprehensive, structured review report that serves as the single source of truth for what was found, what needs to change, and what the overall recommendation is.

---

# Workflow

## Step 1 — Collect All Phase Outputs

Gather results from all phases that ran:
- github-pr-analyzer (PR context, metadata)
- code-quality-reviewer
- architecture-decision-reviewer
- security-impact-reviewer
- test-coverage-reviewer
- performance-impact-reviewer
- maintainability-reviewer
- documentation-reviewer
- maintainer-feedback-interpreter (if run)
- bot-feedback-analyzer (if run)
- requested-change-evaluator (if run)
- pr-change-implementer (if run)

---

## Step 2 — Produce Executive Summary

Write a 3–5 sentence summary covering:
- What the PR does
- Overall quality verdict
- Most significant concern (if any)
- Approval recommendation

---

## Step 3 — Findings Table

Produce a table of all findings:

| # | Category | Severity | File:Line | Description | Status |
|---|----------|----------|-----------|-------------|--------|
| 1 | Code Quality | Blocking | foo.py:42 | ... | Open |
| 2 | Performance | Suggested | bar.py:88 | ... | Addressed |

Severity: Blocking / High / Medium / Low / Nitpick
Status: Open / Addressed / Declined / Deferred

---

## Step 4 — Category Summaries

For each review category that ran, write a one-paragraph summary:
- What was checked
- What was found
- Verdict (Pass / Needs Work / Fail)

Categories:
- Code Quality
- Architecture
- Security
- Test Coverage
- Performance
- Maintainability
- Documentation

---

## Step 5 — Required Changes

List all blocking and required changes:
- What must change before merge
- Which file and location
- Why it is required

---

## Step 6 — Suggested Improvements

List non-blocking suggestions:
- Improvement description
- Location
- Rationale
- Effort estimate

---

## Step 7 — Deferred Items

List items that should be tracked as follow-up work:
- Description
- Suggested issue title
- Why deferred from this PR

---

## Step 8 — Approval Recommendation

One of:

- **Approve**: No blocking issues. Ready to merge.
- **Approve with minor nits**: No blocking issues, but minor suggestions worth noting.
- **Request changes**: One or more blocking issues must be addressed.
- **Needs discussion**: Architectural or design concerns that need maintainer input before proceeding.

---

# Output Format

```markdown
## PR Review Report

### Executive Summary
[3-5 sentence summary]

### Approval Recommendation
[APPROVE | APPROVE WITH NITS | REQUEST CHANGES | NEEDS DISCUSSION]

### Findings Table
[table]

### Category Verdicts
**Code Quality**: [Pass/Needs Work/Fail] — [summary]
**Architecture**: [Pass/Needs Work/Fail] — [summary]
**Security**: [Pass/Needs Work/Fail] — [summary]
**Test Coverage**: [Pass/Needs Work/Fail] — [summary]
**Performance**: [Pass/Needs Work/Fail] — [summary]
**Maintainability**: [Pass/Needs Work/Fail] — [summary]
**Documentation**: [Pass/Needs Work/Fail] — [summary]

### Required Changes
1. [description] — [file:line]
2. ...

### Suggested Improvements
1. [description] — [rationale]
2. ...

### Deferred Items
1. [description] — suggest as follow-up: "[issue title]"
```
