# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,456.26 | 2026-08-11T01:45Z |
| cumulative mining spend | ~$74,139 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T01:45Z |
| **available for mining** | **~$113,456** (balance − $10,000 floor) | 2026-08-11T01:45Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T01:45Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T01:45Z | 123456.26 | p1937 R2s WEAK_SKIP + purge (no new rent); burn$64/h; Δ−$11 vs p1936 (shared ok) |
| 2026-08-11T01:39Z | 123467.42 | p1936 R2s saysth×awesome armed + R2g purge (no new rent); burn$64/h; bal flat vs p1935 |
| 2026-08-11T01:34Z | 123478.50 | p1935 R2i SKIP_UNSERVABLE 441 + thomp purge (no new rent); burn$64/h; Δ−$11 vs p1934 (shared ok) |
| 2026-08-11T01:31Z | 123489.79 | p1934 R2q chall healthy → n80 running (no new rent); burn$64/h; Δ−$11 vs p1933 (shared ok) |
| 2026-08-11T01:23Z | 123500.96 | p1933 R2q unblocked → pure-saysth chall reload (no new rent); burn$64/h; Δ−$11 vs p1932 (shared ok) |
| 2026-08-11T01:19Z | 123512.14 | p1932 disk purge r1_out+BKN7 (no new rent); burn$64/h; bal flat vs p1931 |
| 2026-08-11T01:17Z | 123512.14 | p1931 R2r Talent×whoami armed (no new rent); burn$64/h; Δ−$11 vs p1930 (shared ok) |
| 2026-08-11T01:14Z | 123523.34 | p1930 whoami prefetch+watch-458 armed (no new rent); burn$64/h; Δ−$11 vs p1929 (shared ok) |
| 2026-08-11T01:10Z | 123534.54 | p1929 R2j SKIP harvest (432 Reason−); no new rent; burn$64/h; Δ−$11 vs p1928 (shared ok) |
| 2026-08-11T01:07Z | 123545.22 | p1928 R2q pure-saysth armed after R2i…R2p (no new rent); burn$64/h; bal flat vs p1927 |
