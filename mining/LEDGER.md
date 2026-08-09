# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $180,777.25 | 2026-08-09T04:50Z |
| cumulative mining spend | ~$16,963 (9 pods ~$326.2/h accruing) | 2026-08-09T04:50Z |
| **available for mining** | **~$170,777** (balance − $10,000 floor) | 2026-08-09T04:50Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (9 pods) | ~$326.2/h | 2026-08-09T04:50Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T04:50Z | 180777.25 | tear mine-f25-1 (F25 REFUTE m=−0.06343; ~$36 accrued); rent mine-f32-1 H200@$31.92/h TTL12h COUNT=8; burn →~$326.2/h |
| 2026-08-09T04:39Z | 180907.42 | tear mine-f17-1 (F17 REFUTE m=−0.05489; ~$83 accrued); rent mine-f31-1 H200@$31.92/h TTL12h COUNT=8; burn stays ~$318.7/h |
| 2026-08-09T04:31Z | 180951.74 | rent mine-f30-1 H200@$28.00/h TTL12h COUNT=8; burn →~$318.7/h |
| 2026-08-09T04:26Z | 180994.03 | rent mine-f29-1 H200@$28.00/h TTL12h COUNT=8; burn →~$290.7/h |
| 2026-08-09T04:21Z | 181032.86 | rent mine-f28-1 H200@$28.00/h TTL12h COUNT=8; burn →~$262.7/h |
| 2026-08-09T04:17Z | 181069.29 | rent mine-f27-1 H200@$28.00/h TTL12h COUNT=8; burn →~$234.7/h |
| 2026-08-09T04:12Z | 181104.16 | rent mine-f26-1 H200@$23.20/h TTL12h COUNT=8; burn →~$206.7/h |
| 2026-08-09T04:08Z | 181137.02 | tear mine-f18-1 (F18 REFUTE m=−0.03010; ~$69 accrued); burn →~$183.5/h |
| 2026-08-09T04:01Z | 181172.33 | tear mine-f16-1 (F16 REFUTE m=−0.07623; ~$58 accrued); burn →~$217.3/h |
| 2026-08-09T03:55Z | 181213.04 | tear mine-f24-1 (F24 REFUTE m=−0.08673; ~$28 accrued); burn →~$245.3/h |
