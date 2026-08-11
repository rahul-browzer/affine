# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 (`1c4255fa-…`) | 8×B300 | $64.00 | 2026-08-11T16:12Z | TK@65536 · R2g n80 · R2i/441 · BKN/432 · sft3→asdf |

SSH: `ssh root@86.38.182.50 -p 40300`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T00:26Z | p1917: fleet=1 · R2g ~5/80; armed asdf after sft3 (@c2309815…); burn$64/h; bal~$123635 |
| 2026-08-11T00:23Z | p1916: fleet=1 · R2g chall200 + n80 pid146391; BKN6 DONE; armed sft3 prefetch; burn$64/h; bal~$123635 |
| 2026-08-11T00:21Z | p1915: fleet=1 · R2g merge DONE (Δ0.626) + chall reload pid142866; BKN6 ~48GiB; burn$64/h; bal~$123635 |
