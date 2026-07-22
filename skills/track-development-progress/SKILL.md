---
name: track-development-progress
description: Record business-facing and technical changes for each repository after development work, including changed capabilities, user-visible behavior, API/data changes, validation results, risks, and commit references. Use when finishing a coding task, updating the repository progress snapshot, or documenting what changed beyond commit messages.
---

# Track Development Progress

记录开发任务完成后的业务功能变化，并按仓库保存到根仓库 `.progress/<仓库名>.md`。

## Workflow

1. Identify every changed repository and its final commit. Inspect the task request, `git diff`, changed files, and relevant tests; do not infer business behavior from the commit title alone.
2. For each repository, write a concise entry containing:
   - `功能变化`: user-visible capability or business behavior added, changed, or removed.
   - `技术变化`: important API, data model, route, configuration, or architecture changes.
   - `验证结果`: tests, lint, typecheck, manual checks, or explicit not-run reason.
   - `风险与后续`: known gaps, compatibility concerns, follow-up work, or `无`.
3. Keep the entry factual. Separate implemented behavior from planned behavior, and mention mock-only or partially implemented behavior explicitly.
4. Append the entry with the bundled helper script. The script creates or updates one Markdown file per repository under the ignored `.progress/` directory:

   ```bash
   printf '%s\n' '- 功能变化：...' '- 技术变化：...' '- 验证结果：...' '- 风险与后续：...' \\
     | skills/track-development-progress/scripts/append-progress-entry.sh \\
         --repo '<repository-name>' --commit '<commit-sha>' --category '<feature|fix|refactor|config|docs>'
   ```

5. Run `./scripts/progress.sh` from the harness root. It refreshes and displays the current repository status and lists the per-repository progress files; it does not create a consolidated snapshot.
6. Do not commit `.progress/`; it is local working state and must remain ignored by Git.

## Entry quality rules

- Prefer business terms over file names: say “支持按能力切换 V1/V2 评测版本”，not “新增 `VersionToggle.tsx`”.
- Include scope: identify the affected capability, user flow, endpoint, or repository.
- Record cross-repository work as separate entries, then mention the integration relationship in `风险与后续`.
- If only infrastructure or configuration changed, state the developer impact instead of inventing user-facing functionality.
- If the task is incomplete, record what is implemented and what remains.

## Output shape

Use one entry per repository and commit. Keep each entry short enough to scan in a progress report:

```text
## 2026-07-22 — v-ai-platform — abc1234
- category: feature
- 功能变化：...
- 技术变化：...
- 验证结果：...
- 风险与后续：...
```

Each repository file starts with a repository heading, for example `.progress/v-ai-platform.md`, followed by its chronological entries. Do not create a `.progress` file, `.progress.prev`, or `.progress-log.md`; `.progress` is a directory.

## Resources

Use [scripts/append-progress-entry.sh](scripts/append-progress-entry.sh) to append entries consistently and avoid duplicate records for the same repository/commit.
