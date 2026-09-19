# Security

## Warnings

This repository is experimental, under active development, and not audited.

Do not deposit production funds into these contracts without significant additional engineering and independent review.

## Known MVP Limitations

- The oracle registry is development-only and owner-controlled.
- The router adapter system performs external calls and requires careful adapter review.
- Vault pricing is simplistic and assumes a single reserve asset.
- No slippage, fee, pause, upgrade, emergency withdrawal, role separation, or strategy accounting is included.
- No production `$KERBEROS` token design is implemented.
- The indexer is analytics-only and not a source of truth.

## Whitepaper-Aligned Risks

The whitepaper emphasizes that successful execution is not the same as intended execution. Production Kerberos implementations should preserve uncertainty, distinguish rejected from unresolved states, trace sources, and validate outcomes after execution.
