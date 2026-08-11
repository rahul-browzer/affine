# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,590.39 | 2026-08-11T00:42Z |
| cumulative mining spend | ~$74,006 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T00:42Z |
| **available for mining** | **~$113,590** (balance − $10,000 floor) | 2026-08-11T00:42Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T00:42Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T00:42Z | 123590.39 | p1921 sth DONE; cp200 prefetch armed (no new rent); burn$64/h; Δ−$22 vs p1920 (shared ok) |
| 2026-08-11T00:37Z | 123612.64 | p1920 R2j Talent×BKN7 armed (no new rent); burn$64/h; Δ−$11 vs p1919 (shared ok) |
| 2026-08-11T00:30Z | 123623.97 | p1919 sth prefetch armed after zeus (no new rent); burn$64/h; bal flat vs p1918 |
| 2026-08-11T00:28Z | 123623.97 | p1918 zeus prefetch armed after asdf (no new rent); burn$64/h; Δ−$11 vs p1917 (shared ok) |
| 2026-08-11T00:26Z | 123635.16 | p1917 asdf prefetch armed after sft3 (no new rent); burn$64/h; bal flat vs p1916 |
| 2026-08-11T00:23Z | 123635.16 | p1916 R2g n80 + sft3 prefetch armed (no new rent); burn$64/h; bal flat vs p1915 |
| 2026-08-11T00:21Z | 123635.16 | p1915 R2g merge DONE + chall reload (no new rent); burn$64/h; Δ−$11 vs p1914 (shared ok) |
| 2026-08-11T00:18Z | 123646.31 | p1914 BKN-six prefetch armed (no new rent); burn$64/h; bal flat vs p1913 |
| 2026-08-11T00:16Z | 123646.31 | p1913 disk cleanup dead blends (no new rent); burn$64/h; Δ−$11 vs p1912 (shared ok) |
| 2026-08-11T00:13Z | 123657.45 | p1912 chal-00440 Reason harvest + R2g merge ungated (no new rent); burn$64/h; bal flat vs p1911 |
