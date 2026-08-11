# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,382.734 | 2026-08-11T22:23Z |
| cumulative mining spend | ~$77,208 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T22:23Z |
| **available for mining** | **~$110,383** (balance − $10,000 floor) | 2026-08-11T22:23Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T22:23Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T22:23Z | 120382.734 | p2121 no rent (B300×8=0); R2bf dpo2 armed; R3 merge; burn **$180.25/h**; Δ−$21 vs p2120 |
| 2026-08-11T22:18Z | 120403.598 | p2120 no rent (B300×8=0); R4b REFUTE→R5 on r4; fleet→R6; burn **$180.25/h**; Δ−$21 vs p2119 |
| 2026-08-11T22:14Z | 120424.541 | p2119 no rent (B300×8=0); crown disk purge+R2be n80; burn **$180.25/h**; Δ−$63 vs p2118 |
| 2026-08-11T21:56Z | 120487.215 | p2118 no rent (B300×8=0); R2bd UNSERVABLE→R2be hope12; burn **$180.25/h**; Δ−$21 vs p2117 |
| 2026-08-11T21:53Z | 120507.962 | p2117 no rent (B300×8=0); R2bc UNSERVABLE→R2bd armed; burn **$180.25/h**; Δ−$21 vs p2116 |
| 2026-08-11T21:44Z | 120549.759 | p2116 no rent (B300×8=0); R4 REFUTE→R4b train; burn **$180.25/h**; Δ−$21 vs p2115 |
| 2026-08-11T21:36Z | 120570.714 | p2115 no rent (B300×8=0); R4 n80 unblocked; burn **$180.25/h**; Δ−$21 vs p2114 |
| 2026-08-11T21:29Z | 120612.386 | p2114 no rent (B300×8=0); R2bc armed; burn **$180.25/h**; Δ$0 vs p2113 |
| 2026-08-11T21:24Z | 120633.231 | p2113 no rent (B300×8=0); R4 chall maxlen fix+n80; burn **$180.25/h**; Δ−$21 vs p2112 |
| 2026-08-11T21:20Z | 120654.010 | p2112 no rent (B300×8=0); 90s R5 burst 53 miss; burn **$180.25/h**; Δ$0 vs p2111 |
