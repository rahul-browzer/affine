# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,897.28 | 2026-08-11T05:55Z |
| cumulative mining spend | ~$74,696 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T05:55Z |
| **available for mining** | **~$112,897** (balance − $10,000 floor) | 2026-08-11T05:55Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T05:55Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T05:55Z | 122897.28 | p1972 armed Reason watches 468–471 + R2p Stage-5 (no new rent); burn$64/h; Δ$0 vs p1971 |
| 2026-08-11T05:52Z | 122897.28 | p1971 armed pig-after-google chal471 (no new rent); burn$64/h; Δ−$11 vs p1970 (shared ok) |
| 2026-08-11T05:50Z | 122908.43 | p1970 armed google-after-sky chal470 (no new rent); burn$64/h; Δ$0 vs p1969 (shared ok) |
| 2026-08-11T05:47Z | 122908.43 | p1969 armed sky-after-sbs chal469 (no new rent); burn$64/h; Δ−$11 vs p1968 (shared ok) |
| 2026-08-11T05:45Z | 122919.64 | p1968 armed sbs prefetch chal468 (no new rent); burn$64/h; Δ$0 vs p1967 (shared ok) |
| 2026-08-11T05:43Z | 122919.64 | p1967 R2z Talent×v9 eager + watch467 (no new rent); burn$64/h; Δ−$22 vs p1966 (shared ok) |
| 2026-08-11T05:33Z | 122941.78 | p1966 R2p n80 + awesome-v9 prefetch arm (no new rent); burn$64/h; Δ−$34 vs p1965 (shared ok) |
| 2026-08-11T05:28Z | 122975.49 | p1965 R2o REFUTE + purge + R2p chall reload (no new rent); burn$64/h; Δ−$11 vs p1964 (shared ok) |
| 2026-08-11T05:13Z | 122986.68 | p1964 R2p Talent×sth premerge + R2p gate fix (no new rent); burn$64/h; Δ−$22 vs p1963 (shared ok) |
| 2026-08-11T05:03Z | 123008.48 | p1963 R2y eager Talent×tpc9 (no new rent); burn$64/h; Δ−$23 vs p1962 (shared ok) |
