---
name: task-type-classifier
description: Classifies the type of review task the user is requesting — full PR review, respond to maintainer feedback, fix CI failures, draft a reply, or implement requested changes. Use at the start of any review workflow to route to the correct sub-workflow.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Task Type Classifier Skill

## Objective

Determine what kind of review action the user needs so the review-agent can select the correct workflow.

Without classification, the agent cannot route the task correctly — this must run first.

---

# Classification Categories

## Category A — Full PR Review

Triggered when:
- User says "review this PR", "check this pull request", "give feedback on this PR"
- No existing review comments exist, or user wants a fresh review
- User provides a branch or PR number without further context

Action: → Full PR Review Workflow

---

## Category B — Respond to Maintainer Feedback

Triggered when:
- A human maintainer has left review comments
- User says "address the review comments", "respond to the maintainer", "fix what they requested"
- PR has `changes_requested` status from a human reviewer

Action: → Respond to Maintainer Feedback Workflow

---

## Category C — Fix CI/Bot Failures

Triggered when:
- CI checks are failing
- A bot has left automated comments
- User says "fix the CI", "address the linting errors", "fix the test failures"
- PR has failing checks in the status table

Action: → Fix CI/Bot Failures Workflow

---

## Category D — Draft Reply Only

Triggered when:
- User wants to respond to a comment but NOT make code changes
- User says "draft a reply", "write a response", "how should I respond to this"
- User wants to explain a decision or decline a suggestion

Action: → Draft Reply Only Workflow

---

## Category E — Implement Review Changes Only

Triggered when:
- User has already understood the feedback
- User says "implement the requested changes", "apply the reviewer's suggestions"
- User provides a list of changes to make without asking for analysis

Action: → Implement Review Changes Only Workflow

---

# Classification Workflow

## Step 1 — Read the User's Request

Parse the user's message for explicit keywords and intent signals.

---

## Step 2 — Check PR State

If a PR number or URL is provided:
- Check current review status
- Check CI check statuses
- Count human review comments vs. bot comments

---

## Step 3 — Apply Classification Rules

Priority order (apply first match):
1. If user explicitly says "review" with no other context → Category A
2. If human maintainer comments exist and user says "address" or "respond" → Category B
3. If CI is failing and user says "fix" → Category C
4. If user explicitly says "draft a reply" or "write a response" → Category D
5. If user says "implement" or "apply changes" → Category E
6. Default (ambiguous): → Category A (full review)

---

## Step 4 — Output Classification

Emit:
- Detected task type (A–E)
- Confidence level (high/medium/low)
- Reasoning for the classification
- Recommended workflow name

---

# Output Format

Task Classification:
- Type: [A | B | C | D | E]
- Label: [Full Review | Respond to Maintainer | Fix CI | Draft Reply | Implement Changes]
- Confidence: [High | Medium | Low]
- Reason: [brief explanation]
- Recommended Workflow: [workflow name from review-agent.md]
