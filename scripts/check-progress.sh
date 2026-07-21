#!/usr/bin/env bash
# 跨项目开发检查工具 — 快速查看所有子模块的工作状态
# 用法:
#   ./scripts/check-progress.sh              # 彩色终端摘要
#   ./scripts/check-progress.sh --save       # 同时保存到 .progress
#   ./scripts/check-progress.sh --branches   # 只列出各子模块分支

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

MODE="${1:-}"

if [[ "$MODE" == "--branches" ]]; then
  printf "${BOLD}%-30s %-20s %-10s${RESET}\n" "PROJECT" "BRANCH" "COMMIT"
  printf "%-30s %-20s %-10s\n" "──────────────────────────────" "────────────────────" "──────────"

  git submodule foreach --quiet '
    NAME=$(basename "$sm_path")
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
    COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
    printf "%-30s %-20s %-10s\n" "$NAME" "$BRANCH" "$COMMIT"
  '
  exit 0
fi

echo ""
printf "${BOLD}🔍 Cross-Project Development Check${RESET}\n"
printf "${DIM}   $(date '+%Y-%m-%d %H:%M:%S')${RESET}\n"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

WARN_COUNT=0

git submodule foreach --quiet '
  NAME=$(basename "$sm_path")
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
  DIRTY_COUNT=$(git status --porcelain 2>/dev/null | wc -l | tr -d " ")

  UPSTREAM=$(git rev-parse --abbrev-ref "@{upstream}" 2>/dev/null || echo "")
  if [[ -n "$UPSTREAM" ]]; then
    AHEAD=$(git rev-list --count "$UPSTREAM..HEAD" 2>/dev/null || echo "0")
    BEHIND=$(git rev-list --count "HEAD..$UPSTREAM" 2>/dev/null || echo "0")
  else
    AHEAD="0"
    BEHIND="0"
  fi

  # 状态图标
  if [[ "$DIRTY_COUNT" -gt 0 ]]; then
    STATUS_ICON="🟡"
    STATUS_TEXT="$DIRTY_COUNT 个文件有变更"
  elif [[ "$AHEAD" -gt 0 ]]; then
    STATUS_ICON="🔵"
    STATUS_TEXT="$AHEAD 个提交未推送"
  else
    STATUS_ICON="🟢"
    STATUS_TEXT="clean"
  fi

  printf "\n  %s ${BOLD}%s${RESET}\n" "$STATUS_ICON" "$NAME"
  printf "     branch: %s  commit: %s\n" "$BRANCH" "$COMMIT"

  if [[ "$AHEAD" -gt 0 || "$BEHIND" -gt 0 ]]; then
    printf "     sync:   ↑%s ↓%s\n" "$AHEAD" "$BEHIND"
  fi

  if [[ "$DIRTY_COUNT" -gt 0 ]]; then
    printf "     status: %s\n" "$STATUS_TEXT"
    git status --porcelain 2>/dev/null | head -5 | while read -r line; do
      printf "             %s\n" "$line"
    done
    REMAINING=$((DIRTY_COUNT - 5))
    if [[ $REMAINING -gt 0 ]]; then
      printf "             ... 还有 %d 个文件\n" "$REMAINING"
    fi
  fi

  if [[ "$BRANCH" == "detached" || "$BRANCH" == "HEAD" ]]; then
    printf "     ⚠️  处于 detached HEAD 状态，注意切换到工作分支\n"
  fi
'

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ "$MODE" == "--save" ]]; then
  "$ROOT_DIR/scripts/progress.sh" > /dev/null 2>&1
  printf "${GREEN}📝 已同时保存到 .progress${RESET}\n"
fi

echo ""
printf "${DIM}Tip: ./scripts/check-progress.sh --branches  快速查看分支列表${RESET}\n"
printf "${DIM}     ./scripts/progress.sh --diff             对比上次快照${RESET}\n"
echo ""
