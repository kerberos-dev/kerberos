# Protocol

## Execution Assurance Concepts

Kerberos verifies whether an action corresponds to what was intended. The PDF describes execution records, source tracing, policy checks, and outcome verification as the core protocol concepts.

## Portfolio MVP Extension

The portfolio MVP is intentionally conservative:

- Each portfolio vault holds one ERC-20 reserve asset.
- Shares are minted on deposit and burned on withdrawal.
- Initial shares are minted 1:1 with assets.
- Later deposits mint proportional shares based on current vault assets and total share supply.
- No yield strategy, pricing oracle, rebalancing engine, or production adapter is included.

## $KERBEROS Token

The user requested `$KERBEROS` be treated as a utility/ecosystem token rather than equity. The attached PDF does not specify token mechanics. This repository therefore includes no token contract, sale mechanics, allocation schedule, or investment language.

Any future `$KERBEROS` design should be documented separately, reviewed legally, and kept distinct from equity or profit-share claims.
