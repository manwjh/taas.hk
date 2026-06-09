# T4：Claude Code CLI 裸配置测试报告

## 测试结论

**PASS（需修正文档命令）**。在 macOS 机器上，按文档设置 `ANTHROPIC_BASE_URL=https://taas.hk` 和 `ANTHROPIC_API_KEY=sk-xxx` 后，直接运行 `claude --model gpt-5.5` 未能使用 `taas.hk`；将命令改为 `claude --bare -p --model gpt-5.5 "只回复 OK"` 后，Claude Code 可正常返回 `ok`。

## 对应源文档

- `README.md`：`二、厂商 Agent · 网关接入`
- `README.md`：`四、taas.hk 前置 / 连接参数`
- `guides/claude-code.md`：`2. taas.hk 网关接入 · CLI`
- `guides/claude-code.md`：`连接参数`
- `guides/claude-code.md`：`配置`
- `guides/claude-code.md`：`验证`

## 测试环境

- 测试完成环境：macOS
- 测试终端：macOS Terminal
- 主机标识：`perfxlab@perfxlabdeMac-mini`
- Agent：Claude Code CLI
- Claude Code 版本：`2.1.169`
- 配置方式：Shell 环境变量
- API Token：已打码，格式为 `sk-xxx`
- 测试模型：`gpt-5.5`
- 是否使用 CC Switch：否

## 测试步骤与结果

### 1. 设置 `ANTHROPIC_BASE_URL`

执行命令：

```bash
export ANTHROPIC_BASE_URL=https://taas.hk
echo $ANTHROPIC_BASE_URL
```

输出：

```text
https://taas.hk
```

验证结果：

- Shell 环境变量 `ANTHROPIC_BASE_URL` 已设置成功。

### 2. 设置 `ANTHROPIC_API_KEY`

执行命令：

```bash
export ANTHROPIC_API_KEY=sk-xxx
echo $ANTHROPIC_API_KEY
```

输出：

```text
sk-xxx
```

验证结果：

- Shell 环境变量 `ANTHROPIC_API_KEY` 已设置成功。

### 3. 检查 Claude Code 版本

执行命令：

```bash
claude --version
```

输出：

```text
2.1.169 (Claude Code)
```

验证结果：

- Claude Code CLI 已安装。
- 当前测试版本为 `2.1.169`。

### 4. 使用文档原命令启动 Claude Code

执行命令：

```bash
claude --model gpt-5.5
```

输出摘要：

```text
Welcome to Claude Code v2.1.169

Unable to connect to Anthropic services

Failed to connect to api.anthropic.com: ERR_BAD_REQUEST

Please check your internet connection and network settings.
```

验证结果：

- Claude Code 没有使用已设置的 `ANTHROPIC_BASE_URL=https://taas.hk`。
- Claude Code 仍尝试连接官方 `api.anthropic.com`。
- 文档中的原启动命令在该测试环境下未通过。

### 5. 使用修正命令启动 Claude Code

执行命令：

```bash
claude --bare -p --model gpt-5.5 "只回复 OK"
```

输出：

```text
ok
```

验证结果：

- Claude Code 可以在裸配置模式下使用 `ANTHROPIC_BASE_URL=https://taas.hk`。
- `gpt-5.5` 模型可正常返回。
- `--bare -p` 命令可作为当前文档中 Claude Code CLI 裸配置的有效验证命令。

## 需修正文档点

`guides/claude-code.md` 中的 CLI 配置示例为：

```bash
export ANTHROPIC_BASE_URL=https://taas.hk
export ANTHROPIC_API_KEY=sk-your-token
claude --model gpt-5.5
```

但本次实测中，执行上述流程后，Claude Code 仍连接 `api.anthropic.com`，未按预期连接 `https://taas.hk`。

建议将验证命令调整为：

```bash
claude --bare -p --model gpt-5.5 "只回复 OK"
```

## 后续待验证

为确认文档覆盖完整，建议继续补测：

1. 使用 `~/.claude/settings.json` 写入 `ANTHROPIC_BASE_URL` 和 `ANTHROPIC_API_KEY` 后，再配合 `--bare -p` 运行。
2. 通过 CC Switch 配置 Claude Code CLI，验证 T5 是否同样可用。

## 最终结论

T4 测试通过，但当前 `guides/claude-code.md` 中的验证命令需要修正。在 macOS + Claude Code `2.1.169` 环境下，`claude --model gpt-5.5` 会继续连接 `api.anthropic.com`；改用 `claude --bare -p --model gpt-5.5 "只回复 OK"` 后，可正常通过 `taas.hk` 返回 `ok`。
