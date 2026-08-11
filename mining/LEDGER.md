# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,512.14 | 2026-08-11T01:19Z |
| cumulative mining spend | ~$74,084 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T01:19Z |
| **available for mining** | **~$113,512** (balance − $10,000 floor) | 2026-08-11T01:19Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T01:19Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T01:19Z | 123512.14 | p1932 disk purge r1_out+BKN7 (no new rent); burn$64/h; bal flat vs p1931 |
| 2026-08-11T01:17Z | 123512.14 | p1931 R2r Talent×whoami armed (no new rent); burn$64/h; Δ−$11 vs p1930 (shared ok) |
| 2026-08-11T01:14Z | 123523.34 | p1930 whoami prefetch+watch-458 armed (no new rent); burn$64/h; Δ−$11 vs p1929 (shared ok) |
| 2026-08-11T01:10Z | 123534.54 | p1929 R2j SKIP harvest (432 Reason−); no new rent; burn$64/h; Δ−$11 vs p1928 (shared ok) |
| 2026-08-11T01:07Z | 123545.22 | p1928 R2q pure-saysth armed after R2i…R2p (no new rent); burn$64/h; bal flat vs p1927 |
| 2026-08-11T01:03Z | 123545.22 | p1927 R2p Talent×sth + watch-455 armed (no new rent); burn$64/h; Δ−$12 vs p1926 (shared ok) |
| 2026-08-11T01:00Z | 123556.93 | p1926 R2o Talent×zeus + watch-452 armed (no new rent); burn$64/h; bal flat vs p1925 |
| 2026-08-11T00:56Z | 123556.93 | p1925 R2g REFUTE + R2n Talent×asdf armed (no new rent); burn$64/h; Δ−$11 vs p1924 (shared ok) |
| 2026-08-11T00:52Z | 123567.99 | p1924 R2m Talent×cp200 + watch-456 armed (no new rent); burn$64/h; Δ−$11 vs p1923 (shared ok) |
| 2026-08-11T00:49Z | 123579.21 | p1923 R2l Talent×sft3 + watch-450 armed (no new rent); burn$64/h; Δ−$11 vs p1922 (shared ok) |
