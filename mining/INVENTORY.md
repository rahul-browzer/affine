# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ay n80 + R2az + v10 cached |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥11 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r10 | 8×B300 | ~$64 | rent pid2146782 + boot pid**2221996** | R4–R8 auto-boot; R9+ stamp-only |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T19:12Z | p2077: R8 uploader+fleet-boot (pid2221996); B300×8=0; burn $116.25/h; R3≥11; R2ay~66/80 |
| 2026-08-11T19:09Z | p2076: R7 uploader+fleet-boot (pid2210763); top250 Reason data; B300×8=0; burn $116.25/h; R3≥8; R2ay~61/80 |
| 2026-08-11T19:07Z | p2075: R6 uploader+fleet-boot (pid2205764); data n=202 z≤180; B300×8=0; burn $116.25/h; R3≥6; R2ay~54/80 |
