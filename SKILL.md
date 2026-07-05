---
name: krea-2-turbo-image
description: Generate Krea 2 Turbo text-to-image outputs through EvoLink, with API key setup, non-generating key validation, task polling, and result URL handling.
homepage: https://github.com/Evolink-AI/krea-2-turbo-image-generate-api-skill
metadata: {"openclaw":{"homepage":"https://github.com/Evolink-AI/krea-2-turbo-image-generate-api-skill","requires":{"bins":["jq","curl"],"env":["EVOLINK_API_KEY"]},"primaryEnv":"EVOLINK_API_KEY"}}
---

# Krea 2 Turbo Image Generation

Use this skill when the user wants to generate images with Krea 2 Turbo through EvoLink.

## When To Use

Activate this skill when the user asks to:

- generate an image with Krea 2 Turbo
- use `krea-2-turbo`
- run EvoLink image generation
- create cinematic, product, poster, social, or concept images through the Krea 2 Turbo API
- install or test the Krea 2 Turbo agent skill

Do not use this skill for image editing, reference-image generation, video, audio, text chat, pricing-only questions, or unrelated model comparisons.

## Setup

All paths are relative to the directory containing this `SKILL.md`.

```text
SKILL_DIR = directory containing this SKILL.md
SCRIPT = {SKILL_DIR}/scripts/krea-2-turbo-image.sh
```

Before creating a generation task:

1. Check whether `EVOLINK_API_KEY` is set.
2. If missing, send the user to https://evolink.ai/dashboard/keys?utm_source=skill&utm_medium=install&utm_campaign=krea-2-turbo-image.
3. Ask the user to paste the key back.
4. Save it as `EVOLINK_API_KEY` for the current session.
5. Validate it with `GET https://api.evolink.ai/v1/credits`. This is a non-generating endpoint and does not spend generation credits.
6. After validation succeeds, tell the user: `The skill is ready.`

## User Input

Required:

- `prompt`: English works best; maximum length is 640 tokens.

Optional:

- `size`: default `1:1`; supported values are `1:1`, `4:3`, `3:4`, `5:4`, `4:5`, `2:3`, `3:2`, `9:16`, `16:9`, `1:2`, `2:1`.
- `quality`: default `1K`; supported values are `1K` and `2K`.
- `seed`: integer from `0` to `1048576`; `0` or empty uses a random seed.
- `nsfw_check`: default `false`.
- `callback_url`: HTTPS callback URL. Do not use private or localhost addresses.

Ask for all missing required information in one message. Do not ask for optional parameters unless the user needs control; use defaults when they say "default is fine" or provide only a prompt.

## Execution

Run exactly one task per user request. Once the script prints `TASK_SUBMITTED`, do not retry unless the user explicitly asks; retrying can spend additional credits.

Dry run:

```bash
{SKILL_DIR}/scripts/krea-2-turbo-image.sh "A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting" --size 16:9 --quality 1K --dry-run
```

Real run:

```bash
EVOLINK_API_KEY=$EVOLINK_API_KEY {SKILL_DIR}/scripts/krea-2-turbo-image.sh "A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting" --size 16:9 --quality 1K
```

With options:

```bash
{SKILL_DIR}/scripts/krea-2-turbo-image.sh "Minimalist architectural render at sunset" --size 3:2 --quality 2K --seed 12345 --nsfw-check false
```

## Output Protocol

Parse these stdout/stderr lines:

| Line | Meaning | Action |
|---|---|---|
| `DRY_RUN:` | No API call was made | Show the payload and say no credits were spent. |
| `TASK_SUBMITTED: task_id=<id> estimated=<time>` | Create request succeeded | Tell the user the task started and keep polling. |
| `STATUS_UPDATE: status=<status> progress=<n>` | Task is pending or processing | Briefly relay progress if useful. |
| `RESULT_URL=<url>` | Task completed | Give the URL and remind the user to save the image because links expire. |
| `ERROR:` | Request or task failed | Show the message and suggest the specific fix. |
| `POLL_TIMEOUT:` | Local polling expired | Tell the user the task may still finish and preserve the task ID. |

## API Facts

- Create endpoint: `POST https://api.evolink.ai/v1/images/generations`
- Task endpoint: `GET https://api.evolink.ai/v1/tasks/{task_id}`
- Model: `krea-2-turbo`
- Lifecycle: async
- Output: image URLs in `results`
- Result URL lifetime: 24 hours
- Reference images: not supported

## Safety And Boundaries

- Do not promise exact reproduction from a seed; same seed with same prompt may reproduce similar composition.
- Do not create prompts involving illegal sexual content, minors in sexual contexts, extremist content, or graphic violence.
- Avoid copyrighted characters, trademarks, logos, and celebrity likeness for commercial outputs unless the user confirms rights and the request is allowed.
- If content is blocked, help the user rewrite the prompt safely.
- Do not fabricate completed URLs. Only report `RESULT_URL` values returned by the API.

## References

- `scripts/krea-2-turbo-image.sh`: create and poll a Krea 2 Turbo image task.
- `references/api-params.md`: parameter reference.
- `docs/api-reference.md`: endpoint and response details.
- `docs/errors.md`: error codes and troubleshooting.
