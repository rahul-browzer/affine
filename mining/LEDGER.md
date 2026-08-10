# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $123,903.44 | 2026-08-10T22:25Z |
| cumulative mining spend | ~$73,695 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T22:25Z |
| **available for mining** | **~$113,903** (balance − $10,000 floor) | 2026-08-10T22:25Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-10T22:25Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T22:25Z | 123903.44 | p1896 near-miss rescan 438/439 (no new rent); R2d n80 mid; burn$64/h; bal flat vs p1895 |
| 2026-08-10T22:20Z | 123903.44 | p1895 R1c REFUTE harvest; R2d chall reload (no new rent); burn$64/h; Δ−$123 vs p1893 (shared ok) |
| 2026-08-10T21:34Z | 124026.41 | p1893 skip weak R2/R2b/R2c; R2d→R2e after R1c (no new rent); burn$64/h; bal flat vs p1892 |
| 2026-08-10T21:27Z | 124026.41 | p1892 R2e Talent×awesome premerge DONE Δ=0.626 (no new rent); burn$64/h; Δ−$22 vs p1891 (shared ok) |
| 2026-08-10T21:16Z | 124048.74 | p1891 R2d pure awesome-v6 n80 waiter armed (no new rent); burn$64/h; Δ−$11 vs p1890 (shared ok) |
| 2026-08-10T21:13Z | 124059.93 | p1890 R2c skew premerge DONE Δ=0.009 (no new rent); burn$64/h; Δ−$11 vs p1889 (shared ok) |
| 2026-08-10T21:08Z | 124071.13 | p1889 R2c skew Tok0.25/awesome0.75 premerge+waiter armed (no new rent); burn$64/h; Δ−$11 vs p1888 (shared ok) |
| 2026-08-10T21:05Z | 124081.85 | p1888 R2b premerge DONE + vs-Tok near-miss scan (no new rent); burn$64/h; Δ−$12 vs p1887 (shared ok) |
| 2026-08-10T20:58Z | 124093.50 | p1887 nearmiss DONE stamp + R2b reload armed (no new rent); burn$64/h; Δ−$11 vs p1886 (shared ok) |
| 2026-08-10T20:54Z | 124104.64 | p1886 R2b Tok×awesome CPU premerge armed (no new rent); burn$64/h; bal flat vs p1885 |
