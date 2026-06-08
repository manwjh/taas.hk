# OpenCode 使用指南

本文说明如何将 **taas.hk** 令牌配置到 [OpenCode](https://opencode.ai)。

---

## 前置条件

1. 已在 [taas.hk](https://taas.hk) 创建令牌（pro 或 plus），详见 [README](../README.md#二如何创建令牌)
2. 已安装 OpenCode CLI

可选：[CC Switch 使用指南](./cc-switch.md)。

---

## 连接参数

| 配置项 | 值 |
|--------|-----|
| API 地址 | `https://taas.hk/v1` |
| API Key | 你的 `sk-...` 令牌 |
| Provider 包 | `@ai-sdk/openai-compatible` |
| 推荐模型 | `gpt-5.5`、`gpt-5.4` |
| 协议 | Chat Completions（`POST /v1/chat/completions`） |

> OpenCode 通过 AI SDK 的 OpenAI 兼容 Provider 接入，走标准 Chat 接口，配置最简单，也适合用来验证令牌是否有效。

---

## 配置 OpenCode

编辑 OpenCode 配置文件，添加自定义 Provider：

```json
{
  "provider": {
    "type": "npm",
    "package": "@ai-sdk/openai-compatible",
    "name": "taas.hk",
    "options": {
      "baseURL": "https://taas.hk/v1",
      "apiKey": "sk-your-token",
      "setCacheKey": true
    },
    "models": {
      "gpt-5.5": { "name": "gpt-5.5" }
    }
  }
}
```

具体配置文件路径以你安装的 OpenCode 版本为准（通常在 `~/.config/opencode/` 或项目级配置）。

---

## 验证配置

### 检查模型列表

```bash
curl -H "Authorization: Bearer sk-your-token" \
  https://taas.hk/v1/models
```

### Chat 对话测试

```bash
curl -X POST https://taas.hk/v1/chat/completions \
  -H "Authorization: Bearer sk-your-token" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.5",
    "messages": [{"role": "user", "content": "hello"}]
  }'
```

返回正常 JSON 即表示令牌和 Chat 链路可用。

### 在 OpenCode 中测试

启动 OpenCode 后发起一次简单任务，确认流式输出正常。

---

## 常见问题

**OpenCode 和 Codex 用同一个令牌吗？**

可以。两者 API 地址都是 `https://taas.hk/v1`，区别仅在于协议（Chat vs Responses）。

**支持哪些模型？**

以 `GET /v1/models` 返回的 catalog 为准，常用：`gpt-5.5`、`gpt-5.4`、`deepseek-v4-pro`、`deepseek-v4-flash`。

**需要配置代理吗？**

国内网络访问境外 API 时，可在终端设置 `HTTP_PROXY` / `HTTPS_PROXY`，或在 OpenCode 启动环境中配置代理。

---

## 相关文档

- [Codex 使用指南](./codex.md)
- [Claude Code 使用指南](./claude-code.md)
- [CC Switch 使用指南](./cc-switch.md)
- [taas.hk 用户指南](../README.md)
