# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $182,655.61 | 2026-08-09T01:02Z |
| cumulative mining spend | ~$15,108 (6 pods ~$175.8/h accruing) | 2026-08-09T01:02Z |
| **available for mining** | **~$172,656** (balance − $10,000 floor) | 2026-08-09T01:02Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$175.8/h | 2026-08-09T01:02Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T01:02Z | 182655.61 | accrual (F13 merge recover + F12 d203 re-point; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:59Z | 182689.55 | accrual (F11 FALSE_PROBE quarantine; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:56Z | 182689.55 | accrual (F10 freeze+n80; F12 recover; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:50Z | 182721.60 | accrual (F11 recover264; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:45Z | 182753.71 | rm mine-f9-1 (~$113) + mine-f4-1 (~$347); burn ~$175.8/h |
| 2026-08-09T00:38Z | 182833.09 | rent mine-f15-1 @$31.92/h (H110/F15); burn ~$271.3/h |
| 2026-08-09T00:35Z | 182833.09 | rent mine-f14-1 @$28/h (H109/F14); burn ~$239.4/h |
| 2026-08-09T00:31Z | 182867.94 | rm mine-f7-1 (H102 REFUTE ~$105); burn ~$211.4/h |
| 2026-08-09T00:18Z | 182979.64 | rent mine-f13-1 @$31.92/h (H108/F13); burn ~$239.4/h |
| 2026-08-09T00:11Z | 183014.40 | rent mine-f12-1 @$28/h (H107/F12); burn ~$207.5/h |
