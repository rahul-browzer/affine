# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,221.67 | 2026-08-11T11:05Z |
| cumulative mining spend | ~$75,368 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T11:05Z |
| **available for mining** | **~$112,222** (balance − $10,000 floor) | 2026-08-11T11:05Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T11:05Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T11:05Z | 122221.67 | p2017 R2ab REFUTE + R2ac n80 + R2am EAGER (no new rent); burn$52.25/h; Δ−$20 vs p2016 (shared ok) |
| 2026-08-11T11:00Z | 122242.04 | p2016 R2am Talent×sbs-v1 EAGER armed (no new rent); burn$52.25/h; Δ−$10 vs p2015 (shared ok) |
| 2026-08-11T10:55Z | 122252.22 | p2015 R2ac↔R2ad deadlock fix (no new rent); burn$52.25/h; Δ−$10 vs p2014 (shared ok) |
| 2026-08-11T10:48Z | 122262.41 | p2014 R2al SKIP + R2ad DONE (no new rent); burn$52.25/h; Δ−$61 vs p2012 (shared ok) |
| 2026-08-11T10:16Z | 122323.62 | p2012 sbs-v1 DONE + watch480 armed (no new rent); burn$52.25/h; Δ−$10 vs p2011 (shared ok) |
| 2026-08-11T10:13Z | 122333.78 | p2011 armed sbs-v1 prefetch (no new rent); burn$52.25/h; Δ−$10 vs p2010 (shared ok) |
| 2026-08-11T10:09Z | 122344.08 | p2010 R2ad EAGER Talent×pig (no new rent); burn$52.25/h; Δ−$10 vs p2009 (shared ok) |
| 2026-08-11T10:05Z | 122353.75 | p2009 re-armed R2ad Talent×pig (no new rent); burn$52.25/h; Δ$0 vs p2008 |
| 2026-08-11T10:00Z | 122353.75 | p2008 stamped 470 + R2ac DONE (no new rent); burn$52.25/h; Δ−$21 vs p2007 (shared ok) |
| 2026-08-11T09:53Z | 122374.66 | p2007 R2ak n80 DONE hr0.641× (no new rent); burn$52.25/h; Δ−$51 vs p2006 (shared ok) |
