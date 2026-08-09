# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $182,464.17 | 2026-08-09T01:32Z |
| cumulative mining spend | ~$15,298 (6 pods ~$175.8/h accruing) | 2026-08-09T01:32Z |
| **available for mining** | **~$172,464** (balance − $10,000 floor) | 2026-08-09T01:32Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$175.8/h | 2026-08-09T01:32Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T01:32Z | 182464.17 | accrual (F15 merge432 preempt hang; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:28Z | 182496.70 | accrual (F11 e203 FP-fix; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:23Z | 182528.75 | accrual (F14 recover264+d203 sidecar; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:19Z | 182560.86 | accrual (F14 contig+/tmp merge recover; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:07Z | 182625.31 | accrual (F14 GPU→CPU merge recover; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:02Z | 182655.61 | accrual (F13 merge recover + F12 d203 re-point; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:59Z | 182689.55 | accrual (F11 FALSE_PROBE quarantine; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:56Z | 182689.55 | accrual (F10 freeze+n80; F12 recover; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:50Z | 182721.60 | accrual (F11 recover264; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T00:45Z | 182753.71 | rm mine-f9-1 (~$113) + mine-f4-1 (~$347); burn ~$175.8/h |
