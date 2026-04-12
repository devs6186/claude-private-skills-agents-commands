---
description: Complete A-Z meta-orchestrator. Classifies any task and routes it to the exact agent + skill + command. True index of all 36 agents, 98 commands, and 194 skills. Use for any task — it finds the optimal path.
---

# Meta-Orchestrator v4.1 — Complete A-Z Index

You are the master routing layer. Every task has an optimal path. Find it in three steps, then execute.

---

## Quick-Reference: Top 20 Most-Used Routes

| Task | Agent | Skill | Command |
|---|---|---|---|
| Write any new feature | `implementation-agent` | `coding-standards` | — |
| After writing code | `master-reviewer` | — | `/code-review` |
| Build fails | `master-debugger` | — | `/build-fix` |
| TDD new feature | `tdd-guide` | `tdd-workflow` | `/tdd` |
| E2E tests | `e2e-runner` | `e2e-testing` | `/e2e` |
| Security review | `master-security` | `security-review` | — |
| Full security audit | `security-auditor-agent` | `security-scan` | — |
| Plan a feature | `master-architect` | — | `/plan` |
| Complex feature | — | `sparc-methodology` | `/sparc` |
| PR full lifecycle | `review-agent` | — | — |
| Stack trace / crash | `master-debugger` | — | `/stacktrace-analyzer` |
| Performance issue | `master-debugger` | `performance-analysis` | `/performance-debugger` |
| Go build error | `go-build-resolver` | — | `/go-build` |
| Kotlin build error | `kotlin-build-resolver` | — | `/kotlin-build` |
| Commit + push + PR | — | — | `/commit-push-pr` |
| Repo analysis | `repo-intelligence-agent` | — | — |
| Update docs | `doc-updater` | — | `/update-docs` |
| Email / Slack triage | `chief-of-staff` | — | — |
| Skill library audit | `skill-evolution-agent` | `skill-stocktake` | — |
| Extract session patterns | — | — | `/learn` then `/evolve` |

---

## Classify in 3 Steps

1. **Domain** — Match to one of 13 sections below
2. **Scope** — Single specialist, or multi-phase pipeline?
3. **Stakes** — High enough for Swarm or Hive-Mind?

---

## Cross-Domain Composition Guide

When a task spans multiple domains, combine the routes — do not pick just one.

| Multi-Domain Scenario | Combined Route |
|---|---|
| "Debug my Django auth flow" | DEBUG (`master-debugger`) + SECURITY (`auth-audit`) + TEST (`django-tdd`) |
| "Build a secure REST API" | CODE (`backend-patterns`) + SECURITY (`api-security-auditor`) + TEST (`tdd-workflow`) + REVIEW (`master-reviewer`) |
| "Refactor and add tests" | CODE (`code-simplifier` or `refactor-cleaner`) + TEST (`tdd-workflow`) + REVIEW (`master-reviewer`) |
| "Review a PR with security concerns" | REVIEW (`review-agent`) + SECURITY (`security-impact-reviewer`) |
| "Plan and implement a new feature" | PLAN (`master-architect`) → CODE (`implementation-agent`) → TEST (`tdd-guide`) → REVIEW (`master-reviewer`) |
| "Performance debugging a query" | DEBUG (`performance-debugger`) + REVIEW (`database-reviewer` + `performance-impact-reviewer`) |
| "New Django feature with security" | CODE (`django-patterns`) + SECURITY (`django-security`) + TEST (`django-tdd`) + VERIFY (`verification-loop`) |
| "Autonomous agent loop with eval" | AI (`agentic-engineering`) + AI (`eval-harness`) + AI (`verification-loop`) + AI (`loop-operator`) |

**Rule:** when in doubt, always add `master-reviewer` at the end. When touching auth/input/API, always add `master-security`.

---

## Conflict Resolution — When Multiple Routes Are Valid

