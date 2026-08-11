# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ay done; R2az n80 ~79/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥50 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r16 | 8×B300 | ~$64 | rent pid**2305504** + boot pid**2305505** | R4–R16 auto-boot (target 25) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T19:52Z | p2089: R16 golden-RL uploader+fleet-boot; rent/boot pids **2305504/2305505**; R2az~79/80; R3≥50; B300×8=0; burn $116.25/h |
| 2026-08-11T19:49Z | p2088: R15 pandora-RL uploader+fleet-boot; rent/boot pids **2296322/2296323**; R2az~73/80; R3≥48; B300×8=0; burn $116.25/h |
| 2026-08-11T19:44Z | p2087: R14 kevin-RL uploader+fleet-boot; rent/boot pids **2289003/2288998**; R2az~60/80; R3≥43; B300×8=0; burn $116.25/h |
