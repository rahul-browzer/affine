# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $178,734.95 | 2026-08-09T09:46Z |
| cumulative mining spend | ~$18,970 (8 pods ~$223.4/h accruing) | 2026-08-09T09:47Z |
| **available for mining** | **~$168,735** (balance − $10,000 floor) | 2026-08-09T09:47Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (8 pods) | ~$223.4/h | 2026-08-09T09:47Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T09:47Z | 178734.95 | no rent/rm; F44 teacher recover (burn ~$223.4/h) |
| 2026-08-09T09:45Z | 178765.62 | rm mine-f37-1 (spent ~$61); burn ~$223.4/h |
| 2026-08-09T09:36Z | 178800.02 | rent mine-f45-1 8×H200 @$31.92/h TTL12h; burn ~$246.6/h |
| 2026-08-09T09:30Z | 178829.85 | rent mine-f44-1 8×H200 @$28.00/h TTL12h; burn ~$214.7/h |
| 2026-08-09T09:24Z | 178886.10 | no rent/rm; F40 king recover (burn accruing ~$186.7/h) |
| 2026-08-09T09:20Z | 178886.10 | no rent/rm; F41 retrain OK (burn accruing ~$186.7/h) |
| 2026-08-09T09:12Z | 178941.68 | no rent/rm; F41 recover (burn accruing ~$186.7/h) |
| 2026-08-09T09:04Z | 178995.78 | no rent/rm; F42 recover (burn accruing ~$186.7/h) |
| 2026-08-09T08:57Z | 179024.90 | no rent/rm; burn ~$186.7/h accruing (F37 n80 + F40 retrain) |
| 2026-08-09T08:38Z | 179135.81 | F40 recover (no rent/rm); burn ~$186.7/h accruing |
