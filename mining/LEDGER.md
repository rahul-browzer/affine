# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $117,795.192 | 2026-08-12T08:40Z |
| cumulative mining spend | ~$79,805 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T08:40Z |
| **available for mining** | **~$107,795** (balance − $10,000 floor) | 2026-08-12T08:40Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T08:40Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T08:40Z | 117795.192 | p2209 no rent (8×=0; burst**3557663**); R17 n80 vs guass relaunch; burn **$180.25/h**; Δ−$42 vs p2208 |
| 2026-08-12T08:29Z | 117857.915 | p2208 no rent (8×=0; burst**3557663**); R3 guass retarget armed; burn **$180.25/h**; Δ$0 vs p2207 |
| 2026-08-12T08:27Z | 117857.915 | p2207 no rent (8×=0; burst**3557663**); R4 guass retarget armed; burn **$180.25/h**; Δ$0 vs p2206 |
| 2026-08-12T08:25Z | 117857.915 | p2206 no rent (8×=0; burst**3557663**); crown king→guass; burn **$180.25/h**; Δ−$42 vs p2205 |
| 2026-08-12T08:17Z | 117899.505 | p2205 no rent (8×=0; burst**3557663** next=R25); R15 REFUTE→R24 arm; burn **$180.25/h**; Δ−$21 vs p2204 |
| 2026-08-12T08:11Z | 117920.424 | p2204 no rent (8×=0; burst**3519918**); R15 n80 launched; burn **$180.25/h**; Δ−$41 vs p2203 |
| 2026-08-12T08:02Z | 117960.998 | p2203 no rent (8×=0; burst**3519918**); R15 merge unstick→DONE; burn **$180.25/h**; Δ−$22 vs p2202 |
| 2026-08-12T07:55Z | 117983.006 | p2202 no rent yet (8×=0; burst**3519918** after p2199 TIMEOUT); burn **$180.25/h**; Δ−$21 vs p2201 |
| 2026-08-12T07:48Z | 118024.992 | p2201 no rent (8×=0; burst+waiter 429); R15 GPU-merge hang→CPU relaunch; burn **$180.25/h**; Δ−$83 vs p2200 |
| 2026-08-12T07:28Z | 118108.301 | p2200 no rent (8×=0; burst+waiter 429); R15 merge relaunch pandora BASE; burn **$180.25/h**; Δ−$21 vs p2199 |
