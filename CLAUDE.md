# Global Claude Code — Master Workflow

This file defines the universal operating model, agent routing, skill selection strategy, and development pipeline active in every project.

---

## Core Principles

1. **Verification first** — Always give Claude a way to verify its work. Verification improves output quality 2-3x. Run tests, open the browser, check logs — confirm it works before moving on.
2. **Plan before code** — Never modify files without understanding the full scope first. Use Plan mode (Shift+Tab twice) to lock in the approach before implementation.
3. **Root cause, not workaround** — Fix the actual problem; never mask symptoms
4. **Minimal change** — Make the smallest correct change; no scope creep
5. **Security by default** — Every input boundary is a trust boundary
6. **Test coverage** — New functionality requires new tests; changed behavior requires updated tests
7. **Production grade** — All code is written for real-world use, not prototypes
8. **Living CLAUDE.md** — When Claude makes a mistake or you correct its approach, update project CLAUDE.md immediately so the mistake is never repeated. Run `/update-claude-md` to capture lessons.

---

## Master Development Pipeline

Every non-trivial task follows this pipeline:

```
1. UNDERSTAND  →  Read relevant files, inspect codebase, understand context
2. PLAN        →  Enter Plan mode (Shift+Tab ×2); iterate until plan is solid; confirm before code
3. IMPLEMENT   →  Write code following language patterns and project conventions
4. VERIFY      →  Run tests, open browser, check logs — confirm it works (highest leverage step)
5. REVIEW      →  Use master-reviewer immediately after writing code
6. SECURITY    →  Use master-security for any auth/input/API/payment changes
7. TEST        →  Ensure full test coverage; add missing tests
8. DOCUMENT    →  Update docs if public APIs or user flows changed
```

> **Why VERIFY before REVIEW?** bcherny (Claude Code creator): *"Give Claude a way to verify its work — this is the most important thing. It improves results 2-3x."* Don't move on until the code demonstrably works.

---

## Agent Routing Guide

### When to use which agent

| Task | Agent |
|------|-------|
| New feature design, system architecture, trade-off analysis | `master-architect` |
| Step-by-step implementation plan with file paths and phases | `master-architect` (PLAN mode) |
| Full project timeline, milestones, effort estimates | `master-architect` (PROJECT mode) |
| Code review after writing or modifying code | `master-reviewer` |
| PR review, CI failures, maintainer feedback response | `master-reviewer` |
| Security review during development | `master-security` (REVIEW mode) |
| Full pre-deployment or periodic security audit | `master-security` (AUDIT mode) |
| Build errors (TypeScript, Go, Kotlin, Python, Gradle) | `master-debugger` |
| Runtime errors, crashes, logic bugs, environment issues | `master-debugger` |
| Test failures, flaky tests, CI pipeline failures | `master-debugger` |
| TDD workflow, test-first development | `tdd-guide` |
| E2E test generation and execution (Playwright) | `e2e-runner` |
| PostgreSQL schema, query, RLS, migration review | `database-reviewer` |
| Python code review (PEP 8, type hints, security) | `python-reviewer` |
| Go code review (idiomatic, concurrency, error handling) | `go-reviewer` |
| Kotlin code review (null safety, coroutines, patterns) | `kotlin-reviewer` |
| Dead code removal, consolidation, cleanup | `refactor-cleaner` |
| Documentation updates, codemaps | `doc-updater` |
| Email/Slack/communication triaging | `chief-of-staff` |
| Autonomous agent loops, continuous operation | `loop-operator` |
| Agent harness configuration and optimization | `harness-optimizer` |
| Repository exploration, codebase understanding | `repo-intelligence-agent` |
| Technical research, technology evaluation | `research-agent` |
| PR review lifecycle, maintainer interaction | `review-agent` (or `master-reviewer`) |
| Skill evaluation, quality scoring, gap detection | `skill-evolution-agent` (Gap Detection / Full Audit mode) |
| Improving a specific skill below grade B | `skill-evolution-agent` (Targeted Skill Improvement mode) |
| Turning instincts into skills/commands/agents | `/evolve` or `/evolve --generate` |
| Complex implementation from instructions | `implementation-agent` |
| Full security audit (comprehensive) | `security-auditor-agent` (or `master-security`) |
| End-to-end system architecture blueprint | `solution-architecture-agent` (or `master-architect`) |
| Project planning with milestones | `project-planner-agent` (or `master-architect`) |
| TypeScript implementation, strict typing, generics | `typescript-specialist` |
| Python implementation guidance, idiomatic patterns | `python-specialist` |
| Database schema design, indexing, query optimization | `database-specialist` |
| Coordinate 3+ parallel agents on a single objective | `project-coordinator` |
| Production-ready boilerplate / template generation | `base-template-generator` |
| Complex multi-phase feature (SPARC methodology) | `/sparc` |
| Parallel multi-agent swarm (large codebases) | `swarm-orchestration` skill + `project-coordinator` |
| High-stakes decision needing multiple perspectives | `hive-mind-advanced` skill |
| Remove AI writing patterns, humanize text | `humanizer` skill |
| Any complex multi-domain task (auto-routes) | `/workflow-orchestrator` |

