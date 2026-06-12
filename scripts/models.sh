#!/usr/bin/env bash
: "${TAAS_API_KEY:?export TAAS_API_KEY=sk-...}"
curl -sS -H "Authorization: Bearer ${TAAS_API_KEY}" \
  "${TAAS_BASE_URL:-https://taas.hk}/v1/models" | jq .
