# Callback / Webhook

Set `callback_url` when you want EvoLink to notify your server after the task is completed, failed, or cancelled.

Requirements:

- HTTPS only.
- URL length must not exceed 2048 characters.
- Localhost and private IP address callbacks are prohibited.
- Callback timeout is 10 seconds.
- EvoLink retries failed callback delivery up to 3 times after 1, 2, and 4 seconds.
- A 2xx response from your callback endpoint is treated as successful.

Example request field:

```json
{
  "callback_url": "https://your-domain.com/webhooks/image-task-completed"
}
```

The callback response body format is consistent with `GET /v1/tasks/{task_id}`. Store the task ID and keep polling available as a fallback.
