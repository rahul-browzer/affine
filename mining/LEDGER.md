# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $179,694.33 | 2026-08-09T06:57Z |
| cumulative mining spend | ~$18,002 (7 pods ~$253.6/h accruing) | 2026-08-09T06:57Z |
| **available for mining** | **~$169,694** (balance − $10,000 floor) | 2026-08-09T06:57Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (7 pods) | ~$253.6/h | 2026-08-09T06:57Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T06:57Z | 179694.33 | rm mine-f26+f27+f31 (REFUTE); burn ~$253.6/h; no rent |
| 2026-08-09T06:54Z | 179737.13 | rm mine-f28-1+f30-1 (REFUTE); burn ~$336.8/h; F35 king478 no rent |
| 2026-08-09T06:50Z | 179740.82 | no rent/rm; burn ~$392.8/h (F22+F32 king478; accrue only) |
| 2026-08-09T06:40Z | 179875.38 | no rent/rm; burn ~$392.8/h (F36 tf36 fix+relaunch; accrue only) |
| 2026-08-09T06:34Z | 179919.83 | no rent/rm; burn ~$392.8/h (F32 king478→n80; accrue only) |
| 2026-08-09T06:26Z | 179965.45 | rent mine-f36-1 8×H200 @$33.81/h TTL12h; burn ~$392.8/h |
| 2026-08-09T06:22Z | 180007.56 | no rent/rm; burn ~$359.0/h (F32 post_train relaunch; accrue only) |
| 2026-08-09T06:16Z | 180049.59 | no rent/rm; burn ~$359.0/h (F22 chall recover264 + F29 n80; accrue only) |
| 2026-08-09T06:12Z | 180091.77 | no rent/rm; burn ~$359.0/h (F31 n80 d203 after recover481; accrue only) |
| 2026-08-09T06:08Z | 180133.87 | no rent/rm; burn ~$359.0/h (F31 tok-fix + F26 n80; accrue only) |
