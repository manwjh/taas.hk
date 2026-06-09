# T10：场景 02 taas.hk GPT -> Codex 测试报告

## 测试结论

**PASS**。`guides/scenario-02-taas-gpt-in-codex.md` 对应的 Codex 场景可以由前置测试结果支撑，整体链路可用。

## 对应源文档

- `guides/scenario-02-taas-gpt-in-codex.md`
- `guides/codex.md`
- `guides/cc-switch.md`
- `README.md`

## 场景覆盖范围

本场景验证的是 `taas.hk GPT -> Codex`，覆盖以下使用方式：


| 子项  | 内容                    | 测试结论 | 关联报告                                                           |
| --- | --------------------- | ---- | -------------------------------------------------------------- |
| T1  | taas.hk 基础 API 连通     | PASS | [T1-taas-api-connectivity.md](./T1-taas-api-connectivity.md)   |
| T2  | Codex 裸改配置            | PASS | [T2-codex-direct-config.md](./T2-codex-direct-config.md)       |
| T3  | Codex 通过 CC Switch 配置 | PASS | [T3-codex-cc-switch-config.md](./T3-codex-cc-switch-config.md) |


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

### 2. Codex 裸改配置

手动编辑 `~/.codex/config.toml`：

```toml
model_provider = "taas"
model = "gpt-5.5"

[model_providers.taas]
name = "taas.hk"
base_url = "https://taas.hk/v1"
wire_api = "responses"
env_key = "OPENAI_API_KEY"
```

结果：

- Codex 可识别 `taas` Provider。
- `gpt-5.5` 可正常使用。
- 不依赖 CC Switch 的裸配置方式可用。

### 3. 验证 Codex 通过 CC Switch 配置

通过 CC Switch 配置 Codex：

```text
Base URL: https://taas.hk/v1
API Key: sk-xxx
Model: gpt-5.5
Wire API: responses
```

结果：

- CC Switch 可正确配置 Codex。
- Codex 重启后可正常使用。

## 最终结论

T10 场景测试通过。`taas.hk GPT -> Codex` 场景整体可用，包括 Codex 裸改配置和 Codex + CC Switch 配置两条路径。