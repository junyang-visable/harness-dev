# Agent 工作约定

## Progress 信息

每次完成代码修改后，必须按照以下顺序执行：

1. 在对应项目中运行与改动相关的 lint、typecheck、测试或其他必要验证。
2. 在实际发生代码修改的项目中创建 Git commit。
3. 回到本仓库根目录 `/Users/yangjun/Desktop/harness-dev`，执行：

   ```bash
   ./scripts/progress.sh
   ```

4. 最终回复中说明修改内容、验证结果、commit，以及 progress 已更新。

`.progress` 是本地工作状态快照，默认被 `.gitignore` 忽略，不要提交它，除非用户明确要求。

如果一次任务同时修改多个子项目，分别提交各子项目后，再统一执行一次根仓库的 `./scripts/progress.sh`。
