---
name: maintainability-reviewer
description: Reviews long-term maintainability of pull request changes — evaluating coupling, cohesion, extensibility, technical debt introduced, and whether the code will be easy to modify in the future. Use during full PR reviews.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Maintainability Reviewer Skill

## Objective

Evaluate whether the changes in a PR leave the codebase easier or harder to maintain over time.

This is a forward-looking assessment about future developer experience, not just current correctness.

---

# Workflow

## Step 1 — Assess Readability for Future Developers

Ask:
- Can a developer unfamiliar with this code understand it in under 5 minutes?
- Are the intent and constraints of the code clear from reading it?
- Is there implicit knowledge required that is not documented?

---

## Step 2 — Evaluate Coupling

Check:
- Does the change create hidden dependencies between modules?
- Are there direct references to internal implementation details of other modules?
- Would changing one module require changes in many others (ripple effect)?
- Are there global variables or shared state introduced?

---

## Step 3 — Evaluate Cohesion

Assess:
- Do changed classes/functions have a single, clear responsibility?
- Are unrelated concerns mixed in the same function or class?
- Is there a god-object or mega-function growing larger with this PR?

---

## Step 4 — Evaluate Technical Debt Introduced

Look for:
- TODO/FIXME comments without issue tracking references
- Workarounds labeled as "temporary" with no clear path to removal
- Copy-paste duplication introduced (first instance is OK; second demands extraction)
- Hardcoded values that will need changing in the future
- String literals that should be constants or config

---

## Step 5 — Evaluate Testability

Check:
- Can the changed code be tested without setting up complex infrastructure?
- Are dependencies injectable or mockable?
- Are there hidden global side effects that make testing order-dependent?
- Is I/O tightly coupled to business logic (difficult to unit test)?

---

## Step 6 — Evaluate Extensibility

Assess:
- If requirements change in the next 6 months, how much of this code needs to be rewritten?
- Are extension points available where new behavior is likely to be added?
- Is the code open for extension and closed for modification in stable areas?

---

## Step 7 — Evaluate Backward Compatibility

Check:
- Are any public APIs or interfaces changed in a breaking way?
- Are deprecation warnings provided for removed or changed interfaces?
- Will existing callers of changed functions need to be updated?

---

# Severity Classification

- **Blocking**: Breaking public API without deprecation; global state mutations; untestable design
- **Suggested**: Missed extraction opportunity; coupling that increases ripple risk
- **Nitpick**: Naming, structural, or organizational improvements for clarity

---

# Output Format

Maintainability Review:
- Readability assessment
- Coupling concerns (list)
- Cohesion assessment
- Technical debt introduced
- Testability verdict
- Extensibility outlook
- Backward compatibility check
- Overall maintainability verdict (Good / Acceptable / Needs Improvement)