| Conflict | Resolution |
|---|---|
| `go-reviewer` vs `master-reviewer` | Use `go-reviewer` for idiomatic/concurrency issues; use `master-reviewer` when you need CRITICAL/HIGH severity triage across the whole file |
| `python-reviewer` vs `master-reviewer` | `python-reviewer` for PEP 8, type hints, Pythonic patterns; `master-reviewer` when security or architecture is also in scope |
| `kotlin-reviewer` vs `master-reviewer` | `kotlin-reviewer` for null safety, coroutines, Compose; `master-reviewer` for cross-cutting architecture review |
| `database-reviewer` vs `database-specialist` | `database-specialist` for design/schema decisions; `database-reviewer` for reviewing existing queries/migrations |
| `master-security` vs `security-auditor-agent` | `master-security` during development; `security-auditor-agent` for pre-deploy full audit |
| `tdd-guide` vs `e2e-runner` | `tdd-guide` for unit/integration TDD; `e2e-runner` for critical user flows only |
| `research-agent` vs individual researchers | `research-agent` for open-ended multi-source research; individual commands (`/web-researcher`, `/github-researcher`) for targeted single-source lookup |
| `code-explorer` vs `repo-intelligence-agent` | `code-explorer` for deep feature tracing; `repo-intelligence-agent` for full-repo architecture understanding |
| `implementation-agent` vs language specialist | Use language specialist (`typescript-specialist`, `python-specialist`) when strict typing or idiomatic patterns are the primary concern |

---

## DOMAIN 1 — CODE: Writing & Implementation

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Any new code / feature | `implementation-agent` | `coding-standards` | — |
| Generate code from spec | `implementation-agent` | — | `/code-implementation-generator` |
| TypeScript / JS | `typescript-specialist` | `coding-standards` | — |
| Python | `python-specialist` | `python-patterns` | — |
| Go | `implementation-agent` | `golang-patterns` | — |
| Kotlin / KMP | `implementation-agent` | `kotlin-patterns` + `kotlin-coroutines-flows` | — |
| Java / Spring Boot | `implementation-agent` | `java-coding-standards` | — |
| C++ | `implementation-agent` | `cpp-coding-standards` | — |
| Perl | `implementation-agent` | `perl-patterns` | — |
| Swift / iOS / SwiftUI | `implementation-agent` | `swiftui-patterns` | — |
| Android / Jetpack Compose | `implementation-agent` | `android-clean-architecture` | — |
| Compose Multiplatform / KMP | `implementation-agent` | `compose-multiplatform-patterns` | — |
| REST API design | `master-architect` | `api-design` | — |
| Backend service | `implementation-agent` | `backend-patterns` | — |
| Frontend (React / Next.js) | `implementation-agent` | `frontend-patterns` | — |
| Django app | `implementation-agent` | `django-patterns` | — |
| Spring Boot app | `implementation-agent` | `springboot-patterns` | — |
| Kotlin Ktor | `implementation-agent` | `kotlin-ktor-patterns` | — |
| Kotlin Exposed ORM | `implementation-agent` | `kotlin-exposed-patterns` | — |
| JPA / Hibernate | `implementation-agent` | `jpa-patterns` | — |
| Docker / containerization | `implementation-agent` | `docker-patterns` | — |
| Deployment / CI/CD | `implementation-agent` | `deployment-patterns` | — |
| Database schema / queries | `database-specialist` | `database-migrations` | — |
| PostgreSQL | `database-reviewer` | `postgres-patterns` | — |
| Boilerplate / scaffold | `base-template-generator` | — | — |
| Simplify / clean up code | `code-simplifier` | — | — |
| Dead code removal | `refactor-cleaner` | — | `/refactor-clean` |
| Explore codebase → implement | `code-explorer` → `code-architect` | — | — |
| Content hash caching | `implementation-agent` | `content-hash-cache-pattern` | — |
| DDD / V3 architecture | `implementation-agent` | `v3-ddd-architecture` | — |
| Blueprint / spec doc | — | `blueprint` | — |
| Swift actor / persistence | `implementation-agent` | `swift-actor-persistence` | — |
| Swift concurrency | `implementation-agent` | `swift-concurrency-6-2` | — |
| Swift protocol + DI | `implementation-agent` | `swift-protocol-di-testing` | — |

---

## DOMAIN 2 — DEBUG: Errors, Crashes, Performance

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Any build failure | `master-debugger` | — | `/build-fix` |
| Go build error | `go-build-resolver` | — | `/go-build` |
| Kotlin / Gradle build | `kotlin-build-resolver` | — | `/kotlin-build` `/gradle-build` |
| Runtime error / log | `master-debugger` | — | `/error-log-analyzer` |
| Stack trace | `master-debugger` | — | `/stacktrace-analyzer` |
| API / HTTP failures | `debugging-agent` | — | `/api-integration-debugger` |
| Dependency version conflict | `debugging-agent` | — | `/dependency-conflict-detector` |
| Environment / Docker issue | `debugging-agent` | — | `/environment-debugger` |
| Config file issue | `debugging-agent` | — | `/configuration-analyzer` |
| Performance / memory / CPU | `master-debugger` | `performance-analysis` | `/performance-debugger` |
| Failing test root cause | `master-debugger` | — | `/failing-test-analyzer` |
| Minimal reproduction | `debugging-agent` | — | `/minimal-reproduction-builder` |
| Fix strategy (final step) | `debugging-agent` | — | `/fix-strategy-generator` |
| Dependency testing gaps | `debugging-agent` | — | `/dependency-testing-analyzer` |
| Execution path trace | `debugging-agent` | — | `/execution-path-analyzer` |

