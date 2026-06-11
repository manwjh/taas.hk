# Codex 使用指南

[Codex](https://openai.com/codex) 是 OpenAI **厂商 Agent**。本文说明官方配置，以及经 taas.hk 网关接入的两种方式：**直接改配置文件**，或通过 **[CC Switch](./cc-switch.md)** 图形化管理。

**前置**：已在 taas.hk 创建令牌，见 [README · 创建令牌](../README.md#创建令牌)。

---

## 1. 官方配置

| 入口 | 说明 |
|------|------|
| **Codex app** | macOS / Windows |
| **CLI** | `codex` |
| **IDE 扩展** | VS Code 等 |

三者共用 Codex 配置目录与登录缓存（[Authentication](https://developers.openai.com/codex/auth)）：

| 环境 | 配置目录 | 配置文件 |
|------|----------|----------|
| macOS | `~/.codex` | `~/.codex/config.toml` |
| Windows | `%USERPROFILE%\.codex` | `%USERPROFILE%\.codex\config.toml` |

| 计费 | 说明 |
|------|------|
| **ChatGPT 订阅** | 浏览器登录 ChatGPT |
| **API key** | [OpenAI Platform](https://platform.openai.com/) 按量计费 |

CLI 无有效会话时，默认引导 ChatGPT 登录。此路径下无需改 Base URL。

---

## 2. taas.hk 网关接入 · 直接配置

### 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | `OPENAI_API_KEY=sk-...` |
| 模型 | `gpt-5.5`、`gpt-5.4` 等（以 `/v1/models` 为准） |
| 协议 | Responses，`wire_api = "responses"` |

Codex 使用 [Responses API](https://developers.openai.com/codex/config-advanced#custom-model-providers)，不是 Chat Completions。taas.hk 支持 Responses，**无需** CC Switch 本地路由。

### 配置

编辑配置文件：

| 环境 | 路径 |
|------|------|
| macOS | `~/.codex/config.toml` |
| Windows | `%USERPROFILE%\.codex\config.toml` |

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

参数说明：

| 参数 | 说明 |
|------|------|
| `model_reasoning_effort = "high"` | 使用高推理强度 |
| `disable_response_storage = true` | 不要求上游存储 Responses |
| `requires_openai_auth = true` | 让 Codex 使用 OpenAI API key 认证流程，填入 taas.hk 令牌即可 |

不建议把 CC Switch 生成的 `approval_policy`、`sandbox_mode`、`marketplaces.*`、`desktop.*` 作为通用接入配置复制。它们分别属于本机执行权限、内置市场缓存、桌面端界面偏好，不是 taas.hk 网关连通所需参数。

API Key 在首次打开 Codex 时录入。Codex 会把认证信息写入本机认证缓存，无需手动创建 `.env`。

### 首次打开 Codex

首次打开 Codex app 若出现登录页：

| 按钮 | 适用场景 |
|------|----------|
| **Sign in with ChatGPT** | 使用 ChatGPT 订阅登录，走 OpenAI 官方服务 |
| **Sign in another way** | 使用 API key / 自定义配置，适合 taas.hk 网关 |
| **Sign up** | 注册新账号 |

接 taas.hk 网关时选择 **Sign in another way**。随后出现 **OpenAI API key** 输入框时，填入同一个 taas.hk 令牌 `sk-...`。这里的 “OpenAI API key” 是 Codex 的通用字段名；实际请求地址和模型仍由 `config.toml` 中的 `base_url` 与 `model` 决定。不要使用 **Sign in with ChatGPT**，否则可能继续走 ChatGPT 订阅而不是 taas.hk。

- **生效**：完全退出 Codex（macOS：`Cmd+Q`；Windows：退出窗口与托盘进程）后重新打开。
- **切换来源**：若仍走 ChatGPT 订阅，在 Codex 中登出后再用上述配置启动。

### 验证

**macOS（zsh / bash）**

```bash
# 令牌与模型列表
curl -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models

# Responses 链路（Codex 实际使用的协议）
curl -X POST https://taas.hk/v1/responses \
  -H "Authorization: Bearer sk-your-token" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","input":"hello","store":false}'

# 已安装 CLI 时
codex
```

**Windows（PowerShell）**

```powershell
# 令牌与模型列表
curl.exe -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models

# Responses 链路（Codex 实际使用的协议）
curl.exe -X POST https://taas.hk/v1/responses `
  -H "Authorization: Bearer sk-your-token" `
  -H "Content-Type: application/json" `
  -d '{"model":"gpt-5.5","input":"hello","store":false}'

# 已安装 CLI 时
codex
```

---

## 3. taas.hk 网关接入 · CC Switch

[CC Switch](https://github.com/farion1231/cc-switch) 将供应商预设写入 Codex 配置与认证文件，切换时自动覆盖，适合多套供应商来回切换。

| 环境 | `config.toml` | `auth.json` |
|------|---------------|-------------|
| macOS | `~/.codex/config.toml` | `~/.codex/auth.json` |
| Windows | `%USERPROFILE%\.codex\config.toml` | `%USERPROFILE%\.codex\auth.json` |

### 槽位参数

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | `sk-...` |
| 模型 | `gpt-5.5` |
| Wire API | `responses` |

> taas.hk 令牌连接串中的 URL 常为 `https://taas.hk`（不带 `/v1`）。**Codex 槽位须填 `https://taas.hk/v1`**，与 Claude Code 不同。

### 操作步骤

| 步骤 | 操作 |
|------|------|
| 1 | 打开 CC Switch → 切换到 **Codex** 面板 |
| 2 | 点击 **+** → 选择 **Custom**（taas.hk 不在内置 preset 列表） |
| 3 | 填写上表：Base URL、API Key、模型 `gpt-5.5`，Wire API 选 `responses` |
| 4 | **不要**开启「需要本地路由」（taas.hk 原生支持 Responses，直连即可） |
| 5 | 保存后在供应商卡片上点击 **启用** |
| 6 | 完全退出 Codex（macOS：`Cmd+Q`；Windows：退出窗口与托盘进程）后重新打开 |

CC Switch 启用后会写入上表对应环境路径：

- `auth.json` — `OPENAI_API_KEY`（**不是** `.env`）
- `config.toml` — `model_provider`、`base_url`、`wire_api` 等

切换供应商、托盘快捷切换等通用说明见 [cc-switch.md](./cc-switch.md)。

### 验证

同 [§2 验证](#验证)。

---

## 常见问题

**切换 `model_provider` 后侧边栏历史变少？**  
本地会话按 `model_provider` 分组；可用 `codex resume --all` 查看。

**504 超时？**  
先用 Chat 接口验证令牌（[README · 验证](../README.md#验证连通)），再排查 Responses 链路。

**503，提示 `No available channel for model gpt-5.4-mini`？**  
Agent 回退到了当前令牌分组不支持的模型。在 Codex 中手动切回 `gpt-5.5` 或 `gpt-5.4` 即可。

---

## 相关文档

[cc-switch.md](./cc-switch.md) · [接入指南总览](../README.md)
