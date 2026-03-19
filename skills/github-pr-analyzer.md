---
name: github-pr-analyzer
description: Fetches and parses pull request content including diff, changed files, inline comments, CI status, and bot feedback. Use when analyzing a PR before reviewing or responding to it.
metadata:
  author: dev-os
  version: 1.0
  category: review
---

# GitHub PR Analyzer Skill

## Objective

Retrieve and parse the full content of a pull request to give the review agent complete context before any review, feedback-response, or drafting phase begins.

---

# Workflow

## Step 1 — Identify the PR

Collect:
- PR URL, number, or branch name
- Repository name and owner
- Base branch (target of merge)
- Head branch (source of changes)

---

## Step 2 — Fetch PR Metadata

Retrieve:
- PR title and description
- Author, creation date, last update
- Labels, milestone, linked issues
- Review status (approved, changes requested, pending)
- Number of comments, reviews, and CI checks

Use `gh pr view <number> --json` for structured data.

---

## Step 3 — Fetch Changed Files

Retrieve:
- List of files added, modified, deleted
- File paths and extensions
- Line counts per file (additions and deletions)

Use `gh pr diff <number>` or `git diff base..head`.

---

## Step 4 — Fetch the Diff

Parse the raw unified diff:
- Identify changed hunks per file
- Note context lines around changes
- Flag files with large diffs (> 200 lines changed) as requiring focused review

---

## Step 5 — Fetch Inline Comments

Collect all review comments:
- Comment author (human vs. bot)
- File and line reference
- Comment body
- Whether the comment is resolved or pending
- Thread replies

---

## Step 6 — Fetch CI Status

Retrieve:
- All CI check names and statuses (pass/fail/pending)
- Failed check names and links to logs
- Bot comments from CI systems (linters, coverage tools, security scanners)

---

## Step 7 — Classify Feedback Sources

Tag each comment as:
- `human-maintainer`: review from a project maintainer or contributor
- `human-reviewer`: review from a non-maintainer reviewer
- `bot-ci`: automated CI check failure
- `bot-linter`: linting bot comment (ruff, black, eslint, etc.)
- `bot-coverage`: coverage drop alert
- `bot-security`: security scanner finding

---

# Output Format

PR Context Summary:
- PR metadata (title, description, author, status)
- Changed files list with line counts
- Diff summary per file
- Inline comments grouped by source (human vs. bot)
- CI check status table
- Blocking issues (any required changes or failing checks)
