---
name: architecture-decision-reviewer
description: Reviews architectural decisions introduced in a pull request — evaluating structural choices, design pattern alignment, abstraction quality, and compatibility with existing system architecture. Use when a PR introduces new components, patterns, or structural changes.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Architecture Decision Reviewer Skill

## Objective

Evaluate whether the architectural choices in a PR are sound, consistent with the existing codebase, and appropriate for the problem being solved.

---

# Workflow

## Step 1 — Understand Existing Architecture

Before reviewing the diff, survey:
- Existing module structure and boundaries
- Current design patterns in use (factory, strategy, observer, etc.)
- Dependency direction (which layers import from which)
- Public interfaces and extension points

---

## Step 2 — Identify Structural Changes

In the diff, locate:
- New classes, modules, or packages
- Changes to public interfaces or function signatures
- New abstractions (base classes, protocols, interfaces)
- Dependency additions or removals

---

## Step 3 — Evaluate Design Pattern Alignment

Check:
- Does the PR introduce a pattern consistent with how similar problems are solved elsewhere?
- Is the pattern appropriate for the problem (not over-engineered, not under-designed)?
- Are there existing utilities or patterns in the codebase that could have been reused?

---

## Step 4 — Evaluate Abstraction Quality

Assess:
- Is the abstraction at the right level? (too broad = leaky; too narrow = premature)
- Does the new abstraction have more than one callsite? (single-use abstractions are usually wrong)
- Is the abstraction adding cognitive overhead without benefit?
- Does the interface make the code easier to test?

---

## Step 5 — Evaluate Coupling and Cohesion

Check:
- Does the change increase coupling between modules that should be independent?
- Do new classes have a single, clear responsibility?
- Are there cross-cutting concerns (logging, error handling) that should be centralized but aren't?

---

## Step 6 — Evaluate Dependency Direction

Verify:
- Core logic does not depend on I/O, UI, or framework layers
- New dependencies flow in the correct direction (outer layers depend on inner layers)
- No circular imports or dependency cycles introduced

---

## Step 7 — Assess Scalability and Extensibility

Consider:
- Will the design handle future requirements without a full rewrite?
- Are extension points available where needed?
- Is the approach closed for modification in stable areas?

---

# Severity Classification

- **Blocking**: Dependency inversions, circular dependencies, interfaces that lock in wrong abstractions
- **Suggested**: Pattern inconsistency, missed reuse of existing utilities
- **Nitpick**: Naming or structural preferences that don't affect correctness

---

# Output Format

Architecture Review:
- Structural changes detected (list)
- Pattern alignment assessment
- Abstraction quality verdict
- Coupling and cohesion analysis
- Dependency direction check
- Blocking concerns
- Recommended improvements
