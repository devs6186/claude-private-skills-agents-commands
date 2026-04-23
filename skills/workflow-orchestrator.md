---
name: workflow-orchestrator
description: Master front-door orchestration skill. Step 0 always invokes prompt-refiner for intent refinement, then inventories all installed skills and agents at runtime, classifies the task, and routes to the optimal execution strategy — single agent, pipeline, SPARC, swarm, or hive-mind. The single entry point for all complex tasks.
metadata:
  author: devs6186+dev-os
  version: 4.1
  category: orchestration
---

# Master Workflow Orchestrator v4.1

Write your query. This orchestrator handles everything else.

---

## STEP 0 — ALWAYS FIRST: Prompt Refiner

**Before any routing, planning, or execution — invoke `prompt-refiner`.**

```
User query (any form, any clarity)
  → prompt-refiner
      → Refined Execution Brief
          (canonical prompt · domains · risk · strategy · agent plan · quality gates)
  → workflow-orchestrator reads brief
  → executes the plan
```

`prompt-refiner` is not optional. Every execution begins here.

If `prompt-refiner` is unavailable, perform `internal_refinement` inline using the same fields (`intent`, `requested_outcome`, `scope`, `constraints`, `acceptance_criteria`, `risks`, `verification`, `out_of_scope`) and note the fallback.

---

## STEP 1 — Runtime Skill + Agent Inventory

After prompt-refiner completes, inventory all installed assets:

1. Inspect `~/.claude/skills/` — all 242 skills
2. Inspect `~/.claude/agents/` — all 36 agents
3. For each discovered skill/agent, classify as `primary_candidate`, `support_candidate`, or `irrelevant` given the refined prompt
4. If inventory cannot be completed, continue with reduced confidence

This means the orchestrator always routes based on what is actually installed — not a hardcoded assumption.

---

## STEP 2 — Task Classification

Assign exactly one value per axis from the refined brief:

- `work_type`: `research` · `planning` · `implementation` · `debugging` · `review` · `security` · `documentation` · `testing` · `infrastructure` · `content` · `business` · `skills` · `ai-agents` · `architecture`
- `codebase_impact`: `none` · `local` · `cross_module` · `architecture`
- `risk`: `low` · `medium` · `high`
- `verification_burden`: `light` · `standard` · `heavy`
- `execution_shape`: `single_skill` · `single_agent` · `sequential_pipeline` · `parallel_review_bundle` · `multi_agent` · `sparc` · `swarm` · `hive_mind`

**Risk rules**:
- `high` if: auth, payments, secrets, file uploads, external APIs, schema changes, destructive ops, deployments
- `medium` if: production code changes but no sensitive surface
- `low` if: docs-only or advisory work

**Verification burden**:
- `heavy` when `risk = high` or `codebase_impact` is `cross_module` or `architecture`
- `standard` for normal code changes
- `light` for advisory or docs-only

---

## STEP 3 — Primary Executor Selection

Apply these rules in order, stop at first match:

1. If a project-specific skill directly matches `work_type` + domain → choose it
2. If a domain-specific skill directly matches `work_type` + detected stack → choose it
3. Use this default primary mapping:

| Work Type | Primary |
|---|---|
| `research` | `research-agent` |
| `planning` | `master-architect` |
| `implementation` | `implementation-agent` |
| `debugging` | `master-debugger` |
| `review` | `master-reviewer` |
| `security` | `security-auditor-agent` |
| `documentation` | `doc-updater` |
| `testing` | `tdd-guide` |
| `infrastructure` | `deployment-patterns` |
| `content` | `content-engine` |
| `business` | best matching business-domain skill |
| `skills` | `skill-evolution-agent` |
| `ai-agents` | `agentic-engineering` |
| `architecture` | `solution-architecture-agent` |

4. Use `workflow-orchestrator` only when no narrower primary matches.

---

## STEP 4 — Support Bucket Selection

Check every bucket below. Mark each `support` or `skip`.

