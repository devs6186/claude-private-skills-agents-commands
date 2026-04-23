---
name: timeline-report
description: Generate a "Journey Into [Project]" narrative report analyzing a project's entire development history from claude-mem's timeline. Use when asked for a timeline report, project history analysis, development journey, or full project report.
metadata:
  author: devs6186+dev-os
  version: 1.0
  category: memory
---

# Timeline Report

Generate a comprehensive narrative analysis of a project's entire development history using claude-mem's persistent memory timeline.

## When to Use

- "Write a timeline report"
- "Journey into [project]"
- "Analyze my project history"
- "Full project report"
- "What's the story of this project?"

## Prerequisites

The claude-mem worker must be running on localhost:37777. The project must have claude-mem observations recorded.

## Workflow

### Step 1: Determine Project Name

If in a git worktree, use the parent project:

```bash
git_dir=$(git rev-parse --git-dir 2>/dev/null)
git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
if [ "$git_dir" != "$git_common_dir" ]; then
  parent_project=$(basename "$(dirname "$git_common_dir")")
else
  parent_project=$(basename "$PWD")
fi
echo "$parent_project"
```

### Step 2: Fetch the Full Timeline

```bash
curl -s "http://localhost:37777/api/context/inject?project=PROJECT_NAME&full=true"
```

**Token estimates:**
- Small project (< 1,000 observations): ~20-50K tokens
- Medium (1,000-10,000 observations): ~50-300K tokens
- Large (10,000-35,000 observations): ~300-750K tokens

### Step 3: Estimate Token Count

Report to user before proceeding: ~1 token per 4 characters. Wait for confirmation if > 100K tokens.

### Step 4: Analyze with a Subagent

Deploy an Agent with the full timeline. The report must include these 10 sections:

1. **Project Genesis** — first commits, initial vision, founding decisions
2. **Architectural Evolution** — how architecture changed and why
3. **Key Breakthroughs** — "aha" moments where tone shifts from investigation to resolution
4. **Work Patterns** — debugging cycles, feature sprints, refactoring phases, exploration phases
5. **Technical Debt** — where shortcuts were taken and paid back
6. **Challenges and Debugging Sagas** — hardest multi-session problems
7. **Memory and Continuity** — how persistent memory affected development
8. **Token Economics & Memory ROI** — quantitative analysis (query SQLite at `~/.claude-mem/claude-mem.db`)
9. **Timeline Statistics** — date range, observation counts by type, most active periods
10. **Lessons and Meta-Observations** — patterns, principles, what a new dev would learn

**Writing style:** technical narrative (~3,000-6,000 words), specific observation IDs + timestamps, honest about struggles, markdown formatting.

### Step 5: Save the Report

Default: `./journey-into-PROJECT_NAME.md`

### Step 6: Report Completion

Tell the user: save location, token cost, date range covered, observations analyzed.

## Error Handling

- **Empty timeline:** Check project name with: `curl -s 'http://localhost:37777/api/search?query=*&limit=1'`
- **Worker not running:** Start claude-mem worker; check with `ps aux | grep worker-service`
