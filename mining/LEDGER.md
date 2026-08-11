# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,646.31 | 2026-08-11T00:18Z |
| cumulative mining spend | ~$73,951 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T00:18Z |
| **available for mining** | **~$113,646** (balance − $10,000 floor) | 2026-08-11T00:18Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T00:18Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T00:18Z | 123646.31 | p1914 BKN-six prefetch armed (no new rent); burn$64/h; bal flat vs p1913 |
| 2026-08-11T00:16Z | 123646.31 | p1913 disk cleanup dead blends (no new rent); burn$64/h; Δ−$11 vs p1912 (shared ok) |
| 2026-08-11T00:13Z | 123657.45 | p1912 chal-00440 Reason harvest + R2g merge ungated (no new rent); burn$64/h; bal flat vs p1911 |
| 2026-08-11T00:10Z | 123657.45 | p1911 R2h harvest REFUTE + BKN watch armed (no new rent); burn$64/h; Δ−$34 vs p1910 (shared ok) |
| 2026-08-10T23:56Z | 123691.04 | p1910 BKN seven prefetch armed (no new rent); burn$64/h; Δ−$11 vs p1909 (shared ok) |
| 2026-08-10T23:53Z | 123702.22 | p1909 R2i reload→n80 waiter armed (no new rent); burn$64/h; bal flat vs p1908 |
| 2026-08-10T23:50Z | 123702.22 | p1908 R2i/441 watcher+premerge armed (no new rent); burn$64/h; Δ−$11 vs p1907 (shared ok) |
| 2026-08-10T23:47Z | 123713.36 | p1907 thompsville chal-00441 prefetch armed (no new rent); burn$64/h; Δ−$11 vs p1906 (shared ok) |
| 2026-08-10T23:45Z | 123724.56 | p1906 R2e harvest REFUTE + R2h n80 launch (no new rent); burn$64/h; Δ−$56 vs p1905 (shared ok) |
| 2026-08-10T23:20Z | 123780.45 | p1905 R2h TTK n80 waiter armed + R2g rearmed (no new rent); burn$64/h; bal flat vs p1904 |
