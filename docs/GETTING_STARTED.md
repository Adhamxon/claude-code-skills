# Getting Started with Claude Code & This Skill Collection

So you've got Claude Code installed and you want to supercharge it with 30 purpose-built skills and 5 specialized agents. You're in the right place.

## What is Claude Code?

Claude Code is Anthropic's agentic coding tool — an AI assistant that lives in your terminal. Run `claude` in any project directory and you get an intelligent coding partner that can read, write, and reason about your codebase.

## How Auto-Discovery Works

Claude Code automatically looks for a `.claude/` directory in your project root. Everything inside it is loaded at session start:

- `.claude/skills/*/SKILL.md` — Injected as system context when triggered
- `.claude/agents/*.md` — Available as agent personas you can switch to

No config files. No registrations. Just drop the folder in and it works.

## Prerequisites

- **Node.js 18+** — Required to run Claude Code
- **Claude Code CLI** — Install globally:

```bash
npm install -g @anthropic-ai/claude-code
```

- **Anthropic API key** — Set it in your environment:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

Or let Claude Code authenticate via the browser flow on first run.

## Installation

### Quick install (clone directly as .claude/)

```bash
cd /path/to/your/project
git clone https://github.com/your-username/claude-code-skills.git .claude
```

### Copy manually

```bash
cp -r /path/to/claude-code-skills/.claude /path/to/your/project/.claude
```

### Using setup scripts

```bash
# macOS / Linux
bash scripts/setup.sh

# Windows
powershell -File scripts/setup.ps1
```

## Verifying It Works

```bash
claude
```

Claude Code starts up and silently loads all skills and agents from `.claude/`. You'll see the skills activate as you work — ask about Claude API features and the `claude-api` skill triggers; request a code review and `matt-code-review` kicks in.

## Essential Claude Code Commands

| Command | What It Does |
|---------|-------------|
| `claude` | Start an interactive session |
| `claude -p "prompt"` | Run a one-shot prompt (non-interactive) |
| `claude -p "review the last commit"` | Quick code review |
| `/compact` | Within a session, summarize context to save tokens |
| `/init` | Initialize Claude Code in a new project |
| `claude --model claude-sonnet-4-20250514` | Use a specific model |
| `claude --resume` | Resume a previous session |

## Using Agents

Switch agents during a Claude Code session by referencing them:

```
# Start claude, then say:
"Switch to architect mode"
"Act as a code reviewer for this PR"
"Switch to tdd-dev, I want to write tests"
"Act as a security auditor"
"Switch to designer mode"
```

Or use them directly from the CLI:

```bash
claude -p "architect: design the auth module for this app"
```

Available agents: `architect`, `code-reviewer`, `tdd-dev`, `security-auditor`, `designer`

## How Skills Activate

Skills are context-aware. Claude Code reads the `SKILL.md` frontmatter triggers and injects the skill when your task matches. No manual loading needed.

```
You: "Generate a PDF report from this data"
Claude: *activates `pdf` skill, loads PDF generation instructions*

You: "Deploy this to Vercel"
Claude: *activates `vercel-deploy` skill*
```

## Troubleshooting

**Skills not loading?**
- Confirm `.claude/skills/` exists with skill folders
- Restart Claude Code with `claude --resume` or start fresh
- Check you're in the project root (where `.claude/` lives)

**Agent not responding as expected?**
- Verify the `.md` file is in `.claude/agents/`
- Check frontmatter has correct `name` and `description` fields
- Try being explicit: "Use the architect agent to analyze this"

**Tokens running high?**
- Use `/compact` within a session to summarize and reset context
- Start Claude Code with a specific focus: `claude -p "help me with X"`
