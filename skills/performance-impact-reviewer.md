---
name: performance-impact-reviewer
description: Reviews performance implications of pull request changes — assessing algorithmic complexity, hot path impact, memory usage, and unnecessary computational overhead introduced by the diff. Use when changes touch performance-sensitive code.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Performance Impact Reviewer Skill

## Objective

Identify performance regressions or inefficiencies introduced specifically by the PR diff, and suggest more efficient alternatives where applicable.

---

# Workflow

## Step 1 — Identify Performance-Sensitive Paths

Flag changed code that operates in:
- Inner loops or recursive functions
- Hot paths called per-request, per-file, or per-function in bulk processing
- Database query construction or ORM usage
- Network I/O or file I/O operations
- Large collection manipulation (sorts, filters, aggregations)
- Feature extraction or matching engines

---

## Step 2 — Analyze Algorithmic Complexity

For changed functions:
- Estimate Big-O time complexity
- Compare to the previous implementation (if visible in the diff context)
- Flag regressions: O(n) → O(n²), O(1) → O(n), etc.
- Identify opportunities to improve complexity (e.g., nested loops solvable with a hash map)

---

## Step 3 — Check Loop Efficiency

In loops and comprehensions:
- Flag redundant computation moved outside the loop
- Identify repeated attribute lookups that should be cached (e.g., `len(x)` in a loop condition)
- Check for unnecessary list/set creation when a generator suffices
- Identify repeated database or file reads inside a loop

---

## Step 4 — Check Memory Usage

Assess:
- Large data structures allocated unnecessarily
- Unbounded accumulation in collections (e.g., appending to a list without limit)
- Copies of large objects when mutation or reference sharing would suffice
- Streaming vs. loading entire file into memory

---

## Step 5 — Check I/O Efficiency

Review:
- Repeated opens/closes of the same file
- Sequential reads that should be batched
- N+1 query patterns in database access
- Missing connection or resource pooling

---

## Step 6 — Check Index and Lookup Patterns

For search and lookup operations:
- Linear scans (O(n)) that should use a hash map or set (O(1))
- Repeated `in` checks on lists vs. sets
- Bytes/string pattern matching that can be pre-indexed
- Pre-computation opportunities for repeated calculations

---

## Step 7 — Assess Impact in Context

Estimate impact severity based on call frequency:
- Called once per binary analysis: low impact even if O(n)
- Called once per function (thousands of times): medium impact
- Called once per instruction (millions of times): high impact even for small overhead

---

# Severity Classification

- **Blocking**: O(n²) or worse in a hot path; N+1 query patterns in bulk operations
- **Suggested**: Missed O(1) optimization; unnecessary allocations in loops
- **Nitpick**: Minor constant-factor improvements; stylistic loop reformulations

---

# Output Format

Performance Impact Review:
- Hot paths affected (list)
- Complexity analysis per changed function
- Memory usage concerns
- I/O efficiency issues
- Index and lookup pattern improvements
- Overall performance verdict (No Regression / Minor Concern / Regression Detected)
- Suggested optimizations with before/after pseudocode where applicable
