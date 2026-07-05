# Task Lifecycle

Krea 2 Turbo runs asynchronously through EvoLink.

1. Send `POST /v1/images/generations`.
2. Read the returned `id`.
3. Poll `GET /v1/tasks/{task_id}`.
4. Stop when status is `completed` or `failed`.
5. On `completed`, read the generated image URL from `results`.

Statuses:

| Status | Meaning |
|---|---|
| `pending` | Task has been accepted. |
| `processing` | Generation is in progress. |
| `completed` | Result URLs are available. |
| `failed` | Inspect `error.code` and `error.message`. |

Use a max polling limit and preserve the task ID on timeout; the server-side task may still complete.
