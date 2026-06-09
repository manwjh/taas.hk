# Codex 使用指南

[Codex](https://openai.com/codex) 是 OpenAI **厂商 Agent**。本文对应 [README §一、§二](../README.md)：官方计费说明，以及经 taas.hk 网关接入的具体步骤。

**前置**：已在 taas.hk 创建令牌，见 [README · 创建令牌](../README.md#创建令牌)。

---

## 1. 官方配置

| 入口 | 说明 |
|------|------|
| **Codex app** | macOS / Windows |
| **CLI** | `codex` |
| **IDE 扩展** | VS Code 等 |

三者共用 `~/.codex/config.toml` 与登录缓存（[Authentication](https://developers.openai.com/codex/auth)）。

| 计费 | 说明 |
|------|------|
| **ChatGPT 订阅** | 浏览器登录 ChatGPT |
| **API key** | [OpenAI Platform](https://platform.openai.com/) 按量计费 |

CLI 无有效会话时，默认引导 ChatGPT 登录。此路径下无需改 Base URL。

---

## 2. taas.hk 网关接入

### 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | 环境变量 `OPENAI_API_KEY=sk-...` |
| 模型 | `gpt-5.5`、`gpt-5.4` 等（以 `/v1/models` 为准） |
| 协议 | Responses，`wire_api = "responses"` |

Codex 使用 [Responses API](https://developers.openai.com/codex/config-advanced#custom-model-providers)，不是 Chat Completions。

### 配置

编辑 `~/.codex/config.toml`：

```toml
model_provider = "taas"
model = "gpt-5.5"

[model_providers.taas]
name = "taas.hk"
base_url = "https://taas.hk/v1"
wire_api = "responses"
env_key = "OPENAI_API_KEY"
```

```bash
export OPENAI_API_KEY=sk-your-token
```

- **App / IDE**：通常读不到终端 `export`，将 `OPENAI_API_KEY=sk-...` 写入 `~/.codex/.env`（[Config basics](https://developers.openai.com/codex/config-basic)）。
- **生效**：完全退出 Codex（macOS：`Cmd+Q`）后重新打开。
- **切换来源**：若仍走 ChatGPT 订阅，在 Codex 中登出后再用上述配置启动。

### 验证

```bash
curl -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models
codex
```

### CC Switch（可选）

Codex 槽位：Base URL `https://taas.hk/v1`，Wire API `responses`，模型 `gpt-5.5`。切换后完全退出再打开。见 [cc-switch.md](./cc-switch.md)。

---

## 常见问题

**切换 `model_provider` 后侧边栏历史变少？**  
本地会话按 `model_provider` 分组；可用 `codex resume --all` 查看。

**504 超时？**  
先用 Chat 接口验证令牌（[README · 验证](../README.md#验证连通)），再排查 Responses 链路。

---

## 相关文档

[cc-switch.md](./cc-switch.md) · [接入指南总览](../README.md)
