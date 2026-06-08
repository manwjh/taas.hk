# Codex 使用指南

本文说明如何将 **taas.hk** 令牌配置到 [Codex](https://openai.com/codex)。

---

## 前置条件

1. 已在 [taas.hk](https://taas.hk) 创建令牌（pro 或 plus），详见 [README](../README.md#二如何创建令牌)
2. 已安装 Codex Desktop 或 Codex CLI

可选：[CC Switch 使用指南](./cc-switch.md)。

---

## 连接参数

| 配置项 | 值 |
|--------|-----|
| API 地址 | `https://taas.hk/v1` |
| API Key | 你的 `sk-...` 令牌 |
| 推荐模型 | `gpt-5.5`、`gpt-5.4` |
| 协议 | `responses`（Codex 原生协议） |

> Codex 使用 OpenAI **Responses API**（`POST /v1/responses`），不是 Chat Completions。配置时须指定 `wire_api = "responses"`。

---

## 配置 Codex

编辑 Codex 配置文件（通常位于 `~/.codex/config.toml`）：

```toml
model_provider = "taas"
model = "gpt-5.5"
model_reasoning_effort = "medium"
disable_response_storage = true

[model_providers.taas]
name = "taas.hk"
base_url = "https://taas.hk/v1"
wire_api = "responses"
requires_openai_auth = true
```

设置环境变量：

```bash
export OPENAI_API_KEY=sk-your-token
```

修改配置后，**完全退出 Codex**（macOS：`Cmd+Q`），再重新打开。

---

## 验证配置

### 检查模型列表

```bash
curl -H "Authorization: Bearer sk-your-token" \
  https://taas.hk/v1/models
```

应返回包含 `gpt-5.5`、`gpt-5.4` 等模型的列表。

### 在 Codex 中测试

启动 Codex 后发起一次简单编程任务，确认能正常收到流式响应。

---

## 使用须知

### 切换 model_provider 后，侧边栏历史变少了？

Codex 本地会话按 **`model_provider`** 分组显示。修改 `config.toml` 中的 `model_provider` 后，旧会话可能不再出现在侧边栏；会话文件通常仍在 `~/.codex/sessions/`。

```bash
codex resume --all
```

---

## 故障排查

### 配置未生效

症状：改了 API 地址或令牌，Codex 仍走旧配置。

处理：完全退出 Codex（`Cmd+Q`）后重启；检查 `~/.codex/config.toml` 与 `~/.codex/auth.json` 是否已更新。

### 连接超时（504）

症状：Codex 请求长时间无响应，最终返回 HTTP 504。

原因：`/v1/responses` 对上游稳定性要求较高。

处理：先用 Chat 接口验证令牌是否有效（见 [OpenCode 指南](./opencode.md)），确认 taas.hk 连通后再排查 Responses 专用链路。

---

## 相关文档

- [Claude Code 使用指南](./claude-code.md)
- [OpenCode 使用指南](./opencode.md)
- [CC Switch 使用指南](./cc-switch.md)
- [taas.hk 用户指南](../README.md)
