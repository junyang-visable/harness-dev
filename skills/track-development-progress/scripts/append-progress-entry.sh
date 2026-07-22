#!/usr/bin/env bash
# Append one business-change entry to the harness progress log.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
LOG_FILE="$ROOT_DIR/.progress-log.md"

REPO=""
COMMIT=""
CATEGORY="feature"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO="${2:?--repo requires a value}"
      shift 2
      ;;
    --commit)
      COMMIT="${2:?--commit requires a value}"
      shift 2
      ;;
    --category)
      CATEGORY="${2:?--category requires a value}"
      shift 2
      ;;
    *)
      echo "Usage: $0 --repo NAME --commit SHA [--category CATEGORY]" >&2
      exit 2
      ;;
  esac
done

if [[ -z "$REPO" || -z "$COMMIT" ]]; then
  echo "❌ --repo and --commit are required" >&2
  exit 2
fi

BODY="$(cat)"
if [[ -z "${BODY//[[:space:]]/}" ]]; then
  echo "❌ progress entry body must be provided on stdin" >&2
  exit 2
fi

if [[ -f "$LOG_FILE" ]] && grep -Fq -- " — $REPO — $COMMIT" "$LOG_FILE"; then
  echo "ℹ️  已存在 $REPO@$COMMIT 的 progress 记录，跳过"
  exit 0
fi

{
  printf '\n## %s — %s — %s\n' "$(date '+%Y-%m-%d')" "$REPO" "$COMMIT"
  printf '%s\n' "- category: $CATEGORY"
  printf '%s\n' "$BODY"
} >> "$LOG_FILE"

echo "✅ 已追加 progress 业务记录: $REPO@$COMMIT"
