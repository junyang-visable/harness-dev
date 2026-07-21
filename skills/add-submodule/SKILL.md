# Add Git Submodule

> **适用场景**：将一个已有的 Git 仓库作为子模块挂载到 `harness-dev/projects/` 下。

## 前置条件

- [ ] 已克隆并进入 `harness-dev` 根目录
- [ ] 目标仓库已存在于远端（GitHub / GitLab 等）
- [ ] 有目标仓库的读取权限（SSH Key 或 Token 已配置）

## 步骤

### Step 1: 执行添加脚本

```bash
./scripts/add-project.sh <repo-url> [local-name]

# 示例
./scripts/add-project.sh git@github.com:yangjun/my-app.git my-app
```

脚本会自动：
- 执行 `git submodule add`
- 提交 `chore: add submodule <name>` 到主仓库

### Step 2（可选）: 手动指定跟踪分支

默认跟踪子模块远端的默认分支。如需跟踪特定分支，在 `.gitmodules` 中添加 `branch` 字段：

```ini
[submodule "projects/my-app"]
    path = projects/my-app
    url = git@github.com:yangjun/my-app.git
    branch = main   # ← 新增这一行
```

然后提交：

```bash
git add .gitmodules
git commit -m "chore(submodule): track branch main for my-app"
```

### Step 3: 通知协作者

其他人在拉取主仓库后需要初始化子模块：

```bash
git submodule update --init --recursive
```

## 验证

```bash
git submodule status
# 输出示例（前缀 + 表示已更新到最新）:
# +abc1234 projects/my-app (heads/main)
```

## 常见问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| `fatal: 'projects/my-app' already exists` | 目录已存在但未作为 submodule 登记 | 删除该目录后重新执行 |
| 子模块显示 `-` 前缀 | 未初始化 | `git submodule update --init` |
| 子模块显示 `+` 前缀 | 本地有超前提交 | `cd projects/<name>` 后 push 或 reset |

## 参考资料

- [Pro Git: Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- 相关脚本: `scripts/add-project.sh`、`scripts/sync-all.sh`

---
*最后更新: 2026-07-21*
