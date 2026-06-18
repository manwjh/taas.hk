# 场景一 · Codex 直接配置接入 taas.hk

**目标**：不安装 CC Switch，手动编辑 Codex 配置文件，让 Codex App / CLI / IDE 扩展经 taas.hk 调用 GPT 模型（如 `gpt-5.5`）。

**前置**：已完成 [令牌创建与验证](./README.md#典型用户场景)。

**延伸阅读**：[codex.md §2](./codex.md#2-taashk-网关接入--直接配置)

---

## 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | taas.hk 令牌 `sk-...` |
| 模型 | `gpt-5.5`、`gpt-5.4` 等（以 `/v1/models` 为准） |
| 协议 | Responses，`wire_api = "responses"` |

> Codex 使用 [Responses API](https://developers.openai.com/codex/config-advanced#custom-model-providers)，不是 Chat Completions。taas.hk 原生支持 Responses，**无需** CC Switch 本地路由。

---

## 步骤一 · 验证网关（建议先做）

**macOS（zsh / bash）**

```bash
curl -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models

curl -X POST https://taas.hk/v1/responses \
  -H "Authorization: Bearer sk-your-token" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","input":"hello","store":false}'
```

**Windows（PowerShell）**

```powershell
curl.exe -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models

curl.exe -X POST https://taas.hk/v1/responses `
  -H "Authorization: Bearer sk-your-token" `
  -H "Content-Type: application/json" `
  -d '{"model":"gpt-5.5","input":"hello","store":false}'
```

返回模型列表与正常 JSON 响应即表示 Responses 链路可用。

> 📷 **插图** `images/scenario-01/01-curl-responses.png`  
> 说明：终端中 Responses 接口返回 `"output"` 或 `"status":"completed"` 类字段。

也可使用仓库脚本：

```bash
export TAAS_API_KEY=sk-your-token
./scripts/responses.sh hello
```

---

## 步骤二 · 编辑 Codex 配置文件

配置文件路径：

| 环境 | 路径 |
|------|------|
| macOS | `~/.codex/config.toml` |
| Windows | `%USERPROFILE%\.codex\config.toml` |

### 增量修改（已有 Codex 用户必读）

若 `config.toml` **已存在**（内含 `marketplaces.*`、`plugins.*`、`projects.*`、`desktop.*` 等），**只追加或修改**下列字段，**不要**用示例全文覆盖整个文件。覆盖会丢失插件、信任项目、桌面偏好等本机设置。

需要改动的最少字段：

1. 顶部的 `model_provider`、`model`、`model_reasoning_effort`、`disable_response_storage`
2. 新增一个 `[model_providers.<名称>]` 段

### 最少配置块

`model_provider` 与 `[model_providers.xxx]` 的 **xxx 须一致**；名称可自定（如 `taas` 或 `taas-plus`），不影响连通。

```toml
model_provider = "taas"
model = "gpt-5.5"
model_reasoning_effort = "high"
disable_response_storage = true

[model_providers.taas]
name = "taas.hk"
base_url = "https://taas.hk/v1"
wire_api = "responses"
requires_openai_auth = true
```

| 参数 | 说明 |
|------|------|
| `model_provider` | 当前启用的 provider 键，须与下方 `[model_providers.xxx]` 的 `xxx` 一致 |
| `model_reasoning_effort = "high"` | 使用高推理强度 |
| `disable_response_storage = true` | 不要求上游存储 Responses |
| `requires_openai_auth = true` | 走 OpenAI API key 认证流程，填入 taas.hk 令牌即可 |

> 📷 **插图** `images/scenario-01/02-config-toml.png`  
> 说明：编辑器中打开的 `~/.codex/config.toml`，`base_url` 为 `https://taas.hk/v1`。

> 勿复制 CC Switch 生成的 `approval_policy`、`sandbox_mode` 等本机偏好字段；它们与网关连通无关。

### 本机对照样本（已验证可用）

以下为 macOS 上经 taas.hk 正常推理的 **最少有效片段**（其余 `marketplaces.*`、`plugins.*` 等可保留不动）：

```toml
model_provider = "taas-plus"
model = "gpt-5.5"
model_reasoning_effort = "high"
disable_response_storage = true

[model_providers.taas-plus]
name = "taas_plus"
base_url = "https://taas.hk/v1"
wire_api = "responses"
requires_openai_auth = true
```

对照检查清单：

| 检查项 | 期望 |
|--------|------|
| `base_url` | `https://taas.hk/v1`（**带** `/v1`） |
| `wire_api` | `responses` |
| `model_provider` | 与 `[model_providers.xxx]` 的 `xxx` 一致 |
| `model` | 令牌分组内可用的 id（如 `gpt-5.5`） |
| Codex 会话元数据 | 新会话中 `model_provider` 应为上述键名 |

---

## 步骤三 · 首次登录 Codex

1. **完全退出** 已在运行的 Codex（macOS `Cmd+Q`；Windows 退出窗口与托盘进程）。
2. 重新打开 Codex App（或运行 `codex` CLI）。
3. 若出现登录页，选择 **Sign in another way**（不要选 **Sign in with ChatGPT**）。
4. 在 **OpenAI API key** 输入框填入 taas.hk 令牌 `sk-...`。

| 按钮 | 适用 |
|------|------|
| **Sign in with ChatGPT** | ChatGPT 订阅，走 OpenAI 官方 |
| **Sign in another way** | API key / 自定义网关（**选这个**） |

> 📷 **插图** `images/scenario-01/03-codex-login.png`  
> 说明：Codex 登录页，高亮 **Sign in another way**。

> 📷 **插图** `images/scenario-01/04-enter-api-key.png`  
> 说明：OpenAI API key 输入框，填入 `sk-...` 令牌。

Codex 会把认证信息写入本机缓存（`~/.codex/auth.json`），无需手动创建 `.env`。

登录成功后，`auth.json` 应类似（密钥已脱敏）：

```json
{
  "OPENAI_API_KEY": "sk-your-token",
  "auth_mode": "apikey"
}
```

| 字段 | 说明 |
|------|------|
| `OPENAI_API_KEY` | 与 taas.hk 令牌相同；字段名是 Codex 约定，不代表走 OpenAI 官方 |
| `auth_mode` | 应为 `"apikey"`；若为 ChatGPT 登录缓存，需登出后重走 **Sign in another way** |

> 📷 **插图** `images/scenario-01/04b-auth-json.png`  
> 说明：`~/.codex/auth.json` 中 `auth_mode` 为 `apikey`。

**config.toml 与 auth.json 须同时正确**：只改 `config.toml` 但 auth 仍是 ChatGPT 订阅，或 API key 与 config 中 provider 不一致，都会导致仍走官方或鉴权失败。

---

## 步骤四 · 重启并验证

1. 再次 **完全退出** Codex（`Cmd+Q`）后重新打开。
2. 新建对话，确认模型为 `gpt-5.5`（或你在 `config.toml` 中配置的 id）。
3. 发送 `hello` 测试回复。

> 📷 **插图** `images/scenario-01/05-codex-chat.png`  
> 说明：Codex 主界面，模型显示 `gpt-5.5`，对话正常回复。

若仍走 ChatGPT 订阅：在 Codex 中 **登出**，再用步骤三重新以 API key 登录。

确认走网关的快速检查：

```bash
# 最近会话应显示 model_provider 为你的 taas 键名（如 taas-plus）
grep -m1 '"model_provider"' ~/.codex/sessions/*/*/*.jsonl 2>/dev/null | tail -1
```

---

## 常见问题

| 现象 | 处理 |
|------|------|
| 仍走 ChatGPT 订阅 / 官方模型 | 登出 → `Cmd+Q` 完全退出 → **Sign in another way** → 确认 `auth.json` 中 `auth_mode` 为 `apikey` |
| 503，`No available channel for model gpt-5.4-mini` | Codex 子任务或 UI 可能回退到 mini；`/v1/models` 列出 id 不代表当前分组有通道。手动固定为 `gpt-5.5` 或 `gpt-5.4` |
| 504 超时 | 先用 Chat 接口验证令牌（[README · 验证](../README.md#验证连通)） |
| 侧边栏历史变少 | 切换 `model_provider` 会分组历史；可用 `codex resume --all` 查看 |
| 覆盖整个 `config.toml` 后插件/项目信任丢失 | 恢复备份，仅增量追加 `[model_providers.xxx]` 与顶部 4 个字段 |
| `model_provider` 与 `[model_providers.xxx]` 不一致 | Codex 找不到 provider；两处名称必须相同 |

---

## 下一步

- 需在 OpenAI 官方与 taas.hk 间切换 → [场景二 · CC Switch + Codex](./scenario-02-cc-switch-codex.md)
- Claude Desktop 使用 GPT → [场景三 · CC Switch + Claude Desktop](./scenario-03-cc-switch-claude-desktop.md)

[返回场景索引](./README.md) · [codex.md](./codex.md)
