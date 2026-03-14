# AI Dev Rig — skills-for-coding

> A modular AI skill library for engineers, PMs, and builders. Architecture reviews, PRDs, n8n automation, design, document workflows — production-grade skills that plug directly into Claude Code or any LLM dev environment.

- **Paste a skill into your AI context and get senior-level output, not a draft to fix.**
- **Chain skills together for end-to-end workflows: idea → spec → architecture → automation.**
- **Works today with Claude Code, Cursor, or any system-prompt-capable model.**

Built by **Ishaan Bansal** — Data Science & AI undergrad at Masters' Union ('29), AI product builder (cIAo, agentic workflows, n8n automations).

---

## Core Capabilities

| Capability | What it does | Key folders |
|---|---|---|
| **Architecture reviews** | Scalability, API design, DB schema, service boundary analysis for new and existing systems | `architect-review`, `webapp-testing` |
| **Project scaffolding** | Opinionated bootstrapping with phase-based planning, roadmaps, and execution tracking | `new-project`, `gsd`, `gsd-commands`, `gsd-agents` |
| **n8n automation** | Build, validate, and optimize n8n workflows end-to-end — nodes, expressions, code, and patterns | `n8n-workflow-builder`, `n8n-workflow-patterns`, `n8n-validation-expert`, `n8n-node-configuration`, `n8n-expression-syntax`, `n8n-code-javascript`, `n8n-code-python`, `n8n-mcp-tools-expert` |
| **Product & docs** | PRDs, internal comms, escalation briefs, market research, and doc co-authoring | `prd`, `internal-comms`, `market-research-reports`, `doc-coauthoring`, `escalation` |
| **Design & UX** | UI components, canvas art, Figma MCP integration, diagrams, web artifacts | `frontend-design`, `canvas-design`, `figma`, `web-artifacts-builder`, `excalidraw-diagram-generator`, `theme-factory` |
| **File & data handling** | Reliable processing of PDFs, Word docs, slide decks, and spreadsheets | `pdf`, `docx`, `pptx`, `xlsx` |
| **Plugins & agents** | Curated external MCPs, official plugins, and agent behavior configuration | `official-plugins`, `external-plugins`, `gsd-agents`, `AGENTS.md` |
| **Dev utilities** | Self-healing on errors, skill creation, MCP server building, web scraping | `self-anneal`, `skill-creator`, `mcp-builder`, `firecrawl-scraper` |
| **Brand & content** | Brand voice enforcement, visual brand guidelines, generative art, Slack assets | `brand-voice`, `brand-guidelines`, `algorithmic-art`, `slack-gif-creator` |

---

## How to Use These Skills

Each skill is a `SKILL.md` file inside its folder. To use one:

1. Open the `SKILL.md` for the capability you need.
2. Paste its contents as a system prompt or into your Claude Code / Cursor context.
3. Follow the usage recipe below for your task.

---

### Recipe 1 — Architecture review on an existing app

**Context to provide:** Your stack (e.g., Next.js 14 + Postgres + Redis), current directory structure, and a 2–3 sentence description of the bottleneck or concern.

**Skill:** `architect-review/SKILL.md`

```text
System: [paste contents of architect-review/SKILL.md]

User:
I'm building a multi-tenant SaaS on Next.js 14, Postgres (via Prisma), and Redis for caching.
We're seeing slow dashboard loads at ~500 concurrent users. Here's my schema: [paste schema].
Here's my API route structure: [paste routes].

Please review:
1. Database query patterns and indexing strategy
2. Caching layer design
3. Any service boundary or scaling risks at 10x current load
```

---

### Recipe 2 — PRD + internal comms from a raw idea

**Context to provide:** A rough idea or user problem in 3–5 sentences.

**Skills:** `prd/SKILL.md` → then `internal-comms/SKILL.md`

