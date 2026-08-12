# R10 — merge + Reason-GRPO hybrid

## Axis
α-merge **Tok af10 × sbs-v2** (0.5/0.5; Tok layout donor), then **Reason-GRPO**
LoRA on the merge as init. Structural hybrid: R2 = merge→n80 only; R3 =
Tok-init GRPO; R10 = merge init → GRPO. sbs-v2 is the best pure weak+ parent
(R2ay +0.0093 / hr_live2σ 1.02×).

## Pod
`mine-r10-merge-rl-1` via fleet-rent (**next** after p2223 Hub unblock). 8×B300
prefer. TTL 24h. Uploader: `upload_and_launch.sh` (fleet-boot case).

## Knobs
merge α=0.5/0.5 · GRPO lr=5e-6 r=16 G=4 max_steps=200 max_new=512 (same as R3
so the only axis change is the merge init).

## Decision
n80 vs live king **guass** (`ttttxxxxsada/Affine-5guassq3tu`); submit only if
hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r10_pipeline.nohup` / `r10_train.nohup`.
