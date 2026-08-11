# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $121,578.97 | 2026-08-11T16:25Z |
| cumulative mining spend | ~$76,009 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T16:25Z |
| **available for mining** | **~$111,579** (balance − $10,000 floor) | 2026-08-11T16:25Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T16:25Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T16:25Z | 121578.97 | p2052 R2at hope11 engines up + n80 ~4/80 (no new rent); burn$52.25/h; Δ−$10 vs p2051 (shared ok) |
| 2026-08-11T16:17Z | 121589.16 | p2051 R2as WEAK_SKIP + R2at hope11 load (no new rent); burn$52.25/h; Δ−$41 vs p2050 (shared ok) |
| 2026-08-11T15:57Z | 121630.02 | p2050 tt prefetch DONE + tt_chall prestage (no new rent); burn$52.25/h; Δ−$10 vs p2049 (shared ok) |
| 2026-08-11T15:53Z | 121640.13 | p2049 R2ax tt arm+prefetch (no new rent); burn$52.25/h; Δ−$10 vs p2048 (shared ok) |
| 2026-08-11T15:48Z | 121650.40 | p2048 R2as ~7/80 + v2_chall prestage (no new rent); burn$52.25/h; Δ$0 vs p2047 |
| 2026-08-11T15:46Z | 121650.40 | p2047 R2as n80 started ~1/80 (no new rent); burn$52.25/h; Δ−$10 vs p2046 (shared ok) |
| 2026-08-11T15:42Z | 121660.56 | p2046 R2ar SKIP_UNSERVABLE + R2as 726 load (no new rent); burn$52.25/h; Δ−$20 vs p2045 (shared ok) |
| 2026-08-11T15:32Z | 121680.79 | p2045 R2aq WEAK_SKIP + R2ar load (no new rent); burn$52.25/h; Δ−$41 vs p2044 (shared ok) |
| 2026-08-11T15:11Z | 121721.78 | p2044 R2aw mt1 SKIP_UNSERVABLE (no prefetch/rent); burn$52.25/h; Δ−$10 vs p2043 (shared ok) |
| 2026-08-11T15:08Z | 121732.00 | p2043 arm R2av pure-v2+prefetch (no new rent); burn$52.25/h; Δ−$10 vs p2042 (shared ok) |
