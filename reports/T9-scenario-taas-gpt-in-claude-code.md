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

设置：

```bash
export ANTHROPIC_BASE_URL=https://taas.hk
export ANTHROPIC_API_KEY=sk-xxx
```

命令：

```bash
claude --bare -p --model gpt-5.5 "只回复 OK"
```

结果：

```text
ok
```

### 3. Claude Code CLI 通过 CC Switch 配置

通过 CC Switch 配置 Claude Code CLI：

```text
Base URL: https://taas.hk
API Key: sk-xxx
模型映射：Sonnet -> gpt-5.5
```

结果：

- Claude Code CLI 可通过 CC Switch 配置正常使用。

### 4. Claude Desktop 通过 CC Switch 模型映射

通过 CC Switch 配置 Claude Desktop：

```text
Base URL: https://taas.hk
API Key: sk-xxx
模型映射：Sonnet -> gpt-5.5
```

结果：

- Claude Desktop 模型映射可用。
- 本地路由模式可用。
- 所有 Claude Desktop 相关测试通过。

## 最终结论

T9 场景测试通过。`taas.hk GPT -> Claude Code` 场景整体可用，包括 Claude Code CLI 裸配置、Claude Code CLI + CC Switch、Claude Desktop + CC Switch 模型映射。

