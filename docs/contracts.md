# Contracts

## PortfolioFactory

Permissionless factory for creating portfolio vault/share pairs.

Main function:

- `createPortfolio(metadata)` deploys a `PortfolioShare`, deploys a `PortfolioVault`, configures the vault as the share minter, and emits `PortfolioCreated`.

## PortfolioVault

Minimal non-custodial vault for a single ERC-20 reserve asset.

Main functions:

- `addLiquidity(assets)` transfers assets from the caller and mints proportional shares.
- `removeLiquidity(shares)` burns caller shares and returns proportional assets.
- `setStrategyURI(strategyURI)` lets the manager update strategy metadata only.

## PortfolioShare

Minimal ERC-20 style share token. Minting and burning are restricted to the configured vault.

## MarketRouter

Routes calls into approved adapters after checking an expected action hash against the development registry. This models the whitepaper's expected-vs-observed execution distinction at MVP scale.

## DevelopmentOracleRegistry

Development-only source registry. It is not a decentralized oracle, not production-safe, and not suitable as a trust root for mainnet funds.
