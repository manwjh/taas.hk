# scripts

taas.hk 连通性快捷脚本，对应 [README](../README.md#验证连通) 中的 curl 示例。

```bash
export TAAS_API_KEY=sk-...

./scripts/models.sh
./scripts/chat.sh hello        # OpenCode / Chat Completions
./scripts/responses.sh hello   # Codex / Responses
./scripts/messages.sh hello    # Claude Code / Messages
```

可选环境变量：`TAAS_BASE_URL`（默认 `https://taas.hk`）、`TAAS_MODEL`（默认 `gpt-5.5`）。

需要 `curl` 和 `jq`。
