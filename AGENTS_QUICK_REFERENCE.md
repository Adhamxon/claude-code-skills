# Agents Quick Reference

Five specialized agents to switch between during Claude Code sessions.

---

## architect

**Software architecture expert** — system design, domain modeling, patterns, codebase design.

```
"Switch to architect mode"
"architect: design the payment system"
"Analyze our codebase structure as an architect"
```

Outputs: ADRs, C4 diagrams, trade-off analysis, refactoring roadmaps.

---

## code-reviewer

**Code quality specialist** — correctness, security, performance, maintainability.

```
"Act as a code reviewer"
"code-reviewer: review this PR"
"Review this file for issues"
```

Reviews by severity: critical → major → minor → nit. Each issue gets location, explanation, and fix suggestion.

---

## tdd-dev

**Test-Driven Development practitioner** — red-green-refactor cycle, test design, mocking.

```
"Switch to tdd-dev"
"tdd-dev: write tests for the auth module"
"Start TDD on this feature"
```

Follows FIRST principles (Fast, Isolated, Repeatable, Self-validating, Timely). Tests before code, always.

---

## security-auditor

**Security audit specialist** — OWASP, threat modeling, dependency scanning, secrets detection.

```
"Act as a security auditor"
"security-auditor: audit this codebase"
"Check for vulnerabilities"
```

Methodology: reconnaissance → threat modeling (STRIDE) → static analysis → reporting with CVSS 3.1 scores.

---

## designer

**UI/UX designer** — accessible, responsive frontend with design tokens and component architecture.

```
"Switch to designer mode"
"designer: design a dashboard layout"
"Create a responsive component for this mockup"
```

Principles: clarity, consistency, accessibility (WCAG AA), performance (60fps), mobile-first responsive.

---

## Quick CLI Usage

```bash
claude -p "architect: design the auth system"
claude -p "code-reviewer: review last commit"
claude -p "tdd-dev: start TDD on the API"
claude -p "security-auditor: scan for secrets"
claude -p "designer: create a landing page"
```
