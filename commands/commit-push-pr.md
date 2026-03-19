---
description: Stage all changes, write a commit message, push to remote, and open a pull request. Use this constantly — it's the fastest path from working code to merged PR.
---

# Commit → Push → PR

This command executes the full git shipping workflow in one shot.

## What It Does

1. **Stage** — `git add` all modified tracked files (or specific files if provided)
2. **Commit** — Generate a concise, conventional commit message summarizing changes
3. **Push** — Push the current branch to origin
4. **PR** — Open a pull request using `gh pr create` with a structured description

## Usage

```
/commit-push-pr
/commit-push-pr "feat: add user notifications"
/commit-push-pr --draft
```

## Instructions

### Step 1 — Understand what changed
Run these in parallel:
- `git status` — see modified/untracked files
- `git diff` — see exact changes
- `git log --oneline -5` — understand commit style in this repo

### Step 2 — Stage changes
Stage only relevant files (never `.env`, secrets, large binaries):
```bash
git add <files>
```

### Step 3 — Commit
Generate a commit message following the repo's convention. Default to Conventional Commits:
- `feat:` — new feature
- `fix:` — bug fix
- `refactor:` — code restructure without behavior change
- `docs:` — documentation only
- `test:` — tests only
- `chore:` — tooling, deps, CI

```bash
git commit -m "$(cat <<'EOF'
<type>: <short summary>

<optional body if complex>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

### Step 4 — Push
```bash
git push -u origin HEAD
```

### Step 5 — Open PR
```bash
gh pr create --title "<same as commit title>" --body "$(cat <<'EOF'
## Summary
- <bullet 1>
- <bullet 2>

## Test plan
- [ ] <how to verify>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Step 6 — Output the PR URL
Always print the PR URL at the end so the user can navigate directly to it.

## Arguments

- No args — auto-detect changes and use AI-generated commit message
- `"<message>"` — use provided message as commit title
- `--draft` — open PR as draft
- `--no-pr` — skip PR creation (just commit + push)

## Notes

- Never include `.env`, credential files, or secrets
- Never force-push unless user explicitly requests it
- If pre-commit hooks fail, fix the issue and recommit — never use `--no-verify`
- If branch is behind remote, run `git pull --rebase` first
