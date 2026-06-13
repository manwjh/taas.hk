# Claude Code 使用指南

[Claude Code](https://code.claude.com/docs/en/overview) 是 Anthropic **厂商 Agent**。本文说明官方配置与 taas.hk 网关的手动接入步骤。

**前置**：已在 taas.hk 创建令牌，见 [README · 创建令牌](../README.md#创建令牌)。

---

## 1. 官方配置

| 入口 | 说明 |
|------|------|
| **CLI** | `claude` |
| **Desktop** | Claude 桌面应用 **Code** 标签页（macOS / Windows） |

| 计费 | 说明 |
|------|------|
| **订阅** | Pro / Max / Team / Enterprise |
| **API** | [Anthropic Console](https://console.anthropic.com/) API key |

CLI 与 Desktop 首次使用通常以 Anthropic 账号登录。Desktop 默认 **1P** 模式，推理走 Anthropic 官方基础设施，无需改 Base URL。

---

## 2. taas.hk 网关接入 · CLI

### 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk`（根域，**不带** `/v1`） |
| API Key | `ANTHROPIC_API_KEY=sk-...` |
| 协议 | Anthropic Messages（`POST /v1/messages`） |

CLI 将 Base URL 与 `/v1/messages` 拼接（[LLM gateway](https://code.claude.com/docs/en/llm-gateway)）。勿填 `https://taas.hk/v1`，否则路径重复。

### 配置

写入 Claude Code 配置文件。以下命令可在任意目录运行，只需把 `sk-your-token` 替换为 taas.hk 令牌。

**macOS（zsh / bash）**

```bash
mkdir -p ~/.claude
cat > ~/.claude/settings.json <<'EOF'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://taas.hk",
    "ANTHROPIC_API_KEY": "sk-your-token"
  }
}
EOF
```

**Windows（PowerShell）**

从开始菜单打开 **Windows PowerShell** 后运行（不是“命令提示符”cmd）。`USERPROFILE` 不用改，Windows 会自动指向当前用户目录。

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude" | Out-Null
@'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://taas.hk",
    "ANTHROPIC_API_KEY": "sk-your-token"
  }
}
'@ | Set-Content -Path "$env:USERPROFILE\.claude\settings.json" -Encoding UTF8
```

配置文件路径：

| 环境 | 路径 |
|------|------|
| macOS | `~/.claude/settings.json` |
| Windows | `%USERPROFILE%\.claude\settings.json` |

配置后运行：

```bash
claude --bare -p --model gpt-5.5
```

**模型选择**：id 须与 taas.hk catalog 一致。`CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1` 可从网关拉取模型列表，但仅收录 `claude` / `anthropic` 前缀；**GPT 模型须用 `--model` 显式指定**（如 `gpt-5.5`）。

### 验证

**macOS（zsh / bash）**

```bash
curl -X POST https://taas.hk/v1/messages \
  -H "x-api-key: sk-your-token" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","max_tokens":64,"messages":[{"role":"user","content":"hello"}]}'
```

**Windows（PowerShell）**

```powershell
curl.exe -X POST https://taas.hk/v1/messages `
  -H "x-api-key: sk-your-token" `
  -H "anthropic-version: 2023-06-01" `
  -H "Content-Type: application/json" `
  -d '{"model":"gpt-5.5","max_tokens":64,"messages":[{"role":"user","content":"hello"}]}'
```

### CC Switch（可选）

Claude 槽位 Base URL 填 `https://taas.hk`（不带 `/v1`），启用后运行 `claude --bare -p --model gpt-5.5`。见 [cc-switch.md](./cc-switch.md)。

---

## 3. taas.hk 网关接入 · Desktop

Claude Desktop 默认 **1P**（First Party）：登录 Anthropic 账号，推理走官方，界面会出现 **Free plan · Upgrade**、**Upgrade to Claude Pro** 等订阅提示。

接 taas.hk 须切 **3P**（Third Party，[Cowork on 3P](https://claude.com/docs/cowork/3p/overview)）：推理走你配置的 Gateway，**计费与配额由 taas.hk 令牌决定**，不再走 Anthropic 订阅。

| | 1P（默认） | 3P + taas.hk |
|--|-----------|--------------|
| 登录 | Sign in Anthropic 账号 | 登录页选 **Cowork on 3P**，不 Sign in |
| 界面特征 | 显示账号名、Free/Pro 升级提示 | 无 Anthropic 订阅升级条 |
| 配置文件 | `~/Library/Application Support/Claude/` | `~/Library/Application Support/Claude-3p/` |
| 推理去向 | api.anthropic.com | `https://taas.hk` |

**常见误区**：在 Developer 里填好 Gateway 并 Apply locally，但仍 Sign in 官方账号 → 实际仍在 **1P**，模型菜单仍引导 Pro 升级，**网关不会生效**。Configure 只是写入 profile；**启动时必须选 3P**。

### 连接参数

| 项 | 值 |
|----|-----|
| Base URL | `https://taas.hk`（根域，**不带** `/v1`） |
| API Key | taas.hk 令牌 `sk-...` |
| Auth scheme | **x-api-key**（非默认 bearer） |
| 协议 | Anthropic Messages（Desktop 自动拼接 `/v1/messages`） |

### 步骤一 · 验证网关（可选，建议先做）

确认令牌与模型可用后再配 Desktop。Claude 模型示例（plus 令牌常见可用 id）：

```bash
curl -X POST https://taas.hk/v1/messages \
  -H "x-api-key: sk-your-token" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"model":"claude-sonnet-4.6","max_tokens":32,"messages":[{"role":"user","content":"ping"}]}'
```

返回 `"text":"pong"` 或类似内容即连通。可用模型列表：

```bash
curl -H "Authorization: Bearer sk-your-token" https://taas.hk/v1/models
```

### 步骤二 · 写入 Gateway 配置

1. **完全退出** Claude Desktop（macOS `Cmd+Q`；Windows 托盘右键 Exit）。只关窗口不够。
2. 重新打开，**停在登录页**，先 **不要** Sign in。
3. **Help → Troubleshooting → Enable Developer Mode**（首次需开；已开过则菜单栏直接有 **Developer**）。
4. **Developer → Configure third-party inference**。
5. **Connection** 区：

| 字段 | 填什么 |
|------|--------|
| Inference provider | **Gateway** |
| Gateway base URL | `https://taas.hk` |
| Gateway API key | 你的 `sk-...` |
| Gateway auth scheme | **x-api-key** |
| Model discovery | 建议开启（从网关 `/v1/models` 拉取 Claude 模型） |

6. 点 **Apply locally**。应用会写入本地 profile 并重启。

配置落盘位置（一般无需手改）：

| 环境 | 路径 |
|------|------|
| macOS | `~/Library/Application Support/Claude-3p/configLibrary/` |
| Windows | `%LOCALAPPDATA%\Claude-3p\configLibrary\` |

其中 `_meta.json` 记录当前启用的 profile；每个 profile 为 `{uuid}.json`，**id 必须是 36 位 UUID**（见 [排错](#desktop-排错)）。

### 步骤三 · 以 3P 模式启动（必做）

Apply locally 重启后若又回到官方登录页：

1. **不要**点 Sign in / 用你的 Anthropic 账号登录。
2. 选 **Cowork on 3P** / **Start with third-party inference**（文案因版本略有差异）。
3. 进入主界面后，打开 **Code** 或 **Cowork** 标签，选 **Sonnet**（或 Opus / Haiku），发 `ping` 测试。

若当前已登录官方账号（左下角显示 `用户名 · Free`、模型旁有 **Upgrade to Claude Pro**），说明仍在 1P：**Settings → Sign out** → 完全退出 → 重启 → 登录页选 **Cowork on 3P**。

### 步骤四 · 确认已走网关

| 检查项 | 3P + taas.hk 正常 | 仍在 1P |
|--------|-------------------|---------|
| 左下角账号 | 无 Anthropic Free/Pro 标识 | 如 `PaulWang · Free` |
| 顶部 | 无 **Free plan · Upgrade** | 有订阅升级条 |
| 模型菜单 | Sonnet/Opus/Haiku，**无** Pro 升级按钮 | 模型旁 **Upgrade to Claude Pro** |
| 对话 | 正常回复 | 可能提示需 Pro |

仍不确定时，macOS 可查看 `~/Library/Logs/Claude/main.log`，3P 启动后应有 `inference apiHost=https://taas.hk` 或 `provider: 'gateway'` 类日志。

### 模型说明

Desktop 模型菜单**固定**显示 **Sonnet / Opus / Haiku** 角色名，不会直接显示 `gpt-5.5` 或完整 upstream id。

| 网关上的模型 | Desktop 用法 |
|-------------|-------------|
| `claude-sonnet-4.6` 等 Claude id | 开启 model discovery 后，选 **Sonnet** 等角色即可直连 |
| `gpt-5.5` 等非 Claude id | Desktop 内无法映射；须 [CC Switch · Claude Desktop](./cc-switch.md#claude-desktop) 做模型映射 |

**GPT 走网关不在本节范围**；本节仅覆盖 Desktop 原生 Gateway 直连 Claude 模型。

### Desktop 排错

**Configure Third-Party Inference 显示 Couldn't load configuration**

日志（macOS：`~/Library/Logs/Claude/main.log`）常见 `readConfig failed unknown config id`。原因：`configLibrary/_meta.json` 里 profile **id 不是 UUID**（须 36 位，如 `589df5a7-1e0d-435d-b2ff-7c82383a02ac`），或 `appliedId` 无对应 `{uuid}.json`。修复：在 UI 中 **Apply locally** 重建；勿用手写 `taas-hk.json` 这类非 UUID 文件名。

**找不到 Enable Developer Mode**

须在**登录页、未 Sign in** 时：**Help → Troubleshooting → Enable Developer Mode**。已登录 1P 时先 Sign out。开启后，已登录时也可从 **Developer** 菜单进入 Configure。

**已 Configure 但仍像官方界面**

几乎总是未以 **Cowork on 3P** 启动。Sign out → `Cmd+Q` 完全退出 → 重启 → 登录页选 3P，不要 Sign in Anthropic。

**3P 下对话报错 / model not found**

确认 taas.hk 令牌对该 model id 有权限（步骤一 curl 同模型测试）。plus 令牌通常无 `gpt-5.5`，需 pro 令牌或换 Claude 模型 id。

---

## 常见问题

**CLI 与 Desktop 配置互通吗？**  
不互通。CLI 用 `~/.claude/settings.json`；Desktop 3P 用 `Claude-3p/configLibrary/`。两处需分别配置。

**Configure 之后还要 Sign out 吗？**  
要。Configure 只保存 Gateway profile；**每次要以 3P 启动**才走 taas.hk。已 Sign in 官方账号时需 Sign out，重启后在登录页选 Cowork on 3P。

**模型菜单为什么还像官方的？**  
Desktop UI 固定显示 Sonnet/Opus/Haiku 角色名。若在 3P 下，请求实际发往 taas.hk；若见 **Upgrade to Claude Pro**，说明仍在 1P。

---

## 相关文档

[接入指南总览](../README.md)
