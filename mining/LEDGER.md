# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $184,395.38 | 2026-08-08T20:36Z |
| cumulative mining spend | ~$12,800 (5 pods ~$193/h accruing) | 2026-08-08T20:36Z |
| **available for mining** | **~$174,395** (balance − $10,000 floor) | 2026-08-08T20:36Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$193.4/h | 2026-08-08T20:36Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T20:36Z | 184395.38 | accrual (F4 train→merge; Tok DL resume; burn ~$193/h) |
| 2026-08-08T20:15Z | 184529.61 | rm mine-h95-1 (spent ~$70; H95 REFUTE m=+0.001489) |
| 2026-08-08T20:10Z | 184566.13 | accrual (no rm/rent; F2 n80+mid304; burn ~$225/h) |
| 2026-08-08T20:05Z | 184602.58 | accrual (no rm/rent; F3 n80+mid304; burn ~$225/h) |
| 2026-08-08T20:00Z | 184636.91 | accrual (no rm/rent; F3 king366 seed; burn ~$225/h) |
| 2026-08-08T19:54Z | 184711.35 | accrual (no rm/rent; H96 mid304 rearm; burn ~$225/h) |
| 2026-08-08T19:51Z | 184711.35 | accrual (no rm/rent; F3 king332 re-fire; burn ~$225/h) |
| 2026-08-08T19:47Z | 184747.35 | accrual (no rm/rent; F3 n80 armed; burn ~$225/h) |
| 2026-08-08T19:43Z | 184777.78 | accrual (no rm/rent; F1 king332 re-fire; burn ~$225/h) |
| 2026-08-08T19:40Z | 184820.12 | accrual (no rm/rent; F2 teacher recover; burn ~$225/h) |
