# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,557.90 | 2026-08-11T16:34Z |
| cumulative mining spend | ~$76,030 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T16:34Z |
| **available for mining** | **~$111,558** (balance − $10,000 floor) | 2026-08-11T16:34Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T16:34Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T16:34Z | 121557.90 | p2055 R3 bootstrap launched on `mine-r3-grpo-1` (no new rent; B300×8=0); burn **$116.25/h**; Δ−$11 vs p2054 |
| 2026-08-11T16:30Z | 121568.80 | p2054 rented `mine-r3-grpo-1` 8×B300 @$64/h TTL24h (last free); burn **$116.25/h**; B300 left=0 |
| 2026-08-11T16:25Z | 121578.97 | p2052 R2at hope11 engines up + n80 ~4/80 (no new rent); burn$52.25/h; Δ−$10 vs p2051 |
| 2026-08-11T16:17Z | 121589.16 | p2051 R2as WEAK_SKIP + R2at hope11 load (no new rent); burn$52.25/h; Δ−$41 vs p2050 |
| 2026-08-11T15:57Z | 121630.02 | p2050 tt prefetch DONE + tt_chall prestage (no new rent); burn$52.25/h; Δ−$10 vs p2049 |
| 2026-08-11T15:53Z | 121640.13 | p2049 R2ax tt arm+prefetch (no new rent); burn$52.25/h; Δ−$10 vs p2048 |
| 2026-08-11T15:48Z | 121650.40 | p2048 R2as ~7/80 + v2_chall prestage (no new rent); burn$52.25/h; Δ$0 vs p2047 |
| 2026-08-11T15:46Z | 121650.40 | p2047 R2as n80 started ~1/80 (no new rent); burn$52.25/h; Δ−$10 vs p2046 |
| 2026-08-11T15:42Z | 121660.56 | p2046 R2ar SKIP_UNSERVABLE + R2as 726 load (no new rent); burn$52.25/h; Δ−$20 |
| 2026-08-11T15:32Z | 121680.79 | p2045 R2aq WEAK_SKIP + R2ar load (no new rent); burn$52.25/h; Δ−$41 |
