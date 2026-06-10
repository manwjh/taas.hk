# taas.hk 文档验证测试矩阵

## 测试环境定义


| 环境   | 系统      | 用途             |
| ---- | ------- | -------------- |
| 环境 A | macOS   | 裸配置测试          |
| 环境 B | Windows | CC Switch 配置测试 |


## 当前进度


| 编号  | 测试项                                | 结论           | 测试环境           | 报告文件                                                                               |
| --- | ---------------------------------- | ------------ | -------------- | ---------------------------------------------------------------------------------- |
| T1  | taas.hk 基础 API 连通测试                | PASS         | 环境 A / macOS   | [T1-taas-api-connectivity.md](./T1-taas-api-connectivity.md)                       |
| T2  | Codex 裸改配置测试                       | PASS         | 环境 A / macOS   | [T2-codex-direct-config.md](./T2-codex-direct-config.md)                           |
| T3  | Codex 通过 CC Switch 配置测试            | PASS         | 环境 B / Windows | [T3-codex-cc-switch-config.md](./T3-codex-cc-switch-config.md)                     |
| T4  | Claude Code CLI 裸配置测试              | PASS，需修正文档命令 | 环境 A / macOS   | [T4-claude-code-cli-direct-config.md](./T4-claude-code-cli-direct-config.md)       |
| T5  | Claude Code CLI 通过 CC Switch 配置测试  | PASS         | 环境 B / Windows | [T5-claude-code-cc-switch-config.md](./T5-claude-code-cc-switch-config.md)         |
| T6  | Claude Desktop 通过 CC Switch 模型映射测试 | PASS         | 环境 B / Windows | [T6-claude-desktop-cc-switch-mapping.md](./T6-claude-desktop-cc-switch-mapping.md) |
| T7  | OpenCode 裸 Provider 配置测试           | PASS         | 环境 A / macOS   | [T7-opencode-direct-provider.md](./T7-opencode-direct-provider.md)                 |
| T8  | OpenCode 通过 CC Switch 配置测试         | PASS         | 环境 B / Windows | [T8-opencode-cc-switch-config.md](./T8-opencode-cc-switch-config.md)               |
| T9  | 场景 01：taas.hk GPT -> Claude Code   | PASS         |                | [T9-scenario-taas-gpt-in-claude-code.md](./T9-scenario-taas-gpt-in-claude-code.md) |
| T10 | 场景 02：taas.hk GPT -> Codex         | PASS         |                | [T10-scenario-taas-gpt-in-codex.md](./T10-scenario-taas-gpt-in-codex.md)           |


## 已发现需修改文档点

### Claude Code CLI 验证命令

`guides/claude-code.md` 当前 CLI 示例使用：

```bash
claude --model gpt-5.5
```

macOS + Claude Code `2.1.169` 实测中，该命令仍连接 `api.anthropic.com`。

已验证可用命令为：

macOS / Linux：

```bash
ANTHROPIC_BASE_URL=https://taas.hk \
ANTHROPIC_API_KEY=sk-xxx \
claude --bare -p --model gpt-5.5 "只回复 OK"
```

Windows PowerShell：

```powershell
& {
  $env:ANTHROPIC_BASE_URL = "https://taas.hk"
  $env:ANTHROPIC_API_KEY = "sk-xxx"
  claude --bare -p --model gpt-5.5 "只回复 OK"
}
```

建议将 `guides/claude-code.md` 的 CLI 验证命令调整为跨平台临时配置形式，或增加说明：在需要强制使用 API key / 网关环境变量时，使用 `--bare -p` 进行验证。