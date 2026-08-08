# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. No pre-crown spend cap (operator 2026-08-07).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $185,573.68 | 2026-08-08T17:20Z |
| cumulative mining spend | ~$11,200 (5 pods ~$152/h accruing) | 2026-08-08T17:22Z |
| **available for mining** | **~$175,574** (balance − $10,000 floor) | 2026-08-08T17:20Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$152/h (h88/91/93 $31.92×3 + h90/92 $28×2) | 2026-08-08T17:22Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T17:21Z | 185573.68 | rent mine-h93-1 eager-raven-1e @$31.92/h ttl12h (H93 r15) |
| 2026-08-08T17:20Z | 185573.68 | rm mine-h89-1 (spent ~$48; H89 REFUTE m=−0.007241) |
| 2026-08-08T17:16Z | 185597.46 | burn accrual; H90 retry rearm (no rent/rm) |
| 2026-08-08T17:13Z | 185619.92 | rent mine-h92-1 calm-lion-f6 @$28/h ttl12h (H92 r13) |
| 2026-08-08T17:12Z | 185619.92 | rm mine-h87-1 (spent ~$52; H87 REFUTE m=+0.005075) |
| 2026-08-08T17:10Z | 185644.81 | H90+H91 king340 recovers (no rent/rm) |
| 2026-08-08T17:06Z | 185644.81 | burn accrual; H91 king339 recover (no rent/rm) |
| 2026-08-08T17:02Z | 185666.37 | burn accrual; H90 n80 live + H91 train (no rent/rm) |
| 2026-08-08T16:45Z | 185739.90 | burn accrual; H90 mid304 armed (no rent/rm) |
| 2026-08-08T16:42Z | 185763.74 | burn accrual; H88+H89 n80+mid304 (no rent/rm) |
