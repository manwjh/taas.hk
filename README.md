# taas.hk 用户指南

`taas.hk` 是一个 **AI API 网关**（基于 New API）。用户在此创建 **API 令牌（Token）**，配置到 Codex、Claude Code、OpenCode 等 Agent 中使用。

---

## 一、taas.hk 是什么？

`taas.hk` 提供统一的 API 入口，把多种大模型（如 GPT、DeepSeek 等）封装成标准接口。你不需要直接对接各家厂商，只需：

1. 在 `taas.hk` 创建令牌
2. 把令牌填进 Codex / Claude Code 等工具
3. 通过 `https://taas.hk/v1` 调用模型

**常用模型**：`gpt-5.5`、`gpt-5.4`、`deepseek-v4-pro`、`deepseek-v4-flash`

---

## 二、如何创建令牌？

1. 登录 [taas.hk](https://taas.hk) 管理后台
2. 进入 **令牌 / Token** 管理页面
3. 点击 **新建令牌**，按需选择套餐类型：
   - **pro** — 专业版令牌
   - **plus** — 增强版令牌
4. 创建后复制以 `sk-` 开头的密钥（**只显示一次，请妥善保存**）

> 令牌是你在各 Agent 工具里填写的 API Key，与平台上游密钥无关。

---

## 三、使用场景

| 场景 | 文档 |
|------|------|
| taas.hk GPT → Claude Code CLI / Desktop | [guides/claude-code.md](./guides/claude-code.md) |

---

## 四、各 Agent 指南

| Agent | 协议 | API 地址 | 指南 |
|-------|------|----------|------|
| **Codex** | Responses | `https://taas.hk/v1` | [guides/codex.md](./guides/codex.md) |
| **Claude Code** | Messages | `https://taas.hk` | [guides/claude-code.md](./guides/claude-code.md) |
| **OpenCode** | Chat | `https://taas.hk/v1` | [guides/opencode.md](./guides/opencode.md) |

**可选**：[CC Switch 使用指南](./guides/cc-switch.md) — 本机 Agent 配置管理

---

## 五、快速验证令牌

```bash
# 检查模型列表
curl -H "Authorization: Bearer sk-your-token" \
  https://taas.hk/v1/models

# 简单对话测试
curl -X POST https://taas.hk/v1/chat/completions \
  -H "Authorization: Bearer sk-your-token" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-5.5","messages":[{"role":"user","content":"hello"}]}'
```

返回正常 JSON 即表示令牌和连接可用。

---

## 六、注意事项

1. **令牌安全**：不要把 `sk-` 密钥提交到 Git 或公开分享
2. **pro / plus**：两种令牌对应不同配额或权限，按套餐选择
3. **Codex 需重启**：修改 Codex 配置后，需完全退出（macOS：`Cmd+Q`）再重新打开才生效
4. **网络**：国内访问如遇问题，可配置代理

---

## 相关链接

- [taas.hk 官网](https://taas.hk)
