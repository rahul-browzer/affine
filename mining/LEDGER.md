# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,446.04 | 2026-08-11T09:19Z |
| cumulative mining spend | ~$75,145 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T09:19Z |
| **available for mining** | **~$112,446** (balance − $10,000 floor) | 2026-08-11T09:19Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T09:19Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T09:19Z | 122446.04 | p2004 stamped 469 hr0.459× + R2ab DONE (no new rent); burn$52.25/h; Δ$0 vs p2003 |
| 2026-08-11T09:15Z | 122446.04 | p2003 Talent DONE + R2ab eager armed (no new rent); burn$52.25/h; Δ−$20 vs p2002 (shared ok) |
| 2026-08-11T09:11Z | 122466.45 | p2002 Talent prefetch armed (no new rent); burn$52.25/h; Δ$0 vs p2001 |
| 2026-08-11T09:08Z | 122466.45 | p2001 pig DONE+chall prestage (no new rent); burn$52.25/h; Δ$0 vs p2000 |
| 2026-08-11T09:06Z | 122466.45 | p2000 google DONE + R2al/watch471 armed (no new rent); burn$52.25/h; Δ−$10 vs p1999 (shared ok) |
| 2026-08-11T09:03Z | 122476.07 | p1999 sky DONE + google DL + watch469/pig-chain (no new rent); burn$52.25/h; Δ$0 vs p1998 |
| 2026-08-11T09:00Z | 122476.07 | p1998 warm TKC READY (no new rent); burn$52.25/h; Δ−$21 vs p1997 (shared ok) |
| 2026-08-11T08:55Z | 122497.00 | p1997 armed R2ak google lane (no new rent); burn$52.25/h; Δ$0 vs p1996 |
| 2026-08-11T08:51Z | 122497.00 | p1996 armed R2aj sky lane (no new rent); burn$52.25/h; Δ−$10 vs p1995 (shared ok) |
| 2026-08-11T08:48Z | 122507.19 | p1995 warm-stack restore started on gentle-orbit-bd (no new rent); burn$52.25/h; Δ−$9 vs p1994 (shared ok) |
