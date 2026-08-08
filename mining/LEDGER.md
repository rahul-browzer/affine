# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. No pre-crown spend cap (operator 2026-08-07).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $186,253.64 | 2026-08-08T15:00Z |
| cumulative mining spend | ~$10,265 (5 pods ~$148/h accruing) | 2026-08-08T15:00Z |
| **available for mining** | **~$176,254** (balance − $10,000 floor) | 2026-08-08T15:00Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$148/h (h84/85/86 $28×3 + h82/83 $31.92×2) | 2026-08-08T15:00Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T15:00Z | 186253.64 | rent mine-h86-1 calm-wolf-21 @$28.00/h ttl12h |
| 2026-08-08T14:59Z | 186253.64 | rm mine-h81-1 (spent ~$53; H81 REFUTE m=+0.008811) |
| 2026-08-08T14:54Z | 186279.43 | burn accrual; H84 n80+H83 n80/mid304 (no rent/rm) |
| 2026-08-08T14:43Z | 186327.21 | burn accrual; H84 mid304+king322 (no rent/rm) |
| 2026-08-08T14:40Z | 186327.21 | burn accrual; H82 n80+mid304; H83 preempt rearm (no rent/rm) |
| 2026-08-08T14:35Z | 186351.09 | rent mine-h85-1 eager-fox-a3 @$28.00/h ttl12h |
| 2026-08-08T14:33Z | 186372.59 | rm mine-h80-1 (spent ~$59; H80 REFUTE m=−0.000821) |
| 2026-08-08T14:21Z | 186422.08 | burn accrual; H81 n80 LIVE; H83 preempt rearm (no rent/rm) |
| 2026-08-08T14:08Z | 186493.50 | burn accrual; H83 train; rearm h81/h82 preempt (no rent/rm) |
| 2026-08-08T14:03Z | 186516.09 | burn accrual; H82 train→merge; H84 train (no rent/rm) |
