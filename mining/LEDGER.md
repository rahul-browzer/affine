# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $179,919.83 | 2026-08-09T06:34Z |
| cumulative mining spend | ~$17,775 (12 pods ~$392.8/h accruing) | 2026-08-09T06:34Z |
| **available for mining** | **~$169,920** (balance − $10,000 floor) | 2026-08-09T06:34Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (12 pods) | ~$392.8/h | 2026-08-09T06:34Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T06:34Z | 179919.83 | no rent/rm; burn ~$392.8/h (F32 king478→n80; accrue only) |
| 2026-08-09T06:26Z | 179965.45 | rent mine-f36-1 8×H200 @$33.81/h TTL12h; burn ~$392.8/h |
| 2026-08-09T06:22Z | 180007.56 | no rent/rm; burn ~$359.0/h (F32 post_train relaunch; accrue only) |
| 2026-08-09T06:16Z | 180049.59 | no rent/rm; burn ~$359.0/h (F22 chall recover264 + F29 n80; accrue only) |
| 2026-08-09T06:12Z | 180091.77 | no rent/rm; burn ~$359.0/h (F31 n80 d203 after recover481; accrue only) |
| 2026-08-09T06:08Z | 180133.87 | no rent/rm; burn ~$359.0/h (F31 tok-fix + F26 n80; accrue only) |
| 2026-08-09T06:03Z | 180174.02 | no rent/rm; burn ~$359.0/h (F29/F30/F31 chall recover after bad preempt EXP) |
| 2026-08-09T05:59Z | 180218.12 | no rent/rm; burn ~$359.0/h (F26 teacher479 after bare-cache ENOENT) |
| 2026-08-09T05:57Z | 180218.12 | no rent/rm; burn ~$359.0/h (F27 king478 after mid-n80 ENOENT) |
| 2026-08-09T05:55Z | 180260.06 | no rent/rm; burn ~$359.0/h (F28 king435 seed-from-chall) |
