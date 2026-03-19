---
name: maintainer-reply-writer
description: Writes polished, professional reply comments to maintainer PR reviews — per-comment responses that acknowledge feedback, explain decisions, and confirm implemented changes. Use after changes have been implemented and human-response-drafter has produced drafts.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Maintainer Reply Writer Skill

## Objective

Produce final, ready-to-post replies to each maintainer review comment, combining the change implementation summary with the human response drafts into per-comment text ready for GitHub.

---

# Workflow

## Step 1 — Load Inputs

Collect:
- Human response drafts from human-response-drafter
- Implementation summary from pr-change-implementer (what was changed, where)
- Change evaluation from requested-change-evaluator (what was implemented, declined, deferred)

---

## Step 2 — Produce Per-Comment Reply Text

For each maintainer comment:

### Format

```
[Direct answer or action taken]

[Specific detail — file, function, what changed — if applicable]

[Explanation of any decision that deviated from the suggestion — if applicable]
```

No greeting. No "thank you for the review." Start with substance.

---

## Step 3 — Handle Specific Cases

### Required change was implemented
State what was done. Reference the specific location if it helps. Example:

> "Switched to `contextlib.suppress` as you suggested — cleans it up nicely. Updated `capa/features/common.py:204`."

---

### Suggestion was declined
Acknowledge the point, explain the decision. Example:

> "I see the argument for extracting this — I thought about it — but since it's only called once and the logic is tightly coupled to this context, I think pulling it out would hurt readability more than it helps. Happy to revisit if you feel strongly."

---

### Change deferred to follow-up
Frame it positively, show you've captured it. Example:

> "Good point, though that's a broader refactor than fits here. I've opened #XXXX to track it separately so it doesn't get lost."

---

### Question answered
Answer clearly and add any context that explains the choice. Example:

> "The `frozenset` here is intentional — it gets passed into `_match()` which shouldn't be able to mutate it. A plain set would work but I wanted the contract enforced."

---

## Step 4 — Write a Top-Level PR Summary Comment (Optional)

If there are many changes, write a single top-level comment that summarizes what was addressed:
- List changes made (not exhaustive, just the substantive ones)
- Note anything deferred with issue references
- Keep it to 5–10 lines maximum

Example:

> "Addressed most of the feedback in the latest push. The main changes: [list]. I've deferred [X] to #XXXX since it's out of scope for this PR. Let me know if anything else needs attention."

---

## Step 5 — Final Review

Before outputting:
- Verify no comment went unanswered
- Verify declined changes have explanations
- Verify no AI-sounding phrases remain (re-run through human-response-drafter mental model)
- Verify tone is consistent across all replies

---

# Output Format

Maintainer Reply Comments:
- Per-comment reply text (formatted for GitHub comment, one block per comment)
- Optional top-level summary comment
- Any comments flagged for human review before posting
