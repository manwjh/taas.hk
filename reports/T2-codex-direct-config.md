# T2：Codex 裸改配置测试报告

## 测试结论

**PASS**。Codex 在不依赖 CC Switch 的情况下，通过手动修改配置文件可以正常接入 `taas.hk` 并使用。

## 对应源文档

- `README.md`：`二、厂商 Agent · 网关接入`
- `README.md`：`四、taas.hk 前置 / 连接参数`
- `guides/codex.md`：`2. taas.hk 网关接入`
- `guides/codex.md`：`配置`
- `guides/codex.md`：`验证`

## 测试环境

- 测试完成环境：macOS
- 测试类型：裸改配置
- Agent：Codex
- 配置方式：手动编辑 `~/.codex/config.toml`
- API Token：已打码，格式为 `sk-xxx`
- 测试模型：`gpt-5.5`
- 是否使用 CC Switch：否

## 测试前置

T1 已验证通过：

- `https://taas.hk/v1/models` 可访问。
- `https://taas.hk/v1/chat/completions` 可正常返回。
- `gpt-5.5` 存在于模型列表中。

## 测试步骤与结果

### 1. 手动配置 Codex Provider

按 `guides/codex.md` 编辑 `~/.codex/config.toml`：

```toml
model_provider = "taas"
model = "gpt-5.5"

[model_providers.taas]
name = "taas.hk"
base_url = "https://taas.hk/v1"
wire_api = "responses"
env_key = "OPENAI_API_KEY"
```

验证结果：

- Codex 可识别 `taas` 作为自定义 model provider。
- `base_url` 使用 `https://taas.hk/v1`。
- `wire_api` 使用 `responses`。

### 2. 配置 API Key

按文档设置环境变量：

```bash
export OPENAI_API_KEY=sk-xxx
```

如使用 Codex App / IDE，也可按文档写入：

```env
OPENAI_API_KEY=sk-xxx
```

到：

```text
~/.codex/.env
```

验证结果：

- Codex 能读取 API Key。
- 未依赖 CC Switch 写入配置。

### 3. 启动 Codex 并发起测试请求

启动 Codex 后，使用 `gpt-5.5` 发起简单请求。

验证结果：

- Codex 可正常使用。
- 模型请求可正常返回。
- 裸改配置路径可行。

## 最终结论

T2 测试通过。根据当前测试结果，`guides/codex.md` 中关于手动修改 `~/.codex/config.toml` 接入 `taas.hk` 的说明可用；Codex 不依赖 CC Switch 也可以通过裸配置正常使用。
