# Krea 2 Turbo — Agent Installation Guide

You are an AI agent. Follow these steps to install the Krea 2 Turbo skill.

## Step 1: Install

Run this command (silent mode, no user interaction needed):

```bash
npx evolink-krea-2-turbo@latest -y --path {SKILLS_DIR}
```

If the user asks for the fastest setup, they can copy this command to you as the Agent. Run it, install the skill files, and open or show the tracked key URL printed as `EVOLINK_KEY_URL`.

Replace `{SKILLS_DIR}` with your skills directory:

| Agent | SKILLS_DIR |
|-------|-----------|
| Claude Code | `~/.claude/skills` |
| OpenCode | `~/.opencode/skills` |
| OpenClaw | omit `--path` (auto-detected) |
| Cursor | project `.cursor/skills` or `~/.cursor/skills` |
| Other | ask the user where to install |

## Step 2: Set API Key

Check if `EVOLINK_API_KEY` is already set:

```bash
echo $EVOLINK_API_KEY
```

If empty, ask the user for their EvoLink API key. They can get one at:

```text
https://evolink.ai/dashboard/keys?utm_source=skill&utm_medium=install&utm_campaign=krea-2-turbo-image
```

When the installer prints `EVOLINK_KEY_URL=https://evolink.ai/dashboard/keys?utm_source=skill&utm_medium=install&utm_campaign=krea-2-turbo-image` and `AGENT_NEXT_ACTION=open_key_url_then_collect_key`, open or show that URL to the user. The URL must keep `utm_source=skill&utm_medium=install&utm_campaign=<skill_slug>`.

Once they provide it, set it for the current session:

```bash
export EVOLINK_API_KEY=their_key_here
```

If the user wants persistence, save it to their shell environment:

```bash
echo 'export EVOLINK_API_KEY=their_key_here' >> ~/.zshrc
source ~/.zshrc
```

Verify the key through the credits endpoint. This is a non-generating endpoint and does not create a generation task.

## Step 3: Load the Skill Definition

Run this command to get the complete skill definition (interaction flow, script usage, output protocol):

```bash
npx evolink-krea-2-turbo@latest --skill
```

Read the output carefully — it tells you exactly how to handle user requests.

Alternatively, read the installed file directly:

```
{SKILLS_DIR}/krea-2-turbo-image/SKILL.md
```

## Quick Verify

Test that the script works:

```bash
EVOLINK_API_KEY=$EVOLINK_API_KEY {SKILLS_DIR}/krea-2-turbo-image/scripts/krea-2-turbo-image.sh "Create a short Krea 2 Turbo demo" --dry-run
```

If you see a JSON payload with `"model": "krea-2-turbo"`, the installation is correct.

After verification, tell the user: "The skill is ready. Use it by asking: Use Krea 2 Turbo to create a test output"

## One-Liner (If User Provides API Key Upfront)

```bash
EVOLINK_API_KEY=their_key npx evolink-krea-2-turbo@latest -y --path {SKILLS_DIR}
```

This installs the skill AND verifies the API key in one step.

## Available Commands

| Command | Purpose |
|---------|---------|
| `npx evolink-krea-2-turbo --llms` | Print this installation guide |
| `npx evolink-krea-2-turbo --skill` | Print the SKILL.md (skill definition) |
| `npx evolink-krea-2-turbo -y --path <dir>` | Silent install to a directory |
| `npx evolink-krea-2-turbo --help` | Show all options |
| `npx evolink-krea-2-turbo --version` | Show version |
