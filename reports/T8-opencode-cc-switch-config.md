# T8：OpenCode 通过 CC Switch 配置测试报告

## 测试结论

**PASS**。OpenCode 通过 CC Switch 配置 `taas.hk` 后测试通过。

## 对应源文档

- `guides/opencode.md`：`CC Switch（可选）`
- `guides/cc-switch.md`：`taas.hk 槽位参数 / OpenCode`
- `guides/cc-switch.md`：`切换供应商`

## 测试环境

- 测试完成环境：Windows（环境 B）
- 测试类型：CC Switch 配置
- Agent：OpenCode
- 配置工具：CC Switch
- API Token：已打码，格式为 `sk-xxx`
- 测试模型：`gpt-5.5`
- 是否使用 CC Switch：是

## 测试步骤与结果

### 1. 配置 OpenCode 槽位

按文档在 CC Switch 中配置 OpenCode：

```text
Base URL: https://taas.hk/v1
API Key: sk-xxx
Provider 包: @ai-sdk/openai-compatible
Model: gpt-5.5
```

验证结果：

- CC Switch 可创建/切换 OpenCode 的 taas.hk 配置。
- 配置参数与源文档一致。

### 2. 重启 OpenCode 并发起请求

应用 CC Switch 配置后重启 OpenCode，并发起简单请求。

验证结果：

- OpenCode 可正常使用。
- 模型请求可正常返回。

## 最终结论

T8 测试通过。根据当前验收结果，`guides/opencode.md` 和 `guides/cc-switch.md` 中关于 OpenCode 通过 CC Switch 接入 `taas.hk` 的说明可用。
