# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,751.97 | 2026-08-11T06:58Z |
| cumulative mining spend | ~$74,841 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T06:58Z |
| **available for mining** | **~$112,752** (balance − $10,000 floor) | 2026-08-11T06:58Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-11T06:58Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T06:58Z | 122751.97 | p1982 R2ae SKIP_GATED + R2af armed (no new rent); burn$64/h; Δ−$22 vs p1981 (shared ok) |
| 2026-08-11T06:52Z | 122774.27 | p1981 R2r n80 started + watch462 hist (no new rent); burn$64/h; Δ$0 vs p1980 |
| 2026-08-11T06:47Z | 122774.27 | p1980 harvested 458+R2r chall (no new rent); burn$64/h; Δ−$22 vs p1979 (shared ok) |
| 2026-08-11T06:39Z | 122796.71 | p1979 R2r eager+R2r-busy fix (no new rent); burn$64/h; Δ−$33 vs p1978 (shared ok) |
| 2026-08-11T06:25Z | 122830.21 | p1978 R2ad eager DONE (no new rent); burn$64/h; Δ−$11 vs p1977 (shared ok) |
| 2026-08-11T06:19Z | 122841.26 | p1977 armed R2ad Talent×pig (no new rent); burn$64/h; Δ−$11 vs p1976 (shared ok) |
| 2026-08-11T06:14Z | 122852.56 | p1976 armed R2ac Talent×google (no new rent); burn$64/h; Δ−$11 vs p1975 (shared ok) |
| 2026-08-11T06:09Z | 122863.77 | p1975 R2p REFUTE+purge (no new rent); burn$64/h; Δ−$11 vs p1974 (shared ok) |
| 2026-08-11T06:02Z | 122874.34 | p1974 armed R2ab Talent×sky (wait R2aa eager; no new rent); burn$64/h; Δ−$12 vs p1973 (shared ok) |
| 2026-08-11T05:59Z | 122886.14 | p1973 armed R2aa Talent×sbs eager (no new rent); burn$64/h; Δ−$11 vs p1972 (shared ok) |
