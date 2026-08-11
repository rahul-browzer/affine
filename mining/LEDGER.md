# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,556.93 | 2026-08-11T01:00Z |
| cumulative mining spend | ~$74,039 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T01:00Z |
| **available for mining** | **~$113,557** (balance − $10,000 floor) | 2026-08-11T01:00Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T01:00Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T01:00Z | 123556.93 | p1926 R2o Talent×zeus + watch-452 armed (no new rent); burn$64/h; bal flat vs p1925 |
| 2026-08-11T00:56Z | 123556.93 | p1925 R2g REFUTE + R2n Talent×asdf armed (no new rent); burn$64/h; Δ−$11 vs p1924 (shared ok) |
| 2026-08-11T00:52Z | 123567.99 | p1924 R2m Talent×cp200 + watch-456 armed (no new rent); burn$64/h; Δ−$11 vs p1923 (shared ok) |
| 2026-08-11T00:49Z | 123579.21 | p1923 R2l Talent×sft3 + watch-450 armed (no new rent); burn$64/h; Δ−$11 vs p1922 (shared ok) |
| 2026-08-11T00:46Z | 123590.39 | p1922 R2k Talent×BKN6 + watch-431 armed (no new rent); burn$64/h; bal flat vs p1921 |
| 2026-08-11T00:42Z | 123590.39 | p1921 sth DONE; cp200 prefetch armed (no new rent); burn$64/h; Δ−$22 vs p1920 (shared ok) |
| 2026-08-11T00:37Z | 123612.64 | p1920 R2j Talent×BKN7 armed (no new rent); burn$64/h; Δ−$11 vs p1919 (shared ok) |
| 2026-08-11T00:30Z | 123623.97 | p1919 sth prefetch armed after zeus (no new rent); burn$64/h; bal flat vs p1918 |
| 2026-08-11T00:28Z | 123623.97 | p1918 zeus prefetch armed after asdf (no new rent); burn$64/h; Δ−$11 vs p1917 (shared ok) |
| 2026-08-11T00:26Z | 123635.16 | p1917 asdf prefetch armed after sft3 (no new rent); burn$64/h; bal flat vs p1916 |
