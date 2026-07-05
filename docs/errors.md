# Error Handling

## HTTP Errors

| Error | Likely cause | Fix |
|---|---|---|
| `400` | Invalid JSON body, model, prompt, size, quality, seed, or callback URL | Validate request parameters against the docs. |
| `401` | Missing or invalid `EVOLINK_API_KEY` | Create a new key at https://evolink.ai/dashboard/keys?utm_source=github&utm_medium=readme&utm_campaign=krea-2-turbo-image and validate it with `GET /v1/credits`. |
| `402` | Insufficient account balance or credits | Add credits, lower test volume, and retry intentionally. |
| `403` | Account or model access blocked | Check account permissions and model access. |
| `404` | Unknown or expired task ID | Store the task ID returned by create response and query promptly. |
| `429` | Rate limit or concurrency limit | Reduce concurrency and retry with backoff. |
| `500` | Server error | Retry later and preserve request/task context. |

## Task Error Codes

| Code | Meaning | Retry guidance |
|---|---|---|
| `content_policy_violation` | Prompt violates safety policy | Rewrite the prompt safely before retrying. |
| `invalid_parameters` | Request parameters are invalid | Fix parameters before retrying. |
| `generation_failed_no_content` | Model failed to produce output | Try a clearer prompt. |
| `generation_timeout` | Processing timed out | Retry later or simplify the prompt. |
| `quota_exceeded` | Rate limit or quota exceeded | Reduce frequency or add credits. |
| `resource_exhausted` | Temporary upstream capacity issue | Wait and retry later. |
| `resource_not_found` | Task ID invalid or expired | Verify the task ID. |
| `service_unavailable` | Temporary service issue | Retry later. |
| `unknown_error` | Unclassified failure | Contact support with task ID and response. |

Stop polling when status is `completed` or `failed`.
