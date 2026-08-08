# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. No pre-crown spend cap (operator 2026-08-07).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $186,090.00 | 2026-08-08T15:32Z |
| cumulative mining spend | ~$10,420 (5 pods ~$152/h accruing) | 2026-08-08T15:32Z |
| **available for mining** | **~$176,090** (balance − $10,000 floor) | 2026-08-08T15:32Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$152/h (h85/86 $28×2 + h83/87/88 $31.92×3) | 2026-08-08T15:32Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T15:32Z | 186090.00 | rent mine-h88-1 zesty-hawk-be @$31.92/h ttl12h |
| 2026-08-08T15:32Z | 186090.00 | rm mine-h84-1 (spent ~$36; H84 REFUTE m=−0.002423) |
| 2026-08-08T15:31Z | 186090.87 | rent mine-h87-1 swift-shark-4f @$31.92/h ttl12h |
| 2026-08-08T15:30Z | 186090.87 | rm mine-h82-1 (spent ~$64; H82 REFUTE m=−0.004388) |
| 2026-08-08T15:15Z | 186161.81 | burn accrual; H85 recover attempt1 (no rent/rm) |
| 2026-08-08T15:05Z | 186208.77 | burn accrual; H85 n80+mid304 (no rent/rm) |
| 2026-08-08T15:00Z | 186253.64 | rent mine-h86-1 calm-wolf-21 @$28.00/h ttl12h |
| 2026-08-08T14:59Z | 186253.64 | rm mine-h81-1 (spent ~$53; H81 REFUTE m=+0.008811) |
| 2026-08-08T14:54Z | 186279.43 | burn accrual; H84 n80+H83 n80/mid304 (no rent/rm) |
| 2026-08-08T14:35Z | 186351.09 | rent mine-h85-1 eager-fox-a3 @$28.00/h ttl12h |
