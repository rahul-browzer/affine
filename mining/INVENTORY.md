# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ap h44 reload · R2aq wait |

SSH: `ssh root@95.133.253.90 -p 40099`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T14:11Z | p2034: R2ao REFUTE −0.074×; Stage-5 SKIP; R2ap h44 chall loading; burn$52.25/h · bal~$121844 |
| 2026-08-11T13:43Z | p2033: TKC 200/200/200; R2ao died mid-script edit; continue_r2ao_n80 launched; burn$52.25/h · bal~$121905 |
| 2026-08-11T13:23Z | p2032: R2am REFUTE −1.39×; rescue T/K after EngCore kill; patch orphan-kill; purge blends; burn$52.25/h · bal~$121946 |
