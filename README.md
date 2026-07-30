# Claude Code Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Ready-6C47FF)](https://docs.anthropic.com/en/docs/claude-code/overview)

**258 skills + 5 agents for Claude Code.** Drop the `.claude/` folder into any project and your terminal AI instantly gains expert capabilities — code review, TDD, architecture design, security auditing, document generation, deployment, and more.

Built from the best of Anthropic's official skills, Matt Pocock's engineering workflows, Addy Osmani's agent skills, HuggingFace ML/AI, and curated tools. No config. No setup. Just `claude` and go.

---

## Why This Exists

Claude Code is already powerful out of the box. But skills and agents turn it into a **specialized toolchain**. Want a security audit? The `security-auditor` agent loads with OWASP expertise. Building a feature? `matt-tdd` runs the red-green-refactor cycle. Deploying to Vercel? The `vercel-deploy` skill handles configuration.

This collection packages 258 ready-to-use skills and 5 agent personas so you don't have to write them yourself.

---

## How It Works

Claude Code auto-discovers `.claude/` in your project root. Every session, it scans:

```
.claude/
├── agents/              # 5 agent personas (.md files)
└── skills/              # 258 skill definitions (SKILL.md files)
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

# Go!
cd /path/to/your/project
claude
```

That's it. Claude Code loads everything automatically. Start asking questions.

---

## The Skills

### Anthropic Official (10)
`claude-api` · `mcp-builder` · `skill-creator` · `webapp-testing` · `frontend-design` · `xlsx` · `pptx` · `docx` · `pdf-anthropic` · `pdf`

### Matt Pocock Engineering (10)
`matt-code-review` · `matt-tdd` · `matt-diagnosing-bugs` · `matt-domain-modeling` · `matt-implement` · `matt-research` · `matt-prototype` · `matt-codebase-design` · `matt-writing-great-skills` · `matt-teach`

### Addy Osmani Agent Skills (22) ⭐ NEW
`spec-driven-development` · `code-simplification` · `debugging-and-error-recovery` · `security-and-hardening` · `ci-cd-and-automation` · `incremental-implementation` · `planning-and-task-breakdown` · `frontend-ui-engineering` · `context-engineering` · `git-workflow-and-versioning` · `source-driven-development` · `shipping-and-launch` · `documentation-and-adrs` · `api-and-interface-design` · `doubt-driven-development` · `deprecation-and-migration` · `browser-testing-with-devtools` · `code-review-and-quality` · `observability-and-instrumentation` · `idea-refine` · `interview-me` · `using-agent-skills`

### Productivity & Handoff (1)
`matt-handoff`

### Design & Creative (4)
`theme-factory` · `brand-guidelines` · `canvas-design` · `algorithmic-art`

### Curated Tools (5)
`cli-creator` · `playwright` · `vercel-deploy` · `netlify-deploy` · `security-best-practices`

### Custom Enhanced Skills (11) ⭐ NEW
`ai-ml-engineering` · `api-design-best-practices` · `auth-authorization` · `database-optimization` · `message-queues` · `mobile-development` · `observability` · `performance-optimization` · `system-design` · `testing-strategies` · `web-accessibility`

### HuggingFace ML/AI Skills (3) ⭐ NEW
`trl-training` · `transformers-js` · `train-sentence-transformers`

### Karpathy Guidelines (1) ⭐ NEW
`karpathy-guidelines`

### Awesome LLM Agent Skills (5) ⭐ NEW
`commit-archaeologist` · `project-graveyard` · `scope-creep-detector` · `thinking-out-loud` · `advisor-orchestrator-worker`

### Wondelai Engineering Skills (20) ⭐⭐ NEW
`clean-architecture` · `clean-code` · `domain-driven-design` · `pragmatic-programmer` · `software-design-philosophy` · `refactoring-patterns` · `refactoring-ui` · `working-with-legacy-code` · `ddia-systems` · `high-perf-browser` · `system-design` · `team-topologies` · `release-it` · `design-code-architecture` · `remove-technical-debt` · `improve-code-quality` · `microinteractions` · `ios-hig-design` · `web-typography` · `ux-heuristics`

