# Claude Code 使用指南

[Claude Code](https://code.claude.com/docs/en/overview) 是 Anthropic **厂商 Agent**。本文对应 [README §一、§二](../README.md)：官方计费说明，以及经 taas.hk 网关接入 CLI 与 Desktop 的步骤。

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
claude --model gpt-5.5
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

Claude 槽位 Base URL 填 `https://taas.hk`（不带 `/v1`），启用后运行 `claude --model gpt-5.5`。见 [cc-switch.md](./cc-switch.md)。

---

## 3. taas.hk 网关接入 · Desktop

Desktop 接网关须先切 **Cowork on 3P**（[概述](https://claude.com/docs/cowork/3p/overview)）：

1. Help → Troubleshooting → **Enable Developer Mode**
2. Developer → **Configure third-party inference** → Connection 选 **Gateway**

模型菜单仅展示 **Sonnet / Opus / Haiku** 角色名。接 `gpt-5.5` 等 GPT 模型时，须用 **CC Switch** 做角色映射并开启**本地路由**（[Claude Desktop 说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/zh/2-providers/2.6-claude-desktop.md)）。

| 步骤 | 操作 |
|------|------|
| 1 | CC Switch → **Claude Desktop** 面板（与 CLI 的 Claude 槽位分开） |
| 2 | 添加 taas.hk：Base URL `https://taas.hk`，API Key 你的令牌 |
| 3 | 开启**需要模型映射**，例如下表 |
| 4 | 设置 → 路由 → 显示本地路由开关；Desktop 面板开启**本地路由** |
| 5 | 完全退出并重启 Claude Desktop；映射模式须保持 CC Switch 运行 |

| 模型角色 | 实际请求模型 |
|----------|--------------|
| Sonnet | `gpt-5.5` |

映射模式下请求经 CC Switch 本地网关 `127.0.0.1:15721` 转发。CC Switch 会写入 Desktop 的 3P profile。

---

## 常见问题

**CLI 与 Desktop 配置互通吗？**  
不互通，需分别配置。

**Desktop 能否不用 CC Switch？**  
3P Gateway 可手填 Base URL 与 API Key；但若菜单模型 id 与网关不一致（如 GPT），仍需模型映射能力，目前通过 CC Switch 实现。

---

## 相关文档

[cc-switch.md](./cc-switch.md) · [接入指南总览](../README.md)
