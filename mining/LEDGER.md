# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $117,960.998 | 2026-08-12T08:02Z |
| cumulative mining spend | ~$79,639 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T08:02Z |
| **available for mining** | **~$107,961** (balance − $10,000 floor) | 2026-08-12T08:02Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T08:02Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T08:02Z | 117960.998 | p2203 no rent (8×=0; burst**3519918**); R15 merge unstick→DONE; burn **$180.25/h**; Δ−$22 vs p2202 |
| 2026-08-12T07:55Z | 117983.006 | p2202 no rent yet (8×=0; burst**3519918** after p2199 TIMEOUT); burn **$180.25/h**; Δ−$21 vs p2201 |
| 2026-08-12T07:48Z | 118024.992 | p2201 no rent (8×=0; burst+waiter 429); R15 GPU-merge hang→CPU relaunch; burn **$180.25/h**; Δ−$83 vs p2200 |
| 2026-08-12T07:28Z | 118108.301 | p2200 no rent (8×=0; burst+waiter 429); R15 merge relaunch pandora BASE; burn **$180.25/h**; Δ−$21 vs p2199 |
| 2026-08-12T07:24Z | 118128.989 | p2199 no rent (8×=0; burst CONT +429s); R20 empty-z fix→pid**126769**; burn **$180.25/h**; Δ−$21 vs p2198 |
| 2026-08-12T07:16Z | 118149.829 | p2198 no rent (8×=0; burst@1081 killed); R3+R4 TTL +12h; burn **$180.25/h**; Δ−$61 vs p2197 |
| 2026-08-12T07:01Z | 118211.280 | p2197 no rent (8×=0; burst1500 timeout→waiter CONT); R17 empty-z fix; burn **$180.25/h**; Δ−$22 vs p2196 |
| 2026-08-12T06:51Z | 118254.032 | p2196 no rent (8×=0; burst@1041); R16 REFUTE→R17 arm; burn **$180.25/h**; Δ−$21 vs p2195 |
| 2026-08-12T06:44Z | 118296.041 | p2195 no rent (8×=0; burst@521); HF purge 9 REFUTED; R16 push DONE; burn **$180.25/h**; Δ−$21 vs p2194 |
| 2026-08-12T06:39Z | 118316.966 | p2194 no rent yet (1500-iter burst; 8×=0); R14 REFUTE→R20 arm; R16 merge; burn **$180.25/h**; Δ−$20 vs p2193 |
