---
name: human-response-drafter
description: Drafts natural, human-sounding responses to PR review comments — avoiding robotic, formulaic, or AI-sounding language. Use before maintainer-reply-writer or bot-reply-writer to ensure the tone is professional and authentic.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# Human Response Drafter Skill

## Objective

Produce reply drafts that read as if written by a competent, self-assured engineer — not a form letter, not a bot, and not an apologetic non-answer.

Reviewers notice when replies sound automated. A human-sounding response builds trust and speeds up the review cycle.

---

# Principles

## Sound Like a Developer, Not a Form

**Avoid**:
- "Thank you for your valuable feedback."
- "I appreciate your review."
- "Great suggestion! I've implemented that."
- "As per your request, I have..."
- Unnecessary politeness filler at the start of every reply

**Instead**:
- Get to the point
- Acknowledge the concern directly
- Explain what was done or why a different approach was taken
- Use natural contractions ("I've", "that's", "it's")

---

## Be Specific, Not Generic

**Avoid**: "Fixed it."
**Instead**: "Changed the loop to use a set instead of a list — that brings it from O(n) to O(1) for membership checks."

**Avoid**: "Good point, will update."
**Instead**: "You're right — I missed the edge case where the input is empty. Added a guard in `parse_config()` and a test for it."

---

## Show Reasoning for Decisions

When not making a change, explain why without being defensive:
- "I kept it as a list here because the order matters for the rendering pipeline — converting to a set would lose that."
- "I'd rather tackle the refactor in a separate PR to keep this diff focused on the fix."

---

# Workflow

## Step 1 — Load All Comment Responses Needed

Receive from maintainer-feedback-interpreter or bot-feedback-analyzer:
- Each comment that requires a reply
- Whether the change was implemented, declined, or deferred
- Any clarifying decisions made during implementation

---

## Step 2 — Draft Each Response

For each comment:

### If the change was implemented:
- State what was done concretely
- Reference the specific code or location if helpful
- Skip pleasantries

### If the change was declined:
- Acknowledge the concern without dismissing it
- Explain the reasoning clearly
- Offer an alternative if one exists (e.g., follow-up issue)

### If the change was deferred:
- Explain why it's being left for a follow-up
- Optionally mention an issue number or plan

### If the comment was a question:
- Answer it directly
- Include context the reviewer may have missed

---

## Step 3 — Review Tone

Check each draft for:
- Robotic phrasing → rephrase naturally
- Excessive hedging ("maybe", "I think perhaps", "it might be") → be direct
- Unnecessary apologies → remove
- Starting with "I" on every response → vary the sentence structure
- Repetitive structure across replies → vary the opening of each

---

## Step 4 — Bundle Into a Cohesive Reply

If multiple comments are addressed in one reply:
- Group related responses logically
- Use natural transitions between responses
- Keep the overall reply concise — don't pad it

---

# Output Format

Response Drafts:
- Per-comment response text (ready to paste)
- Tone assessment (Professional / Too Formal / Too Casual)
- Flagged phrases that need human review before posting
