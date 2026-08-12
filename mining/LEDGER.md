# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $118,128.989 | 2026-08-12T07:24Z |
| cumulative mining spend | ~$79,471 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T07:24Z |
| **available for mining** | **~$108,129** (balance − $10,000 floor) | 2026-08-12T07:24Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T07:24Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T07:24Z | 118128.989 | p2199 no rent (8×=0; burst CONT +429s); R20 empty-z fix→pid**126769**; burn **$180.25/h**; Δ−$21 vs p2198 |
| 2026-08-12T07:16Z | 118149.829 | p2198 no rent (8×=0; burst@1081 killed); R3+R4 TTL +12h; burn **$180.25/h**; Δ−$61 vs p2197 |
| 2026-08-12T07:01Z | 118211.280 | p2197 no rent (8×=0; burst1500 timeout→waiter CONT); R17 empty-z fix; burn **$180.25/h**; Δ−$22 vs p2196 |
| 2026-08-12T06:51Z | 118254.032 | p2196 no rent (8×=0; burst@1041); R16 REFUTE→R17 arm; burn **$180.25/h**; Δ−$21 vs p2195 |
| 2026-08-12T06:44Z | 118296.041 | p2195 no rent (8×=0; burst@521); HF purge 9 REFUTED; R16 push DONE; burn **$180.25/h**; Δ−$21 vs p2194 |
| 2026-08-12T06:39Z | 118316.966 | p2194 no rent yet (1500-iter burst; 8×=0); R14 REFUTE→R20 arm; R16 merge; burn **$180.25/h**; Δ−$20 vs p2193 |
| 2026-08-12T06:34Z | 118337.376 | p2193 no rent (1200-iter SKIP_PID_LOCK burst 8×=0); waiter CONT; burn **$180.25/h**; Δ−$63 vs p2192 |
| 2026-08-12T06:15Z | 118400.216 | p2192 no rent (1000-iter SKIP_PID_LOCK burst 8×=0); R16 warm-arm crown; burn **$180.25/h**; Δ−$84 vs p2191 |
| 2026-08-12T05:56Z | 118483.914 | p2191 no rent (900-iter SKIP_PID_LOCK burst 8×=0); R15 warm-arm R3; burn **$180.25/h**; Δ−$63 vs p2190 |
| 2026-08-12T05:41Z | 118546.455 | p2190 no rent (800-iter SKIP_PID_LOCK burst 8×=0); R3b REFUTE; R14 arm; burn **$180.25/h**; Δ−$63 vs p2189 |
