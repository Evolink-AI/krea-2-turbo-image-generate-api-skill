#!/usr/bin/env bash
set -euo pipefail

PROMPT="A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting"
SIZE="16:9"
QUALITY="1K"
SEED=""
NSFW_CHECK="false"
CALLBACK_URL=""
DRY_RUN=0
POLL_INTERVAL=3
MAX_ATTEMPTS=120

while [ "$#" -gt 0 ]; do
  case "$1" in
    --size)
      SIZE="${2:?--size requires a value}"
      shift 2
      ;;
    --quality)
      QUALITY="${2:?--quality requires a value}"
      shift 2
      ;;
    --seed)
      SEED="${2:?--seed requires a value}"
      shift 2
      ;;
    --nsfw-check)
      NSFW_CHECK="${2:?--nsfw-check requires true or false}"
      shift 2
      ;;
    --callback-url)
      CALLBACK_URL="${2:?--callback-url requires a URL}"
      shift 2
      ;;
    --poll-interval)
      POLL_INTERVAL="${2:?--poll-interval requires seconds}"
      shift 2
      ;;
    --max-attempts)
      MAX_ATTEMPTS="${2:?--max-attempts requires a count}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --help|-h)
      cat <<'EOF'
Usage:
  krea-2-turbo-image.sh "prompt" [--size 16:9] [--quality 1K] [--seed 12345] [--nsfw-check true] [--callback-url https://...]

Options:
  --size           One of 1:1, 4:3, 3:4, 5:4, 4:5, 2:3, 3:2, 9:16, 16:9, 1:2, 2:1
  --quality        1K or 2K
  --seed           Integer from 0 to 1048576
  --nsfw-check     true or false
  --callback-url   HTTPS callback URL for async completion
  --dry-run        Print request payload without calling the API
EOF
      exit 0
      ;;
    *)
      PROMPT="$1"
      shift
      ;;
  esac
done

build_payload() {
  jq -n \
    --arg model "krea-2-turbo" \
    --arg prompt "$PROMPT" \
    --arg size "$SIZE" \
    --arg quality "$QUALITY" \
    --arg seed "$SEED" \
    --argjson nsfw_check "$NSFW_CHECK" \
    --arg callback_url "$CALLBACK_URL" '
      {
        model: $model,
        prompt: $prompt,
        size: $size,
        quality: $quality,
        nsfw_check: $nsfw_check
      }
      + (if $seed == "" then {} else {seed: ($seed | tonumber)} end)
      + (if $callback_url == "" then {} else {callback_url: $callback_url} end)
    '
}

PAYLOAD="$(build_payload)"

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'DRY_RUN: would call POST https://api.evolink.ai/v1/images/generations\n'
  printf '%s\n' "$PAYLOAD"
  exit 0
fi

: "${EVOLINK_API_KEY:?Set EVOLINK_API_KEY first}"

CREATE_RESPONSE=$(curl -sS --request POST \
  --url "https://api.evolink.ai/v1/images/generations" \
  --header "Authorization: Bearer ${EVOLINK_API_KEY}" \
  --header "Content-Type: application/json" \
  --header "X-EvoLink-Source: skill" \
  --header "X-EvoLink-Skill: krea-2-turbo-image" \
  --header "X-EvoLink-Package: evolink-krea-2-turbo" \
  --header "X-EvoLink-Campaign: krea-2-turbo-image" \
  --header "X-EvoLink-Touchpoint: first-call" \
  --data "$PAYLOAD")

TASK_ID=$(printf '%s' "$CREATE_RESPONSE" | jq -r '.id // empty')
ESTIMATED=$(printf '%s' "$CREATE_RESPONSE" | jq -r '.task_info.estimated_time // empty')
if [ -z "$TASK_ID" ]; then
  printf 'ERROR: create task failed\n%s\n' "$CREATE_RESPONSE" >&2
  exit 1
fi

printf 'TASK_SUBMITTED: task_id=%s estimated=%ss\n' "$TASK_ID" "${ESTIMATED:-unknown}"

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  TASK=$(curl -sS --request GET \
    --url "https://api.evolink.ai/v1/tasks/${TASK_ID}" \
    --header "Authorization: Bearer ${EVOLINK_API_KEY}" \
    --header "X-EvoLink-Source: skill" \
    --header "X-EvoLink-Skill: krea-2-turbo-image" \
    --header "X-EvoLink-Package: evolink-krea-2-turbo" \
    --header "X-EvoLink-Campaign: krea-2-turbo-image" \
    --header "X-EvoLink-Touchpoint: first-call")

  STATUS=$(printf '%s' "$TASK" | jq -r '.status // empty')
  PROGRESS=$(printf '%s' "$TASK" | jq -r '.progress // empty')
  if [ "$STATUS" = "completed" ]; then
    printf '%s\n' "$TASK" | jq .
    RESULT=$(printf '%s' "$TASK" | jq -r '.results[0] // .result_url // .url // .file_url // .output_url // .result_data.url // empty')
    if [ -n "$RESULT" ]; then
      printf 'RESULT_URL=%s\n' "$RESULT"
    fi
    exit 0
  fi
  if [ "$STATUS" = "failed" ]; then
    printf 'ERROR: task failed\n%s\n' "$TASK" >&2
    exit 1
  fi
  printf 'STATUS_UPDATE: status=%s progress=%s attempt=%s/%s\n' "${STATUS:-unknown}" "${PROGRESS:-unknown}" "$attempt" "$MAX_ATTEMPTS"
  sleep "$POLL_INTERVAL"
done

printf 'POLL_TIMEOUT: task_id=%s dashboard=https://evolink.ai/dashboard/keys?utm_source=skill&utm_medium=install&utm_campaign=krea-2-turbo-image\n' "$TASK_ID" >&2
exit 1
