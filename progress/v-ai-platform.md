# v-ai-platform Progress

## 2026-07-22 — v-ai-platform — f51e15e
- category: config
- 功能变化：前端本地开发请求统一代理到本地后端服务，支持前后端联调。
- 技术变化：Vite API 代理目标改为 localhost:8080，并移除 /api/v-ai-platform 前缀后转发；OAuth2 代理同步切换到本地后端。
- 验证结果：已提交 commit f51e15e；feature/refactor-react 已是当前分支祖先，合并结果为 Already up to date。
- 风险与后续：当前未推送到远端；本地 OAuth2 端点是否完整仍取决于后端实现。

## 2026-07-22 — v-ai-platform — 0fae111
- category: feature
- 功能变化：同步最新 React 架构分支，包含根路径门户首页、SSO 后用户落地页和认证降级处理。
- 技术变化：更新 Nginx 配置、首页资源和 AuthContext；保留当前本地后端代理配置。
- 验证结果：pnpm typecheck 通过；远端 feature/refactor-react 已合并，无冲突。
- 风险与后续：需要在本地重新加载前端开发服务器，确认 SSO 回调和根路径展示。

## 2026-07-22 — v-ai-platform — eeb37ae
- category: config
- 功能变化：预发和线上前端页面支持通过 /market 直接访问，不再要求 /v-ai-platform 前缀；入口页链接同步指向 /market。
- 技术变化：生产构建 base、Nginx SPA 路由回退和容器静态文件目录统一切换为根路径；/api/v-ai-platform 后端接口前缀保持不变。
- 验证结果：pnpm typecheck 通过；pnpm build 通过；确认构建资源使用 /assets/... 根路径；git diff --check 通过。
- 风险与后续：仍需部署到预发验证上层 ingress/CDN 是否存在额外路径重写；旧 /v-ai-platform 路径不再作为主入口。
