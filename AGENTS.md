# Agent 工作约定

## Progress 信息

每次完成代码修改后，必须按照以下顺序执行：

1. 在对应项目中运行与改动相关的 lint、typecheck、测试或其他必要验证。
2. 在实际发生代码修改的项目中创建 Git commit。
3. 根据 `skills/track-development-progress/SKILL.md`，为每个发生改动的仓库和 commit 记录业务功能变化、技术变化、验证结果和风险。
4. 回到本仓库根目录 `/Users/yangjun/Desktop/harness-dev`，执行：

   ```bash
   ./scripts/progress.sh
   ```

5. 最终回复中说明修改内容、验证结果、commit，以及 progress 已更新。

进度记录保存在 `.progress/<仓库名>.md`，按仓库分别维护；`.progress/` 是被 Git 忽略的本地工作目录。不要生成 `.progress` 文件、`.progress.prev` 或 `.progress-log.md`。

如果一次任务同时修改多个子项目，分别提交各子项目后，再统一执行一次根仓库的 `./scripts/progress.sh`。
