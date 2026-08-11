# R19 — TalentPigs-init Reason-GRPO

## Axis
**TalentPigs/affine-5ekxlcg3fx-abc** (reign-3) init + LoRA-GRPO with reward = Reason
(`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R3 = Tok-init GRPO
- R5b = Talent full-FT (no RL)
- R14 = kevin REINFORCE
- R18 = sbs-v2 GRPO
R19 asks whether the prior crowned parent, under the same GRPO stack, clears the live crown bar.

## Method
Talent @dbfbb3e2 · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · Tok king for n80 · merge → n80 vs Tok.
Stack = R3 `train_reason_grpo.py` + R19 start/bootstrap overlays (Talent DL).

## Pod
`mine-r19-talent-grpo-1` via fleet-rent (queue after R18). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2093).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r19_pipeline.nohup` / `r3_train.nohup`.
