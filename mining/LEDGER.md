# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $183,286.61 | 2026-08-08T23:29Z |
| cumulative mining spend | ~$14,125 (4 pods ~$151.5/h accruing) | 2026-08-08T23:29Z |
| **available for mining** | **~$173,287** (balance − $10,000 floor) | 2026-08-08T23:29Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | ~$151.5/h | 2026-08-08T23:29Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T23:29Z | 183286.61 | accrual (F7 d203first; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:24Z | 183316.64 | accrual (F4 teacher OK+n80; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:17Z | 183346.74 | accrual (F4 teacher recover332; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:14Z | 183376.85 | accrual (F4 n80 armed; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:07Z | 183406.94 | accrual (F4 cuda404 cudart relaunch; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T23:01Z | 183467.29 | accrual (F4 CCCL/cuda403; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T22:54Z | 183497.34 | accrual (F8 recover264; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T22:50Z | 183497.34 | accrual (F9 n80 start + F4 cuda401; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T22:45Z | 183527.33 | accrual (F9 longwait arm; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T22:42Z | 183557.62 | rm mine-f6-1 (H101 REFUTE); burn ~$151.5/h |
