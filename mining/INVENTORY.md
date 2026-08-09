# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.
**KING-WATCH: max 1 mine-* ≤$32/h.**

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-f45-1 | lunar-matrix-d4 | 8×H200 | $31.92 | 2026-08-09T21:35Z | **mine-watch-1** warm duel | H64 chall LIVE 200/200/200 |

SSH: 38.255.28.21:20099 · kh `/tmp/mine-f45.kh`.
**Free: 19**. Burn ~$31.92/h. Non-mine — **never rm**.
Lium name stays `mine-f45-1` (no rename API); role = watch.

## Dead (recent)
mine-f44-1/p538 KING-WATCH rm (n80@42/80 no margin); mine-f46-1/p538 rm (no margin);
mine-f42-1/+0.00508; mine-f40-1/−0.023; mine-f41-1/−0.012; mine-f47-1/band 2.24×;
mine-f39-1/+0.0027; mine-f38-1/−0.053; mine-f43-1/−0.0097.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-09T12:06Z | 1 | ok; king S=0.04456 idle; engines 200 + :8002=/tmp/h64_merged; TTL~9.5h no renew; burn ~$32/h |
| 2026-08-09T12:04Z | 1 | ok; H64 swap DONE :8002=/tmp/h64_merged; n_so=24; TTL~9.5h; burn ~$32/h |
| 2026-08-09T12:00Z | 1 | ok; launch H64→/tmp/h64_merged+chall swap; TTL~9.6h; burn ~$32/h |
