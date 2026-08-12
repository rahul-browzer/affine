# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $119,902.820 | 2026-08-12T00:16Z |
| cumulative mining spend | ~$77,690 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T00:16Z |
| **available for mining** | **~$109,903** (balance − $10,000 floor) | 2026-08-12T00:16Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T00:16Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T00:16Z | 119902.820 | p2141 no rent (B300/B200×8=0); R6 train.done→merge+n80-continue; burn **$180.25/h**; Δ−$42 vs p2140 |
| 2026-08-12T00:09Z | 119944.703 | p2140 no rent (B300/B200×8=0); R2bg REFUTE; R2bh reload; burn **$180.25/h**; Δ−$42 vs p2139 |
| 2026-08-11T23:58Z | 119986.353 | p2139 no rent (B300/B200×8=0); fleet→API POST-rent; burn **$180.25/h**; Δ$0 vs p2138 |
| 2026-08-11T23:55Z | 119986.353 | p2138 no rent (B300/B200×8=0); R2bh IntoLayer armed; burn **$180.25/h**; Δ−$42 vs p2137 |
| 2026-08-11T23:49Z | 120028.046 | p2137 no rent (B300/B200×8=0); fleet→unfiltered-8x+CAP-protect; burn **$180.25/h**; Δ$0 vs p2136 |
| 2026-08-11T23:45Z | 120028.046 | p2136 no rent (B300/B200×8=0); fleet→api-http; burn **$180.25/h**; Δ−$21 vs p2135 |
| 2026-08-11T23:40Z | 120048.959 | p2135 no rent (B300/B200×8=0); rearm fleet-boot; burn **$180.25/h**; Δ−$21 vs p2134 |
| 2026-08-11T23:38Z | 120069.802 | p2134 no rent (B300/B200×8=0); fleet→ls→node-id ~1s/iter; burn **$180.25/h**; Δ−$42 vs p2133 |
| 2026-08-11T23:28Z | 120111.566 | p2133 no rent (B300/B200×8=0); R2bf REFUTE→R2bg armed; burn **$180.25/h**; Δ−$42 vs p2132 |
| 2026-08-11T23:19Z | 120153.203 | p2132 no rent (B300×8=0); skip empty B200 waves; fleet ×22 POLL=0; burn **$180.25/h**; Δ$0 vs p2131 |
