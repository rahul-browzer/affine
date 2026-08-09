# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $179,382.15 | 2026-08-09T07:44Z |
| cumulative mining spend | ~$18,314 (4 pods ~$120.9/h accruing) | 2026-08-09T07:44Z |
| **available for mining** | **~$169,382** (balance − $10,000 floor) | 2026-08-09T07:44Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | ~$120.9/h | 2026-08-09T07:44Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T07:44Z | 179382.15 | rm mine-f22-1 (REFUTE m=−0.06273); burn ~$120.9/h; no rent |
| 2026-08-09T07:40Z | 179385.81 | rm mine-f29-1 (REFUTE m=−0.09256); burn ~$184.5/h; no rent |
| 2026-08-09T07:37Z | 179415.87 | rm mine-f35-1 (REFUTE m=−0.0843); burn ~$212.4/h; no rent |
| 2026-08-09T07:34Z | 179450.13 | rm mine-f33-1 (REFUTE m=−0.0216); burn ~$252.4/h; no rent |
| 2026-08-09T07:27Z | 179487.16 | no rent/rm; burn ~$276.8/h (F37 steps+F36 n80; accrue only) |
| 2026-08-09T07:22Z | 179522.30 | no rent/rm; burn ~$276.8/h (F37 train launch; accrue only) |
| 2026-08-09T07:19Z | 179557.45 | no rent/rm; burn ~$276.8/h (F36 salvage; accrue only) |
| 2026-08-09T07:08Z | 179627.61 | rent mine-f37-1 8×H200 @$23.20/h TTL12h; burn ~$276.8/h |
| 2026-08-09T07:02Z | 179659.36 | no rent/rm; burn ~$253.6/h (F29 watcher fix; accrue only) |
| 2026-08-09T06:57Z | 179694.33 | rm mine-f26+f27+f31 (REFUTE); burn ~$253.6/h; no rent |