---

## DOMAIN 3 — TEST: TDD, E2E, Coverage

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| TDD workflow (new feature) | `tdd-guide` | `tdd-workflow` | `/tdd` |
| E2E tests (Playwright) | `e2e-runner` | `e2e-testing` | `/e2e` |
| Test scaffold | — | — | `/test-scaffold-generator` |
| Test coverage report | — | — | `/test-coverage` |
| Python tests | `python-reviewer` | `python-testing` | — |
| Go tests | — | `golang-testing` | `/go-test` |
| Kotlin tests | — | `kotlin-testing` | `/kotlin-test` |
| C++ tests | — | `cpp-testing` | — |
| Perl tests | — | `perl-testing` | — |
| Django TDD | `tdd-guide` | `django-tdd` + `django-verification` | — |
| Spring Boot TDD | `tdd-guide` | `springboot-tdd` + `springboot-verification` | — |
| Eval harness | — | `eval-harness` | `/eval` |
| Verification pipeline | — | `verification-loop` | `/verify` |
| Quality gate (all checks) | — | — | `/quality-gate` |

---

## DOMAIN 4 — REVIEW: Code, PRs, Quality

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| General code review | `master-reviewer` | — | `/code-review` |
| Python review | `python-reviewer` | — | `/python-review` |
| Go review | `go-reviewer` | — | `/go-review` |
| Kotlin review | `kotlin-reviewer` | — | `/kotlin-review` |
| Database review | `database-reviewer` | — | — |
| PR full lifecycle | `review-agent` | — | — |
| Maintainer feedback → response | `review-agent` | `maintainer-feedback-interpreter` | — |
| Bot / CI feedback | `review-agent` | `bot-feedback-analyzer` | — |
| Human-sounding reply | `review-agent` | `human-response-drafter` | — |
| Maintainer formal reply | `review-agent` | `maintainer-reply-writer` | — |
| Bot reply | `review-agent` | `bot-reply-writer` | — |
| PR change implementation | `review-agent` | `pr-change-implementer` | — |
| Review report | `review-agent` | `review-report-generator` | — |
| Architecture decision review | — | `architecture-decision-reviewer` | — |
| Maintainability review | — | `maintainability-reviewer` | — |
| Documentation review | — | `documentation-reviewer` | — |
| Performance impact review | — | `performance-impact-reviewer` | — |
| Security impact review | — | `security-impact-reviewer` | — |
| Test coverage review | — | `test-coverage-reviewer` | — |
| Code quality style review | — | `code-quality-reviewer` | — |
| Skill library audit | `skill-evolution-agent` | `skill-stocktake` | — |
| Plankton code quality | — | `plankton-code-quality` | — |
| GitHub PR analysis | — | `github-pr-analyzer` | — |
| Requested changes evaluation | — | `requested-change-evaluator` | — |

---

## DOMAIN 5 — SECURITY: Audits, Scanning, Hardening

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Security review during dev | `master-security` | `security-review` | — |
| Full pre-deploy audit | `security-auditor-agent` | `security-scan` | — |
| Access control audit | `master-security` | `access-control-auditor` | — |
| API security | `master-security` | `api-security-auditor` | — |
| Auth / session audit | `master-security` | `auth-audit` | — |
| Attack surface mapping | `master-security` | `attack-surface-mapper` | — |
| Injection detection (SQLi/XSS) | `master-security` | `injection-detector` | — |
| Secret scanning | `master-security` | `secret-scanner` | — |
| Infrastructure hardening | `master-security` | `infrastructure-security-auditor` | — |
| Dependency CVE audit | `master-security` | `dependency-audit` | — |
| Django security | `master-security` | `django-security` | — |
| Spring Boot security | `master-security` | `springboot-security` | — |
| Perl security | `master-security` | `perl-security` | — |
| Security report generation | `master-security` | `security-report-generator` | — |
| Remediation implementation | `implementation-agent` | — | — |

