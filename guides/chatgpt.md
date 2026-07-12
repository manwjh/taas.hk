# ChatGPT App 使用指南（taas.hk 网关）

OpenAI 已将原 **Codex Desktop** 并入 **ChatGPT App**：桌面上只有 `ChatGPT.app`，不再有独立的 `Codex.app`。Agent 编码能力（原 Codex）在 ChatGPT App 内使用。

本文说明 **ChatGPT App** 经 [taas.hk](https://taas.hk) 网关调用 GPT 模型的完整流程。CLI / IDE 扩展仍共用同一配置目录，见 [codex.md](./codex.md)。

**前置**：已在 taas.hk 创建令牌，见 [README · 创建令牌](../README.md#创建令牌)。

---

## 1. 升级后的环境说明

### 应用与目录

| 项目 | 升级前（独立 Codex） | 升级后（ChatGPT App） |
|------|----------------------|------------------------|
| macOS 应用 | `Codex.app` | **`ChatGPT.app`**（内部仍标识为 Codex） |
| 官方文档 | developers.openai.com/codex | [learn.chatgpt.com](https://learn.chatgpt.com/docs/auth) |
| 用户配置 | `~/.codex/config.toml` | **仍是** `~/.codex/config.toml` |
| 应用数据（macOS） | `~/Library/Application Support/Codex/` | **仍是** `Codex/` 目录名 |
| 凭证缓存 | `~/.codex/auth.json` 或系统钥匙串 | 默认 **macOS 钥匙串**「Codex Safe Storage」 |

> **易混淆点**：界面品牌是 ChatGPT，但配置根目录仍叫 `CODEX_HOME`（默认 `~/.codex`）。**没有** `~/.chatgpt/` 配置目录。

### 两种登录方式

ChatGPT App 支持两种全局登录（[Authentication](https://learn.chatgpt.com/docs/auth)）：

| 方式 | 登录入口 | 模型请求认证 | 适用 |
|------|----------|--------------|------|
| **ChatGPT 订阅** | Continue to sign in | ChatGPT OAuth token | 走 OpenAI 官方，用订阅额度 |
| **API key** | **Sign in another way** | 你填入的 `sk-...` | 接 taas.hk 等第三方网关 |

接 taas.hk 时，须让**模型请求**携带 taas.hk 令牌，而不是 ChatGPT 订阅 token。

### 与 Claude Desktop 3P 的区别

ChatGPT App **没有** Claude Desktop 的「Developer → Configure third-party inference」图形界面。接第三方网关靠 **`config.toml` + 登录方式**（或 `env_key` 环境变量），不是 Gateway 表单。

| | ChatGPT App | Claude Desktop 3P |
|--|-------------|-------------------|
| 配置入口 | 编辑 `~/.codex/config.toml` | Developer → Configure third-party inference |
| taas.hk Base URL | `https://taas.hk/v1`（**带** `/v1`） | `https://taas.hk`（**不带** `/v1`） |
| 协议 | Responses API | Anthropic Messages |
| 令牌录入 | Sign in another way，或 `env_key` | Gateway API key 表单 |

---

## 2. 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | taas.hk 令牌 `sk-...` |
| 模型 | `gpt-5.5`、`gpt-5.4` 等（以 `/v1/models` 为准） |
| 协议 | Responses，`wire_api = "responses"` |

ChatGPT App 使用 [Responses API](https://learn.chatgpt.com/docs/config-file/config-advanced#custom-model-providers)，不是 Chat Completions。taas.hk 原生支持 Responses，**无需** CC Switch 本地路由。

---

## 3. taas.hk 网关接入 · 完整流程

以下 6 步适用于 **ChatGPT App（macOS / Windows）**。全程直连 taas.hk，不依赖 CC Switch。

### 第 1 步：验证令牌（建议先做）

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

返回模型列表与正常 JSON / 事件流即表示链路可用。若此处已 `401 Invalid token`，请先在 taas.hk 控制台**新建令牌**，再继续后续步骤。

也可使用仓库脚本：

```bash
export TAAS_API_KEY=sk-your-token
./scripts/responses.sh hello
```

---

### 第 2 步：编辑 `config.toml`

配置文件路径：

| 环境 | 路径 |
|------|------|
| macOS | `~/.codex/config.toml` |
| Windows | `%USERPROFILE%\.codex\config.toml` |

#### 增量修改（已有用户必读）

若 `config.toml` **已存在**（内含 `marketplaces.*`、`plugins.*`、`projects.*`、`desktop.*` 等），**只追加或修改**下列字段，**不要**用示例全文覆盖整个文件。覆盖会丢失插件、信任项目、桌面偏好等本机设置。

需要改动的最少字段：

1. 顶部的 `model_provider`、`model`、`model_reasoning_effort`、`disable_response_storage`
2. 新增或修改一个 `[model_providers.<名称>]` 段

#### 方案 A · 纯 taas.hk（推荐大多数用户）

模型请求与 ChatGPT 订阅完全分离：登出 ChatGPT 账号，仅用 taas.hk 令牌登录。

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
| `model_provider` | 须与 `[model_providers.xxx]` 的 `xxx` 一致 |
| `requires_openai_auth = true` | 模型请求使用「Sign in another way」填入的 API key（即 taas.hk 令牌） |
| `disable_response_storage = true` | 不要求上游存储 Responses |

#### 方案 B · 保留 ChatGPT 登录 + 模型走 taas.hk

需要同时使用 ChatGPT 订阅功能（插件、市场等）且模型请求走 taas.hk 时用此方案。**不要**设置 `requires_openai_auth = true`（否则模型请求会误用 ChatGPT OAuth token）。

```toml
model_provider = "taas"
model = "gpt-5.5"
model_reasoning_effort = "high"
disable_response_storage = true

[model_providers.taas]
name = "taas.hk"
base_url = "https://taas.hk/v1"
wire_api = "responses"
env_key = "TAAS_API_KEY"
```

然后设置环境变量，使 **ChatGPT App 进程**能读到（仅写在 shell 配置文件对 GUI 应用无效）：

**macOS**

```bash
# 写入 launchd，GUI 应用启动时可继承
launchctl setenv TAAS_API_KEY sk-your-token
```

**Windows（PowerShell，当前用户）**

```powershell
[System.Environment]::SetEnvironmentVariable("TAAS_API_KEY", "sk-your-token", "User")
```

设置后须**完全退出** ChatGPT App 再打开。长期有效可写入 macOS 的 `~/.zprofile` 并在登录时执行 `launchctl setenv`，或使用 Windows 用户环境变量面板。

#### 方案 C · 仅改内置 OpenAI 地址（最简）

若不需要自定义 `model_provider` 名称，可只重定向内置 OpenAI 提供商：

```toml
openai_base_url = "https://taas.hk/v1"
model = "gpt-5.5"
disable_response_storage = true
```

须配合 **Sign in another way** 填入 taas.hk 令牌；不要用 ChatGPT 订阅登录。

---

### 第 3 步：录入或更新令牌（方案 A / C 必做）

1. 打开 ChatGPT App，右上角 **Profile → Log out**（若已登录 ChatGPT 账号）。
2. **完全退出**应用（macOS `Cmd+Q`；Windows 退出窗口与托盘进程）。
3. 重新打开 ChatGPT App。
4. 在登录页选择 **Sign in another way**（**不要**选 Continue to sign in / Sign in with ChatGPT）。
5. 在 **OpenAI API key** 输入框填入 taas.hk 令牌 `sk-...`（字段名是 OpenAI 约定，实际走 `config.toml` 中的 `base_url`）。

| 按钮 | 适用 |
|------|------|
| **Sign in with ChatGPT** | ChatGPT 订阅，走 OpenAI 官方 |
| **Sign in another way** | API key / taas.hk 网关（**选这个**） |

凭证默认写入 **系统钥匙串**（服务名「Codex Safe Storage」），不一定生成 `~/.codex/auth.json`。

---

### 第 4 步：完全重启 ChatGPT App

改 `config.toml` 或更新令牌后，必须 **完全退出**（`Cmd+Q`）再打开。只关窗口不够。

---

### 第 5 步：在 App 内验证

1. 新建对话，确认模型为 `gpt-5.5`（或你在 `config.toml` 中配置的 id）。
2. 发送 `hello` 测试回复。
3. 若右上角 Profile 显示 API key 状态（方案 A/C），说明未走 ChatGPT 订阅登录。

可选：检查最近会话是否使用你的 provider 键名：

```bash
grep -m1 '"model_provider"' ~/.codex/sessions/*/*/*.jsonl 2>/dev/null | tail -1
```

---

### 第 6 步：令牌轮换（出现 401 时）

`401 Unauthorized: Invalid token` 且 URL 为 `https://taas.hk/v1/responses` 时，通常是**钥匙串中的旧令牌失效**，而非 Base URL 配错。

| 步骤 | 操作 |
|------|------|
| 1 | taas.hk 控制台 → **新建令牌**，复制新 `sk-...` |
| 2 | `curl` 验证新令牌（见第 1 步） |
| 3 | ChatGPT App → **Log out** → `Cmd+Q` 完全退出 |
| 4 | 重新打开 → **Sign in another way** → 填入**新**令牌 |
| 5 | 再次 `Cmd+Q` 重启后发消息测试 |

方案 B 用户还需更新 `launchctl setenv TAAS_API_KEY ...`（或 Windows 用户环境变量）。

---

## 4. taas.hk 网关接入 · CC Switch

[CC Switch](https://github.com/farion1231/cc-switch) 的 **Codex** 槽位仍写入 `~/.codex/config.toml` 与认证信息，适用于 ChatGPT App。操作步骤见 [codex.md §3](./codex.md#3-taashk-网关接入--cc-switch) 与 [scenario-02](./scenario-02-cc-switch-codex.md)。

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | `sk-...` |
| 模型 | `gpt-5.5` |
| Wire API | `responses` |
| 需要本地路由 | **关闭** |

CC Switch 启用后完全退出 ChatGPT App（`Cmd+Q`）再打开。若你已用 ChatGPT 账号登录且出现 401，须在 CC Switch 写入的配置中改用 **方案 B（`env_key`）**，或 Log out 后走 **Sign in another way**。

---

## 5. 常见问题

### `401 Unauthorized: Invalid token`，url: `https://taas.hk/v1/responses`

| 可能原因 | 处理 |
|----------|------|
| 钥匙串中 taas.hk 令牌过期或被轮换 | 新建令牌 → Log out → Sign in another way 重新录入 |
| `curl` 也返回 401 | 令牌本身无效，与 App 无关，在 taas.hk 重建令牌 |
| 已 ChatGPT 登录且配置了 `requires_openai_auth = true` | 模型请求可能携带 ChatGPT OAuth token；改用**方案 B** 或 Log out 后**方案 A** |
| 刚改配置未重启 | `Cmd+Q` 完全退出后再开 |

### `503`，提示 `No available channel for model gpt-5.4-mini`

Agent 子任务或 UI 回退到了当前令牌分组不支持的模型。手动固定为 `gpt-5.5` 或 `gpt-5.4`。

### `504` 超时

先用 Chat 接口验证令牌（[README · 验证](../README.md#验证连通)），再排查 Responses 链路。

### 切换 `model_provider` 后侧边栏历史变少

本地会话按 `model_provider` 分组；可用 `codex resume --all` 查看（CLI 与 App 共用 `~/.codex`）。

### 找不到 `~/.codex/auth.json`

默认凭证在 **系统钥匙串**，属正常现象。更新令牌请通过 App 内 **Log out → Sign in another way**，不要手改不存在的 `auth.json`。

### 升级后还能用独立 Codex App 吗？

不能。请使用 **ChatGPT.app**；本仓库 [Releases](https://github.com/manwjh/taas.hk/releases?q=codex-desktop) 同步的安装包现为 ChatGPT 渠道，配置方法以本文为准。

---

## 6. 检查清单

| 检查项 | 期望值 |
|--------|--------|
| 应用 | `ChatGPT.app`（非已废弃的独立 `Codex.app`） |
| `base_url` | `https://taas.hk/v1`（**带** `/v1`） |
| `wire_api` | `responses` |
| `model_provider` | 与 `[model_providers.xxx]` 的 `xxx` 一致 |
| 纯 taas.hk（方案 A/C） | Sign in another way + `requires_openai_auth = true` 或未用 ChatGPT 登录 |
| ChatGPT 登录 + taas.hk（方案 B） | `env_key = "TAAS_API_KEY"`，**无** `requires_openai_auth` |
| 改配置 / 换令牌后 | `Cmd+Q` 完全退出再开 |
| 令牌验证 | `curl .../v1/models` 与 `curl .../v1/responses` 均正常 |

---

## 相关文档

[codex.md](./codex.md)（CLI / IDE 扩展） · [scenario-01](./scenario-01-codex-direct.md) · [scenario-02](./scenario-02-cc-switch-codex.md) · [cc-switch.md](./cc-switch.md) · [接入指南总览](../README.md)
