# 音乐系统前端

独立 Vue 3 + Vite 前端，使用 Vue Router、Pinia、Axios 和 Element Plus。旧版静态页面仍保留在 `src/main/resources/static/`，新前端开发和构建在 `frontend/` 中完成。

## 本地启动

确认 MySQL 3307、Redis 6379 可用。当前用户级 `JWT_SECRET` 已本地配置；新开 PowerShell 会继承。已打开的 IDEA 需完全退出后重新启动，才能读取更新的用户环境变量。然后在项目根目录运行：

```powershell
cd D:\IntelliJ\music-system
mvn -s "$env:USERPROFILE\.m2\settings.xml" spring-boot:run
```

另开 PowerShell 启动前端：

```powershell
cd D:\IntelliJ\music-system\frontend
npm install
npm run dev
```

访问 `http://localhost:5173`。Vite 将 `/api`、`/media` 转发到 `http://localhost:8080`。生产构建：`npm run build`，输出 `frontend/dist/`；部署静态站点时需将 `/api` 和 `/media` 反向代理到后端。

## Playwright 浏览器测试

本地已安装 Playwright，默认使用 Windows Microsoft Edge。确保后端及开发数据库可用后：

```powershell
cd D:\IntelliJ\music-system\frontend
npm run test:e2e
```

用户流程测试会创建 `e2eqa*` 账号、地址、购物车、订单、模拟支付和退款申请；测试数据会保留，不会自动删除。管理员后台测试需预先建立获批准的管理员账号，并通过临时进程环境变量提供凭据：

```powershell
$env:E2E_ADMIN_USERNAME = '本地 QA 管理员用户名'
$env:E2E_ADMIN_PASSWORD = '本地 QA 管理员密码'
npm run test:e2e
Remove-Item Env:E2E_ADMIN_USERNAME, Env:E2E_ADMIN_PASSWORD
```

不要把密码、Token 或私钥写进源码或提交到 Git。

## 接口和数据约定

- API 响应为 `Result { code, message, data }`，只有业务 `code = 200` 才表示成功。登录数据为 `data.token` 和 `data.userInfo`，请求头为 `Authorization: Bearer <token>`。
- `WebConfig` 当前拦截所有 `/api/**`，注册、登录、测试和支付宝回调除外；因此首页目录请求当前需要登录。
- 盲盒支付后由后端事务执行抽取；前端不伪造抽奖结果。
- `pay.mock-enabled` 开启时用于本地模拟支付，不涉及真实资金。订单、支付、退款及盲盒请求会写业务数据，建议仅使用开发数据库。
- 审计日志表已在开发数据库安装，审计页面路由已部署；管理员查询/审计写入需独立 QA 管理员账号，创建前等待批准。
