# Claude Code 使用指南

[Claude Code](https://code.claude.com/docs/en/overview) 是 Anthropic **厂商 Agent**。本文说明官方配置与 taas.hk 网关的手动接入步骤。

**前置**：已在 taas.hk 创建令牌，见 [README · 创建令牌](../README.md#创建令牌)。

---

## 1. 官方配置

| 入口 | 说明 |
|------|------|
| **CLI** | `claude` |
| **Desktop** | Claude 桌面应用 **Code** 标签页 |

| 计费 | 说明 |
|------|------|
| **订阅** | Pro / Max / Team / Enterprise |
| **API** | [Anthropic Console](https://console.anthropic.com/) API key |

CLI 与 Desktop 首次使用通常以 Anthropic 账号登录。Desktop 默认 **1P** 模式，推理走 Anthropic 官方基础设施，无需改 Base URL。

---

## 2. taas.hk 网关接入 · CLI

### 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk`（根域，**不带** `/v1`） |
| API Key | `ANTHROPIC_API_KEY=sk-...` |
| 协议 | Anthropic Messages（`POST /v1/messages`） |

CLI 将 Base URL 与 `/v1/messages` 拼接（[LLM gateway](https://code.claude.com/docs/en/llm-gateway)）。勿填 `https://taas.hk/v1`，否则路径重复。

### 配置

```bash
export ANTHROPIC_BASE_URL=https://taas.hk
export ANTHROPIC_API_KEY=sk-your-token
claude --bare -p --model gpt-5.5
```

或 `~/.claude/settings.json`（[Settings](https://code.claude.com/docs/en/settings)）：

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://taas.hk",
    "ANTHROPIC_API_KEY": "sk-your-token"
  }
}
```

**模型选择**：id 须与 taas.hk catalog 一致。`CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1` 可从网关拉取模型列表，但仅收录 `claude` / `anthropic` 前缀；**GPT 模型须用 `--model` 显式指定**（如 `gpt-5.5`）。

### 验证

```bash
curl -X POST https://taas.hk/v1/messages \
  -H "x-api-key: sk-your-token" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","max_tokens":64,"messages":[{"role":"user","content":"hello"}]}'
```

### CC Switch（可选）

Claude 槽位 Base URL 填 `https://taas.hk`（不带 `/v1`），启用后运行 `claude --bare -p --model gpt-5.5`。见 [cc-switch.md](./cc-switch.md)。

---

## 3. taas.hk 网关接入 · Desktop

Desktop 接网关须先切 **Cowork on 3P**（[概述](https://claude.com/docs/cowork/3p/overview)）：

1. Help → Troubleshooting → **Enable Developer Mode**
2. Developer → **Configure third-party inference** → Connection 选 **Gateway**
3. 填写 Gateway Base URL `https://taas.hk` 与 API Key，**Apply locally**，重启应用

模型菜单仅展示 **Sonnet / Opus / Haiku** 角色名。若网关实际模型为 `gpt-5.5` 等 GPT id，菜单选项与上游模型不一致，需额外的**模型映射**与**本地路由**才能完成请求转发。

上述映射配置不在 Claude Desktop 内完成，见 [CC Switch 使用指南 · Claude Desktop](./cc-switch.md#claude-desktop)。

---

## 常见问题

**CLI 与 Desktop 配置互通吗？**  
不互通，需分别配置。

---

## 相关文档

[接入指南总览](../README.md)
