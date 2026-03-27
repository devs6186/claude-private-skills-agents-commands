---
name: swarm-orchestration
version: 1.0.0
description: |
  Orchestrate multi-agent swarms for parallel task execution. Supports three
  topologies: Hierarchical (coordinator + specialized workers), Mesh (peer-to-peer),
  and Adaptive (dynamic reconfiguration). Use for large codebases, complex
  multi-workstream tasks, or any work that benefits from parallel agent execution.
  Includes load balancing, fault tolerance, and collective memory.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Agent, TodoWrite]
---

# Swarm Orchestration

Run multiple specialized agents in parallel, coordinating their work through structured topologies. Swarms are best for tasks too large or complex for a single agent.

---

## When to Use Swarms

- Task has clearly separable workstreams (module A, module B, module C)
- Codebase is large enough that full context doesn't fit in one agent
- Parallel research across multiple domains needed
- Different phases can proceed simultaneously (tests while implementation runs)
- Speed matters and the work is parallelizable

---

## Three Topologies

### 1. Hierarchical (Default)
One coordinator agent directs specialized worker agents.

```
Coordinator
├── Researcher agents (gather information)
├── Coder agents (implement)
├── Tester agents (validate)
└── Reviewer agents (quality check)
```

Best for: Structured projects with clear phases, when order matters.

### 2. Mesh (Peer-to-Peer)
All agents communicate directly, no single coordinator.

```
Agent-A ↔ Agent-B ↔ Agent-C
    ↕           ↕
Agent-D ↔ Agent-E
```

Best for: Research tasks, brainstorming, when multiple independent perspectives are valuable.

### 3. Adaptive
Topology changes dynamically based on task progress and agent load.

Best for: Long-running complex tasks where requirements evolve.

---

## Agent Types

| Type | Role | Spawned When |
|------|------|-------------|
| `coordinator` | Routes work, aggregates results | Always (hierarchical) |
| `coder` | Writes implementation code | Active workstreams |
| `tester` | Writes and runs tests | After each implementation phase |
| `reviewer` | Code quality, patterns, security | After implementation |
| `architect` | System design decisions | Design phases |
| `researcher` | Gathers information, investigates | Unknown domains |
| `security-architect` | Threat modeling, CVE review | Any security-critical work |
| `performance-engineer` | Optimization, profiling | Performance phases |

---

## Task Execution Strategies

### Parallel (All at Once)
All tasks start simultaneously. Use when tasks are fully independent.

```
Agent("coder-auth", "Implement authentication module")
Agent("coder-api", "Implement REST API endpoints")
Agent("coder-db", "Implement database layer")
```

### Pipeline (Sequential)
Each task feeds the next. Use when outputs are inputs to next stage.

```
1. Agent("researcher", "Analyze requirements") → findings
2. Agent("architect", "Design system using: [findings]") → blueprint
3. Agent("coder", "Implement: [blueprint]") → code
```

### Adaptive (Mixed)
Start with parallel where possible, serialize only when blocked.

```
[researcher + architect] (parallel)
→ wait for both
→ [coder-module-A + coder-module-B] (parallel, both using arch output)
→ [tester] (sequential, needs both coders done)
```

---

## Collective Memory

All agents in a swarm share a memory namespace. Pass context explicitly:

```markdown
## Swarm Context (pass to all agents)
- Task: [description]
- Architecture decisions: [summary]
- Shared state: [key facts all agents need]
- Agent outputs so far: [running log]
```

Each agent appends its findings to the shared context before completing.

---

## Spawning a Swarm

### Example: Full Feature Swarm

```
Step 1 — Initialize (define scope):
  Agent("coordinator", "Break this feature into parallel workstreams: [task]")

Step 2 — Parallel implementation:
  Agent("coder-A", "Implement module A per coordinator output")
  Agent("coder-B", "Implement module B per coordinator output")
  Agent("tester", "Write test suite as modules are built")
  Agent("security-architect", "Review each module for vulnerabilities")

Step 3 — Consolidation:
  Agent("reviewer", "Review all agent outputs, identify conflicts")
  Agent("coordinator", "Integrate all workstreams into final result")
```

---

## Load Balancing

- Max agents: 8 parallel (beyond this, overhead exceeds benefit)
- Assign smaller tasks to agents with faster history
- If an agent stalls: re-assign its remaining work to another agent
- Always have one coordinator monitoring overall progress

---

## Fault Tolerance

- If an agent fails: log the failure, re-assign the task
- Checkpoint outputs after each phase so failed work is not lost
- Prefer agents failing loudly over silently continuing with wrong assumptions

---

## Anti-Patterns

- **Too many agents**: 8+ agents for a simple task adds coordination overhead
- **Shared mutable state**: Agents overwriting each other's work → use namespaced outputs
- **No consolidation phase**: Parallel work that's never integrated is wasted
- **Coordinator doing work**: Coordinator coordinates; it doesn't implement

---

## Activation

Start a swarm with: `/orchestrate [task description]`

Or invoke directly:
```
Agent("coordinator", "Orchestrate a swarm to: [task]")
```
