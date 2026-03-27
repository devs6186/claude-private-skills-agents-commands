---
name: sparc-methodology
version: 1.0.0
description: |
  SPARC multi-agent orchestration methodology for complex software tasks.
  Breaks objectives into five phases: Specification, Pseudocode, Architecture,
  Refinement, Completion. Use for complex feature development, system design,
  or any task requiring structured multi-phase execution with parallel agents.
  Supports 17 SPARC modes covering the full SDLC.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Agent, TodoWrite, WebSearch, WebFetch]
---

# SPARC Methodology

SPARC is a structured multi-agent orchestration framework for solving complex software problems. It decomposes work into five phases and routes each phase to specialized agents running in parallel where possible.

**SPARC = Specification → Pseudocode → Architecture → Refinement → Completion**

---

## The Five Phases

### S — Specification
Define what needs to be built.
- Gather requirements (functional and non-functional)
- Identify constraints, edge cases, acceptance criteria
- Produce a precise, unambiguous specification document
- Output: `spec.md` with all requirements

### P — Pseudocode
Design the logic before writing code.
- Algorithm design in plain language
- Data structures and flow decisions
- Error handling strategy
- TDD: write test scenarios first
- Output: `pseudocode.md` with logic outline

### A — Architecture
Design the system structure.
- Component decomposition
- Interface contracts between components
- Data model and storage decisions
- API design
- Deployment topology
- Output: `architecture.md` with diagrams and decisions

### R — Refinement
Implement and improve.
- Write production code following architecture
- Security review and hardening
- Performance optimization
- Code review pass
- Output: working implementation + tests

### C — Completion
Finalize and deliver.
- Integration testing
- Documentation
- Deployment preparation
- Final validation
- Output: production-ready deliverable

---

## 17 SPARC Modes

| Mode | Purpose | Use When |
|------|---------|----------|
| `orchestrator` | Coordinates all other SPARC agents | Starting any complex multi-phase task |
| `swarm-coordinator` | Manages parallel agent swarms | Parallel workstreams needed |
| `workflow-manager` | Sequences dependent tasks | Strict ordering required |
| `batch-executor` | Runs many similar tasks | Bulk operations |
| `coder` | Implements code from spec | Writing production code |
| `architect` | Designs system structure | Architecture phase |
| `tdd` | Test-first implementation | When quality is critical |
| `reviewer` | Code quality review | After implementation |
| `researcher` | Investigates unknowns | Unknown technology/approach |
| `analyzer` | Root-cause analysis | Debugging complex issues |
| `optimizer` | Performance/efficiency | After working implementation |
| `designer` | UX/API interface design | User-facing components |
| `innovator` | Novel solution generation | Stuck on a hard problem |
| `documenter` | Writes documentation | Public APIs or user flows |
| `debugger` | Systematic bug investigation | Failing tests or crashes |
| `tester` | Test suite development | Comprehensive test coverage |
| `memory-manager` | Persists patterns across sessions | Long-running projects |

---

## Orchestration Patterns

### Standard Feature Development
```
orchestrator
  → researcher (unknown dependencies)
  → architect (system design)
  → [coder + tdd] (parallel: implementation + tests)
  → reviewer (quality check)
  → documenter (if public API)
```

### Complex Debugging
```
orchestrator
  → analyzer (root cause)
  → researcher (if unfamiliar domain)
  → coder (fix implementation)
  → tester (regression suite)
  → reviewer (verify fix is clean)
```

### System Design
```
orchestrator
  → researcher (technology evaluation)
  → architect (structure design)
  → [designer + coder] (parallel: interface + core)
  → reviewer + tester (validation)
```

### Parallel Swarm (Large Codebase)
```
swarm-coordinator
  → [coder-1: module A] [coder-2: module B] [coder-3: module C]  (parallel)
  → [tester-1: unit] [tester-2: integration]  (parallel)
  → reviewer (consolidate)
```

---

## Agent Invocation

Use Claude Code's Agent tool to invoke SPARC agents:

```
# Parallel invocation (preferred)
Agent("researcher", "Investigate best approach for X")
Agent("architect", "Design the system for Y given researcher findings")

# Sequential when dependent
1. Agent("researcher", "Find all existing patterns for X")
2. Agent("architect", "Design based on researcher output: [findings]")
3. Agent("coder", "Implement the architecture: [blueprint]")
```

---

## Memory Integration

After each phase, store outputs for subsequent phases:

```
Phase output → Pass as context to next agent
Key decisions → Document in plan.md
Patterns discovered → Available for future sessions via /learn
```

---

## Quality Gates Between Phases

- **S → P**: Specification reviewed and unambiguous
- **P → A**: Logic validated, no unresolved edge cases
- **A → R**: Architecture agreed, no circular dependencies
- **R → C**: All tests pass, security reviewed
- **C → Done**: Integration tests pass, docs updated

---

## Anti-Patterns to Avoid

- Skipping Specification: "Just write the code" leads to wasted refactoring
- Monolithic implementation: One agent doing everything loses parallelism benefit
- No memory between phases: Losing context = repeating work
- Skipping the reviewer mode: Code quality degrades without review gates
- Over-engineering the Pseudocode phase: Keep it light, move to Architecture quickly

---

## Activation

Invoke with: `/sparc [mode] [task description]`

Examples:
- `/sparc` — Full SPARC pipeline for the current task
- `/sparc architect` — Architecture phase only
- `/sparc tdd` — TDD implementation mode
- `/sparc swarm-coordinator` — Parallel agent swarm
- `/sparc reviewer` — Code review pass only
