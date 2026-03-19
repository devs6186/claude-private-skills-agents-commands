---
name: bot-feedback-analyzer
description: Analyzes automated bot and CI feedback on a pull request — parsing linter errors, test failures, coverage drops, and security scanner findings into actionable fix tasks. Use when CI has failed or a bot has commented on a PR.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Bot Feedback Analyzer Skill

## Objective

Parse machine-generated feedback from CI systems, linting bots, coverage tools, and security scanners into a structured, human-readable list of fix tasks.

---

# Workflow

## Step 1 — Identify All Bot Sources

Collect feedback from:
- CI check run logs (GitHub Actions, CircleCI, etc.)
- Linting bots (ruff, flake8, black, isort, eslint, prettier)
- Test runners (pytest, jest, vitest)
- Coverage bots (codecov, coveralls)
- Security scanners (bandit, snyk, dependabot)
- Type checkers (mypy, pyright, tsc)
- Dependency auditors (safety, pip-audit)

---

## Step 2 — Parse Linting Errors

For each linting failure:
- Extract the rule code (e.g., `E501`, `NIC002`, `SIM105`)
- Extract the file path and line number
- Extract the error message
- Determine the fix action (format, rename, restructure, suppress)

Group errors by rule code to identify systematic issues vs. isolated cases.

---

## Step 3 — Parse Test Failures

For each failed test:
- Extract the test name and file
- Extract the failure message and traceback
- Classify failure type:
  - `AssertionError`: test expectation not met
  - `ImportError`: missing dependency or broken import
  - `AttributeError/TypeError`: API mismatch
  - `Exception`: unexpected runtime error
- Determine whether the failure is in the test itself or the code under test

---

## Step 4 — Parse Coverage Drops

If a coverage bot reported:
- Extract the coverage percentage before and after
- Identify which files have reduced coverage
- Identify which lines are newly uncovered
- Determine the minimum coverage threshold (if configured)
- Flag if the drop is blocking merge

---

## Step 5 — Parse Type Checker Errors

For mypy/pyright/tsc failures:
- Extract the file, line, and error code
- Identify the type mismatch or missing annotation
- Determine whether a type annotation fix or a code logic fix is needed

---

## Step 6 — Parse Security Scanner Findings

For bandit/snyk/dependabot findings:
- Extract severity level
- Extract the affected file and line
- Describe the vulnerability
- Note whether the finding is on new code introduced by the PR or pre-existing

---

## Step 7 — Produce Fix Task List

For each finding:
- Assign a fix category: `lint-fix`, `test-fix`, `coverage-fix`, `type-fix`, `security-fix`
- Write a concrete fix description (what exactly needs to change)
- Estimate fix complexity: `trivial` (1 line), `simple` (< 10 lines), `complex` (refactor needed)
- Order by: blocking checks first, then severity, then complexity

---

# Output Format

Bot Feedback Analysis:
- CI check status table (pass/fail per check)
- Linting errors (grouped by rule, with file:line references)
- Test failures (with failure classification and fix hints)
- Coverage report (delta, affected files)
- Type errors (with fix type)
- Security findings (with severity)
- Ordered fix task list (blocking first)
- Estimated total fix effort: [trivial | 30 min | 1 hour | half-day]
