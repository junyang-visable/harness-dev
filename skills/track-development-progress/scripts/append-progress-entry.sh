#!/usr/bin/env bash
# Prepend one business-change entry to a repository-specific progress file.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROGRESS_DIR="$ROOT_DIR/.progress"

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

if [[ "$REPO" == .* || "$REPO" == */* || "$REPO" == *..* ]]; then
  echo "❌ --repo must be a simple repository name without path separators or '..'" >&2
  exit 2
fi

BODY="$(cat)"
if [[ -z "${BODY//[[:space:]]/}" ]]; then
  echo "❌ progress entry body must be provided on stdin" >&2
  exit 2
fi

mkdir -p "$PROGRESS_DIR"
PROGRESS_FILE="$PROGRESS_DIR/$REPO.md"

if [[ -f "$PROGRESS_FILE" ]] && grep -Fq -- " — $REPO — $COMMIT" "$PROGRESS_FILE"; then
  echo "ℹ️  已存在 $REPO@$COMMIT 的 progress 记录，跳过"
  exit 0
fi

if [[ ! -f "$PROGRESS_FILE" ]]; then
  printf '# %s Progress\n' "$REPO" > "$PROGRESS_FILE"
fi

ENTRY_FILE=$(mktemp)
TEMP_FILE=$(mktemp)
trap 'rm -f "$ENTRY_FILE" "$TEMP_FILE"' EXIT

{
  printf '\n## %s — %s — %s\n' "$(date '+%Y-%m-%d')" "$REPO" "$COMMIT"
  printf '%s\n' "- category: $CATEGORY"
  printf '%s\n' "$BODY"
} > "$ENTRY_FILE"

{
  IFS= read -r HEADER || true
  printf '%s\n' "$HEADER"
  cat "$ENTRY_FILE"
  tail -n +2 "$PROGRESS_FILE"
} < "$PROGRESS_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$PROGRESS_FILE"

echo "✅ 已更新 progress 业务记录（最新记录置顶）: $REPO@$COMMIT"