```text
System: [paste contents of prd/SKILL.md]

User:
Idea: A lightweight tool that monitors a Postgres database and sends a Slack alert
when any table grows faster than a configurable threshold.

Target users: Backend engineers at small teams without a data team.
Generate a full PRD including problem statement, success metrics, user stories,
and technical requirements.
```

Then pass the PRD output into `internal-comms/SKILL.md` to generate a launch brief or stakeholder update.

---

### Recipe 3 — Design and validate an n8n workflow

**Context to provide:** What you want to automate — the trigger, the steps, and the destination.

**Skills:** `n8n-workflow-builder/SKILL.md` → `n8n-validation-expert/SKILL.md`

```text
System: [paste contents of n8n-workflow-builder/SKILL.md]

User:
Build an n8n workflow that:
1. Triggers when a new row is added to a Supabase table called `leads`
2. Enriches the lead using the Apollo.io API (GET /people/match)
3. Posts a formatted Slack message to #sales-alerts with name, company, and score
4. If enrichment fails, writes the raw lead to a fallback Airtable base

Return the complete workflow JSON ready to import into n8n.
```

Then validate with `n8n-validation-expert/SKILL.md` to catch expression errors and node misconfigurations before running.

---

## Opinionated End-to-End Workflows

### Workflow A — Vague idea → shipped feature

| Step | Action | Skill |
|---|---|---|
| 1 | Turn a rough idea into a structured PRD with success metrics and user stories | `prd` |
| 2 | Run an architecture review on your current stack against the new requirements | `architect-review` |
| 3 | Scaffold the new service or feature with phased planning and task tracking | `new-project`, `gsd` |
| 4 | Build the frontend component or UI flow | `frontend-design`, `web-artifacts-builder` |
| 5 | Wire up any data sync or notification automation in n8n | `n8n-workflow-builder` |
| 6 | Write the internal comms (launch brief, team update) | `internal-comms` |

**Example:** Add usage analytics to your app — PRD → architecture review of your event pipeline → scaffold the analytics service → build a dashboard component → n8n workflow to sync events to your data warehouse → internal update to your team.

---

### Workflow B — Raw data + PDFs → research report + slides

| Step | Action | Skill |
|---|---|---|
| 1 | Extract and structure content from source PDFs or documents | `pdf`, `docx` |
| 2 | Run a market research analysis with competitive frameworks | `market-research-reports` |
| 3 | Generate a structured report with themes and citations | `doc-coauthoring` |
| 4 | Convert the report into a presentation deck | `pptx` |
| 5 | Apply a consistent visual theme | `theme-factory` |

**Example:** Preparing a competitive landscape — scrape competitor docs + industry PDFs → structure findings → generate a McKinsey-style research report → export to slides → apply brand theme.

---

## Repo Structure

