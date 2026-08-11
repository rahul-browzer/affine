# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2az REFUTE; **R2ba** awesome-v10 n80 live |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥62 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r17 | 8×B300 | ~$64 | rent pid**2321516** + boot pid**2321517** | R4–R17 auto-boot (target 25) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T19:59Z | p2091: R17 coder-RL uploader+fleet-boot; rent/boot pids **2321516/2321517**; R2ba n80 live; R3≥62; B300×8=0; burn $116.25/h |
| 2026-08-11T19:56Z | p2090: R2az REFUTE m≈0; **R2ba** awesome-v10 armed (pids 186429/186430/186561); R3≥57; B300×8=0; burn $116.25/h |
| 2026-08-11T19:52Z | p2089: R16 golden-RL uploader+fleet-boot; rent/boot pids **2305504/2305505**; R2az~79/80; R3≥50; B300×8=0; burn $116.25/h |
