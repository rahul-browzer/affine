# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $181,032.86 | 2026-08-09T04:21Z |
| cumulative mining spend | ~$16,708 (7 pods ~$262.7/h accruing) | 2026-08-09T04:21Z |
| **available for mining** | **~$171,033** (balance − $10,000 floor) | 2026-08-09T04:21Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (7 pods) | ~$262.7/h | 2026-08-09T04:21Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T04:21Z | 181032.86 | rent mine-f28-1 H200@$28.00/h TTL12h COUNT=8; burn →~$262.7/h |
| 2026-08-09T04:17Z | 181069.29 | rent mine-f27-1 H200@$28.00/h TTL12h COUNT=8; burn →~$234.7/h |
| 2026-08-09T04:12Z | 181104.16 | rent mine-f26-1 H200@$23.20/h TTL12h COUNT=8; burn →~$206.7/h |
| 2026-08-09T04:08Z | 181137.02 | tear mine-f18-1 (F18 REFUTE m=−0.03010; ~$69 accrued); burn →~$183.5/h |
| 2026-08-09T04:01Z | 181172.33 | tear mine-f16-1 (F16 REFUTE m=−0.07623; ~$58 accrued); burn →~$217.3/h |
| 2026-08-09T03:55Z | 181213.04 | tear mine-f24-1 (F24 REFUTE m=−0.08673; ~$28 accrued); burn →~$245.3/h |
| 2026-08-09T03:53Z | 181253.04 | tear mine-f21-1 (F21 REFUTE m=−0.07226; ~$63 accrued); burn →~$273.3/h |
| 2026-08-09T03:28Z | 181473.00 | tear mine-f20-1 (F20 REFUTE m=−0.02975; ~$28 accrued); burn →~$313.3/h |
| 2026-08-09T03:21Z | 181519.77 | rent mine-f25-1 H200 @$24.40/h TTL12h COUNT=8; burn →~$336.5/h |
| 2026-08-09T03:15Z | 181563.22 | tear mine-f19-1 (F19 REFUTE m=−0.00611; ~$26 accrued); burn →~$312.1/h |
