#!/usr/bin/env bash
# 添加新子项目为 Git Submodule
# 用法: ./scripts/add-project.sh <repo-url> [local-name]

set -euo pipefail

REPO_URL="${1:?用法: $0 <repo-url> [local-name]}"
LOCAL_NAME="${2:-}"

# 从 URL 推断本地目录名（去掉 .git 后缀）
if [[ -z "$LOCAL_NAME" ]]; then
  LOCAL_NAME=$(basename "$REPO_URL" .git)
fi

TARGET_PATH="projects/$LOCAL_NAME"

# 检查是否已存在
if [[ -d "$TARGET_PATH" ]]; then
  echo "⚠️  $TARGET_PATH 已存在，跳过。"
  exit 0
fi

echo "➕ 添加子模块: $REPO_URL → $TARGET_PATH"
git submodule add "$REPO_URL" "$TARGET_PATH"
git commit -m "chore: add submodule $LOCAL_NAME"

echo "✅ 子模块 $LOCAL_NAME 添加完成。"
echo "   进入开发: cd $TARGET_PATH"
