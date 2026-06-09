# T1：taas.hk 基础 API 连通测试报告

## 测试结论

**PASS**。`taas.hk` 基础 API 连通正常：

- `/v1/models` 可正常返回模型列表。
- `/v1/chat/completions` 可使用 `gpt-5.5` 正常返回模型回复。

## 对应源文档

- `README.md`：`四、taas.hk 前置`
- `README.md`：`创建令牌`
- `README.md`：`验证连通`
- `README.md`：`连接参数`

## 测试环境

- 测试完成环境：macOS
- 测试终端：macOS Terminal
- 主机标识：`perfxlab@perfxlabdeMac-mini`
- 测试目录：`wechat`
- API Token：已打码，格式为 `sk-xxx`
- 测试模型：`gpt-5.5`

## 测试步骤与结果

### 1. 获取模型列表

执行命令：

```bash
curl -H "Authorization: Bearer sk-xxx" https://taas.hk/v1/models
```

返回结果摘要：

```json
{
  "object": "list",
  "success": true,
  "data": [
    {
      "id": "deepseek-v4-pro",
      "owned_by": "deepseek",
      "supported_endpoint_types": ["openai", "anthropic"]
    },
    {
      "id": "gpt-5.5",
      "owned_by": "openai",
      "supported_endpoint_types": ["openai", "openai-response"]
    },
    {
      "id": "gpt-5.4",
      "owned_by": "openai",
      "supported_endpoint_types": ["openai", "openai-response"]
    },
    {
      "id": "gpt-5.4-mini",
      "owned_by": "openai",
      "supported_endpoint_types": ["openai", "openai-response"]
    },
    {
      "id": "deepseek-v4-flash",
      "owned_by": "deepseek",
      "supported_endpoint_types": ["openai", "anthropic"]
    }
  ]
}
```

验证结果：

- 接口 `https://taas.hk/v1/models` 可访问。
- token 认证有效。
- 返回模型包含文档中提到的 `gpt-5.5`、`gpt-5.4`、`deepseek-v4-pro`、`deepseek-v4-flash`。

### 2. 调用 Chat Completions

执行命令：

```bash
curl -X POST https://taas.hk/v1/chat/completions \
  -H "Authorization: Bearer sk-xxx" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","messages":[{"role":"user","content":"hello"}]}'
```

返回结果摘要：

```json
{
  "object": "chat.completion",
  "model": "gpt-5.5",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you today?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 22,
    "completion_tokens": 13,
    "total_tokens": 35
  }
}
```

验证结果：

- 接口 `https://taas.hk/v1/chat/completions` 可访问。
- `gpt-5.5` 模型可用于 Chat Completions。
- 返回结构符合 chat completion 形式，包含 `choices`、`message`、`usage`。

## 最终结论

T1 测试通过。根据当前测试结果，README 中关于 taas.hk token、模型列表查询、Chat Completions 连通验证的说明可用，可作为后续 Codex、Claude Code、OpenCode 接入测试的前置条件。