| Bucket | Mark `support` When | Typical Picks |
|---|---|---|
| Repository understanding | Code changes required, unfamiliar repo | `repo-overview`, `repo-structure-analyzer`, `code-explorer`, `repo-intelligence-agent`, `smart-explore` |
| Planning & architecture | `work_type = planning` or `codebase_impact = architecture` | `blueprint`, `task-decomposer`, `solution-architecture-agent`, `master-architect`, `make-plan`, `do` |
| Implementation | Code or scaffolding will be written | `implementation-agent`, `tdd-workflow`, `base-template-generator` |
| Debugging | Failing build, test, or runtime error | `failing-test-analyzer`, `error-log-analyzer`, `stacktrace-analyzer`, `fix-strategy-generator` |
| Review | Any code or config will change | `master-reviewer`, stack-specific reviewer |
| Security | `risk = high` or auth/secrets/APIs in scope | `master-security`, `security-review`, domain security skill |
| Testing & verification | Work is not purely advisory | `verification-loop`, `tdd-workflow`, `test-coverage-reviewer` |
| Documentation | Docs, codemaps, or public behavior changes | `doc-updater`, `documentation-reviewer` |
| Research | Facts, tool selection, or external evidence needed | `deep-research`, `web-researcher`, `research-synthesizer` |
| Language & framework | Specific stack detected | matching language skill + reviewer |
| Data & database | Queries, storage, migrations, or schema touched | `database-specialist`, `database-reviewer`, `database-migrations` |
| Infrastructure | CI, Docker, env, deploy, or ops touched | `docker-patterns`, `deployment-patterns`, `environment-debugger` |
| Performance | Latency, throughput, memory, or scale explicit | `performance-analysis`, `performance-debugger` |
| Skills & harness | Skills, hooks, or agent harnesses touched | `skill-evolution-agent`, `skill-compatibility-validator`, `hooks-automation` |
| Content & business | Writing or business-domain requirements | best matching content or business skill |
| AI & agents | Agent systems, Claude API, eval, hooks | `agentic-engineering`, `claude-api`, `eval-harness`, `agentdb-memory-patterns`, `mem-search`, `knowledge-agent`, `timeline-report` |

Selection rules:
- Choose the narrowest relevant skill first
- At most two support skills per bucket
- Skip if it duplicates the primary executor

---

## STEP 5 — Quality Gates

Apply these gate rules — never silently omit them:

| Gate | Activate When |
|---|---|
| Review gate | Code or config changes are in scope |
| Security gate | `risk = high` or auth/secrets/uploads/APIs/deployments in scope |
| Verification gate | Task is not purely advisory |
| Database gate | Schema, migrations, queries, or persistence contracts change |
| Documentation gate | Docs or public APIs change |
| TDD gate | New functionality is being added |

If a triggered gate is intentionally skipped, write the explicit reason.

---

## STEP 6 — Execution Strategy Selection

| Strategy | Use When |
|---|---|
| **Single Agent** | Task fits one specialist cleanly |
| **Sequential Pipeline** | Phases depend on each other |
| **SPARC** | Complex feature: full spec → pseudocode → architecture → refinement → completion |
| **Parallel Swarm** | 3+ independent workstreams with disjoint write scopes |
| **Hive-Mind** | High-stakes decision where multiple perspectives matter |

### SPARC
Phases: Specification → Pseudocode → Architecture → Refinement → Completion
Invoke: `/sparc [task]`
See: `sparc-methodology` skill

### Swarm
```
project-coordinator → breaks into workstreams (max 8 parallel)
→ [agent-A] [agent-B] [agent-C] (parallel, disjoint ownership)
→ master-reviewer → consolidate
```
See: `swarm-orchestration` skill (topologies: hierarchical / mesh / adaptive)

### Hive-Mind
```
Queen agent → defines the question
→ [researcher, architect, coder, tester, security-architect] (parallel, independent)
→ Queen → aggregates, surfaces minority view, confidence score
```
See: `hive-mind-advanced` skill

---

## STEP 7 — Execution Order

Always follow this sequence:

1. Step 0: `prompt-refiner` (canonical prompt)
2. Step 1: runtime inventory
3. Step 2: task classification
4. Step 3: primary executor selection
5. Step 4: support bucket selection
6. Step 5: quality gate selection
7. Step 6: execution strategy selection
8. Execute: primary → support → quality gates → verification close-out

If `execution_shape = parallel_review_bundle`: only parallelize read-only or disjoint write scopes.
If `execution_shape = multi_agent`: assign explicit ownership to each workstream before execution.

---

## Full Agent Reference (36 agents in ~/.claude/agents/)

### Master Series
| Agent | Use For |
|---|---|
| `master-architect` | Architecture, system design, planning, trade-off analysis |
| `master-reviewer` | Code quality review — after every implementation |
| `master-debugger` | Build errors, crashes, test failures, runtime bugs |
| `master-security` | Auth, API security, input handling, payment flows |

