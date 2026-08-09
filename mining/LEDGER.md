# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $179,522.30 | 2026-08-09T07:22Z |
| cumulative mining spend | ~$18,174 (8 pods ~$276.8/h accruing) | 2026-08-09T07:22Z |
| **available for mining** | **~$169,522** (balance − $10,000 floor) | 2026-08-09T07:22Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (8 pods) | ~$276.8/h | 2026-08-09T07:22Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T07:22Z | 179522.30 | no rent/rm; burn ~$276.8/h (F37 train launch; accrue only) |
| 2026-08-09T07:19Z | 179557.45 | no rent/rm; burn ~$276.8/h (F36 salvage; accrue only) |
| 2026-08-09T07:08Z | 179627.61 | rent mine-f37-1 8×H200 @$23.20/h TTL12h; burn ~$276.8/h |
| 2026-08-09T07:02Z | 179659.36 | no rent/rm; burn ~$253.6/h (F29 watcher fix; accrue only) |
| 2026-08-09T06:57Z | 179694.33 | rm mine-f26+f27+f31 (REFUTE); burn ~$253.6/h; no rent |
| 2026-08-09T06:54Z | 179737.13 | rm mine-f28-1+f30-1 (REFUTE); burn ~$336.8/h; F35 king478 no rent |
| 2026-08-09T06:50Z | 179740.82 | no rent/rm; burn ~$392.8/h (F22+F32 king478; accrue only) |
| 2026-08-09T06:40Z | 179875.38 | no rent/rm; burn ~$392.8/h (F36 tf36 fix+relaunch; accrue only) |
| 2026-08-09T06:34Z | 179919.83 | no rent/rm; burn ~$392.8/h (F32 king478→n80; accrue only) |
| 2026-08-09T06:26Z | 179965.45 | rent mine-f36-1 8×H200 @$33.81/h TTL12h; burn ~$392.8/h |
