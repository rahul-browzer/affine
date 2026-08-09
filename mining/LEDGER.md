# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $178,941.68 | 2026-08-09T09:12Z |
| cumulative mining spend | ~$18,750 (7 pods ~$186.7/h accruing) | 2026-08-09T09:12Z |
| **available for mining** | **~$168,942** (balance − $10,000 floor) | 2026-08-09T09:12Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (7 pods) | ~$186.7/h | 2026-08-09T09:12Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T09:12Z | 178941.68 | no rent/rm; F41 recover (burn accruing ~$186.7/h) |
| 2026-08-09T09:04Z | 178995.78 | no rent/rm; F42 recover (burn accruing ~$186.7/h) |
| 2026-08-09T08:57Z | 179024.90 | no rent/rm; burn ~$186.7/h accruing (F37 n80 + F40 retrain) |
| 2026-08-09T08:38Z | 179135.81 | F40 recover (no rent/rm); burn ~$186.7/h accruing |
| 2026-08-09T08:34Z | 179161.05 | rm COUNT=3 f43 + rent mine-f43-1 8×H200 @$31.92/h TTL12h |
| 2026-08-09T08:26Z | 179186.37 | rent mine-f42-1 8×H200 @$28.00/h TTL12h; burn ~$154.8/h |
| 2026-08-09T08:21Z | 179208.98 | rm mine-f36-1 + rent mine-f41-1 @$28.00/h TTL12h |
| 2026-08-09T08:12Z | 179254.24 | rent mine-f40-1 8×H200 @$28.00/h TTL12h |
| 2026-08-09T08:08Z | 179274.58 | rm mine-f32-1 + rent mine-f39-1 @$24.40/h TTL12h |
| 2026-08-09T07:53Z | 179338.63 | rent mine-f38-1 8×H200 @$23.20/h TTL12h |
