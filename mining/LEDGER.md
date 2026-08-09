# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $179,208.98 | 2026-08-09T08:21Z |
| cumulative mining spend | ~$18,487 (5 pods ~$126.8/h accruing) | 2026-08-09T08:21Z |
| **available for mining** | **~$169,209** (balance − $10,000 floor) | 2026-08-09T08:21Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$126.8/h | 2026-08-09T08:21Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T08:21Z | 179208.98 | rm mine-f36-1 (REFUTE m=−0.06667) + rent mine-f41-1 @$28.00/h TTL12h; burn ~$126.8/h |
| 2026-08-09T08:12Z | 179254.24 | rent mine-f40-1 8×H200 @$28.00/h TTL12h; burn ~$132.6/h |
| 2026-08-09T08:08Z | 179274.58 | rm mine-f32-1 (REFUTE m=−0.02626) + rent mine-f39-1 @$24.40/h TTL12h; burn ~$104.6/h |
| 2026-08-09T07:53Z | 179338.63 | rent mine-f38-1 8×H200 @$23.20/h TTL12h; burn ~$112.1/h |
| 2026-08-09T07:48Z | 179358.19 | rm mine-f34-1 (REFUTE m=−0.06281); burn ~$88.9/h; no rent |
| 2026-08-09T07:44Z | 179382.15 | rm mine-f22-1 (REFUTE m=−0.06273); burn ~$120.9/h; no rent |
| 2026-08-09T07:40Z | 179385.81 | rm mine-f29-1 (REFUTE m=−0.09256); burn ~$184.5/h; no rent |
| 2026-08-09T07:37Z | 179415.87 | rm mine-f35-1 (REFUTE m=−0.0843); burn ~$212.4/h; no rent |
| 2026-08-09T07:34Z | 179450.13 | rm mine-f33-1 (REFUTE m=−0.0216); burn ~$252.4/h; no rent |
| 2026-08-09T07:27Z | 179487.16 | no rent/rm; burn ~$276.8/h (F37 steps+F36 n80; accrue only) |