---

## Skill Selection by Task Type

### Writing Code
- Language standards: `coding-standards`, `python-patterns`, `golang-patterns`, `kotlin-patterns`, `java-coding-standards`, `cpp-coding-standards`
- Framework: `django-patterns`, `springboot-patterns`, `kotlin-ktor-patterns`, `frontend-patterns`, `backend-patterns`
- Testing: `tdd-workflow`, `python-testing`, `golang-testing`, `kotlin-testing`, `e2e-testing`
- Security: `security-review`, `django-security`, `springboot-security`
- Database: `postgres-patterns`, `database-migrations`, `jpa-patterns`, `kotlin-exposed-patterns`

### Debugging
- `error-log-analyzer` → when logs present
- `stacktrace-analyzer` → when stack trace present
- `dependency-conflict-detector` → package version issues
- `environment-debugger` → Docker/OS/deployment
- `configuration-analyzer` → config file issues
- `api-integration-debugger` → HTTP/API failures
- `performance-debugger` → slow/memory/CPU issues
- `failing-test-analyzer` → test failures
- `minimal-reproduction-builder` → isolating bugs
- `fix-strategy-generator` → always run last

### Architecture & Planning
- `problem-requirement-extractor` → extract requirements
- `constraint-analyzer` → identify constraints
- `architecture-pattern-selector` → pick patterns
- `component-identifier` → define components
- `data-flow-designer` → design data flows
- `technology-selection-advisor` → recommend tech
- `scalability-planner` → design scaling
- `failure-mode-analyzer` → identify failure scenarios
- `architecture-synthesizer` → compile blueprint

### Research
- `web-researcher` → official docs, technical blogs
- `github-researcher` → open source projects
- `stackoverflow-researcher` → code solutions
- `hackernews-researcher` → developer sentiment
- `reddit-researcher` → practitioner opinions
- `twitter-researcher` → industry trends
- `paper-analyzer` → academic research
- `research-synthesizer` → combine multiple sources

### Code Review & Quality
- `code-quality-reviewer` → style/patterns/complexity
- `architecture-decision-reviewer` → design choices
- `security-impact-reviewer` → security of changes
- `test-coverage-reviewer` → test quality
- `performance-impact-reviewer` → performance of changes
- `maintainability-reviewer` → long-term health
- `documentation-reviewer` → doc completeness

### PR Management
- `github-pr-analyzer` → fetch PR diff and comments
- `maintainer-feedback-interpreter` → parse reviewer comments
- `bot-feedback-analyzer` → parse CI/bot output
- `requested-change-evaluator` → prioritize changes
- `human-response-drafter` → write natural replies
- `maintainer-reply-writer` → formal maintainer responses
- `bot-reply-writer` → CI bot acknowledgments
- `review-report-generator` → final report

