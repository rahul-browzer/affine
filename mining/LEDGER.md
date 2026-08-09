# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $182,240.38 | 2026-08-09T02:07Z |
| cumulative mining spend | ~$15,507 (8 pods ~$241.6/h accruing) | 2026-08-09T02:07Z |
| **available for mining** | **~$172,240** (balance − $10,000 floor) | 2026-08-09T02:07Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (8 pods) | ~$241.6/h | 2026-08-09T02:07Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T02:07Z | 182240.38 | rent mine-f18-1 @$33.81/h TTL12h; burn →~$241.6/h |
| 2026-08-09T02:03Z | 182272.15 | rent mine-f17-1 @$31.92/h TTL12h; burn →~$207.7/h |
| 2026-08-09T01:58Z | 182304.99 | rent mine-f16-1 @$28/h TTL12h; burn →~$175.8/h |
| 2026-08-09T01:53Z | 182334.65 | F12 tear (~$47.64 spent); burn →~$147.8/h |
| 2026-08-09T01:48Z | 182367.73 | accrual (F15 d203 rearm + F11 longwait; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:45Z | 182367.73 | accrual (F11 king435 seeded; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:37Z | 182432.55 | accrual (F11 king332 armed; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:35Z | 182432.55 | accrual (F15 visual433+SKIP_MERGE; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:32Z | 182464.17 | accrual (F15 merge432 preempt hang; no rm/rent; burn ~$175.8/h) |
| 2026-08-09T01:28Z | 182496.70 | accrual (F11 e203 FP-fix; no rm/rent; burn ~$175.8/h) |
