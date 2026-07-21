# harness-dev

个人多仓库开发管理 + 经验沉淀的中枢仓库。

## 目录结构

```
harness-dev/
├── projects/        # Git Submodules — 各子项目
├── skills/          # 个人技能库（可复用的操作流程、SOP）
│   └── templates/   # Skill 模板
├── snippets/        # 可复用代码片段
│   ├── js/
│   ├── shell/
│   └── config/
├── docs/            # 文档 & 架构决策记录（ADR）
│   └── adr/
└── scripts/         # 仓库管理工具脚本
```

## 子项目管理（Git Submodules）

### 添加新子项目

```bash
# 推荐使用封装脚本
./scripts/add-project.sh <repo-url> [local-name]

# 或手动添加
git submodule add <repo-url> projects/<name>
git commit -m "chore: add submodule <name>"
```

### 克隆此仓库（含所有子模块）

```bash
git clone --recurse-submodules <harness-repo-url>

# 已克隆但忘记加 --recurse-submodules
git submodule update --init --recursive
```

### 同步所有子模块到最新

```bash
./scripts/sync-all.sh

# 或手动
git submodule update --remote --merge
```

### 常用命令速查

| 操作 | 命令 |
|------|------|
| 查看子模块状态 | `git submodule status` |
| 进入子模块开发 | `cd projects/<name>` |
| 更新单个子模块 | `git submodule update --remote projects/<name>` |
| 删除子模块 | `git rm projects/<name>` |

## Skills 体系

`skills/` 目录下的每个子目录是一个独立的 Skill，遵循统一格式（见 `skills/templates/SKILL.md`）。

Skill 可以被 AI 工具（如 Cursor Agent）直接读取和执行，也可作为个人操作手册使用。

## 约定

- 所有子模块放在 `projects/` 目录下
- Skill 文件名统一为 `SKILL.md`
- 代码片段按语言分类存放在 `snippets/`
- 架构决策记录（ADR）放在 `docs/adr/`，命名格式：`NNNN-title.md`
