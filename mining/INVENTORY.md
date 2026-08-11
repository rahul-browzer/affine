# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2r n80 ~6–8/80** · R2x–ad eager |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T06:52Z | p1981: fleet=1 · R2r chall:8002 up · n80 gathering · watch462 hist fast-path · burn$64/h · bal~$122774 |
| 2026-08-11T06:47Z | p1980: fleet=1 · harvested 458 whoami Reason+ 0.39× · R2r premerge+chall loading · Stage-5 armed · burn$64/h · bal~$122774 |
| 2026-08-11T06:39Z | p1979: fleet=1 · purged asdf/zeus/sth/cp200 (~266 GiB) · **R2r eager DONE** Δ0.671 · fixed R2x–ad R2r always-busy · burn$64/h · bal~$122797 |
