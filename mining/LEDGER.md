# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,684.88 | 2026-08-11T07:29Z |
| cumulative mining spend | ~$74,907 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T07:29Z |
| **available for mining** | **~$112,685** (balance − $10,000 floor) | 2026-08-11T07:29Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T07:29Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T07:29Z | 122684.88 | p1986 R2af SKIP_BOARD + chall kill (no new rent); burn$64/h; Δ−$11 vs p1985 (shared ok) |
| 2026-08-11T07:23Z | 122696.03 | p1985 R2r REFUTE harvest + whoami purge + R2af claim (no new rent); burn$64/h; Δ−$34 vs p1984 (shared ok) |
| 2026-08-11T07:05Z | 122729.63 | p1984 R2af chall pre-materialise (no new rent); burn$64/h; Δ−$22 vs p1983 (shared ok) |
| 2026-08-11T07:02Z | 122751.97 | p1983 HF Stage-5 prepurge +210.7 GiB (no new rent); burn$64/h; Δ$0 vs p1982 |
| 2026-08-11T06:58Z | 122751.97 | p1982 R2ae SKIP_GATED + R2af armed (no new rent); burn$64/h; Δ−$22 vs p1981 (shared ok) |
| 2026-08-11T06:52Z | 122774.27 | p1981 R2r n80 started + watch462 hist (no new rent); burn$64/h; Δ$0 vs p1980 |
| 2026-08-11T06:47Z | 122774.27 | p1980 harvested 458+R2r chall (no new rent); burn$64/h; Δ−$22 vs p1979 (shared ok) |
| 2026-08-11T06:39Z | 122796.71 | p1979 R2r eager+R2r-busy fix (no new rent); burn$64/h; Δ−$33 vs p1978 (shared ok) |
| 2026-08-11T06:25Z | 122830.21 | p1978 R2ad eager DONE (no new rent); burn$64/h; Δ−$11 vs p1977 (shared ok) |
| 2026-08-11T06:19Z | 122841.26 | p1977 armed R2ad Talent×pig (no new rent); burn$64/h; Δ−$11 vs p1976 (shared ok) |
