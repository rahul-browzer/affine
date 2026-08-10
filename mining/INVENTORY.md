# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.
**KING-WATCH: max 1 mine-* ≤$32/h.**

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-watch-1 | golden-wolf-bd | 8×H200 | $28.00 | 2026-08-10T08:50Z | warm duel | **READY** 200/200/200 |

SSH: 152.236.142.236:40301 · key `~/.ssh/id_ed25519` · id `c1f09303-bda8-419a-894e-d31763734766`
Catalog was `37b3ea5c…` lunar-eagle-9e · COUNT=8 verified.
**Free: 19**. Burn ~$28.00/h. Non-mine — **never rm**.

## Dead (recent)
p1440 cosmic-matrix-e2 (dup mine-watch-1 @ $22, no schedule) rm same pass;
mine-f45-1/lunar-matrix-d4 TTL 21:35Z natural rm (p1115); mine-f44-1/p538;
mine-f46-1/p538; mine-f42-1/+0.00508; mine-f40-1/−0.023; mine-f41-1/−0.012;
mine-f47-1/band 2.24×; mine-f39-1/+0.0027; mine-f38-1/−0.053; mine-f43-1/−0.0097.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-10T06:36Z | 1 | p1649 ok; engines **READY** 200/200/200; king S=0.04456 idle; TTL~2.2h |
| 2026-08-10T06:35Z | 1 | p1648 ok; engines **READY** 200/200/200; king S=0.04456 idle; TTL~2.2h |
| 2026-08-10T06:34Z | 1 | p1647 ok; engines **READY** 200/200/200; king S=0.04456 idle; TTL~2.25h |
