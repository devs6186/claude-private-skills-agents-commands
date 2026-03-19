---
description: Record a lesson learned from a mistake into the project's CLAUDE.md so it never repeats. Run this any time you correct Claude's approach or catch a recurring error.
---

# Update CLAUDE.md — Capture Lessons from Mistakes

> *"We update CLAUDE.md multiple times a week when Claude makes a mistake so it doesn't repeat it."* — Boris Cherny, creator of Claude Code

This command captures a lesson from a mistake or corrected behavior into the project's `CLAUDE.md`, creating a permanent instruction that prevents recurrence.

## When to Run

- Claude repeated a mistake you've corrected before
- You told Claude "no, don't do that — do this instead"
- Claude used the wrong pattern, approach, or tool for this codebase
- A review comment revealed a systematic gap in Claude's understanding of this project
- Claude made an assumption that was wrong for this specific project

## Instructions

### Step 1 — Identify the lesson
Ask: *What did Claude do wrong? What is the correct behavior for this project?*

### Step 2 — Check if CLAUDE.md exists
Look for `CLAUDE.md` in the current working directory. If not present, create it.

### Step 3 — Find the right section
Scan existing CLAUDE.md for a related section. Prefer updating an existing rule over adding a new one.

### Step 4 — Write the lesson
Format:
```markdown
## [Section: e.g., "Code Patterns", "Testing", "Architecture"]

- **NEVER do X** — [why: what goes wrong, what happened]
- **ALWAYS do Y instead** — [correct pattern for this project]
```

Keep it short, specific, and actionable. Write for future Claude, not for humans.

### Step 5 — Commit the update
Stage and commit the CLAUDE.md change alongside whatever fix was made:
```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md — [one-line lesson summary]"
```

## Examples

**Bad Claude behavior:** Kept using `axios` when the project uses `fetch` with a custom wrapper.
```markdown
## HTTP Requests
- **NEVER use axios** — this project uses the `apiFetch()` wrapper in `lib/api.ts`
- All API calls go through `apiFetch()` which handles auth headers and error normalization
```

**Bad Claude behavior:** Added `console.log` debug statements and forgot to remove them.
```markdown
## Debugging
- **NEVER commit console.log statements** — use the logger at `lib/logger.ts` for all logging
- Run `grep -r "console.log" src/` before any commit to catch stragglers
```

## Arguments

`$ARGUMENTS` can be:
- Empty — interactive mode: Claude prompts for what the mistake was
- A description of the mistake: `/update-claude-md "kept using axios instead of apiFetch"`
