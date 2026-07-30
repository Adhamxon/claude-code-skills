# Claude Code Skills — Ultimate Agent Skill Collection

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Ready-6C47FF)](https://docs.anthropic.com/en/docs/claude-code/overview)
[![Skills](https://img.shields.io/badge/Skills-384-success)](https://github.com/Adhamxon/claude-code-skills)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Adhamxon/claude-code-skills/pulls)
[![Maintained](https://img.shields.io/badge/maintained-yes-success)](https://github.com/Adhamxon/claude-code-skills)

**384 skills + 5 specialized agents for Claude Code.** Drop the `.claude/` folder into any project and your terminal AI instantly gains expert capabilities — code review, TDD, architecture design, security auditing, document generation, deployment, and more.

Built from the best of Anthropic's official skills, Matt Pocock's engineering workflows, Addy Osmani's agent skills, Google Cloud, HuggingFace ML/AI, Wondelai book skills, and curated community tools. No config. No setup. Just `claude` and go.

---

## Why This Exists

Claude Code is already powerful out of the box. But skills and agents turn it into a **specialized toolchain**. Want a security audit? The `security-auditor` agent loads with OWASP expertise. Building a feature? `matt-tdd` runs the red-green-refactor cycle. Deploying to Vercel? The `vercel-deploy` skill handles configuration.

This collection packages **384 ready-to-use skills** and **5 agent personas** so you don't have to write them yourself.

---

## How It Works

Claude Code auto-discovers `.claude/` in your project root. Every session, it scans:

```
.claude/
├── agents/              # 5 agent personas (.md files)
└── skills/              # 384 skill definitions (SKILL.md files)
```

**Skills** are injected into context when your task matches their trigger conditions. Ask about PDF generation and the `pdf` skill loads automatically. Request a code review and `matt-code-review` activates.

**Agents** are full personas you switch to mid-session. Say "Switch to architect mode" and Claude adopts the architect's expertise, constraints, and working style.

---

## Quick Start

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Drop skills into your project
cp -r /path/to/claude-code-skills/.claude /path/to/your/project/.claude

# Or link directly
ln -s /path/to/claude-code-skills/.claude /path/to/your/project/.claude

# Go!
cd /path/to/your/project
claude
```

That's it. Claude Code loads everything automatically. Start asking questions.

> **Pro tip**: Use `claude -p "..."` for one-shot queries or start a full interactive session.

---

## Skills Catalog

The collection includes **384 skills** organized by domain:

### Anthropic Official (16)
`claude-api` · `mcp-builder` · `skill-creator` · `webapp-testing` · `frontend-design` · `theme-factory` · `brand-guidelines` · `canvas-design` · `algorithmic-art` · `xlsx` · `pptx` · `docx` · `pdf-anthropic` · `pdf` · `internal-comms` · `doc-coauthoring`

### Matt Pocock Engineering (22)
`matt-code-review` · `matt-tdd` · `matt-diagnosing-bugs` · `matt-domain-modeling` · `matt-implement` · `matt-research` · `matt-prototype` · `matt-wayfinder` · `matt-triage` · `matt-to-spec` · `matt-to-tickets` · `matt-codebase-design` · `matt-resolving-merge-conflicts` · `matt-improve-codebase-architecture` · `matt-writing-great-skills` · `matt-teach` · `matt-handoff` · `matt-grilling` · `matt-setup-pre-commit` · `matt-git-guardrails` · `matt-scaffold-exercises` · `matt-migrate-to-shoehorn`

### Addy Osmani Agent Skills (22)
`spec-driven-development` · `code-simplification` · `debugging-and-error-recovery` · `security-and-hardening` · `ci-cd-and-automation` · `incremental-implementation` · `planning-and-task-breakdown` · `frontend-ui-engineering` · `context-engineering` · `git-workflow-and-versioning` · `source-driven-development` · `shipping-and-launch` · `documentation-and-adrs` · `api-and-interface-design` · `doubt-driven-development` · `deprecation-and-migration` · `browser-testing-with-devtools` · `code-review-and-quality` · `observability-and-instrumentation` · `idea-refine` · `interview-me` · `using-agent-skills`

### Animation Skills (8)
`anim-animation-vocabulary` · `anim-apple-design` · `anim-emil-design-eng` · `anim-find-animation-opportunities` · `anim-improve-animations` · `anim-pick-ui-library` · `anim-prototype` · `anim-review-animations`

### Google Cloud Skills (17)
`gcp-gke-basics` · `gcp-cloud-run-basics` · `gcp-bigquery-basics` · `gcp-bigquery-ai-ml` · `gcp-cloud-storage-basics` · `gcp-cloud-sql-basics` · `gcp-spanner-basics` · `gcp-alloydb-basics` · `gcp-firebase-basics` · `gcp-gemini-api` · `gcp-gemini-agents-api` · `gcp-gcloud` · `gcp-cloud-logging-configuration-basics` · `gcp-workload-manager-basics` · `gcp-datalineage-summary` · `gcp-google-cloud-waf-security` · `gcp-detection-engineering-coverage-evaluation`

### Custom Enhanced Skills (11)
`ai-ml-engineering` · `api-design-best-practices` · `auth-authorization` · `database-optimization` · `message-queues` · `mobile-development` · `observability` · `performance-optimization` · `system-design` · `testing-strategies` · `web-accessibility`

### Curated & Community Skills (55)
`figma` · `figma-*` (6 more) · `playwright` · `playwright-interactive` · `vercel-deploy` · `netlify-deploy` · `cli-creator` · `security-best-practices` · `security-threat-model` · `sentry` · `linear` · `screenshot` · `speech` · `define-goal` · `yeet` · `copilot-cli-mastery` · `copilot-*` (23 more) · `supabase` · `sveltekit` · `typescript-*` · `tailwind-*` · `tanstack-query-expert` · `trpc-fullstack` · `zustand-store-ts` · `vercel-ai-sdk-expert` · `vitest-skill` · `uv-package-manager` · and more

### HuggingFace ML/AI Skills (3)
`trl-training` · `transformers-js` · `train-sentence-transformers`

### Awesome LLM Agent Skills (5)
`commit-archaeologist` · `project-graveyard` · `scope-creep-detector` · `thinking-out-loud` · `advisor-orchestrator-worker`

### Wondelai Book Skills (62)
`37signals-way` · `blue-ocean-strategy` · `clean-architecture` · `clean-code` · `cold-start-problem` · `contagious` · `continuous-discovery` · `create-app` · `create-business` · `create-website` · `cro-methodology` · `crossing-the-chasm` · `ddia-systems` · `design-code-architecture` · `design-everyday-things` · `design-sprint` · `domain-driven-design` · `drive-motivation` · `good-strategy-bad-strategy` · `grow-app` · `grow-business` · `grow-website` · `high-output-management` · `high-perf-browser` · `hooked-ux` · `hundred-million-offers` · `improve-app` · `improve-business` · `improve-code-quality` · `improve-retention` · `improve-website` · `influence-psychology` · `inspired-product` · `ios-hig-design` · `jobs-to-be-done` · `lean-analytics` · `lean-startup` · `lean-ux` · `made-to-stick` · `microinteractions` · `mom-test` · `monetizing-innovation` · `negotiation` · `obviously-awesome` · `one-page-marketing` · `pragmatic-programmer` · `predictable-revenue` · `refactoring-patterns` · `refactoring-ui` · `release-it` · `remove-technical-debt` · `scorecard-marketing` · `software-design-philosophy` · `steve-jobs-design-review` · `storybrand-messaging` · `system-design` · `team-topologies` · `top-design` · `traction-eos` · `ux-heuristics` · `web-typography` · `working-with-legacy-code`

### Project Management Skills (68)
`ab-test-analysis` · `analyze-feature-requests` · `ansoff-matrix` · `beachhead-segment` · `brainstorm-*` (4) · `business-model` · `cohort-analysis` · `competitive-battlecard` · `competitor-analysis` · `create-prd` · `customer-journey-map` · `draft-nda` · `grammar-check` · `growth-loops` · `gtm-motions` · `gtm-strategy` · `ideal-customer-profile` · `identify-assumptions-*` (2) · `interview-script` · `job-stories` · `lean-canvas` · `market-segments` · `market-sizing` · `marketing-ideas` · `metrics-dashboard` · `monetization-strategy` · `north-star-metric` · `opportunity-solution-tree` · `outcome-roadmap` · `pestle-analysis` · `porters-five-forces` · `positioning-ideas` · `pre-mortem` · `pricing-strategy` · `prioritization-frameworks` · `prioritize-assumptions` · `prioritize-features` · `privacy-policy` · `product-name` · `product-strategy` · `product-vision` · `release-notes` · `retro` · `review-resume` · `sentiment-analysis` · `shipping-artifacts` · `sprint-plan` · `sql-queries` · `stakeholder-map` · `startup-canvas` · `strategy-red-team` · `summarize-interview` · `summarize-meeting` · `swot-analysis` · `test-scenarios` · `user-personas` · `user-segmentation` · `user-stories` · `value-prop-statements` · `value-proposition` · `wwas`

### iOS & Swift Skills (16)
`app-store-changelog` · `bug-hunt-swarm` · `github` · `ios-debugger-agent` · `macos-menubar-tuist-app` · `macos-spm-app-packaging` · `orchestrate-batch-refactor` · `project-skill-audit` · `react-component-performance` · `review-and-simplify-changes` · `review-swarm` · `swift-concurrency-expert` · `swiftui-liquid-glass` · `swiftui-performance-audit` · `swiftui-ui-patterns` · `swiftui-view-refactor`

### Obsidian Skills (5)
`defuddle` · `json-canvas` · `obsidian-bases` · `obsidian-cli` · `obsidian-markdown`

### Web & Framework Skills (45)
`supabase-postgres-best-practices` · `supabase` · `sveltekit` · `tailwind-design-system` · `tailwind-patterns` · `tanstack-query-expert` · `threejs-animation` · `threejs-fundamentals` · `threejs-interaction` · `threejs-materials` · `threejs-postprocessing` · `threejs-textures` · `trpc-fullstack` · `turborepo-caching` · `typescript-advanced-types` · `typescript-expert` · `ui-a11y` · `ui-component` · `ui-motion` · `ui-tokens` · `unslop` · `unslop-commit` · `unslop-file` · `unslop-review` · `using-git-worktrees` · `uv-package-manager` · `vector-database-engineer` · `vercel-ai-sdk-expert` · `verification-before-completion` · `vitest-skill` · `weaviate` · `workflow-automation` · `writing-great-skills` · `zod-validation-expert` · `zustand-store-ts`

### Security Testing Skills (42)
`performing-api-security-testing-with-postman` · `performing-cve-prioritization-with-kev-catalog` · `performing-docker-bench-security-assessment` · `performing-ssl-tls-security-assessment` · `performing-web-application-penetration-test` · `remediating-s3-bucket-misconfiguration` · `scanning-container-images-with-grype` · `scanning-docker-images-with-trivy` · `scanning-iac-and-images-with-trivy` · `scanning-kubernetes-manifests-with-kubesec` · `scanning-network-with-nmap-advanced` · `securing-api-gateway-with-aws-waf` · `securing-aws-iam-permissions` · `securing-aws-lambda-execution-roles` · `securing-github-actions-workflows` · `securing-kubernetes-on-cloud` · `securing-serverless-functions` · `sql-injection-testing` · `testing-api-authentication-weaknesses` · `testing-api-for-broken-object-level-authorization` · `testing-api-for-mass-assignment-vulnerability` · `testing-api-security-with-owasp-top-10` · `testing-cors-misconfiguration` · `testing-for-business-logic-vulnerabilities` · `testing-for-email-header-injection` · `testing-for-host-header-injection` · `testing-for-json-web-token-vulnerabilities` · `testing-for-open-redirect-vulnerabilities` · `testing-for-sensitive-data-exposure` · `testing-for-xss-vulnerabilities` · `testing-for-xxe-injection-vulnerabilities` · `testing-jwt-token-security` · `testing-oauth2-implementation-flaws` · `testing-patterns` · `testing-prompt-injection-in-rag-pipelines` · `testing-websocket-api-security` · `threat-modeling-expert` · `verifying-build-provenance-with-slsa-sigstore` · `vulnerability-scanner` · `wcag-audit-patterns` · `web-security-testing` · `systematic-debugging`

### Copilot Community Skills (24)
`copilot-cli-mastery` · `copilot-codeql` · `copilot-conventional-commit` · `copilot-diagnose` · `copilot-draw-io-diagram-generator` · `copilot-git-commit` · `copilot-github-actions-efficiency` · `copilot-mcp-cli` · `copilot-postgresql-optimization` · `copilot-postgresql-code-review` · `copilot-sql-optimization` · `copilot-sql-server-table-reconciliation` · `copilot-security-review` · `copilot-typescript-mcp-server-generator` · `copilot-python-mcp-server-generator` · `copilot-java-springboot` · `copilot-csharp-async` · `copilot-dotnet-best-practices` · `copilot-azure-architecture-autopilot` · `copilot-terraform-azurerm-set-diff-analyzer` · `copilot-react-audit-grep-patterns` · `copilot-playwright-generate-test` · `copilot-architecture-blueprint-generator` · `copilot-create-implementation-plan`

Full details in [docs/SKILLS_REFERENCE.md](docs/SKILLS_REFERENCE.md).

---

## The Agents

| Agent | Mode | Best For |
|-------|------|----------|
| `architect` | System design | Architecture reviews, ADRs, domain modeling |
| `code-reviewer` | Code audit | PR review, quality gates, security checks |
| `tdd-dev` | Test-first dev | Red-green-refactor, test design, mocking |
| `security-auditor` | Security | OWASP, threat modeling (STRIDE), dependency CVEs |
| `designer` | UI/UX | Responsive design, accessibility, design tokens |

Switch mid-session: *"Switch to tdd-dev"* or use CLI: `claude -p "architect: design the auth module"`

Quick reference in [AGENTS_QUICK_REFERENCE.md](AGENTS_QUICK_REFERENCE.md).

---

## Real Workflows

```bash
# One-shot code review
claude -p "code-reviewer: audit the last 3 commits for security issues"

# Full TDD cycle
claude -p "tdd-dev: implement user authentication with tests"

# Architecture with docs
claude -p "architect: design our notification system, output an ADR"

# Security audit
claude -p "security-auditor: scan src/api/ for OWASP vulnerabilities"

# Generate a report
claude -p "generate a PDF report from data/quarterly.json"

# Deploy
claude -p "vercel-deploy: configure production deployment"

# Session context high?
/compact  # Frees up context tokens mid-session
```

---

## Essential Claude Code Commands

| Command | Usage |
|---------|-------|
| `claude` | Start interactive session |
| `claude -p "..."` | One-shot query |
| `claude --resume` | Resume previous session |
| `claude --model claude-sonnet-4-20250514` | Use Sonnet 4 |
| `claude --model claude-3-opus-20240229` | Use Opus for complex tasks |
| `/compact` | Free up context tokens mid-session |
| `/init` | Initialize Claude Code in project |
| `claude --dangerously-skip-permissions` | Bypass permission prompts (use with care) |

---

## Project Structure

```
Claude_Code_Skills/
├── .claude/
│   ├── agents/              # 5 agent .md files
│   └── skills/              # 384 skill folders
├── docs/
│   ├── GETTING_STARTED.md
│   └── SKILLS_REFERENCE.md
├── scripts/
│   ├── setup.sh             # macOS / Linux
│   └── setup.ps1            # Windows
├── CLAUDE_CODE_WORKFLOW.md
├── AGENTS_QUICK_REFERENCE.md
├── README.md
├── LICENSE
├── NOTICE.md
└── .gitignore
```

---

## Attribution

This project is a Claude Code adaptation of [opencode-ultimate-skills](https://github.com/Adhamxon/opencode-ultimate-skills) by **Adkhamkhon**. Originally built for OpenCode, it has been expanded and restructured for Claude Code.

Copyright (c) 2026 Adkhamkhon — MIT License

See [NOTICE.md](NOTICE.md) for attribution requirements if you reuse individual skill files.

---

## License

MIT — free for personal and commercial use. See [LICENSE](LICENSE).

---

## Acknowledgments

- [Anthropic](https://anthropic.com) — Official Claude skills collection and Claude Code
- [Matt Pocock](https://github.com/mattpocock) — Engineering workflow skills
- [Addy Osmani](https://github.com/addyosmani) — Agent development patterns
- [Google Cloud](https://cloud.google.com) — Cloud product skills
- [HuggingFace](https://huggingface.co) — ML/AI training tools
- [Awesome GitHub Copilot](https://github.com/awesome-github-copilot) — Community skills
- [Wondelai](https://github.com/wondelai) — Book-based engineering skills

---

*Built for Claude Code. Powered by the community. Maintained by Adkhamkhon.*
