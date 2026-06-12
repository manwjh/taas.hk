#!/usr/bin/env bash
: "${TAAS_API_KEY:?export TAAS_API_KEY=sk-...}"
curl -sS -X POST "${TAAS_BASE_URL:-https://taas.hk}/v1/messages" \
  -H "x-api-key: ${TAAS_API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${TAAS_MODEL:-gpt-5.5}\",\"max_tokens\":64,\"messages\":[{\"role\":\"user\",\"content\":\"${1:-hello}\"}]}" | jq .
