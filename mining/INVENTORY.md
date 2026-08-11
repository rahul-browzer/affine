# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · **R2v n80** · stage5-push · R2w · bridges |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T03:01Z | p1948: fleet=1 · **stage5-push armed** + asdf_chall pre-staged; R2v~32/80; burn$64/h; bal~$123289 |
| 2026-08-11T02:57Z | p1947: fleet=1 · **R2w pure-asdf armed** (wait R2v) + bridge→R2n; burn$64/h; bal~$123300 |
| 2026-08-11T02:53Z | p1946: fleet=1 · **R2v~12/80** + **bridge_r2v_to_r2l** armed; burn$64/h; bal~$123300 |
