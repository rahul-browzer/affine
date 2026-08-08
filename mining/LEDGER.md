# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $184,177.36 | 2026-08-08T21:13Z |
| cumulative mining spend | ~$13,150 (6 pods ~$213/h accruing) | 2026-08-08T21:13Z |
| **available for mining** | **~$174,177** (balance − $10,000 floor) | 2026-08-08T21:13Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$213.3/h | 2026-08-08T21:13Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T21:13Z | 184177.36 | rent mine-f9-1 H200@$31.92/h ttl12h (H104/F9); burn ~$213/h |
| 2026-08-08T21:05Z | 184209.87 | rent mine-f8-1 H200@$28/h ttl12h (H103/F8); burn ~$181/h |
| 2026-08-08T20:53Z | 184300.31 | rent mine-f7-1 H200@$28/h ttl12h (H102/F7); burn ~$153/h |
| 2026-08-08T20:50Z | 184328.20 | rm mine-f3-1 (spent ~$50; H97 REFUTE m=−0.01506); burn ~$125/h |
| 2026-08-08T20:47Z | 184330.45 | rm mine-h96-1 (spent ~$53; H96 REFUTE m=+0.00913); burn ~$153/h |
| 2026-08-08T20:43Z | 184362.58 | rent mine-f6-1 H200@$28/h ttl12h (H101/F6); burn ~$181/h |
| 2026-08-08T20:38Z | 184392.88 | rm mine-f2-1 (spent ~$57; H99 REFUTE m=−0.001994); burn ~$153/h |
| 2026-08-08T20:36Z | 184395.38 | accrual (F4 train→merge; Tok DL resume; burn ~$193/h) |
| 2026-08-08T20:15Z | 184529.61 | rm mine-h95-1 (spent ~$70; H95 REFUTE m=+0.001489) |
| 2026-08-08T20:10Z | 184566.13 | accrual (no rm/rent; F2 n80+mid304; burn ~$225/h) |
