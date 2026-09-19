# Deployment

## Status

Experimental / Under Active Development / Not Audited.

## Local

```bash
anvil
forge script contracts/script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

## Testnet Or Mainnet

This repository intentionally does not include:

- RPC URLs.
- Private keys.
- Deployed contract addresses.
- Claims of production readiness.
- Audit claims.

Before any public deployment:

1. Replace the development-only oracle registry with a real trust/source model.
2. Add complete invariant, fuzz, and integration tests.
3. Review adapter behavior and external call risks.
4. Conduct independent security review.
5. Publish verified contract addresses only after deployment.

## Robinhood Chain

The attached whitepaper references Robinhood Chain chain ID `4663` and ETH as gas. No RPC endpoint or deployed address is provided here.
