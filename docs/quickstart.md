# Quickstart

1. Set `EVOLINK_API_KEY`.
2. Create a Krea 2 Turbo task with `POST /v1/images/generations`.
3. Store the returned `id`.
4. Poll `GET /v1/tasks/{task_id}` until `status` is `completed` or `failed`.
5. Save the first URL in `results` promptly; generated image links are valid for 24 hours.

Dry run without API spend:

```bash
./scripts/krea-2-turbo-image.sh "A clean studio product render of a compact camera" --size 1:1 --quality 1K --dry-run
```

Real run:

```bash
export EVOLINK_API_KEY="your_key_here"
./scripts/krea-2-turbo-image.sh "A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting" --size 16:9 --quality 1K
```
