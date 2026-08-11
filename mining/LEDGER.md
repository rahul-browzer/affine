# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,236.736 | 2026-08-11T22:55Z |
| cumulative mining spend | ~$77,354 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T22:55Z |
| **available for mining** | **~$110,237** (balance − $10,000 floor) | 2026-08-11T22:55Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T22:55Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T22:55Z | 120236.736 | p2125 no rent (B300×8=0); R3 n80 unblocked; R5 REFUTE; burn **$180.25/h**; Δ−$21 vs p2124 |
| 2026-08-11T22:49Z | 120278.512 | p2124 no rent (B300×8=0); R5 reseat+n80; R2be below→R2bf; burn **$180.25/h**; Δ−$21 vs p2123 |
| 2026-08-11T22:42Z | 120299.345 | p2123 no rent (B300×8=0); R3 visual graft+resume; R5 n80 armed; burn **$180.25/h**; Δ−$21 vs p2122 |
| 2026-08-11T22:36Z | 120320.253 | p2122 no rent (B300×8=0); R3 gocryptfs merge unstick→`/tmp`; burn **$180.25/h**; Δ−$62 vs p2121 |
| 2026-08-11T22:23Z | 120382.734 | p2121 no rent (B300×8=0); R2bf dpo2 armed; R3 merge; burn **$180.25/h**; Δ−$21 vs p2120 |
| 2026-08-11T22:18Z | 120403.598 | p2120 no rent (B300×8=0); R4b REFUTE→R5 on r4; fleet→R6; burn **$180.25/h**; Δ−$21 vs p2119 |
| 2026-08-11T22:14Z | 120424.541 | p2119 no rent (B300×8=0); crown disk purge+R2be n80; burn **$180.25/h**; Δ−$63 vs p2118 |
| 2026-08-11T21:56Z | 120487.215 | p2118 no rent (B300×8=0); R2bd UNSERVABLE→R2be hope12; burn **$180.25/h**; Δ−$21 vs p2117 |
| 2026-08-11T21:53Z | 120507.962 | p2117 no rent (B300×8=0); R2bc UNSERVABLE→R2bd armed; burn **$180.25/h**; Δ−$21 vs p2116 |
| 2026-08-11T21:44Z | 120549.759 | p2116 no rent (B300×8=0); R4 REFUTE→R4b train; burn **$180.25/h**; Δ−$21 vs p2115 |
