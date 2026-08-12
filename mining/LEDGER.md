# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $119,401.926 | 2026-08-12T02:18Z |
| cumulative mining spend | ~$78,193 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T02:18Z |
| **available for mining** | **~$109,402** (balance − $10,000 floor) | 2026-08-12T02:18Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T02:18Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T02:18Z | 119401.926 | p2161 no rent (API 8×B300/B200=0); R7 chall-id fix→n80; burn **$180.25/h**; Δ−$21 vs p2160 |
| 2026-08-12T02:14Z | 119422.870 | p2160 no rent (API 8×B300/B200=0; only 1×); R2bk CLOSE + R2bl Bittoby; burn **$180.25/h**; Δ−$41 vs p2159 |
| 2026-08-12T02:02Z | 119463.580 | p2159 no rent (API B300/B200×8=0); R7 n80 defaults→ckp333; burn **$180.25/h**; Δ−$22 vs p2158 |
| 2026-08-12T01:58Z | 119485.605 | p2158 no rent (API B300/B200×8=0); R8 REFUTE→R7 warm-arm; burn **$180.25/h**; Δ−$21 vs p2157 |
| 2026-08-12T01:53Z | 119506.338 | p2157 no rent (API B300/B200×8=0); R8 n80 launched; burn **$180.25/h**; Δ−$21 vs p2156 |
| 2026-08-12T01:48Z | 119527.197 | p2156 no rent (API B300/B200×8=0); R2bl Bittoby armed; burn **$180.25/h**; Δ−$21 vs p2155 |
| 2026-08-12T01:41Z | 119548.062 | p2155 no rent (API B300/B200×8=0); king retarget DONE + R2bk n80; burn **$180.25/h**; Δ−$21 vs p2154 |
| 2026-08-12T01:34Z | 119589.550 | p2154 no rent (API B300/B200×8=0); R9 post_train armed; burn **$180.25/h**; Δ−$21 vs p2153 |
| 2026-08-12T01:29Z | 119610.731 | p2153 no rent (API B300/B200×8=0); R3+R8 post→ckp333; burn **$180.25/h**; Δ$0 vs p2152 |
| 2026-08-12T01:26Z | 119610.731 | p2152 no rent (API B300/B200×8=0); reign5 retarget armed; burn **$180.25/h**; Δ−$21 vs p2151 |
