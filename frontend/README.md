# 音乐系统前端

独立 Vue 3 + Vite 前端。旧版后端静态页面保留在 `src/main/resources/static/`，可作为回退入口；本前端开发和构建均在 `frontend/` 内执行。

## 本地启动

先在项目根目录按现有方式启动后端（默认 `http://localhost:8080`），并确保启动进程已配置 `JWT_SECRET`。然后在 PowerShell 执行：

```powershell
cd D:\IntelliJ\music-system\frontend
npm install
npm run dev
```

打开 Vite 输出的 `http://localhost:5173`。Vite 将 `/api` 和 `/media` 转发到 `http://localhost:8080`。如果后端端口变更，请同步修改 `vite.config.js`。

生产构建：

```powershell
cd D:\IntelliJ\music-system\frontend
npm run build
```

构建产物写入 `frontend/dist/`，当前不自动复制到 Spring Boot 静态目录；这是独立前后端分离部署。部署时由静态 Web 服务器托管 `dist`，并将 `/api`、`/media` 反向代理到后端。

## 后端对接边界

- API 响应按 `Result { code, message, data }` 解包，仅 `code = 200` 视为成功。登录使用 `data.token` 和 `data.userInfo`，请求头为 `Authorization: Bearer <token>`。
- 后端 `WebConfig` 当前拦截所有 `/api/**`，只有登录、注册、测试和支付回调例外，因此专辑、盲盒列表页面也需要先登录。
- 后端暂无用户资料更新、用户订单后台列表、运营统计、盲盒用户抽取接口。前端对应页面不会用假数据模拟这些结果。审计日志接口要求 `super_admin`。
- 支付服务当前不能作为真实支付渠道使用。订单创建、支付创建、退款等操作会产生业务写入；请只在测试数据环境中验证。
