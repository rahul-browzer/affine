# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $125,187.31 | 2026-08-10T12:55Z |
| cumulative mining spend | ~$72,411 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T12:55Z |
| **available for mining** | **~$115,187** (balance − $10,000 floor) | 2026-08-10T12:55Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | ~$28.00/h | 2026-08-10T12:55Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T12:55Z | 125187.31 | p1835 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$54 vs p1834 (shared ok) |
| 2026-08-10T12:39Z | 125241.23 | p1834 −$50,040 vs p1833; **not** mine-* burn (shared/operator Δ); floor ok; burn~$28/h |
| 2026-08-10T12:23Z | 175281.61 | p1833 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T12:07Z | 175322.12 | p1832 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T11:51Z | 175359.87 | p1831 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T11:35Z | 175392.50 | p1830 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T11:19Z | 175417.13 | p1829 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T11:03Z | 175441.32 | p1828 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T10:47Z | 175466.19 | p1827 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
| 2026-08-10T10:32Z | 175490.68 | p1826 KING-WATCH idle; engines 200/200/200; burn~$28/h; no rent/rm |
