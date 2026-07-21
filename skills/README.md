# Skills 个人技能库

每个 Skill 是一个可重复执行的操作流程，记录在独立目录的 `SKILL.md` 文件中。

## 已有 Skills

| Skill | 适用场景 |
|-------|----------|
| [templates/SKILL.md](./templates/SKILL.md) | Skill 编写模板 |

## 如何新建 Skill

1. 在 `skills/` 下创建新目录，命名为 Skill 的功能（kebab-case）
2. 复制 `templates/SKILL.md` 并按实际情况填写
3. 在上表中登记

## Skill 与 AI 工具集成

Cursor Agent 可以直接读取和执行这里的 Skill。在对话中引用方式：

```
请读取并执行 skills/<name>/SKILL.md
```

## 命名约定

- 目录名：`kebab-case`，描述功能而非技术（如 `setup-ci` 而非 `github-actions`）
- 文件名：固定为 `SKILL.md`
- 附属脚本/配置：放在同目录下
