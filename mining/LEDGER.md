# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 crown push — expect tear `mine-watch-1` (~$28/h) then
rent `mine-crown-1` 8×B300-class (~$60–76/h). Refresh totals from `lium balance`.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $124,759.03 | 2026-08-10T15:55Z |
| cumulative mining spend | ~$72,841 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T15:55Z |
| **available for mining** | **~$114,759** (balance − $10,000 floor) | 2026-08-10T15:55Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | ~$28.00/h | 2026-08-10T15:55Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T15:55Z | 124759.03 | p1846 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$25 vs p1845 (shared ok) |
| 2026-08-10T15:39Z | 124783.65 | p1845 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$25 vs p1844 (shared ok) |
| 2026-08-10T15:23Z | 124808.20 | p1844 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$29 vs p1843 (shared ok) |
| 2026-08-10T15:07Z | 124836.83 | p1843 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$54 vs p1842 (shared ok) |
| 2026-08-10T14:48Z | 124890.64 | p1842 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$40 vs p1841 (shared ok) |
| 2026-08-10T14:32Z | 124931.05 | p1841 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$41 vs p1840 (shared ok) |
| 2026-08-10T14:16Z | 124971.57 | p1840 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$54 vs p1839 (shared ok) |
| 2026-08-10T14:00Z | 125025.51 | p1839 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$40 vs p1838 (shared ok) |
| 2026-08-10T13:44Z | 125065.89 | p1838 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$33 vs p1837 (shared ok) |
| 2026-08-10T13:28Z | 125098.70 | p1837 KING-WATCH idle; engines 200/200/200; burn~$28/h; Δ−$48 vs p1836 (shared ok) |
