# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK+LoRA@65536 · n80 ~22/80 + HF public push |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-10T17:45Z | p1864: fleet=1 · n80 chall22/king21; HF private push failed→delete h5b-merged+public relaunch; burn$64/h; bal~$124529 |
| 2026-08-10T17:42Z | p1863: fleet=1 · n80 chall15/king16 + HF push 65.4GiB started; burn$64/h; bal~$124529 |
| 2026-08-10T17:39Z | p1862: fleet=1 · LoRA n80 alive chall4/king6 @65536; burn$64/h; bal~$124541 |
