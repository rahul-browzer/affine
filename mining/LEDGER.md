# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $184,928.91 | 2026-08-08T19:22Z |
| cumulative mining spend | ~$12,185 (6 pods ~$225/h accruing) | 2026-08-08T19:22Z |
| **available for mining** | **~$174,929** (balance − $10,000 floor) | 2026-08-08T19:22Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (6 pods) | ~$225.3/h | 2026-08-08T19:22Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-08T19:22Z | 184928.91 | rm mine-h94-1 (spent ~$53; H94 REFUTE m=−0.013746) |
| 2026-08-08T19:21Z | 184929.84 | rm mine-h91-1 (spent ~$91; H91 REFUTE m=−0.005604) |
| 2026-08-08T19:19Z | 184968.46 | rent mine-f4-1 calm-wolf-30 @$63.60/h ttl12h (H100/F4 B300) |
| 2026-08-08T19:17Z | 184968.46 | rm mine-h93-1 (spent ~$62; H93 REFUTE m=−0.007210) |
| 2026-08-08T19:13Z | 185006.58 | rent mine-f2-1 zesty-orbit-85 @$40/h ttl12h (H99/F2 B200) |
| 2026-08-08T19:12Z | 185006.58 | rm mine-f2-1 zesty-orbit-24 (COUNT=7; ~$1) |
| 2026-08-08T19:07Z | 185042.29 | rent mine-f1-1 brave-hawk-5a @$33.81/h ttl12h (H98/F1 RL) |
| 2026-08-08T19:02Z | 185072.37 | rent mine-f3-1 noble-raven-ff @$28/h ttl12h (H97/F3 r256) |
| 2026-08-08T18:53Z | 185133.03 | rent mine-h96-1 golden-matrix-af @$28/h ttl12h (H96 r9) |
| 2026-08-08T18:52Z | 185133.03 | rm mine-h92-1 (spent ~$47; H92 REFUTE m=+0.000618) |
