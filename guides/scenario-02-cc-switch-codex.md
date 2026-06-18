# 场景二 · CC Switch 配置 Codex 接入 taas.hk

**目标**：用 [CC Switch](https://github.com/farion1231/cc-switch) 图形化管理 Codex 供应商，一键在 taas.hk 与 OpenAI 官方等预设间切换。

**前置**：已完成 [令牌创建与验证](./README.md#典型用户场景)；已安装 CC Switch。

**延伸阅读**：[codex.md §3](./codex.md#3-taashk-网关接入--cc-switch) · [cc-switch.md](./cc-switch.md)

---

## 连接参数

| 字段 | 值 |
|------|-----|
| Base URL | `https://taas.hk/v1` |
| API Key | `sk-...` |
| 模型 | `gpt-5.5` |
| Wire API | `responses` |
| 需要本地路由 | **关闭**（taas.hk 原生支持 Responses，直连即可） |

> taas.hk 令牌连接串中的 URL 常为 `https://taas.hk`（不带 `/v1`）。**Codex 槽位须填 `https://taas.hk/v1`**，与 Claude Code 不同。

CC Switch 启用后会写入：

| 环境 | 文件 |
|------|------|
| macOS | `~/.codex/config.toml`、`~/.codex/auth.json` |
| Windows | `%USERPROFILE%\.codex\config.toml`、`%USERPROFILE%\.codex\auth.json` |

---

## 步骤一 · 安装 CC Switch

1. 从 [CC Switch Releases](https://github.com/farion1231/cc-switch/releases) 下载对应平台安装包。
2. 安装并启动 CC Switch，确认托盘或主窗口正常显示。

> 📷 **插图** `images/scenario-02/01-cc-switch-home.png`  
> 说明：CC Switch 主界面，左侧 Agent 列表可见 Codex、Claude 等槽位。

---

## 步骤二 · 添加 taas.hk 供应商

| 步骤 | 操作 |
|------|------|
| 1 | 打开 CC Switch → 切换到 **Codex** 面板 |
| 2 | 点击 **+** → 选择 **Custom**（taas.hk 不在内置 preset 列表） |
| 3 | 填写连接参数（见上表） |
| 4 | Wire API 选 **`responses`** |
| 5 | **不要**开启「需要本地路由」 |
| 6 | 保存供应商卡片 |

> 📷 **插图** `images/scenario-02/02-add-provider-form.png`  
> 说明：Custom 供应商表单，Base URL `https://taas.hk/v1`，Wire API 选 `responses`。

> 📷 **插图** `images/scenario-02/03-provider-card.png`  
> 说明：保存后的 taas.hk 供应商卡片，尚未启用。

---

## 步骤三 · 启用并写入配置

1. 在 taas.hk 供应商卡片上点击 **启用**。
2. CC Switch 会自动写入 `config.toml`（`model_provider`、`base_url`、`wire_api` 等）与 `auth.json`（`OPENAI_API_KEY`）。

> 📷 **插图** `images/scenario-02/04-enable-provider.png`  
> 说明：供应商卡片处于「已启用」状态，其他 Codex 供应商变灰。

可选：在 CC Switch **设置** 中配置托盘快捷切换，便于在多供应商间切换。

---

## 步骤四 · 重启 Codex

1. **完全退出** Codex（macOS `Cmd+Q`；Windows 退出窗口与托盘进程）。
2. 重新打开 Codex App 或运行 `codex`。
3. 首次若提示 API key，填入与 CC Switch 相同的 `sk-...` 令牌。
4. 新建对话，确认模型为 `gpt-5.5`，发送测试消息。

> 📷 **插图** `images/scenario-02/05-codex-running.png`  
> 说明：Codex 正常运行，请求经 taas.hk 返回。

---

## 步骤五 · 验证（可选）

同 [场景一 · 步骤一](./scenario-01-codex-direct.md#步骤一--验证网关建议先做)，或：

```bash
export TAAS_API_KEY=sk-your-token
./scripts/responses.sh hello
```

---

## 切换回 OpenAI 官方

| 步骤 | 操作 |
|------|------|
| 1 | CC Switch → Codex 面板 → 启用 OpenAI 官方或其他供应商 |
| 2 | 完全退出 Codex（`Cmd+Q`）后重新打开 |

切换 `model_provider` 后，Codex 侧边栏历史可能按供应商分组变化，属正常现象。详见 [codex.md · 常见问题](./codex.md#常见问题)。

> 📷 **插图** `images/scenario-02/06-switch-provider.png`  
> 说明：CC Switch 中切换启用的 Codex 供应商。

---

## 常见问题

| 问题 | 说明 |
|------|------|
| Base URL 要不要带 `/v1`？ | Codex **必须** `https://taas.hk/v1` |
| 要不要开本地路由？ | **不要**；仅 Claude Desktop GPT 映射才需要 |
| auth 写在哪里？ | CC Switch 写 `auth.json`，不是 `.env` |

---

## 下一步

- Claude Desktop 使用 GPT 模型 → [场景三 · CC Switch + Claude Desktop](./scenario-03-cc-switch-claude-desktop.md)
- 不想用 CC Switch → [场景一 · Codex 直接配置](./scenario-01-codex-direct.md)

[返回场景索引](./README.md) · [cc-switch.md](./cc-switch.md)
