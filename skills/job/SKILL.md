---
name: job
description: AI-powered job search workflow based on career-ops. Use when the user is searching for a job, evaluating a job offer/JD/URL, tailoring a CV to a role, scanning company career portals, tracking applications, preparing STAR interview stories, drafting salary negotiation messages, or writing LinkedIn outreach. Triggers on phrases like "evaluate this job", "score this offer", "tailor my CV", "should I apply", "scan careers", "prep for this interview", "negotiate this offer".
origin: user
metadata:
  author: devs6186+dev-os
  version: 1.0
  category: career
---

# Job — AI Job Search Command Center

Wraps the [santifer/career-ops](https://github.com/santifer/career-ops) workflow into a skill. Turns the AI assistant into a filter that evaluates job offers, tailors CVs, and tracks a pipeline — so the user only spends time on roles actually worth applying to.

> **Core philosophy:** career-ops is a *filter*, not a spray-and-pray tool. It should **discourage** applying to anything scoring below 4.0/5. Human-in-the-loop — AI evaluates and recommends, the user always makes the final call. **Never auto-submit an application.**

## When to Activate

- User pastes a **job URL, JD text, or company careers link** — even without an explicit command
- User asks to **evaluate / score / rate** a role, or asks "should I apply to this?"
- User wants a **tailored CV / resume** for a specific job
- User wants to **scan company career pages**
- User wants to **batch-evaluate** multiple offers
- User asks for **interview prep** — STAR+Reflection stories, behavioral questions
- User asks for **salary negotiation** scripts, geo-discount pushback, competing-offer leverage
- User wants to **track** applications, see pipeline status, or filter by stage
- User wants a **LinkedIn outreach** or cold contact message for a role
- User asks to do **deep company research** before applying

## Setup (first-time only)

Check if `~/career-ops/` exists. If not, guide the user through install:

```bash
git clone https://github.com/santifer/career-ops.git ~/career-ops
cd ~/career-ops
npm install
npx playwright install chromium
npm run doctor
cp config/profile.example.yml config/profile.yml      # edit with user details
cp templates/portals.example.yml portals.yml          # customize companies
# Create cv.md in project root with the user's CV in markdown
```

**Key files to populate:**
- `cv.md` — their CV in markdown (source of truth)
- `config/profile.yml` — name, target roles, comp expectations, geo, preferences
- `article-digest.md` (optional) — proof points, wins, metrics, career story
- `portals.yml` — companies to scan

## Command Map

| Intent | Command |
|--------|---------|
| Show all commands | `/career-ops` |
| Full auto-pipeline (evaluate + PDF + tracker) | `/career-ops {paste JD or URL}` |
| Evaluate one JD only | `/career-ops-evaluate --file ./jds/role.txt` |
| Scan pre-configured company portals | `/career-ops scan` |
| Generate ATS-optimized tailored CV PDF | `/career-ops pdf` |
| Batch-evaluate many offers in parallel | `/career-ops batch` |
| View application tracker | `/career-ops tracker` |
| Draft LinkedIn outreach message | `/career-ops contacto` |
| Deep company research | `/career-ops deep` |
| Interview prep | `/career-ops interview` |
| Salary negotiation script | `/career-ops negotiate` |

Or just paste a job URL/JD directly — career-ops auto-detects it and runs the full pipeline.

## Evaluation Framework

Every JD gets scored **A–F across 10 weighted dimensions** producing a 0–5 score. Each evaluation contains 6 blocks:

1. **Role summary** — what this role actually is (past the buzzwords)
2. **CV match** — strengths, gaps, red flags against `cv.md`
3. **Level strategy** — stretch, lateral, or downlevel? how to pitch it
4. **Comp research** — market benchmark, expected band, geo adjustment
5. **Personalization** — why this company, why now, concrete hooks
6. **Interview prep** — STAR+Reflection stories from the user's proof points

**Hard rule:** If score < 4.0/5, recommend **do not apply**. Do not generate a PDF unless user explicitly overrides.

## CV Tailoring Rules

- Read `cv.md` as source of truth — never invent skills or experience
- Inject keywords from JD **only if the user actually has that experience**
- Reorder bullets to front-load what matches the JD
- Output as `output/{company}-{role}.pdf` via Playwright
- ATS-optimized: no tables, no images in critical paths

## Interview Story Bank

Each evaluation contributes STAR+R stories to a shared bank. Format every story as:
- **Situation** — context (1–2 sentences)
- **Task** — the specific problem the user owned
- **Action** — what *they* did (not "the team") — quantified
- **Result** — outcome with metrics
- **Reflection** — what they'd do differently, what they learned

## Negotiation Scripts

- Never apologize for asking
- Anchor on market data (comp research block)
- Address one issue at a time (base → equity → bonus → start date)
- For geo-discount pushback: focus on role scope and market rate
- Always give the recruiter a clear path to "yes"

## Hard Rules

1. **Never auto-submit** an application. The user always clicks submit.
2. **Never invent experience** on a CV.
3. **Respect the <4.0 floor.** Low-score roles don't get PDFs by default.
4. **Data stays local.** CV, contacts, tracker — all on the user's machine.
5. **AI recommends, user decides.** Frame every output as a recommendation.