```
skills-for-coding-/
│
├── AGENTS.md                     # 3-layer agent architecture (directives → orchestration → execution)
│
├── # ── ENGINEERING ────────────────────────────────────────────────────
├── architect-review/             # Scalability, API, DB, service boundary reviews
├── webapp-testing/               # Frontend & integration testing workflows
├── new-project/                  # 3-layer project scaffolding
├── gsd/                          # GSD system: spec-driven phase execution
├── gsd-commands/                 # Slash commands for GSD workflow
├── gsd-agents/                   # Specialist sub-agents (planner, executor, verifier, debugger)
│
├── # ── AUTOMATION ─────────────────────────────────────────────────────
├── n8n-workflow-builder/         # End-to-end n8n workflow creation
├── n8n-workflow-patterns/        # Proven architectural patterns for n8n
├── n8n-node-configuration/       # Operation-aware node config guidance
├── n8n-validation-expert/        # Validation error interpretation and fixing
├── n8n-expression-syntax/        # n8n expression syntax and debugging
├── n8n-code-javascript/          # JavaScript in n8n Code nodes
├── n8n-code-python/              # Python in n8n Code nodes
├── n8n-mcp-tools-expert/         # Guide for n8n-mcp MCP tools
│
├── # ── PRODUCT & DOCS ──────────────────────────────────────────────────
├── prd/                          # Product Requirement Documents
├── internal-comms/               # Status reports, launch briefs, leadership updates
├── market-research-reports/      # Porter's Five Forces, SWOT, TAM/SAM/SOM
├── doc-coauthoring/              # Collaborative documentation workflows
├── escalation/                   # Structured escalation briefs with impact + decision clarity
│
├── # ── DESIGN & UX ─────────────────────────────────────────────────────
├── frontend-design/              # Production-grade React/HTML/CSS components
├── canvas-design/                # Static visual design in PNG/PDF
├── figma/                        # Figma MCP integration — extract design tokens + assets
├── web-artifacts-builder/        # Multi-component HTML artifacts
├── excalidraw-diagram-generator/ # Flowcharts, architecture diagrams, mind maps
├── theme-factory/                # Apply design systems to any artifact
│
├── # ── FILE & DATA ─────────────────────────────────────────────────────
├── pdf/                          # PDF extraction, merging, OCR, form filling
├── docx/                         # Word document creation and editing
├── pptx/                         # PowerPoint presentation workflows
├── xlsx/                         # Excel/CSV creation, formula handling, analysis
│
├── # ── PLUGINS & AGENTS ────────────────────────────────────────────────
├── official-plugins/             # Curated official Claude Code plugins
├── external-plugins/             # Third-party MCP integrations (Supabase, Linear, GitHub…)
├── mcp-builder/                  # Guide for building custom MCP servers
│
├── # ── UTILITIES ───────────────────────────────────────────────────────
├── self-anneal/                  # Structured error recovery and debugging
├── skill-creator/                # Create, benchmark, and optimize new skills
├── firecrawl-scraper/            # Enterprise web scraping and data extraction
│
└── # ── BRAND & CONTENT ─────────────────────────────────────────────────
    ├── brand-voice/              # Brand tone, style guide, terminology enforcement
    ├── brand-guidelines/         # Visual brand standards
    ├── algorithmic-art/          # Generative art with p5.js
    └── slack-gif-creator/        # Animated GIFs for Slack
```

---

## Architecture Philosophy

This repo is built on a **3-layer agent architecture** (see `AGENTS.md`):

- **Layer 1 — Directive:** What to do. Skills as structured Markdown SOPs.
- **Layer 2 — Orchestration:** The model. Intelligent routing between directives and execution tools.
- **Layer 3 — Execution:** Deterministic scripts. API calls, data processing, file operations.

The core insight: *LLMs are probabilistic; business logic is deterministic. Push complexity into code. Let the model focus on decisions.*

90% accuracy per step → 59% success over 5 steps. This architecture keeps compounding errors from accumulating.

---

## Roadmap

This repo evolves with real projects, not hypothetical ones. Planned additions:

- [ ] **Test harnesses** — eval suites for skill output quality
- [ ] **Example projects** — 2–3 real mini-projects built end-to-end with these skills
- [ ] **CLI wrapper** — `npx run-skill <skill-name>` to invoke any skill from the terminal
- [ ] **n8n template library** — importable `.json` workflow templates for common automations
- [ ] **Per-folder mini-READMEs** — usage docs and example outputs for flagship skills

---

## About

**Ishaan Bansal** is a Data Science & AI undergrad at Masters' Union (class of '29), building at the intersection of agentic systems, product thinking, and automation. He treats AI as a co-engineer and co-PM — not a chat tool — and this repo is the working toolkit that reflects that.

Current projects: **cIAo** (AI product), agentic workflow systems, n8n automation pipelines.

[GitHub](https://github.com/ishaands12) · [LinkedIn](https://www.linkedin.com/in/ishaan-bansal-/)

---

*Skills are living documents. They get sharper with every real project they're run on.*
