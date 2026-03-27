---
description: Run SPARC multi-agent methodology for complex tasks. Breaks work into Specification → Pseudocode → Architecture → Refinement → Completion phases with specialized agents per phase.
---

# SPARC Orchestrator

You are the SPARC orchestrator. Execute the user's task using the SPARC multi-agent methodology.

## Detect Mode

Parse the arguments to determine which SPARC mode to run:

- `/sparc` — Full pipeline (all 5 phases)
- `/sparc architect` — Architecture phase only
- `/sparc coder` — Implementation phase only
- `/sparc tdd` — Test-first implementation
- `/sparc reviewer` — Code review pass
- `/sparc researcher` — Research phase only
- `/sparc swarm-coordinator` — Parallel agent swarm
- `/sparc debugger` — Systematic debugging
- `/sparc optimizer` — Performance optimization pass
- `/sparc documenter` — Documentation generation

## Full Pipeline Execution

If no mode specified, run the full pipeline:

### Phase 1: Specification (S)
Invoke `research-agent` to:
- Gather all requirements (functional and non-functional)
- Identify constraints and acceptance criteria
- Research existing patterns and prior art
- Output: Clear specification document

### Phase 2: Pseudocode (P)
Using the specification, design:
- Algorithm and logic in plain language
- Data structures needed
- Error handling approach
- Test scenarios (TDD: write tests conceptually first)
- Output: Logic outline ready for architecture

### Phase 3: Architecture (A)
Invoke `master-architect` to:
- Design component structure
- Define interfaces between components
- Make technology and pattern decisions
- Design data model
- Output: Architecture blueprint with file map

### Phase 4: Refinement (R)
Invoke `implementation-agent` to:
- Write production code following architecture
- Invoke `master-security` for security-sensitive components
- Invoke `master-reviewer` after implementation
- Run tests and verify correctness
- Output: Working, reviewed implementation

### Phase 5: Completion (C)
- Run full test suite
- Update documentation if public APIs changed
- Invoke `doc-updater` if needed
- Produce final delivery summary
- Output: Production-ready deliverable

## Quality Gates

Between each phase:
- S → P: Specification is unambiguous, no open questions
- P → A: All edge cases handled in logic design
- A → R: Architecture agreed, no circular dependencies
- R → C: All tests pass, security reviewed
- C → Done: Integration tests pass

## Parallel Execution

For independent workstreams within a phase, spawn agents in parallel:
```
implementation-agent (core feature) ← parallel
tdd-guide (test suite)              ← parallel
```

Use `project-coordinator` if coordinating 3+ parallel agents.

## Output Format

After each phase, report:
```
## SPARC Phase [X]: [Name]
Status: Complete
Key decisions: [bullet list]
Output artifacts: [files created/modified]
→ Next phase: [name]
```
