# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2e n80 · saysth DONE · 440 watch |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T23:11Z | p1902: fleet=1 · saysth prefetch DONE; R2e ~21/80; 440 watcher 129745; burn$64/h; bal~$123792 |
| 2026-08-10T23:06Z | p1901: fleet=1 · R2e ~7/80 + saysth prefetch 129090; burn$64/h; bal~$123803 |
| 2026-08-10T23:01Z | p1900: fleet=1 · R2e chall:8002 200 + n80 pid128291 active; burn$64/h; bal~$123825 |
