# Claude Code Workflow Guide

Real-world workflows combining Claude Code CLI, skills, and agents.

---

## Daily Development with Claude Code

### 1. Start a Session

```bash
claude
```

Claude Code launches in your project root. It auto-discovers `.claude/skills/` and `.claude/agents/`. All 30 skills and 5 agents are ready.

### 2. Review Recent Work

```bash
# One-shot review
claude -p "review the last commit for bugs, security issues, and style problems"

# Or inside a session: "Review the last 3 commits"
```

This triggers the `matt-code-review` skill and optionally the `code-reviewer` agent.

### 3. TDD Cycle

```bash
claude -p "start tdd on the auth module — I need login, logout, and password reset"
```

The `matt-tdd` skill activates and the `tdd-dev` agent takes over. You get:
- Red: failing tests written first
- Green: minimal implementation
- Refactor: clean up with tests still passing

### 4. Debugging a Bug

```
Inside a Claude Code session:
"I found a bug — users can't reset their passwords. Diagnose this."
```

The `matt-diagnosing-bugs` skill loads. You get systematic root cause analysis: reproduction steps, hypotheses, and a fix.

### 5. Architecture Design

```bash
claude -p "architect: design the payment processing system. We use Stripe, need to handle subscriptions, invoices, and webhooks."
```

The `architect` agent activates with `matt-domain-modeling` and `matt-codebase-design` skills. Expect ADRs, C4 diagrams, and trade-off analysis.

---

## Feature Development Workflow

A complete feature from idea to shipping:

```bash
# 1. Research
claude -p "research: what's the best approach for real-time notifications in our React app?"

# 2. Design
claude -p "architect: design the notification system based on the research findings"

# 3. Prototype
claude -p "prototype: build a proof of concept for WebSocket notifications"

# 4. Implement
claude -p "implement the notification system — follow the architecture doc"

# 5. Review
claude -p "review the notification system code for issues"
```

---

## PR Review Workflow

```bash
# Review a specific PR branch
claude -p "review the current PR — check for security, performance, and correctness"

# Or with the code-reviewer agent
claude -p "code-reviewer: do a full audit of the changes in this branch"
```

The `code-reviewer` agent inspects correctness, security (OWASP), performance (N+1, complexity), and maintainability.

---

## Security Audit

```bash
claude -p "security-auditor: audit this codebase for OWASP Top 10 vulnerabilities and hardcoded secrets"
```

The `security-auditor` agent scans: attack surface mapping, threat modeling (STRIDE), static analysis, dependency CVEs. Each finding includes severity (CVSS 3.1), location, impact, and remediation.

---

## UI/UX Design Session

```bash
claude -p "designer: design a responsive dashboard layout for our analytics page"

# Follow up
"Now create the React components with Tailwind CSS"
```

The `designer` agent produces accessible (WCAG AA), responsive (mobile-first) UI code with design tokens.

---

## Document Generation

```bash
# Generate a report
claude -p "generate a PDF report from the data in results.json"

# Create a presentation
claude -p "create a PowerPoint deck summarizing this quarter's metrics"

# Build a spreadsheet
claude -p "create an Excel file with monthly revenue data from our API"
```

Skills activated: `pdf`, `pptx`, `xlsx`, `docx`

---

## Deployment

```bash
claude -p "vercel-deploy: set up deployment for our Next.js app with environment variables"

# Or for Netlify
claude -p "netlify-deploy: configure this static site with redirects and serverless functions"
```

---

## Session Management Tips

| Action | Command |
|--------|---------|
| Clear context | `/compact` |
| Resume session | `claude --resume` |
| Use specific model | `claude --model claude-sonnet-4-20250514` |
| One-shot query | `claude -p "question"` |
| Init new project | `/init` within Claude Code |

---

## Skill + Agent Combinations

| Goal | Agent | Primary Skill |
|------|-------|--------------|
| Code review | `code-reviewer` | `matt-code-review` |
| TDD | `tdd-dev` | `matt-tdd` |
| Architecture | `architect` | `matt-domain-modeling` + `matt-codebase-design` |
| Security | `security-auditor` | `security-best-practices` |
| UI Design | `designer` | `frontend-design` |
| Bug fix | — | `matt-diagnosing-bugs` |
| Research | — | `matt-research` |
| Prototype | — | `matt-prototype` |
| Implementation | — | `matt-implement` |
| Deployment | — | `vercel-deploy` / `netlify-deploy` |
| Document gen | — | `pdf` / `docx` / `xlsx` / `pptx` |
