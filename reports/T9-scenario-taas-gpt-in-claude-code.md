# T9：场景 01 taas.hk GPT -> Claude Code 测试报告

## 测试结论

**PASS**。`guides/scenario-01-taas-gpt-in-claude-code.md` 对应的 Claude Code 场景可以由前置测试结果支撑，整体链路可用。

## 对应源文档

- `guides/scenario-01-taas-gpt-in-claude-code.md`
- `guides/claude-code.md`
- `guides/cc-switch.md`
- `README.md`

## 场景覆盖范围

本场景验证的是 `taas.hk GPT -> Claude Code`，覆盖以下使用方式：


| 子项  | 内容                               | 测试结论         | 关联报告                                                                               |
| --- | -------------------------------- | ------------ | ---------------------------------------------------------------------------------- |
| T1  | taas.hk 基础 API 连通                | PASS         | [T1-taas-api-connectivity.md](./T1-taas-api-connectivity.md)                       |
| T4  | Claude Code CLI 裸配置              | PASS，需修正文档命令 | [T4-claude-code-cli-direct-config.md](./T4-claude-code-cli-direct-config.md)       |
| T5  | Claude Code CLI 通过 CC Switch 配置  | PASS         | [T5-claude-code-cc-switch-config.md](./T5-claude-code-cc-switch-config.md)         |
| T6  | Claude Desktop 通过 CC Switch 模型映射 | PASS         | [T6-claude-desktop-cc-switch-mapping.md](./T6-claude-desktop-cc-switch-mapping.md) |


## 场景步骤与结果

### 1. 验证 taas.hk 基础 API

先按 README 验证：

```bash
curl -H "Authorization: Bearer sk-xxx" https://taas.hk/v1/models
```

以及：

```bash
curl -X POST https://taas.hk/v1/chat/completions \
  -H "Authorization: Bearer sk-xxx" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","messages":[{"role":"user","content":"hello"}]}'
```

结果：

- `/v1/models` 可返回模型列表。
- `/v1/chat/completions` 可使用 `gpt-5.5` 返回回复。

### 2. 验证 Claude Code CLI 裸配置

临时配置并执行。

macOS / Linux：

```bash
ANTHROPIC_BASE_URL=https://taas.hk \
ANTHROPIC_API_KEY=sk-xxx \
claude --bare -p --model gpt-5.5 "只回复 OK"
```

Windows CMD：

```bat
set ANTHROPIC_BASE_URL=https://taas.hk && set ANTHROPIC_API_KEY=sk-xxx && claude --bare -p --model gpt-5.5 "只回复 OK"
```

结果：

```text
ok
```

### 3. Claude Code CLI 通过 CC Switch 配置

通过 CC Switch 配置 Claude Code CLI 的供应商：

```text
Base URL: https://taas.hk
API Key: sk-xxx
模型映射：Sonnet -> gpt-5.5
```

继续在 CC Switch 中打开路由：

```text
设置 -> 路由 -> 本地路由
```

操作步骤：

1. 打开路由总开关。
2. 启动 Claude 路由。
3. 保持 CC Switch 和 Claude 路由运行。

### 4. Claude Desktop 通过 CC Switch 模型映射

通过 CC Switch 配置 Claude Desktop：

```text
Base URL: https://taas.hk
API Key: sk-xxx
开启模型映射：Sonnet -> gpt-5.5
```

## 最终结论

T9 场景测试通过。`taas.hk GPT -> Claude Code` 场景整体可用，包括 Claude Code CLI 裸配置、Claude Code CLI + CC Switch、Claude Desktop + CC Switch 模型映射。