### AI & Agent Development
- `claude-api` → Anthropic Claude API patterns
- `agentic-engineering` → building agentic systems
- `autonomous-loops` → continuous agent patterns
- `eval-harness` → evaluation framework
- `verification-loop` → verification patterns
- `agent-harness-construction` → agent harness design
- `cost-aware-llm-pipeline` → LLM cost optimization
- `prompt-optimizer` → prompt improvement
- `dmux-workflows` → multi-agent orchestration
- `sparc-methodology` → SPARC S→P→A→R→C multi-agent pipeline
- `swarm-orchestration` → parallel agent swarms (hierarchical/mesh/adaptive)
- `hive-mind-advanced` → collective intelligence deliberation for hard decisions
- `agentdb-memory-patterns` → persistent agent memory with HNSW vector search
- `hooks-automation` → Claude Code lifecycle hooks (pre/post tool, session events)
- `agentic-jujutsu` → advanced techniques: self-critique, constraint escalation, adversarial testing
- `pair-programming` → structured AI pair programming (Navigator/Driver modes)

---

## Language-Specific Workflows

### TypeScript / JavaScript
Build error → `master-debugger` (BUILD FIX, runs `npx tsc --noEmit`)
Code review → `master-reviewer`
Security → `master-security`
Skills: `coding-standards`, `frontend-patterns`, `backend-patterns`, `e2e-testing`

### Python
Build error → `master-debugger` (runs `mypy`, `pytest`)
Code review → `python-reviewer`
Security → `master-security`
Skills: `python-patterns`, `python-testing`, `django-patterns`, `django-tdd`, `django-security`

### Go
Build error → `master-debugger` → `go-build-resolver` (runs `go build ./...`, `go vet ./...`)
Code review → `go-reviewer`
Testing → `/go-test`
Skills: `golang-patterns`, `golang-testing`

### Kotlin / Android
Build error → `master-debugger` → `kotlin-build-resolver` (runs `./gradlew build`)
Code review → `kotlin-reviewer`
Testing → `/kotlin-test`
Skills: `kotlin-patterns`, `kotlin-testing`, `kotlin-coroutines-flows`, `kotlin-ktor-patterns`, `android-clean-architecture`

### Java / Spring Boot
Code review → `master-reviewer`
Skills: `java-coding-standards`, `springboot-patterns`, `springboot-tdd`, `springboot-security`, `jpa-patterns`

### Swift / iOS
Skills: `swiftui-patterns`, `swift-concurrency-6-2`, `swift-actor-persistence`, `swift-protocol-di-testing`

---

## Automatic Triggers

These agents run **automatically** (proactively, without being asked):

| Trigger | Action |
|---------|--------|
| After any code write/edit | Run `/verify` — tests, build, or open browser to confirm it works |
| After any code write/edit | Use `master-reviewer` for code quality |
| Writing new API endpoint | `master-security` (REVIEW mode) |
| Modifying auth/session code | `master-security` (REVIEW mode) |
| Build fails | `master-debugger` (BUILD FIX mode) |
| Planning new feature | Start in Plan mode; use `master-architect` (PLAN/COMBINED mode) |
| Adding new functionality | `tdd-guide` (enforce test-first) |
| Claude makes a mistake / you correct its approach | Run `/update-claude-md` to capture the lesson |
| After `/learn` or `/learn-eval` extracts new patterns | Run `/evolve` — cluster instincts into skills/commands/agents |
| After `/update-claude-md` records a gap or weakness | Run `skill-evolution-agent` (Gap Detection mode) — check if a skill needs improving |
| After a long session with repeated skill usage | Run `skill-evolution-agent` (Targeted Skill Improvement mode) on the most-used skill |
| Periodically / end-of-sprint | Run `skill-evolution-agent` (Full Library Audit) — grade all skills, improve anything below B |

