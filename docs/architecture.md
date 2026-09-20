# Architecture

KERBEROS is split into two conceptual layers.

## Whitepaper Layer: Execution Assurance

The whitepaper-supported model centers on verification records:

1. Establish intended execution requirements.
2. Inspect the observed action.
3. Validate observed properties against requirements and policy.
4. Resolve as verified, rejected, or unresolved.
5. Verify outcome after execution where possible.

In this repository, `MarketRouter` is the MVP bridge into that model. It checks a trusted development source before routing to an adapter and emits an `ExecutionRouted` event containing expected and observed action hashes.

## MVP Extension: Portfolio Protocol

The portfolio-first layer is implemented as a minimal non-custodial MVP:

- `PortfolioFactory` creates vault/share pairs.
- `PortfolioVault` accepts a single ERC-20 reserve asset and mints/burns portfolio shares.
- `PortfolioShare` represents ownership of vault liquidity.
- `MarketRouter` routes adapter calls after a development-only source check.
- `DevelopmentOracleRegistry` is intentionally labeled development-only.

This extension is not attributed to the PDF.

## Data Sources

Contract state is authoritative. The indexer stores analytics events only and must not be used as the source of truth for balances or ownership.
