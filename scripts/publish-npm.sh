#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAGE_DIR="${STAGE_DIR:-${ROOT_DIR}/.npm-stage}"
EXECUTE=0

for arg in "$@"; do
  case "$arg" in
    --execute) EXECUTE=1 ;;
    --dry-run) EXECUTE=0 ;;
    *)
      printf 'Unknown argument: %s\n' "$arg" >&2
      printf 'Usage: scripts/publish-npm.sh [--dry-run|--execute]\n' >&2
      exit 2
      ;;
  esac
done

if [ ! -f "${ROOT_DIR}/README.npm.md" ]; then
  printf 'README.npm.md is required before npm release staging.\n' >&2
  exit 1
fi

rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"

rsync -a \
  --exclude '.git/' \
  --exclude '.codex/' \
  --exclude '.github/' \
  --exclude '.npm-stage/' \
  --exclude 'reports/' \
  --exclude 'node_modules/' \
  --exclude 'github-repo-review*.md' \
  --exclude 'README.*.md' \
  "$ROOT_DIR"/ "$STAGE_DIR"/

cp "${ROOT_DIR}/README.npm.md" "${STAGE_DIR}/README.md"

printf 'Staged npm payload at %s\n' "$STAGE_DIR"
(
  cd "$STAGE_DIR"
  npm pack --dry-run --json --ignore-scripts
)

if [ "$EXECUTE" -ne 1 ]; then
  printf 'Dry run only. Re-run with --execute after completion-gate passes and owner approval is recorded.\n'
  exit 0
fi

(
  cd "$STAGE_DIR"
  npm publish --access public --auth-type=web
)
