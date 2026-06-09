# Agent 大模型 API 接入指南

总览编程 Agent 接入大模型 API 的两条路径，并以 [taas.hk](https://taas.hk) 为网关示例。

---

## Agent 分类

| 类型 | 代表 | 配置特点 |
|------|------|----------|
| **厂商 Agent** | [Codex](https://openai.com/codex)、[Claude Code](https://code.claude.com/docs/en/overview) | 默认走厂商订阅或官方 API；接网关需改端点或切换 Desktop 模式 |
| **开源 Agent** | [OpenCode](https://opencode.ai)、[OpenClaw](https://github.com/openclaw/openclaw) | 通过 Provider 选模型来源；厂商 API 与网关配置方式相同 |

---

## 一、厂商 Agent · 官方配置

安装后登录厂商账号或填写 Console API key，使用官方模型，无需改 Base URL。

| Agent | 入口 | 计费 |
|-------|------|------|
| **Codex** | App / CLI / IDE 扩展 | ChatGPT 订阅，或 [OpenAI Platform](https://platform.openai.com/) API key |
| **Claude Code** | CLI / Desktop | Anthropic 订阅，或 [Console](https://console.anthropic.com/) API key |

共用配置文件：Codex → `~/.codex/config.toml`；Claude CLI → `~/.claude/settings.json`。Desktop 默认 **1P** 模式，推理走 Anthropic 官方基础设施。

详见 [codex.md §1](./guides/codex.md#1-官方配置)、[claude-code.md §1](./guides/claude-code.md#1-官方配置)。

---

## 二、厂商 Agent · 网关接入

将推理指向 API 网关时，需配置 **Base URL**、**API Key**、**模型 id**，并匹配协议。

| Agent | 协议 | 要点 |
|-------|------|------|
| **Codex** | [Responses](https://developers.openai.com/codex/config-advanced#custom-model-providers) | 自定义 `model_provider`，`wire_api = "responses"` |
| **Claude Code（CLI）** | [Messages](https://code.claude.com/docs/en/llm-gateway) | `ANTHROPIC_BASE_URL` 填根域（不带 `/v1`） |
| **Claude Desktop** | Messages | 切 [Cowork on 3P](https://claude.com/docs/cowork/3p/overview)；接 GPT 时需 [CC Switch](./guides/cc-switch.md) 模型映射 |

操作步骤：[codex.md](./guides/codex.md) · [claude-code.md](./guides/claude-code.md) · [scenario-01](./guides/scenario-01-taas-gpt-in-claude-code.md) · [scenario-02](./guides/scenario-02-taas-gpt-in-codex.md)

配置可手改文件，或用 [CC Switch](./guides/cc-switch.md) 管理多套预设（可选）。

---

## 三、开源 Agent · Provider 配置

在 `opencode.json` 或 `openclaw.json` 中添加 Provider，填写 Base URL、API Key、模型即可。OpenAI 官方、Anthropic 官方与 taas.hk 等网关，均为 Provider 的一种来源。

| Agent | 协议 | 配置文件 |
|-------|------|----------|
| **OpenCode** | Chat Completions | `~/.config/opencode/opencode.json` |
| **OpenClaw** | 按 Provider | `~/.openclaw/openclaw.json` |

详见 [opencode.md](./guides/opencode.md)、[CC Switch · OpenClaw](./guides/cc-switch.md#openclaw)。

---

## 四、taas.hk 前置

### 创建令牌

1. 登录 [taas.hk](https://taas.hk) → **令牌 / Token** → **新建令牌**（pro 或 plus）
2. 复制 `sk-...` 密钥（仅显示一次）

### 验证连通

```bash
curl -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models

curl -X POST https://taas.hk/v1/chat/completions \
  -H "Authorization: Bearer sk-your-token" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","messages":[{"role":"user","content":"hello"}]}'
```

### 连接参数

| Agent | API 地址 | 备注 |
|-------|----------|------|
| Codex | `https://taas.hk/v1` | `wire_api = "responses"` |
| Claude Code（CLI） | `https://taas.hk` | 不带 `/v1` |
| Claude Desktop | `https://taas.hk` | 3P + 模型映射 |
| OpenCode | `https://taas.hk/v1` | `@ai-sdk/openai-compatible` |
| OpenClaw | 按 Provider 填写 | 见 CC Switch 槽位 |

常用模型：`gpt-5.5`、`gpt-5.4`、`deepseek-v4-pro`、`deepseek-v4-flash`（以 `/v1/models` 为准）。

---

## 五、指南索引

| 文档 | 内容 |
|------|------|
| [codex.md](./guides/codex.md) | Codex 官方计费与 taas.hk 接入 |
| [claude-code.md](./guides/claude-code.md) | Claude Code CLI / Desktop 接入 |
| [opencode.md](./guides/opencode.md) | OpenCode Provider 配置 |
| [cc-switch.md](./guides/cc-switch.md) | CC Switch 配置管理 |

---

## 注意事项

- 勿将 `sk-` 密钥提交到 Git 或公开分享
- Codex 改配置后需完全退出（`Cmd+Q`）再打开；切换 `model_provider` 会改变侧边栏历史分组
- Claude CLI 与 Desktop 配置不互通
- Claude Desktop 模型映射模式需保持 CC Switch 本地路由运行

---

## 相关链接

- [taas.hk](https://taas.hk) · [CC Switch](https://github.com/farion1231/cc-switch)
