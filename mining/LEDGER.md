# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $119,819.501 | 2026-08-12T00:36Z |
| cumulative mining spend | ~$77,773 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T00:36Z |
| **available for mining** | **~$109,820** (balance − $10,000 floor) | 2026-08-12T00:36Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T00:36Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T00:36Z | 119819.501 | p2144 no rent (API B300/B200×8=0); R9 warm-arm crown 6–7; burn **$180.25/h**; Δ−$42 vs p2143 |
| 2026-08-12T00:29Z | 119861.152 | p2143 no rent (API B300/B200×8=0); R6 REFUTE→R6b armed; burn **$180.25/h**; Δ−$21 vs p2142 |
| 2026-08-12T00:22Z | 119881.924 | p2142 no rent (API B300/B200×8=0); R6 n80 live ~40/80; burn **$180.25/h**; Δ−$21 vs p2141 |
| 2026-08-12T00:16Z | 119902.820 | p2141 no rent (B300/B200×8=0); R6 train.done→merge+n80-continue; burn **$180.25/h**; Δ−$42 vs p2140 |
| 2026-08-12T00:09Z | 119944.703 | p2140 no rent (B300/B200×8=0); R2bg REFUTE; R2bh reload; burn **$180.25/h**; Δ−$42 vs p2139 |
| 2026-08-11T23:58Z | 119986.353 | p2139 no rent (B300/B200×8=0); fleet→API POST-rent; burn **$180.25/h**; Δ$0 vs p2138 |
| 2026-08-11T23:55Z | 119986.353 | p2138 no rent (B300/B200×8=0); R2bh IntoLayer armed; burn **$180.25/h**; Δ−$42 vs p2137 |
| 2026-08-11T23:49Z | 120028.046 | p2137 no rent (B300/B200×8=0); fleet→unfiltered-8x+CAP-protect; burn **$180.25/h**; Δ$0 vs p2136 |
| 2026-08-11T23:45Z | 120028.046 | p2136 no rent (B300/B200×8=0); fleet→api-http; burn **$180.25/h**; Δ−$21 vs p2135 |
| 2026-08-11T23:40Z | 120048.959 | p2135 no rent (B300/B200×8=0); rearm fleet-boot; burn **$180.25/h**; Δ−$21 vs p2134 |
