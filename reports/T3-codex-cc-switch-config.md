# T3：Codex 通过 CC Switch 配置测试报告

## 测试结论

**PASS**。在 Windows 机器上，通过 CC Switch 配置 Codex 接入 `taas.hk` 后，可以正常使用。

## 对应源文档

- `README.md`：`二、厂商 Agent · 网关接入`
- `README.md`：`四、taas.hk 前置 / 连接参数`
- `guides/codex.md`：`CC Switch（可选）`
- `guides/cc-switch.md`：`taas.hk 槽位参数 / Codex`
- `guides/cc-switch.md`：`切换供应商`

## 测试环境

- 测试完成环境：Windows
- 测试类型：CC Switch 配置
- Agent：Codex
- 配置工具：CC Switch
- API Token：已打码，格式为 `sk-xxx`
- 测试模型：`gpt-5.5`
- 是否使用 CC Switch：是

## 测试前置

T1 已验证通过：

- `https://taas.hk/v1/models` 可访问。
- `gpt-5.5` 存在于模型列表中。
- `gpt-5.5` 支持 `openai-response` endpoint 类型。

T2 已验证通过：

- Codex 裸改配置可正常接入 `taas.hk`。
- `base_url = "https://taas.hk/v1"` 可用。
- `wire_api = "responses"` 可用。

## 测试步骤与结果

### 1. 在 CC Switch 中配置 Codex 槽位

按 `guides/codex.md` 和 `guides/cc-switch.md` 配置 Codex：

```text
Base URL: https://taas.hk/v1
API Key: sk-xxx
Model: gpt-5.5
Wire API: responses
```

验证结果：

- CC Switch 可创建/切换 Codex 的 taas.hk 配置。
- 配置参数与源文档一致。

### 2. 应用配置并启动 Codex

应用 CC Switch 配置后，按文档要求完全退出并重新打开 Codex。

验证结果：

- Codex 可正常启动。
- Codex 可使用 CC Switch 写入/切换后的 taas.hk 配置。

### 3. 发起 Codex 请求

在 Codex 中发起简单请求，验证模型调用是否可用。

验证结果：

- Codex 可以正常使用。
- 通过 CC Switch 配置的 `gpt-5.5` 可正常返回结果。

## 最终结论

T3 测试通过。根据当前测试结果，Windows 机器上使用 CC Switch 配置 Codex 接入 `taas.hk` 的流程可用；`guides/codex.md` 和 `guides/cc-switch.md` 中关于 Codex 槽位的说明可作为有效配置步骤。
