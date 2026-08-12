# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $119,506.338 | 2026-08-12T01:53Z |
| cumulative mining spend | ~$78,088 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T01:53Z |
| **available for mining** | **~$109,506** (balance − $10,000 floor) | 2026-08-12T01:53Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T01:53Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T01:53Z | 119506.338 | p2157 no rent (API B300/B200×8=0); R8 n80 launched; burn **$180.25/h**; Δ−$21 vs p2156 |
| 2026-08-12T01:48Z | 119527.197 | p2156 no rent (API B300/B200×8=0); R2bl Bittoby armed; burn **$180.25/h**; Δ−$21 vs p2155 |
| 2026-08-12T01:41Z | 119548.062 | p2155 no rent (API B300/B200×8=0); king retarget DONE + R2bk n80; burn **$180.25/h**; Δ−$21 vs p2154 |
| 2026-08-12T01:34Z | 119589.550 | p2154 no rent (API B300/B200×8=0); R9 post_train armed; burn **$180.25/h**; Δ−$21 vs p2153 |
| 2026-08-12T01:29Z | 119610.731 | p2153 no rent (API B300/B200×8=0); R3+R8 post→ckp333; burn **$180.25/h**; Δ$0 vs p2152 |
| 2026-08-12T01:26Z | 119610.731 | p2152 no rent (API B300/B200×8=0); reign5 retarget armed; burn **$180.25/h**; Δ−$21 vs p2151 |
| 2026-08-12T01:17Z | 119652.351 | p2151 no rent (API B300/B200×8=0); R6b REFUTE→R8 warm-arm; burn **$180.25/h**; Δ−$21 vs p2150 |
| 2026-08-12T01:12Z | 119673.238 | p2150 no rent (API B300/B200×8=0); killed dual snatcher; R6b n80~28/80; burn **$180.25/h**; Δ−$21 vs p2149 |
| 2026-08-12T01:07Z | 119694.227 | p2149 no rent (API B300/B200×8=0); R6b merge+stale-chall kill; R2bj n80~8/80; burn **$180.25/h**; Δ−$20 vs p2148 |
| 2026-08-12T01:04Z | 119713.950 | p2148 no rent (API B300/B200×8=0); R2bj reload dead→relaunched chall load; burn **$180.25/h**; Δ−$22 vs p2147 |
