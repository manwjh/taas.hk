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

详见 [codex.md §1](./guides/codex.md#1-官方配置)、[claude-code.md §1](./guides/claude-code.md#1-官方配置)。

---

## 二、厂商 Agent · 网关接入（手动配置）

将推理指向 API 网关时，需配置 **Base URL**、**API Key**、**模型 id**，并匹配协议。

| Agent | 协议 | 要点 |
|-------|------|------|
| **Codex** | [Responses](https://developers.openai.com/codex/config-advanced#custom-model-providers) | `model_provider` + `wire_api = "responses"` |
| **Claude Code（CLI）** | [Messages](https://code.claude.com/docs/en/llm-gateway) | `ANTHROPIC_BASE_URL` 根域，不带 `/v1` |
| **Claude Desktop** | Messages | [Cowork on 3P](https://claude.com/docs/cowork/3p/overview) + Gateway |

操作步骤：[guides 典型场景](./guides/README.md) · [codex.md §2 直接配置 / §3 CC Switch](./guides/codex.md#2-taashk-网关接入--直接配置) · [claude-code.md](./guides/claude-code.md)

---

## 三、开源 Agent · Provider 配置（手动配置）

在 `opencode.json` 或 `openclaw.json` 中添加 Provider，填写 Base URL、API Key、模型即可。

| Agent | 协议 | 配置文件 |
|-------|------|----------|
| **OpenCode** | Chat Completions | `~/.config/opencode/opencode.json` |
| **OpenClaw** | 按 Provider | `~/.openclaw/openclaw.json` |

详见 [opencode.md](./guides/opencode.md)。

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
| Claude Desktop | `https://taas.hk` | 3P；GPT 模型另需 CC Switch 映射 |
| OpenCode | `https://taas.hk/v1` | `@ai-sdk/openai-compatible` |
| OpenClaw | 按 Provider 填写 | 见 CC Switch 槽位 |

常用模型：`gpt-5.5`、`gpt-5.4`、`deepseek-v4-pro`、`deepseek-v4-flash`（以 `/v1/models` 为准）。

---

## 五、CC Switch 配置管理

[CC Switch](https://github.com/farion1231/cc-switch) 是可选的图形化配置工具：保存多套供应商预设，切换时写入各 Agent 配置文件，**不替代**上文的手动配置路径。

| 适用场景 | 说明 |
|----------|------|
| 多供应商切换 | 在 Codex / Claude / OpenCode / OpenClaw 槽位间一键切换 |
| Claude Desktop + GPT | 模型角色映射与本地路由（手动配置无法覆盖） |

各 Agent 槽位参数、切换步骤与常见问题，统一见 **[cc-switch.md](./guides/cc-switch.md)**。

---

## 六、指南索引

### 典型用户场景（step by step）

| 场景 | 文档 |
|------|------|
| Codex 直接配置接入 taas.hk | [scenario-01-codex-direct.md](./guides/scenario-01-codex-direct.md) |
| CC Switch 配置 Codex 接入 taas.hk | [scenario-02-cc-switch-codex.md](./guides/scenario-02-cc-switch-codex.md) |
| CC Switch 配置 Claude Desktop 接入 taas.hk | [scenario-03-cc-switch-claude-desktop.md](./guides/scenario-03-cc-switch-claude-desktop.md) |

总览：[guides/README.md](./guides/README.md)

### Agent 专篇

| 文档 | 内容 |
|------|------|
| [codex.md](./guides/codex.md) | Codex 直接配置与 CC Switch 配置 |
| [claude-code.md](./guides/claude-code.md) | Claude Code 手动配置 |
| [opencode.md](./guides/opencode.md) | OpenCode 手动配置 |
| [cc-switch.md](./guides/cc-switch.md) | CC Switch 统一配置 |

---

## 注意事项

- taas.hk **不对外部个人开发者开放**；如需开户，请联系管理员 [manwjh@126.com](mailto:manwjh@126.com)。
- 国内网络下，部分第三方 API 站点（含网关域名）可能因未完成 ICP 备案，被运营商 DNS 拦截或解析异常，表现为 `Could not resolve host`、连接超时等。可先将系统或路由器的 DNS 改为公共解析（如 `223.5.5.5`、`119.29.29.29`、`1.1.1.1`、`8.8.8.8`），再用 `nslookup taas.hk` 或 `curl` 验证；若公共 DNS 可解析而默认 DNS 不行，即为 DNS 问题。修改 DNS 后无需改 Agent 配置。
- 勿将 `sk-` 密钥提交到 Git 或公开分享
- Codex 改配置后需完全退出（`Cmd+Q`）再打开；切换 `model_provider` 会改变侧边栏历史分组
- Codex 使用过程中可能出现如下错误：
  ```
  Reconnecting... 1/5
  unexpected status 503 Service Unavailable: No available channel for model gpt-5.4-mini under group plus (distributor) (request id: ...), url: https://taas.hk/v1/responses
  ```
  通常是因为 Agent 回退到了当前服务商不支持的模型（如 `gpt-5.4-mini`）。此时强制切回 `gpt-5.4` 或 `gpt-5.5` 即可恢复。
- Claude CLI 与 Desktop 配置不互通
- Claude Desktop GPT 映射模式须保持 CC Switch 本地路由运行

---

## 相关链接

- [taas.hk](https://taas.hk) · [CC Switch](https://github.com/farion1231/cc-switch)