---

## DOMAIN 6 — PLAN: Architecture, Design, Estimation

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| New feature plan | `master-architect` | — | `/plan` |
| System design | `solution-architecture-agent` | — | — |
| Full project planning | `project-planner-agent` | — | — |
| Complex feature (5-phase) | — | `sparc-methodology` | `/sparc` |
| Architecture patterns | — | `architecture-pattern-selector` | `/architecture-pattern-selector` |
| Architecture synthesis | — | `architecture-synthesizer` | `/architecture-synthesizer` |
| Component design | — | `component-identifier` | `/component-identifier` |
| Data flow design | — | `data-flow-designer` | `/data-flow-designer` |
| Constraint analysis | — | `constraint-analyzer` | `/constraint-analyzer` |
| Problem requirements | — | — | `/problem-requirement-extractor` |
| Problem classification | — | — | `/problem-classifier` |
| Scope analysis | — | `scope-analyzer` | — |
| Risk planning | — | `risk-planner` | — |
| Scalability planning | — | `scalability-planner` | `/scalability-planner` |
| Failure mode analysis | — | `failure-mode-analyzer` | `/failure-mode-analyzer` |
| Effort estimation | — | `effort-estimator` | — |
| Complexity estimation | — | `complexity-estimator` | — |
| Milestone generation | — | `milestone-generator` | — |
| Team capacity planning | — | `team-capacity-planner` | — |
| Task decomposition | — | `task-dependency-mapper` | `/task-decomposer` |
| Project structure gen | — | `project-structure-generator` | `/project-structure-generator` |
| Project plan compile | — | `project-plan-compiler` | — |
| Interface contracts | — | `interface-contract-designer` | `/interface-contract-designer` |
| Integration assembly | — | `integration-assembler` | `/integration-assembler` |
| Multi-project plan | — | — | `/multi-plan` |
| Backend + frontend parallel | — | — | `/multi-backend` + `/multi-frontend` |
| Execute multi-agent parallel | — | — | `/multi-execute` |
| Full multi-workflow | — | — | `/multi-workflow` |
| Custom orchestration | — | — | `/orchestrate` |
| High-stakes decisions | — | `hive-mind-advanced` | — |
| Task type classification | — | `task-type-classifier` | — |

---

## DOMAIN 7 — RESEARCH: Web, Papers, Code, Synthesis

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| General technical research | `research-agent` | — | — |
| Web / official docs | — | — | `/web-researcher` |
| GitHub / open source | — | — | `/github-researcher` |
| Stack Overflow | — | — | `/stackoverflow-researcher` |
| Hacker News sentiment | — | — | `/hackernews-researcher` |
| Reddit practitioner views | — | — | `/reddit-researcher` |
| Twitter / X trends | — | — | `/twitter-researcher` |
| Academic papers | — | — | `/paper-analyzer` |
| Synthesize multiple sources | — | `deep-research` | `/research-synthesizer` |
| Neural search (Exa) | — | `exa-search` | — |
| Technology comparison | — | — | `/technology-comparison` |
| Technology selection | — | `technology-selection-advisor` | `/technology-selection-advisor` |
| Market research | — | `market-research` | — |

---

## DOMAIN 8 — REPO: Exploration, Analysis, Contribution

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Full repo analysis | `repo-intelligence-agent` | — | — |
| Repo overview | — | — | `/repo-overview` |
| Repo structure map | — | — | `/repo-structure-analyzer` |
| Repo activity / history | — | — | `/repo-activity-analyzer` |
| Codebase deep exploration | `code-explorer` | — | — |
| Feature architecture in repo | `code-architect` | — | — |
| Find issues to fix | — | — | `/issue-finder` |
| Contribution opportunities | — | — | `/contribution-oppurtunity-analyzer` |
| Ecosystem scan | — | — | `/ecosystem-scanner` |
| Implementation validation | — | `implementation-validator` | `/implementation-validator` |

---

## DOMAIN 9 — DOCS & COMMS: Documentation, Communication

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Update project docs | `doc-updater` | — | `/update-docs` |
| Update codemaps | `doc-updater` | — | `/update-codemaps` |
| Documentation analysis | — | `documentation-analyzer` | `/documentation-analyzer` |
| Documentation generation | — | `documentation-generator` | `/documentation-generator` |
| Update CLAUDE.md | — | — | `/update-claude-md` |
| Email / Slack / LINE / Messenger | `chief-of-staff` | — | — |
| Article writing | — | `article-writing` | — |
| Social content creation | — | `content-engine` | — |
| Crosspost content | — | `crosspost` | — |
| Frontend slides / presentations | — | `frontend-slides` | — |
| Humanize AI-generated text | — | `humanizer` | — |
| PDF generation | — | `pdf-maker` | — |
| Visa / document translation | — | `visa-doc-translate` | — |

