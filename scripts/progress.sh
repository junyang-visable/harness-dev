#!/usr/bin/env bash
# 刷新并显示仓库状态及按仓库拆分的 progress 文件。

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROGRESS_DIR="$ROOT_DIR/progress"
mkdir -p "$PROGRESS_DIR"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "# harness-dev Progress Status"
echo "# Generated: $TIMESTAMP"
echo "# ─────────────────────────────────────"
echo ""

cd "$ROOT_DIR"
echo "## Main Repo"
MAIN_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
MAIN_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
MAIN_DIRTY=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
echo "  branch:  $MAIN_BRANCH"
echo "  commit:  $MAIN_COMMIT"
echo "  dirty:   $MAIN_DIRTY files"
echo ""

echo "## Submodules"
echo ""
git submodule foreach --quiet '
  NAME=$(basename "$sm_path")
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
  DIRTY_COUNT=$(git status --porcelain 2>/dev/null | wc -l | tr -d " ")
  echo "### $NAME"
  echo "  path:      $sm_path"
  echo "  branch:    $BRANCH"
  echo "  commit:    $COMMIT"
  if [[ "$DIRTY_COUNT" -gt 0 ]]; then
    echo "  dirty:     yes ($DIRTY_COUNT files)"
  else
    echo "  dirty:     no"
  fi
  echo ""
'

echo "## Progress Files"
echo ""
shopt -s nullglob
FILES=("$PROGRESS_DIR"/*.md)
if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "暂无仓库 progress 文件。"
else
  for FILE in "${FILES[@]}"; do
    echo "- ${FILE#$ROOT_DIR/}"
  done
fi
echo ""
echo "# ─────────────────────────────────────"
echo "# Progress details are stored in progress/<repository>.md"
echo "✅ progress 状态已刷新 ($TIMESTAMP)"
