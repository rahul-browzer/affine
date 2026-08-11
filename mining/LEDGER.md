# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,048.959 | 2026-08-11T23:40Z |
| cumulative mining spend | ~$77,543 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T23:40Z |
| **available for mining** | **~$110,049** (balance − $10,000 floor) | 2026-08-11T23:40Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T23:40Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T23:40Z | 120048.959 | p2135 no rent (B300/B200×8=0); rearm fleet-boot; burn **$180.25/h**; Δ−$21 vs p2134 |
| 2026-08-11T23:38Z | 120069.802 | p2134 no rent (B300/B200×8=0); fleet→ls→node-id ~1s/iter; burn **$180.25/h**; Δ−$42 vs p2133 |
| 2026-08-11T23:28Z | 120111.566 | p2133 no rent (B300/B200×8=0); R2bf REFUTE→R2bg armed; burn **$180.25/h**; Δ−$42 vs p2132 |
| 2026-08-11T23:19Z | 120153.203 | p2132 no rent (B300×8=0); skip empty B200 waves; fleet ×22 POLL=0; burn **$180.25/h**; Δ$0 vs p2131 |
| 2026-08-11T23:15Z | 120153.203 | p2131 no rent (B300×8=0); fleet parallel×16+86400iters; burn **$180.25/h**; Δ−$21 vs p2130 |
| 2026-08-11T23:13Z | 120174.080 | p2130 no rent (B300×8=0); fleet→**parallel×8**; burn **$180.25/h**; Δ$0 vs p2129 |
| 2026-08-11T23:11Z | 120174.080 | p2129 no rent (B300×8=0); fleet→**parallel×4**; burn **$180.25/h**; Δ−$21 vs p2128 |
| 2026-08-11T23:07Z | 120194.970 | p2128 no rent (B300×8=0); R3b dedupe + fleet POLL=1s; burn **$180.25/h**; Δ−$20 vs p2127 |
| 2026-08-11T23:04Z | 120214.828 | p2127 no rent (B300×8=0); R3 REFUTE→R3b on r3; fleet→R7; burn **$180.25/h**; Δ−$22 vs p2126 |
| 2026-08-11T22:59Z | 120236.736 | p2126 no rent (B300×8=0); R5→R6 retarget on r4; fleet→R7; burn **$180.25/h**; Δ$0 vs p2125 |