### Language Specialists
| Agent | Use For |
|---|---|
| `python-reviewer` | Python review (PEP 8, type hints, patterns) |
| `python-specialist` | Python implementation, idiomatic patterns |
| `go-reviewer` | Go review (idiomatic, concurrency, errors) |
| `go-build-resolver` | Go/`go build` + `go vet` failures |
| `kotlin-reviewer` | Kotlin/Android review (null safety, coroutines, Compose) |
| `kotlin-build-resolver` | Kotlin/Gradle build failures |
| `typescript-specialist` | TypeScript strict typing, generics, modules |

### Architecture & Planning
| Agent | Use For |
|---|---|
| `solution-architecture-agent` | End-to-end system architecture blueprint |
| `project-planner-agent` | Milestones, timelines, effort estimates |
| `project-coordinator` | Coordinate 3+ parallel agents |
| `master-architect` | PLAN mode: step-by-step plan with file paths |

### Implementation
| Agent | Use For |
|---|---|
| `implementation-agent` | Converts instructions into concrete code |
| `base-template-generator` | Production-ready boilerplate |
| `tdd-guide` | Test-first development |
| `code-simplifier` | Simplify and refine recently written code |
| `code-architect` | Code architecture design |

### Research & Exploration
| Agent | Use For |
|---|---|
| `research-agent` | Technical research, technology evaluation |
| `repo-intelligence-agent` | Codebase exploration and understanding |
| `code-explorer` | Fast codebase exploration by pattern/keyword |

### Security & Quality
| Agent | Use For |
|---|---|
| `security-auditor-agent` | Full pre-deployment security audit |
| `refactor-cleaner` | Dead code removal, consolidation |

### Database
| Agent | Use For |
|---|---|
| `database-reviewer` | PostgreSQL schema, queries, RLS, migrations |
| `database-specialist` | Schema design, indexing, query optimization |

### Testing
| Agent | Use For |
|---|---|
| `e2e-runner` | Playwright E2E generation and execution |
| `debugging-agent` | General debugging specialist |

### Operations & Meta
| Agent | Use For |
|---|---|
| `doc-updater` | Documentation and codemaps |
| `chief-of-staff` | Email, Slack, communication triage |
| `loop-operator` | Autonomous continuous agent loops |
| `harness-optimizer` | Agent harness configuration and optimization |
| `skill-evolution-agent` | Skill quality scoring, gap detection, improvement |
| `review-agent` | PR review lifecycle, maintainer interaction |
| `agent-sdk-verifier-py` | Verify Python Agent SDK applications |
| `agent-sdk-verifier-ts` | Verify TypeScript Agent SDK applications |

---

## Full Skill Reference (193 skills in ~/.claude/skills/)

### Debugging & Analysis
`error-log-analyzer` · `stacktrace-analyzer` · `dependency-conflict-detector` · `environment-debugger` · `configuration-analyzer` · `api-integration-debugger` · `performance-debugger` · `failing-test-analyzer` · `minimal-reproduction-builder` · `fix-strategy-generator` · `execution-path-analyzer` · `dependency-testing-analyzer` · `anti-pattern-czar` (cmd)

### Architecture & Planning
`problem-requirement-extractor` · `constraint-analyzer` · `architecture-pattern-selector` · `component-identifier` · `data-flow-designer` · `technology-selection-advisor` · `technology-comparison` · `scalability-planner` · `failure-mode-analyzer` · `architecture-synthesizer` · `architecture-decision-reviewer` · `scope-analyzer` · `risk-planner` · `task-decomposer` · `task-dependency-mapper` · `task-type-classifier` · `complexity-estimator` · `effort-estimator` · `milestone-generator` · `project-plan-compiler` · `project-structure-generator` · `project-guidelines-example` · `team-capacity-planner` · `blueprint` · `api-design` · `make-plan` · `do`

### Code Quality & Review
`code-quality-reviewer` · `maintainability-reviewer` · `documentation-reviewer` · `performance-impact-reviewer` · `security-impact-reviewer` · `test-coverage-reviewer` · `coding-standards` · `plankton-code-quality` · `implementation-validator` · `code-implementation-generator` · `problem-classifier`

### Security
`security-review` · `security-scan` · `auth-audit` · `access-control-auditor` · `api-security-auditor` · `attack-surface-mapper` · `injection-detector` · `secret-scanner` · `infrastructure-security-auditor` · `security-report-generator` · `security-impact-reviewer` · `dependency-audit`

### Testing
`tdd-workflow` · `e2e-testing` · `test-scaffold-generator` · `test-coverage-reviewer` · `python-testing` · `golang-testing` · `kotlin-testing` · `cpp-testing` · `perl-testing` · `failing-test-analyzer` · `dependency-testing-analyzer` · `django-tdd` · `django-verification` · `springboot-tdd` · `springboot-verification`

