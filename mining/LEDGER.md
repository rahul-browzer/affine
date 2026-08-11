# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.
**2026-08-10:** Reason v3 — tore watch (~$28/h); rented `mine-crown-1` 8×B300 @$64/h.
**2026-08-11:** replaced bricked B300 with 8×B200 @$52.25/h (B300 sold out).

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $122,466.45 | 2026-08-11T09:06Z |
| cumulative mining spend | ~$75,125 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T09:06Z |
| **available for mining** | **~$112,466** (balance − $10,000 floor) | 2026-08-11T09:06Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (1 pod) | **$52.25/h** (`mine-crown-1` 8×B200) | 2026-08-11T09:06Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T09:06Z | 122466.45 | p2000 google DONE + R2al/watch471 armed (no new rent); burn$52.25/h; Δ−$10 vs p1999 (shared ok) |
| 2026-08-11T09:03Z | 122476.07 | p1999 sky DONE + google DL + watch469/pig-chain (no new rent); burn$52.25/h; Δ$0 vs p1998 |
| 2026-08-11T09:00Z | 122476.07 | p1998 warm TKC READY (no new rent); burn$52.25/h; Δ−$21 vs p1997 (shared ok) |
| 2026-08-11T08:55Z | 122497.00 | p1997 armed R2ak google lane (no new rent); burn$52.25/h; Δ$0 vs p1996 |
| 2026-08-11T08:51Z | 122497.00 | p1996 armed R2aj sky lane (no new rent); burn$52.25/h; Δ−$10 vs p1995 (shared ok) |
| 2026-08-11T08:48Z | 122507.19 | p1995 warm-stack restore started on gentle-orbit-bd (no new rent); burn$52.25/h; Δ−$9 vs p1994 (shared ok) |
| 2026-08-11T08:42Z | 122515.81 | p1994 rm bricked B300 + rent 8×B200@$52.25/h TTL24h; burn$52.25/h; Δ−$57 vs p1993 (shared+rent ok) |
| 2026-08-11T08:27Z | 122550.70 | p1994mid R2ai n80 on old pod (pre-brick); burn was$64/h |
| 2026-08-11T08:21Z | 122572.97 | p1993 R2ai orphan-GPU clear + chall relaunch (no new rent); burn$64/h; Δ$0 vs p1992 |
| 2026-08-11T08:18Z | 122572.97 | p1992 R2ag harvest+R2ah/R2z SKIP+R2ai arm (no new rent); burn$64/h; Δ−$33 vs p1991 (shared ok) |
