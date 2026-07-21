# 0001: 使用 Git Submodules 管理多仓库

**状态**: 已接受
**日期**: 2026-07-21

## 背景

需要在一个中枢仓库中管理多个独立项目，同时保持各子项目的独立 Git 历史和部署流程。

## 决策

使用 **Git Submodules**，将各子项目以固定 commit 引用挂载到 `projects/` 目录。

## 后果

**优点**:
- 各子项目保持完全独立的仓库、历史和 CI/CD
- 主仓库记录每个子项目的精确版本（commit hash），可追溯
- 无需引入额外工具（monorepo 工具链等）

**取舍**:
- 子模块更新需要手动触发（`./scripts/sync-all.sh`）
- 新成员需要额外了解 submodule 的工作方式
- Clone 时需要 `--recurse-submodules` 参数
