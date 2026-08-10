# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.
**Pod cap: 20** (operator 2026-08-08). Burn cap $833/h.
**KING-WATCH: max 1 mine-* ≤$32/h.**

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-watch-1 | golden-wolf-bd | 8×H200 | $28.00 | 2026-08-10T19:12Z | warm duel | **READY** 200/200/200 |

SSH: 152.236.142.236:40301 · key `~/.ssh/id_ed25519` · id `c1f09303-bda8-419a-894e-d31763734766`
p1836 renew via `ea473ae7…` → TTL 13:59→19:12Z; dup `gentle-lion-75` rm same pass.
**Free: 19**. Burn ~$28.00/h. Non-mine — **never rm**.

## Dead (recent)
p1836 gentle-lion-75 (dup mine-watch-1 @$28 PENDING, no schedule) rm same pass;
p1726 eager-lion-ed (dup mine-watch-1 @$28 PENDING, no schedule) rm same pass;
p1440 cosmic-matrix-e2 (dup mine-watch-1 @ $22, no schedule) rm same pass;
mine-f45-1/lunar-matrix-d4 TTL 21:35Z natural rm (p1115); mine-f44-1/p538;
mine-f46-1/p538; mine-f42-1/+0.00508; mine-f40-1/−0.023; mine-f41-1/−0.012;
mine-f47-1/band 2.24×; mine-f39-1/+0.0027; mine-f38-1/−0.053; mine-f43-1/−0.0097.

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-10T13:28Z | 1 | p1837 ok; engines **READY** 200/200/200; king S=0.04456 idle; TTL~5.7h |
| 2026-08-10T13:12Z | 1→2→1 | p1836 renew TTL→19:12Z; rm dup gentle-lion-75; engines 200/200/200; king S=0.04456 idle |
| 2026-08-10T12:55Z | 1 | p1835 ok; engines **READY** 200/200/200; king S=0.04456 idle; TTL~1.1h |
