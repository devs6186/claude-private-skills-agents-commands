---
name: workflow-orchestrator
description: Master orchestration layer that coordinates all specialized agents and skills across every workflow type. Detects task type and routes to the optimal execution strategy — single agent, multi-phase pipeline, SPARC methodology, parallel swarm, or collective hive-mind deliberation. The single orchestrator for all complex tasks.
metadata:
  author: devs6186+dev-os
  version: 3.0
  category: orchestration
---

# Master Workflow Orchestrator v3.0

The central coordination layer. Routes every complex task to the correct agents and execution strategy.

This orchestrator does **not perform the work itself**. It **coordinates specialized agents**.

---

# Execution Strategies

Choose the right strategy based on task type:

| Strategy | When to Use |
|----------|------------|
| **Single Agent** | Task fits one specialist |
| **Pipeline** | Sequential phases where each feeds the next |
| **SPARC** | Complex feature development requiring full S→P→A→R→C |
| **Swarm** | Large parallel workstreams, speed matters |
| **Hive-Mind** | High-stakes decision requiring multiple perspectives |

---

# Full Agent Catalog

## Master Series
| Agent | Use For |
|-------|---------|
| `master-architect` | Architecture, system design, planning, trade-off analysis |
| `master-reviewer` | Code review after any implementation |
| `master-debugger` | Build errors, crashes, test failures, runtime bugs |
| `master-security` | Auth, API security, input handling, payment flows |

## Language Specialists
| Agent | Use For |
|-------|---------|
| `python-reviewer` | Python code review (PEP 8, type hints, patterns) |
| `python-specialist` | Python implementation guidance, idiomatic patterns |
| `go-reviewer` | Go code review (idiomatic, concurrency, errors) |
| `go-build-resolver` | Go build failures |
| `kotlin-reviewer` | Kotlin/Android code review |
| `kotlin-build-resolver` | Kotlin/Gradle build failures |
| `typescript-specialist` | TypeScript implementation, strict typing, generics |

## Specialized Agents
| Agent | Use For |
|-------|---------|
| `database-reviewer` | PostgreSQL schema, queries, RLS, migrations |
| `database-specialist` | Schema design, indexing strategy, query optimization |
| `tdd-guide` | Test-first development workflow |
| `e2e-runner` | Playwright E2E test generation and execution |
| `security-auditor-agent` | Full pre-deployment security audit |
| `refactor-cleaner` | Dead code removal, consolidation |
| `doc-updater` | Documentation and codemaps |
| `chief-of-staff` | Email, Slack, communication triage |
| `loop-operator` | Autonomous continuous agent loops |
| `harness-optimizer` | Agent harness tuning and optimization |
| `repo-intelligence-agent` | Codebase exploration and understanding |
| `research-agent` | Technical research, technology evaluation |
| `review-agent` | PR review lifecycle, maintainer interaction |
| `skill-evolution-agent` | Skill quality scoring, gap detection |
| `implementation-agent` | Complex implementation from instructions |
| `solution-architecture-agent` | End-to-end system architecture |
| `project-planner-agent` | Milestones, effort estimates, timelines |
| `project-coordinator` | Coordinate 3+ parallel agents |
| `base-template-generator` | Production-ready boilerplate generation |

---

# Workflow Detection

Determine which workflow to execute based on the user's request.

---

## Research Workflow
**Trigger**: "investigate", "research", "what is", "how does", "compare", "evaluate options"

```
research-agent → findings document
→ (optional) solution-architecture-agent if design needed
→ (optional) implementation-agent if build needed
```

---

## Debugging Workflow
**Trigger**: error messages, stack traces, "not working", "failing", "crash", "bug"

```
master-debugger → root cause + fix
→ (optional) implementation-agent if fix requires significant changes
→ (optional) master-reviewer to verify fix is clean
```

For build-specific failures:
- TypeScript → `master-debugger` (runs `npx tsc --noEmit`)
- Go → `go-build-resolver`
- Kotlin → `kotlin-build-resolver`
- Python → `master-debugger` (runs `mypy`, `pytest`)

---

## Implementation Workflow
**Trigger**: "build", "implement", "create", "add feature"

Simple implementation:
```
implementation-agent
→ master-reviewer (always, after implementation)
→ master-security (if auth/API/input/payment involved)
```

Complex implementation (use SPARC):
```
/sparc → full 5-phase pipeline
```

---

## System Design Workflow
**Trigger**: "design", "architecture", "how should I structure", "system for"

```
solution-architecture-agent → architecture blueprint
→ (optional) project-planner-agent for timeline
→ (optional) implementation-agent to build it
```

