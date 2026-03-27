---
name: agentic-jujutsu
version: 1.0.0
description: |
  Advanced agentic techniques for getting more from Claude Code. Covers: context
  manipulation for better outputs, prompt chaining patterns, self-critique loops,
  structured output extraction, agent handoffs, and meta-prompting. Use these
  techniques when standard approaches produce suboptimal results.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Agent, AskUserQuestion]
---

# Agentic Jujutsu

Advanced techniques for amplifying Claude's capabilities. Use when standard approaches fall short.

---

## 1. Self-Critique Loop

Force Claude to critique its own output before finalizing:

```
Pattern:
  1. Generate first draft
  2. "Now critique that output — what's wrong with it?"
  3. "Now fix the issues you identified"
  4. Repeat until critique finds nothing significant

Example:
  [generate code]
  "Now review that code as a skeptical senior engineer. What are the problems?"
  [gets critique]
  "Fix the top 3 issues you identified."
  [improved code]
  "One more review — anything left?"
```

This catches more bugs than a single generation pass. Three loops is usually enough.

---

## 2. Contrastive Prompting

Generate multiple approaches and compare:

```
"Generate three different implementations of [feature]:
 - Option A: prioritizing simplicity
 - Option B: prioritizing performance
 - Option C: prioritizing extensibility

Then tell me which you'd choose and why."
```

Forces broader exploration before committing to one path.

---

## 3. Rubber Duck Debugging with Structure

```
"I have a bug. I'm going to explain it to you. Don't solve it yet — just ask me
clarifying questions until you think you understand the full picture. Then
we'll solve it together."
```

Forces you to articulate the problem completely before Claude suggests solutions. Often you find the bug yourself during explanation.

---

## 4. Constraint Escalation

Start with maximum constraints, relax only what's necessary:

```
"Implement [feature] with these constraints:
 - No external dependencies
 - Under 50 lines
 - No classes, only functions
 - Must work in Node 16+

If any constraint makes it impossible, tell me which one and why before relaxing it."
```

Produces minimal, focused implementations. Much better than "implement X" which produces kitchen-sink code.

---

## 5. Role Assignment for Different Perspectives

Assign Claude a specific role before asking a question:

```
"As a security auditor, review this code."
"As a performance engineer, identify the bottleneck."
"As a first-time user of this API, explain what's confusing."
"As a maintainer who has never seen this code, what questions would you have?"
```

Different roles surface different issues. Stack multiple roles on the same code for comprehensive review.

---

## 6. Structured Output Extraction

When you need data in a specific format, specify the schema upfront:

```
"Analyze [file] and return ONLY a JSON object with this schema:
{
  'bugs': [{'line': number, 'severity': 'critical|high|medium|low', 'description': string}],
  'suggestions': [{'line': number, 'description': string}],
  'verdict': 'approve|request-changes|reject'
}
No other text."
```

Makes output machine-readable and directly actionable.

---

## 7. Context Priming

Front-load the most important context before the actual question:

```
"Here's what you need to know before I ask my question:
 - This is a payments system. Bugs here cause real financial loss.
 - We use Stripe, not direct card processing.
 - All amounts are in cents to avoid floating point errors.
 - The codebase follows the repository pattern.

Given that context: [actual question]"
```

Better context → better answers. Don't assume Claude inferred it.

---

## 8. Incremental Specification

Build specifications iteratively with Claude:

```
Round 1: "I want to build [vague idea]. Ask me 5 questions to clarify the requirements."
Round 2: [answer questions] → "Now ask 3 follow-up questions about the unclear parts."
Round 3: [answer] → "Now write the specification based on our discussion."
Round 4: "What did I forget to specify?"
```

Gets to a tight spec before writing any code.

---

## 9. Adversarial Testing

Ask Claude to attack its own implementation:

```
"You just implemented [feature]. Now act as an attacker trying to break it.
What are the 5 most likely attack vectors? Include:
 - Input manipulation attacks
 - Race conditions
 - Edge cases that cause crashes
 - Ways to bypass business logic
 - Anything else a malicious user might try"
```

Then fix what it finds. More effective than "check for security issues."

---

## 10. Chain of Agents

When context limits prevent one agent from holding the full picture:

```
Agent 1 → Research (returns: findings document)
Agent 2 → Architecture (receives findings, returns: design document)
Agent 3 → Implementation (receives design, returns: code)
Agent 4 → Review (receives code + original requirements, returns: verdict)
```

Each agent gets exactly the context it needs. No agent carries unnecessary history.

---

## When to Use These

| Technique | When |
|-----------|------|
| Self-critique | Code quality matters, first pass not good enough |
| Contrastive | Multiple valid approaches, need to pick the best |
| Constraint escalation | Default output too complex or over-engineered |
| Role assignment | Need a specific perspective (security, UX, performance) |
| Structured output | Need to process Claude's output programmatically |
| Context priming | Domain-specific work Claude might not assume correctly |
| Adversarial testing | Security-sensitive or payment-critical code |
| Chain of agents | Task too large for single context window |