### Project Management Skills (30) ⭐⭐ NEW
`brainstorm-okrs` · `create-prd` · `sprint-plan` · `retro` · `user-stories` · `test-scenarios` · `pre-mortem` · `prioritization-frameworks` · `outcome-roadmap` · `stakeholder-map` · `strategy-red-team` · `release-notes` · `business-model` · `lean-canvas` · `product-strategy` · `product-vision` · `value-proposition` · `swot-analysis` · `porters-five-forces` · `pricing-strategy` · `competitor-analysis` · `customer-journey-map` · `market-sizing` · `user-personas` · `interview-script` · `metrics-dashboard` · `gtm-strategy` · `competitive-battlecard` · `sql-queries` · `cohort-analysis`

### Web & Framework Skills (30) ⭐⭐ NEW
`tanstack-query-expert` · `trpc-fullstack` · `zod-validation-expert` · `vitest-skill` · `sveltekit` · `typescript-advanced-types` · `supabase-postgres-best-practices` · `tailwind-patterns` · `turborepo-caching` · `uv-package-manager` · `threejs-fundamentals` · `zustand-store-ts` · `ui-component` · `ui-a11y` · `vercel-ai-sdk-expert` · `using-git-worktrees` · `workflow-automation` · `systematic-debugging` · `verification-before-completion` · `writing-great-skills`

### Security Skills (25) ⭐⭐ NEW
`testing-api-security-with-owasp-top-10` · `testing-cors-misconfiguration` · `testing-for-xss-vulnerabilities` · `testing-for-json-web-token-vulnerabilities` · `testing-for-sql-injection` · `testing-api-authentication-weaknesses` · `testing-for-broken-access-control` · `testing-oauth2-implementation-flaws` · `testing-prompt-injection-in-rag-pipelines` · `testing-websocket-api-security` · `testing-for-xxe-injection-vulnerabilities` · `securing-aws-iam-permissions` · `securing-github-actions-workflows` · `securing-serverless-functions` · `securing-api-gateway-with-aws-waf` · `remediating-s3-bucket-misconfiguration` · `scanning-docker-images-with-trivy` · `scanning-kubernetes-manifests-with-kubesec` · `performing-ssl-tls-security-assessment` · `performing-docker-bench-security-assessment`

### iOS & Swift Skills (8) ⭐⭐ NEW
`swift-concurrency-expert` · `swiftui-liquid-glass` · `swiftui-performance-audit` · `swiftui-ui-patterns` · `swiftui-view-refactor` · `ios-debugger-agent` · `app-store-changelog` · `bug-hunt-swarm`

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

See [CLAUDE_CODE_WORKFLOW.md](CLAUDE_CODE_WORKFLOW.md) for complete walkthroughs, but here's a taste:

```bash
# One-shot code review
claude -p "code-reviewer: audit the last 3 commits for security issues"

# Full TDD cycle
claude -p "tdd-dev: implement user authentication with tests"

# Architecture with docs
claude -p "architect: design our notification system, output an ADR"

# Generate a report
claude -p "generate a PDF report from data/quarterly.json"

# Deploy
claude -p "vercel-deploy: configure production deployment"

# Session context high? /compact clears it
# Inside claude: /compact
```

---

## Essential Claude Code Commands

| Command | Usage |
|---------|-------|
| `claude` | Start interactive session |
| `claude -p "..."` | One-shot query |
| `claude --resume` | Resume previous session |
| `claude --model claude-sonnet-4-20250514` | Use Sonnet 4 |
| `/compact` | Free up context tokens mid-session |
| `/init` | Initialize Claude Code in project |

---

## Project Structure

```
Claude_Code_Skills/
├── .claude/
│   ├── agents/              # 5 agent .md files
│   └── skills/              # 258 skill folders
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

This project is a Claude Code adaptation of [opencode-ultimate-skills](https://github.com/Adhamxon/opencode-ultimate-skills) by **Adkhamkhon**. Originally built for OpenCode, it has been rewritten, restructured, and expanded for Claude Code.

Copyright (c) 2026 Adkhamkhon — MIT License

See [NOTICE.md](NOTICE.md) for attribution requirements if you reuse individual skill files.

---

## License

MIT — free for personal and commercial use. See [LICENSE](LICENSE).

---

*Built for Claude Code. Powered by the community. Maintained by Adkhamkhon.*
