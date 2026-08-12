# INVENTORY — live mine-* pods

**Cap: 40 lines.** Live table + last 3 reconciles. Older → `archive/`.

## Live

| name | huid | config | $/h | TTL | role |
|---|---|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd (`3d07e519-…`) | 8×B200 | $52.25 | **2026-08-13T02:35Z** | **R17** coder-REINFORCE |
| mine-r3-grpo-1 | golden-hawk-ff (`d55eec0f-…`) | 8×B300 | $64.00 | **2026-08-13T04:29Z** | **R15** merge→n80 pid**78627** |
| mine-r4-fullft-1 | noble-orbit-9d (`70f95aab-…`) | 8×B300 | $64.00 | **2026-08-13T08:57Z** | **R20** kevin-GRPO |
| *(pending fleet)* | mine-r24…r32 + R5b/R18… | 8×B300 | ~$64 | rent POST + boot **2756348** | R24 first |

SSH crown/R17: `ssh root@95.133.253.90 -p 40099`
SSH R3/R15: `ssh root@204.9.206.245 -p 40051`
SSH R4/R20: `ssh root@86.38.182.50 -p 40307`
Host hist bridge: pid**3174953** (+chal-00525)
Host fleet-rent: pid**3373328** (CONT; next=R24)
Host fleet-burst: pid**3465495** (p2199 SKIP_PID_LOCK)
Host fleet-boot: pid**2756348**

Non-mine (do not touch): `affine-eval`, `affine-bench`, `affine-datagen`.

## Last reconciles

| when | action |
|---|---|
| 2026-08-12T07:28Z | p2200: R15 train DONE→merge abort (kevin BASE); pin pandora + relaunch post**78627**; 8×=0; burn **$180.25/h** |
| 2026-08-12T07:24Z | p2199: R20 empty-z fixed (GRPO cut@`</think>`0 + normalize); pid**126769**; burst CONT; 8×=0; burn **$180.25/h** |
| 2026-08-12T07:16Z | p2198: R3+R4 TTL +12h + Soft/Dead env; burst1081 empty→kill; waiter CONT; 8×=0; burn **$180.25/h** |