### Python
`python-patterns` · `python-testing` · `django-patterns` · `django-tdd` · `django-security` · `django-verification`

### Go
`golang-patterns` · `golang-testing`

### Kotlin / Android
`kotlin-patterns` · `kotlin-testing` · `kotlin-coroutines-flows` · `kotlin-ktor-patterns` · `kotlin-exposed-patterns` · `android-clean-architecture`

### Java / Spring Boot
`java-coding-standards` · `springboot-patterns` · `springboot-tdd` · `springboot-security` · `springboot-verification` · `jpa-patterns`

### Swift / iOS
`swiftui-patterns` · `swift-concurrency-6-2` · `swift-actor-persistence` · `swift-protocol-di-testing`

### C++
`cpp-coding-standards` · `cpp-testing`

### Perl
`perl-patterns` · `perl-security` · `perl-testing`

### TypeScript / JS / Frontend
`coding-standards` · `frontend-patterns` · `backend-patterns` · `e2e-testing`

### Cross-Platform
`compose-multiplatform-patterns` · `v3-ddd-architecture`

### Database
`postgres-patterns` · `database-migrations` · `jpa-patterns` · `kotlin-exposed-patterns`

### Infrastructure / DevOps
`docker-patterns` · `deployment-patterns` · `github-workflow-automation` · `configure-ecc` · `hooks-automation`

### Research
`web-researcher` · `github-researcher` · `stackoverflow-researcher` · `hackernews-researcher` · `reddit-researcher` · `twitter-researcher` · `paper-analyzer` · `research-synthesizer` · `deep-research` · `search-first` · `exa-search` · `iterative-retrieval`

### Documentation
`documentation-generator` · `documentation-analyzer` · `documentation-reviewer`

### AI / Agent Engineering
`claude-api` · `agentic-engineering` · `autonomous-loops` · `continuous-agent-loop` · `continuous-learning` · `continuous-learning-v2` · `eval-harness` · `verification-loop` · `agent-harness-construction` · `cost-aware-llm-pipeline` · `prompt-optimizer` · `dmux-workflows` · `sparc-methodology` · `swarm-orchestration` · `hive-mind-advanced` · `agentdb-memory-patterns` · `hooks-automation` · `agentic-jujutsu` · `pair-programming` · `enterprise-agent-ops` · `ai-first-engineering`

### Memory & Session Intelligence (claude-mem)
`mem-search` · `smart-explore` · `knowledge-agent` · `timeline-report`

### PR / Collaboration
`github-pr-analyzer` · `maintainer-feedback-interpreter` · `bot-feedback-analyzer` · `requested-change-evaluator` · `human-response-drafter` · `maintainer-reply-writer` · `bot-reply-writer` · `review-report-generator` · `pr-change-implementer`

### Performance
`performance-analysis` · `performance-debugger` · `performance-impact-reviewer`

### Content & Media
`article-writing` · `content-engine` · `crosspost` · `x-api` · `frontend-slides` · `video-editing` · `videodb` · `fal-ai-media` · `humanizer` · `pdf-maker`

### Data & Integrations
`clickhouse-io` · `nanoclaw-repl` · `regex-vs-llm-structured-text` · `foundation-models-on-device` · `nutrient-document-processing` · `visa-doc-translate` · `liquid-glass-design` · `content-hash-cache-pattern`

### Business Domain
`carrier-relationship-management` · `customs-trade-compliance` · `energy-procurement` · `inventory-demand-planning` · `logistics-exception-management` · `production-scheduling` · `quality-nonconformance` · `returns-reverse-logistics` · `market-research` · `investor-materials` · `investor-outreach` · `strategic-compact`

### Career
`job`

### Skill Evolution
`skill-evaluator` · `skill-gap-detector` · `skill-improvement-generator` · `skill-version-manager` · `skill-weakness-analyzer` · `skill-compatibility-validator` · `skill-stocktake`

### Repository Intelligence
`repo-activity-analyzer` · `repo-overview` · `repo-structure-analyzer` · `ecosystem-scanner` · `contribution-oppurtunity-analyzer` · `issue-finder` · `smart-explore`

### Orchestration
`prompt-refiner` · `workflow-orchestrator` · `sparc-methodology` · `swarm-orchestration` · `hive-mind-advanced` · `dmux-workflows`

### Misc / Utility
`integration-assembler` · `interface-contract-designer` · `ralphinho-rfc-pipeline` · `scope-analyzer` · `problem-classifier` · `blueprint` · `api-design` · `dev-workflow` · `claude-code-plugin-release`

