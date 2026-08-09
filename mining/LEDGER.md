# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $180,260.06 | 2026-08-09T05:55Z |
| cumulative mining spend | ~$17,435 (11 pods ~$359.0/h accruing) | 2026-08-09T05:55Z |
| **available for mining** | **~$170,260** (balance − $10,000 floor) | 2026-08-09T05:55Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (11 pods) | ~$359.0/h | 2026-08-09T05:55Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T05:55Z | 180260.06 | no rent/rm; burn ~$359.0/h (F28 king435 seed-from-chall) |
| 2026-08-09T05:51Z | 180260.06 | no rent/rm; burn ~$359.0/h (F27 n80 realpath fix) |
| 2026-08-09T05:46Z | 180302.23 | no rent/rm; burn ~$359.0/h (F28 king332 + F26 chall264 + F27 n80) |
| 2026-08-09T05:42Z | 180344.35 | no rent/rm; burn ~$359.0/h (F28 n80 + F27/F29–F31 finalize unstick) |
| 2026-08-09T05:30Z | 180428.05 | no rent/rm; burn ~$359.0/h (F26 copytree salvage + serve) |
| 2026-08-09T05:26Z | 180470.67 | no rent/rm; burn stays ~$359.0/h (F28 finalize unstick only) |
| 2026-08-09T05:20Z | 180512.50 | tear COUNT=4 lunar-lion-a0 (~$0.2); rent mine-f35-1 B200@$40.00/h TTL12h COUNT=8; burn →~$359.0/h |
| 2026-08-09T05:11Z | 180601.10 | rent mine-f34-1 H200@$31.92/h TTL12h COUNT=8; burn →~$318.9/h |
| 2026-08-09T05:07Z | 180641.85 | tear mine-f23-1 (F23 REFUTE m=−0.08436; ~$164 accrued); rent mine-f33-1 H200@$24.40/h TTL12h COUNT=8; burn →~$287.0/h |
| 2026-08-09T04:50Z | 180777.25 | tear mine-f25-1 (F25 REFUTE m=−0.06343; ~$36 accrued); rent mine-f32-1 H200@$31.92/h TTL12h COUNT=8; burn →~$326.2/h |
