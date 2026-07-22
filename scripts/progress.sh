#!/usr/bin/env bash
# 生成 .progress 快照文件，记录所有子模块的分支和变更状态
# 用法:
#   ./scripts/progress.sh          # 更新 .progress
#   ./scripts/progress.sh --diff   # 显示与上次快照的差异

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROGRESS_FILE="$ROOT_DIR/.progress"
PREV_FILE="$ROOT_DIR/.progress.prev"
BUSINESS_LOG="$ROOT_DIR/.progress-log.md"

if [[ "${1:-}" == "--diff" ]]; then
  if [[ ! -f "$PROGRESS_FILE" ]]; then
    echo "❌ 还没有 .progress 文件，先运行 ./scripts/progress.sh 生成。"
    exit 1
  fi
  # 先备份旧快照，生成新的，再 diff
  cp "$PROGRESS_FILE" "$PREV_FILE"
  # 递归调用自身生成新快照
  "$0"
  echo ""
  echo "📊 与上次快照的差异:"
  echo "─────────────────────────────────────"
  diff --unified=0 "$PREV_FILE" "$PROGRESS_FILE" || true
  rm -f "$PREV_FILE"
  exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

{
  echo "# harness-dev Progress Snapshot"
  echo "# Generated: $TIMESTAMP"
  echo "# ─────────────────────────────────────"
  echo ""

  # 主仓库状态
  echo "## Main Repo"
  cd "$ROOT_DIR"
  MAIN_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  MAIN_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
  MAIN_DIRTY=$(git diff --stat --shortstat 2>/dev/null | tail -1)
  echo "  branch:  $MAIN_BRANCH"
  echo "  commit:  $MAIN_COMMIT"
  if [[ -n "$MAIN_DIRTY" ]]; then
    echo "  dirty:   yes ($MAIN_DIRTY)"
  else
    echo "  dirty:   no"
  fi
  echo ""

  # 各子模块状态
  echo "## Submodules"
  echo ""

  git submodule foreach --quiet '
    NAME=$(basename "$sm_path")
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
    COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
    DIRTY_COUNT=$(git status --porcelain 2>/dev/null | wc -l | tr -d " ")
    STAGED=$(git diff --cached --stat --shortstat 2>/dev/null | tail -1)
    UNSTAGED=$(git diff --stat --shortstat 2>/dev/null | tail -1)
    UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d " ")

    # 检查是否有未推送的提交
    UPSTREAM=$(git rev-parse --abbrev-ref "@{upstream}" 2>/dev/null || echo "")
    if [[ -n "$UPSTREAM" ]]; then
      AHEAD=$(git rev-list --count "$UPSTREAM..HEAD" 2>/dev/null || echo "0")
      BEHIND=$(git rev-list --count "HEAD..$UPSTREAM" 2>/dev/null || echo "0")
    else
      AHEAD="?"
      BEHIND="?"
    fi

    echo "### $NAME"
    echo "  path:      $sm_path"
    echo "  branch:    $BRANCH"
    echo "  commit:    $COMMIT"
    echo "  ahead:     $AHEAD"
    echo "  behind:    $BEHIND"
    if [[ "$DIRTY_COUNT" -gt 0 ]]; then
      echo "  dirty:     yes ($DIRTY_COUNT files)"
      [[ -n "$STAGED" ]] && echo "  staged:    $STAGED"
      [[ -n "$UNSTAGED" ]] && echo "  unstaged:  $UNSTAGED"
      [[ "$UNTRACKED" -gt 0 ]] && echo "  untracked: $UNTRACKED files"
    else
      echo "  dirty:     no"
    fi
    echo ""
  '

  echo "## Business Changes"
  echo ""
  if [[ -f "$BUSINESS_LOG" ]]; then
    cat "$BUSINESS_LOG"
  else
    echo "暂无业务功能变化记录。"
  fi
  echo ""

  echo "# ─────────────────────────────────────"
  echo "# Tip: run ./scripts/progress.sh --diff to compare with previous snapshot"

} > "$PROGRESS_FILE"

echo "✅ .progress 已更新 ($TIMESTAMP)"
echo ""
cat "$PROGRESS_FILE"
