# Krea 2 Turbo Image Generation API Skill

Install an agent skill and run Krea 2 Turbo text-to-image generation through EvoLink.

## Install

```bash
npx evolink-krea-2-turbo@latest -y --path ~/.codex/skills
```

Then get an EvoLink API key:

[Get an EvoLink API key](https://evolink.ai/dashboard/keys?utm_source=npm&utm_medium=package&utm_campaign=krea-2-turbo-image)

Set the key:

```bash
export EVOLINK_API_KEY="your_key_here"
```

Run directly:

```bash
EVOLINK_API_KEY=your_key npx evolink-krea-2-turbo@latest "A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting"
```

## API Flow

Create a task:

```bash
curl --request POST \
  --url https://api.evolink.ai/v1/images/generations \
  --header "Authorization: Bearer ${EVOLINK_API_KEY}" \
  --header "Content-Type: application/json" \
  --data '{
    "model": "krea-2-turbo",
    "prompt": "A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting",
    "size": "16:9",
    "quality": "1K"
  }'
```

Poll:

```bash
curl --request GET \
  --url https://api.evolink.ai/v1/tasks/{task_id} \
  --header "Authorization: Bearer ${EVOLINK_API_KEY}"
```

## Model Facts

| Field | Value |
|---|---|
| Model ID | `krea-2-turbo` |
| Create endpoint | `POST /v1/images/generations` |
| Task endpoint | `GET /v1/tasks/{task_id}` |
| Lifecycle | Asynchronous |
| Input | Text-to-image only |
| Reference images | Not supported |
| Result retention | Generated image links are valid for 24 hours |

## Parameters

`prompt` is required. Optional parameters include `size`, `quality`, `seed`, `nsfw_check`, and `callback_url`.

Supported `size` values: `1:1`, `4:3`, `3:4`, `5:4`, `4:5`, `2:3`, `3:2`, `9:16`, `16:9`, `1:2`, `2:1`.

Supported `quality` values: `1K`, `2K`.

## Links

- Official docs: https://docs.evolink.ai/en/api-manual/image-series/krea/krea-2-turbo-image-generate
- GitHub: https://github.com/Evolink-AI/krea-2-turbo-image-generate-api-skill

## License

MIT
