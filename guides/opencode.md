# OpenCode 使用指南

[OpenCode](https://opencode.ai) 是**开源 Agent**，通过 [Provider](https://opencode.ai/docs/providers/) 对接模型。本文说明 Provider 机制与 taas.hk 的手动配置步骤。

**前置**：已在 taas.hk 创建令牌，见 [README · 创建令牌](../README.md#创建令牌)。

---

## 1. Provider 机制

OpenCode 无厂商订阅登录。在配置中添加 Provider 即可对接：

- 厂商官方 API（OpenAI、Anthropic 等，经 `/connect` 录入凭据）
- API 网关（如 taas.hk）

配置层级（[Config](https://opencode.ai/docs/config/)）：

| 范围 | 路径 |
|------|------|
| 全局 | `~/.config/opencode/opencode.json` |
| 项目 | 项目根 `opencode.json`（优先级更高） |

厂商 API 与网关的配置结构相同，仅 Base URL 与 API Key 不同。

---

## 2. taas.hk Provider

### 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | taas.hk 令牌 `sk-...` |
| SDK 包 | `@ai-sdk/openai-compatible` |
| 协议 | Chat Completions（`POST /v1/chat/completions`） |

若模型走 `/v1/responses`，应改用 `@ai-sdk/openai`（taas.hk 当前以 Chat 验证连通）。

### 配置

**方式 A：配置文件**

`~/.config/opencode/opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "taas": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "taas.hk",
      "options": {
        "baseURL": "https://taas.hk/v1",
        "apiKey": "{env:TAAS_API_KEY}"
      },
      "models": {
        "gpt-5.5": { "name": "gpt-5.5" }
      }
    }
  },
  "model": "taas/gpt-5.5"
}
```

```bash
export TAAS_API_KEY=sk-your-token
```

**方式 B：TUI**

1. 运行 `/connect`，Provider ID 与配置 key 一致（如 `taas`），录入 API Key
2. 在 `opencode.json` 中补全 `provider`、`models`、`model`
3. `/models` 中应出现 `taas/gpt-5.5`

修改配置后重启 OpenCode。

### 验证

```bash
curl -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models

curl -X POST https://taas.hk/v1/chat/completions \
  -H "Authorization: Bearer sk-your-token" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","messages":[{"role":"user","content":"hello"}]}'
```

---

## 相关文档

[接入指南总览](../README.md)
