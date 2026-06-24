# sa1tmyst
Mechanic mystery wrapper for sa1t v2.

## What
Creates sa1t v2 pools with mechanic hidden until graduation. Commitment hash is registered on-chain; mechanic reveals atomically at sellout.

## Deploy
```bash
forge install
forge build
forge create --rpc-url $ETH_RPC --private-key $PK src/Sa1tMyst.sol:Sa1tMyst
```

## Use
1. Deploy sa1t v2 pool via sa1t factory (standard flow)
2. Call `registerMystery(pool, keccak256(abi.encodePacked(mechanic, salt)), salt)`
3. Trade on curve — mechanic stays hidden
4. At graduation, call `reveal(pool, mechanic)` to unlock

## Frontend
Open `index.html` and set `WRAPPER` address in `window.SA1TMYST`.
