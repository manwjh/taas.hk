# 场景三 · CC Switch 配置 Claude Desktop 接入 taas.hk

**目标**：在 Claude Desktop 中使用 taas.hk 提供的 **GPT 模型**（如 `gpt-5.5`）。Desktop 界面固定显示 Sonnet / Opus / Haiku 角色名，须通过 CC Switch **模型映射** 将角色指向实际 upstream 模型。

**前置**：已完成 [令牌创建与验证](./README.md#典型用户场景)；已安装 CC Switch 与 Claude Desktop。

**延伸阅读**：[claude-code.md §3 Desktop](./claude-code.md#3-taashk-网关接入--desktop) · [cc-switch.md · Claude Desktop](./cc-switch.md#claude-desktop)

---

## 两种 Desktop 接入方式

| 方式 | 适用模型 | 是否需要 CC Switch |
|------|----------|-------------------|
| **3P Gateway 直连** | Claude 模型（如 `claude-sonnet-4.6`） | 可选（CC Switch 只写 profile） |
| **3P + 模型映射** | GPT 等非 Claude id（如 `gpt-5.5`） | **必须**（本场景） |

本场景覆盖第二种：Desktop 选 **Sonnet**，实际请求 `gpt-5.5`。

映射模式下，请求经 CC Switch 本地路由 `127.0.0.1:15721` 转发（[路由说明](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/en/4-proxy/4.2-routing.md)）。

---

## 连接参数

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk`（根域，**不带** `/v1`） |
| API Key | `sk-...` |
| Auth scheme | **x-api-key** |
| 需要模型映射 | **开启** |

| 模型角色（Desktop 显示） | 实际请求模型 |
|--------------------------|--------------|
| Sonnet | `gpt-5.5` |

可按令牌权限调整映射表（Opus / Haiku 同理）。

---

## 步骤一 · Claude Desktop 切换到 3P

Claude Desktop 默认 **1P**（First Party）：登录 Anthropic 账号，界面会出现 **Upgrade to Claude Pro** 等订阅提示。接 taas.hk 须切 **3P**（Third Party）。

1. **完全退出** Claude Desktop（macOS `Cmd+Q`；Windows 托盘 Exit）。
2. 重新打开，**停在登录页**，先 **不要** Sign in Anthropic 账号。
3. **Help → Troubleshooting → Enable Developer Mode**（首次；已开启则菜单栏有 **Developer**）。
4. **Developer → Configure third-party inference**。
5. **Connection** 区填写：

| 字段 | 值 |
|------|-----|
| Inference provider | **Gateway** |
| Gateway base URL | `https://taas.hk` |
| Gateway API key | 你的 `sk-...` |
| Gateway auth scheme | **x-api-key** |
| Model discovery | 建议开启 |

6. 点击 **Apply locally**，应用会写入 3P profile 并重启。

> 📷 **插图** `images/scenario-03/01-developer-configure.png`  
> 说明：Developer → Configure third-party inference，Gateway base URL 填 `https://taas.hk`。

7. 重启后若回到官方登录页：**不要** Sign in → 选 **Cowork on 3P** / **Start with third-party inference**。

> 📷 **插图** `images/scenario-03/02-cowork-3p.png`  
> 说明：登录页选择 **Cowork on 3P**，而非 Sign in Anthropic。

**确认已在 3P**：

| 检查项 | 3P 正常 | 仍在 1P |
|--------|---------|---------|
| 左下角 | 无 Anthropic Free/Pro 标识 | 如 `用户名 · Free` |
| 模型菜单 | 无 **Upgrade to Claude Pro** | 有 Pro 升级按钮 |

配置落盘：`~/Library/Application Support/Claude-3p/configLibrary/`（macOS）。

> 仅使用 Claude 模型、不需要 GPT 映射时，到此即可直连网关。详见 [claude-code.md §3](./claude-code.md#3-taashk-网关接入--desktop)。

---

## 步骤二 · CC Switch 添加 Claude Desktop 供应商

| 步骤 | 操作 |
|------|------|
| 1 | CC Switch → **Claude Desktop** 面板（与 CLI 的 Claude 槽位**分开**） |
| 2 | 点击 **+** → **Custom** |
| 3 | Base URL `https://taas.hk`，API Key 填令牌 |
| 4 | 开启 **需要模型映射** |
| 5 | 映射表：Sonnet → `gpt-5.5`（按令牌权限调整） |
| 6 | 保存供应商 |

> 📷 **插图** `images/scenario-03/03-desktop-provider-form.png`  
> 说明：Claude Desktop 槽位，开启模型映射，Sonnet 映射到 `gpt-5.5`。

---

## 步骤三 · 开启本地路由

模型映射模式须保持 CC Switch 本地路由运行：

| 步骤 | 操作 |
|------|------|
| 1 | CC Switch **设置** → **路由** → 开启 **显示本地路由开关** |
| 2 | 回到 **Claude Desktop** 面板 → 开启 **本地路由** |
| 3 | 在 Claude Desktop 供应商卡片上点击 **启用** |

> 📷 **插图** `images/scenario-03/04-local-proxy.png`  
> 说明：Claude Desktop 面板中「本地路由」已开启，供应商已启用。

> CC Switch 须保持运行；关闭后 Desktop GPT 映射会失败。

---

## 步骤四 · 重启 Claude Desktop 并测试

1. **完全退出** Claude Desktop（`Cmd+Q`）。
2. 确认 CC Switch 在运行且 taas.hk 供应商 + 本地路由已启用。
3. 以 **Cowork on 3P** 启动 Desktop（不要 Sign in Anthropic）。
4. 打开 **Code** 或 **Cowork** 标签，模型选 **Sonnet**，发送 `ping`。

> 📷 **插图** `images/scenario-03/05-desktop-chat.png`  
> 说明：Desktop 中选 Sonnet，对话正常回复（实际 upstream 为 `gpt-5.5`）。

可选验证（macOS 日志）：

```bash
grep -i "apiHost\|gateway" ~/Library/Logs/Claude/main.log | tail -5
```

应出现 `inference apiHost=https://taas.hk` 或经 `127.0.0.1:15721` 转发类日志。

---

## 步骤五 · 验证网关（可选）

```bash
curl -X POST https://taas.hk/v1/messages \
  -H "x-api-key: sk-your-token" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","max_tokens":32,"messages":[{"role":"user","content":"ping"}]}'
```

或使用：

```bash
export TAAS_API_KEY=sk-your-token
./scripts/messages.sh ping
```

---

## 常见问题

| 现象 | 处理 |
|------|------|
| 仍显示 **Upgrade to Claude Pro** | 仍在 1P：Sign out → 完全退出 → 登录页选 **Cowork on 3P** |
| Configure 报 Couldn't load configuration | profile id 须为 UUID；在 UI 中 **Apply locally** 重建，勿手写非 UUID 文件名 |
| 3P 下 model not found | 确认令牌对 `gpt-5.5` 有权限；plus 令牌通常需换 Claude id 或 pro 令牌 |
| 映射模式无响应 | 确认 CC Switch **本地路由** 已开且 CC Switch 保持运行 |
| CLI 与 Desktop 配置互通吗？ | **不互通**；CLI 用 `~/.claude/settings.json`，Desktop 用 `Claude-3p/configLibrary/` |

**直连 vs 映射**

| | 直连（Claude 模型） | 映射（GPT 模型） |
|--|---------------------|------------------|
| CC Switch 本地路由 | 不需要 | **必须开启** |
| Desktop 模型菜单 | Sonnet 等 → 网关 Claude id | Sonnet 等 → 映射后的 GPT id |

---

## 相关场景

- Codex 接入 taas.hk → [场景一](./scenario-01-codex-direct.md) / [场景二](./scenario-02-cc-switch-codex.md)
- Claude Code CLI → [claude-code.md §2](./claude-code.md#2-taashk-网关接入--cli)

[返回场景索引](./README.md) · [cc-switch.md](./cc-switch.md)