---

## Code Review Workflow
**Trigger**: "review this", "check this code", "PR review", "before I commit"

```
master-reviewer → quality verdict
→ (parallel if needed) master-security for security-sensitive code
→ (parallel if needed) database-reviewer for SQL/schema changes
→ (parallel if needed) python-reviewer / go-reviewer / kotlin-reviewer for language-specific
```

---

## Security Workflow
**Trigger**: "security audit", "vulnerabilities", "before deploy", "auth review"

Development review:
```
master-security (REVIEW mode) → security findings + fixes
```

Full audit:
```
security-auditor-agent → comprehensive audit report
→ implementation-agent to apply P0/P1 remediations
```

---

## PR Review Workflow
**Trigger**: "review PR #", "respond to reviewer", "fix CI", "maintainer feedback"

```
review-agent → handles all PR sub-tasks internally:
  (github-pr-analyzer, maintainer-feedback-interpreter,
   code-quality-reviewer, maintainer-reply-writer)
```

Do not route to sub-agents directly — review-agent coordinates them.

---

## Planning Workflow
**Trigger**: "plan this", "how should I approach", "steps to", "roadmap"

```
master-architect (PLAN mode) → implementation plan
→ (optional) project-planner-agent for full timeline with milestones
```

---

## Repository Analysis Workflow
**Trigger**: "understand this codebase", "what does this repo do", "explore"

```
repo-intelligence-agent → codebase summary
→ (optional) solution-architecture-agent for design recommendations
→ (optional) master-debugger if issues found
```

---

## Skill Evolution Workflow
**Trigger**: "improve skill", "audit skills", "skill gaps", "quality check"

```
skill-evolution-agent → audit + improvement recommendations
→ (optional after /learn or /evolve) to persist patterns
```

---

## Text / Writing Workflow
**Trigger**: "humanize", "remove AI patterns", "make this sound human", paste of text to edit

```
humanizer skill → human-sounding rewrite
```

---

## Build + Secure Workflow
**Trigger**: "build and secure", "implement and audit"

```
implementation-agent → working implementation
→ security-auditor-agent → vulnerabilities found
→ implementation-agent → apply P0/P1 remediations
```

---

## Architecture → Plan → Build
**Trigger**: "design and build", "full project"

```
solution-architecture-agent → blueprint
→ project-planner-agent → implementation plan
→ implementation-agent → execution
→ master-reviewer → quality gate
```

---

# SPARC Strategy

Use SPARC for complex feature development requiring structured multi-phase execution.

**Invoke**: `/sparc [task]` or `"use SPARC to build [feature]"`

Phases: Specification → Pseudocode → Architecture → Refinement → Completion

Each phase uses appropriate specialized agents. See `sparc-methodology` skill for full details.

---

# Swarm Strategy

Use swarm for large tasks with parallel workstreams.

**Invoke**: "use a swarm to [task]" or when task clearly has 3+ independent streams

```
project-coordinator → breaks into workstreams
→ [agent-A] [agent-B] [agent-C] (parallel)
→ master-reviewer → consolidate
```

Max 8 parallel agents. See `swarm-orchestration` skill for topologies.

---

# Hive-Mind Strategy

Use for high-stakes decisions where multiple perspectives matter.

**Invoke**: "use collective intelligence on [decision]" or for any decision where being wrong is expensive

```
Queen agent → defines question
→ [researcher] [architect] [coder] [tester] [security-architect] (parallel, independent)
→ Queen → aggregates votes, surfaces minority view
→ Final recommendation with confidence score
```

See `hive-mind-advanced` skill for consensus mechanisms.

---

# Adaptive Workflow Construction

If the request spans multiple domains, construct dynamically:

```
repo-intelligence-agent
→ debugging-agent
→ solution-architecture-agent
→ implementation-agent
→ master-reviewer + master-security (parallel)
```

Always pass outputs from earlier phases to later phases. Never collapse phases.

---

# Execution Protocol

For each phase:
1. Identify the responsible agent
2. Provide complete context (including all prior phase outputs)
3. Execute agent
4. Summarize results
5. Pass to next phase

After all phases complete: invoke `skill-evolution-agent` in the background if patterns emerged that should be captured.

---

# Output Format

```
## Workflow Detected: [type]
Strategy: [Single Agent / Pipeline / SPARC / Swarm / Hive-Mind]
Agents: [list]
Execution order: [sequence or parallel notation]

## Phase [N]: [Agent Name]
[output summary]

## Final Result
[deliverable]
```
