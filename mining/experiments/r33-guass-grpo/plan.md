# R33 — guass-init Reason-GRPO

## Axis
**ttttxxxxsada/Affine-5guassq3tu** (live reign-6) init + LoRA-GRPO with reward =
Reason (`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R3 = Tok-init GRPO
- R19–R23 = other reign-parent GRPO
- R2bm = guass-as-challenger vs old ckp333 (no train)
R33 asks whether continuing GRPO from the *current* king clears the live crown bar
(real LoRA derivative — not a weight-identical copy).

## Method
guass @e86758f5 · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` · train GPUs 6–7 · teacher on 0–1
· n80 king = same guass rev · merge → n80 vs guass.
Stack = R3 `train_reason_grpo.py` + R33 start/bootstrap overlays.

## Pod
`mine-r33-guass-grpo-1` via fleet-rent (queue after R32). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2233).

## Decision
n80 vs guass; submit iff margin > live `k_sigma·SE` (k=2.0). No 1.5×.
Watch: `/root/logs/r33_pipeline.nohup` / `r3_train.nohup`.
