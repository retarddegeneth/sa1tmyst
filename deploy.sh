#!/usr/bin/env bash
# Deploy Sa1tMyst wrapper to Ethereum mainnet
# Usage: ./deploy.sh <PRIVATE_KEY> <RPC_URL> [SA1T_V2_FACTORY]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTRACT="$SCRIPT_DIR/contracts/Sa1tMyst.sol"

PK="${1:?Usage: deploy.sh <PRIVATE_KEY> <RPC_URL> [SA1T_V2_FACTORY]}"
RPC="${2:?Usage: deploy.sh <PRIVATE_KEY> <RPC_URL> [SA1T_V2_FACTORY]}"
FACTORY="${3:-0x0000000000000000000000000000000000000000}"

echo "== Building Sa1tMyst =="
cd "$SCRIPT_DIR/contracts"
forge build --force

echo "== Deploying Sa1tMyst to $RPC =="
OUTPUT=$(forge create \
  --rpc-url "$RPC" \
  --private-key "$PK" \
  --etherscan-api-key "${ETHERSCAN_KEY:-}" \
  --verify \
  "$CONTRACT:Sa1tMyst" 2>&1)

echo "$OUTPUT"
ADDRESS=$(echo "$OUTPUT" | grep -oE '0x[a-fA-F0-9]{40}' | head -1 || true)
if [ -z "$ADDRESS" ]; then
  echo "Failed to parse deployed address"
  exit 1
fi

echo "== Deployed =="
echo "WRAPPER=$ADDRESS"
echo "SA1T_V2_FACTORY=$FACTORY"
echo "CHAIN=ethereum"
echo "EXPLORER=https://etherscan.io"
echo
echo "Set these in index.html window.SA1TMYST"
