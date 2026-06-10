# CC Switch 使用指南

[CC Switch](https://github.com/farion1231/cc-switch) 是本机 **Agent 配置管理工具**：保存多套供应商预设，切换时写入各 Agent 配置文件。数据存储在 `~/.cc-switch/cc-switch.db`（[说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/5-faq/5.1-config-files.md)）。

---

## 职责

| 做 | 不做 |
|----|------|
| 保存预设，切换时写 Agent 配置 | 替代 Agent 安装 |
| Claude Desktop 模型映射与格式转换 | 管理 Agent 会话历史 |

常规模式下 Agent **直连**供应商 API。Claude Desktop **模型映射**模式例外：请求经本地路由网关（`127.0.0.1:15721`）转发（[路由说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/4-proxy/4.2-routing.md)）。

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

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | `sk-...` |
| 模型 | `gpt-5.5` |
| Wire API | `responses` |

切换后完全退出 Codex（`Cmd+Q`）再打开。

### Claude Code（CLI）

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk`（不带 `/v1`） |
| API Key | `sk-...` |

运行 `claude --bare -p --model gpt-5.5`。

### Claude Desktop

接 GPT 等非 Claude 角色模型时：

1. 开启**需要模型映射**（Sonnet/Opus/Haiku → 实际模型 id）
2. 开启**本地路由**，保持 CC Switch 运行
3. 重启 Claude Desktop

详见 [claude-code.md §3](./claude-code.md#3-taashk-网关接入--desktop)。

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

## 相关文档

- [codex.md](./codex.md) · [claude-code.md](./claude-code.md) · [opencode.md](./opencode.md) · [接入指南总览](../README.md)
