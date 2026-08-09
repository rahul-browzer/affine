# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $180,512.50 | 2026-08-09T05:20Z |
| cumulative mining spend | ~$17,183 (11 pods ~$359.0/h accruing) | 2026-08-09T05:20Z |
| **available for mining** | **~$170,512** (balance − $10,000 floor) | 2026-08-09T05:20Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (11 pods) | ~$359.0/h | 2026-08-09T05:20Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T05:20Z | 180512.50 | tear COUNT=4 lunar-lion-a0 (~$0.2); rent mine-f35-1 B200@$40.00/h TTL12h COUNT=8; burn →~$359.0/h |
| 2026-08-09T05:11Z | 180601.10 | rent mine-f34-1 H200@$31.92/h TTL12h COUNT=8; burn →~$318.9/h |
| 2026-08-09T05:07Z | 180641.85 | tear mine-f23-1 (F23 REFUTE m=−0.08436; ~$164 accrued); rent mine-f33-1 H200@$24.40/h TTL12h COUNT=8; burn →~$287.0/h |
| 2026-08-09T04:50Z | 180777.25 | tear mine-f25-1 (F25 REFUTE m=−0.06343; ~$36 accrued); rent mine-f32-1 H200@$31.92/h TTL12h COUNT=8; burn →~$326.2/h |
| 2026-08-09T04:39Z | 180907.42 | tear mine-f17-1 (F17 REFUTE m=−0.05489; ~$83 accrued); rent mine-f31-1 H200@$31.92/h TTL12h COUNT=8; burn stays ~$318.7/h |
| 2026-08-09T04:31Z | 180951.74 | rent mine-f30-1 H200@$28.00/h TTL12h COUNT=8; burn →~$318.7/h |
| 2026-08-09T04:26Z | 180994.03 | rent mine-f29-1 H200@$28.00/h TTL12h COUNT=8; burn →~$290.7/h |
| 2026-08-09T04:21Z | 181032.86 | rent mine-f28-1 H200@$28.00/h TTL12h COUNT=8; burn →~$262.7/h |
| 2026-08-09T04:17Z | 181069.29 | rent mine-f27-1 H200@$28.00/h TTL12h COUNT=8; burn →~$234.7/h |
| 2026-08-09T04:12Z | 181104.16 | rent mine-f26-1 H200@$23.20/h TTL12h COUNT=8; burn →~$206.7/h |
