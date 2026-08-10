# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $124,652.41 | 2026-08-10T16:49Z |
| cumulative mining spend | ~$72,948 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T16:49Z |
| **available for mining** | **~$114,652** (balance − $10,000 floor) | 2026-08-10T16:49Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-10T16:49Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T16:49Z | 124652.41 | p1857 R1 LoRA train launched GPUs6–7 (no new rent); burn$64/h; bal flat vs p1856 |
| 2026-08-10T16:47Z | 124652.41 | p1856 R1 SFT join+peft staged (no new rent); burn$64/h; Δ−$22 vs p1855 (shared ok) |
| 2026-08-10T16:44Z | 124674.81 | p1855 R1 high_reason harvest staged (no new rent); burn$64/h; Δ−$11 vs p1854 (shared ok) |
| 2026-08-10T16:38Z | 124685.85 | p1854 n80 progressing + mine.env export fix (no new rent); burn$64/h; bal flat vs p1853 |
| 2026-08-10T16:33Z | 124685.85 | p1853 watcher relaunch→engines 200 + n80 H64 sim (no new rent); burn$64/h; Δ−$11 vs p1852 (shared ok) |
| 2026-08-10T16:29Z | 124697.15 | p1852 restore relaunch+vLLM serve after mid-edit crash (no new rent); burn$64/h; bal flat vs p1851 |
| 2026-08-10T16:25Z | 124697.15 | p1851 B300 flash+Tok preprocessor pre-serve (no new rent); burn$64/h; Δ−$11 vs p1850 (shared ok) |
| 2026-08-10T16:21Z | 124708.31 | p1850 installed pandas/pyarrow on crown (no new rent); burn$64/h; Δ−$11 vs p1849 (shared ok) |
| 2026-08-10T16:18Z | 124719.47 | p1849 Reason harness+corpus+watcher (no new rent); burn$64/h; Δ−$6 vs p1848 (shared ok) |
| 2026-08-10T16:14Z | 124725.26 | p1848 mine-crown-1 bootstrap launched (no new rent); burn$64/h; bal flat vs p1847 |
