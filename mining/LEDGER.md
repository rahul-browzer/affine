# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $124,104.64 | 2026-08-10T20:54Z |
| cumulative mining spend | ~$73,494 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T20:54Z |
| **available for mining** | **~$114,105** (balance − $10,000 floor) | 2026-08-10T20:54Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-10T20:54Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T20:54Z | 124104.64 | p1886 R2b Tok×awesome CPU premerge armed (no new rent); burn$64/h; bal flat vs p1885 |
| 2026-08-10T20:52Z | 124104.64 | p1885 nearmiss prefetch armed (no new rent); burn$64/h; Δ−$11 vs p1884 (shared ok) |
| 2026-08-10T20:49Z | 124115.79 | p1884 R2 waiter pidfile-gate fix/relaunch (no new rent); burn$64/h; bal flat vs p1883 |
| 2026-08-10T20:46Z | 124115.79 | p1883 HF purge 6 legacy merges (~423GiB; no new rent); burn$64/h; Δ−$11 vs p1882 (shared ok) |
| 2026-08-10T20:42Z | 124127.05 | p1882 R1b n80#2 harvest REFUTE (no new rent); burn$64/h; Δ−$45 vs p1881 (shared ok) |
| 2026-08-10T20:21Z | 124171.76 | p1881 R1c merge waiter armed + R1b-dec gate (no new rent); burn$64/h; Δ−$11 vs p1880 (shared ok) |
| 2026-08-10T20:18Z | 124182.89 | p1880 R1c train overlap launch (no new rent); burn$64/h; Δ−$11 vs p1879 (shared ok) |
| 2026-08-10T20:14Z | 124194.09 | p1879 R1b n80 ReadTimeout recovery + relaunch (no new rent); burn$64/h; Δ−$56 vs p1878 (shared ok) |
| 2026-08-10T19:46Z | 124249.93 | p1878 R1b merge+n80 harvest (no new rent); burn$64/h; Δ−$78 vs p1876 (shared ok) |
| 2026-08-10T19:13Z | 124328.25 | p1876 R2 premerge harvest (no new rent); burn$64/h; Δ−$67 vs p1875 (shared ok) |
