#!/usr/bin/env bash
# Reveal mechanic for a mystery pool in Sa1tMyst wrapper
# Usage: ./reveal.sh <PRIVATE_KEY> <RPC_URL> <WRAPPER_ADDRESS> <POOL_ADDRESS> <MECHANIC>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PK="${1:?Usage: reveal.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC>}"
RPC="${2:?Usage: reveal.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC>}"
WRAPPER="${3:?Usage: reveal.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC>}"
POOL="${4:?Usage: reveal.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC>}"
MECHANIC="${5:?Usage: reveal.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC>}"

echo "== Revealing mechanic =="
echo "POOL=$POOL"
echo "MECHANIC=$MECHANIC"

cast send "$WRAPPER" \
  --rpc-url "$RPC" \
  --private-key "$PK" \
  "reveal(address,string)" \
  "$POOL" \
  "$MECHANIC"

echo "== Revealed =="
