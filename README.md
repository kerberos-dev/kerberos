# KERBEROS Protocol

**Experimental / Under Active Development / Not Audited**

KERBEROS is a GitHub-ready protocol monorepo built from the referenced conversation and the attached `KERBEROS.pdf` whitepaper. The whitepaper positions Kerberos as **execution assurance for autonomous systems**: an independent verification layer between intent and execution.

The repository also includes the user's requested portfolio-first protocol MVP. Those portfolio market components are clearly marked as a requested extension because they are **not described in the attached whitepaper**.

## Whitepaper Verification

Supported by the attached `KERBEROS.pdf`:

- Execution assurance for autonomous systems.
- "Verify the action. Validate the outcome."
- Establish -> Inspect -> Validate -> Resolve lifecycle.
- Execution Records as the central unit.
- Source Trace and provenance of important execution data.
- Transaction, permission, policy, outcome, and continuous assurance.
- Human-readable verification console concepts: Activity, Executions, Alerts, Sources, Policies, Trust, History.
- Kerberos exists between application intent and wallet/protocol execution.

Not found in the attached whitepaper and therefore treated as requested/inferred MVP extensions:

- Portfolio-first markets.
- `PortfolioFactory`, `PortfolioVault`, `PortfolioShare`, and `MarketRouter` as portfolio protocol contracts.
- `$KERBEROS` token economics or utility token mechanics.
- Production deployment addresses, audits, or production readiness.

## Repository Layout

```text
apps/web              Next.js frontend scaffold
contracts             Solidity contracts, Foundry tests, deploy scripts
packages/sdk          TypeScript viem helpers
packages/abi          Minimal ABI exports
packages/config       Network/config registry with no fabricated addresses
backend/indexer       Node/TypeScript analytics indexer scaffold
docs                  Architecture, protocol, contracts, deployment, security
```

## Quick Start

```bash
pnpm install
pnpm build
forge test
```

Foundry is required for contract tests. The repository intentionally vendors only a tiny local `forge-std` test shim so the MVP tests remain readable without pulling large dependencies into the generated ZIP.

## Status

This code is an MVP scaffold intended for review and extension. It is not audited, not deployed, and not production-ready. The backend indexer is for analytics and event history only; ownership and balances must be read from contracts directly.
