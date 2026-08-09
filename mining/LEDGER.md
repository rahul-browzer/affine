# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $181,811.18 | 2026-08-09T02:51Z |
| cumulative mining spend | ~$15,937 (11 pods ~$400/h accruing) | 2026-08-09T02:51Z |
| **available for mining** | **~$171,811** (balance − $10,000 floor) | 2026-08-09T02:51Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (11 pods) | ~$400.4/h | 2026-08-09T02:51Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T02:51Z | 181811.18 | tear mine-f10-1 (~$83 accrued); burn →~$400.4/h |
| 2026-08-09T02:49Z | 181865.22 | accrual (F17 king449 recover; no rm/rent; burn ~$428.4/h) |
| 2026-08-09T02:42Z | 181918.53 | tear mine-f11-1 (~$74.5 accrued); burn →~$428.4/h |
| 2026-08-09T02:38Z | 181975.32 | accrual (F21 teacher recover447; no rm/rent; burn ~$456.4/h) |
| 2026-08-09T02:32Z | 182028.07 | rent mine-f23-1 B300 @$63.60/h TTL12h COUNT=8; burn →~$456.4/h |
| 2026-08-09T02:28Z | 182077.05 | rent mine-f22-1 B300 @$63.60/h TTL12h COUNT=8; burn →~$392.8/h |
| 2026-08-09T02:19Z | 182163.72 | rent mine-f21-1 B200 @$40/h TTL12h COUNT=8; burn →~$329.2/h |
| 2026-08-09T02:16Z | 182163.72 | rent mine-f20-1 @$23.20/h TTL12h (after COUNT=2 liar tear); burn →~$289.2/h |
| 2026-08-09T02:12Z | 182202.72 | rent mine-f19-1 @$24.40/h TTL12h (after COUNT=4 liar tears); burn →~$266/h |
| 2026-08-09T02:07Z | 182240.38 | rent mine-f18-1 @$33.81/h TTL12h; burn →~$241.6/h |
