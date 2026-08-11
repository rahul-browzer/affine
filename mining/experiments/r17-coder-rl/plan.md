# R17 — Qwen3-Coder base + REINFORCE on teacher Reason

## Axis
Non-Albedo **`Qwen/Qwen3-Coder-30B-A3B-Instruct`** init + online REINFORCE with
reward = Reason (`lpC(y_C|z) − lpC(y_C|∅)`). Leaves the Affine/Albedo king
basin (≠ R5 Genesis, ≠ R5b Talent, ≠ R14–R16 earner RL, ≠ R3/R8 Tok RL).
Raw H142 screen was S\*v2-gate REFUTE; Reason v3 has no gates — train the
coder basin on teacher Reason instead of screening raw.

## Method
Coder @b2cff646 · LoRA r=16/α32 · lr=5e-6 · G=2 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · merge → n80 vs Tok.
Stack = H135 `train_rl_l2.py` + R17 start/bootstrap overlays (Coder DL).

## Pod
`mine-r17-coder-rl-1` via fleet-rent (queue after R16). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2091).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r17_pipeline.nohup` / `h135_train.nohup`.
