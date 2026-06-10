# CC Switch 使用指南

[CC Switch](https://github.com/farion1231/cc-switch) 是本机 **Agent 配置管理工具**：保存多套 API 供应商预设，切换时写入各 Agent 配置文件。数据存储在 `~/.cc-switch/cc-switch.db`（[说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/5-faq/5.1-config-files.md)）。

各 Agent 的 taas.hk 接入步骤见对应指南。**Codex 槽位操作步骤**见 [codex.md §3](./codex.md#3-taashk-网关接入--cc-switch)。

---

## 职责

| 做 | 不做 |
|----|------|
| 保存预设，切换时写 Agent 配置 | 替代 Agent 安装 |
| Claude Desktop 模型映射与格式转换 | 管理 Agent 会话历史 |

常规模式下 Agent **直连**供应商 API。Claude Desktop **模型映射**模式例外：请求经本地路由网关 `127.0.0.1:15721` 转发（[路由说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/4-proxy/4.2-routing.md)）。

---

## 写入的配置文件

| Agent | 文件 |
|-------|------|
| Codex | `~/.codex/config.toml`、`~/.codex/auth.json` |
| Claude Code | `~/.claude/settings.json` |
| OpenCode | `~/.config/opencode/opencode.json` |
| OpenClaw | `~/.openclaw/openclaw.json` |

不必安装 CC Switch 也可手改上述文件接入 taas.hk。

---

## taas.hk 槽位参数

### Codex

Base URL `https://taas.hk/v1`，Wire API `responses`，模型 `gpt-5.5`。切换后完全退出 Codex（`Cmd+Q`）再打开。

操作步骤见 [codex.md §3](./codex.md#3-taashk-网关接入--cc-switch)。

### Claude Code（CLI）

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk`（不带 `/v1`） |
| API Key | `sk-...` |

运行 `claude --bare -p --model gpt-5.5`。

### Claude Desktop

接 `gpt-5.5` 等 GPT 模型时须开启模型映射（[官方说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/zh/2-providers/2.6-claude-desktop.md)）。Desktop 侧须先完成 [Cowork on 3P](./claude-code.md#3-taashk-网关接入--desktop) 切换。

| 步骤 | 操作 |
|------|------|
| 1 | CC Switch → **Claude Desktop** 面板（与 CLI 的 Claude 槽位分开） |
| 2 | 添加 taas.hk：Base URL `https://taas.hk`，API Key 你的令牌 |
| 3 | 开启**需要模型映射**，填写下表 |
| 4 | 设置 → 路由 → **显示本地路由开关**；Desktop 面板开启**本地路由** |
| 5 | 完全退出并重启 Claude Desktop；映射模式须保持 CC Switch 运行 |

| 模型角色 | 实际请求模型 |
|----------|--------------|
| Sonnet | `gpt-5.5` |

CC Switch 会写入 Desktop 的 3P profile；映射模式下请求经 `127.0.0.1:15721` 转发。

### OpenCode

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | `sk-...` |
| Provider 包 | `@ai-sdk/openai-compatible` |
| 模型 | `gpt-5.5` |

### OpenClaw

在 OpenClaw 槽位按界面填写；写入 `~/.openclaw/openclaw.json`。配置结构见 [OpenClaw 文档](https://docs.openclaw.ai/gateway/configuration)。

---

## 切换供应商

| Agent | 操作 |
|-------|------|
| Codex | 完全退出（`Cmd+Q`）再打开 |
| Claude Code（CLI） | 重新运行 `claude` |
| Claude Desktop | 完全退出并重启；映射模式保持本地路由开启 |
| OpenCode / OpenClaw | 重启对应 Agent |

Codex 切换会改写 `model_provider`，侧边栏历史可能变化，见 [codex.md · 常见问题](./codex.md#常见问题)。

---

## 常见问题

**Claude Code 的 Base URL 为什么不带 `/v1`？**  
CLI 自动拼接 `/v1/messages`，填 `https://taas.hk/v1` 会导致路径重复。

**Claude Desktop 直连模式与映射模式区别？**  
直连：CC Switch 只写 3P profile，无需保持本地路由。映射：须开启本地路由并保持 CC Switch 运行，用于 GPT 等非 Claude 角色模型。

---

## 相关文档

[codex.md](./codex.md) · [claude-code.md](./claude-code.md) · [opencode.md](./opencode.md) · [接入指南总览](../README.md)
