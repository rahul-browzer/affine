# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $124,406.54 | 2026-08-10T18:41Z |
| cumulative mining spend | ~$73,193 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-10T18:41Z |
| **available for mining** | **~$114,407** (balance − $10,000 floor) | 2026-08-10T18:41Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$64.00/h** (`mine-crown-1` 8×B300) | 2026-08-10T18:41Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-10T18:41Z | 124406.54 | p1874 R2 CPU premerge armed (no new rent); burn$64/h; bal flat vs p1873 |
| 2026-08-10T18:38Z | 124406.54 | p1873 R2 α-merge recipe+waiter armed (no new rent); burn$64/h; Δ−$11 vs p1872 (shared ok) |
| 2026-08-10T18:34Z | 124417.52 | p1872 R2 parent prefetch launched (no new rent); burn$64/h; bal flat vs p1871 |
| 2026-08-10T18:31Z | 124417.52 | p1871 R1b→R1c chain armed (no new rent); burn$64/h; Δ−$11 vs p1870 (shared ok) |
| 2026-08-10T18:29Z | 124428.87 | p1870 R1c EPOCHS=6 + merge waiter staged (no new rent); burn$64/h; bal flat vs p1869 |
| 2026-08-10T18:25Z | 124428.87 | p1869 R1b nsup probe+R1c filter (no new rent); burn$64/h; Δ−$22 vs p1868 (shared ok) |
| 2026-08-10T18:18Z | 124451.19 | p1868 R1b merge→n80 waiter armed (no new rent); burn$64/h; bal flat vs p1867 |
| 2026-08-10T18:15Z | 124451.19 | p1867 R1b train launched max_len=16384 (no new rent); burn$64/h; Δ−$11 vs p1866 (shared ok) |
| 2026-08-10T18:13Z | 124462.42 | p1866 R1 LoRA n80 harvest no-submit (no new rent); burn$64/h; Δ−$34 vs p1865 (shared ok) |
| 2026-08-10T17:56Z | 124495.96 | p1865 HF public quota purge+push DONE (no new rent); burn$64/h; Δ−$33 vs p1864 (shared ok) |
