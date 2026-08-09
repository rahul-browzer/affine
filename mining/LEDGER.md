# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $177,909.35 | 2026-08-09T12:10Z |
| cumulative mining spend | ~$19,826 (Δ bal from p526 baseline) | 2026-08-09T12:10Z |
| **available for mining** | **~$167,909** (balance − $10,000 floor) | 2026-08-09T12:10Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | ~$31.92/h | 2026-08-09T12:10Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T12:10Z | 177909.35 | KING-WATCH idle; no rent/rm; burn ~$32/h |
| 2026-08-09T12:08Z | 177924.23 | KING-WATCH idle; no rent/rm; burn ~$32/h |
| 2026-08-09T12:07Z | 177924.23 | KING-WATCH idle; no rent/rm; burn ~$32/h |
| 2026-08-09T12:06Z | 177924.23 | KING-WATCH idle; no rent/rm; burn ~$32/h |
| 2026-08-09T12:04Z | 177938.41 | no rent/rm; H64 chall swap confirmed; burn ~$32/h |
| 2026-08-09T11:57Z | 177953.89 | KING-WATCH rm mine-f44-1+mine-f46-1; burn ~$32/h (1 pod) |
| 2026-08-09T11:52Z | 177974.56 | no rent/rm; F45 p529 cutover; burn ~$83/h |
| 2026-08-09T11:46Z | 177993.63 | rm mine-f42-1 after REFUTE (spent ~$93); burn ~$83/h |
| 2026-08-09T11:38Z | 178036.88 | rm mine-f40-1 after REFUTE (spent ~$97); burn ~$111/h |
| 2026-08-09T11:33Z | 178062.02 | rm mine-f41-1 after REFUTE (spent ~$90); burn ~$139/h |
