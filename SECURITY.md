# 安全政策

## 支持的版本

我们会对以下版本发布安全更新：

| 版本 | 支持状态 |
|------|----------|
| 最新 main 分支 | ✅ 支持 |

## 报告漏洞

如发现安全漏洞，请**不要**在公开 Issue 中披露。请通过以下方式私下报告：

- 在仓库中创建 **Private Security Advisory**：  
  GitHub 仓库 → **Security** → **Advisories** → **Report a vulnerability**
- 或通过可验证的途径联系维护者（若仓库中提供了联系方式）。

我们会尽快确认并回复，并在修复后（如适用）在 Release / Advisory 中致谢（经你同意后）。

## 安全相关实践建议

- 不要将 `.env`、`TELEGRAM_BOT_TOKEN`、`OPENCLAW_GATEWAY_TOKEN` 等敏感信息提交到仓库或写入日志。
- 生产环境建议使用环境变量或密钥管理服务加载配置，并限制脚本与 Bot 的访问权限。