---

## DOMAIN 10 — AI & AGENT SYSTEMS

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Claude / Anthropic API | — | `claude-api` | — |
| Agent SDK (TypeScript) | `agent-sdk-verifier-ts` | — | — |
| Agent SDK (Python) | `agent-sdk-verifier-py` | — | — |
| Build agentic systems | — | `agentic-engineering` | — |
| Autonomous agent loops | `loop-operator` | `autonomous-loops` | `/loop-start` `/loop-status` |
| Continuous operation patterns | `loop-operator` | `continuous-agent-loop` | — |
| Continuous learning (stable) | — | `continuous-learning` | — |
| Continuous learning (adaptive) | — | `continuous-learning-v2` | — |
| Agent harness build | `harness-optimizer` | `agent-harness-construction` | `/harness-audit` |
| Eval-driven development | — | `eval-harness` | `/eval` |
| Verification pipeline | — | `verification-loop` | `/verify` |
| Cost-aware LLM pipeline | — | `cost-aware-llm-pipeline` | — |
| Prompt optimization | — | `prompt-optimizer` | `/prompt-optimize` |
| Prompt refining | — | `prompt-refiner` | — |
| Iterative retrieval | — | `iterative-retrieval` | — |
| Search-first patterns | — | `search-first` | — |
| Deep research pipeline | — | `deep-research` | — |
| Neural search (Exa) | — | `exa-search` | — |
| Dmux multi-agent | — | `dmux-workflows` | — |
| SPARC pipeline | — | `sparc-methodology` | `/sparc` |
| Parallel swarm (3+ streams) | `project-coordinator` | `swarm-orchestration` | — |
| High-stakes decision | — | `hive-mind-advanced` | — |
| Persistent agent memory | — | `agentdb-memory-patterns` | — |
| Hooks automation | — | `hooks-automation` | — |
| Advanced agent techniques | — | `agentic-jujutsu` | — |
| Pair programming mode | — | `pair-programming` | — |
| Enterprise agent ops | — | `enterprise-agent-ops` | — |
| AI-first engineering | — | `ai-first-engineering` | — |
| Regex vs LLM decision | — | `regex-vs-llm-structured-text` | — |

---

## DOMAIN 10b — INTEGRATIONS & TOOLS

| Task Pattern | Skill | Notes |
|---|---|---|
| ClickHouse integration | `clickhouse-io` | Analytics at scale |
| Nanoclaw REPL | `nanoclaw-repl` | Interactive agent REPL |
| Foundation models on-device | `foundation-models-on-device` | Edge inference |
| X / Twitter API | `x-api` | Post, threads, analytics |
| FAL.ai media generation | `fal-ai-media` | Image / video / audio |
| Video DB | `videodb` | Video pipeline |
| Video editing | `video-editing` | Programmatic editing |
| Nutrient document processing | `nutrient-document-processing` | Doc workflows |
| Liquid glass UI design | `liquid-glass-design` | Apple Vision design |

---

## DOMAIN 11 — BUSINESS DOMAINS

| Task Pattern | Skill |
|---|---|
| Market research | `market-research` |
| Investor materials (deck/memo) | `investor-materials` |
| Investor outreach | `investor-outreach` |
| Strategic context management | `strategic-compact` |
| Carrier relationship | `carrier-relationship-management` |
| Customs & trade compliance | `customs-trade-compliance` |
| Energy procurement | `energy-procurement` |
| Inventory & demand planning | `inventory-demand-planning` |
| Logistics exception management | `logistics-exception-management` |
| Production scheduling | `production-scheduling` |
| Quality nonconformance | `quality-nonconformance` |
| Returns & reverse logistics | `returns-reverse-logistics` |

---

## DOMAIN 12 — META: Skills, Sessions, Routing

