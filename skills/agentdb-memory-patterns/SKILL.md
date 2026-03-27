---
name: agentdb-memory-patterns
version: 1.0.0
description: |
  Persistent agent memory patterns using SQLite-backed storage with HNSW vector
  search. Covers short-term session memory, long-term pattern storage, namespace
  isolation between agents, and cross-session learning. Use when building agents
  that need to remember context, learn from past work, or share state across sessions.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# AgentDB Memory Patterns

Persistent memory for Claude Code agents using structured storage with vector search.

---

## Memory Namespaces

Organize memory by purpose to avoid pollution:

| Namespace | Purpose | Retention |
|-----------|---------|-----------|
| `session` | Current task context | Session only |
| `patterns` | Reusable solutions that worked | Long-term |
| `agents` | Agent-specific learned behaviors | Long-term |
| `tasks` | Task records and outcomes | 30 days |
| `errors` | Failed approaches (avoid repeating) | 30 days |
| `project` | Project-specific knowledge | Per-project |
| `specs` | Requirements and specifications | Per-project |
| `architecture` | Architecture decisions | Per-project |

---

## Core Operations

### Store a Pattern
```
After solving a problem successfully:
memory_store(
  key: "pattern-[descriptive-name]",
  value: {
    problem: "what was the problem",
    solution: "what worked",
    context: "when to apply this",
    code: "relevant snippet if applicable"
  },
  namespace: "patterns"
)
```

### Search Before Starting
```
Before starting any task:
results = memory_search(
  query: "[task keywords]",
  namespace: "patterns",
  threshold: 0.7  // score > 0.7 = use this pattern
)

if results.length > 0:
  → adapt the stored pattern
else:
  → solve fresh, then store the solution
```

### Session Memory
```
# Start of complex task
memory_store(key: "session-context", value: {
  task: "description",
  approach: "planned approach",
  constraints: ["list of constraints"]
}, namespace: "session")

# Reference during task
context = memory_retrieve(key: "session-context", namespace: "session")
```

---

## HNSW Vector Search

For semantic similarity (finding related patterns by meaning, not exact keywords):

```
# Store with embedding (automatic on store)
memory_store(key: "auth-pattern", value: "JWT implementation with refresh tokens", namespace: "patterns")

# Search semantically - finds related content even with different wording
results = memory_search(
  query: "how to handle token expiration",  // different words, same concept
  namespace: "patterns",
  limit: 5
)
# Returns: auth-pattern with high score because concepts match
```

HNSW search is 150x-12,500x faster than linear search at scale. Use it for pattern retrieval.

---

## Agent Scoping

Each agent type maintains its own memory scope to avoid interference:

```
# Coder agent stores its patterns
memory_store(key: "typescript-generics-pattern", namespace: "agents/coder")

# Reviewer agent stores its own
memory_store(key: "security-review-checklist", namespace: "agents/reviewer")

# Cross-agent access (read-only)
pattern = memory_retrieve(key: "typescript-generics-pattern", namespace: "agents/coder")
```

---

## Learning Pattern

The core loop for self-improving agents:

```
1. RETRIEVE — Search memory before starting
   results = memory_search(query=task, threshold=0.7)

2. EXECUTE — Do the work
   if high-score result found:
     → adapt stored pattern
   else:
     → solve fresh

3. EVALUATE — Did it work?
   success = run_tests() or user_confirmed()

4. STORE — Persist what worked
   if success:
     memory_store(key=pattern_name, value=solution, namespace="patterns")
   else:
     memory_store(key=failure_name, value=what_not_to_do, namespace="errors")
```

---

## Memory Hygiene

- Use descriptive keys: `auth-jwt-refresh-pattern` not `p1`
- Include context in values: when to use this, not just what it is
- Set TTLs on session data: don't pollute long-term with session noise
- Periodically consolidate: merge similar patterns into one authoritative entry
- Never store secrets, tokens, or credentials in memory
