# Claude Code 使用指南

[Claude Code](https://code.claude.com/docs/en/overview) 是 Anthropic 的 agentic coding 工具。本文说明其两种入口、官方计费方式，以及如何用 **taas.hk** 接入。

---

## 1. 两种入口与官方计费

### 两种入口

| 入口 | 说明 |
|------|------|
| **Terminal CLI** | 终端运行 `claude` 命令 |
| **Desktop app** | Anthropic 桌面应用，打开 **Code** 标签页 |

两者共用同一套 Claude Code 能力；配置方式不同。

### 官方计费

| 方式 | 说明 |
|------|------|
| **订阅** | Pro / Max / Team / Enterprise，月费制；网页、Desktop、CLI 共享额度 |
| **API** | [Anthropic Console](https://console.anthropic.com/) 创建 API key，按 token 计费 |

首次启动 CLI 或 Desktop 时，通常用 Anthropic 账号登录（订阅路径）。

### Desktop 默认模式与切换

Desktop 默认走 **1P**（first-party）：用 Anthropic 订阅账号登录，推理走 Anthropic 官方基础设施。

要用 taas.hk 等第三方 API，需切换到 **Cowork on 3P**（third-party inference，第三方推理模式）。推理改走你配置的 Gateway / 云厂商端点，会话保存在本机。

Anthropic 官方配置路径（Desktop 内）：

1. Help → Troubleshooting → **Enable Developer Mode**
2. Developer → **Configure third-party inference**
3. Connection 选 **Gateway**，填写 Gateway base URL 与 API key
4. **Apply locally**，重启应用

参考：[Cowork on 3P overview](https://claude.com/docs/cowork/3p/overview) · [Configuration reference](https://claude.com/docs/cowork/3p/configuration)

CLI 接第三方：设置 `ANTHROPIC_BASE_URL` 等环境变量，见下文第 2 节。参考：[Third-party integrations](https://code.claude.com/docs/en/third-party-integrations)

---

## 2. taas.hk 接入 CLI

### 连接参数

| 配置项 | 值 |
|--------|-----|
| API 地址 | `https://taas.hk`（根域，不带 `/v1`） |
| API Key | taas.hk 令牌 `sk-...` |
| 协议 | Anthropic Messages（`POST /v1/messages`） |

### 配置

**环境变量：**

```bash
export ANTHROPIC_BASE_URL=https://taas.hk
export ANTHROPIC_API_KEY=sk-your-token
claude --model gpt-5.5
```

**或写入 `~/.claude/settings.json`：**

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://taas.hk",
    "ANTHROPIC_API_KEY": "sk-your-token"
  }
}
```

模型 id 须与 taas.hk catalog 一致（如 `gpt-5.5`）。也可用 `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1` 从 `/v1/models` 拉取后在 `/model` 中选择。

### 验证

```bash
curl -X POST https://taas.hk/v1/messages \
  -H "x-api-key: sk-your-token" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","max_tokens":64,"messages":[{"role":"user","content":"hello"}]}'
```

### CC Switch（可选）

CC Switch → **Claude** 槽位 → 添加 taas.hk → 运行 `claude --model gpt-5.5`。见 [CC Switch 使用指南](./cc-switch.md)。

---

## 3. taas.hk 接入 Desktop（Cowork on 3P）

Desktop 的模型菜单只接受 **Sonnet / Opus / Haiku** 角色名。`gpt-5.5` 等 GPT 模型 id 需通过 **CC Switch** 做**模型映射**，并开启**本地路由**。

### 步骤

1. 安装 [CC Switch](https://github.com/farion1231/cc-switch)
2. 左侧选 **Claude Desktop** 面板（与 CLI 的 Claude 槽位分开）
3. 添加 taas.hk 供应商：Base URL `https://taas.hk`，API Key 你的令牌
4. 开启 **需要模型映射**，填写映射表，例如：

| 模型角色 | 菜单显示名 | 实际请求模型 |
|----------|------------|--------------|
| Sonnet | GPT 5.5 | `gpt-5.5` |

5. 开启 **本地路由**（设置 → 路由 → 显示本地路由开关；Desktop 面板打开路由）
6. 启用该供应商，**完全退出并重启 Claude Desktop**
7. 使用期间保持 CC Switch 运行（映射模式依赖本地网关 `127.0.0.1:15721`）

CC Switch 会写入 Desktop 的 3P profile。详见 [CC Switch · Claude Desktop](./cc-switch.md#claude-desktop) 与 [CC Switch Claude Desktop 文档](https://github.com/farion1231/cc-switch/blob/main/docs/user-manual/zh/2-providers/2.6-claude-desktop.md)。

---

## 常见问题

**`ANTHROPIC_BASE_URL` 要不要加 `/v1`？**

CLI 会自动拼接 `/v1/messages`，填 `https://taas.hk` 即可。

**CLI 与 Desktop 配置互通吗？**

不互通。Claude 槽位与 Claude Desktop 面板需分别配置。

---

## 相关文档

- [CC Switch 使用指南](./cc-switch.md)
- [taas.hk 用户指南](../README.md)
