# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $185,072.37 | 2026-08-08T19:02Z |
| cumulative mining spend | ~$11,800 (6 pods ~$180/h accruing) | 2026-08-08T19:02Z |
| **available for mining** | **~$175,072** (balance − $10,000 floor) | 2026-08-08T19:02Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$180/h (h91/93/95 $31.92×3 + h94/96/f3 $28×3) | 2026-08-08T19:02Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T19:02Z | 185072.37 | rent mine-f3-1 noble-raven-ff @$28/h ttl12h (H97/F3 r256) |
| 2026-08-08T18:53Z | 185133.03 | rent mine-h96-1 golden-matrix-af @$28/h ttl12h (H96 r9) |
| 2026-08-08T18:52Z | 185133.03 | rm mine-h92-1 (spent ~$47; H92 REFUTE m=+0.000618) |
| 2026-08-08T18:36Z | 185220.48 | burn accrual; H94 king re-fire+n80; H93 mid304 |
| 2026-08-08T18:21Z | 185291.61 | burn accrual; H94/H93 recovers (no rent/rm) |
| 2026-08-08T18:17Z | 185315.57 | burn accrual; H94 n80+mid304 |
| 2026-08-08T18:05Z | 185363.21 | rent mine-h95-1 calm-raven-0f @$31.92/h ttl12h |
| 2026-08-08T18:05Z | 185383.10 | rm mine-h90-1 (spent ~$47; H90 REFUTE) |
| 2026-08-08T17:45Z | 185527.15 | burn accrual; H91 n80+mid304 |
| 2026-08-08T17:27Z | 185549.85 | rent mine-h94-1 cosmic-fox-43 @$28/h ttl12h |
