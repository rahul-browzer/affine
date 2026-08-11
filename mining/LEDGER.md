# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,194.970 | 2026-08-11T23:07Z |
| cumulative mining spend | ~$77,396 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T23:07Z |
| **available for mining** | **~$110,195** (balance − $10,000 floor) | 2026-08-11T23:07Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T23:07Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T23:07Z | 120194.970 | p2128 no rent (B300×8=0); R3b dedupe + fleet POLL=1s; burn **$180.25/h**; Δ−$20 vs p2127 |
| 2026-08-11T23:04Z | 120214.828 | p2127 no rent (B300×8=0); R3 REFUTE→R3b on r3; fleet→R7; burn **$180.25/h**; Δ−$22 vs p2126 |
| 2026-08-11T22:59Z | 120236.736 | p2126 no rent (B300×8=0); R5→R6 retarget on r4; fleet→R7; burn **$180.25/h**; Δ$0 vs p2125 |
| 2026-08-11T22:55Z | 120236.736 | p2125 no rent (B300×8=0); R3 n80 unblocked; R5 REFUTE; burn **$180.25/h**; Δ−$21 vs p2124 |
| 2026-08-11T22:49Z | 120278.512 | p2124 no rent (B300×8=0); R5 reseat+n80; R2be below→R2bf; burn **$180.25/h**; Δ−$21 vs p2123 |
| 2026-08-11T22:42Z | 120299.345 | p2123 no rent (B300×8=0); R3 visual graft+resume; R5 n80 armed; burn **$180.25/h**; Δ−$21 vs p2122 |
| 2026-08-11T22:36Z | 120320.253 | p2122 no rent (B300×8=0); R3 gocryptfs merge unstick→`/tmp`; burn **$180.25/h**; Δ−$62 vs p2121 |
| 2026-08-11T22:23Z | 120382.734 | p2121 no rent (B300×8=0); R2bf dpo2 armed; R3 merge; burn **$180.25/h**; Δ−$21 vs p2120 |
| 2026-08-11T22:18Z | 120403.598 | p2120 no rent (B300×8=0); R4b REFUTE→R5 on r4; fleet→R6; burn **$180.25/h**; Δ−$21 vs p2119 |
| 2026-08-11T22:14Z | 120424.541 | p2119 no rent (B300×8=0); crown disk purge+R2be n80; burn **$180.25/h**; Δ−$63 vs p2118 |