---

## Plan Mode → Implementation Workflow

The single most effective session pattern (from bcherny's own workflow):

1. **Start in Plan mode** — Press Shift+Tab twice to enter Plan mode at session start
2. **Iterate on the plan** — Go back and forth with Claude until the plan is concrete and solid
3. **Switch to auto-accept** — Once plan is confirmed, enable auto-accept (Shift+Tab once) and let Claude implement
4. **Verify the result** — Run tests, open the browser, check that it actually works

This eliminates premature implementation, reduces rework, and keeps human oversight at the planning stage.

---

## Living CLAUDE.md — Learning from Mistakes

> *"We update CLAUDE.md multiple times a week when Claude makes a mistake so it doesn't repeat it."* — bcherny

When Claude produces an incorrect output, wrong approach, or repeats a mistake:

1. Run `/update-claude-md` to capture the lesson in the project's CLAUDE.md
2. Format: what happened, what the correct behavior is, why
3. Commit the updated CLAUDE.md alongside the fix

This compounds over time — each mistake caught becomes a permanent instruction that prevents recurrence.

---

## Parallel Sessions

For complex work, run 5+ Claude instances in parallel across terminal tabs or claude.ai/code:

- Use numbered tabs (1–5) and system notifications to track which sessions need input
- Hand off sessions between local terminal and claude.ai/code using `&` to continue context
- Each session can own an independent workstream (feature branch, bug fix, exploration)
- Use `/save-session` before handing off, `/resume-session` when picking back up

---

## Session Management

- `/save-session` — Save current state before long operations
- `/resume-session` — Restore context from previous session
- `/checkpoint` — Quick snapshot mid-task
- `/learn` — Extract reusable patterns from session → then run `/evolve`
- `/learn-eval` — Extract + self-evaluate before saving → then run `/evolve --generate`
- After `/learn`/`/learn-eval` → run `skill-evolution-agent` if extracted patterns reveal a skill gap or weakness

---

## Multi-Project Workflows

- `/multi-plan` — Plan changes spanning multiple projects
- `/multi-backend` + `/multi-frontend` — Coordinate backend and frontend in parallel
- `/multi-workflow` — Full multi-model collaborative development
- `/orchestrate` — Custom multi-project orchestration

---

## Quality Gates (before any merge/deploy)

1. `npx tsc --noEmit` exits 0 (TypeScript)
2. `go build ./... && go vet ./...` pass (Go)
3. `./gradlew build` pass (Kotlin/Android)
4. No CRITICAL security findings
5. Test coverage at or above project threshold
6. `master-reviewer` verdict: Approve or Warn (no BLOCK)
7. `/quality-gate` passes

Run `/verify` for full automated verification.

---

## Model Routing

> **Creator recommendation**: bcherny (Claude Code creator) uses Opus for all coding tasks — *"best coding model I've ever used; better tool use justifies the speed tradeoff."*

| Task | Model | Agent |
|------|-------|-------|
| All coding, implementation, refactoring | **opus** | Default — use Opus when quality matters |
| Architecture, complex planning | opus | `master-architect` |
| Code review, security review, debugging | opus | `master-reviewer`, `master-security`, `master-debugger` |
| Documentation updates, simple edits | haiku | `doc-updater` |
| Fast research, quick lookups | sonnet | `research-agent` |

Use `/model-route` to get cost-optimal routing for any specific task.

---

## Skill Categories Reference

### Core Development
`coding-standards` · `tdd-workflow` · `e2e-testing` · `security-review` · `security-scan` · `api-design` · `backend-patterns` · `frontend-patterns` · `database-migrations` · `deployment-patterns` · `docker-patterns`

### Language-Specific
`python-patterns` · `python-testing` · `golang-patterns` · `golang-testing` · `kotlin-patterns` · `kotlin-testing` · `kotlin-coroutines-flows` · `kotlin-ktor-patterns` · `kotlin-exposed-patterns` · `java-coding-standards` · `jpa-patterns` · `cpp-coding-standards` · `cpp-testing` · `perl-patterns` · `perl-security` · `perl-testing`

### Framework-Specific
`django-patterns` · `django-tdd` · `django-security` · `django-verification` · `springboot-patterns` · `springboot-tdd` · `springboot-security` · `springboot-verification` · `postgres-patterns`

### Mobile / Cross-Platform
`android-clean-architecture` · `swiftui-patterns` · `swift-concurrency-6-2` · `swift-actor-persistence` · `swift-protocol-di-testing` · `compose-multiplatform-patterns`

### AI / Agent Engineering
`claude-api` · `agentic-engineering` · `autonomous-loops` · `continuous-agent-loop` · `continuous-learning-v2` · `eval-harness` · `verification-loop` · `agent-harness-construction` · `cost-aware-llm-pipeline` · `prompt-optimizer` · `iterative-retrieval` · `search-first` · `deep-research` · `dmux-workflows` · `sparc-methodology` · `swarm-orchestration` · `hive-mind-advanced` · `agentdb-memory-patterns` · `hooks-automation` · `agentic-jujutsu` · `pair-programming`

### Business Domain
`carrier-relationship-management` · `customs-trade-compliance` · `energy-procurement` · `inventory-demand-planning` · `logistics-exception-management` · `production-scheduling` · `quality-nonconformance` · `returns-reverse-logistics` · `market-research` · `investor-materials` · `investor-outreach`

### Content & Media
`article-writing` · `content-engine` · `crosspost` · `x-api` · `frontend-slides` · `video-editing` · `videodb` · `fal-ai-media`

### Utilities
`blueprint` · `regex-vs-llm-structured-text` · `nanoclaw-repl` · `clickhouse-io` · `exa-search` · `foundation-models-on-device` · `nutrient-document-processing` · `visa-doc-translate` · `liquid-glass-design`

---

## Key Commands Quick Reference

| Command | Purpose |
|---------|---------|
| `/plan` | Create implementation plan (waits for confirm) |
| `/commit-push-pr` | Stage, commit, push, and open PR in one command (use constantly) |
| `/update-claude-md` | Record a lesson in project CLAUDE.md after a mistake |
| `/tdd` | Test-driven development workflow |
| `/code-review` | Invoke master-reviewer |
| `/build-fix` | Invoke master-debugger build fix |
| `/go-build` · `/kotlin-build` · `/gradle-build` | Language-specific build fix |
| `/go-review` · `/kotlin-review` · `/python-review` | Language-specific code review |
| `/e2e` | Generate and run E2E tests |
| `/quality-gate` | Run all quality checks |
| `/verify` | Full verification pass |
| `/security` (via master-security) | Security review |
| `/refactor-clean` | Dead code cleanup |
| `/update-docs` | Update documentation |
| `/skill-create` | Extract patterns from git history |
| `/learn` · `/learn-eval` | Extract session patterns → always follow with `/evolve` |
| `/evolve` | Cluster instincts into skills/commands/agents |
| `/evolve --generate` | Cluster + write evolved files to disk |
| `/save-session` · `/resume-session` | Session persistence |
| `/prompt-optimize` | Optimize a prompt |
| `/model-route` | Get cost-optimal model routing |
| `/sparc` | Run SPARC multi-agent pipeline (S→P→A→R→C) |
| `/workflow-orchestrator` | Master orchestrator — auto-detects and routes any task |
| `humanizer` skill | Remove AI writing patterns, restore human voice |
| `swarm-orchestration` skill | Launch parallel agent swarm |
| `hive-mind-advanced` skill | Collective intelligence for high-stakes decisions |
| `agentic-jujutsu` skill | Advanced techniques: self-critique, adversarial testing |
