#!/usr/bin/env bash
# 同步所有子模块到各自远端分支的最新提交
# 用法: ./scripts/sync-all.sh [--branch <branch>]

set -euo pipefail

BRANCH="${2:-}"

echo "🔄 拉取主仓库最新..."
git pull --rebase

echo "🔄 同步所有子模块..."
if [[ -n "$BRANCH" ]]; then
  git submodule foreach "git fetch origin && git checkout $BRANCH && git pull origin $BRANCH || true"
else
  git submodule update --remote --merge
fi

echo ""
echo "📊 当前子模块状态:"
git submodule status

echo ""
echo "✅ 所有子模块同步完成。"
