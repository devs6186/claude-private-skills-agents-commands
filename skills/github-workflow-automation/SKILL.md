---
name: github-workflow-automation
version: 1.0.0
description: |
  GitHub Actions workflow patterns, PR automation, issue triage, and repository
  automation using gh CLI and GitHub Actions. Covers CI/CD pipelines, branch
  protection, auto-labeling, status checks, and release automation.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, WebFetch]
---

# GitHub Workflow Automation

Automate GitHub repository operations using GitHub Actions and gh CLI.

---

## GitHub Actions Patterns

### CI Pipeline (Universal)
```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm test -- --coverage
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: test-results
          path: coverage/
```

### Auto-label PRs by file changes
```yaml
name: Label PRs

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/labeler@v5
        with:
          repo-token: "${{ secrets.GITHUB_TOKEN }}"
```

With `.github/labeler.yml`:
```yaml
frontend:
  - changed-files:
    - any-glob-to-any-file: 'src/components/**'

backend:
  - changed-files:
    - any-glob-to-any-file: 'src/api/**'

database:
  - changed-files:
    - any-glob-to-any-file: 'migrations/**'
```

### Auto-merge Dependabot PRs
```yaml
name: Auto-merge Dependabot

on: pull_request

jobs:
  auto-merge:
    if: github.actor == 'dependabot[bot]'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: gh pr merge --auto --squash "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Release Automation
```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run build
      - uses: softprops/action-gh-release@v1
        with:
          generate_release_notes: true
          files: dist/**
```

---

## gh CLI Automation

### PR Management
```bash
# Create PR with full metadata
gh pr create \
  --title "feat: add user authentication" \
  --body "$(cat .github/pr-template.md)" \
  --label "feature,needs-review" \
  --assignee "@me"

# Auto-merge when checks pass
gh pr merge --auto --squash

# Review and approve
gh pr review --approve --body "LGTM"

# List PRs needing review
gh pr list --search "is:open review-requested:@me"
```

### Issue Automation
```bash
# Create issue from template
gh issue create --template bug-report.md

# Auto-close issues fixed by PR
# In PR description: "Fixes #123" or "Closes #456"

# List all open bugs
gh issue list --label bug --state open

# Assign issue to self
gh issue edit 123 --add-assignee @me
```

### Branch Protection
```bash
# Require PR reviews and status checks
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["CI"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}'
```

---

## Repository Automation Patterns

### Stale Issue Closer
```yaml
# .github/workflows/stale.yml
name: Stale Issues

on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v9
        with:
          days-before-stale: 30
          days-before-close: 7
          stale-issue-message: 'This issue has been inactive for 30 days. It will be closed in 7 days unless updated.'
          stale-pr-message: 'This PR has been inactive for 30 days.'
```

### Required Status Checks
Always require these checks on `main`:
1. `lint` — Code style
2. `typecheck` — Type safety
3. `test` — Unit/integration tests
4. `build` — Build succeeds

Add branch protection to enforce these via gh CLI or repository settings.
