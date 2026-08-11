# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | 2026-08-12T08:42Z | R2ay done; R2az n80 ~4/80 |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | 2026-08-12T16:29Z | GRPO pid28660 step≥20 + TK + wedge-watch |
| *(pending fleet)* | mine-r4…r10 | 8×B300 | ~$64 | rent pid2146782 + boot pid**2247190** | R4–R9+R3b+R4b auto-boot; R5b+ stamp-only |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Host R3 wedge: pid**2176107** `experiments/r3-reason-grpo/watch_r3_wedge.sh`

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-11T19:21Z | p2080: R4b uploader+fleet-boot (pid2247190); R2az~4/80; R3≥20; B300×8=0; burn $116.25/h |
| 2026-08-11T19:18Z | p2079: R9 uploader+fleet-boot (pid2240518); R2ay m=+0.0093; R2az n80; B300×8=0; burn $116.25/h |
| 2026-08-11T19:14Z | p2078: R3b uploader+fleet-boot (pid2228441); B300×8=0; burn $116.25/h; R3≥13; R2ay~77/80 |
