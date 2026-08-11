# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,975.49 | 2026-08-11T05:28Z |
| cumulative mining spend | ~$74,618 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T05:28Z |
| **available for mining** | **~$112,975** (balance − $10,000 floor) | 2026-08-11T05:28Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T05:28Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T05:28Z | 122975.49 | p1965 R2o REFUTE + purge + R2p chall reload (no new rent); burn$64/h; Δ−$11 vs p1964 (shared ok) |
| 2026-08-11T05:13Z | 122986.68 | p1964 R2p Talent×sth premerge + R2p gate fix (no new rent); burn$64/h; Δ−$22 vs p1963 (shared ok) |
| 2026-08-11T05:03Z | 123008.48 | p1963 R2y eager Talent×tpc9 (no new rent); burn$64/h; Δ−$23 vs p1962 (shared ok) |
| 2026-08-11T04:54Z | 123031.48 | p1962 R2n REFUTE + R2o n80 + R2x eager (no new rent); burn$64/h; Δ−$34 vs p1961 (shared ok) |
| 2026-08-11T04:39Z | 123065.01 | p1961 R2o eager Talent×zeus + chal452 Reason+ hr0.25× (no new rent); burn$64/h; Δ−$22 vs p1960 (shared ok) |
| 2026-08-11T04:25Z | 123087.35 | p1960 R2n~25/80 + Stage-5 arm + HF prepurge +140.5 GiB (no new rent); burn$64/h; Δ−$11 vs p1959 (shared ok) |
| 2026-08-11T04:20Z | 123098.52 | p1959 R2n~13/80 + purge REFUTED HF ~281 GiB (no new rent); burn$64/h; Δ−$11 vs p1958 (shared ok) |
| 2026-08-11T04:16Z | 123109.64 | p1958 R2l REFUTE + R2n n80 start + R2l purge (no new rent); burn$64/h; Δ−$67 vs p1957 (shared ok) |
| 2026-08-11T03:49Z | 123176.77 | p1957 R2n premerge DONE + disk purge (no new rent); burn$64/h; Δ−$22 vs p1956 (shared ok) |
| 2026-08-11T03:40Z | 123199.14 | p1956 SKIP R2w board-first asdf hr0.40× (no new rent); burn$64/h; bal flat vs p1955 |
