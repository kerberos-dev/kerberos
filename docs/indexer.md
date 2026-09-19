# Indexer

The indexer is a Node/TypeScript scaffold using PostgreSQL.

It listens for:

- `PortfolioCreated`
- `ExecutionRouted`

The database is for analytics, dashboards, and event history only.

Never use the indexer as the authority for:

- token balances
- share ownership
- approvals
- permissions
- vault solvency

Read those from contract state directly.
