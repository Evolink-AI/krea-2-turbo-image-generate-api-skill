# Response Schema

## Create Task Response

```json
{
  "created": 1751280000,
  "id": "task-unified-1751280000-k2t9x8a3",
  "model": "krea-2-turbo",
  "object": "image.generation.task",
  "progress": 0,
  "status": "pending",
  "task_info": {
    "can_cancel": false,
    "estimated_time": 45
  },
  "type": "image",
  "usage": {
    "billing_rule": "per_call",
    "credits_reserved": 0.05,
    "user_group": "default"
  }
}
```

## Completed Task Response

```json
{
  "created": 1756817821,
  "id": "task-unified-1756817821-4x3rx6ny",
  "model": "krea-2-turbo",
  "object": "image.generation.task",
  "progress": 100,
  "results": [
    "https://example.com/image.jpg"
  ],
  "status": "completed",
  "task_info": {
    "can_cancel": false
  },
  "type": "image"
}
```

## Failed Task Response

```json
{
  "id": "task-unified-1772618027-cmeisy8h",
  "object": "image.generation.task",
  "status": "failed",
  "model": "krea-2-turbo",
  "progress": 0,
  "error": {
    "code": "content_policy_violation",
    "message": "Content policy violation. Your request was blocked by safety filters."
  }
}
```

Generated image links are valid for 24 hours. Download or copy final assets into your own storage promptly.
