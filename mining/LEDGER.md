# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $183,497.34 | 2026-08-08T22:50Z |
| cumulative mining spend | ~$13,915 (4 pods ~$151.5/h accruing) | 2026-08-08T22:50Z |
| **available for mining** | **~$173,497** (balance − $10,000 floor) | 2026-08-08T22:50Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | ~$151.5/h | 2026-08-08T22:50Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T22:50Z | 183497.34 | accrual (F9 n80 start + F4 cuda401; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T22:45Z | 183527.33 | accrual (F9 longwait arm; no rm/rent; burn ~$151.5/h) |
| 2026-08-08T22:42Z | 183557.62 | rm mine-f6-1 (H101 REFUTE); burn ~$151.5/h |
| 2026-08-08T22:34Z | 183623.19 | accrual (F8 longwait arm; no rm/rent; burn ~$179.5/h) |
| 2026-08-08T22:30Z | 183623.19 | accrual (F8 king332 Tok + F4 frozen chall; no rm/rent; burn ~$179.5/h) |
| 2026-08-08T22:25Z | 183688.02 | accrual (F7 watcher fix + F9 reseed; no rm/rent; burn ~$179.5/h) |
| 2026-08-08T22:20Z | 183720.55 | accrual (F4 peer-seed; no rm/rent; burn ~$179.5/h) |
| 2026-08-08T22:14Z | 183753.05 | rm mine-f1-1 (H98 REFUTE); burn ~$179.5/h |
| 2026-08-08T22:08Z | 183791.12 | accrual (F9 CPU merge recover; no rm/rent; burn ~$213/h) |
| 2026-08-08T22:05Z | 183791.12 | accrual (F4 longwait dedupe; no rm/rent; burn ~$213/h) |
