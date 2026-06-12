#!/usr/bin/env bash
: "${TAAS_API_KEY:?export TAAS_API_KEY=sk-...}"
curl -sS -X POST "${TAAS_BASE_URL:-https://taas.hk}/v1/responses" \
  -H "Authorization: Bearer ${TAAS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${TAAS_MODEL:-gpt-5.5}\",\"input\":\"${1:-hello}\",\"store\":false}" | jq .
