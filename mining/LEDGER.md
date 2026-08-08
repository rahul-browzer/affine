# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $184,747.35 | 2026-08-08T19:47Z |
| cumulative mining spend | ~$12,400 (6 pods ~$225/h accruing) | 2026-08-08T19:47Z |
| **available for mining** | **~$174,747** (balance − $10,000 floor) | 2026-08-08T19:47Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$225.3/h | 2026-08-08T19:47Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T19:47Z | 184747.35 | accrual (no rm/rent; F3 n80 armed; burn ~$225/h) |
| 2026-08-08T19:43Z | 184777.78 | accrual (no rm/rent; F1 king332 re-fire; burn ~$225/h) |
| 2026-08-08T19:40Z | 184820.12 | accrual (no rm/rent; F2 teacher recover; burn ~$225/h) |
| 2026-08-08T19:36Z | 184820.12 | accrual (no rm/rent; burn ~$225/h × ~6m) |
| 2026-08-08T19:22Z | 184928.91 | rm mine-h94-1 (spent ~$53; H94 REFUTE m=−0.013746) |
| 2026-08-08T19:21Z | 184929.84 | rm mine-h91-1 (spent ~$91; H91 REFUTE m=−0.005604) |
| 2026-08-08T19:19Z | 184968.46 | rent mine-f4-1 calm-wolf-30 @$63.60/h ttl12h (H100/F4 B300) |
| 2026-08-08T19:17Z | 184968.46 | rm mine-h93-1 (spent ~$62; H93 REFUTE m=−0.007210) |
| 2026-08-08T19:13Z | 185006.58 | rent mine-f2-1 zesty-orbit-85 @$40/h ttl12h (H99/F2 B200) |
| 2026-08-08T19:12Z | 185006.58 | rm mine-f2-1 zesty-orbit-24 (COUNT=7; ~$1) |
