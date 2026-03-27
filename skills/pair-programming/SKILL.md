---
name: pair-programming
version: 1.0.0
description: |
  Structured pair programming workflow with Claude as co-pilot. Two modes:
  Navigator (you drive, Claude navigates with suggestions and catches) and
  Driver (Claude implements, you review each step). Includes red-green-refactor
  TDD pairing, code review pairing, and debugging pairing sessions.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion]
---

# Pair Programming

Structured collaborative coding with Claude. Two programmers (you + Claude) working on the same problem at the same time, each contributing what they do best.

---

## Two Modes

### Navigator Mode (You Drive)
You write the code. Claude watches and:
- Spots bugs before you run the code
- Suggests better approaches when you get stuck
- Asks clarifying questions about intent
- Tracks the bigger picture while you focus on current line
- Catches naming issues, missing error handling, security holes

**Activation**: "I'm going to write [feature]. Watch as I work and flag any issues."

### Driver Mode (Claude Drives)
Claude writes the code. You:
- Set direction at each decision point
- Approve or redirect each significant change
- Keep Claude on track with project conventions
- Catch anything that doesn't match your mental model

**Activation**: "Implement [feature], but explain each step and wait for my okay before the next."

---

## TDD Pairing (Red-Green-Refactor)

The most effective pair programming pattern with AI:

### Red Phase (Write Failing Test)
```
You: "Let's implement user authentication. Write the test first."
Claude: Writes failing test that describes desired behavior
You: Confirm the test captures requirements → "Yes, run it"
Claude: Runs test, confirms it fails for the right reason
```

### Green Phase (Make It Pass)
```
Claude: "Here's the minimal implementation to make the test pass:"
[writes simplest possible code]
You: Review — is this the right approach? Any shortcuts?
Claude: Runs test, confirms it passes
```

### Refactor Phase
```
You: "The implementation works but [naming/structure concern]"
Claude: Proposes refactor
You: Approve or redirect
Claude: Refactors while keeping test green
```

---

## Debugging Pairing

When stuck on a bug, use structured pair debugging:

```
Step 1 — State the hypothesis
You: "I think the bug is in [location] because [reason]"
Claude: Evaluates hypothesis — agrees or challenges with evidence

Step 2 — Design the probe
Claude: "To confirm/deny: add this log/test/assertion: [specific thing]"
You: Add the probe, share the output

Step 3 — Interpret results
You: [paste output]
Claude: Interprets, updates hypothesis

Step 4 — Repeat until root cause found
```

---

## Code Review Pairing

Review code together before committing:

```
You: "Review this before I commit: [paste code or file path]"
Claude: Reviews line by line, flags:
  - Bugs and edge cases
  - Security concerns
  - Performance issues
  - Naming and clarity
  - Missing tests
  - Style inconsistencies

You: For each flag, decide: fix, explain, or defer
Claude: Makes approved fixes, documents deferred items
```

---

## Communication Patterns

**Navigator gives directions, not orders:**
- "I'm thinking we should handle the error case here" (not "add error handling")
- "What happens if the user is null?" (not "add null check")
- "This function is doing two things" (not "refactor this")

**Driver communicates before acting:**
- "I'm going to add a helper function for this — does that make sense?"
- "I could go either way on the naming — `fetchUser` or `getUser`?"
- "Before I implement this, do we have existing utilities for X?"

---

## Session Start Checklist

Before pairing begins:
1. What are we building? (clear goal)
2. What's the acceptance criteria? (how do we know we're done?)
3. Are there existing patterns to follow? (check codebase first)
4. Which mode: Navigator or Driver?
5. Time box: how long is this session?

---

## Activation

```
"Let's pair on [task] — you drive, I'll navigate"
"Pair with me on [task] — I'll drive, watch for issues"
"TDD pair: implement [feature] test-first"
"Debug pair: I have a bug in [file], let's figure it out together"
```
