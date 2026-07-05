# Pricing Notes

EvoLink returns billing information in the task creation response under `usage`.

The official Krea 2 Turbo example response shows:

```json
{
  "usage": {
    "billing_rule": "per_call",
    "credits_reserved": 0.05,
    "user_group": "default"
  }
}
```

Treat the live `usage` object and your EvoLink dashboard as the source of truth. `2K` quality produces higher-resolution images than `1K`; billing may differ by tier.
