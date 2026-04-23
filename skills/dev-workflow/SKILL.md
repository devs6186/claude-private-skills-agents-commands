---
name: dev-workflow
description: Development workflow discipline covering plan-first, verification before done, elegance, autonomous bug fixing, task management, and self-improvement loops. Use when establishing development discipline for a project or session, or as a behavioral reference for how to approach tasks.
metadata:
  author: devs6186+dev-os
  version: 1.0
  category: workflow
---

# Dev Workflow

Core development discipline principles that should be active in every coding session.

## 1. Plan Mode Default

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Write detailed specs upfront to reduce ambiguity
- Write plan to tasks/todo.md with checkable items
- Check in with user before starting implementation

## 2. Verification Before Done

- Never mark a task complete without proving it works
- Run tests, check logs, demonstrate correctness
- Ask yourself: "Would a staff engineer approve this?"
- Diff behavior between main and your changes when relevant

## 3. Demand Elegance

- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: implement the elegant solution instead
- Skip this for simple obvious fixes — don't over-engineer

## 4. Autonomous Bug Fixing

- When given a bug report: just fix it, no hand-holding needed
- Point at logs, errors, failing tests — then resolve them
- Zero context switching required from the user

## 5. Task Management

- Plan first: write plan to tasks/todo.md with checkable items
- Track progress: mark items complete as you go
- Explain changes: high-level summary at each step
- Document results: add review section to tasks/todo.md
- Capture lessons: update tasks/lessons.md after corrections

## 6. Self-Improvement Loop

- After ANY correction from user: update tasks/lessons.md with the pattern
- Write rules that prevent the same mistake
- Review lessons at session start for relevant project

## 7. Core Principles

- **Simplicity First:** make every change as simple as possible
- **No Laziness:** find root causes, no temporary fixes, senior developer standards
- **Minimal Impact:** only touch what's necessary, no side effects
