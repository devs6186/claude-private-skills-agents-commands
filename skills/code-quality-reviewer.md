---
name: code-quality-reviewer
description: Reviews code quality in a pull request diff — checking style, naming conventions, complexity, readability, antipatterns, and adherence to project linting rules. Use during full PR reviews or targeted quality checks.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Code Quality Reviewer Skill

## Objective

Evaluate the code quality of changes in a PR diff, identifying issues across style, complexity, naming, and project conventions before the code reaches maintainers.

---

# Workflow

## Step 1 — Load Project Conventions

Before reviewing, identify the project's style rules:
- Linting config files (`.flake8`, `ruff.toml`, `.eslintrc`, `pyproject.toml`)
- Formatter settings (`black`, `prettier`)
- Naming conventions from existing codebase patterns
- CONTRIBUTING.md or CLAUDE.md style guidelines

---

## Step 2 — Review Naming and Clarity

Check:
- Variable and function names are descriptive and follow conventions (snake_case, camelCase, etc.)
- No single-letter variables outside tight loops
- Boolean names start with `is_`, `has_`, `can_`, or similar predicates
- Class names are PascalCase (for OOP projects)
- Constants are UPPER_SNAKE_CASE

---

## Step 3 — Review Complexity

Evaluate:
- Function length: flag functions > 50 lines as candidates for decomposition
- Cyclomatic complexity: flag functions with > 5 branches or deeply nested blocks
- Cognitive load: identify code that is hard to follow even when correct
- Excessive parameter counts: flag functions with > 5 parameters

---

## Step 4 — Review Code Patterns

Check for antipatterns:
- Magic numbers and strings (should be named constants)
- Duplicated logic that should be extracted
- Unnecessary negation in conditions (`not x is None` vs. `x is not None`)
- Premature optimization or unnecessary cleverness
- Over-engineering: abstractions with one callsite
- Mutable default arguments in Python (`def f(x=[])`)
- Shadowing built-in names

---

## Step 5 — Review Import and Dependency Usage

Check:
- Unused imports
- Import ordering compliance with project rules (isort, etc.)
- Importing from internal modules that should stay private
- Circular imports introduced by the diff

---

## Step 6 — Review Error Handling

Evaluate:
- Bare `except:` without specifying exception type
- Swallowed exceptions without logging
- Over-broad exception catching
- Missing error messages in raises
- Project-specific exception patterns (e.g., `contextlib.suppress` preference)

---

## Step 7 — Review Comments and Inline Docs

Check:
- Commented-out code left in the diff
- TODO/FIXME/HACK markers without issue references
- Misleading or outdated comments
- Docstrings missing for public functions/classes added in the diff

---

# Severity Classification

- **Blocking**: Linting violations, antipatterns that will break CI, project convention violations
- **Suggested**: Style improvements that don't affect correctness
- **Nitpick**: Minor preferences, optional cleanup

---

# Output Format

Code Quality Report:
- Overall quality rating (Excellent / Good / Needs Work / Poor)
- Blocking issues (with file:line references)
- Suggested improvements
- Nitpicks
- Compliance with project linting rules (pass/fail per rule category)
