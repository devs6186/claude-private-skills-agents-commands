---
name: hive-mind-advanced
version: 1.0.0
description: |
  Collective intelligence system for high-stakes decisions requiring multiple
  agent perspectives. A Queen agent leads Worker agents to gather evidence,
  analyze from different angles, and reach consensus through majority voting,
  weighted voting, or Byzantine fault tolerance. Use for architecture decisions,
  technology selection, security audits, and any decision where being wrong
  is expensive.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Agent, TodoWrite, WebSearch]
---

# Hive Mind — Collective Intelligence

Run a structured multi-agent deliberation where agents with different specializations independently analyze a problem and reach consensus. Unlike a swarm (which divides work), a Hive Mind multiplies perspectives on the same problem.

---

## When to Use Hive Mind

- High-stakes architectural decisions with no clear right answer
- Technology selection (3+ viable options, real trade-offs)
- Security decisions where a single reviewer might miss something
- Code review on critical paths (payment, auth, data deletion)
- Diagnosing complex bugs that one agent has already failed to solve
- Any decision where the cost of being wrong is high

---

## Structure

### Queen Agent
The Queen orchestrates the deliberation. She does not vote; she coordinates.

**Queen types:**
- `strategic` — Long-term architectural and technology decisions
- `tactical` — Short-term implementation and design decisions
- `adaptive` — Dynamic decisions that change as evidence comes in

### Worker Agents
Workers independently analyze the problem from their specialization angle.

| Worker Type | Analyzes From |
|-------------|--------------|
| `researcher` | Available information, prior art, documentation |
| `coder` | Implementation feasibility, code complexity |
| `analyst` | Requirements coverage, edge cases |
| `tester` | Testability, failure modes, edge cases |
| `architect` | System coherence, scalability, coupling |
| `reviewer` | Code quality, patterns, maintainability |
| `optimizer` | Performance, resource usage |
| `documenter` | Explainability, maintainability by others |

---

## Consensus Mechanisms

### Majority Vote
Each worker submits a verdict. The option with the most votes wins.
Best for: Decisions with clear options, 5+ workers.

### Weighted Vote
Workers are weighted by their specialization relevance.
Example: Architecture decision → architect (3x), coder (2x), tester (1x)
Best for: Decisions where some angles matter more than others.

### Byzantine Fault Tolerance (BFT)
Consensus reached only when (2/3 + 1) of workers agree.
Tolerates up to 1/3 workers being wrong or malicious.
Best for: Critical security or financial decisions.

---

## Process

### Step 1 — Queen Defines the Question
```
Queen prompt: "Evaluate [DECISION] across these dimensions:
  - Option A: [description]
  - Option B: [description]
  - Option C: [description]

Each worker should independently assess and return:
  1. Recommended option
  2. Top 2 reasons
  3. Biggest risk of their recommendation
  4. Confidence (1-10)"
```

### Step 2 — Workers Deliberate (Parallel)
```
Agent("researcher", "[queen prompt] — analyze from research angle")
Agent("architect", "[queen prompt] — analyze from architecture angle")
Agent("coder", "[queen prompt] — analyze from implementation angle")
Agent("tester", "[queen prompt] — analyze from testing angle")
Agent("security-architect", "[queen prompt] — analyze from security angle")
```

### Step 3 — Queen Aggregates
```
Queen collects all worker verdicts:
- Tally votes (or apply weights)
- Identify dissenting workers and their reasons
- Surface the strongest argument against the majority
- Produce final recommendation with confidence level
```

### Step 4 — Queen Decision
```
Final output:
- Recommendation: Option [X]
- Consensus: [majority/unanimous/contested]
- Confidence: [1-10]
- Key supporting reasons: [top 3]
- Main risk: [from dissenting workers]
- Minority view: [summary of losing argument]
```

---

## Collective Memory

The Hive Mind maintains three memory types:

| Memory Type | What It Stores | Retention |
|-------------|---------------|-----------|
| `knowledge` | Facts, documentation, reference information | Long-term |
| `context` | Current task state, worker outputs | Session |
| `consensus` | Past decisions and their outcomes | Long-term |
| `error` | Decisions that turned out wrong | Long-term (for learning) |

Past decisions are available for future deliberations: "We faced this tradeoff before and chose X; it led to Y outcome."

---

## Example: Technology Selection

**Question**: "Should we use PostgreSQL, MongoDB, or DynamoDB for the user data store?"

**Queen type**: Strategic

**Workers**: researcher, architect, coder, tester, optimizer

**Worker outputs** (each independent):
- researcher: "PostgreSQL — best documented, proven at scale, SQL queries simpler"
- architect: "PostgreSQL — relational model fits user data structure, foreign keys reduce bugs"
- coder: "PostgreSQL — ORM support better, migrations more mature"
- tester: "PostgreSQL — easier to seed test data, transactions simplify test isolation"
- optimizer: "DynamoDB — lowest latency at extreme scale, but we're not at that scale"

**Queen aggregation**:
- Vote: PostgreSQL 4, DynamoDB 1, MongoDB 0
- Consensus: Strong majority (BFT satisfied)
- Risk surface: optimizer raised DynamoDB for scale — valid at 10M+ users
- **Decision: PostgreSQL**, revisit if user count exceeds 5M

---

## Activation

Invoke the hive mind for any high-stakes decision:

```
"Use hive mind to decide: [decision question]"
"Run a collective intelligence analysis on: [architecture choice]"
"Get multiple agent perspectives on: [technical tradeoff]"
```

Or set up explicitly:
```
Agent("queen-strategic", "Orchestrate hive mind deliberation on: [question]")
```
