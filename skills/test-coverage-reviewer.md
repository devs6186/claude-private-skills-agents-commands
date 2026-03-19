---
name: test-coverage-reviewer
description: Evaluates whether new code in a pull request is adequately tested — checking test presence, quality, edge case coverage, and assertion depth. Use during PR reviews or when CI reports a coverage drop.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Test Coverage Reviewer Skill

## Objective

Determine whether the PR's changes are adequately covered by tests, and identify specific missing test scenarios.

---

# Workflow

## Step 1 — Map Changed Code to Tests

For every changed source file:
- Identify the corresponding test file(s)
- Check whether tests were added, modified, or unchanged
- Flag source changes with no accompanying test changes

---

## Step 2 — Evaluate Test Presence

Check:
- New public functions/methods have at least one test
- New classes have tests covering their primary behaviors
- Bug fixes include a regression test that would have caught the bug
- New edge cases or error paths are tested

---

## Step 3 — Evaluate Test Quality

Assess:
- Tests contain meaningful assertions (not just `assert result is not None`)
- Tests cover the happy path and at least one failure/edge case
- Test names clearly describe what is being tested
- Tests are not testing implementation details (brittle tests)
- Tests do not depend on external state, network, or filesystem unless marked as integration tests

---

## Step 4 — Evaluate Edge Cases

Identify scenarios not covered:
- Empty input, None/null values, zero, empty collections
- Maximum/minimum boundary values
- Invalid types passed to functions
- Exception paths and error conditions
- Concurrent or re-entrant usage (if applicable)

---

## Step 5 — Evaluate Assertion Depth

Check:
- Are the right properties being asserted?
- Are side effects verified, not just return values?
- Are error messages and exception types verified?
- Are call counts or invocation patterns verified where relevant?

---

## Step 6 — Check for Test Infrastructure Issues

Look for:
- Tests that always pass regardless of correctness (vacuous tests)
- Mocks that are too permissive and hide real bugs
- Tests that test the mock rather than the real behavior
- Flaky tests introduced (sleep-based timing, uncontrolled external state)

---

## Step 7 — Estimate Coverage Impact

Based on the diff:
- Estimate whether coverage will increase, stay flat, or drop
- Flag if new code paths have no test path reaching them
- Note if the PR relies on existing tests for coverage (acceptable if intentional)

---

# Severity Classification

- **Blocking**: Bug fix without regression test; new public API with zero tests
- **Suggested**: Missing edge case coverage; assertion depth insufficient
- **Nitpick**: Test naming, organization, or style improvements

---

# Output Format

Test Coverage Review:
- Coverage verdict (Adequate / Partial / Insufficient)
- Missing tests (with suggested test descriptions)
- Weak assertions identified
- Edge cases not covered
- Test quality issues
- Estimated coverage impact (increase / flat / drop)
