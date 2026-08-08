# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $184,362.58 | 2026-08-08T20:44Z |
| cumulative mining spend | ~$12,890 (5 pods ~$181/h accruing) | 2026-08-08T20:44Z |
| **available for mining** | **~$174,363** (balance − $10,000 floor) | 2026-08-08T20:44Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (5 pods) | ~$181.4/h | 2026-08-08T20:44Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T20:43Z | 184362.58 | rent mine-f6-1 H200@$28/h ttl12h (H101/F6); burn ~$181/h |
| 2026-08-08T20:38Z | 184392.88 | rm mine-f2-1 (spent ~$57; H99 REFUTE m=−0.001994); burn ~$153/h |
| 2026-08-08T20:36Z | 184395.38 | accrual (F4 train→merge; Tok DL resume; burn ~$193/h) |
| 2026-08-08T20:15Z | 184529.61 | rm mine-h95-1 (spent ~$70; H95 REFUTE m=+0.001489) |
| 2026-08-08T20:10Z | 184566.13 | accrual (no rm/rent; F2 n80+mid304; burn ~$225/h) |
| 2026-08-08T20:05Z | 184602.58 | accrual (no rm/rent; F3 n80+mid304; burn ~$225/h) |
| 2026-08-08T20:00Z | 184636.91 | accrual (no rm/rent; F3 king366 seed; burn ~$225/h) |
| 2026-08-08T19:54Z | 184711.35 | accrual (no rm/rent; H96 mid304 rearm; burn ~$225/h) |
| 2026-08-08T19:51Z | 184711.35 | accrual (no rm/rent; F3 king332 re-fire; burn ~$225/h) |
| 2026-08-08T19:47Z | 184747.35 | accrual (no rm/rent; F3 n80 armed; burn ~$225/h) |
