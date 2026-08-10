# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,702.22 | 2026-08-10T23:50Z |
| cumulative mining spend | ~$73,895 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T23:50Z |
| **available for mining** | **~$113,702** (balance − $10,000 floor) | 2026-08-10T23:50Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-10T23:50Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T23:50Z | 123702.22 | p1908 R2i/441 watcher+premerge armed (no new rent); burn$64/h; Δ−$11 vs p1907 (shared ok) |
| 2026-08-10T23:47Z | 123713.36 | p1907 thompsville chal-00441 prefetch armed (no new rent); burn$64/h; Δ−$11 vs p1906 (shared ok) |
| 2026-08-10T23:45Z | 123724.56 | p1906 R2e harvest REFUTE + R2h n80 launch (no new rent); burn$64/h; Δ−$56 vs p1905 (shared ok) |
| 2026-08-10T23:20Z | 123780.45 | p1905 R2h TTK n80 waiter armed + R2g rearmed (no new rent); burn$64/h; bal flat vs p1904 |
| 2026-08-10T23:17Z | 123780.45 | p1904 R2g reload→n80 waiter armed (no new rent); burn$64/h; Δ−$11 vs p1903 (shared ok) |
| 2026-08-10T23:14Z | 123791.64 | p1903 R2g Talent×saysth waiter armed (no new rent); burn$64/h; bal flat vs p1902 |
| 2026-08-10T23:11Z | 123791.64 | p1902 saysth prefetch DONE + 440 watcher (no new rent); burn$64/h; Δ−$11 vs p1901 (shared ok) |
| 2026-08-10T23:06Z | 123802.87 | p1901 parent scan + saysth prefetch (no new rent); burn$64/h; Δ−$22 vs p1900 (shared ok) |
| 2026-08-10T23:01Z | 123825.21 | p1900 R2e chall:8002 healthy + n80 launched (no new rent); burn$64/h; bal flat vs p1899 |
| 2026-08-10T22:57Z | 123825.21 | p1899 R2d n80 DONE hr=0.22×; R2e chall reload (no new rent); burn$64/h; Δ−$45 vs p1898 (shared ok) |
