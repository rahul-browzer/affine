# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $119,255.925 | 2026-08-12T02:52Z |
| cumulative mining spend | ~$78,340 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T02:52Z |
| **available for mining** | **~$109,256** (balance − $10,000 floor) | 2026-08-12T02:52Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T02:52Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T02:52Z | 119255.925 | p2167 no rent (API 8×=0); R11 Soft/Dead TTL-fix; burn **$180.25/h**; Δ−$21 vs p2166 |
| 2026-08-12T02:48Z | 119276.828 | p2166 no rent (API 8×=0); R2bl REFUTE; burn **$180.25/h**; Δ−$21 vs p2165 |
| 2026-08-12T02:42Z | 119297.524 | p2165 no rent (API 8×=0); kσ=2 decision writer deploy; burn **$180.25/h**; Δ−$21 vs p2164 |
| 2026-08-12T02:36Z | 119318.684 | p2164 no rent (API 8×=0); crown TTL→14:36Z; burn **$180.25/h**; Δ−$42 vs p2163 |
| 2026-08-12T02:28Z | 119360.330 | p2163 no rent (API 8×B300/B200=0; only 1×); R3b king preswap; burn **$180.25/h**; Δ−$21 vs p2162 |
| 2026-08-12T02:24Z | 119381.086 | p2162 no rent (API 8×B300/B200=0); R7 REFUTE→R11 warm; burn **$180.25/h**; Δ−$21 vs p2161 |
| 2026-08-12T02:18Z | 119401.926 | p2161 no rent (API 8×B300/B200=0); R7 chall-id fix→n80; burn **$180.25/h**; Δ−$21 vs p2160 |
| 2026-08-12T02:14Z | 119422.870 | p2160 no rent (API 8×B300/B200=0; only 1×); R2bk CLOSE + R2bl Bittoby; burn **$180.25/h**; Δ−$41 vs p2159 |
| 2026-08-12T02:02Z | 119463.580 | p2159 no rent (API B300/B200×8=0); R7 n80 defaults→ckp333; burn **$180.25/h**; Δ−$22 vs p2158 |
| 2026-08-12T01:58Z | 119485.605 | p2158 no rent (API B300/B200×8=0); R8 REFUTE→R7 warm-arm; burn **$180.25/h**; Δ−$21 vs p2157 |
