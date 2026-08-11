# R13 — Offline DPO on teacher-Reason duel prefs

## Axis
Frozen preference pairs: **chosen** = higher duel Reason thought,
**rejected** = lower. Train Tok-init LoRA with classic DPO
(`−log σ(β·((lp_c−ref_c)−(lp_r−ref_r)))`) — **no live teacher sampling**
during train.

Loss class ≠ R3 GRPO, ≠ R8 REINFORCE, ≠ R11 **online** DPO, ≠ R12 BoN-CE.
S\* H138/F43 used the same pairs under Λ2 naming; Reason = Λ2 so the
labels transfer. Never got a gateless Reason-v3 n80 under live kσ=2.

## Method
Tok af10 init · LoRA r=16/α32 · lr=5e-6 · β=0.1 · max_steps=200
· data `dpo_duel_reason.jsonl` (604 pairs, mean gap≈0.125)
· train GPUs 6–7 · teacher DL+serve in parallel for post_train n80.
Stack = H138 `train_dpo.py` + R13 start/bootstrap overlays.

## Pod
`mine-r13-odpo-1` via fleet-rent (queue after R12). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2086).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r13_pipeline.nohup` / `h138_train.nohup`.
