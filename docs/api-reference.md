# API Reference

## Create Image Task

- Method: `POST`
- URL: `https://api.evolink.ai/v1/images/generations`
- Model: `krea-2-turbo`
- Authentication: `Authorization: Bearer ${EVOLINK_API_KEY}`
- Content type: `application/json`

Request body:

| Field | Type | Required | Default | Notes |
|---|---:|---:|---|---|
| `model` | string | yes | `krea-2-turbo` | Only `krea-2-turbo` is valid for this skill. |
| `prompt` | string | yes | none | English works best; maximum 640 tokens. |
| `size` | enum | no | `1:1` | Aspect ratio. |
| `quality` | enum | no | `1K` | Resolution tier: `1K` or `2K`. |
| `seed` | integer | no | random | Range `0` to `1048576`; `0` or empty is random. |
| `nsfw_check` | boolean | no | `false` | Enables stricter moderation; basic moderation is always active. |
| `callback_url` | HTTPS URL | no | none | Receives task status payload when the task completes, fails, or is cancelled. |

## Query Task

- Method: `GET`
- URL: `https://api.evolink.ai/v1/tasks/{task_id}`
- Authentication: `Authorization: Bearer ${EVOLINK_API_KEY}`

`task_id` is the `id` returned by the create response.

## Key Validation

Use `GET https://api.evolink.ai/v1/credits` to validate an API key before creating a generation task. This endpoint is non-generating and does not spend generation credits.
