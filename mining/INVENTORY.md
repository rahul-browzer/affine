# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ay n80 + R2az + v10 cached |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥6 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r10 | 8×B300 | ~$64 | rent pid2146782 + boot pid**2205764** | R4+R5+R6 auto-boot; R7+ stamp-only |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T19:07Z | p2075: R6 uploader+fleet-boot (pid2205764); data n=202 z≤180; B300×8=0; burn $116.25/h; R3≥6; R2ay~54/80 |
| 2026-08-11T19:04Z | p2074: R5 uploader+fleet-boot wire (pid2198447); B300×8=0; burn $116.25/h; R3≥5; R2ay~49/80 |
| 2026-08-11T19:01Z | p2073: R3 step1–2 OK (mean_r≈0.019→0.025); R2ay~38/80; B300×8=0; burn $116.25/h |
