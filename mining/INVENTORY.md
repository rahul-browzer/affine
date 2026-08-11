# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2t n80 ~3/80** + R2k…p + R2r |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T02:06Z | p1940: fleet=1 · R2t engines 200/200/200 · n80 running ~3/80; burn$64/h; bal~$123400 |
| 2026-08-11T02:03Z | p1939: fleet=1 · **R2q REFUTE** hr **−0.35×**; R2t chall reload started; burn$64/h; bal~$123411 |
| 2026-08-11T01:55Z | p1938: fleet=1 · armed **R2t** saysth×Talent Δ=**0.207** (wait R2q); R2q ~58/80; burn$64/h; bal~$123434 |