### gstack Sprint Workflow (Garry Tan / YC)
Full-stack sprint toolkit with 40 skills — use as `gstack:autoplan`, `gstack:ship`, etc.

| Intent | gstack Skill |
|---|---|
| Auto-plan a task from context | `gstack:autoplan` |
| Plan + CEO review | `gstack:plan-ceo-review` |
| Plan + design review | `gstack:plan-design-review` |
| Plan + eng review | `gstack:plan-eng-review` |
| Plan + devex review | `gstack:plan-devex-review` |
| Plan fine-tuning | `gstack:plan-tune` |
| Ship a feature (full deploy) | `gstack:ship` |
| Land and deploy | `gstack:land-and-deploy` |
| Setup deploy pipeline | `gstack:setup-deploy` |
| QA / test run | `gstack:qa` · `gstack:qa-only` |
| Code review | `gstack:review` · `gstack:careful` |
| Design consultation | `gstack:design-consultation` |
| Design HTML prototype | `gstack:design-html` |
| Design review | `gstack:design-review` |
| Design shotgun (rapid ideas) | `gstack:design-shotgun` |
| Developer experience review | `gstack:devex-review` |
| Security guard check | `gstack:guard` |
| Canary deployment | `gstack:canary` |
| Freeze / unfreeze deployments | `gstack:freeze` · `gstack:unfreeze` |
| Browse / web search | `gstack:browse` |
| Investigate / debug | `gstack:investigate` |
| Health check | `gstack:health` |
| Benchmark model performance | `gstack:benchmark` · `gstack:benchmark-models` |
| Generate PDF | `gstack:make-pdf` |
| Document release | `gstack:document-release` |
| Pair programming agent | `gstack:pair-agent` |
| Context save / restore | `gstack:context-save` · `gstack:context-restore` |
| Session learning | `gstack:learn` |
| Upgrade gstack | `gstack:gstack-upgrade` |
| Sprint retrospective | `gstack:retro` |
| CSO briefing | `gstack:cso` |
| Office hours | `gstack:office-hours` |
| Open browser | `gstack:open-gstack-browser` |
| Browser cookies setup | `gstack:setup-browser-cookies` |
| Codex generation | `gstack:codex` |

---

## Automatic Triggers (always apply)

| Condition | Mandatory Action |
|---|---|
| After any code implementation | `master-reviewer` |
| New functionality | `tdd-guide` (test-first) |
| Auth/sessions/payments/user input | `master-security` |
| Database schema/query/migration | `database-reviewer` |
| Pre-deployment | `security-auditor-agent` + `master-reviewer` |
| Language-specific build failure | Go: `go-build-resolver` · Kotlin: `kotlin-build-resolver` · Python/TS: `master-debugger` |
| New patterns emerged in session | `skill-evolution-agent` (background) |
| Claude made a mistake | `/update-claude-md` |

---

## Fallback Rules

- `prompt-refiner` unavailable → `internal_refinement` inline, note fallback
- Runtime inventory incomplete → continue with reduced confidence, do not claim full coverage
- Two skills conflict → prefer project-specific over generic, domain-specific over broad, safety gates over convenience
- No suitable primary found → use `implementation-agent` for code, `research-agent` for research, `master-architect` for planning

---

## Mandatory End-State Checks

Before finishing, confirm every answer is `yes`:

1. Was `prompt-refiner` (or inline refinement) completed?
2. Was exactly one primary executor chosen?
3. Was every support bucket marked `support` or `skip`?
4. Were support skills limited to the minimum useful set (max 2 per bucket)?
5. Were all triggered quality gates added or explicitly justified as skipped?
6. Did the execution order match the selected execution shape?
7. Did the output include reduced-confidence notes where applicable?

If any answer is `no`, the orchestration plan is incomplete.

---

## Output Format

```
## Step 0: Refined Execution Brief
[Full output from prompt-refiner]

## Inventory Summary
- Skills available: 242 | Agents available: 36
- Inventory confidence: full | reduced
- Routing confidence: full | reduced

## Task Classification
- work_type: [...]
- codebase_impact: [...]
- risk: [...]
- verification_burden: [...]
- execution_shape: [...]

## Routing Plan
- Primary executor: [...]
- Support skills: [...]
- Quality gates: [...]

| Bucket | Decision | Selected |
|---|---|---|
| Review | support | master-reviewer |
| Security | skip | none — low risk |

## Execution Order
1. [step]
2. [step]
...

## Phase [N]: [Agent/Skill]
[output summary]

## Final Result
[deliverable]
```
