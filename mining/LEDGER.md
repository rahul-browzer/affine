# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $181,519.77 | 2026-08-09T03:21Z |
| cumulative mining spend | ~$16,240 (9 pods ~$336.5/h accruing) | 2026-08-09T03:21Z |
| **available for mining** | **~$171,520** (balance − $10,000 floor) | 2026-08-09T03:21Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (9 pods) | ~$336.5/h | 2026-08-09T03:21Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T03:21Z | 181519.77 | rent mine-f25-1 H200 @$24.40/h TTL12h COUNT=8; burn →~$336.5/h |
| 2026-08-09T03:15Z | 181563.22 | tear mine-f19-1 (F19 REFUTE m=−0.00611; ~$26 accrued); burn →~$312.1/h |
| 2026-08-09T03:10Z | 181609.05 | tear mine-f13-1 (F13 REFUTE m=−0.07293; ~$92 accrued); burn →~$336.5/h |
| 2026-08-09T03:04Z | 181702.88 | accrual (F16 teacher453; F21 n80; no rm/rent; burn ~$368.5/h) |
| 2026-08-09T03:01Z | 181702.88 | tear mine-f14-1+f15-1 (F14/F15 REFUTE); burn →~$368.5/h |
| 2026-08-09T02:54Z | 181811.18 | rent mine-f24-1 H200 @$28/h TTL12h COUNT=8; burn →~$428.4/h |
| 2026-08-09T02:51Z | 181811.18 | tear mine-f10-1 (~$83 accrued); burn →~$400.4/h |
| 2026-08-09T02:49Z | 181865.22 | accrual (F17 king449 recover; no rm/rent; burn ~$428.4/h) |
| 2026-08-09T02:42Z | 181918.53 | tear mine-f11-1 (~$74.5 accrued); burn →~$428.4/h |
| 2026-08-09T02:38Z | 181975.32 | accrual (F21 teacher recover447; no rm/rent; burn ~$456.4/h) |