| Task Pattern | Agent | Skill | Command |
|---|---|---|---|
| Commit + push + open PR | — | — | `/commit-push-pr` |
| Save session state | — | — | `/save-session` |
| Resume prior session | — | — | `/resume-session` |
| Checkpoint mid-task | — | — | `/checkpoint` |
| Extract session patterns | — | — | `/learn` |
| Extract + self-evaluate | — | — | `/learn-eval` |
| Cluster instincts → skills | — | — | `/evolve` |
| Evolve + write to disk | — | — | `/evolve --generate` |
| Create new skill from history | — | — | `/skill-create` |
| Skill library full audit | `skill-evolution-agent` | `skill-stocktake` | — |
| Skill gap detection | `skill-evolution-agent` | `skill-gap-detector` | — |
| Skill quality evaluation | `skill-evolution-agent` | `skill-evaluator` | — |
| Skill weakness analysis | `skill-evolution-agent` | `skill-weakness-analyzer` | — |
| Skill improvement | `skill-evolution-agent` | `skill-improvement-generator` | — |
| Skill compatibility check | `skill-evolution-agent` | `skill-compatibility-validator` | — |
| Skill version management | `skill-evolution-agent` | `skill-version-manager` | — |
| Configure ECC harness | — | `configure-ecc` | — |
| Harness optimization | `harness-optimizer` | — | `/harness-audit` |
| Cost-optimal model routing | — | — | `/model-route` |
| Project list | — | — | `/projects` |
| Session list | — | — | `/sessions` |
| PM2 process management | — | — | `/pm2` |
| Background thought | — | — | `/aside` |
| CLAW tool | — | — | `/claw` |
| Promote / deploy | — | — | `/promote` |
| Instinct import | — | — | `/instinct-import` |
| Instinct export | — | — | `/instinct-export` |
| Instinct status | — | — | `/instinct-status` |
| Setup project manager | — | — | `/setup-pm` |
| GitHub workflow automation | — | `github-workflow-automation` | — |
| Project guidelines template | — | `project-guidelines-example` | — |
| Ralphinho RFC pipeline | — | `ralphinho-rfc-pipeline` | — |

---

## Execution Strategies

| Strategy | Trigger | Pattern |
|---|---|---|
| **Single** | One domain, one file, one specialist | Call agent or invoke skill directly |
| **Pipeline** | Touches 2+ modules, or has a natural before/after (plan→implement, implement→review) | Chain agents sequentially; pass each output as context to the next |
| **SPARC** | Ambiguous requirements, cross-cutting feature, 4+ files to change | `/sparc [task]` — 5-phase: Spec → Pseudocode → Arch → Refine → Complete |
| **Swarm** | 3+ truly independent workstreams that can run in parallel | `project-coordinator` → parallel agents (max 8) → `master-reviewer` |
| **Hive-Mind** | High-stakes irreversible decision (schema change, library migration, major refactor) | `hive-mind-advanced` → 5 parallel analysts → vote tally + minority view + confidence score |

**Single vs Pipeline decision rule:** if the task touches only one module and one concern → Single. If it touches multiple modules, or has a dependency between steps (you must know X before you can do Y), or the output of one step changes what the next step does → Pipeline.

### Auto-apply pipelines (always, no exceptions):
- **After any code write** → `master-reviewer`
- **Auth / API / input code** → `master-security` after `master-reviewer`
- **New feature** → `tdd-guide` *before* `implementation-agent` (TDD-first)
- **Build fails** → `master-debugger` before anything else
- **PR opened / feedback received** → `review-agent` owns the lifecycle
- **Docs changed** → `doc-updater` after implementation
- **Session ends with patterns** → `/learn` then `/evolve`

---

## Output Format

```
Domain: [domain name]
Strategy: [Single | Pipeline | SPARC | Swarm | Hive-Mind]
Path: [agent] + [skill] + [command]

Phase 1: [resource] → [output]
Phase 2: [resource] → [output]
...
Final: [deliverable]
```

**Concrete example — "Add JWT auth to the Django API":**
```
Domain: CODE + SECURITY + TEST (multi-domain)
Strategy: Pipeline
Path: implementation-agent(django-patterns) → master-security(auth-audit) → tdd-guide(django-tdd) → master-reviewer

Phase 1: implementation-agent + django-patterns → JWT middleware, login/logout views, token refresh
Phase 2: master-security + auth-audit → verify token expiry, rotation, httpOnly cookies, no secrets in code
Phase 3: tdd-guide + django-tdd → tests for login, logout, expired token, missing token, refresh
Phase 4: master-reviewer → code quality, error handling, edge cases

Final: Secure, tested JWT auth ready for PR
```

Always pass phase outputs as context to next phases. Never collapse parallel phases into one.
