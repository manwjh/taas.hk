# 典型用户场景

本文档汇总 **3 种最常见** 的 taas.hk 接入路径，按步骤操作即可。详细参数与排错见各 Agent 专篇。

**共用前置**（每个场景开始前建议完成）：

| 步骤 | 操作 |
|------|------|
| 1 | 登录 [taas.hk](https://taas.hk) → **令牌 / Token** → **新建令牌**（pro 或 plus），复制 `sk-...` |
| 2 | 验证连通：`curl -H "Authorization: Bearer sk-..." https://taas.hk/v1/models` |

> 📷 **插图** `images/common/01-create-token.png`  
> 说明：taas.hk 控制台「新建令牌」页面，复制密钥（仅显示一次）。

> 📷 **插图** `images/common/02-verify-models.png`  
> 说明：终端执行 `curl .../v1/models` 返回模型列表。

---

## 场景索引

| 场景 | 适用人群 | 文档 |
|------|----------|------|
| **场景一** | 只用 Codex，愿意手改配置文件 | [scenario-01-codex-direct.md](./scenario-01-codex-direct.md) |
| **场景二** | 用 Codex，且需在多套 API 供应商间切换 | [scenario-02-cc-switch-codex.md](./scenario-02-cc-switch-codex.md) |
| **场景三** | 用 Claude Desktop，且要用 GPT 模型（如 `gpt-5.5`） | [scenario-03-cc-switch-claude-desktop.md](./scenario-03-cc-switch-claude-desktop.md) |

---

## 连接参数速查

| Agent | Base URL | 协议 | 备注 |
|-------|----------|------|------|
| **Codex** | `https://taas.hk/v1` | Responses | `wire_api = "responses"` |
| **Claude Desktop（3P）** | `https://taas.hk` | Messages | 根域，**不带** `/v1` |
| **Claude Desktop + GPT 映射** | `https://taas.hk` | Messages + 本地路由 | 须 CC Switch 模型映射 |

---

## 专篇索引

| 文档 | 内容 |
|------|------|
| [codex.md](./codex.md) | Codex 官方配置、直接配置、CC Switch 参数 |
| [claude-code.md](./claude-code.md) | Claude Code CLI / Desktop 手动配置 |
| [cc-switch.md](./cc-switch.md) | CC Switch 槽位参数与切换说明 |
| [opencode.md](./opencode.md) | OpenCode Provider 配置 |

[返回接入指南总览](../README.md)
