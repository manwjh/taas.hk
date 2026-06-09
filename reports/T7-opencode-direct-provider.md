# T7：OpenCode 裸 Provider 配置测试报告

## 测试结论

**PASS**。OpenCode 通过手动配置 Provider 接入 `taas.hk` 后测试通过。

## 对应源文档

- `README.md`：`三、开源 Agent · Provider 配置`
- `guides/opencode.md`：`1. Provider 机制`
- `guides/opencode.md`：`2. taas.hk Provider`
- `guides/opencode.md`：`配置`
- `guides/opencode.md`：`验证`

## 测试环境

- 测试完成环境：macOS（环境 A）
- 测试类型：裸 Provider 配置
- Agent：OpenCode
- 配置方式：手动编辑 `opencode.json`
- API Token：已打码，格式为 `sk-xxx`
- 测试模型：`gpt-5.5`
- 是否使用 CC Switch：否

## 测试步骤与结果

### 1. 配置 OpenCode Provider

按文档配置 `opencode.json`：

```json
{
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

验证结果：

- OpenCode 可识别 `taas` Provider。
- `taas/gpt-5.5` 可用。

### 2. 启动 OpenCode 并发起请求

配置完成后启动 OpenCode，并发起简单请求。

验证结果：

- OpenCode 可正常使用。
- 模型请求可正常返回。

## 最终结论

T7 测试通过。根据当前验收结果，`guides/opencode.md` 中关于手动配置 OpenCode Provider 接入 `taas.hk` 的说明可用。
