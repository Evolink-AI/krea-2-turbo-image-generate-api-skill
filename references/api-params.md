# Krea 2 Turbo API Parameters

| Parameter | Required | Accepted values | Notes |
|---|---:|---|---|
| `model` | yes | `krea-2-turbo` | Model ID. |
| `prompt` | yes | string | English works best; maximum 640 tokens. |
| `size` | no | `1:1`, `4:3`, `3:4`, `5:4`, `4:5`, `2:3`, `3:2`, `9:16`, `16:9`, `1:2`, `2:1` | Aspect ratio. |
| `quality` | no | `1K`, `2K` | Resolution tier. |
| `seed` | no | integer `0` to `1048576` | `0` or empty uses random seed. |
| `nsfw_check` | no | `true`, `false` | Basic moderation is always active. |
| `callback_url` | no | HTTPS URL | Called after task completion, failure, or cancellation. |
