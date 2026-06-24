#!/usr/bin/env bash
# Register a sa1t pool as a mystery token in Sa1tMyst wrapper
# Usage: ./register.sh <PRIVATE_KEY> <RPC_URL> <WRAPPER_ADDRESS> <POOL_ADDRESS> <MECHANIC> <SALT>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PK="${1:?Usage: register.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC> <SALT>}"
RPC="${2:?Usage: register.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC> <SALT>}"
WRAPPER="${3:?Usage: register.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC> <SALT>}"
POOL="${4:?Usage: register.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC> <SALT>}"
MECHANIC="${5:?Usage: register.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC> <SALT>}"
SALT="${6:?Usage: register.sh <PK> <RPC> <WRAPPER> <POOL> <MECHANIC> <SALT>}"

cast compute keccak256 "$MECHANIC$SALT" --rpc-url "$RPC"
HASH=$(cast compute keccak256 "$MECHANIC$SALT" --rpc-url "$RPC")

echo "== Registering mystery =="
echo "POOL=$POOL"
echo "MECHANIC=$MECHANIC"
echo "SALT=$SALT"
echo "HASH=$HASH"

cast send "$WRAPPER" \
  --rpc-url "$RPC" \
  --private-key "$PK" \
  "registerMystery(address,bytes32,string)" \
  "$POOL" \
  "$HASH" \
  "$SALT"

echo "== Registered =="
echo "Pool $POOL is now a mystery token with mechanic hidden."
