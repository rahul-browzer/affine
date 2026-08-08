# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. No pre-crown spend cap (operator 2026-08-07).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $185,666.37 | 2026-08-08T17:02Z |
| cumulative mining spend | ~$11,020 (5 pods ~$152/h accruing) | 2026-08-08T17:02Z |
| **available for mining** | **~$175,666** (balance − $10,000 floor) | 2026-08-08T17:02Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$152/h (h89/90 $28×2 + h87/88/91 $31.92×3) | 2026-08-08T17:02Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T17:02Z | 185666.37 | burn accrual; H90 n80 live + H91 train (no rent/rm) |
| 2026-08-08T16:45Z | 185739.90 | burn accrual; H90 mid304 armed (no rent/rm) |
| 2026-08-08T16:42Z | 185763.74 | burn accrual; H88+H89 n80+mid304 (no rent/rm) |
| 2026-08-08T16:35Z | 185810.45 | burn accrual; H87 mid304 + H88 recovers (no rent/rm) |
| 2026-08-08T16:31Z | 185810.45 | rent mine-h91-1 brave-shark-d2 @$31.92/h ttl12h (H91 r12) |
| 2026-08-08T16:30Z | 185810.45 | rm mine-h86-1 (spent ~$42; H86 REFUTE m=−0.000341) |
| 2026-08-08T16:24Z | 185855.94 | rent mine-h90-1 noble-shark-3c @$28.00/h ttl12h (H90 r14) |
| 2026-08-08T16:21Z | 185855.94 | rm mine-h85-1 (spent ~$50; H85 REFUTE m=−0.008170); burn accrual |
| 2026-08-08T16:09Z | 185926.97 | burn accrual; H87 teacher recover331 (no rent/rm) |
| 2026-08-08T16:05Z | 185926.97 | burn accrual; H89 train→merge→chall; H88 DL→train |
