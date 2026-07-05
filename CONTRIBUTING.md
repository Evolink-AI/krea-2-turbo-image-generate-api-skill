# Contributing

This repository is a focused EvoLink Krea 2 Turbo API and agent skill repository.

## Scope

Accepted contributions:

- Fix API examples, response parsing, or task polling behavior.
- Improve documentation for Krea 2 Turbo image generation.
- Improve agent installation compatibility for Claude Code, Codex, OpenClaw, and Hermes.
- Fix security, error handling, or packaging issues.

Out of scope:

- Adding unrelated model APIs.
- Replacing the EvoLink endpoint with another provider.
- Committing API keys, generated private files, or local agent settings.

## Local Checks

Before opening a pull request:

```bash
npm run check:surfaces
bash scripts/publish-npm.sh --dry-run
npx -y . --version
```

For API behavior changes, run one real smoke test with `EVOLINK_API_KEY` and include the task ID plus final result URL in the pull request.
